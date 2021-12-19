# 合法手の生成
# 王手のチェック
# 行けない駒のチェック
# 千日手
# 打ち歩詰め
# 両王手
# 開き王手
# 入玉宣言

# Copyright 2021-12-14 Koki Fushimi

export isonboard
export ispromotable
export SShogiBoard
export getexistent
export getally
export getenemy
# export pawn_movements
# export lance_movements
# export knight_movements
# export rook_movements
export movements

Square = Tuple{Integer,Integer}

function isonboard(p::Square)
    x, y = p
    1 ≤ x ≤ 9 && 1 ≤ y ≤ 9
end

function ispromotable(sengo::Sengo, src::Square, dst::Square)
    _, y0 = src
    _, y1 = dst
    if issente(sengo)
        1 ≤ y0 ≤ 3 || 1 ≤ y1 ≤ 3
    else
        7 ≤ y0 ≤ 9 || 7 ≤ y1 ≤ 9
    end
end

function ispromotable(sengo::Sengo, koma::Koma, src::Square, dst::Square)
    ispromotable(koma) && ispromotable(sengo, src, dst)
end

SShogiBoard{T} = SMatrix{9,9,T,81}
SShogiBitBoard = SShogiBoard{Bool}
SBB = SShogiBitBoard


ue(sengo::Sengo) = 0, -sign(sengo)
shita(sengo::Sengo) = 0, sign(sengo)
migi(sengo::Sengo) = -sign(sengo), 0
hidari(sengo::Sengo) = sign(sengo), 0

migiue(sengo::Sengo) = migi(sengo) .+ ue(sengo)
migishita(sengo::Sengo) = migi(sengo) .+ shita(sengo)
hidariue(sengo::Sengo) = hidari(sengo) .+ ue(sengo)
hidarishita(sengo::Sengo) = hidari(sengo) .+ shita(sengo)

function getexistent(kyokumen::Kyokumen)
    ret = zeros(Bool, 9, 9)
    for i = 1:9, j = 1:9
        ret[i, j] = kyokumen[i, j] ≠ 〼
    end
    SShogiBoard{Bool}(ret)
end

function getally(kyokumen::Kyokumen)
    ret = zeros(Bool, 9, 9)
    for i = 1:9, j = 1:9
        ret[i, j] = Sengo(kyokumen) == Sengo(kyokumen[i, j])
    end
    SShogiBoard{Bool}(ret)
end

function getenemy(kyokumen::Kyokumen)
    ret = zeros(Bool, 9, 9)
    for i = 1:9, j = 1:9
        ret[i, j] = next(Sengo(kyokumen)) == Sengo(kyokumen[i, j])
    end
    SShogiBoard{Bool}(ret)
end

function pushsquare!(xs::Vector{Square}, p0::Square, dp::Square, bbe::SShogiBitBoard, bba::SShogiBitBoard)
    p1 = p0 .+ dp
    if isonboard(p1)
        if bbe[p1...] && bba[p1...]
            xs
        else
            push!(xs, p1)
        end
    else
        xs
    end
end

function pushsquareuntilhit!(xs::Vector{Square}, p0::Square, dp::Square, bbe::SShogiBitBoard, bba::SShogiBitBoard)
    p = p0 .+ dp
    while isonboard(p)
        if bbe[p...]
            if bba[p...]
                break
            end
            push!(xs, p)
            break
        end
        push!(xs, p)
        p = p .+ dp
    end
    xs
end

function pawn_movements(sengo::Sengo, p::Square, bbe::SShogiBitBoard, bba::SShogiBitBoard)
    ret = Square[]
    pushsquare!(ret, p, ue(sengo), bbe, bba)
    ret
end

function knight_movements(sengo::Sengo, p::Square, bbe::SShogiBitBoard, bba::SShogiBitBoard)
    ret = Square[]
    pushsquare!(ret, p, migi(sengo) .+ 2 .* ue(sengo), bbe, bba)
    pushsquare!(ret, p, hidari(sengo) .+ 2 .* ue(sengo), bbe, bba)
    ret
end

function silver_movements(sengo::Sengo, p::Square, bbe::SShogiBitBoard, bba::SShogiBitBoard)
    ret = Square[]
    pushsquare!(ret, p, ue(sengo), bbe, bba)
    pushsquare!(ret, p, (1, 1), bbe, bba)
    pushsquare!(ret, p, (1, -1), bbe, bba)
    pushsquare!(ret, p, (-1, 1), bbe, bba)
    pushsquare!(ret, p, (-1, -1), bbe, bba)
    ret
end

function gold_movements(sengo::Sengo, p::Square, bbe::SShogiBitBoard, bba::SShogiBitBoard)
    ret = Square[]
    pushsquare!(ret, p, migiue(sengo), bbe, bba)
    pushsquare!(ret, p, hidariue(sengo), bbe, bba)
    pushsquare!(ret, p, ue(sengo), bbe, bba)
    pushsquare!(ret, p, shita(sengo), bbe, bba)
    pushsquare!(ret, p, hidari(sengo), bbe, bba)
    pushsquare!(ret, p, migi(sengo), bbe, bba)
    ret
end

function king_movements(::Sengo, p::Square, bbe::SShogiBitBoard, bba::SShogiBitBoard)
    ret = Square[]
    pushsquare!(ret, p, (+1, 0), bbe, bba)
    pushsquare!(ret, p, (0, +1), bbe, bba)
    pushsquare!(ret, p, (-1, 0), bbe, bba)
    pushsquare!(ret, p, (0, -1), bbe, bba)
    pushsquare!(ret, p, (+1, +1), bbe, bba)
    pushsquare!(ret, p, (+1, -1), bbe, bba)
    pushsquare!(ret, p, (-1, +1), bbe, bba)
    pushsquare!(ret, p, (-1, -1), bbe, bba)
    ret
end

function lance_movements(sengo::Sengo, p::Square, bbe::SShogiBitBoard, bba::SShogiBitBoard)
    ret = Square[]
    pushsquareuntilhit!(ret, p, ue(sengo), bbe, bba)
    ret
end

function bishop_movements(::Sengo, p::Square, bbe::SShogiBitBoard, bba::SShogiBitBoard)
    ret = Square[]
    pushsquareuntilhit!(ret, p, (+1, +1), bbe, bba)
    pushsquareuntilhit!(ret, p, (+1, -1), bbe, bba)
    pushsquareuntilhit!(ret, p, (-1, +1), bbe, bba)
    pushsquareuntilhit!(ret, p, (-1, -1), bbe, bba)
    ret
end

function rook_movements(::Sengo, p::Square, bbe::SShogiBitBoard, bba::SShogiBitBoard)
    ret = Square[]
    pushsquareuntilhit!(ret, p, (+1, 0), bbe, bba)
    pushsquareuntilhit!(ret, p, (0, +1), bbe, bba)
    pushsquareuntilhit!(ret, p, (-1, 0), bbe, bba)
    pushsquareuntilhit!(ret, p, (0, -1), bbe, bba)
    ret
end

function horse_movements(::Sengo, p::Square, bbe::SShogiBitBoard, bba::SShogiBitBoard)
    ret = Square[]
    pushsquareuntilhit!(ret, p, (+1, +1), bbe, bba)
    pushsquareuntilhit!(ret, p, (+1, -1), bbe, bba)
    pushsquareuntilhit!(ret, p, (-1, +1), bbe, bba)
    pushsquareuntilhit!(ret, p, (-1, -1), bbe, bba)
    pushsquare!(ret, p, (+1, 0), bbe, bba)
    pushsquare!(ret, p, (0, +1), bbe, bba)
    pushsquare!(ret, p, (-1, 0), bbe, bba)
    pushsquare!(ret, p, (0, -1), bbe, bba)
    ret
end

function dragon_movements(::Sengo, p::Square, bbe::SShogiBitBoard, bba::SShogiBitBoard)
    ret = Square[]
    pushsquareuntilhit!(ret, p, (+1, 0), bbe, bba)
    pushsquareuntilhit!(ret, p, (0, +1), bbe, bba)
    pushsquareuntilhit!(ret, p, (-1, 0), bbe, bba)
    pushsquareuntilhit!(ret, p, (0, -1), bbe, bba)
    pushsquare!(ret, p, (+1, +1), bbe, bba)
    pushsquare!(ret, p, (+1, -1), bbe, bba)
    pushsquare!(ret, p, (-1, +1), bbe, bba)
    pushsquare!(ret, p, (-1, -1), bbe, bba)
    ret
end

const _movements_functions = Dict(
    歩兵 => pawn_movements,
    香車 => lance_movements,
    桂馬 => knight_movements,
    銀将 => silver_movements,
    金将 => gold_movements,
    玉将 => king_movements,
    角行 => bishop_movements,
    飛車 => rook_movements,
    と金 => gold_movements,
    成香 => gold_movements,
    成桂 => gold_movements,
    成銀 => gold_movements,
    竜馬 => horse_movements,
    竜王 => dragon_movements,
)

function movements(sengo::Sengo, p::Square, koma::Koma, bbe::SShogiBitBoard, bba::SShogiBitBoard)
    f = _movements_functions[koma]
    f(sengo, p, bbe, bba)
end

function movements(kyokumen::Kyokumen, p::Square, koma::Koma)
    movements(Sengo(kyokumen), p, koma, getexistent(kyokumen), getally(kyokumen))
end

function motion_info(sengo::Sengo, src::Square, dst::Square)
    if issente(sengo)
        dx, dy = dst .- src
        -sign(dx), -sign(dy)
    else
        dx, dy = dst .- src
        sign(dx), sign(dy)
    end
end

function movements(kyokumen::Kyokumen)
    sengo = Sengo(kyokumen)
    bba = getally(kyokumen)
    bbe = getexistent(kyokumen)
    ret = []
    for i = 1:9, j = 1:9
        if bba[i, j]
            koma = Koma(kyokumen[i, j])
            ps = movements(sengo, (i, j), koma, bbe, bba)
            for p in ps
                src = (i, j)
                dst = p
                ispromotable_ = ispromotable(sengo, koma, src, dst)
                if ispromotable_
                    push!(ret, Dict(
                        :sengo => sengo,
                        :src => src,
                        :dst => dst,
                        :src_koma => koma,
                        :dst_koma => koma,
                        :ispromotable => true,
                        :ispromotion => true,
                        :motion_info => motion_info(sengo, src, dst),
                    ))
                    push!(ret, Dict(
                        :sengo => sengo,
                        :src => src,
                        :dst => dst,
                        :src_koma => koma,
                        :dst_koma => naru(koma),
                        :ispromotable => true,
                        :ispromotion => false,
                        :motion_info => motion_info(sengo, src, dst),
                    ))
                else
                    move = Dict(
                        :sengo => sengo,
                        :src => src,
                        :dst => dst,
                        :src_koma => koma,
                        :dst_koma => koma,
                        :ispromotable => false,
                        :ispromotion => false,
                        :motion_info => motion_info(sengo, src, dst),
                    )
                    push!(ret, move)
                end
            end
        elseif gettebanmochigoma(kyokumen)
        end
    end
    ret
end

function islocal(koma::Koma)
    n = Integer(koma)
    n == 2 || 8 ≤ n ≤ 13 || 15 ≤ n ≤ 17
end

# function maptupleadd(x::Tuple{Integer,Integer}, ys::Vector{Tuple{Integer,Integer}})
#     [x .+ y for y in ys]
# end

# function isally(sengo::Sengo, masu::Masu)
#     sengo == Sengo(masu)
# end

# function isally(kyokumen::Kyokumen, masu::Masu)
#     isally(kyokumen.teban, masu)
# end

# function remove_ally(kyokumen::Kyokumen, positions::Vector{Tuple{Integer,Integer}})
#     ret = Tuple{Integer,Integer}[]
#     for position in positions
#         x, y = position
#         masu = kyokumen[x, y]
#         if !isally(kyokumen, masu)
#             push!(ret, position)
#         end
#     end
#     ret
# end

# # 二歩のチェック

# function check_notnifu(kyokumen::Kyokumen, move::Move)
#     true
# end

# function check_notnifu(kyokumen::Kyokumen, drop::Drop)
#     x, _ = to(drop)
#     if Koma(drop) == 歩兵 && Masu(歩兵, kyokumen.teban) ∈ kyokumen[x, :]
#         false
#     else
#         true
#     end
# end

# """
#     check_notnifu(kyokumen::Kyokumen, move::AbstractMove)

# Return `true` if the `move` on the `kyokumen` is not nifu, otherwise `false`.
# """
# check_notnifu

# # 行き所のない駒のチェック

# function forward_rank(sengo::Sengo, n::Integer)
#     if issente(sengo)
#         n
#     else
#         typeof(n)(10) - n
#     end
# end

# function check_notikidokorononaikoma(kyokumen::Kyokumen, drop::Drop)
#     koma = Drop(koma)
#     _, y = to(koma)
#     if koma == 歩兵
#         if forward_rank(sengo, y) == 1
#             false
#         else
#             true
#         end
#     elseif koma == 香車
#         if forward_rank(sengo, y) == 1
#             false
#         else
#             true
#         end
#     elseif koma == 桂馬
#         if forward_rank(sengo, y) ≤ 2
#             false
#         else
#             true
#         end
#     else
#         true
#     end
# end

# function check_notikidokorononaikoma(kyokumen::Kyokumen, move::Move)
#     koma = Koma(kyokumen, move)
#     sengo = kyokumen.teban
#     _, y = to(move)
#     if isnothing(koma)
#         error("Invalid move $move")
#     elseif move.ispromote
#         true
#     elseif koma == 歩兵
#         if forward_rank(sengo, y) == 1
#             false
#         else
#             true
#         end
#     elseif koma == 香車
#         if forward_rank(sengo, y) == 1
#             false
#         else
#             true
#         end
#     elseif koma == 桂馬
#         if forward_rank(sengo, y) ≤ 2
#             false
#         else
#             true
#         end
#     else
#         true
#     end
# end

# # 

# function 利き(kyokumen::Kyokumen, x::Integer, y::Integer)

# end

# function attack(kyokumen::Kyokumen, x::Integer, y::Integer)
#     masu = kyokumen[x, y]
#     ret = Tuple{Integer,Integer}[]
#     if isempty(masu)
#         ret
#     else
#         koma = Koma(masu)
#         sengo = Sengo(masu)
#         if islocal(koma)
#             if koma == 歩兵
#                 positions = maptupleadd((x, y), 歩兵の動き方(sengo))
#                 positions = remove_outofboard(positions)
#                 positions = remove_ally(kyokumen, positions)
#                 positions = remove_checked(kyokumen, positions)
#             elseif koma == 金将 || 成銀 || 成桂 || 成香 || と金
#                 positions = maptupleadd((x, y), 金将の動き方(sengo))
#                 positions = remove_outofboard(positions)
#             elseif koma == 桂馬
#             elseif koma == 銀将
#                 movement_ginshou()
#             elseif koma == 玉将
#                 ret = movement_gyoku()
#             end
#         else
#             if koma == 香車
#             elseif koma == 飛車
#             elseif koma == 角行
#             elseif koma == 竜王
#             elseif koma == 竜馬
#             end
#         end
#     end
# end