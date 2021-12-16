@testset "Masu" begin
    @testset "isempty(::Masu)" begin
        @test isempty(〼) == true
        @test isempty(☗歩兵) == false
        @test isempty(☗香車) == false
        @test isempty(☗桂馬) == false
        @test isempty(☗銀将) == false
        @test isempty(☗金将) == false
        @test isempty(☗角行) == false
        @test isempty(☗飛車) == false
        @test isempty(☗玉将) == false
        @test isempty(☗と金) == false
        @test isempty(☗成香) == false
        @test isempty(☗成桂) == false
        @test isempty(☗成銀) == false
        @test isempty(☗竜馬) == false
        @test isempty(☗竜王) == false
        @test isempty(☖歩兵) == false
        @test isempty(☖香車) == false
        @test isempty(☖桂馬) == false
        @test isempty(☖銀将) == false
        @test isempty(☖金将) == false
        @test isempty(☖角行) == false
        @test isempty(☖飛車) == false
        @test isempty(☖玉将) == false
        @test isempty(☖と金) == false
        @test isempty(☖成香) == false
        @test isempty(☖成桂) == false
        @test isempty(☖成銀) == false
        @test isempty(☖竜馬) == false
        @test isempty(☖竜王) == false
    end
    @testset "issente(::Masu)" begin
        @test issente(〼) == false
        @test issente(☗歩兵) == true
        @test issente(☗香車) == true
        @test issente(☗桂馬) == true
        @test issente(☗銀将) == true
        @test issente(☗金将) == true
        @test issente(☗角行) == true
        @test issente(☗飛車) == true
        @test issente(☗玉将) == true
        @test issente(☗と金) == true
        @test issente(☗成香) == true
        @test issente(☗成桂) == true
        @test issente(☗成銀) == true
        @test issente(☗竜馬) == true
        @test issente(☗竜王) == true
        @test issente(☖歩兵) == false
        @test issente(☖香車) == false
        @test issente(☖桂馬) == false
        @test issente(☖銀将) == false
        @test issente(☖金将) == false
        @test issente(☖角行) == false
        @test issente(☖飛車) == false
        @test issente(☖玉将) == false
        @test issente(☖と金) == false
        @test issente(☖成香) == false
        @test issente(☖成桂) == false
        @test issente(☖成銀) == false
        @test issente(☖竜馬) == false
        @test issente(☖竜王) == false
    end
    @testset "isgote(::Masu)" begin
        @test isgote(〼) == false
        @test isgote(☗歩兵) == false
        @test isgote(☗香車) == false
        @test isgote(☗桂馬) == false
        @test isgote(☗銀将) == false
        @test isgote(☗金将) == false
        @test isgote(☗角行) == false
        @test isgote(☗飛車) == false
        @test isgote(☗玉将) == false
        @test isgote(☗と金) == false
        @test isgote(☗成香) == false
        @test isgote(☗成桂) == false
        @test isgote(☗成銀) == false
        @test isgote(☗竜馬) == false
        @test isgote(☗竜王) == false
        @test isgote(☖歩兵) == true
        @test isgote(☖香車) == true
        @test isgote(☖桂馬) == true
        @test isgote(☖銀将) == true
        @test isgote(☖金将) == true
        @test isgote(☖角行) == true
        @test isgote(☖飛車) == true
        @test isgote(☖玉将) == true
        @test isgote(☖と金) == true
        @test isgote(☖成香) == true
        @test isgote(☖成桂) == true
        @test isgote(☖成銀) == true
        @test isgote(☖竜馬) == true
        @test isgote(☖竜王) == true
    end
    @testset "sign(::Masu)" begin
        @test sign(〼) == 0
        @test sign(☗歩兵) == +1
        @test sign(☗香車) == +1
        @test sign(☗桂馬) == +1
        @test sign(☗銀将) == +1
        @test sign(☗金将) == +1
        @test sign(☗角行) == +1
        @test sign(☗飛車) == +1
        @test sign(☗玉将) == +1
        @test sign(☗と金) == +1
        @test sign(☗成香) == +1
        @test sign(☗成桂) == +1
        @test sign(☗成銀) == +1
        @test sign(☗竜馬) == +1
        @test sign(☗竜王) == +1
        @test sign(☖歩兵) == -1
        @test sign(☖香車) == -1
        @test sign(☖桂馬) == -1
        @test sign(☖銀将) == -1
        @test sign(☖金将) == -1
        @test sign(☖角行) == -1
        @test sign(☖飛車) == -1
        @test sign(☖玉将) == -1
        @test sign(☖と金) == -1
        @test sign(☖成香) == -1
        @test sign(☖成桂) == -1
        @test sign(☖成銀) == -1
        @test sign(☖竜馬) == -1
        @test sign(☖竜王) == -1
    end
    @testset "Sengo(::Masu)" begin
        @test Sengo(〼) |> isnothing
        @test Sengo(☗歩兵) == 先手
        @test Sengo(☗香車) == 先手
        @test Sengo(☗桂馬) == 先手
        @test Sengo(☗銀将) == 先手
        @test Sengo(☗金将) == 先手
        @test Sengo(☗角行) == 先手
        @test Sengo(☗飛車) == 先手
        @test Sengo(☗玉将) == 先手
        @test Sengo(☗と金) == 先手
        @test Sengo(☗成香) == 先手
        @test Sengo(☗成桂) == 先手
        @test Sengo(☗成銀) == 先手
        @test Sengo(☗竜馬) == 先手
        @test Sengo(☗竜王) == 先手
        @test Sengo(☖歩兵) == 後手
        @test Sengo(☖香車) == 後手
        @test Sengo(☖桂馬) == 後手
        @test Sengo(☖銀将) == 後手
        @test Sengo(☖金将) == 後手
        @test Sengo(☖角行) == 後手
        @test Sengo(☖飛車) == 後手
        @test Sengo(☖玉将) == 後手
        @test Sengo(☖と金) == 後手
        @test Sengo(☖成香) == 後手
        @test Sengo(☖成桂) == 後手
        @test Sengo(☖成銀) == 後手
        @test Sengo(☖竜馬) == 後手
        @test Sengo(☖竜王) == 後手
    end
    @testset "Masu(::Koma, ::Sengo)" begin
        @test Masu(歩兵, 先手) == ☗歩兵
        @test Masu(香車, 先手) == ☗香車
        @test Masu(桂馬, 先手) == ☗桂馬
        @test Masu(銀将, 先手) == ☗銀将
        @test Masu(金将, 先手) == ☗金将
        @test Masu(玉将, 先手) == ☗玉将
        @test Masu(と金, 先手) == ☗と金
        @test Masu(成香, 先手) == ☗成香
        @test Masu(成桂, 先手) == ☗成桂
        @test Masu(成銀, 先手) == ☗成銀
        @test Masu(竜馬, 先手) == ☗竜馬
        @test Masu(竜王, 先手) == ☗竜王
        @test Masu(歩兵, 後手) == ☖歩兵
        @test Masu(香車, 後手) == ☖香車
        @test Masu(桂馬, 後手) == ☖桂馬
        @test Masu(銀将, 後手) == ☖銀将
        @test Masu(金将, 後手) == ☖金将
        @test Masu(玉将, 後手) == ☖玉将
        @test Masu(と金, 後手) == ☖と金
        @test Masu(成香, 後手) == ☖成香
        @test Masu(成桂, 後手) == ☖成桂
        @test Masu(成銀, 後手) == ☖成銀
        @test Masu(竜馬, 後手) == ☖竜馬
        @test Masu(竜王, 後手) == ☖竜王
    end
    @testset "Koma(::Masu)" begin
        @test Koma(〼) |> isnothing
        @test Koma(☗歩兵) == 歩兵
        @test Koma(☗香車) == 香車
        @test Koma(☗桂馬) == 桂馬
        @test Koma(☗銀将) == 銀将
        @test Koma(☗金将) == 金将
        @test Koma(☗角行) == 角行
        @test Koma(☗飛車) == 飛車
        @test Koma(☗玉将) == 玉将
        @test Koma(☗と金) == と金
        @test Koma(☗成香) == 成香
        @test Koma(☗成桂) == 成桂
        @test Koma(☗成銀) == 成銀
        @test Koma(☗竜馬) == 竜馬
        @test Koma(☗竜王) == 竜王
        @test Koma(☖歩兵) == 歩兵
        @test Koma(☖香車) == 香車
        @test Koma(☖桂馬) == 桂馬
        @test Koma(☖銀将) == 銀将
        @test Koma(☖金将) == 金将
        @test Koma(☖角行) == 角行
        @test Koma(☖飛車) == 飛車
        @test Koma(☖玉将) == 玉将
        @test Koma(☖と金) == と金
        @test Koma(☖成香) == 成香
        @test Koma(☖成桂) == 成桂
        @test Koma(☖成銀) == 成銀
        @test Koma(☖竜馬) == 竜馬
        @test Koma(☖竜王) == 竜王
    end
    @testset "ispromotable(::Masu)" begin
        @test ispromotable(〼) == false
        @test ispromotable(☗歩兵) == true
        @test ispromotable(☗香車) == true
        @test ispromotable(☗桂馬) == true
        @test ispromotable(☗銀将) == true
        @test ispromotable(☗金将) == false
        @test ispromotable(☗角行) == true
        @test ispromotable(☗飛車) == true
        @test ispromotable(☗玉将) == false
        @test ispromotable(☗と金) == false
        @test ispromotable(☗成香) == false
        @test ispromotable(☗成桂) == false
        @test ispromotable(☗成銀) == false
        @test ispromotable(☗竜馬) == false
        @test ispromotable(☗竜王) == false
        @test ispromotable(☖歩兵) == true
        @test ispromotable(☖香車) == true
        @test ispromotable(☖桂馬) == true
        @test ispromotable(☖銀将) == true
        @test ispromotable(☖金将) == false
        @test ispromotable(☖角行) == true
        @test ispromotable(☖飛車) == true
        @test ispromotable(☖玉将) == false
        @test ispromotable(☖と金) == false
        @test ispromotable(☖成香) == false
        @test ispromotable(☖成桂) == false
        @test ispromotable(☖成銀) == false
        @test ispromotable(☖竜馬) == false
        @test ispromotable(☖竜王) == false
    end
    @testset "naru(::Masu)" begin
        @test naru(〼) |> isnothing
        @test naru(☗歩兵) == ☗と金
        @test naru(☗香車) == ☗成香
        @test naru(☗桂馬) == ☗成桂
        @test naru(☗銀将) == ☗成銀
        @test naru(☗金将) |> isnothing
        @test naru(☗角行) == ☗竜馬
        @test naru(☗飛車) == ☗竜王
        @test naru(☗玉将) |> isnothing
        @test naru(☗と金) |> isnothing
        @test naru(☗成香) |> isnothing
        @test naru(☗成桂) |> isnothing
        @test naru(☗成銀) |> isnothing
        @test naru(☗竜馬) |> isnothing
        @test naru(☗竜王) |> isnothing
        @test naru(☖歩兵) == ☖と金
        @test naru(☖香車) == ☖成香
        @test naru(☖桂馬) == ☖成桂
        @test naru(☖銀将) == ☖成銀
        @test naru(☖金将) |> isnothing
        @test naru(☖角行) == ☖竜馬
        @test naru(☖飛車) == ☖竜王
        @test naru(☖玉将) |> isnothing
        @test naru(☖と金) |> isnothing
        @test naru(☖成香) |> isnothing
        @test naru(☖成桂) |> isnothing
        @test naru(☖成銀) |> isnothing
        @test naru(☖竜馬) |> isnothing
        @test naru(☖竜王) |> isnothing
    end
end