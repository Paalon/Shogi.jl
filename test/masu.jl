using Test
using Shogi

@test Masu(Koma("竜王"), Sengo("b")) == Masu("+R")
@test Masu(Koma("竜王"), Sengo("w")) == Masu("+r")

@test isempty(MasuFromSFEN("1")) == true
@test isempty(MasuFromSFEN("P")) == false
@test isomote(MasuFromSFEN("L")) == true
@test isomote(MasuFromSFEN("p")) == true
@test isomote(MasuFromSFEN("+p")) == false

@test ispromotable(MasuFromSFEN("S")) == true
@test ispromotable(MasuFromSFEN("s")) == true
@test ispromotable(MasuFromSFEN("P")) == true
@test ispromotable(MasuFromSFEN("p")) == true
@test ispromotable(MasuFromSFEN("+S")) == false
@test ispromotable(MasuFromSFEN("+s")) == false
@test ispromotable(MasuFromSFEN("+P")) == false
@test ispromotable(MasuFromSFEN("+p")) == false
@test ispromotable(MasuFromSFEN("K")) == false
@test ispromotable(MasuFromSFEN("k")) == false
@test ispromotable(MasuFromSFEN("G")) == false
@test ispromotable(MasuFromSFEN("g")) == false
@test ispromotable(MasuFromSFEN("1")) |> isnothing

@test naru(MasuFromSFEN("S")) == MasuFromSFEN("+S")
@test naru(MasuFromSFEN("s")) == MasuFromSFEN("+s")
@test naru(MasuFromSFEN("1")) |> isnothing
@test naru(MasuFromSFEN("K")) |> isnothing
@test naru(MasuFromSFEN("G")) |> isnothing
