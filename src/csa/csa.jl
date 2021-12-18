# Copyright 2021-12-14 Koki Fushimi

# export MoveFromCSA

export next_from_csa, next_from_csa!

using Bijections

include("sengo.jl")
include("koma.jl")
include("masu.jl")
include("banmen.jl")
include("kyokumen.jl")

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

"""
    next_from_csa(kyokumen::Kyokumen, str::AbstractString)

Construct the next kyokumen from current kyokumen `kyokumen` and CSA move string `str`.
"""
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
