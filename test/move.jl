@testset "Move" begin
    isvalid_move(str::AbstractString) = AbstractMove(str) |> sfen == str

    @test isvalid_move("2g2f")
    @test isvalid_move("2h2b+")
    @test isvalid_move("8b8h+")
    @test isvalid_move("2b2h")
    @test isvalid_move("9i1a+")
    @test isvalid_move("P*8g")
    @test isvalid_move("B*5e")

    kyokumen = Kyokumen()
    susumeru!(kyokumen, Move("2g2f"))
    @test kyokumen == Kyokumen("lnsgkgsnl/1r5b1/ppppppppp/9/9/7P1/PPPPPPP1P/1B5R1/LNSGKGSNL w -")
    @test susumeru(kyokumen, Move("8c8d")) == Kyokumen("lnsgkgsnl/1r5b1/p1ppppppp/1p7/9/7P1/PPPPPPP1P/1B5R1/LNSGKGSNL b -")
    @test kyokumen == Kyokumen("lnsgkgsnl/1r5b1/ppppppppp/9/9/7P1/PPPPPPP1P/1B5R1/LNSGKGSNL w -")
end