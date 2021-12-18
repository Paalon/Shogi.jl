# Copyright 2021-11-25 Koki Fushimi

export AbstractMove
export KifuMove
export KyokumenMove
export CompleteMove

abstract type AbstractMove end
abstract type KifuMove <: AbstractMove end
abstract type KyokumenMove <: KifuMove end
abstract type CompleteMove <: KyokumenMove end

struct EncodedMove <: CompleteMove
    src1::UInt128
    src2::UInt128
    dst1::UInt128
    dst2::UInt128
end

# function getsrc(move::CompleteMove)
#     move.src
# end

# function getdst(move::CompleteMove)
#     move.dst
# end

# function getname(move::CompleteMove)
#     move.name
# end

# function ispromotable(move::CompleteMove)
#     move.ispromotable
# end

# function ispromotion(move::CompleteMove)
#     move.ispromotion
# end

# function Koma(move::CompleteMove)
#     move.koma
# end

# function iscapture(move::CompleteMove)
#     move.iscapture
# end

# struct Move <: CompleteMove
#     sengo::Sengo
#     src::Kyokumen
#     dst::Kyokumen
#     src_pos::Tuple{Integer,Integer}
#     dst_pos::Tuple{Integer,Integer}
#     ispromotable::Bool
#     ispromotion::Bool
#     src_koma::Koma
#     dst_masu::Masu
#     suffix::String
#     name::String
# end

# function Koma(move::Move)
#     move.src_koma
# end

# function iscapture(move::Move)
#     move.dst_masu ≠ 〼
# end

# function captured_koma(move::Move)
#     Koma(move.dst_masu)
# end

# 手は厳密には２局面をつなぐエッジである。

# 日本将棋連盟 形式
# 移動元 x::Integer, y::Integer, 1 ≤ x ≤ 9, 1 ≤ y ≤ 9 or 駒台
# 移動先 x::Integer, y::Integer, 1 ≤ x ≤ 9, 1 ≤ y ≤ 9
# 手番 teban::Sengo
# 打った手か？ isdrop
# 取った手か？ iscapture
# 成った手か？
# 基本合法手の下で成れる手か？

# ２局面からその手を計算するプログラムを作る。

# function basicmoves(kyokumen::Kyokumen)
#     ret = Dict[]
#     bb_koma = zeros(Bool, 9, 9)
#     bb_teban_koma = zeros(Bool, 9, 9)
#     for i = 1:9, j = 1:9
#         bb_koma[i, j] = kyokumen[i, j] ≠ 〼
#         bb_teban_koma[i, j] = Sengo(kyokumen) == Sengo(kyokumen[i, j])
#     end
#     sengo = Sengo(kyokumen)
#     for i = 1:9, j = 1:9
#         if bb_teban_koma[i, j]
#             koma = Koma(kyokumen[i, j])
#             if koma == 歩兵
#                 ms = 歩兵の動き方(sengo)
#                 xs = [(i, j) .+ m for m in ms]
#                 xs = filter(isonboard, xs)
#                 for x in xs
#                     dict = Dict(
#                         :sengo => sengo,
#                         :src => (i, j)
#                         :dst => x,
#                         :koma => 歩兵,
#                     )
#                     push!(ret, dict)
#                 end
#             elseif koma == 桂馬
#                 ms = 桂馬の動き方(sengo)
#                 xs = [(i, j) .+ m for m in ms]
#                 xs = filter(isonboard, xs)
#                 for x in xs
#                     dict = Dict(
#                         :sengo => sengo,
#                         :src => (i, j)
#                         :dst => x,
#                         :koma => 桂馬,
#                         :ispromotable =>
#                     )
#                 end
#             elseif koma == 銀将
#                 銀将の動き方(sengo)
#             elseif koma == 金将 || koma == と金 || koma == 成香 || koma == 成桂 || koma == 成銀
#                 金将の動き方(sengo)
#             elseif koma == 玉将
#                 玉将の動き方(sengo)
#             elseif koma == 香車
                
#             elseif koma == 飛車
#             elseif koma == 角行
#             elseif koma == 竜王
#             elseif koma == 竜馬
#             end
#         end
#     end
# end


# function MoveFromSFEN(str::AbstractString)
# end

# function MoveFromCSA(str::AbstractString)
# end

# function MoveFromKakinoki(str::AbstractString)
# end

# function fullsuffix_from_sfen(str::AbstractString)
    
# end

# function relmot(sengo::Sengo, t0::Union{Nothing,Tuple{Integer,Integer}}, t1::Tuple{Integer,Integer})
#     if isnothing(t0)
#         (relmot = 打, ispromotable = false,)
#     else
#         x0, y0 = t0
#         x1, y1 = t1
#         relative = if x0 < x1
#             if issente(sengo)
#                 右
#             else
#                 左
#             end
#         elseif x0 > x1
#             if issente(sengo)
#                 左
#             else
#                 右
#             end
#         else
#             直
#         end
#         motion = if y0 < y1
#             if issente(sengo)
#                 引
#             else
#                 上
#             end
#         elseif y0 > y1
#             if issente(sengo)
#                 上
#             else
#                 引
#             end
#         else
#             寄
#         end
#         if issente(sengo)
#             sengo
#         end
#         (relmot = (relative, motion), ispromotable = ispromotable,)
#     end
# end

# function relmot_from_sfen(str::AbstractString)
# end



# ☗２６歩 -> ２７から２６に歩が直ぐ上がる

# ☗５５金直引
# ☗５５金左寄
# ☗５５金右寄
# ☗５５金左上
# ☗５５金直上
# ☗５５金右上

# ☗５５銀左引
# ☗５５銀右引
# ☗５５銀左上
# ☗５５銀直上
# ☗５５銀右上

# ☗５５桂右上
# ☗５５桂左上

# ☗５５飛直上
# ☗５５飛直引
# ☗５５飛左寄
# ☗５５飛右寄

# ☗５５角左上
# ☗５５角右上
# ☗５５角左引
# ☗５５角右引

# ☗５５竜左上
# ☗５５竜直上
# ☗５５竜右上
# ☗５５竜左寄
# ☗５５竜右寄
# ☗５５竜左引
# ☗５５竜直引
# ☗５５竜右引

# ☗５５歩直上
# ☗５５香直上
# 成
# 不成
# 打

# function string(s::JSAKifuMoveSuffix)
# end

# struct Move
#     kyokumen0::Kyokumen
#     kyokumen1::Kyokumen
#     src_index::Union{Nothing,Tuple{Integer,Integer}}
#     dst_index::Tuple{Ingeger,Integer}
#     relative::JSARelativeSuffix
#     motion::JSAMotionSuffix
#     isdrop::Union{Missing,Bool}
#     iscapture::Union{Missing,Bool}
#     captured::Union{Missing,Koma}
#     issame::Union{Missing,Bool}
#     ispromotion::Union{Missing,Bool}
#     ispromotable::Union{Missing,Bool}
#     suffix::Union{Missing,}
# end

# function jsasuffix(move::Move)
#     ret = []
# end

# """
#     jsa(move::Move)

# 日本将棋連盟の指定する棋譜の指し手の表記を返す。
# See https://www.shogi.or.jp/faq/kihuhyouki.html for detail.
# """
# function jsa(move::Move)
#     x, y = move.dst_index
#     x_char, y_char = int_to_zenkaku[x], int_to_zenkaku[y]
#     koma = Koma(move.dst_masu)
#     suf = join(string.(jsasuffix(move)))
#     "$x_char$y_char$koma$suf"
# end

# export AbstractMove, Move, Drop, sfen
# export susumeru!, susumeru
# export traditional_notation



# """
#     Move <: AbstractMove

# Type for representing a on-board move.
# """
# struct Move <: AbstractMove
#     from_x::Int8
#     from_y::Int8
#     to_x::Int8
#     to_y::Int8
#     ispromote::Bool
# end

# function Move(str::AbstractString)
#     from_x, from_y, to_x, to_y = parse.(Int8, string.((
#         str[1], sfen_suuji_to_hankaku_suuji(str[2]),
#         str[3], sfen_suuji_to_hankaku_suuji(str[4]),
#     )))
#     ispromote = length(str) == 5 && str[5] == '+'
#     Move(from_x, from_y, to_x, to_y, ispromote)
# end

# function to(move::Move)
#     move.to_x, move.to_y
# end

# function from(move::Move)
#     move.from_x, move.from_y
# end


# function to(drop::Drop)
#     drop.to_x, drop.to_y
# end

# # # 投了
# # struct Resign <: AbstractMove end

# # # 引き分け
# # struct Draw <: AbstractMove end

# # # 持将棋
# # struct Jishogi <: AbstractMove end

# # # 反則手
# # function isillegal(kyokumen::Kyokumen, move::Move)

# #     isnifu(kyokumen, move) &&
# #     is
# # end

# # # 

# # # 連続王手の千日手
# # struct PerpetualCheck <: AbstractMove end

# # # 
# # struct Nifu <: AbstractMove end

# function AbstractMove(str::AbstractString)
#     n = length(str)
#     e = ErrorException("Invalid string $str")
#     koma_omote_chars = ['K', 'R', 'B', 'G', 'S', 'N', 'L', 'P']
#     # 不正な文字列はここで全て排除する。
#     if 4 ≤ n ≤ 5
#         if str[2] == '*'
#             if str[1] in koma_omote_chars && str[3] in '1':'9' && str[4] in 'a':'i' && n == 4
#                 Drop(str)
#             else
#                 throw(e)
#             end
#         else
#             char_1_to_9 = '1':'9'
#             char_a_to_i = 'a':'i'
#             if str[1] in char_1_to_9 && str[3] in char_1_to_9 && str[2] in char_a_to_i && str[4] in char_a_to_i
#                 if n == 5
#                     if str[5] == '+'
#                         Move(str)
#                     else
#                         throw(e)
#                     end
#                 else
#                     Move(str)
#                 end
#             else
#                 throw(e)
#             end
#         end
#     else
#         throw(e)
#     end
# end

# function Koma(::Kyokumen, drop::Drop)
#     drop.koma
# end

# function Koma(kyokumen::Kyokumen, move::Move)
#     Koma(kyokumen[from(move)...])
# end

# function susumeru!(kyokumen::Kyokumen, drop::Drop)
#     mochigoma = teban_mochigoma(kyokumen)
#     if mochigoma[drop.koma] ≥ 1 && isempty(kyokumen[to(drop)...])
#         mochigoma[drop.koma] -= 1
#         kyokumen[to(drop)...] = Masu(drop.koma, kyokumen.teban)
#     else
#         error("Fail to susumeru!")
#     end
#     kyokumen.teban = next(kyokumen.teban)
#     kyokumen
# end

# function susumeru!(kyokumen::Kyokumen, move::Move)
#     if !isempty(kyokumen[to(move)...])
#         toru!(kyokumen, to(move)...)
#     end
#     kyokumen[to(move)...] = if move.ispromote
#         masu = naru(kyokumen[from(move)...])
#         if isnothing(masu)
#             error("Cannot promote.")
#         else
#             masu
#         end
#     else
#         kyokumen[from(move)...]
#     end
#     kyokumen[from(move)...] = Masu(0)
#     kyokumen.teban = next(kyokumen.teban)
#     kyokumen
# end

# function susumeru!(kyokumen::Kyokumen, moves::AbstractMove...)
#     for move in moves
#         susumeru!(kyokumen, move)
#     end
#     kyokumen
# end

# function susumeru(kyokumen::Kyokumen, moves::AbstractMove...)
#     kyokumen = copy(kyokumen)
#     susumeru!(kyokumen, moves...)
# end

# function susumeru!(kyokumen::Kyokumen, moves::AbstractString...)
#     susumeru!(kyokumen, AbstractMove.(moves)...)
# end

# function susumeru(kyokumen::Kyokumen, moves::AbstractString...)
#     kyokumen = copy(kyokumen)
#     susumeru!(kyokumen, AbstractMove.(moves)...)
# end

# """
#     susumeru!(kyokumen::Kyokumen, moves::AbstractMove...)
#     susumeru!(kyokumen::Kyokumen, moves::AbstractString...)
#     susumeru(kyokumen::Kyokumen, moves::AbstractMove...)
#     susumeru(kyokumen::Kyokumen, moves::AbstractString...)

# Do the moves to the kyokumen.
# """
# susumeru!, susumeru

# function ispromotable(sengo::Sengo, from::Tuple{<:Integer,<:Integer}, to::Tuple{<:Integer,<:Integer})
#     if issente(sengo)
#         _, y0 = from
#         _, y1 = to
#         1 ≤ y0 ≤ 3 || 1 ≤ y1 ≤ 3
#     else
#         _, y0 = from
#         _, y1 = to
#         7 ≤ y0 ≤ 9 || 7 ≤ y1 ≤ 9
#     end
# end

# function ispromotable(kyokumen::Kyokumen, from::Tuple{<:Integer,<:Integer}, to::Tuple{<:Integer,<:Integer})
#     ispromotable(kyokumen.teban, from, to)
# end

# function ispromotable(kyokumen::Kyokumen, move::Move)
#     x = ispromotable(kyokumen[from(move)...])
#     if isnothing(x)
#         error("Invalid move $move")
#     elseif x && ispromotable(kyokumen, from(move), to(move))
#         true
#     else
#         false
#     end
# end

# # todo: add relative position and dousa.
# function traditional_notation(kyokumen::Kyokumen, move::AbstractMove)
#     ret = ""
#     if issente(kyokumen)
#         ret *= "☗"
#     else
#         ret *= "☖"
#     end
#     x, y = to(move)
#     ret *= x |> string |> only |> hankaku_suuji_to_zenkaku_suuji |> string
#     ret *= y |> string |> only |> hankaku_suuji_to_zenkaku_suuji |> string
#     hankaku_suuji_to_kansuuji
#     koma = Koma(kyokumen, move)
#     ret *= string(koma, style = :kifu)
#     if typeof(move) == Drop
#         # 
#         ret *= "打"
#     else
#         # typeof(move) == Move
#         if ispromotable(kyokumen, move)
#             if move.ispromote
#                 ret *= "成"
#             else
#                 ret *= "不成"
#             end
#         end
#     end
#     ret
# end