@testset "Kyokumen" begin
    isvalid_kyokumen(str::AbstractString) = Kyokumen(str) |> sfen == str

    @test isvalid_kyokumen("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -")
    @test isvalid_kyokumen("lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p")
    @test isvalid_kyokumen("lnsgk1snl/6g2/p1pppp2p/6R2/5b3/1rP6/P2PPPP1P/1SG4S1/LN2KG1NL b B4Pp")
    @test isvalid_kyokumen("lnsgk1sn+B/6g2/p1pppp2p/7p1/5b3/2P6/P2PPPP1P/2G4S1/LN2KG1NL w RL4Prs")
    @test isvalid_kyokumen("8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L w Sbgn3p")

    a = Kyokumen()
    b = copy(a)
    @test a == b
    b.teban = Shogi.gote
    @test a ≠ b

    a = Kyokumen()
    masu = a[8, 8]
    @test masu == Masu(Koma("角行"), Shogi.sente)
    a[8, 8] = Shogi.空き枡
    @test a != Kyokumen()
    @test a[8, 8] == Shogi.空き枡

    a = Kyokumen()
    toru!(a, 2, 2)
    @test a[2, 2] |> isempty
    @test a.mochigoma.sente[Koma("角行")] == 1
end