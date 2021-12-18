export CSAMove
export next!, next

abstract type CSAMove <: KyokumenMove end

struct CSAOnBoardMove <: CSAMove
    sengo::Sengo
    src::Tuple{Integer, Integer}
    dst::Tuple{Integer, Integer}
    koma::Koma
end

function Sengo(move::CSAMove)
    move.sengo
end

struct CSADrop <: CSAMove
    sengo::Sengo
    dst::Tuple{Integer, Integer}
    koma::Koma
end

function CSAMove(str::AbstractString)
    sengo = SengoFromCSA(string(str[1]))
    src = int_to_hankaku(str[2]), int_to_hankaku(str[3])
    dst = int_to_hankaku(str[4]), int_to_hankaku(str[5])
    koma = KomaFromCSA(str[6:7])
    if src == (0, 0)
        CSADrop(sengo, dst, koma)
    else
        CSAOnBoardMove(sengo, src, dst, koma)
    end
end

function next!(kyokumen::Kyokumen, move::CSAOnBoardMove)
    Sengo(kyokumen) == move.sengo || error("手番が一致しない。")
    sengo = move.sengo
    Sengo(kyokumen[move.dst...]) ≠ sengo || error("移動先に自分の駒がある。")
    src_koma = Koma(kyokumen[move.src...])
    dst_koma = move.koma
    src_koma == dst_koma ||
        (naru(src_koma) == dst_koma && ispromotable(sengo, src_koma, move.src, move.dst)) ||
        error("移動前と移動後で駒の種類が成・不成を含めても一致しない。")
    if kyokumen[move.dst...] ≠ 〼
        dst_enemy_koma = Koma(kyokumen[move.dst...])
        gettebanmochigoma(kyokumen)[dst_enemy_koma] += 1
    end
    kyokumen[move.dst...] = Masu(sengo, dst_koma)
    kyokumen[move.src...] = 〼
    kyokumen.teban = next(kyokumen.teban)
    kyokumen
end

function next!(kyokumen::Kyokumen, move::CSADrop)
    Sengo(kyokumen) == move.sengo || error("手番が一致しない。")
    kyokumen[move.dst...] ≠ 〼 || error("移動先が空きマスでない。")
    gettebanmochigoma(kyokumen)[move.koma] ≥ 1 || error("打ちたい駒を持っていない。")
    kyokumen[move.dst...] = move.koma
    gettebanmochigoma(kyokumen)[move.koma] -= 1
    kyokumen.teban = next(kyokumen.teban)
    kyokumen
end

function next(kyokumen::Kyokumen, move::CSAMove)
    kyokumen = copy(kyokumen)
    next!(kyokumen, move)
end