module SFEN

using Bijections

import ..Sengo, ..sente, ..gote
import ..Koma, ..歩兵, ..香車, ..桂馬, ..銀将, ..金将, ..角行, ..飛車, ..玉将, ..と金, ..成香, ..成桂, ..成銀, ..竜馬, ..竜王
import ..Masu, ..〼
import ..Kyokumen
import ..AbstractKifu

const sengo_to_sfen = Bijection(Dict(sente => "b", gote => "w"))
sfen(sengo::Sengo) = sengo_to_sfen[sengo]
Sengo(str::AbstractString) = sengo_to_sfen(str)

"""
    SFENKifu

SFEN 形式の棋譜を表す型。
"""
mutable struct SFENKifu <: AbstractKifu
end

end # module SFEN

# module SFEN

# using Bijections

# import ..Sengo as Sengo_, ..sente, ..gote
# import ..Koma, ..歩兵, ..香車, ..桂馬, ..銀将, ..金将, ..角行, ..飛車, ..玉将, ..と金, ..成香, ..成桂, ..成銀, ..竜馬, ..竜王
# import ..Masu, ..〼
# import ..GameState
# import ..GameStateWithPlyCount

# export sfen

# const koma_to_sfen = Bijection(Dict(
#     歩兵 => "P",
#     香車 => "L",
#     桂馬 => "N",
#     銀将 => "S",
#     金将 => "G",
#     角行 => "B",
#     飛車 => "R",
#     玉将 => "K",
#     と金 => "+P",
#     成香 => "+L",
#     成桂 => "+N",
#     成銀 => "+S",
#     竜馬 => "+B",
#     竜王 => "+R",
# ))
# sfen(koma::Koma) = koma_to_sfen[koma]
# KomaFromSFEN(str::AbstractString) = koma_to_sfen(str)

# const masu_to_sfen = let
#     ret = Dict()
#     for masu in instances(Masu)
#         n = Integer(masu)
#         if n == 0
#             ret[〼] = "1"
#         else
#             koma = Koma(abs(n))
#             if n > 0
#                 ret[Masu(koma, sente)] = sfen(koma)
#             else
#                 ret[Masu(koma, gote)] = lowercase(sfen(koma))
#             end
#         end
#     end
#     ret
# end |> Bijection

# sfen(masu::Masu) = masu_to_sfen[masu]
# MasuFromSFEN(str::AbstractString) = masu_to_sfen(str)

# # function parse(str::AbstractString)
# #     banmen_str, teban_str, mochigoma_str, tesuu_str = split(str, " ")
# #     kyokumen = Kyokumen(join((banmen_str, teban_str, mochigoma_str), " "))
# #     tesuu = parse(Int, tesuu_str)
# #     GameStateWithPlyCount(kyokumen, tesuu)
# # end

# sfen(s::GameState) = ""
# sfen(s::GameStateWithPlyCount) = "$(sfen(s.gamestate)) $(s.plycount)"

# # function SFENKyokumenFromSFEN(str::AbstractString)
# #     banmen_str, teban_str, mochigoma_str, tesuu_str = split(str, " ")
# #     kyokumen = Kyokumen(join((banmen_str, teban_str, mochigoma_str), " "))
# #     tesuu = parse(Int, tesuu_str)
# #     SFENKyokumen(kyokumen, tesuu)
# # end

# end # module SFEN