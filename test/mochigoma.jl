@testset "Mochigoma" begin
    @test Mochigoma("B3P")[Koma("歩兵")] == 3
    @test Mochigoma("rnl" |> uppercase)[Koma("飛車")] == 1

    let
        mochigoma = Mochigoma()
        mochigoma[Koma("歩兵")] = 12
        mochigoma[Koma("飛車")] = 2
        mochigoma[Koma("桂馬")] = 4
        @test mochigoma[Koma("歩兵")] == 12
        @test mochigoma[Koma("飛車")] == 2
        @test mochigoma[Koma("桂馬")] == 4
    end

    a = Mochigoma()
    b = Mochigoma()
    @test a == b
    a[Koma("歩兵")] = 12
    @test a ≠ b
    b[Koma("歩兵")] = 12
    @test a == b
end