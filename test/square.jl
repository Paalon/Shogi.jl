@testset "Square" begin
    @test Square(COLORLESS, PIECELESS) == EMPTY
    @test Square(BLACK, PAWN) == BLACK_PAWN
    @test Square(BLACK, LANCE) == BLACK_LANCE
    @test Square(BLACK, KNIGHT) == BLACK_KNIGHT
    @test Square(BLACK, SILVER) == BLACK_SILVER
    @test Square(BLACK, GOLD) == BLACK_GOLD
    @test Square(BLACK, BISHOP) == BLACK_BISHOP
    @test Square(BLACK, ROOK) == BLACK_ROOK
    @test Square(BLACK, KING) == BLACK_KING
    @test Square(BLACK, PROMOTED_PAWN) == BLACK_PROMOTED_PAWN
    @test Square(BLACK, PROMOTED_LANCE) == BLACK_PROMOTED_LANCE
    @test Square(BLACK, PROMOTED_KNIGHT) == BLACK_PROMOTED_KNIGHT
    @test Square(BLACK, PROMOTED_SILVER) == BLACK_PROMOTED_SILVER
    @test Square(BLACK, PROMOTED_BISHOP) == BLACK_PROMOTED_BISHOP
    @test Square(BLACK, PROMOTED_ROOK) == BLACK_PROMOTED_ROOK
    @test Square(WHITE, PAWN) == WHITE_PAWN
    @test Square(WHITE, LANCE) == WHITE_LANCE
    @test Square(WHITE, KNIGHT) == WHITE_KNIGHT
    @test Square(WHITE, SILVER) == WHITE_SILVER
    @test Square(WHITE, GOLD) == WHITE_GOLD
    @test Square(WHITE, BISHOP) == WHITE_BISHOP
    @test Square(WHITE, ROOK) == WHITE_ROOK
    @test Square(WHITE, KING) == WHITE_KING
    @test Square(WHITE, PROMOTED_PAWN) == WHITE_PROMOTED_PAWN
    @test Square(WHITE, PROMOTED_LANCE) == WHITE_PROMOTED_LANCE
    @test Square(WHITE, PROMOTED_KNIGHT) == WHITE_PROMOTED_KNIGHT
    @test Square(WHITE, PROMOTED_SILVER) == WHITE_PROMOTED_SILVER
    @test Square(WHITE, PROMOTED_BISHOP) == WHITE_PROMOTED_BISHOP
    @test Square(WHITE, PROMOTED_ROOK) == WHITE_PROMOTED_ROOK

    @test Color(EMPTY) == COLORLESS
    @test Color(BLACK_PAWN) == BLACK
    @test Color(BLACK_LANCE) == BLACK
    @test Color(BLACK_KNIGHT) == BLACK
    @test Color(BLACK_SILVER) == BLACK
    @test Color(BLACK_GOLD) == BLACK
    @test Color(BLACK_BISHOP) == BLACK
    @test Color(BLACK_ROOK) == BLACK
    @test Color(BLACK_KING) == BLACK
    @test Color(BLACK_PROMOTED_PAWN) == BLACK
    @test Color(BLACK_PROMOTED_LANCE) == BLACK
    @test Color(BLACK_PROMOTED_KNIGHT) == BLACK
    @test Color(BLACK_PROMOTED_SILVER) == BLACK
    @test Color(BLACK_PROMOTED_BISHOP) == BLACK
    @test Color(BLACK_PROMOTED_ROOK) == BLACK
    @test Color(WHITE_PAWN) == WHITE
    @test Color(WHITE_LANCE) == WHITE
    @test Color(WHITE_KNIGHT) == WHITE
    @test Color(WHITE_SILVER) == WHITE
    @test Color(WHITE_GOLD) == WHITE
    @test Color(WHITE_BISHOP) == WHITE
    @test Color(WHITE_ROOK) == WHITE
    @test Color(WHITE_KING) == WHITE
    @test Color(WHITE_PROMOTED_PAWN) == WHITE
    @test Color(WHITE_PROMOTED_LANCE) == WHITE
    @test Color(WHITE_PROMOTED_KNIGHT) == WHITE
    @test Color(WHITE_PROMOTED_SILVER) == WHITE
    @test Color(WHITE_PROMOTED_BISHOP) == WHITE
    @test Color(WHITE_PROMOTED_ROOK) == WHITE

    @test Piece(EMPTY) == PIECELESS
    @test Piece(BLACK_PAWN) == PAWN
    @test Piece(BLACK_LANCE) == LANCE
    @test Piece(BLACK_KNIGHT) == KNIGHT
    @test Piece(BLACK_SILVER) == SILVER
    @test Piece(BLACK_GOLD) == GOLD
    @test Piece(BLACK_BISHOP) == BISHOP
    @test Piece(BLACK_ROOK) == ROOK
    @test Piece(BLACK_KING) == KING
    @test Piece(BLACK_PROMOTED_PAWN) == PROMOTED_PAWN
    @test Piece(BLACK_PROMOTED_LANCE) == PROMOTED_LANCE
    @test Piece(BLACK_PROMOTED_KNIGHT) == PROMOTED_KNIGHT
    @test Piece(BLACK_PROMOTED_SILVER) == PROMOTED_SILVER
    @test Piece(BLACK_PROMOTED_BISHOP) == PROMOTED_BISHOP
    @test Piece(BLACK_PROMOTED_ROOK) == PROMOTED_ROOK
    @test Piece(WHITE_PAWN) == PAWN
    @test Piece(WHITE_LANCE) == LANCE
    @test Piece(WHITE_KNIGHT) == KNIGHT
    @test Piece(WHITE_SILVER) == SILVER
    @test Piece(WHITE_GOLD) == GOLD
    @test Piece(WHITE_BISHOP) == BISHOP
    @test Piece(WHITE_ROOK) == ROOK
    @test Piece(WHITE_KING) == KING
    @test Piece(WHITE_PROMOTED_PAWN) == PROMOTED_PAWN
    @test Piece(WHITE_PROMOTED_LANCE) == PROMOTED_LANCE
    @test Piece(WHITE_PROMOTED_KNIGHT) == PROMOTED_KNIGHT
    @test Piece(WHITE_PROMOTED_SILVER) == PROMOTED_SILVER
    @test Piece(WHITE_PROMOTED_BISHOP) == PROMOTED_BISHOP
    @test Piece(WHITE_PROMOTED_ROOK) == PROMOTED_ROOK

    @test rotate(EMPTY) == EMPTY
    @test rotate(BLACK_PAWN) == WHITE_PAWN
    @test rotate(BLACK_LANCE) == WHITE_LANCE
    @test rotate(BLACK_KNIGHT) == WHITE_KNIGHT
    @test rotate(BLACK_SILVER) == WHITE_SILVER
    @test rotate(BLACK_GOLD) == WHITE_GOLD
    @test rotate(BLACK_KING) == WHITE_KING
    @test rotate(BLACK_BISHOP) == WHITE_BISHOP
    @test rotate(BLACK_ROOK) == WHITE_ROOK
    @test rotate(BLACK_PROMOTED_PAWN) == WHITE_PROMOTED_PAWN
    @test rotate(BLACK_PROMOTED_LANCE) == WHITE_PROMOTED_LANCE
    @test rotate(BLACK_PROMOTED_KNIGHT) == WHITE_PROMOTED_KNIGHT
    @test rotate(BLACK_PROMOTED_SILVER) == WHITE_PROMOTED_SILVER
    @test rotate(BLACK_PROMOTED_BISHOP) == WHITE_PROMOTED_BISHOP
    @test rotate(BLACK_PROMOTED_ROOK) == WHITE_PROMOTED_ROOK
    @test rotate(WHITE_PAWN) == BLACK_PAWN
    @test rotate(WHITE_LANCE) == BLACK_LANCE
    @test rotate(WHITE_KNIGHT) == BLACK_KNIGHT
    @test rotate(WHITE_SILVER) == BLACK_SILVER
    @test rotate(WHITE_GOLD) == BLACK_GOLD
    @test rotate(WHITE_KING) == BLACK_KING
    @test rotate(WHITE_BISHOP) == BLACK_BISHOP
    @test rotate(WHITE_ROOK) == BLACK_ROOK
    @test rotate(WHITE_PROMOTED_PAWN) == BLACK_PROMOTED_PAWN
    @test rotate(WHITE_PROMOTED_LANCE) == BLACK_PROMOTED_LANCE
    @test rotate(WHITE_PROMOTED_KNIGHT) == BLACK_PROMOTED_KNIGHT
    @test rotate(WHITE_PROMOTED_SILVER) == BLACK_PROMOTED_SILVER
    @test rotate(WHITE_PROMOTED_BISHOP) == BLACK_PROMOTED_BISHOP
    @test rotate(WHITE_PROMOTED_ROOK) == BLACK_PROMOTED_ROOK
end