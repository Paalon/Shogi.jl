@testset "Sengo" begin
    @test Sengo(true) == Sengo("b")
    @test Sengo(true) == Sengo('b')
    @test Sengo(false) == Sengo("w")
    @test Sengo(false) == Sengo('w')
    @test Shogi.sente == Sengo(true)
    @test Shogi.gote == Sengo(false)
    @test Shogi.sente |> next == Shogi.gote
end