export JSA

module JSA

using ..Shogi
using Bijections

const COLOR_TO_JSA = Bijection(Dict(
    BLACK => "☗",
    WHITE => "☖",
))

const PIECE_TO_JSA = Bijection(Dict(
    PAWN => "歩",
    LANCE => "香",
    KNIGHT => "桂",
    SILVER => "銀",
    GOLD => "金",
    KING => "玉",
    BISHOP => "角",
    ROOK => "飛",
    PROMOTED_PAWN => "と",
    PROMOTED_LANCE => "成香",
    PROMOTED_KNIGHT => "成桂",
    PROMOTED_SILVER => "成銀",
    PROMOTED_BISHOP => "馬",
    PROMOTED_ROOK => "竜",
))

const FILE_TO_JSA = Bijection(Dict(
    FILE1 => "１",
    FILE2 => "２",
    FILE3 => "３",
    FILE4 => "４",
    FILE5 => "５",
    FILE6 => "６",
    FILE7 => "７",
    FILE8 => "８",
    FILE9 => "９",
))

const RANK_TO_JSA = Bijection(Dict(
    RANK1 => "１",
    RANK2 => "２",
    RANK3 => "３",
    RANK4 => "４",
    RANK5 => "５",
    RANK6 => "６",
    RANK7 => "７",
    RANK8 => "８",
    RANK9 => "９",
))

string(color::Color) = COLOR_TO_JSA[color]
string(piece::Piece) = PIECE_TO_JSA[piece]
string(file::File) = FILE_TO_JSA[file]
string(rank::Rank) = RANK_TO_JSA[rank]
string(coordinate::Coordinate) = string(File(coordinate)) * string(Rank(coordinate))

parse(::Type{Color}, str::AbstractString) = COLOR_TO_JSA(str)
parse(::Type{Piece}, str::AbstractString) = PIECE_TO_JSA(str)
parse(::Type{File}, str::AbstractString) = FILE_TO_JSA(str)
parse(::Type{Rank}, str::AbstractString) = RANK_TO_JSA(str)

function parse(::Type{Coordinate}, str::AbstractString)
    strs = split(str, "")
    length(strs) == 2 || error()
    file = parse(File, strs[1])
    rank = parse(Rank, strs[2])
    Coordinate(file, rank)
end

end # module