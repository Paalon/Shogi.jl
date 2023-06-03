@testset "JSA" begin
    @test JSA.string(BLACK) == "☗"
    @test JSA.string(WHITE) == "☖"

    @test JSA.string(PAWN) == "歩"
    @test JSA.string(LANCE) == "香"
    @test JSA.string(KNIGHT) == "桂"
    @test JSA.string(SILVER) == "銀"
    @test JSA.string(GOLD) == "金"
    @test JSA.string(BISHOP) == "角"
    @test JSA.string(ROOK) == "飛"
    @test JSA.string(KING) == "玉"
    @test JSA.string(PROMOTED_PAWN) == "と"
    @test JSA.string(PROMOTED_LANCE) == "成香"
    @test JSA.string(PROMOTED_KNIGHT) == "成桂"
    @test JSA.string(PROMOTED_SILVER) == "成銀"
    @test JSA.string(PROMOTED_BISHOP) == "馬"
    @test JSA.string(PROMOTED_ROOK) == "竜"

    @test JSA.string(COORDINATE34) == "３４"
    @test JSA.string(COORDINATE79) == "７９"
    @test JSA.string(COORDINATE81) == "８１"
end