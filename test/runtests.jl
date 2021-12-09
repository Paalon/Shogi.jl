using Test

using Shogi

# SFEN for test

const kyokumen_sfen_strings = [
    "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
    "lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p 2"
    "lnsgk1snl/6g2/p1pppp2p/6R2/5b3/1rP6/P2PPPP1P/1SG4S1/LN2KG1NL b B4Pp 1"
    "lnsgk1sn+B/6g2/p1pppp2p/7p1/5b3/2P6/P2PPPP1P/2G4S1/LN2KG1NL w RL4Prs 2"
    "8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L w Sbgn3p 2"
]

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
@test isempty(Masu("1", style = :sfen))
@test !isempty(Masu("P", style = :sfen))
@test isomote(Masu("L", style = :sfen))
@test isomote(Masu("p", style = :sfen))
@test !isomote(Masu("+p", style = :sfen))

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

isvalid_kyokumen(str::AbstractString) = Kyokumen(str) |> sfen == str

@test isvalid_kyokumen("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -")
@test isvalid_kyokumen("lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p")
@test isvalid_kyokumen("lnsgk1snl/6g2/p1pppp2p/6R2/5b3/1rP6/P2PPPP1P/1SG4S1/LN2KG1NL b B4Pp")
@test isvalid_kyokumen("lnsgk1sn+B/6g2/p1pppp2p/7p1/5b3/2P6/P2PPPP1P/2G4S1/LN2KG1NL w RL4Prs")
@test isvalid_kyokumen("8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L w Sbgn3p")

# SFENKyokumen

isvalid_sfenkyokumen(str::AbstractString) = SFENKyokumen(str) |> sfen == str

@test isvalid_sfenkyokumen("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1")
@test isvalid_sfenkyokumen("lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p 16")

# Move

isvalid_move(str::AbstractString) = AbstractMove(str) |> sfen == str

@test isvalid_move("2g2f")
@test isvalid_move("2h2b+")
@test isvalid_move("8b8h+")
@test isvalid_move("2b2h")
@test isvalid_move("9i1a+")
@test isvalid_move("P*8g")
@test isvalid_move("B*5e")

# Kifu

# @test sfen(Kifu()) == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
# @test sfen(Kifu("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 2g2f 8c8d")) == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 2g2f 8c8d"

# coding

@test bitstring(Koma("飛車")) == "011111"
@test bitstring(Masu("K", style = :sfen)) == ""
@test bitstring(Masu("k", style = :sfen)) == ""
@test bitstring(Masu("1", style = :sfen)) == "0"

isvalid_kyokumen_coding_length(str::AbstractString) = Kyokumen(str) |> bitstring |> length == 256
isvalid_kyokumen_coding(str::AbstractString) = Kyokumen(str) |> encode |> decode |> sfen == str

@test "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -" |> isvalid_kyokumen_coding_length
@test "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -" |> isvalid_kyokumen_coding
@test "lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p" |> isvalid_kyokumen_coding_length
@test "lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p" |> isvalid_kyokumen_coding
@test "lnsgk1snl/6g2/p1pppp2p/6R2/5b3/1rP6/P2PPPP1P/1SG4S1/LN2KG1NL b B4Pp" |> isvalid_kyokumen_coding_length
@test "lnsgk1snl/6g2/p1pppp2p/6R2/5b3/1rP6/P2PPPP1P/1SG4S1/LN2KG1NL b B4Pp" |> isvalid_kyokumen_coding
@test "lnsgk1sn+B/6g2/p1pppp2p/7p1/5b3/2P6/P2PPPP1P/2G4S1/LN2KG1NL w RL4Prs" |> isvalid_kyokumen_coding_length
@test "lnsgk1sn+B/6g2/p1pppp2p/7p1/5b3/2P6/P2PPPP1P/2G4S1/LN2KG1NL w RL4Prs" |> isvalid_kyokumen_coding
@test "8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L w Sbgn3p" |> isvalid_kyokumen_coding_length
@test "8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L w Sbgn3p" |> isvalid_kyokumen_coding