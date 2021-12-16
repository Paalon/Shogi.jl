@testset "Mochigoma" begin
    @testset "copy(::Mochigoma)" begin
        a = Mochigoma()
        b = copy(a)
        @test a !== b
    end
    @testset "==(::Mochigoma, ::Mochigoma)" begin
        @test Mochigoma() == Mochigoma()
        xs = rand(Int8, 8)
        @test Mochigoma(xs) == Mochigoma(xs)
    end
    @testset "getindex(::Mochigoma, ::Koma)" begin
        mochigoma = Mochigoma([1, 2, 3, 4, 5, 6, 7, 8])
        @test mochigoma[歩兵] == 8
        @test mochigoma[香車] == 7
        @test mochigoma[桂馬] == 6
        @test mochigoma[銀将] == 5
        @test mochigoma[金将] == 4
        @test mochigoma[角行] == 3
        @test mochigoma[飛車] == 2
        @test mochigoma[玉将] == 1
    end
    @testset "setindex!(::Mochigoma, ::Integer, ::Koma)" begin
        mochigoma = Mochigoma()
        mochigoma[歩兵] = 12
        mochigoma[飛車] = 2
        mochigoma[桂馬] = 4
        @test mochigoma[歩兵] == 12
        @test mochigoma[飛車] == 2
        @test mochigoma[桂馬] == 4
        mochigoma[金将] += 1
        @test mochigoma[金将] == 1
    end
    @testset "jishogi_score(::Mochigoma)" begin
        @test jishogi_score(Mochigoma()) == 0
        @test jishogi_score(Mochigoma([0, 1, 2, 3, 4, 5, 6, 7])) == 40
    end
end