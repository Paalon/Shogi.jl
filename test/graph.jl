function isvalid_kifu_sfen(str::AbstractString)
    kifu = KifuFromSFEN(str)
    sfen(kifu) == str
end

@testset "Kifu" begin
    kifu = Kifu()
    add_move!(kifu, Kyokumen(), AbstractMove("2g2f"))
    @test sfen(kifu) == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2g2f"
    @test isvalid_kifu_sfen("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2g2f")
    @test isvalid_kifu_sfen("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2g2f 8c8d")
    @test isvalid_kifu_sfen("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2g2f 8c8d 2f2e 8d8e")
    @test isvalid_kifu_sfen("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2g2f 8c8d 2f2e 8d8e 6i7h 4a3b 7g7f 3c3d 2e2d 2c2d 2h2d 8e8f 8g8f 8b8f 2d3d 2b8h+ 7i8h P*2h 3i2h B*4e 3d2d P*2c B*7g 8f8h+ 7g8h 2c2d 8h1a+")
end