@testset "SFENKyokumen" begin
    isvalid_sfenkyokumen(str::AbstractString) = SFENKyokumen(str) |> sfen == str
    @test isvalid_sfenkyokumen("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1")
    @test isvalid_sfenkyokumen("lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p 16")
end