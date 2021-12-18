# export KifuFromSFEN

# function MoveFromSFEN(kyokumen::Kyokumen, str::AbstractString)
#     4 ≤ length(str) ≤ 5 || error("Invalid length.")
#     sengo = Sengo(src)
#     src = copy(kyokumen)
#     dst = copy(src)
#     if str[2] == '*'
#         length(str) == 4 || error("Invalid length.")
#         koma = KomaFromSFEN(string(str[1]))
#         teban_mochigoma(dst)[koma] ≥ 1 || error("There is no mochigoma $koma.")
#         to_x = hankaku_suuji_to_int8(str[3])
#         to_y = hankaku_suuji_to_int8(hankaku_suuji_to_sfen_suuji(str[4]))
#         _check_in1to9(to_x)
#         _check_in1to9(to_y)
#         teban_mochigoma(dst)[koma] -= 1
#         dst[to_x, to_y] = Masu(koma, dst.teban)
#         dst.teban = next(dst.teban)
#         Move(sengo, src, dst, false, false, koma, 〼, "", "")
#     else
#         from_x = hankaku_suuji_to_int8(str[1])
#         from_y = hankaku_suuji_to_int8(hankaku_suuji_to_sfen_suuji(str[2]))
#         to_x = hankaku_suuji_to_int8(str[3])
#         to_y = hankaku_suuji_to_int8(hankaku_suuji_to_sfen_suuji(str[4]))
#         _check_in1to9(from_x)
#         _check_in1to9(from_y)
#         _check_in1to9(to_x)
#         _check_in1to9(to_y)
#         if length(str) == 5 && str[5] == '+'
#             dst_masu = dst[to_x, to_y]
#             src_masu = dst[from_x, from_y]
#             dst[to_x, to_y] = naru(src_masu)
#             dst[from_x, from_y] = 〼
#             Move(sengo, src, dst, true, true, koma, Koma(dst_masu), "", "")
#         else
#             dst[to_x, to_y] = dst[from_x, from_y]
#             dst[from_x, from_y] = 〼
#         end
#     end
    
#     src = kyokumen
#     dst = next_from_sfen(src)
#     Move(
#         sengo,
#         src,
#         dst,
#         ispromotable(kyokumen[]),
#         length(str) == 5 && str[5] == '+',
#         src_koma = 
#     )
# end

# function MoveDictFromSFEN(str::AbstractString)
#     n = length(str)
#     if 4 ≤ n ≤ 5
#         if str[2] == '*'
#             # drop
#             koma = Koma(string(str[1]))
#             x = int_to_hankaku(str[3])
#             y = int_to_sfen_suuji(str[4])
#             if isomote(koma) && n == 4
#                 Dict(
#                     :dst => (x, y),
#                     :koma => koma,
#                     :motion => [打],
#                 )
#             else
#                 error()
#             end
#         else
#             # not drop
#             x_src = int_to_hankaku(str[1])
#             y_src = int_to_sfen_suuji(str[2])
#             x_dst = int_to_hankaku(str[3])
#             y_dst = int_to_sfen_suuji(str[4])
#             if n == 4
#                 Dict(
#                     :src => (x_src, y_src),
#                     :dst => (x_dst, y_dst),
#                     :motion => [不成],
#                 )
#             elseif n == 5 && str[5] == '+'
#                 Dict(
#                     :src => (x_src, y_src),
#                     :dst => (x_dst, y_dst),
#                     :motion => [成],
#                 )
#             end
#         end
#     else
#         error()
#     end
# end

# function sfen(move::Move)
#     from_x = move.from_x |> string
#     from_y = move.from_y |> integer_to_sfen_suuji
#     to_x = move.to_x |> string
#     to_y = move.to_y |> integer_to_sfen_suuji
#     result = "$from_x$from_y$to_x$to_y"
#     if move.ispromote
#         result *= "+"
#     end
#     result
# end

# function sfen(drop::Drop)
#     koma = drop.koma |> sfen
#     to_x = drop.to_x
#     to_y = drop.to_y |> integer_to_sfen_suuji
#     "$koma*$to_x$to_y"
# end

# function sfen(kifu::Kifu) end

# function KifuFromSFEN(str::AbstractString) end