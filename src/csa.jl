# Copyright 2021-12-14 Koki Fushimi

export csa
export SengoFromCSA
export KomaFromCSA
export MasuFromCSA
export BanmenEmptyCSA, BanmenHirateCSA
export BanmenFromCSA
export KyokumenHirateCSA
export KyokumenFromCSA
# export MoveFromCSA

export next_from_csa, next_from_csa!

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
        elseif length(line) ≥ 2 line[1] == 'P' && isdigit(line[2]) && line[2] ≠ '0'
            # 2.5 (2)
            n = parse(Int, line[2])
            str = line[3:end]
            for i = 1:9
                masu = MasuFromCSA(str[3i-2:3i])
                kyokumen[10 - i, n] = masu
            end
        elseif length(line) ≥ 2 && line[1] == 'P' && (line[2] == '+' || line[2] == '-')
            n = length(line) - 2
            sengo = SengoFromCSA(line[2])
            if n > 0
                str = line[3:end]
                k = length(str)
                koma_n = Int(k / 4)
                for i in 1:koma_n
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

function next_from_csa!(kyokumen::Kyokumen, str::AbstractString)
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

function next_from_csa(kyokumen::Kyokumen, str::AbstractString)
    kyokumen = copy(kyokumen)
    next_from_csa!(kyokumen, str)
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
