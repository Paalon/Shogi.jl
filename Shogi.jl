module Shogi

export Sengo, Tesuu, KomaOmote, Masu, Banmen, Mochigoma, Kyokumen
export sfen, move!

import Base:
    string, ==, copy, sign, -, show, getindex, setindex!, isempty, abs

# Utilities

keyvalueswap(dict::Dict) = Dict(value => key for (key, value) in dict)

# 先後

struct Sengo
    bool::Bool
end

function Base.show(io::IO, sengo::Sengo)
    if sengo.bool
        print(io, "☗")
    else
        print(io, "☖")
    end
end

function Sengo(str::AbstractString)
    if str == "b"
        Sengo(true)
    elseif str == "w"
        Sengo(false)
    else
        error("Invalid string: $str")
    end
end

Sengo(char::AbstractChar) = Sengo(string(char))

sfen(sengo::Sengo) = ifelse(sengo.bool, "b", "w")

next(sengo::Sengo) = Sengo(!sengo.bool)

sign(sengo::Sengo) = ifelse(sengo.bool, 1, -1)

issente(sengo::Sengo) = sengo.bool

istekijin(sengo::Sengo, y::Int8) = (issente(sengo) && 1 ≤ y ≤ 3) || (!issente(sengo) && 7 ≤ y ≤ 9)
istekijin(sengo::Sengo, ::Int8, y::Int8) = istekijin(sengo, y)

# SFEN 手数

struct Tesuu
    n::Int64
end

function Tesuu(str::AbstractString)
    n = tryparse(Int64, str)
    if isnothing(n)
        error("Invalid string: $str")
    end
    Tesuu(n)
end

Tesuu(char::AbstractChar) = Tesuu(string(char))

sfen(tesuu::Tesuu) = string(tesuu.n)

next(tesuu::Tesuu) = Tesuu(tesuu.n + 1)

# 駒表

struct KomaOmote
    n::Int8
end

const dict_sfen_to_koma_omote = Dict(
    "K" => KomaOmote(1),
    "R" => KomaOmote(2),
    "B" => KomaOmote(3),
    "G" => KomaOmote(4),
    "S" => KomaOmote(5),
    "N" => KomaOmote(6),
    "L" => KomaOmote(7),
    "P" => KomaOmote(8),
)

const dict_koma_omote_to_sfen = keyvalueswap(dict_sfen_to_koma_omote)

KomaOmote(str::AbstractString) = dict_sfen_to_koma_omote[str]
KomaOmote(char::AbstractChar) = KomaOmote(string(char))

sfen(koma_omote::KomaOmote) = dict_koma_omote_to_sfen[koma_omote]

const dict_koma_omote_to_komachar1 = Dict(
    KomaOmote(1) => "玉",
    KomaOmote(2) => "飛",
    KomaOmote(3) => "角",
    KomaOmote(4) => "金",
    KomaOmote(5) => "銀",
    KomaOmote(6) => "桂",
    KomaOmote(7) => "香",
    KomaOmote(8) => "歩",
)

komachar1(koma_omote::KomaOmote) = dict_koma_omote_to_komachar1[koma_omote]

isfu(koma_omote::KomaOmote) = koma_omote.n == 8

# マス

struct Masu
    n::Int8
end

function Sengo(masu::Masu)
    if masu.n > 0
        Sengo(true)
    elseif masu.n < 0
        Sengo(false)
    end
end

function Base.:(-)(masu::Masu)
    Masu(-masu.n)
end

abs(masu::Masu) = Masu(abs(masu.n))

const dict_sfen_to_masu = let
    d = Dict(
        "1" => Masu(0),
        "K" => Masu(2),
        "R" => Masu(4),
        "B" => Masu(6),
        "G" => Masu(8),
        "S" => Masu(10),
        "N" => Masu(12),
        "L" => Masu(14),
        "P" => Masu(16),
        "+R" => Masu(5),
        "+B" => Masu(7),
        "+S" => Masu(11),
        "+N" => Masu(13),
        "+L" => Masu(15),
        "+P" => Masu(17),
    )
    ks = collect(keys(d))
    for key in ks
        d[lowercase(key)] = -d[key]
    end
    d
end

const dict_masu_to_sfen = keyvalueswap(dict_sfen_to_masu)

Masu(str::AbstractString) = dict_sfen_to_masu[str]
Masu(char::AbstractChar) = Masu(string(char))

function masu_to_sign_string(masu::Masu)
    if masu.n > 0
        "+"
    elseif masu.n < 0
        "-"
    else
        " "
    end
end

const dict_masu_to_masuchar2 = let
    dict = Dict(Masu(0) => " ・")
    base_dict = Dict(
        Masu(2) => "玉",
        Masu(4) => "飛",
        Masu(5) => "龍",
        Masu(6) => "角",
        Masu(7) => "馬",
        Masu(8) => "金",
        Masu(10) => "銀",
        Masu(11) => "全",
        Masu(12) => "桂",
        Masu(13) => "圭",
        Masu(14) => "香",
        Masu(15) => "杏",
        Masu(16) => "歩",
        Masu(17) => "と",
    )
    base_dict_keys = collect(keys(base_dict))
    for key in base_dict_keys
        komachar1 = base_dict[key]
        dict[key] = "+$komachar1"
        dict[-key] = "-$komachar1"
    end
    dict
end

function masuchar2(masu::Masu)
    dict_masu_to_masuchar2[masu]
end

function Base.show(io::IO, masu::Masu)
    print(io, masuchar2(masu))
end

sfen(masu::Masu) = dict_masu_to_sfen[masu]

function naru(masu::Masu)
    n = masu.n
    Masu(n + sign(n))
end

function rotate(masu::Masu)
    n = masu.masu
    Masu(-n)
end

function KomaOmote(masu::Masu)
    KomaOmote(abs(masu.n) ÷ 2)
end

function Masu(koma_omote::KomaOmote, sengo::Sengo)
    Masu(sign(sengo) * 2koma_omote.n)
end

isempty(masu::Masu) = masu.n == 0

# 持ち駒

mutable struct Mochigoma
    komasuus::Vector{Int8}
end

function Mochigoma()
    Mochigoma(zeros(Int8, 8))
end

function sfen(koma_omote::KomaOmote, komasuu::Integer)
    if komasuu == 0
        ""
    elseif komasuu == 1
        sfen(koma_omote)
    else
        "$komasuu$(sfen(koma_omote))"
    end
end

function sfen(mochigoma::Mochigoma)
    ret = ""
    for (i, komasuu) in enumerate(mochigoma.komasuus)
        ret *= sfen(KomaOmote(i), komasuu)
    end
    ret
end

function Mochigoma(str::AbstractString)
    mochigoma = Mochigoma()
    iter_res = iterate(str)
    while !isnothing(iter_res)
        char, stat = iter_res
        if isnumeric(char)
            n = parse(Int8, string(char))
            char, stat = iterate(str, stat)
            mochigoma.komasuus[KomaOmote(char).n] = n
        else
            n = 1
            mochigoma.komasuus[KomaOmote(char).n] = n
        end
        iter_res = iterate(str, stat)
    end
    mochigoma
end

function Base.show(io::IO, mochigoma::Mochigoma)
    for (i, komasuu) in enumerate(mochigoma.komasuus)
        if komasuu == 0
        elseif komasuu == 1
            print(io, komachar1(KomaOmote(i)))
        else
            print(io, "$(komachar1(KomaOmote(i)))$komasuu")
        end
    end
end

function increment!(mochigoma::Mochigoma, koma_omote::KomaOmote)
    mochigoma.komasuus[koma_omote.n] += 1
    mochigoma
end

function decrement!(mochigoma::Mochigoma, koma_omote::KomaOmote)
    mochigoma.komasuus[koma_omote.n] -= 1
    mochigoma
end

function getindex(mochigoma::Mochigoma, koma_omote::KomaOmote)
    mochigoma.komasuus[koma_omote.n]
end

function setindex!(mochigoma::Mochigoma, n::Integer, koma_omote::KomaOmote)
    mochigoma.komasuus[koma_omote.n] = n
end

# 盤面

mutable struct Banmen
    matrix::Matrix{Int8}
end

function getindex(banmen::Banmen, i, j)
    Masu(banmen.matrix[i, j])
end

function setindex!(banmen::Banmen, masu::Masu, i, j)
    banmen.matrix[i, j] = masu.n
end

function Base.show(io::IO, banmen::Banmen)
    for i = 1:9
        for j = 1:9
            n = banmen.matrix[10-j, i]
            print(io, Masu(n))
        end
        print(io, "\n")
    end
end

function Banmen(str::AbstractString)
    matrix = zeros(Int8, 9, 9)
    iter_res = iterate(str)
    i = 1
    j = 1
    while !isnothing(iter_res)
        char, stat = iter_res
        if isnumeric(char)
            n = parse(Int8, char)
            for _ = 1:n
                matrix[10-j, i] = Int8(0)
                j += 1
            end
        elseif char == '/'
            i += 1
            j = 1
        elseif char == '+'
            char, stat = iterate(str, stat)
            matrix[10-j, i] = Masu("+$char").n
            j += 1
        else
            matrix[10-j, i] = Masu(char).n
            j += 1
        end
        iter_res = iterate(str, stat)
    end
    Banmen(matrix)
end

function sfen(banmen::Banmen)
    ret = ""
    for i = 1:9
        for j = 1:9
            n = banmen.matrix[10-j, i]
            ret *= sfen(Masu(n))
        end
        if i != 9
            ret *= "/"
        end
    end
    ret = replace(ret, "111111111" => "9")
    ret = replace(ret, "11111111" => "8")
    ret = replace(ret, "1111111" => "7")
    ret = replace(ret, "111111" => "6")
    ret = replace(ret, "11111" => "5")
    ret = replace(ret, "1111" => "4")
    ret = replace(ret, "111" => "3")
    ret = replace(ret, "11" => "2")
    ret
end

function Banmen()
    Banmen("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL")
end

# 局面

mutable struct Kyokumen
    banmen::Banmen
    mochigoma_sente::Mochigoma
    mochigoma_gote::Mochigoma
    teban::Sengo
    tesuu::Tesuu
end

function Kyokumen()
    Kyokumen(Banmen(), Mochigoma(), Mochigoma(), Sengo(true), Tesuu(1))
end

function Kyokumen(str::AbstractString)
    banmen_str, teban_str, mochigoma_str, tesuu_str = split(str, " ")
    banmen = Banmen(banmen_str)

    # begin parse mochigoma

    mochigoma_sente = Mochigoma()
    mochigoma_gote = Mochigoma()

    if mochigoma_str != "-"
        iter_res = iterate(mochigoma_str)
        while !isnothing(iter_res)
            s, stat = iter_res
            if isnumeric(s)
                n = parse(Int8, s)
                s, stat = iterate(mochigoma_str, stat)
                if islowercase(s)
                    mochigoma_gote[KomaOmote(uppercase(s))] = n
                else
                    mochigoma_sente[KomaOmote(s)] = n
                end
            else
                if islowercase(s)
                    mochigoma_gote[KomaOmote(uppercase(s))] = 1
                else
                    mochigoma_sente[KomaOmote(s)] = 1
                end
            end
            iter_res = iterate(mochigoma_str, stat)
        end
    end

    # end parse mochigoma

    teban = Sengo(teban_str)
    tesuu = Tesuu(tesuu_str)
    Kyokumen(banmen, mochigoma_sente, mochigoma_gote, teban, tesuu)
end

function Base.show(io::IO, kyokumen::Kyokumen)
    println(io, kyokumen.banmen)
    println(io, "先手持ち駒: ", kyokumen.mochigoma_sente)
    println(io, "後手持ち駒: ", kyokumen.mochigoma_gote)
    println(io, kyokumen.teban)
    println(io, "$(kyokumen.tesuu.n - 1) 手目")
end

function sfen(kyokumen::Kyokumen)
    banmen = sfen(kyokumen.banmen)
    mochigoma_sente = sfen(kyokumen.mochigoma_sente)
    mochigoma_gote = sfen(kyokumen.mochigoma_gote) |> lowercase
    mochigoma = "$mochigoma_sente$mochigoma_gote"
    if mochigoma == ""
        mochigoma = "-"
    end
    teban = sfen(kyokumen.teban)
    tesuu = sfen(kyokumen.tesuu)
    "$banmen $teban $mochigoma $tesuu"
end

function issente(kyokumen::Kyokumen)
    issente(kyokumen.teban)
end

function sign(kyokumen::Kyokumen)
    sign(kyokumen.teban)
end

function teban_mochigoma(kyokumen::Kyokumen)
    if issente(kyokumen)
        kyokumen.mochigoma_sente
    else
        kyokumen.mochigoma_gote
    end
end

function next!(kyokumen::Kyokumen)
    kyokumen.teban = next(kyokumen.teban)
    kyokumen.tesuu = next(kyokumen.tesuu)
    kyokumen
end

function capture!(kyokumen::Kyokumen, x::Integer, y::Integer)
    koma_omote = KomaOmote(abs(kyokumen.banmen[x, y]).n ÷ 2)
    if koma_omote.n == 0
        error("No koma in $x$y.")
    end
    if issente(kyokumen)
        increment!(kyokumen.mochigoma_sente, koma_omote)
    else
        increment!(kyokumen.mochigoma_gote, koma_omote)
    end
    kyokumen.banmen[x, y] = Masu(0)
    kyokumen
end

abstract type AbstractMove end

struct Move <: AbstractMove
    from_x::Int8
    from_y::Int8
    to_x::Int8
    to_y::Int8
    ispromote::Bool
end

const dict_123456789_int8_to_abcdefghi_char = let
    dict = Dict{Int8,Char}()
    abc = 'a':'i'
    for i = 1:9
        dict[i] = abc[i]
    end
    dict
end

const dict_abcdefghi_char_to_123456789_int8 = keyvalueswap(dict_123456789_int8_to_abcdefghi_char)

function Move(str::AbstractString)
    from_x = parse(Int8, string(str[1]))
    from_y = dict_abcdefghi_char_to_123456789_int8[str[2]]
    to_x = parse(Int8, string(str[3]))
    to_y = dict_abcdefghi_char_to_123456789_int8[str[4]]
    ispromote = length(str) == 5 && str[5] == '+'
    Move(from_x, from_y, to_x, to_y, ispromote)
end

struct Drop <: AbstractMove
    to_x::Int8
    to_y::Int8
    koma_omote::KomaOmote
end

function Drop(str::AbstractString)
    koma_omote = KomaOmote(str[1])
    to_x = parse(Int8, string(str[3]))
    to_y = dict_abcdefghi_char_to_123456789_int8[str[4]]
    Drop(to_x, to_y, koma_omote)
end

function AbstractMove(str::AbstractString)
    n = length(str)
    e = ErrorException("Invalid string $str")
    koma_omote_chars = ['K', 'R', 'B', 'G', 'S', 'N', 'L', 'P']
    # 不正な文字列はここで全て排除する。
    if 4 ≤ n ≤ 5
        if str[2] == '*'
            if str[1] in koma_omote_chars && str[3] in '1':'9' && str[4] in 'a':'i' && n == 4
                Drop(str)
            else
                throw(e)
            end
        else
            char_1_to_9 = '1':'9'
            char_a_to_i = 'a':'i'
            if str[1] in char_1_to_9 && str[3] in char_1_to_9 && str[2] in char_a_to_i && str[4] in char_a_to_i
                if n == 5
                    if str[5] == '+'
                        Move(str)
                    else
                        throw(e)
                    end
                else
                    Move(str)
                end
            else
                throw(e)
            end
        end
    else
        throw(e)
    end
end

function isikibanonaikoma(koma_omote::KomaOmote, sengo::Sengo, ::Int8, y::Int8)
    if koma_omote == KomaOmote(6)
        # 桂馬
        ((issente(sengo) && 1 ≤ y ≤ 2) || (issente(sengo) && 8 ≤ y ≤ 9))
    elseif koma_omote == KomaOmote(7) || koma_omote == KomaOmote(8)
        # 香車 or 歩兵
        ((issente(sengo) && y == 1) || (issente(sengo) && y == 9))
    else
        false
    end
end

function isnifu(banmen::Banmen, sengo::Sengo, x::Int8, ::Int8)
    for y = 1:9
        if banmen[x, y].n == sign(sengo) * 16
            return true
        end
    end
    false
end

# todo: 合法手チェック
# history-stateless requirement
# 成るならば敵陣を通過する ✔️
# 行き先に自分の駒がない ✔️
# 行き場のない駒にならない
# 通過する場所に駒がない
# 駒の基本的な動き方に違反しない
# history-stateful requirement
# 打ち歩詰めでない
# 連続王手の千日手でない
function move!(kyokumen::Kyokumen, move::Move)
    from_masu = kyokumen.banmen[move.from_x, move.from_y]
    to_masu = kyokumen.banmen[move.to_x, move.to_y]
    if move.ispromote
        if istekijin(kyokumen.teban, move.to_y) || istekijin(kyokumen.teban, from_y)
            from_masu = naru(from_masu)
        else
            error("敵陣を通らない場合は成れません。")
        end
    end
    to_masu_sengo = Sengo(to_masu)
    if isnothing(to_masu_sengo)
        # 行き先に駒がない
        # 移動する
        kyokumen.banmen[move.to_x, move.to_y] = from_masu
        kyokumen.banmen[move.from_x, move.from_y] = Masu(0)
    else
        teban = issente(kyokumen)
        to_koma_teban = issente(to_masu_sengo)
        if teban == to_koma_teban
            # 自分の駒がある
            error("自分の駒がある場所には移動できません。")
        else
            # 相手の駒がある
            # 相手の駒を取る
            capture!(kyokumen, move.to_x, move.to_y)
            # 移動する
            kyokumen.banmen[move.to_x, move.to_y] = from_masu
            kyokumen.banmen[move.from_x, move.from_y] = Masu(0)
        end
    end
    next!(kyokumen)
end

# todo: 合法手チェック
# history-stateless requirement
# 行き先に駒がない ✔️
# 行き場のない駒にならない ✔️
# 二歩にならない ✔️
# history-stateful requirement
# 打ち歩詰めでない
# 連続王手の千日手でない
function move!(kyokumen::Kyokumen, drop::Drop)
    mochigoma = teban_mochigoma(kyokumen)
    n = mochigoma[drop.koma_omote]
    if !(n ≥ 1)
        error("その駒は持っていないので、打てません。")
    end
    if !isempty(kyokumen.banmen[drop.to_x, drop.to_y])
        error("そこには駒が既にあるので、打てません。")
    end
    if isfu(drop.koma_omote) && isnifu(kyokumen.banmen, kyokumen.teban, drop.to_x, drop.to_y)
        error("二歩になるので、打てません。")
    end
    if isikibanonaikoma(drop.koma_omote, kyokumen.teban, drop.to_x, drop.to_y)
        error("行き場のない駒になるので、打てません。")
    end
    mochigoma[drop.koma_omote] = n - 1
    kyokumen.banmen[drop.to_x, drop.to_y] = Masu(drop.koma_omote, kyokumen.teban)
    next!(kyokumen)
end

function move!(kyokumen::Kyokumen, str::AbstractString)
    move!(kyokumen, AbstractMove(str))
end

# kyokumen = Kyokumen()
# # moves = "7g7f 3c3d 2g2f 8c8d 2f2e 8d8e 6i7h 4a3b 2e2d 2c2d 2h2d 8e8f 8g8f 8b8f 2d3d 2b8h+ 7i8h 8f7f"
# moves = "7g7f 3c3d 2g2f 8c8d 2f2e 8d8e 6i7h 4a3b 2e2d 2c2d 2h2d 8e8f 8g8f 8b8f 2d3d 2b8h+ 7i8h P*2h 3i2h B*4e 3d2d P*2c B*7g 8f8h+ 7g8h 2c2d 8h1a+"
# for move in split(moves, " ")
#     move!(kyokumen, move)
#     println(kyokumen |> sfen)
# end

# 手

# function Move(str::AbstractString)
#     4 <= length(str) <= 5 || error("Invalid SFEN move string length: $str")
#     if str[2] !== '*'
#         from_x = tryparse(Int, string(str[1]))
#         if isnothing(from_x)
#             throw(ErrorException("Invalid SFEN move string in from_x: $str"))
#         end
#         to_x = tryparse(Int, string(str[3]))
#         if isnothing(to_x)
#             throw(ErrorException("Invalid SFEN move string in to_x: $str"))
#         end
#         ispromoting = length(str) == 5 && str[5] == '+'
#         try
#             from_y = sfen_move_to_int(str[2])
#             to_y = sfen_move_to_int(str[4])
#             Dict(
#                 :type => "move",
#                 :from_x => from_x,
#                 :from_y => from_y,
#                 :to_x => to_x,
#                 :to_y => to_y,
#                 :ispromoting => ispromoting
#             )
#         catch _
#             throw(ErrorException("Invalid SFEN move string in: $str"))
#         end
#     else
#         # 打
#         koma = sfen_masu_to_int8(str[1])
#         to_x = tryparse(Int, string(str[3]))
#         if isnothing(to_x)
#             throw(ErrorException("Invalid SFEN move string: $str"))
#         end
#         try
#             to_y = sfen_move_to_int(str[4])
#             Dict(
#                 :type => "drop",
#                 :koma => koma,
#                 :x => to_x,
#                 :y => to_y,
#             )
#         catch _
#             throw(ErrorException("Invalid SFEN move string: $str"))
#         end
#     end
# end

# # to_x to_y koma_omote 打
# function Drop(to_x::Int8, to_y::Int8, koma_omote::KomaOmote)
#     Move(nothing, nothing, to_x, to_y, Koma(koma_omote), false, true)
# end

# function Move(from_x::Int8, from_y::Int8, to_x::Int8, to_y::Int8,) end

# function move!(kyokumen::Kyokumen, move::Move)

#     next!(kyokumen)
# end

# # todo

# const dict_sfen_to_2_chars = Dict(
#     "K" => "玉将",
#     "R" => "飛車",
#     "+R" => "龍王",
#     "B" => "角行",
#     "+B" => "龍馬",
#     "G" => "金将",
#     "S" => "銀将",
#     "+S" => "成銀",
#     "N" => "桂馬",
#     "+N" => "成桂",
#     "L" => "香車",
#     "L+" => "成香",
#     "P" => "歩兵",
#     "+P" => "と金",
# )

end # module