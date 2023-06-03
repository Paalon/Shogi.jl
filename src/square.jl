export Square

export rotate

using Bijections

@enum Square::Int8 begin
    EMPTY = 0
    BLACK_PAWN = 0 + 1
    BLACK_LANCE = 0 + 2
    BLACK_KNIGHT = 0 + 3
    BLACK_SILVER = 0 + 4
    BLACK_BISHOP = 0 + 5
    BLACK_ROOK = 0 + 6
    BLACK_GOLD = 0 + 7
    BLACK_KING = 0 + 8
    BLACK_PROMOTED_PAWN = 8 + 1
    BLACK_PROMOTED_LANCE = 8 + 2
    BLACK_PROMOTED_KNIGHT = 8 + 3
    BLACK_PROMOTED_SILVER = 8 + 4
    BLACK_PROMOTED_BISHOP = 8 + 5
    BLACK_PROMOTED_ROOK = 8 + 6
    WHITE_PAWN = 0 - 1
    WHITE_LANCE = 0 - 2
    WHITE_KNIGHT = 0 - 3
    WHITE_SILVER = 0 - 4
    WHITE_BISHOP = 0 - 5
    WHITE_ROOK = 0 - 6
    WHITE_GOLD = 0 - 7
    WHITE_KING = 0 - 8
    WHITE_PROMOTED_PAWN = -8 - 1
    WHITE_PROMOTED_LANCE = -8 - 2
    WHITE_PROMOTED_KNIGHT = -8 - 3
    WHITE_PROMOTED_SILVER = -8 - 4
    WHITE_PROMOTED_BISHOP = -8 - 5
    WHITE_PROMOTED_ROOK = -8 - 6
end

@exportinstances Square

Square(color::Color, piece::Piece) = Square(sign(color) * Integer(piece))

function Color(square::Square)
    Color(sign(Integer(square)))
end

function Piece(square::Square)
    Piece(abs(Integer(square)))
end

rotate(square::Square) = Square(-Integer(square))

Base.sign(square::Square) = sign(Integer(square))

promote(square::Square) = Square(sign(square) * 8 + Integer(square))

const SQUARE_TO_STRING = Bijection(Dict(
    EMPTY => " ・",
    BLACK_PAWN => "^歩",
    BLACK_LANCE => "^香",
    BLACK_KNIGHT => "^桂",
    BLACK_SILVER => "^銀",
    BLACK_GOLD => "^金",
    BLACK_KING => "^玉",
    BLACK_BISHOP => "^角",
    BLACK_ROOK => "^飛",
    BLACK_PROMOTED_PAWN => "^と",
    BLACK_PROMOTED_LANCE => "^杏",
    BLACK_PROMOTED_KNIGHT => "^圭",
    BLACK_PROMOTED_SILVER => "^全",
    BLACK_PROMOTED_BISHOP => "^馬",
    BLACK_PROMOTED_ROOK => "^竜",
    WHITE_PAWN => "v歩",
    WHITE_LANCE => "v香",
    WHITE_KNIGHT => "v桂",
    WHITE_SILVER => "v銀",
    WHITE_GOLD => "v金",
    WHITE_KING => "v玉",
    WHITE_BISHOP => "v角",
    WHITE_ROOK => "v飛",
    WHITE_PROMOTED_PAWN => "vと",
    WHITE_PROMOTED_LANCE => "v杏",
    WHITE_PROMOTED_KNIGHT => "v圭",
    WHITE_PROMOTED_SILVER => "v全",
    WHITE_PROMOTED_BISHOP => "v馬",
    WHITE_PROMOTED_ROOK => "v竜",
))