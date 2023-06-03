@testset "Coordinate" begin
    @test Coordinate(1, 1) == COORDINATE11
    @test Coordinate(3, 4) == COORDINATE34
    @test Coordinate(7, 2) == COORDINATE72
    @test Coordinate(9, 9) == COORDINATE99
    
    @test Coordinate(FILE1, RANK1) == COORDINATE11
    @test Coordinate(FILE3, RANK4) == COORDINATE34
    @test Coordinate(FILE7, RANK2) == COORDINATE72
    @test Coordinate(FILE9, RANK9) == COORDINATE99

    @test File(COORDINATE11) == FILE1
    @test File(COORDINATE34) == FILE3
    @test File(COORDINATE72) == FILE7
    @test File(COORDINATE79) == FILE7
    @test File(COORDINATE81) == FILE8
    @test File(COORDINATE99) == FILE9

    @test Rank(COORDINATE11) == RANK1
    @test Rank(COORDINATE34) == RANK4
    @test Rank(COORDINATE72) == RANK2
    @test Rank(COORDINATE79) == RANK9
    @test Rank(COORDINATE81) == RANK1
    @test Rank(COORDINATE99) == RANK9
end