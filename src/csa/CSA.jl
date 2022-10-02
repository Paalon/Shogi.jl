# Copyright 2021-12-14 Koki Fushimi

"""
    CSA::Module

Module for CSA kifu format.
See [CSA標準棋譜ファイル形式](http://www2.computer-shogi.org/protocol/record_v22.html) (Japanese) for the detail.
"""
module CSA

using Bijections

import Shogi: Sengo, Koma, Masu

export csa, SengoFromCSA, KomaFromCSA, MasuFromCSA

import Shogi: ☗, ☖
import ..歩兵, ..香車, ..桂馬, ..銀将, ..金将, ..角行, ..飛車, ..玉将, ..と金, ..成香, ..成桂, ..成銀, ..竜馬, ..竜王

const sente = ☗
const gote = ☖

mutable struct Parser
    root::Kifu
end
function Parser(str::String)
end
Parser() = Parser("")
Parser(io::IO) = Parser(read(io, String))

function parse(parser::Parser)::Kifu
    v = tryparse(parser)
    v isa ParserError && throw(v)
    v
end
parse(str::AbstractString) = parse(Parser(String(str)))
parse(io::IO) = parse(read(io, String))

function tryparse(parser::Parser)::Err{Kifu}
    while true
        # ///
    end
    parser.root
end

function parse_toplevel(parser::Parser)::Err{Nothing}
    # ...
end

@enum ErrorType begin
    ErrSengo
    ErrKoma
    ErrMasu
    ErrBanmen
    ErrKyokumen
    ErrMove
    ErrKifu
end

const err_message = Dict(
    ErrInvalidSengo => "invalid sengo",
    ErrInvalidKoma => "invalid koma name",
    ErrInvalidPosition => "invalid position numbers"
)

for err in instances(ErrorType)
    @assert haskey(err_message, err) "$err does not have an error message"
end

mutable struct ParserError <: Exception
    type::ErrorType
end

# Many functions return either a T or a ParserError
const Err{T} = Union{T,ParserError}

# Sengo

# Koma

const koma_to_csa = Bijection(Dict(
    歩兵 => "FU",
    香車 => "KY",
    桂馬 => "KE",
    銀将 => "GI",
    金将 => "KI",
    角行 => "KA",
    飛車 => "HI",
    玉将 => "OU",
    と金 => "TO",
    成香 => "NY",
    成桂 => "NK",
    成銀 => "NG",
    竜馬 => "UM",
    竜王 => "RY",
))

"""
    csa(koma::Koma)::String

Returns from Koma to CSA string.
"""
function csa(koma::Koma)
    koma_to_csa[koma]
end

"""
    KomaFromCSA(str::AbstractString)::Koma

Returns from CSA string to Koma.
"""
function KomaFromCSA(str::AbstractString)
    koma_to_csa(str)
end

# Masu

function _masu_to_csa(masu::Masu)
    if isempty(masu)
        " * "
    else
        sengo = Sengo(masu)
        koma = Koma(masu)
        csa(sengo) * csa(koma)
    end
end

"""
    masu_to_csa::Bijection{Masu, String}

The bijection from Masu to CSA string.
"""
const masu_to_csa = let
    ret = Dict()
    for masu in instances(Masu)
        ret[masu] = _masu_to_csa(masu)
    end
    ret
end |> Bijection

"""
    csa(masu::Masu)::String

Convert masu to CSA string.
"""
function csa(masu::Masu)
    masu_to_csa[masu]
end

"""
    MasuFromCSA(str::AbstractString)::Masu

Convert CSA string to masu.
"""
function MasuFromCSA(str::AbstractString)
    masu_to_csa(str)
end

# Banmen

export csa, BanmenEmptyCSA, BanmenHirateCSA, BanmenFromCSA

import ..Banmen

"""
    BanmenEmptyCSA::String

CSA string for the empty banmen.
"""
const BanmenEmptyCSA = """
P1 *  *  *  *  *  *  *  *  * 
P2 *  *  *  *  *  *  *  *  * 
P3 *  *  *  *  *  *  *  *  * 
P4 *  *  *  *  *  *  *  *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  *  *  * 
P7 *  *  *  *  *  *  *  *  * 
P8 *  *  *  *  *  *  *  *  * 
P9 *  *  *  *  *  *  *  *  * 
"""

"""
    BanmenHirateCSA::String

CSA string for the hirate banmen.
"""
const BanmenHirateCSA = """
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  * -KA * 
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  *  *  * 
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
"""

function csa(banmen::Banmen)
    ret = ""
    for j = 1:9
        ret *= "P$j"
        for i = 9:-1:1
            ret *= csa(banmen[i, j])
        end
        ret *= "\n"
    end
    ret
end

function BanmenFromCSA(str::AbstractString)
    banmen = Banmen()
    lines = split(str, "\n")
    for (i, line) in enumerate(lines[1:9])
        line[1] == 'P' || error()
        string(line[2]) == string(i) || error()
        for j = 1:9
            index = 3(j-1)+3:3(j-1)+5
            banmen[10-j, i] = MasuFromCSA(line[index])
        end
    end
    banmen
end

# Kyokumen

export csa, KyokumenFromCSA, KyokumenHirateCSA

import ..Kyokumen

"""
    KyokumenHirateCSA::String

CSA string for the hirate kyokumen.
"""
const KyokumenHirateCSA = """
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  * -KA * 
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  *  *  * 
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
+
"""

function csa(kyokumen::Kyokumen)
    ret = ""
    ret *= csa(kyokumen.banmen)
    if !isempty(kyokumen.mochigoma.sente)
        ret *= "P+"
        ret *= csa(kyokumen.mochigoma.sente)
        ret *= "\n"
    end
    if !isempty(kyokumen.mochigoma.gote)
        ret *= "P-"
        ret *= csa(kyokumen.mochigoma.gote)
        ret *= "\n"
    end
    ret *= csa(kyokumen.teban)
    ret *= "\n"
end

function KyokumenFromCSA(str::AbstractString)
    kyokumen = Kyokumen()
    lines = split(str, "\n")
    for line in lines
        if length(line) ≥ 2 && line[1:2] == "PI"
            # 2.5 (1)
            kyokumen.banmen = BanmenHirate()
            n = length(line) - 2
            if n > 0
                komaochi_str = lines[3:end]
                komaochi_n = Int(n / 4)
                for i = 1:komaochi_n
                    komaochi = komaochi_str[4(i-1)+1:4(i-1)+1+4]
                    x = parse(Int, komaochi[1])
                    y = parse(Int, komaochi[2])
                    koma = KomaFromCSA(komaochi[3:4])
                    masu = kyokumen[x, y]
                    Koma(masu) == koma || error("Does not match between the specified masu and koma.")
                    kyokumen[x, y] == 〼
                end
            end
        elseif length(line) ≥ 2
            line[1] == 'P' && isdigit(line[2]) && line[2] ≠ '0'
            # 2.5 (2)
            n = parse(Int, line[2])
            str = line[3:end]
            for i = 1:9
                masu = MasuFromCSA(str[3i-2:3i])
                kyokumen[10-i, n] = masu
            end
        elseif length(line) ≥ 2 && line[1] == 'P' && (line[2] == '+' || line[2] == '-')
            n = length(line) - 2
            sengo = SengoFromCSA(line[2])
            if n > 0
                str = line[3:end]
                k = length(str)
                koma_n = Int(k / 4)
                for i = 1:koma_n
                    s = str[4i-3:4i]
                    x, y = parse(Int, s[1]), parse(Int, s[2])
                    if s[3, 4] == "AL"
                        # add 残り without OU
                        x = remaining_koma_omote(kyokumen)
                        if issente(sengo)
                            kyokumen.mochigoma.sente.matrix[2:8] += x[2:8]
                        else
                            kyokumen.mochigoma.gote.matrix[2:8] += x[2:8]
                        end
                    else
                        koma = KomaFromCSA(s[3, 4])
                        if x == 0 && y == 0
                            if issente(sengo)
                                kyokumen.mochigoma.sente[koma] += 1
                            else
                                kyokumen.mochigoma.gote[koma] += 1
                            end
                        else
                            kyokumen[x, y] = Masu(koma, sengo)
                        end
                    end
                end
            end
        elseif length(line) == 1 && (line[1] == '+' || line[1] == '-')
            kyokumen.teban = SengoFromCSA(string(line[1]))
        end
    end
    kyokumen
end

# Move

export CSAMove
export next!, next

import ..KyokumenMove

abstract type CSAMove <: KyokumenMove end

struct CSAOnBoardMove <: CSAMove
    sengo::Sengo
    src::Tuple{Integer,Integer}
    dst::Tuple{Integer,Integer}
    koma::Koma
end

function Sengo(move::CSAMove)
    move.sengo
end

struct CSADrop <: CSAMove
    sengo::Sengo
    dst::Tuple{Integer,Integer}
    koma::Koma
end

function CSAMove(str::AbstractString)
    sengo = SengoFromCSA(string(str[1]))
    src = int_to_hankaku(str[2]), int_to_hankaku(str[3])
    dst = int_to_hankaku(str[4]), int_to_hankaku(str[5])
    koma = KomaFromCSA(str[6:7])
    if src == (0, 0)
        CSADrop(sengo, dst, koma)
    else
        CSAOnBoardMove(sengo, src, dst, koma)
    end
end

function next!(kyokumen::Kyokumen, move::CSAOnBoardMove)
    Sengo(kyokumen) == move.sengo || error("手番が一致しない。")
    sengo = move.sengo
    Sengo(kyokumen[move.dst...]) ≠ sengo || error("移動先に自分の駒がある。")
    src_koma = Koma(kyokumen[move.src...])
    dst_koma = move.koma
    src_koma == dst_koma ||
        (naru(src_koma) == dst_koma && ispromotable(sengo, src_koma, move.src, move.dst)) ||
        error("移動前と移動後で駒の種類が成・不成を含めても一致しない。")
    if kyokumen[move.dst...] ≠ 〼
        dst_enemy_koma = Koma(kyokumen[move.dst...])
        gettebanmochigoma(kyokumen)[dst_enemy_koma] += 1
    end
    kyokumen[move.dst...] = Masu(sengo, dst_koma)
    kyokumen[move.src...] = 〼
    kyokumen.teban = next(kyokumen.teban)
    kyokumen
end

function next!(kyokumen::Kyokumen, move::CSADrop)
    Sengo(kyokumen) == move.sengo || error("手番が一致しない。")
    sengo = move.sengo
    kyokumen[move.dst...] == 〼 || error("移動先が空きマスでない。")
    gettebanmochigoma(kyokumen)[move.koma] ≥ 1 || error("打ちたい駒を持っていない。")
    kyokumen[move.dst...] = Masu(sengo, move.koma)
    gettebanmochigoma(kyokumen)[move.koma] -= 1
    kyokumen.teban = next(sengo)
    kyokumen
end

function next(kyokumen::Kyokumen, move::CSAMove)
    kyokumen = copy(kyokumen)
    next!(kyokumen, move)
end

# Kifu

export KifuFromCSA

"""
    KifuFromCSA(filename::AbstractString)

Returns kifu from CSA string.
"""
function KifuFromCSA(filename::AbstractString)
    kyokumen = Kyokumen()
    moves = CSAMove[]
    open(filename, "r") do io
        while !eof(io)
            str = readline(io)
            if length(str) ≥ 1
                char = str[1]
                if char == '''
                elseif char == 'V'
                elseif char == 'N'
                    # @info "対局者情報は読み飛ばされます。"
                elseif char == '$'
                    # @info "各種棋譜情報は読み飛ばされます。"
                elseif char == '%'
                    if str == "%TORYO"
                    end
                elseif char == '+'
                    if length(str) == 1
                        kyokumen.teban == ☗
                    else
                        push!(moves, CSAMove(str))
                    end
                elseif char == '-'
                    if length(str) == 1
                        kyokumen.teban == ☖
                    else
                        push!(moves, CSAMove(str))
                    end
                elseif char == 'T'
                elseif char == 'P'
                    n = parse(Int, str[2])
                    for k = 1:9
                        kyokumen[10-k, n] = MasuFromCSA(str[3k:3k+2])
                    end
                end
            end
        end
    end
    Kifu(kyokumen, moves)
end

function csa(kifu::Kifu)::String
end

function print(io::IO, data::Kifu)
    
end

end # module CSA

# function next_from_csa!(kyokumen::Kyokumen, str::AbstractString)
#     # check length
#     length(str) == 7 || error("Invalid length")
#     # check teban
#     teban = SengoFromCSA(string(str[1]))
#     kyokumen.teban == teban || error("Invalid teban")
#     # parse coordinate
#     from_x = parse(Int, str[2])
#     from_y = parse(Int, str[3])
#     to_x = parse(Int, str[4])
#     to_y = parse(Int, str[5])
#     to_koma = KomaFromCSA(str[6:7])
#     if from_x == 0 && from_y == 0
#         kyokumen[to_x, to_y] = Masu(to_koma, kyokumen.teban)
#         teban_mochigoma(kyokumen)[to_koma] -= 1
#     else
#         to_koma_prev = Koma(kyokumen[to_x, to_y])
#         if !isnothing(to_koma_prev)
#             teban_mochigoma(kyokumen)[omote(to_koma_prev)] += 1
#         end
#         kyokumen[from_x, from_y] = 〼
#         kyokumen[to_x, to_y] = to_koma
#     end
#     kyokumen.teban = next(kyokumen.teban)
#     kyokumen
# end

# """
#     next_from_csa(kyokumen::Kyokumen, str::AbstractString)

# Construct the next kyokumen from current kyokumen `kyokumen` and CSA move string `str`.
# """
# function next_from_csa(kyokumen::Kyokumen, str::AbstractString)
#     kyokumen = copy(kyokumen)
#     next_from_csa!(kyokumen, str)
# end

# function parse_char_to_int(char::AbstractChar)
#     parse(Int, string(char))
# end

# function MoveFromCSA(kyokumen::Kyokumen, str::AbstractString)
#     length(str) == 5 || error("Invalid CSA move string: $str")
#     sengo = SengoFromCSA(str[1])
#     x0_char, y0_char, x1_char, y1_char = str[2:5]
#     koma = KomaFromCSA(str[6:7])
#     if x0_char == '0' && y0_char == '0'
#         x1, y1 = parse_char_to_int.((x0_char, y0_char))
#         Drop(x1, y1, koma)
#     else
#         x0, y0, x1, y1 = parse_char_to_int.((x0_char, y0_char, x1_char, y1_char))
#         koma0 = Koma(kyokumen[x0, y0])
#         if ispromotable(koma0) && naru(koma0) == koma
#             Move(x0, y0, x1, y1, true)
#         else
#             Move(x0, y0, x1, y1, false)
#         end
#     end
# end

# function MoveDictFromCSA(str::AbstractString)
#     n = length(str)
#     n == 7 || error()
#     sengo = SengoFromCSA(str[1])
#     if str[2:3] == "00"
#         # drop
#         x = int_to_hankaku(str[4])
#         y = int_to_hankaku(str[5])
#         koma = KomaFromCSA(str[6:7])
#         Dict(
#             :teban => sengo,
#             :dst => (x, y),
#             :dst_koma => koma,
#             :motion => [打],
#         )
#     else
#         # not drop
#         x_src = int_to_hankaku(str[2])
#         y_src = int_to_hankaku(str[3])
#         x_dst = int_to_hankaku(str[4])
#         y_dst = int_to_hankaku(str[5])
#         koma = KomaFromCSA(str[6:7])
#         Dict(
#             :teban => sengo,
#             :src => (x_src, y_src),
#             :dst => (x_dst, y_dst),
#             :dst_koma => koma,
#             :motion => [非打],
#         )
#     end
# end

# function csa(kyokumen::Kyokumen, move::Move)
#     x0, y0 = from(move)
#     x1, y1 = to(move)
#     koma = Koma(kyokumen, move)
#     koma = ifelse(move.ispromotion, naru(koma), koma)
#     koma_str = csa(koma)
#     teban_str = csa(kyokumen.teban)
#     "$teban_str$x0$y0$x1$y1$koma_str"
# end

# function csa(::Kyokumen, drop::Drop)
#     x0, y0 = 0, 0
#     x1, y1 = to(drop)
#     koma = Koma(drop)
#     koma_str = csa(koma)
#     teban_str = csa(kyokumen.teban)
#     "$teban_str$x0$y0$x1$y1$koma_str"
# end

# str = """
# V2.2
# N+<先手の対局者名> / optional
# N-<後手の対局者名> / optional
# $<keyword>:(<data>) / optional
# FU
# KY
# KE
# GI
# KKI"""
