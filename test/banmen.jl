@testset "Banmen" begin
    @testset "==" begin
        @test Banmen() == Banmen()
    end
    @testset "copy" begin
        a = Banmen()
        b = copy(a)
        @test a !== b
    end
    @testset "getindex" begin
        @test Banmen()[1, 1] == 〼
    end
    @testset "setindex!" begin
        banmen = Banmen()
        banmen[1, 1] = ☗竜王
        @test banmen[1, 1] == ☗竜王
        banmen[2, :] = [☗と金, ☗と金, ☗と金, ☗と金, ☗と金, ☗と金, ☗と金, ☗と金, ☗と金]
        @test banmen[2, 9] == ☗と金
    end
    @testset "BanmenHirate" begin
        banmen = BanmenHirate()
        @test banmen[5, 9] == ☗玉将
        @test banmen[2, 7] == ☗歩兵
        @test banmen[8, 8] == ☗角行
        @test banmen[2, 8] == ☗飛車
        @test banmen[5, 1] == ☖玉将
        @test banmen[8, 3] == ☖歩兵
        @test banmen[2, 2] == ☖角行
        @test banmen[8, 2] == ☖飛車
    end
    # banmen = Banmen()
    # banmen[1, 1] = ☗飛車
    # sfen(banmen) == "8R/9/9/9/9/9/9/9/9"

    # banmen = Banmen()
    # banmen[1, 1] = ☗飛車
    # sfen(banmen) == "8R/9/9/9/9/9/9/9/9"

    # banmen = Banmen("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL")
    # @test sfen(banmen) == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"

    # banmen1 = Banmen()
    # banmen2 = copy(Banmen())
    # @test banmen1 == banmen2
    # banmen1[1, 1] = Masu(Koma("飛車"), Shogi.sente)
    # @test banmen1 != banmen2
end