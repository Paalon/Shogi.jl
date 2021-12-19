# Copyright 2021-11-25 Koki Fushimi

export Kifu

function Kifu(kyokumen::Kyokumen)
    book = Book()
    addkyokumen!(book, kyokumen)
    book
end

function Kifu(kyokumen::Kyokumen, moves::Vector{<:KyokumenMove})
    book = Book()
    k1 = kyokumen
    for move in moves
        k0 = k1
        k1 = next(k0, move)
        em = EncodedMove(k0, k1)
        addmove!(book, em)
    end
    book
end

# export hasnode, getnode, addnode!
# export add_move!, get_end

# import Base:
#     show, string

# using Graphs, MetaGraphs

# mutable struct Kifu
#     graph::MetaDiGraph
# end

# function hasnode(kifu::Kifu, kyokumen::Kyokumen)
#     nodes = filter_vertices(kifu.graph, :hexadecimal, encode(kyokumen))
#     if isempty(nodes)
#         false
#     else
#         true
#     end
# end

# """
#     get_node(kifu::Kifu, kyokumen::Kyokumen)

# Get the node of `kyokumen` from `kifu`.
# """
# function getnode(kifu::Kifu, kyokumen::Kyokumen)
#     nodes = filter_vertices(kifu.graph, :hexadecimal, encode(kyokumen))
#     only(nodes)
# end

# """
#     add_node(kifu::Kifu, kyokumen::Kyokumen)

# Add the node of `kyokumen` to `kifu`.
# """
# function add_node!(kifu::Kifu, kyokumen::Kyokumen)
#     hexadecimal = encode(kyokumen)
#     add_vertex!(kifu.graph, :hexadecimal, hexadecimal)
# end

# function getedge(kifu::Kifu, kyokumen::Kyokumen)
#     h
# end

# function addedge!(kifu::Kifu, k0::Kyokumen, k1::Kyokumen, move)
#     n0 = getnode(kifu, k0)
#     n1 = getnode(kifu, k1)
#     add_edge!(kifu.graph, n0, n1, :move, move)
# end

# function Kifu()
#     Kifu(MetaDiGraph())
# end

# function Kifu(kyokumen::Kyokumen)
#     kifu = Kifu()
#     add_node!(kifu, kyokumen)
#     kifu
# end

# function get_end(kifu::Kifu)
#     str = get_prop(kifu.graph, vertices(kifu.graph)[end], :hexadecimal)
#     decode(str)
# end

# function addmove_sfen!(kifu::Kifu, kyokumen::Kyokumen, str::AbstractString)
#     kyokumen_next = next_from_sfen(kyokumen, str)
#     if hasnode(kifu, kyokumen_next)
#         node0 = getnode(kifu, kyokumen)
#         node1 = getnode(kifu, kyokumen_next)
#         add_edge!(kifu.graph, node0, node1, :move, move)
#     else
#         addnode!(kifu, kyokumen_next)
#         node0 = get_node(kifu, kyokumen)
#         node1 = get_node(kifu, kyokumen_next)
#         add_edge!(kifu.graph, node0, node1, :move, move)
#     end
#     kifu
# end

# function Kifu(kyokumen::Kyokumen, moves::Vector{<:AbstractMove})
#     kifu = Kifu(kyokumen)
#     for move in moves
#         add_move!(kifu, kyokumen, move)
#         kyokumen = get_end(kifu)
#     end
#     kifu
# end

# function Kifu(kyokumen::Kyokumen, move::AbstractMove)
#     Kifu(kyokumen, [move])
# end

# function Base.show(io::IO, kifu::Kifu)
#     print(io, "graph = ")
#     println(io, kifu.graph)
#     print(io, get_end(kifu))
#     println(io, sfen(kifu))
# end

# function sfen(kifu::Kifu)
#     hex = get_prop(kifu.graph, 1, :hexadecimal)
#     kyokumen = decode(hex)
#     sfenkyokumen = SFENKyokumen(kyokumen, 1)
#     str = "position sfen $(sfen(sfenkyokumen))"
#     edges_ = edges(kifu.graph)
#     if !isempty(edges_)
#         str *= " moves"
#         for edge in edges_
#             move = get_prop(kifu.graph, edge, :move)
#             str *= " "
#             str *= sfen(move)
#         end
#     end
#     str
# end

# # function startpos(kifu::Kifu)
# #     kifu.positions[1]
# # end

# # function Kifu()
# #     Kifu([Kyokumen()], AbstractMove[])
# # end

# # function Base.show(io::IO, kifu::Kifu)
# #     println(io, "初期局面")
# #     print(io, kifu.positions[1])
# #     println(io, "指し手")
# #     print(io, kifu.moves)
# # end

# # function sfen(kifu::Kifu)
# #     ret = "position sfen $(sfen(startpos(kifu)))"
# #     if !isempty(kifu.moves)
# #         ret *= " moves"
# #         for move in kifu.moves
# #             ret *= " $(sfen(move))"
# #         end
# #     end
# #     ret
# # end

# # function splitonce(str)
# #     split(str, " "; limit = 2)
# # end

# # function kifu(move::Move)
# #     move.ispromote
# #     narinarazu = if move.ispromote
# #         "成"
# #     else
# #         ""
# #     end
# #     "$(move.to_x)$(move.to_y)$narinarazu($(move.from_x)$(move.from_y))"
# # end

# # function kifu(drop::Drop)
# #     "$(drop.to_x)$(drop.to_y)$(sfen(drop.koma_omote))打"
# # end

# # function isikibanonaikoma(koma_omote::KomaOmote, sengo::Sengo, ::Int8, y::Int8)
# #     if koma_omote == KomaOmote(6)
# #         # 桂馬
# #         ((issente(sengo) && 1 ≤ y ≤ 2) || (issente(sengo) && 8 ≤ y ≤ 9))
# #     elseif koma_omote == KomaOmote(7) || koma_omote == KomaOmote(8)
# #         # 香車 or 歩兵
# #         ((issente(sengo) && y == 1) || (issente(sengo) && y == 9))
# #     else
# #         false
# #     end
# # end

# # function isnifu(banmen::Banmen, sengo::Sengo, x::Int8, ::Int8)
# #     for y = 1:9
# #         if banmen[x, y].n == sign(sengo) * 16
# #             return true
# #         end
# #     end
# #     false
# # end

# # # todo: 合法手チェック
# # # history-stateless requirement
# # # 成るならば敵陣を通過する ✔️
# # # 行き先に自分の駒がない ✔️
# # # 行き場のない駒にならない
# # # 通過する場所に駒がない
# # # 駒の基本的な動き方に違反しない
# # # history-stateful requirement
# # # 打ち歩詰めでない
# # # 連続王手の千日手でない
# # function move!(kyokumen::Kyokumen, move::Move)
# #     from_masu = kyokumen.banmen[move.from_x, move.from_y]
# #     to_masu = kyokumen.banmen[move.to_x, move.to_y]
# #     if move.ispromote
# #         if istekijin(kyokumen.teban, move.to_y) || istekijin(kyokumen.teban, from_y)
# #             from_masu = naru(from_masu)
# #         else
# #             error("敵陣を通らない場合は成れません。")
# #         end
# #     end
# #     to_masu_sengo = Sengo(to_masu)
# #     if isnothing(to_masu_sengo)
# #         # 行き先に駒がない
# #         # 移動する
# #         kyokumen.banmen[move.to_x, move.to_y] = from_masu
# #         kyokumen.banmen[move.from_x, move.from_y] = Masu(0)
# #     else
# #         teban = issente(kyokumen)
# #         to_koma_teban = issente(to_masu_sengo)
# #         if teban == to_koma_teban
# #             # 自分の駒がある
# #             error("自分の駒がある場所には移動できません。")
# #         else
# #             # 相手の駒がある
# #             # 相手の駒を取る
# #             capture!(kyokumen, move.to_x, move.to_y)
# #             # 移動する
# #             kyokumen.banmen[move.to_x, move.to_y] = from_masu
# #             kyokumen.banmen[move.from_x, move.from_y] = Masu(0)
# #         end
# #     end
# #     next!(kyokumen)
# # end

# # # todo: 合法手チェック
# # # history-stateless requirement
# # # 行き先に駒がない ✔️
# # # 行き場のない駒にならない ✔️
# # # 二歩にならない ✔️
# # # history-stateful requirement
# # # 打ち歩詰めでない
# # # 連続王手の千日手でない
# # function move!(kyokumen::Kyokumen, drop::Drop)
# #     mochigoma = teban_mochigoma(kyokumen)
# #     n = mochigoma[drop.koma_omote]
# #     if !(n ≥ 1)
# #         error("その駒は持っていないので、打てません。")
# #     end
# #     if !isempty(kyokumen.banmen[drop.to_x, drop.to_y])
# #         error("そこには駒が既にあるので、打てません。")
# #     end
# #     if isfu(drop.koma_omote) && isnifu(kyokumen.banmen, kyokumen.teban, drop.to_x, drop.to_y)
# #         error("二歩になるので、打てません。")
# #     end
# #     if isikibanonaikoma(drop.koma_omote, kyokumen.teban, drop.to_x, drop.to_y)
# #         error("行き場のない駒になるので、打てません。")
# #     end
# #     mochigoma[drop.koma_omote] = n - 1
# #     kyokumen.banmen[drop.to_x, drop.to_y] = Masu(drop.koma_omote, kyokumen.teban)
# #     next!(kyokumen)
# # end

# # function move!(kyokumen::Kyokumen, str::AbstractString)
# #     move!(kyokumen, AbstractMove(str))
# # end