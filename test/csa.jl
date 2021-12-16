@testset verbose = true "CSA" begin
    @testset "Sengo" begin
        @test csa(先手) == "+"
        @test csa(後手) == "-"
        @test SengoFromCSA("+") == 先手
        @test SengoFromCSA("-") == 後手
    end
    @testset "Koma" begin
        @test csa(歩兵) == "FU"
        @test csa(香車) == "KY"
        @test csa(桂馬) == "KE"
        @test csa(銀将) == "GI"
        @test csa(金将) == "KI"
        @test csa(角行) == "KA"
        @test csa(飛車) == "HI"
        @test csa(玉将) == "OU"
        @test csa(と金) == "TO"
        @test csa(成香) == "NY"
        @test csa(成桂) == "NK"
        @test csa(成銀) == "NG"
        @test csa(竜馬) == "UM"
        @test csa(竜王) == "RY"
        @test KomaFromCSA("FU") == 歩兵
        @test KomaFromCSA("KY") == 香車
        @test KomaFromCSA("KE") == 桂馬
        @test KomaFromCSA("GI") == 銀将
        @test KomaFromCSA("KI") == 金将
        @test KomaFromCSA("KA") == 角行
        @test KomaFromCSA("HI") == 飛車
        @test KomaFromCSA("OU") == 玉将
        @test KomaFromCSA("TO") == と金
        @test KomaFromCSA("NY") == 成香
        @test KomaFromCSA("NK") == 成桂
        @test KomaFromCSA("NG") == 成銀
        @test KomaFromCSA("UM") == 竜馬
        @test KomaFromCSA("RY") == 竜王
    end
    @testset "Masu" begin
        @test csa(〼) == " * "
        @test csa(☗歩兵) == "+FU"
        @test csa(☗香車) == "+KY"
        @test csa(☗桂馬) == "+KE"
        @test csa(☗銀将) == "+GI"
        @test csa(☗金将) == "+KI"
        @test csa(☗角行) == "+KA"
        @test csa(☗飛車) == "+HI"
        @test csa(☗玉将) == "+OU"
        @test csa(☗と金) == "+TO"
        @test csa(☗成香) == "+NY"
        @test csa(☗成桂) == "+NK"
        @test csa(☗成銀) == "+NG"
        @test csa(☗竜馬) == "+UM"
        @test csa(☗竜王) == "+RY"
        @test csa(☖歩兵) == "-FU"
        @test csa(☖香車) == "-KY"
        @test csa(☖桂馬) == "-KE"
        @test csa(☖銀将) == "-GI"
        @test csa(☖金将) == "-KI"
        @test csa(☖角行) == "-KA"
        @test csa(☖飛車) == "-HI"
        @test csa(☖玉将) == "-OU"
        @test csa(☖と金) == "-TO"
        @test csa(☖成香) == "-NY"
        @test csa(☖成桂) == "-NK"
        @test csa(☖成銀) == "-NG"
        @test csa(☖竜馬) == "-UM"
        @test csa(☖竜王) == "-RY"
        @test MasuFromCSA(" * ") == 〼
        @test MasuFromCSA("+FU") == ☗歩兵
        @test MasuFromCSA("+KY") == ☗香車
        @test MasuFromCSA("+KE") == ☗桂馬
        @test MasuFromCSA("+GI") == ☗銀将
        @test MasuFromCSA("+KI") == ☗金将
        @test MasuFromCSA("+KA") == ☗角行
        @test MasuFromCSA("+HI") == ☗飛車
        @test MasuFromCSA("+OU") == ☗玉将
        @test MasuFromCSA("+TO") == ☗と金
        @test MasuFromCSA("+NY") == ☗成香
        @test MasuFromCSA("+NK") == ☗成桂
        @test MasuFromCSA("+NG") == ☗成銀
        @test MasuFromCSA("+UM") == ☗竜馬
        @test MasuFromCSA("+RY") == ☗竜王
        @test MasuFromCSA("-FU") == ☖歩兵
        @test MasuFromCSA("-KY") == ☖香車
        @test MasuFromCSA("-KE") == ☖桂馬
        @test MasuFromCSA("-GI") == ☖銀将
        @test MasuFromCSA("-KI") == ☖金将
        @test MasuFromCSA("-KA") == ☖角行
        @test MasuFromCSA("-HI") == ☖飛車
        @test MasuFromCSA("-OU") == ☖玉将
        @test MasuFromCSA("-TO") == ☖と金
        @test MasuFromCSA("-NY") == ☖成香
        @test MasuFromCSA("-NK") == ☖成桂
        @test MasuFromCSA("-NG") == ☖成銀
        @test MasuFromCSA("-UM") == ☖竜馬
        @test MasuFromCSA("-RY") == ☖竜王
    end
    @testset "Banmen" begin
        @test csa(Banmen()) == BanmenEmptyCSA
        @test csa(BanmenHirate()) == BanmenHirateCSA
        @test BanmenFromCSA(BanmenEmptyCSA) == Banmen()
        @test BanmenFromCSA(BanmenHirateCSA) == BanmenHirate()
    end
    @testset "Kyokumen" begin
        @test csa(KyokumenHirate()) == KyokumenHirateCSA
        @test KyokumenFromCSA(KyokumenHirateCSA) == KyokumenHirate()
    end
    @testset "Move" begin
        kyokumen = NextKyokumenFromCSA(KyokumenHirate(), "+2726FU")
        @test kyokumen[2, 7] == 〼
        @test kyokumen[2, 6] == ☗歩兵
        kyokumen = NextKyokumenFromCSA(KyokumenHirate(), "+7776FU")
        @test kyokumen[7, 7] == 〼
        @test kyokumen[7, 6] == ☗歩兵
    end
end
