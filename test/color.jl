@testset "Color" begin
    @test Color(+1) == BLACK
    @test Color(-1) == WHITE
    @test Color(0) == COLORLESS
    
    @test next(BLACK) == WHITE
    @test next(WHITE) == BLACK
    @test next(COLORLESS) == COLORLESS
    
    @test rotate(BLACK) == WHITE
    @test rotate(WHITE) == BLACK
    @test rotate(COLORLESS) == COLORLESS
    
    @test sign(BLACK) == 1
    @test sign(WHITE) == -1
    @test sign(COLORLESS) == 0

    @test Integer(BLACK) == 1
    @test Integer(WHITE) == -1
    @test Integer(COLORLESS) == 0
end