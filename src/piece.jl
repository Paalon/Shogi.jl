export Piece
export ispromotable, promote, isunpromotable, unpromote

@enum Piece::Int8 begin
    PIECELESS = 0
    PAWN = 1
    LANCE = 2
    KNIGHT = 3
    SILVER = 4
    BISHOP = 5
    ROOK = 6
    GOLD = 7
    KING = 8
    PROMOTED_PAWN = 8 + 1
    PROMOTED_LANCE = 8 + 2
    PROMOTED_KNIGHT = 8 + 3
    PROMOTED_SILVER = 8 + 4
    PROMOTED_BISHOP = 8 + 5
    PROMOTED_ROOK = 8 + 6
end

@exportinstances Piece

function ispromotable(piece::Piece)
    1 <= Integer(piece) <= 6
end

function isunpromotable(piece::Piece)
    9 <= Integer(piece) <= 14
end

function promote(piece::Piece)
    if ispromotable(piece)
        Piece(Integer(piece) + 8)
    else
        piece
    end
end

function unpromote(piece::Piece)
    if isunpromotable(piece)
        Piece(Integer(piece) - 8)
    else
        piece
    end
end