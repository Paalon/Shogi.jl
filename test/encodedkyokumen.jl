@testset "EncodedKyokumen" begin
    k = KyokumenHirate()
    ek = EncodedKyokumen(k)
    @test Kyokumen(ek) == k

    k = KyokumenHirate()
    k[8, 3] = 〼
    k[8, 5] = ☖歩兵
    k[3, 3] = 〼
    k[3, 4] = ☖歩兵
    k[2, 3] = 〼
    k[2, 4] = ☖歩兵
    k[2, 7] = 〼
    k[7, 7] = 〼
    k[7, 6] = ☗歩兵
    k.mochigoma.gote[歩兵] = 1
    ek = EncodedKyokumen(k)
    @test encode(k) == string(ek)
    @test bitstring(k) == bitstring(ek)
    @test Kyokumen(ek) == k
end