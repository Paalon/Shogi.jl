@testset "Koma" begin
    @test Koma("金将") |> isomote
    @test Koma("成銀") |> isnarigoma
    @test Koma("+R"; style = :sfen) == Koma("竜"; style = :ichiji)
    @test "と金" |> Koma |> sfen == "+P"
    @test Koma("杏", style = :ichiji) |> sfen == "+L"
    @test ispromotable(Koma("金将")) == false
    @test naru(Koma("銀将")) == Koma("成銀")
end