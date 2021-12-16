@testset "Sengo" begin
    @test Sengo(true) == 先手
    @test Sengo(false) == 後手
    @test Sengo(1) == 先手
    @test Sengo(0) == 後手
    @test next(先手) == 後手
    @test next(後手) == 先手
    @test sign(先手) == 1
    @test sign(後手) == -1
    @test Integer(先手) == 1
    @test Integer(後手) == 0
end