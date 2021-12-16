@testset "Koma" begin
    
    @testset "iskogoma(::Koma)" begin
        @test iskogoma(歩兵) == true
        @test iskogoma(香車) == true
        @test iskogoma(桂馬) == true
        @test iskogoma(銀将) == true
        @test iskogoma(金将) == true
        @test iskogoma(角行) == false
        @test iskogoma(飛車) == false
        @test iskogoma(玉将) == false
        @test iskogoma(と金) == true
        @test iskogoma(成香) == true
        @test iskogoma(成桂) == true
        @test iskogoma(成銀) == true
        @test iskogoma(竜馬) == false
        @test iskogoma(竜王) == false
    end

    @testset "isoogoma(::Koma)" begin
        @test isoogoma(歩兵) == false
        @test isoogoma(香車) == false
        @test isoogoma(桂馬) == false
        @test isoogoma(銀将) == false
        @test isoogoma(金将) == false
        @test isoogoma(角行) == true
        @test isoogoma(飛車) == true
        @test isoogoma(玉将) == false
        @test isoogoma(と金) == false
        @test isoogoma(成香) == false
        @test isoogoma(成桂) == false
        @test isoogoma(成銀) == false
        @test isoogoma(竜馬) == true
        @test isoogoma(竜王) == true
    end

    # @testset "isnarigoma(::Koma)" begin
    #     @test isnarigoma(歩兵) == false
    #     @test isnarigoma(香車) == false
    #     @test isnarigoma(桂馬) == false
    #     @test isnarigoma(銀将) == false
    #     @test isnarigoma(金将) == false
    #     @test isnarigoma(角行) == false
    #     @test isnarigoma(飛車) == false
    #     @test isnarigoma(玉将) == false
    #     @test isnarigoma(と金) == true
    #     @test isnarigoma(成香) == true
    #     @test isnarigoma(成桂) == true
    #     @test isnarigoma(成銀) == true
    #     @test isnarigoma(竜馬) == true
    #     @test isnarigoma(竜王) == true
    # end

    @testset "ispromotable(::Koma)" begin
        @test ispromotable(歩兵) == true
        @test ispromotable(香車) == true
        @test ispromotable(桂馬) == true
        @test ispromotable(銀将) == true
        @test ispromotable(金将) == false
        @test ispromotable(角行) == true
        @test ispromotable(飛車) == true
        @test ispromotable(玉将) == false
        @test ispromotable(と金) == false
        @test ispromotable(成香) == false
        @test ispromotable(成桂) == false
        @test ispromotable(成銀) == false
        @test ispromotable(竜馬) == false
        @test ispromotable(竜王) == false
    end

    @testset "naru(::Koma)" begin
        @test naru(歩兵) == と金
        @test naru(香車) == 成香
        @test naru(桂馬) == 成桂
        @test naru(銀将) == 成銀
        @test naru(金将) |> isnothing
        @test naru(角行) == 竜馬
        @test naru(飛車) == 竜王
        @test naru(玉将) |> isnothing
        @test naru(と金) |> isnothing
        @test naru(成香) |> isnothing
        @test naru(成桂) |> isnothing
        @test naru(竜馬) |> isnothing
        @test naru(竜王) |> isnothing
    end

    @testset "omote(::Koma)" begin
        @test omote(歩兵) == 歩兵
        @test omote(香車) == 香車
        @test omote(桂馬) == 桂馬
        @test omote(銀将) == 銀将
        @test omote(金将) == 金将
        @test omote(角行) == 角行
        @test omote(飛車) == 飛車
        @test omote(玉将) == 玉将
        @test omote(と金) == 歩兵
        @test omote(成香) == 香車
        @test omote(成桂) == 桂馬
        @test omote(成銀) == 銀将
        @test omote(竜馬) == 角行
        @test omote(竜王) == 飛車
    end

    @testset "jishogi_score(::Koma)" begin
        @test jishogi_score(歩兵) == 1
        @test jishogi_score(香車) == 1
        @test jishogi_score(桂馬) == 1
        @test jishogi_score(銀将) == 1
        @test jishogi_score(金将) == 1
        @test jishogi_score(角行) == 5
        @test jishogi_score(飛車) == 5
        @test jishogi_score(玉将) == 0
        @test jishogi_score(と金) == 1
        @test jishogi_score(成香) == 1
        @test jishogi_score(成桂) == 1
        @test jishogi_score(成銀) == 1
        @test jishogi_score(竜馬) == 5
        @test jishogi_score(竜王) == 5
    end

end