@testset "Move" begin
    position = Position()
    move = NormalMove(COORDINATE27, COORDINATE26, false)
    domove!(position, move)
    @test position[2, 6] == BLACK_PAWN
    @test position[2, 7] == EMPTY
    @test position.side == WHITE
end