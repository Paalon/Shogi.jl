@testset "attack" begin
    @testset "isonboard" begin
        @test let
            for i = 1:9, j = 1:9
                if !isonboard((i, j))
                    return false
                end
            end
            true
        end
        @test isonboard((0, 5)) == false
        @test isonboard((5, 0)) == false
        @test isonboard((10, 5)) == false
        @test isonboard((5, 10)) == false
        @test isonboard((0, 0)) == false
        @test isonboard((10, 10)) == false
    end
    @testset "ispromotable" begin
        @test ispromotable(先手, (2, 8), (2, 1))
        @test ispromotable(先手, (2, 1), (2, 8))
        @test ispromotable(後手, (8, 6), (8, 7))
        @test ispromotable(後手, (8, 7), (8, 6))
        @test ispromotable(先手, (2, 6), (2, 7)) == false
        @test ispromotable(後手, (8, 3), (8, 4)) == false
    end
    @testset "getexistent" begin
        @test getexistent(KyokumenHirate()) == SShogiBoard{Bool}([
            1 0 1 0 0 0 1 0 1
            1 1 1 0 0 0 1 1 1
            1 0 1 0 0 0 1 0 1
            1 0 1 0 0 0 1 0 1
            1 0 1 0 0 0 1 0 1
            1 0 1 0 0 0 1 0 1
            1 0 1 0 0 0 1 0 1
            1 1 1 0 0 0 1 1 1
            1 0 1 0 0 0 1 0 1
        ])
    end
    @testset "getally" begin
        @test getally(KyokumenHirate()) == SShogiBoard{Bool}([
            0 0 0 0 0 0 1 0 1
            0 0 0 0 0 0 1 1 1
            0 0 0 0 0 0 1 0 1
            0 0 0 0 0 0 1 0 1
            0 0 0 0 0 0 1 0 1
            0 0 0 0 0 0 1 0 1
            0 0 0 0 0 0 1 0 1
            0 0 0 0 0 0 1 1 1
            0 0 0 0 0 0 1 0 1
        ])
    end
    @testset "pawn_movements" begin
        hirate = KyokumenHirate()
        bbe = getexistent(hirate)
        bba = getally(hirate)
        @test Shogi.pawn_movements(先手, (2, 7), bbe, bba) |> Set == [(2, 6)] |> Set
        @test Shogi.pawn_movements(先手, (2, 8), bbe, bba) |> Set == [] |> Set
        @test Shogi.pawn_movements(先手, (2, 4), bbe, bba) |> Set == [(2, 3)] |> Set
        @test Shogi.pawn_movements(先手, (2, 1), bbe, bba) |> Set == [] |> Set
        hirate.teban = 後手
        bbe = getexistent(hirate)
        bba = getally(hirate)
        @test Shogi.pawn_movements(後手, (8, 3), bbe, bba) |> Set == [(8, 4)] |> Set
        @test Shogi.pawn_movements(後手, (8, 2), bbe, bba) |> Set == [] |> Set
        @test Shogi.pawn_movements(後手, (8, 6), bbe, bba) |> Set == [(8, 7)] |> Set
        @test Shogi.pawn_movements(後手, (8, 9), bbe, bba) |> Set == [] |> Set
    end
    @testset "lance_movements" begin
        hirate = KyokumenHirate()
        bbe = getexistent(hirate)
        bba = getally(hirate)
        @test Shogi.lance_movements(先手, (1, 9), bbe, bba) |> Set == Set([(1, 8)])
        @test Shogi.lance_movements(先手, (1, 8), bbe, bba) |> Set == Set([])
        @test Shogi.lance_movements(先手, (1, 7), bbe, bba) |> Set == Set([(1, 3), (1, 4), (1, 5), (1, 6)])
        @test Shogi.lance_movements(先手, (1, 6), bbe, bba) |> Set == Set([(1, 3), (1, 4), (1, 5)])
        @test Shogi.lance_movements(先手, (1, 5), bbe, bba) |> Set == Set([(1, 3), (1, 4)])
        @test Shogi.lance_movements(先手, (1, 4), bbe, bba) |> Set == Set([(1, 3)])
        @test Shogi.lance_movements(先手, (1, 3), bbe, bba) |> Set == Set([(1, 1), (1, 2)])
        @test Shogi.lance_movements(先手, (1, 2), bbe, bba) |> Set == Set([(1, 1)])
        @test Shogi.lance_movements(先手, (1, 1), bbe, bba) |> Set == Set([])
        hirate.teban = 後手
        bbe = getexistent(hirate)
        bba = getally(hirate)
    end
    @testset "rook_movements" begin
        hirate = KyokumenHirate()
        bbe = getexistent(hirate)
        bba = getally(hirate)
        @test Set(Shogi.rook_movements(先手, (1, 9), bbe, bba)) == Set([(1, 8)])
        @test Set(Shogi.rook_movements(先手, (1, 8), bbe, bba)) == Set([])
        @test Set(Shogi.rook_movements(先手, (1, 7), bbe, bba)) == Set([(1, 3), (1, 4), (1, 5), (1, 6), (1, 8)])
        @test Set(Shogi.rook_movements(先手, (1, 6), bbe, bba)) == Set([(1, 3), (1, 4), (1, 5), (9, 6), (8, 6), (7, 6), (6, 6), (5, 6), (4, 6), (3, 6), (2, 6)])
        @test Set(Shogi.rook_movements(先手, (1, 5), bbe, bba)) == Set([(1, 3), (1, 4), (1, 6), (9, 5), (8, 5), (7, 5), (6, 5), (5, 5), (4, 5), (3, 5), (2, 5)])
        @test Set(Shogi.rook_movements(先手, (1, 4), bbe, bba)) == Set([(1, 3), (1, 5), (1, 6), (9, 4), (8, 4), (7, 4), (6, 4), (5, 4), (4, 4), (3, 4), (2, 4)])
        @test Set(Shogi.rook_movements(先手, (1, 3), bbe, bba)) == Set([(1, 1), (1, 2), (1, 4), (1, 5), (1, 6), (2, 3)])
        @test Set(Shogi.rook_movements(先手, (1, 2), bbe, bba)) == Set([(1, 1), (1, 3), (2, 2)])
        @test Set(Shogi.rook_movements(先手, (1, 1), bbe, bba)) == Set([(2, 1), (1, 2), (1, 3)])
    end
    @testset "movements" begin
        kyokumen = Kyokumen()
        @test movements(kyokumen, (1, 9), 歩兵) |> Set == [(1, 8)] |> Set
        @test movements(kyokumen, (1, 1), 歩兵) |> Set == [] |> Set
    end
end