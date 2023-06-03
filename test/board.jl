@testset "Board" begin
    board = Board()
    @test board[5, 9] == BLACK_KING
    @test board[2, 8] == BLACK_ROOK
    @test board[8, 8] == BLACK_BISHOP
    @test board[1, 2] == EMPTY
    @test board[2, 1] == WHITE_KNIGHT
    @test board[5, 1] == WHITE_KING
    @test board[8, 2] == WHITE_ROOK
    @test board[2, 2] == WHITE_BISHOP

    @test board[COORDINATE83] == WHITE_PAWN

    @test Board() == Board()
end