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
@test Koma("+R"; style=:sfen) == Koma("竜"; style=:ichiji)
@test "と金" |> Koma |> sfen == "+P"
@test Koma("杏", style=:ichiji) |> sfen == "+L"

# Masu

@test Masu(Koma("竜王"), Sengo("b")) == Masu("+R")
@test Masu(Koma("竜王"), Sengo("w")) == Masu("+r")

# let
#     mochigoma = Mochigoma()
#     mochigoma.komasuu[8] += 1
#     @test mochigoma[歩兵] == 1
# end

