@testset "kakinoki" begin
    @testset "Sengo" begin
        @test kakinoki(先手) == "▲"
        @test kakinoki(後手) == "△"
        @test SengoFromKakinoki("▲") == 先手
        @test SengoFromKakinoki("△") == 後手
    end
    @testset "Koma" begin
        @test kakinoki(玉将) == "玉"
        @test kakinoki(飛車) == "飛"
        @test kakinoki(竜王) == "龍"
        @test kakinoki(角行) == "角"
        @test kakinoki(竜馬) == "馬"
        @test kakinoki(金将) == "金"
        @test kakinoki(銀将) == "銀"
        @test kakinoki(成銀) == "成銀"
        @test kakinoki(桂馬) == "桂"
        @test kakinoki(成桂) == "成桂"
        @test kakinoki(香車) == "香"
        @test kakinoki(成香) == "成香"
        @test kakinoki(歩兵) == "歩"
        @test kakinoki(と金) == "と"
        @test KomaFromKakinoki("玉") == 玉将
        @test KomaFromKakinoki("飛") == 飛車
        @test KomaFromKakinoki("龍") == 竜王
        @test KomaFromKakinoki("角") == 角行
        @test KomaFromKakinoki("馬") == 竜馬
        @test KomaFromKakinoki("金") == 金将
        @test KomaFromKakinoki("銀") == 銀将
        @test KomaFromKakinoki("成銀") == 成銀
        @test KomaFromKakinoki("桂") == 桂馬
        @test KomaFromKakinoki("成桂") == 成桂
        @test KomaFromKakinoki("香") == 香車
        @test KomaFromKakinoki("成香") == 成香
        @test KomaFromKakinoki("歩") == 歩兵
        @test KomaFromKakinoki("と") == と金
    end
    @testset "Kifu" begin
    end
end