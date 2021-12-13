@testset "Banmen" begin
    banmen = Banmen()
    banmen[1, 1] = Masu(Koma("飛車"), Shogi.sente)
    sfen(banmen) == "8R/9/9/9/9/9/9/9/9"

    banmen = Banmen()
    banmen[1, 1] = Masu(Koma("飛車"), Shogi.sente)
    sfen(banmen) == "8R/9/9/9/9/9/9/9/9"

    banmen = Banmen("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL")
    @test sfen(banmen) == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"

    banmen1 = Banmen()
    banmen2 = copy(Banmen())
    @test banmen1 == banmen2
    banmen1[1, 1] = Masu(Koma("飛車"), Shogi.sente)
    @test banmen1 != banmen2
end