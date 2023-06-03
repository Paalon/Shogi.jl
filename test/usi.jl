@testset "USI" begin

    @test USI.string(PAWN) == "P"

    @test USI.string(BLACK_PAWN) == "P"
    @test USI.string(WHITE_PAWN) == "p"
    @test USI.string(BLACK_PROMOTED_PAWN) == "+P"
    @test USI.string(WHITE_PROMOTED_PAWN) == "+p"

    @test USI.parse(Square, "P") == BLACK_PAWN
    @test USI.parse(Square, "p") == WHITE_PAWN

    @test USI.string(FILE1) == "1"
    @test USI.string(FILE2) == "2"
    @test USI.string(FILE3) == "3"
    @test USI.string(FILE4) == "4"
    @test USI.string(FILE5) == "5"
    @test USI.string(FILE6) == "6"
    @test USI.string(FILE7) == "7"
    @test USI.string(FILE8) == "8"
    @test USI.string(FILE9) == "9"

    @test USI.string(RANK1) == "a"
    @test USI.string(RANK2) == "b"
    @test USI.string(RANK3) == "c"
    @test USI.string(RANK4) == "d"
    @test USI.string(RANK5) == "e"
    @test USI.string(RANK6) == "f"
    @test USI.string(RANK7) == "g"
    @test USI.string(RANK8) == "h"
    @test USI.string(RANK9) == "i"

    @test USI.string(COORDINATE77) == "7g"

    @test USI.parse(File, "1") == FILE1
    @test USI.parse(File, "2") == FILE2
    @test USI.parse(File, "3") == FILE3
    @test USI.parse(File, "4") == FILE4
    @test USI.parse(File, "5") == FILE5
    @test USI.parse(File, "6") == FILE6
    @test USI.parse(File, "7") == FILE7
    @test USI.parse(File, "8") == FILE8
    @test USI.parse(File, "9") == FILE9

    @test USI.parse(Rank, "a") == RANK1
    @test USI.parse(Rank, "b") == RANK2
    @test USI.parse(Rank, "c") == RANK3
    @test USI.parse(Rank, "d") == RANK4
    @test USI.parse(Rank, "e") == RANK5
    @test USI.parse(Rank, "f") == RANK6
    @test USI.parse(Rank, "g") == RANK7
    @test USI.parse(Rank, "h") == RANK8
    @test USI.parse(Rank, "i") == RANK9

    @test USI.parse(Coordinate, "7g") == COORDINATE77

    # Board

    @test USI.parse(Board, "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL") == Board()

    # Hand

    @test USI.parse(Tuple{Hand, Hand}, "-") == (Hand(), Hand())
    w = Hand()
    w[PAWN] = 18
    w[LANCE] = 4
    w[KNIGHT] = 4
    w[SILVER] = 4
    w[GOLD] = 4
    w[BISHOP] = 2
    w[ROOK] = 2
    @test USI.parse(Tuple{Hand, Hand}, "2r2b4g4s4n4l18p") == (Hand(), w)

    b, w = Hand(), Hand()
    b[SILVER] = 1
    w[BISHOP] = 1
    w[GOLD] = 1
    w[KNIGHT] = 1
    w[PAWN] = 3
    @test USI.parse(Tuple{Hand, Hand}, "Sbgn3p") == (b, w)

    # Position

    @test USI.string(Position()) == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
    @test USI.string(Position(); ply=false) == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -"
    @test USI.parse(Position, "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1") == Position()
    USI.parse(Position, "8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L w Sbgn3p 124")

    # Move
    
    @test USI.string(Move(COORDINATE77, COORDINATE76)) == "7g7f"
    @test USI.string(Move(COORDINATE88, COORDINATE11, true)) == "8h1a+"
    @test USI.string(Move(COORDINATE45, BISHOP)) == "B*4e"

    @test USI.parse(Move, "7g7f") == Move(COORDINATE77, COORDINATE76)
    @test USI.parse(Move, "8h1a+") == Move(COORDINATE88, COORDINATE11, true)
    @test USI.parse(Move, "B*4e") == Move(COORDINATE45, BISHOP)

    position = Position()
    domove!(position, USI.parse(Move, "7g7f"))
    domove!(position, USI.parse(Move, "3c3d"))
    domove!(position, USI.parse(Move, "8h2b+"))
    domove!(position, USI.parse(Move, "3a2b"))
    domove!(position, USI.parse(Move, "B*7g"))
    domove!(position, USI.parse(Move, "B*3c"))
end