using Test

using Shogi

# Sengo

@test Sengo(true) == Sengo("b")
@test Sengo(true) == Sengo('b')
@test Sengo(false) == Sengo("w")
@test Sengo(false) == Sengo('w')
@test Shogi.sente == Sengo(true)
@test Shogi.gote == Sengo(false)
@test Shogi.sente |> next == Shogi.gote

# Tesuu

@test Integer(next(Tesuu(23))) == 24

# Koma

@test Koma("金将") |> isomote
@test Koma("成銀") |> isnarigoma
@test Koma("+R"; style = :sfen) == Koma("竜"; style = :ichiji)
@test "と金" |> Koma |> sfen == "+P"
@test Koma("杏", style = :ichiji) |> sfen == "+L"

# Masu

@test Masu(Koma("竜王"), Sengo("b")) == Masu("+R")
@test Masu(Koma("竜王"), Sengo("w")) == Masu("+r")

# Mochigoma

@test Mochigoma("B3P")[Koma("歩兵")] == 3
@test Mochigoma("rnl" |> uppercase)[Koma("飛車")] == 1

let
    mochigoma = Mochigoma()
    mochigoma[Koma("歩兵")] = 12
    mochigoma[Koma("飛車")] = 2
    mochigoma[Koma("桂馬")] = 4
    @test mochigoma[Koma("歩兵")] == 12
    @test mochigoma[Koma("飛車")] == 2
    @test mochigoma[Koma("桂馬")] == 4
end

# Banmen

let
    banmen = Banmen()
    banmen[1, 1] = Masu(Koma("飛車"), Shogi.sente)
    sfen(banmen) == "8R/9/9/9/9/9/9/9/9"

    banmen = Banmen()
    banmen[1, 1] = Masu(Koma("飛車"), Shogi.sente)
    sfen(banmen) == "8R/9/9/9/9/9/9/9/9"

    banmen = Banmen("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL")
    @test sfen(banmen) == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"
end

# let
#     mochigoma = Mochigoma()
#     mochigoma.komasuu[8] += 1
#     @test mochigoma[歩兵] == 1
# end

