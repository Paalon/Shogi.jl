# Copyright 2021-12-14 Koki Fushimi

export csa
export SengoFromCSA
export KomaFromCSA
export MasuFromCSA
export BanmenEmptyCSA, BanmenHirateCSA
export BanmenFromCSA
# export KyokumenFromCSA
# export MoveFromCSA

export NextKyokumenFromCSA

using Bijections

const sengo_to_csa = Bijection(Dict(先手 => "+", 後手 => "-"))

function csa(sengo::Sengo)
    sengo_to_csa[sengo]
end

function SengoFromCSA(str::AbstractString)
    sengo_to_csa(str)
end

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

function csa(koma::Koma)
    koma_to_csa[koma]
end

function KomaFromCSA(str::AbstractString)
    koma_to_csa(str)
end

function _masu_to_csa(masu::Masu)
    if isempty(masu)
        " * "
    else
        sengo = Sengo(masu)
        koma = Koma(masu)
        csa(sengo) * csa(koma)
    end
end

const masu_to_csa = let
    ret = Dict()
    for masu in instances(Masu)
        ret[masu] = _masu_to_csa(masu)
    end
    ret
end |> Bijection

function csa(masu::Masu)
    masu_to_csa[masu]
end

function MasuFromCSA(str::AbstractString)
    masu_to_csa(str)
end

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

function NextKyokumenFromCSA(kyokumen::Kyokumen, str::AbstractString)
    kyokumen = copy(kyokumen)
    # check length
    length(str) == 7 || error("Invalid length")
    # check teban
    teban = SengoFromCSA(string(str[1]))
    kyokumen.teban == teban || error("Invalid teban")
    # parse coordinate
    from_x = parse(Int, str[2])
    from_y = parse(Int, str[3])
    to_x = parse(Int, str[4])
    to_y = parse(Int, str[5])
    to_koma = KomaFromCSA(str[6:7])
    if from_x == 0 && from_y == 0
        kyokumen[to_x, to_y] = Masu(to_koma, kyokumen.teban)
        teban_mochigoma(kyokumen)[to_koma] -= 1
    else
        to_koma_prev = Koma(kyokumen[to_x, to_y])
        if !isnothing(to_koma_prev)
            teban_mochigoma(kyokumen)[omote(to_koma_prev)] += 1
        end
        kyokumen[from_x, from_y] = 〼
        kyokumen[to_x, to_y] = to_koma
    end
    kyokumen.teban = next(kyokumen.teban)
    kyokumen
end

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

# function KifuFromCSA(filename::AbstractString)
#     open(filename, "r") do io
#         while !eof(io)
#             char = read(io, Char)
#             # コメント
#             if char == '''
#                 _ = readuntil(io, '\n')
#             elseif char == 'V'
#                 version = readuntil(io, '\n')
#                 # 対局者名
#             elseif char == 'N'
#                 char = read(io, Char)
#                 if char == '+'
#                     先手の対局者名 = readuntil(io, '\n')
#                 elseif char == '-'
#                     後手の対局者名 = readuntil(io, '\n')
#                 else
#                     @warn "対局者名の指定が変です。"
#                     _ = readuntil(io, '\n')
#                 end
#             elseif char == '$'
#                 @info "各種棋譜情報は読み飛ばされます。"
#                 _ = readuntil(io, '\n')
#             elseif char == '%'
#             elseif char == '+'
#                 kyokumen = Kyokumen()
#             elseif char == '-'
#                 kyokumen = Kyokumen()
#             elseif char == 'T'
#                 @info "持ち時間は読み飛ばされます。"
#             elseif char == 'P'
#                 char = read(io, Char)
#                 n = parse(Int, char)

#             end
#         end
#     end
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
