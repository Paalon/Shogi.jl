@testset "util" begin
    @test Shogi.int_to_hankaku[2] == '2'
    @test Shogi.int_to_hankaku('2') == 2
    @test Shogi.int_to_zenkaku[2] == '２'
    @test Shogi.int_to_zenkaku('２') == 2
    @test Shogi.int_to_kansuuji[2] == '二'
    @test Shogi.int_to_kansuuji('二') == 2
    @test Shogi.int_to_sfen_dan[2] == 'b'
    @test Shogi.int_to_sfen_dan('b') == 2
end