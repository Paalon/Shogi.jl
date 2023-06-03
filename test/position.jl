@testset "Position" begin
    @test Position() == Position()
    position = Position()
    position[7, 6] = BLACK_PAWN
    position[7, 7] = EMPTY
    position[COORDINATE84] = WHITE_PAWN
    position[COORDINATE83] = EMPTY
end