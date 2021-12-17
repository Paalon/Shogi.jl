@testset "coding" begin
    @testset "bitstring(::Koma)" begin
        @test bitstring(歩兵) == "00"
        @test bitstring(と金) == "10"
        @test bitstring(香車) == "0001"
        @test bitstring(成香) == "1001"
        @test bitstring(桂馬) == "0101"
        @test bitstring(成桂) == "1101"
        @test bitstring(銀将) == "0011"
        @test bitstring(成銀) == "1011"
        @test bitstring(金将) == "0111"
        @test bitstring(角行) == "001111"
        @test bitstring(竜馬) == "101111"
        @test bitstring(飛車) == "011111"
        @test bitstring(竜王) == "111111"
        @test bitstring(玉将) == ""
    end
    @testset "bitstring(::Masu)" begin
        @test bitstring(〼) == "0"
        @test bitstring(☗歩兵) == "0011"
        @test bitstring(☗と金) == "1011"
        @test bitstring(☗香車) == "000111"
        @test bitstring(☗成香) == "100111"
        @test bitstring(☗桂馬) == "010111"
        @test bitstring(☗成桂) == "110111"
        @test bitstring(☗銀将) == "001111"
        @test bitstring(☗成銀) == "101111"
        @test bitstring(☗金将) == "011111"
        @test bitstring(☗角行) == "00111111"
        @test bitstring(☗竜馬) == "10111111"
        @test bitstring(☗飛車) == "01111111"
        @test bitstring(☗竜王) == "11111111"
        @test bitstring(☗玉将) == ""
        @test bitstring(☖歩兵) == "0001"
        @test bitstring(☖と金) == "1001"
        @test bitstring(☖香車) == "000101"
        @test bitstring(☖成香) == "100101"
        @test bitstring(☖桂馬) == "010101"
        @test bitstring(☖成桂) == "110101"
        @test bitstring(☖銀将) == "001101"
        @test bitstring(☖成銀) == "101101"
        @test bitstring(☖金将) == "011101"
        @test bitstring(☖角行) == "00111101"
        @test bitstring(☖竜馬) == "10111101"
        @test bitstring(☖飛車) == "01111101"
        @test bitstring(☖竜王) == "11111101"
        @test bitstring(☖玉将) == ""
    end
    @testset "bitstring(::Kyokumen)" begin
        # @test bitstring(KyokumenHirate())
        # @show encode(Kyokumen(), base=2)
    end

    isvalid_kyokumen_coding_length(str::AbstractString) = Kyokumen(str) |> bitstring |> length == 256
    isvalid_kyokumen_coding(str::AbstractString) = Kyokumen(str) |> encode |> decode |> sfen == str

    # @test "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -" |> isvalid_kyokumen_coding_length
    # @test "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -" |> isvalid_kyokumen_coding
    # @test "lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p" |> isvalid_kyokumen_coding_length
    # @test "lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p" |> isvalid_kyokumen_coding
    # @test "lnsgk1snl/6g2/p1pppp2p/6R2/5b3/1rP6/P2PPPP1P/1SG4S1/LN2KG1NL b B4Pp" |> isvalid_kyokumen_coding_length
    # @test "lnsgk1snl/6g2/p1pppp2p/6R2/5b3/1rP6/P2PPPP1P/1SG4S1/LN2KG1NL b B4Pp" |> isvalid_kyokumen_coding
    # @test "lnsgk1sn+B/6g2/p1pppp2p/7p1/5b3/2P6/P2PPPP1P/2G4S1/LN2KG1NL w RL4Prs" |> isvalid_kyokumen_coding_length
    # @test "lnsgk1sn+B/6g2/p1pppp2p/7p1/5b3/2P6/P2PPPP1P/2G4S1/LN2KG1NL w RL4Prs" |> isvalid_kyokumen_coding
    # @test "8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L w Sbgn3p" |> isvalid_kyokumen_coding_length
    # @test "8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L w Sbgn3p" |> isvalid_kyokumen_coding
end