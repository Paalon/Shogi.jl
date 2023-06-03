export Move, NormalMove, DropMove
export domove!, generateMoves

abstract type Move end

struct NormalMove <: Move
    from::Coordinate
    to::Coordinate
    promotion::Bool
end

struct DropMove <: Move
    to::Coordinate
    piece::Piece
end

function Base.show(io::IO, move::NormalMove)
    print(io, USI.string(move))
end

function Base.show(io::IO, move::DropMove)
    print(io, USI.string(move))
end

function Move(from::Coordinate, to::Coordinate)
    NormalMove(from, to, false)
end

function Move(from::Coordinate, to::Coordinate, promotion::Bool)
    NormalMove(from, to, promotion)
end

function Move(to::Coordinate, piece::Piece)
    DropMove(to, piece)
end

function domove!(position::Position, move::NormalMove)
    square_from = position[move.from]
    square_to = position[move.to]
    if square_to != EMPTY
        piece_to = unpromote(Piece(square_to))
        hand = gethand(position, position.side)
        hand[piece_to] += 1
    end
    if move.promotion
        position[move.to] = Shogi.promote(square_from)
    else
        position[move.to] = square_from
    end
    position[move.from] = EMPTY
    position.side = next(position.side)
    position
end

function domove!(position::Position, move::DropMove)
    position[move.to] = Square(Color(position), move.piece)
    hand = gethand(position, position.side)
    hand[move.piece] -= 1
    position.side = next(position.side)
    position
end

function generatePseudoLegalMoves(position::Position)
    # todo: 打ち歩詰め、連続王手の千日手, 王手放置
    ret = Move[]
    side = Color(position)
    board_ally = Color(position.board) .== side
    board_opponent = Color(position.board) .== next(side)
    board_empty = Color(position.board) .== COLORLESS
    board_promotable = promotablebitboard(side)
    board_onerank = onerankbitboard(side)
    board_tworank = tworankbitboard(side)
    board_pawnfile = pawnfilebitboard(position.board, side)

    for x in 1:9
        for y in 1:9
            # generate normal moves
            if board_ally[x, y]
                piece = Piece(position[x, y])
                motion = PIECE_TO_MOTION[piece]
                # generate direct moves
                direct_targets = [[x, y] + [1, sign(side)] .* m for m in motion.direct]
                for direct_target in direct_targets
                    z0 = [x, y]
                    z1 = direct_target
                    if 1 ≤ z1[1] ≤ 9 && 1 ≤ z1[2] ≤ 9 && !board_ally[z1...]
                        if !(piece == PAWN && board_onerank[z1...]) && !(piece == KNIGHT && board_tworank[z1...])
                            push!(ret, Move(Coordinate(z0...), Coordinate(z1...)))
                        end
                        if (board_promotable[z0...] || board_promotable[z1...]) && ispromotable(Piece(position[z0...]))
                            push!(ret, Move(Coordinate(z0...), Coordinate(z1...), true))
                        end
                    end
                end
                # generate projective moves
                for p in motion.projective
                    for n in 1:8
                        z = [x, y] + n * [1, sign(side)] .* p
                        if 1 ≤ z[1] ≤ 9 && 1 ≤ z[2] ≤ 9 && !board_ally[z...]
                            if !(piece == LANCE && board_onerank[z...])
                                push!(ret, Move(Coordinate(x, y), Coordinate(z...)))
                            end
                            if (board_promotable[x, y] || board_promotable[z...]) && ispromotable(Piece(position[x, y]))
                                push!(ret, Move(Coordinate(x, y), Coordinate(z...), true))
                            end
                            if board_opponent[z...]
                                break
                            end
                        else
                            break
                        end
                    end
                end
            end
            # generate dropping moves
            if board_empty[x, y]
                hand = gethand(position, side)
                if hand[PAWN] > 0 && !board_onerank[x, y] && !board_pawnfile[x, y]
                    push!(ret, Move(Coordinate(x, y), PAWN))
                end
                if hand[LANCE] > 0 && !board_onerank[x, y]
                    push!(ret, Move(Coordinate(x, y), LANCE))
                end
                if hand[KNIGHT] > 0 && !board_tworank[x, y]
                    push!(ret, Move(Coordinate(x, y), KNIGHT))
                end
                for piece in [SILVER, GOLD, BISHOP, ROOK]
                    if hand[piece] > 0
                        push!(ret, Move(Coordinate(x, y), piece))
                    end
                end
            end
        end
    end
    ret
end

function generateMoves(position::Position)
    # todo: 打ち歩詰め、連続王手の千日手
    ret = Move[]
    moves = generatePseudoLegalMoves(position)
    for move in moves
        position_new = copy(position)
        domove!(position_new, move)
        kc = kingcoordinate(position_new, Color(position))
        moves_opp = generatePseudoLegalMoves(position_new)
        checked = false
        for move_opp in moves_opp
            
            if move_opp.to == kc
                checked = true
                break
            end
        end
        if !checked
            push!(ret, move)
        end
    end
    ret
end