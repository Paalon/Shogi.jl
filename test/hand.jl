@testset "Hand" begin
    hand = Hand()
    @test hand[PAWN] == 0
    @test hand[LANCE] == 0
    @test hand[KNIGHT] == 0
    @test hand[SILVER] == 0
    @test hand[GOLD] == 0
    @test hand[BISHOP] == 0
    @test hand[ROOK] == 0

    hand[PAWN] += 1
    @test hand[PAWN] == 1
    hand[PAWN] -= 1
    @test hand[PAWN] == 0

    @test_throws InexactError hand[PAWN] -= 1
    
    hand[GOLD] += 4
    clear!(hand)
    @test hand[GOLD] == 0

    @test Hand() == Hand()
end