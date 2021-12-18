module Shogi

export Sengo, Tesuu, KomaOmote, Masu, Banmen, Mochigoma, Kyokumen
export sfen, move!

import Base:
    string, ==, copy, sign, -, show, getindex, setindex!, isempty, abs


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

# マス

struct Masu
    n::Int8
end

function Base.:(-)(masu::Masu)
    Masu(-masu.n)
end

abs(masu::Masu) = Masu(abs(masu.n))

function naru(masu::Masu)
    n = masu.n
    Masu(n + sign(n))
end

function rotate(masu::Masu)
    n = masu.masu
    Masu(-n)
end

# 局面

function issente(kyokumen::Kyokumen)
    issente(kyokumen.teban)
end

function sign(kyokumen::Kyokumen)
    sign(kyokumen.teban)
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

end # module