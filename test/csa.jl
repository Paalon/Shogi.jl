@testset "CSA" begin
    @test CSA.string(BLACK) == "+"
    @test CSA.string(WHITE) == "-"

    @test CSA.string(PAWN) == "FU"
    @test CSA.string(LANCE) == "KY"
    @test CSA.string(KNIGHT) == "KE"
    @test CSA.string(SILVER) == "GI"
    @test CSA.string(GOLD) == "KI"

    @test CSA.string(BLACK_PAWN) == "+FU"
    @test CSA.string(WHITE_PAWN) == "-FU"

    @test CSA.string(COORDINATE34) == "34"
    @test CSA.string(COORDINATE79) == "79"
    @test CSA.string(COORDINATE81) == "81"

    @test CSA.parse(Color, "+") == BLACK
    @test CSA.parse(Color, "-") == WHITE

    @test CSA.parse(Piece, "FU") == PAWN
    @test CSA.parse(Piece, "KY") == LANCE
    @test CSA.parse(Piece, "KE") == KNIGHT
    @test CSA.parse(Piece, "GI") == SILVER
    @test CSA.parse(Piece, "KI") == GOLD
    @test CSA.parse(Piece, "OU") == KING
    @test CSA.parse(Piece, "KA") == BISHOP
    @test CSA.parse(Piece, "HI") == ROOK

    @test CSA.parse(Square, "+FU") == BLACK_PAWN
    @test CSA.parse(Square, "+KY") == BLACK_LANCE
    @test CSA.parse(Square, "+KE") == BLACK_KNIGHT
    @test CSA.parse(Square, "+GI") == BLACK_SILVER
    @test CSA.parse(Square, "+KI") == BLACK_GOLD
    @test CSA.parse(Square, "+OU") == BLACK_KING
    @test CSA.parse(Square, "+KA") == BLACK_BISHOP
    @test CSA.parse(Square, "+HI") == BLACK_ROOK

    @test CSA.parse(File, "1") == FILE1
    @test CSA.parse(File, "2") == FILE2
    @test CSA.parse(File, "3") == FILE3
    @test CSA.parse(File, "4") == FILE4
    @test CSA.parse(File, "5") == FILE5
    @test CSA.parse(File, "6") == FILE6
    @test CSA.parse(File, "7") == FILE7
    @test CSA.parse(File, "8") == FILE8
    @test CSA.parse(File, "9") == FILE9

    @test CSA.parse(Rank, "1") == RANK1
    @test CSA.parse(Rank, "2") == RANK2
    @test CSA.parse(Rank, "3") == RANK3
    @test CSA.parse(Rank, "4") == RANK4
    @test CSA.parse(Rank, "5") == RANK5
    @test CSA.parse(Rank, "6") == RANK6
    @test CSA.parse(Rank, "7") == RANK7
    @test CSA.parse(Rank, "8") == RANK8
    @test CSA.parse(Rank, "9") == RANK9

    @test CSA.string(Position()) == """
                                    P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
                                    P2 * -HI *  *  *  *  * -KA * 
                                    P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
                                    P4 *  *  *  *  *  *  *  *  * 
                                    P5 *  *  *  *  *  *  *  *  * 
                                    P6 *  *  *  *  *  *  *  *  * 
                                    P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
                                    P8 * +KA *  *  *  *  * +HI * 
                                    P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
                                    P+
                                    P-
                                    +
                                    """
end