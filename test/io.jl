@testset "io" begin
    @testset "Sengo" begin
        @test string_cli(先手) == "+"
        @test string_cli(後手) == "-"
    end
    @testset "Koma" begin
        @test string_cli(歩兵) == "歩"
        @test string_cli(香車) == "香"
        @test string_cli(桂馬) == "桂"
        @test string_cli(銀将) == "銀"
        @test string_cli(金将) == "金"
        @test string_cli(角行) == "角"
        @test string_cli(飛車) == "飛"
        @test string_cli(玉将) == "玉"
        @test string_cli(と金) == "と"
        @test string_cli(成香) == "杏"
        @test string_cli(成桂) == "圭"
        @test string_cli(成銀) == "全"
        @test string_cli(竜馬) == "馬"
        @test string_cli(竜王) == "竜"
    end
    @testset "Masu" begin
        @test string_cli(〼) == " ・"
        @test string_cli(☗歩兵) == "+歩"
        @test string_cli(☖歩兵) == "-歩"
    end
    @testset "Mochigoma" begin
        @test string(Mochigoma([0, 0, 0, 0, 0, 0, 0, 0])) == "なし"
        @test string(Mochigoma([0, 0, 0, 0, 0, 0, 0, 1])) == "歩"
        @test string(Mochigoma([0, 0, 0, 0, 0, 0, 0, 2])) == "歩２"
        @test string(Mochigoma([0, 0, 0, 0, 0, 0, 0, 10])) == "歩１０"
        @test string(Mochigoma([0, 0, 0, 0, 0, 0, 0, 18])) == "歩１８"
    end
end