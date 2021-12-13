@testset "coding" begin
    @test bitstring(Koma("飛車")) == "011111"
    @test bitstring(MasuFromSFEN("K")) == ""
    @test bitstring(MasuFromSFEN("k")) == ""
    @test bitstring(MasuFromSFEN("1")) == "0"

    isvalid_kyokumen_coding_length(str::AbstractString) = Kyokumen(str) |> bitstring |> length == 256
    isvalid_kyokumen_coding(str::AbstractString) = Kyokumen(str) |> encode |> decode |> sfen == str

    @test "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -" |> isvalid_kyokumen_coding_length
    @test "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -" |> isvalid_kyokumen_coding
    @test "lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p" |> isvalid_kyokumen_coding_length
    @test "lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p" |> isvalid_kyokumen_coding
    @test "lnsgk1snl/6g2/p1pppp2p/6R2/5b3/1rP6/P2PPPP1P/1SG4S1/LN2KG1NL b B4Pp" |> isvalid_kyokumen_coding_length
    @test "lnsgk1snl/6g2/p1pppp2p/6R2/5b3/1rP6/P2PPPP1P/1SG4S1/LN2KG1NL b B4Pp" |> isvalid_kyokumen_coding
    @test "lnsgk1sn+B/6g2/p1pppp2p/7p1/5b3/2P6/P2PPPP1P/2G4S1/LN2KG1NL w RL4Prs" |> isvalid_kyokumen_coding_length
    @test "lnsgk1sn+B/6g2/p1pppp2p/7p1/5b3/2P6/P2PPPP1P/2G4S1/LN2KG1NL w RL4Prs" |> isvalid_kyokumen_coding
    @test "8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L w Sbgn3p" |> isvalid_kyokumen_coding_length
    @test "8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L w Sbgn3p" |> isvalid_kyokumen_coding
end