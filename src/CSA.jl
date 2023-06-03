export CSA

module CSA

using ..Shogi
using Bijections

const COLOR_TO_CSA = Bijection(Dict(
    BLACK => "+",
    WHITE => "-",
))

const PIECE_TO_CSA = Bijection(Dict(
    PAWN => "FU",
    LANCE => "KY",
    KNIGHT => "KE",
    SILVER => "GI",
    GOLD => "KI",
    KING => "OU",
    BISHOP => "KA",
    ROOK => "HI",
    PROMOTED_PAWN => "TO",
    PROMOTED_LANCE => "NY",
    PROMOTED_KNIGHT => "NK",
    PROMOTED_SILVER => "NG",
    PROMOTED_BISHOP => "UM",
    PROMOTED_ROOK => "RY",
))

const SQUARE_TO_CSA = Bijection(Dict(
    EMPTY => " * ",
    BLACK_PAWN => "+FU",
    BLACK_LANCE => "+KY",
    BLACK_KNIGHT => "+KE",
    BLACK_SILVER => "+GI",
    BLACK_GOLD => "+KI",
    BLACK_KING => "+OU",
    BLACK_BISHOP => "+KA",
    BLACK_ROOK => "+HI",
    BLACK_PROMOTED_PAWN => "+TO",
    BLACK_PROMOTED_LANCE => "+NY",
    BLACK_PROMOTED_KNIGHT => "+NK",
    BLACK_PROMOTED_SILVER => "+NG",
    BLACK_PROMOTED_BISHOP => "+UM",
    BLACK_PROMOTED_ROOK => "+RY",
    WHITE_PAWN => "-FU",
    WHITE_LANCE => "-KY",
    WHITE_KNIGHT => "-KE",
    WHITE_SILVER => "-GI",
    WHITE_GOLD => "-KI",
    WHITE_KING => "-OU",
    WHITE_BISHOP => "-KA",
    WHITE_ROOK => "-HI",
    WHITE_PROMOTED_PAWN => "-TO",
    WHITE_PROMOTED_LANCE => "-NY",
    WHITE_PROMOTED_KNIGHT => "-NK",
    WHITE_PROMOTED_SILVER => "-NG",
    WHITE_PROMOTED_BISHOP => "-UM",
    WHITE_PROMOTED_ROOK => "-RY",
))

const FILE_TO_CSA = Bijection(Dict(
    FILE1 => "1",
    FILE2 => "2",
    FILE3 => "3",
    FILE4 => "4",
    FILE5 => "5",
    FILE6 => "6",
    FILE7 => "7",
    FILE8 => "8",
    FILE9 => "9",
))

const RANK_TO_CSA = Bijection(Dict(
    RANK1 => "1",
    RANK2 => "2",
    RANK3 => "3",
    RANK4 => "4",
    RANK5 => "5",
    RANK6 => "6",
    RANK7 => "7",
    RANK8 => "8",
    RANK9 => "9",
))

string(color::Color) = COLOR_TO_CSA[color]
string(piece::Piece) = PIECE_TO_CSA[piece]
string(square::Square) = SQUARE_TO_CSA[square]
string(file::File) = FILE_TO_CSA[file]
string(rank::Rank) = RANK_TO_CSA[rank]
string(coordinate::Coordinate) = string(File(coordinate)) * string(Rank(coordinate))

parse(::Type{Color}, str::AbstractString) = COLOR_TO_CSA(str)
parse(::Type{Piece}, str::AbstractString) = PIECE_TO_CSA(str)
parse(::Type{Square}, str::AbstractString) = SQUARE_TO_CSA(str)
parse(::Type{File}, str::AbstractString) = FILE_TO_CSA(str)
parse(::Type{Rank}, str::AbstractString) = RANK_TO_CSA(str)

function parse(::Type{Coordinate}, str::AbstractString)
    strs = split(str, "")
    length(strs) == 2 || error()
    file = parse(File, strs[1])
    rank = parse(Rank, strs[2])
    Coordinate(file, rank)
end

function string(board::Board)
    ret = ""
    for rank in 1:9
        ret *= "P$rank"
        for file in 9:-1:1
            ret *= CSA.string(board[file, rank])
        end
        ret *= "\n"
    end
    ret
end

function string(hand::Hand, side::Color)
    ret = "P$(string(side))"
    for piece in [ROOK, BISHOP, GOLD, SILVER, KNIGHT, LANCE, PAWN]
        for _ in 1:hand[piece]
            ret *= "00"
            ret *= string(piece)
        end
    end
    ret *= "\n"
end

function string(position::Position)
    ret = string(position.board)
    ret *= string(position.hands[1], BLACK)
    ret *= string(position.hands[2], WHITE)
    ret *= string(position.side)
    ret *= "\n"
end

# function parse(::Type{Position}, str::AbstractString)
#     position = Position(EmptyBoard(), (Hand(), Hand()), BLACK)
#     lines = split(string, "\n")
#     for line in lines
#         if line == "+"
#             position.side = BLACK
#         elseif line == "-"
#             position.side = WHITE
#         elseif line >= 2
#             if line[1:2] == "PI"
#                 position = Position()

#             elseif line[1:2] == ""
#         else
#             throw(erorr("Invalid CSA"))
#         end
#     end
# end

end # module