export USI

module USI

using ..Shogi
using Bijections

const COLOR_TO_USI = Bijection(Dict(
    BLACK => "b",
    WHITE => "w",
))

const PIECE_TO_USI = Bijection(Dict(
    PAWN => "P",
    LANCE => "L",
    KNIGHT => "N",
    SILVER => "S",
    GOLD => "G",
    KING => "K",
    BISHOP => "B",
    ROOK => "R",
    PROMOTED_PAWN => "+P",
    PROMOTED_LANCE => "+L",
    PROMOTED_KNIGHT => "+N",
    PROMOTED_SILVER => "+S",
    PROMOTED_BISHOP => "+B",
    PROMOTED_ROOK => "+R",
))

const SQUARE_TO_USI = Bijection(Dict(
    EMPTY => "1",
    BLACK_PAWN => "P",
    BLACK_LANCE => "L",
    BLACK_KNIGHT => "N",
    BLACK_SILVER => "S",
    BLACK_GOLD => "G",
    BLACK_KING => "K",
    BLACK_BISHOP => "B",
    BLACK_ROOK => "R",
    BLACK_PROMOTED_PAWN => "+P",
    BLACK_PROMOTED_LANCE => "+L",
    BLACK_PROMOTED_KNIGHT => "+N",
    BLACK_PROMOTED_SILVER => "+S",
    BLACK_PROMOTED_BISHOP => "+B",
    BLACK_PROMOTED_ROOK => "+R",
    WHITE_PAWN => "p",
    WHITE_LANCE => "l",
    WHITE_KNIGHT => "n",
    WHITE_SILVER => "s",
    WHITE_GOLD => "g",
    WHITE_KING => "k",
    WHITE_BISHOP => "b",
    WHITE_ROOK => "r",
    WHITE_PROMOTED_PAWN => "+p",
    WHITE_PROMOTED_LANCE => "+l",
    WHITE_PROMOTED_KNIGHT => "+n",
    WHITE_PROMOTED_SILVER => "+s",
    WHITE_PROMOTED_BISHOP => "+b",
    WHITE_PROMOTED_ROOK => "+r",
))

const FILE_TO_USI = Bijection(Dict(
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

const RANK_TO_USI = Bijection(Dict(
    RANK1 => "a",
    RANK2 => "b",
    RANK3 => "c",
    RANK4 => "d",
    RANK5 => "e",
    RANK6 => "f",
    RANK7 => "g",
    RANK8 => "h",
    RANK9 => "i",
))

string(color::Color) = COLOR_TO_USI[color]
string(piece::Piece) = PIECE_TO_USI[piece]
string(square::Square) = SQUARE_TO_USI[square]
string(file::File) = FILE_TO_USI[file]
string(rank::Rank) = RANK_TO_USI[rank]
string(coordinate::Coordinate) = string(File(coordinate)) * string(Rank(coordinate))

parse(::Type{Color}, str::AbstractString) = COLOR_TO_USI(str)
parse(::Type{Piece}, str::AbstractString) = PIECE_TO_USI(str)
parse(::Type{Square}, str::AbstractString) = SQUARE_TO_USI(str)
parse(::Type{File}, str::AbstractString) = FILE_TO_USI(str)
parse(::Type{Rank}, str::AbstractString) = RANK_TO_USI(str)

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
        ret *= ""
        for file in 9:-1:1
            ret *= USI.string(board[file, rank])
        end
        if rank != 9
            ret *= "/"
        end
    end

    replace(
        ret,
        "111111111" => "9",
        "11111111" => "8",
        "1111111" => "7",
        "111111" => "6",
        "11111" => "5",
        "1111" => "4",
        "111" => "3",
        "11" => "2",
    )
end

function string(hand::Hand, color::Color)
    ret = ""
    for piece in [ROOK, BISHOP, GOLD, SILVER, KNIGHT, LANCE, PAWN]
        n = hand[piece]
        if n == 1
            ret *= string(Square(color, piece))
        elseif n > 1
            ret *= n
            ret *= string(Square(color, piece))
        end
    end
    ret
end

function string(position::Position; ply=true)
    ret = string(position.board)
    ret *= " "
    ret *= string(position.side)
    ret *= " "
    str = string(position.hands[1], BLACK) * string(position.hands[2], WHITE)
    if str == ""
        str = "-"
    end
    ret *= str
    if ply
        ret *= " 1"
    end
    ret
end

function parse(::Type{Board}, str::AbstractString)
    str = replace(
        str,
        "9" => "111111111",
        "8" => "11111111",
        "7" => "1111111",
        "6" => "111111",
        "5" => "11111",
        "4" => "1111",
        "3" => "111",
        "2" => "11",
    )
    rows = split(str, "/")
    board = EmptyBoard()
    for (rank, row) in enumerate(rows)
        rank > 9 && throw(error("Invalid SFEN: $str"))
        file = 9
        ispromoted = false
        for c in row
            if c == '+'
                ispromoted = true
            else
                square = parse(Square, Base.string(c))
                color = Color(square)
                piece = Piece(square)
                if ispromoted
                    if ispromotable(piece)
                        piece = Shogi.promote(piece)
                    else
                        throw(error("Invalid SFEN: not promotable but promoted"))
                    end
                end
                board[file, rank] = Square(color, piece)
                ispromoted = false
                file -= 1
            end
        end
    end
    board
end

function parse(::Type{Tuple{Hand, Hand}}, str::AbstractString)
    blackhand = Hand()
    whitehand = Hand()
    if str == "-"
    elseif isnothing(match(r"^(?:[0-9]*[PLNSGBRplnsgbr])*$", str))
        throw(error("Invalid SFEN"))
    else
        for m in eachmatch(r"(?:[0-9]*[PLNSGBRplnsgbr])", str)
            if length(m.match) > 1
                n_str = m.match[1:end-1]
                n = Base.parse(Int, n_str)
                square = parse(Square, Base.string(m.match[end]))
                piece = Piece(square)
                color = Color(square)
                if isblack(color)
                    blackhand[piece] = n
                else
                    whitehand[piece] = n
                end
            else
                n = 1
                square = parse(Square, m.match)
                piece = Piece(square)
                color = Color(square)
                if isblack(color)
                    blackhand[piece] = n
                else
                    whitehand[piece] = n
                end
            end
        end
    end
    blackhand, whitehand
end

function parse(::Type{Position}, str::AbstractString; ply=true)
    strs = split(str, " ")
    if ply
        length(strs) == 4 || error("Invalid SFEN: $str")
        board = parse(Board, strs[1])
        color = parse(Color, strs[2])
        hands = parse(Tuple{Hand, Hand}, strs[3])
        isnothing(tryparse(Int, strs[4])) && throw(error("Invalid SFEN, ply number"))
        Position(board, hands, color)
    else
        length(strs) == 3 || error("Invalid sfen: $str")
        board = parse(Board, strs[1])
        color = parse(Color, strs[2])
        hands = parse(Tuple{Hand, Hand}, strs[3])
        Position(board, hands, color)
    end
end

function string(move::NormalMove)
    from = string(move.from)
    to = string(move.to)
    promotion = if move.promotion
        "+"
    else
        ""
    end
    "$from$to$promotion"
end

function string(drop::DropMove)
    piece = string(drop.piece)
    to = string(drop.to)
    "$piece*$to"
end

function parse(::Type{Move}, str::AbstractString)
    if str == "none"
        nothing
    elseif length(str) == 4 && str[2] == '*'
        to = parse(Coordinate, str[3:4])
        piece = parse(Piece, str[1:1])
        Move(to, piece)
    elseif length(str) == 4
        from = parse(Coordinate, str[1:2])
        to = parse(Coordinate, str[3:4])
        Move(from, to)
    elseif length(str) == 5 && str[5] == '+'
        from = parse(Coordinate, str[1:2])
        to = parse(Coordinate, str[3:4])
        promotion = true
        Move(from, to, promotion)
    else
        throw(error("Invalid USI move string"))
    end
end

end # module