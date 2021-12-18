# 8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L w Sbgn3p 124
@testset verbose = true "SFEN" begin
    @testset "Sengo" begin
        @test sfen(先手) == "b"
        @test sfen(後手) == "w"
        @test SengoFromSFEN("b") == 先手
        @test SengoFromSFEN("w") == 後手
    end
    @testset "Koma" begin
        @test sfen(歩兵) == "P"
        @test sfen(香車) == "L"
        @test sfen(桂馬) == "N"
        @test sfen(銀将) == "S"
        @test sfen(金将) == "G"
        @test sfen(角行) == "B"
        @test sfen(飛車) == "R"
        @test sfen(玉将) == "K"
        @test sfen(と金) == "+P"
        @test sfen(成香) == "+L"
        @test sfen(成桂) == "+N"
        @test sfen(成銀) == "+S"
        @test sfen(竜馬) == "+B"
        @test sfen(竜王) == "+R"
        @test KomaFromSFEN("P") == 歩兵
        @test KomaFromSFEN("L") == 香車
        @test KomaFromSFEN("N") == 桂馬
        @test KomaFromSFEN("S") == 銀将
        @test KomaFromSFEN("G") == 金将
        @test KomaFromSFEN("B") == 角行
        @test KomaFromSFEN("R") == 飛車
        @test KomaFromSFEN("K") == 玉将
        @test KomaFromSFEN("+P") == と金
        @test KomaFromSFEN("+L") == 成香
        @test KomaFromSFEN("+N") == 成桂
        @test KomaFromSFEN("+S") == 成銀
        @test KomaFromSFEN("+B") == 竜馬
        @test KomaFromSFEN("+R") == 竜王
    end
    @testset "Masu" begin
        @test sfen(〼) == "1"
        @test sfen(☗歩兵) == "P"
        @test sfen(☗香車) == "L"
        @test sfen(☗桂馬) == "N"
        @test sfen(☗銀将) == "S"
        @test sfen(☗金将) == "G"
        @test sfen(☗角行) == "B"
        @test sfen(☗飛車) == "R"
        @test sfen(☗玉将) == "K"
        @test sfen(☗と金) == "+P"
        @test sfen(☗成香) == "+L"
        @test sfen(☗成桂) == "+N"
        @test sfen(☗成銀) == "+S"
        @test sfen(☗竜馬) == "+B"
        @test sfen(☗竜王) == "+R"
        @test sfen(☖歩兵) == "p"
        @test sfen(☖香車) == "l"
        @test sfen(☖桂馬) == "n"
        @test sfen(☖銀将) == "s"
        @test sfen(☖金将) == "g"
        @test sfen(☖角行) == "b"
        @test sfen(☖飛車) == "r"
        @test sfen(☖玉将) == "k"
        @test sfen(☖と金) == "+p"
        @test sfen(☖成香) == "+l"
        @test sfen(☖成桂) == "+n"
        @test sfen(☖成銀) == "+s"
        @test sfen(☖竜馬) == "+b"
        @test sfen(☖竜王) == "+r"
        @test MasuFromSFEN("1") == 〼
        @test MasuFromSFEN("P") == ☗歩兵
        @test MasuFromSFEN("L") == ☗香車
        @test MasuFromSFEN("N") == ☗桂馬
        @test MasuFromSFEN("S") == ☗銀将
        @test MasuFromSFEN("G") == ☗金将
        @test MasuFromSFEN("B") == ☗角行
        @test MasuFromSFEN("R") == ☗飛車
        @test MasuFromSFEN("K") == ☗玉将
        @test MasuFromSFEN("+P") == ☗と金
        @test MasuFromSFEN("+L") == ☗成香
        @test MasuFromSFEN("+N") == ☗成桂
        @test MasuFromSFEN("+S") == ☗成銀
        @test MasuFromSFEN("+B") == ☗竜馬
        @test MasuFromSFEN("+R") == ☗竜王
        @test MasuFromSFEN("p") == ☖歩兵
        @test MasuFromSFEN("l") == ☖香車
        @test MasuFromSFEN("n") == ☖桂馬
        @test MasuFromSFEN("s") == ☖銀将
        @test MasuFromSFEN("g") == ☖金将
        @test MasuFromSFEN("b") == ☖角行
        @test MasuFromSFEN("r") == ☖飛車
        @test MasuFromSFEN("k") == ☖玉将
        @test MasuFromSFEN("+p") == ☖と金
        @test MasuFromSFEN("+l") == ☖成香
        @test MasuFromSFEN("+n") == ☖成桂
        @test MasuFromSFEN("+s") == ☖成銀
        @test MasuFromSFEN("+b") == ☖竜馬
        @test MasuFromSFEN("+r") == ☖竜王
    end
    @testset "Mochigoma" begin
        @test sfen(Mochigoma([0, 0, 0, 0, 0, 0, 0, 0])) == ""
        @test sfen(Mochigoma([0, 1, 0, 0, 0, 0, 0, 0])) == "R"
        @test sfen(Mochigoma([0, 0, 1, 0, 0, 0, 0, 0])) == "B"
        @test sfen(Mochigoma([0, 0, 0, 1, 0, 0, 0, 0])) == "G"
        @test sfen(Mochigoma([0, 0, 0, 0, 1, 0, 0, 0])) == "S"
        @test sfen(Mochigoma([0, 0, 0, 0, 0, 1, 0, 0])) == "N"
        @test sfen(Mochigoma([0, 0, 0, 0, 0, 0, 1, 0])) == "L"
        @test sfen(Mochigoma([0, 0, 0, 0, 0, 0, 0, 1])) == "P"
        @test sfen(Mochigoma([0, 0, 0, 0, 0, 0, 0, 5])) == "5P"
        @test sfen(Mochigoma([0, 0, 0, 0, 0, 0, 0, 10])) == "10P"
        @test sfen(Mochigoma([0, 0, 0, 0, 0, 0, 0, 18])) == "18P"
        @test sfen(Mochigoma([0, 2, 2, 4, 4, 4, 4, 18])) == "2R2B4G4S4N4L18P"
        @test MochigomaFromSFEN("") == Mochigoma([0, 0, 0, 0, 0, 0, 0, 0])
        @test MochigomaFromSFEN("S") == Mochigoma([0, 0, 0, 0, 1, 0, 0, 0])
        @test MochigomaFromSFEN(uppercase("bgn3p")) == Mochigoma([0, 0, 1, 1, 0, 1, 0, 3])
    end
    @testset "Banmen" begin
        @test sfen(Banmen()) == "9/9/9/9/9/9/9/9/9"
        @test sfen(BanmenHirate()) == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"
        @test BanmenFromSFEN("9/9/9/9/9/9/9/9/9") == Banmen()
        @test BanmenFromSFEN("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL") == BanmenHirate()
        str = "8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L"
        @test str |> BanmenFromSFEN |> sfen == str
    end
    @testset "SengoMochigoma" begin
        @test sfen((sente = Mochigoma(), gote = Mochigoma())) == "-"
        @test SengoMochigomaFromSFEN("-") == (
            sente = Mochigoma(),
            gote = Mochigoma(),
        )
    end
    @testset "Kyokumen" begin
        @test sfen(Kyokumen()) == "9/9/9/9/9/9/9/9/9 b -"
        @test sfen(KyokumenHirate()) == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -"
        @test KyokumenFromSFEN("9/9/9/9/9/9/9/9/9 b -") == Kyokumen()
        @test KyokumenFromSFEN("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -") == KyokumenHirate()
        str = "8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L w Sbgn3p"
        @test str |> KyokumenFromSFEN |> sfen == str
    end
    @testset "Move" begin
        @test "2g2f" |> SFENMove |> string == "2g2f"
        @test "7g7f" |> SFENMove |> string == "7g7f"
        @test "P*2h" |> SFENMove |> string == "P*2h"
        @test "2b8h+" |> SFENMove |> string == "2b8h+"
        @test next(KyokumenHirate(), SFENMove("2g2f")) == KyokumenFromSFEN("lnsgkgsnl/1r5b1/ppppppppp/9/9/7P1/PPPPPPP1P/1B5R1/LNSGKGSNL w -")
        @test next(KyokumenHirate(), SFENMove("7g7f")) == KyokumenFromSFEN("lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w -")
    end
end