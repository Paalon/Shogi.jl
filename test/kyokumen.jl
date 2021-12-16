@testset "Kyokumen" begin

    @testset "==" begin
        @test Kyokumen() == Kyokumen()
    end

    @testset "copy" begin
        a = Kyokumen()
        b = copy(a)
        @test a !== b
        @test a == b
    end

    @testset "issente" begin
        @test issente(Kyokumen())
    end

    @testset "getindex" begin
        @test Kyokumen()[1, 1] == 〼
        @test Kyokumen()[1, :] == [〼, 〼, 〼, 〼, 〼, 〼, 〼, 〼, 〼]
        @test Kyokumen()[:, 1] == [〼, 〼, 〼, 〼, 〼, 〼, 〼, 〼, 〼]
    end

    @testset "setindex!" begin
        kyokumen = Kyokumen()
        @test kyokumen[5, 9] == 〼
        kyokumen[5, 9] = ☗玉将
        @test kyokumen[5, 9] == ☗玉将
        kyokumen[:, 7] = Masu.(Integer(☗歩兵) * ones(Int8, 9))
        @test kyokumen[5, 7] == ☗歩兵
    end

    @testset "KyokumenHirate" begin
        kyokumen = KyokumenHirate()
        @test kyokumen[1, 1] == ☖香車
        @test kyokumen[8, 8] == ☗角行
        @test kyokumen[2, 8] == ☗飛車
        @test kyokumen[2, 2] == ☖角行
        @test kyokumen[8, 2] == ☖飛車
    end

    @testset "toru!" begin
        kyokumen = KyokumenHirate()
        toru!(kyokumen, 2, 2)
        @test kyokumen[2, 2] == 〼
        @test kyokumen.mochigoma.sente[角行] == 1
    end

    @testset "" begin
        
    end

    # isvalid_kyokumen(str::AbstractString) = Kyokumen(str) |> sfen == str

    # @test isvalid_kyokumen("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -")
    # @test isvalid_kyokumen("lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p")
    # @test isvalid_kyokumen("lnsgk1snl/6g2/p1pppp2p/6R2/5b3/1rP6/P2PPPP1P/1SG4S1/LN2KG1NL b B4Pp")
    # @test isvalid_kyokumen("lnsgk1sn+B/6g2/p1pppp2p/7p1/5b3/2P6/P2PPPP1P/2G4S1/LN2KG1NL w RL4Prs")
    # @test isvalid_kyokumen("8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L w Sbgn3p")
end