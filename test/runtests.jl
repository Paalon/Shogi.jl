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

# Kyokumen

function test_kyokumen_from_sfen(str::AbstractString)
    kyokumen = Kyokumen(str)
    @test sfen(kyokumen) == str
end

let
    "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" |> test_kyokumen_from_sfen
    "lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p 16" |> test_kyokumen_from_sfen
    "lnsgk1snl/6g2/p1pppp2p/6R2/5b3/1rP6/P2PPPP1P/1SG4S1/LN2KG1NL b B4Pp 21" |> test_kyokumen_from_sfen
    "lnsgk1sn+B/6g2/p1pppp2p/7p1/5b3/2P6/P2PPPP1P/2G4S1/LN2KG1NL w RL4Prs 28" |> test_kyokumen_from_sfen
end
