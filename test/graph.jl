@testset "Kifu" begin
    kifu = Kifu()
    add_move!(kifu, Kyokumen(), AbstractMove("2g2f"))
    @test sfen(kifu) == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2g2f"
end