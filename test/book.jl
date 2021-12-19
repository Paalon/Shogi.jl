@testset "Book" begin
    a = Kifu(KyokumenHirate(), SFENMoves("2g2f 8c8d 7g7f 3c3d"))
    b = Kifu(KyokumenHirate(), SFENMoves("2g2f 8c8d 7g7f 3c3d"))
    @test a == b

    a = Kifu(KyokumenHirate(), SFENMoves("2g2f 8c8d 7g7f 3c3d"))
    b = Kifu(KyokumenHirate(), SFENMoves("7g7f 3c3d 2g2f 8c8d"))
    c = merge(a, b)
    d = merge(b, a)
    @test c == d
end