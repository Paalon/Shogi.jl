# Copyright 2021-11-25 Koki Fushimi

export Kifu, sfen

import Base:
    show, string

using MetaGraphs

mutable struct Kifu
    graph::MetaDiGraph
    # positions::Vector{Kyokumen}
    # moves::Vector{AbstractMove}
end

# function startpos(kifu::Kifu)
#     kifu.positions[1]
# end

# function Kifu()
#     Kifu([Kyokumen()], AbstractMove[])
# end

# function Base.show(io::IO, kifu::Kifu)
#     println(io, "初期局面")
#     print(io, kifu.positions[1])
#     println(io, "指し手")
#     print(io, kifu.moves)
# end

# function sfen(kifu::Kifu)
#     ret = "position sfen $(sfen(startpos(kifu)))"
#     if !isempty(kifu.moves)
#         ret *= " moves"
#         for move in kifu.moves
#             ret *= " $(sfen(move))"
#         end
#     end
#     ret
# end

# function splitonce(str)
#     split(str, " "; limit = 2)
# end

# # Make Kifu instance from USI position command.
# function Kifu(str::AbstractString)
#     kifu = Kifu()
#     args = splitonce(str)
#     if args[1] == "position" && length(args) == 2
#         # "position <args>".
#         args = splitonce(args[2])
#         if args[1] == "sfen" && length(args) == 2
#             # "position sfen <args>"
#             args = split(args[2])
#             if length(args) == 4
#                 # "position sfen <sfen-string>"
#                 sfen_str = join(args, " ")
#                 kyokumen = Kyokumen(sfen_str, style = :sfen)
#                 kifu.positions = [kyokumen]
#             elseif args[5] == "moves" && length(args) ≥ 6
#                 # "position sfen <sfen-string> moves <move-strings>"
#                 sfen_str = join(args[1:4], " ")
#                 move_strs = args[6:end]
#                 kyokumen = Kyokumen(sfen_str, style = :sfen)
#                 kifu.positions = [kyokumen]
#                 kifu.moves = AbstractMove.(move_strs)
#             else
#                 error("Does not match to `position sfen <sfenstring> (moves <move-strings>)`. $str")
#             end
#         elseif args[1] == "startpos"
#             # "position startpos (<args>)"
#             kyokumen = Kyokumen()
#             kifu.positions = [kyokumen]
#             if length(args) == 1
#                 # "position startpos"
#             else
#                 # "position startpos <args>"
#                 args = split(args[2], " ")
#                 if args[1] == "moves"
#                     # "position startpos moves <args>"
#                     move_strs = args[2:end]
#                     kifu.moves = AbstractMove.(move_strs)
#                 else
#                     error("Does not match to `position startpos (moves <move-strings>)`. $str")
#                 end
#             end
#         else
#             error("Does not match to `position [sfen <sfenstring> | startpos]`. $str")
#         end
#     else
#         error("Does not satisfy `position <args>` format. $str")
#     end

#     # if terms[1] == "sfen"
#     #     terms2 = split(terms[2]; limit = 6)
#     #     if length(terms2) == 4
#     #         terms[2]
#     #         kifu.kyokumen = Kyokumen("")
#     #     elseif terms[1] == "startpos"
#     #         kifu.kyokumen = Kyokumen()
#     #         if length(terms) == 1
#     #             Kyokumen
#     #         else
#     #             terms = splitonce(terms[2])
#     #             if terms[1] == "moves"
#     #                 if length(terms) == 2
#     #                     moves = split(terms[2])
#     #                     kifu.moves = AbstractMove.(moves)
#     #                     kyokumen
#     #                 else
#     #                     error()
#     #                 end
#     #             else
#     #             end
#     #         end
#     #     else
#     #         error()
#     #     end
#     # else
#     #     error()
#     # end
#     kifu
# end

# function kifu(move::Move)
#     move.ispromote
#     narinarazu = if move.ispromote
#         "成"
#     else
#         ""
#     end
#     "$(move.to_x)$(move.to_y)$narinarazu($(move.from_x)$(move.from_y))"
# end

# function kifu(drop::Drop)
#     "$(drop.to_x)$(drop.to_y)$(sfen(drop.koma_omote))打"
# end

# function isikibanonaikoma(koma_omote::KomaOmote, sengo::Sengo, ::Int8, y::Int8)
#     if koma_omote == KomaOmote(6)
#         # 桂馬
#         ((issente(sengo) && 1 ≤ y ≤ 2) || (issente(sengo) && 8 ≤ y ≤ 9))
#     elseif koma_omote == KomaOmote(7) || koma_omote == KomaOmote(8)
#         # 香車 or 歩兵
#         ((issente(sengo) && y == 1) || (issente(sengo) && y == 9))
#     else
#         false
#     end
# end

# function isnifu(banmen::Banmen, sengo::Sengo, x::Int8, ::Int8)
#     for y = 1:9
#         if banmen[x, y].n == sign(sengo) * 16
#             return true
#         end
#     end
#     false
# end

# # todo: 合法手チェック
# # history-stateless requirement
# # 成るならば敵陣を通過する ✔️
# # 行き先に自分の駒がない ✔️
# # 行き場のない駒にならない
# # 通過する場所に駒がない
# # 駒の基本的な動き方に違反しない
# # history-stateful requirement
# # 打ち歩詰めでない
# # 連続王手の千日手でない
# function move!(kyokumen::Kyokumen, move::Move)
#     from_masu = kyokumen.banmen[move.from_x, move.from_y]
#     to_masu = kyokumen.banmen[move.to_x, move.to_y]
#     if move.ispromote
#         if istekijin(kyokumen.teban, move.to_y) || istekijin(kyokumen.teban, from_y)
#             from_masu = naru(from_masu)
#         else
#             error("敵陣を通らない場合は成れません。")
#         end
#     end
#     to_masu_sengo = Sengo(to_masu)
#     if isnothing(to_masu_sengo)
#         # 行き先に駒がない
#         # 移動する
#         kyokumen.banmen[move.to_x, move.to_y] = from_masu
#         kyokumen.banmen[move.from_x, move.from_y] = Masu(0)
#     else
#         teban = issente(kyokumen)
#         to_koma_teban = issente(to_masu_sengo)
#         if teban == to_koma_teban
#             # 自分の駒がある
#             error("自分の駒がある場所には移動できません。")
#         else
#             # 相手の駒がある
#             # 相手の駒を取る
#             capture!(kyokumen, move.to_x, move.to_y)
#             # 移動する
#             kyokumen.banmen[move.to_x, move.to_y] = from_masu
#             kyokumen.banmen[move.from_x, move.from_y] = Masu(0)
#         end
#     end
#     next!(kyokumen)
# end

# # todo: 合法手チェック
# # history-stateless requirement
# # 行き先に駒がない ✔️
# # 行き場のない駒にならない ✔️
# # 二歩にならない ✔️
# # history-stateful requirement
# # 打ち歩詰めでない
# # 連続王手の千日手でない
# function move!(kyokumen::Kyokumen, drop::Drop)
#     mochigoma = teban_mochigoma(kyokumen)
#     n = mochigoma[drop.koma_omote]
#     if !(n ≥ 1)
#         error("その駒は持っていないので、打てません。")
#     end
#     if !isempty(kyokumen.banmen[drop.to_x, drop.to_y])
#         error("そこには駒が既にあるので、打てません。")
#     end
#     if isfu(drop.koma_omote) && isnifu(kyokumen.banmen, kyokumen.teban, drop.to_x, drop.to_y)
#         error("二歩になるので、打てません。")
#     end
#     if isikibanonaikoma(drop.koma_omote, kyokumen.teban, drop.to_x, drop.to_y)
#         error("行き場のない駒になるので、打てません。")
#     end
#     mochigoma[drop.koma_omote] = n - 1
#     kyokumen.banmen[drop.to_x, drop.to_y] = Masu(drop.koma_omote, kyokumen.teban)
#     next!(kyokumen)
# end

# function move!(kyokumen::Kyokumen, str::AbstractString)
#     move!(kyokumen, AbstractMove(str))
# end