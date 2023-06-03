using StaticArrays

export Board, EmptyBoard

export Bitboard

mutable struct Board
    board::MMatrix{9, 9, Square}
end

Base.:(==)(a::Board, b::Board) = a.board == b.board

Base.copy(board::Board) = Board(copy(board.board))

Base.show(io::IO, board::Board) = print(io, CSA.string(board))

EmptyBoard() = Board(@MMatrix(fill(EMPTY, 9, 9)))

function rotate(board::Board)
    Board(rot180(rotate.(board.board)))
end

Base.getindex(board::Board, inds...) = getindex(board.board, inds...)
Base.setindex!(board::Board, X, inds...) = setindex!(board.board, X, inds...)

Base.getindex(board::Board, inds::Coordinate) = getindex(board.board, Tuple{Int8, Int8}(inds)...)
Base.setindex!(board::Board, X, inds::Coordinate) = setindex!(board.board, X, Tuple{Int8, Int8}(inds)...)

function Board()
    board = EmptyBoard()
    board[1:9, 1] = [WHITE_LANCE, WHITE_KNIGHT, WHITE_SILVER, WHITE_GOLD, WHITE_KING, WHITE_GOLD, WHITE_SILVER, WHITE_KNIGHT, WHITE_LANCE]
    board[[8, 2], 2] = [WHITE_ROOK, WHITE_BISHOP]
    board[1:9, 3] = fill(WHITE_PAWN, 9)
    board[1:9, 7:9] = rotate.(board[9:-1:1, 3:-1:1])
    board
end

Base.sign(board::Board) = sign.(board.board)
Color(board::Board) = Color.(board.board)

function attackedbitboard(color::Color)
end

function promotablebitboard(color::Color)
    if isblack(color)
        MMatrix{9, 9, Bool}([
            1 1 1 0 0 0 0 0 0
            1 1 1 0 0 0 0 0 0
            1 1 1 0 0 0 0 0 0
            1 1 1 0 0 0 0 0 0
            1 1 1 0 0 0 0 0 0
            1 1 1 0 0 0 0 0 0
            1 1 1 0 0 0 0 0 0
            1 1 1 0 0 0 0 0 0
            1 1 1 0 0 0 0 0 0
        ])
    else
        MMatrix{9, 9, Bool}([
            0 0 0 0 0 0 1 1 1
            0 0 0 0 0 0 1 1 1
            0 0 0 0 0 0 1 1 1
            0 0 0 0 0 0 1 1 1
            0 0 0 0 0 0 1 1 1
            0 0 0 0 0 0 1 1 1
            0 0 0 0 0 0 1 1 1
            0 0 0 0 0 0 1 1 1
            0 0 0 0 0 0 1 1 1
        ])
    end
end

function onerankbitboard(color::Color)
    if isblack(color)
        MMatrix{9,9,Bool}([
            1 0 0 0 0 0 0 0 0
            1 0 0 0 0 0 0 0 0
            1 0 0 0 0 0 0 0 0
            1 0 0 0 0 0 0 0 0
            1 0 0 0 0 0 0 0 0
            1 0 0 0 0 0 0 0 0
            1 0 0 0 0 0 0 0 0
            1 0 0 0 0 0 0 0 0
            1 0 0 0 0 0 0 0 0
        ])
    else
        MMatrix{9,9,Bool}([
            0 0 0 0 0 0 0 0 1
            0 0 0 0 0 0 0 0 1
            0 0 0 0 0 0 0 0 1
            0 0 0 0 0 0 0 0 1
            0 0 0 0 0 0 0 0 1
            0 0 0 0 0 0 0 0 1
            0 0 0 0 0 0 0 0 1
            0 0 0 0 0 0 0 0 1
            0 0 0 0 0 0 0 0 1
        ])
    end
end

function tworankbitboard(color::Color)
    if isblack(color)
        MMatrix{9,9,Bool}([
            1 1 0 0 0 0 0 0 0
            1 1 0 0 0 0 0 0 0
            1 1 0 0 0 0 0 0 0
            1 1 0 0 0 0 0 0 0
            1 1 0 0 0 0 0 0 0
            1 1 0 0 0 0 0 0 0
            1 1 0 0 0 0 0 0 0
            1 1 0 0 0 0 0 0 0
            1 1 0 0 0 0 0 0 0
        ])
    else
        MMatrix{9,9,Bool}([
            0 0 0 0 0 0 0 1 1
            0 0 0 0 0 0 0 1 1
            0 0 0 0 0 0 0 1 1
            0 0 0 0 0 0 0 1 1
            0 0 0 0 0 0 0 1 1
            0 0 0 0 0 0 0 1 1
            0 0 0 0 0 0 0 1 1
            0 0 0 0 0 0 0 1 1
            0 0 0 0 0 0 0 1 1
        ])
    end
end

function pawnfilebitboard(board::Board, color::Color)
    ret = MMatrix{9,9,Bool}(undef)
    b = board.board .== Square(color, PAWN)
    for i in 1:9
        if sum(b[i, :]) > 0
            ret[i, :] .= 1
        else
            ret[i, :] .= 0
        end
    end
    ret
end

# function pawn_attack(board::Board, color::Color)
#     ret = MMatrix{9,9,Bool}(undef)
#     for x in 1:9
#         for y in 1:9
#             square = board[x, y]
#             if Color(square) == color
#                 piece = Piece(square)
#             end
#         end
#     end
# end

struct Bitboard
    b::UInt128
end

function Base.show(io::IO, bb::Bitboard)
    bs = bitstring(bb)
    for x in 0:8
        for y in 8:-1:0
            print(io, bs[end-y*9-x], " ")
        end
        println(io)
    end
end

Base.bitstring(bb::Bitboard) = bitstring(bb.b)
Base.:<<(bb::Bitboard, n) = Bitboard(bb.b << n)
Base.:>>(bb::Bitboard, n) = Bitboard(bb.b >> n)
Base.:&(x::Bitboard, y::Bitboard) = Bitboard(x.b & y.b)
Base.:|(x::Bitboard, y::Bitboard) = Bitboard(x.b | y.b)
Base.xor(x::Bitboard, y::Bitboard) = Bitboard(xor(x.b, y.b))
# Base.getindex(bb::Bitboard, inds...)
# Base.setindex!(bb::Bitboard, X, inds...)

const BLACK_ONE_RANK_BITBOARD = Bitboard(0x00000000000001008040201008040201)
const WHITE_ONE_RANK_BITBOARD = BLACK_ONE_RANK_BITBOARD << 8
const BLACK_TWO_RANK_BITBOARD = BLACK_ONE_RANK_BITBOARD | BLACK_ONE_RANK_BITBOARD << 1
const WHITE_TWO_RANK_BITBOARD = BLACK_TWO_RANK_BITBOARD << 7
const BLACK_PROMOTABLE_BITBOARD = BLACK_ONE_RANK_BITBOARD | BLACK_ONE_RANK_BITBOARD << 1 | BLACK_ONE_RANK_BITBOARD << 2
const WHITE_PROMOTABLE_BITBOARD = BLACK_PROMOTABLE_BITBOARD << 6

# function pawn_attack(bb::Bitboard, color::Color)
#     if color == BLACK
#         bb >> 1
#     elseif color == WHITE
#         bb << 1
#     end
# end