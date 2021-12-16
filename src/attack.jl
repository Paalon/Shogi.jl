# 合法手の生成
# 王手のチェック
# 行けない駒のチェック
# 千日手
# 打ち歩詰め
# 両王手
# 開き王手
# 入玉宣言

# MIT License
# Copyright 2017 merom686
# Copyright 2021-12-14 Koki Fushimi

export attack
export sente, gote
export ue, shita, migi, hidari, migiue, migishita, hidariue, hidarishita
ue(sengo::Sengo) = 0, -sign(sengo)
shita(sengo::Sengo) = 0, sign(sengo)
migi(sengo::Sengo) = -sign(sengo), 0
hidari(sengo::Sengo) = sign(sengo), 0

migiue(sengo::Sengo) = migi(sengo) .+ ue(sengo)
migishita(sengo::Sengo) = migi(sengo) .+ shita(sengo)
hidariue(sengo::Sengo) = hidari(sengo) .+ ue(sengo)
hidarishita(sengo::Sengo) = hidari(sengo) .+ shita(sengo)

yoko(sengo::Sengo) = [migi(sengo), hidari(sengo)]
tate(sengo::Sengo) = [ue(sengo), shita(sengo)]
tateyoko(sengo::Sengo) = [tate(sengo)..., yoko(sengo)...]
uenaname(sengo::Sengo) = [migiue(sengo), hidariue(sengo)]
shitananame(sengo::Sengo) = [migishita(sengo), hidarishita(sengo)]
naname(sengo::Sengo) = [uenaname(sengo)..., shitananame(sengo)...]

歩兵の動き方(sengo::Sengo) = [ue(sengo)]
桂馬の動き方(sengo::Sengo) = [(1, -2sign(sengo)), (-1, -2sign(sengo))]
銀将の動き方(sengo::Sengo) = [naname(sengo)..., ue(sengo)]
金将の動き方(sengo::Sengo) = [tateyoko(sengo)..., miginaname(sengo)...]
玉将の動き方(sengo::Sengo) = [tateyoko(sengo)..., naname(sengo)...]

function islocal(koma::Koma)
    n = Integer(koma)
    n == 2 || 8 ≤ n ≤ 13 || 15 ≤ n ≤ 17
end

function maptupleadd(x::Tuple{Integer, Integer}, ys::Vector{Tuple{Integer, Integer}})
    [x .+ y for y in ys]
end

function remove_outofboard(as::Vector{Tuple{Integer,Integer}})
    ret = Tuple{Integer, Integer}[]
    for a in as
        x, y = a
        if 1 ≤ x ≤ 9 && 1 ≤ y ≤ 9
            push!(ret, a)
        end
    end
    ret
end

function isally(sengo::Sengo, masu::Masu)
    sengo == Sengo(masu)
end

function isally(kyokumen::Kyokumen, masu::Masu)
    isally(kyokumen.teban, masu)
end

function remove_ally(kyokumen::Kyokumen, positions::Vector{Tuple{Integer, Integer}})
    ret = Tuple{Integer, Integer}[]
    for position in positions
        x, y = position
        masu = kyokumen[x, y]
        if !isally(kyokumen, masu)
            push!(ret, position)
        end
    end
    ret
end

# 二歩のチェック

function check_notnifu(kyokumen::Kyokumen, move::Move)
    true
end

function check_notnifu(kyokumen::Kyokumen, drop::Drop)
    x, _ = to(drop)
    if Koma(drop) == 歩兵 && Masu(歩兵, kyokumen.teban) ∈ kyokumen[x, :]
        false
    else
        true
    end
end

"""
    check_notnifu(kyokumen::Kyokumen, move::AbstractMove)

Return `true` if the `move` on the `kyokumen` is not nifu, otherwise `false`.
"""
check_notnifu

# 行き所のない駒のチェック

function forward_rank(sengo::Sengo, n::Integer)
    if issente(sengo)
        n
    else
        typeof(n)(10) - n
    end
end

function check_notikidokorononaikoma(kyokumen::Kyokumen, drop::Drop)
    koma = Drop(koma)
    _, y = to(koma)
    if koma == 歩兵
        if forward_rank(sengo, y) == 1
            false
        else
            true
        end
    elseif koma == 香車
        if forward_rank(sengo, y) == 1
            false
        else
            true
        end
    elseif koma == 桂馬
        if forward_rank(sengo, y) ≤ 2
            false
        else
            true
        end
    else
        true
    end
end

function check_notikidokorononaikoma(kyokumen::Kyokumen, move::Move)
    koma = Koma(kyokumen, move)
    sengo = kyokumen.teban
    _, y = to(move)
    if isnothing(koma)
        error("Invalid move $move")
    elseif move.ispromote
        true
    elseif koma == 歩兵
        if forward_rank(sengo, y) == 1
            false
        else
            true
        end
    elseif koma == 香車
        if forward_rank(sengo, y) == 1
            false
        else
            true
        end
    elseif koma == 桂馬
        if forward_rank(sengo, y) ≤ 2
            false
        else
            true
        end
    else
        true
    end
end

# 

function 利き(kyokumen::Kyokumen, x::Integer, y::Integer)

end

function attack(kyokumen::Kyokumen, x::Integer, y::Integer)
    masu = kyokumen[x, y]
    ret = Tuple{Integer,Integer}[]
    if isempty(masu)
        ret
    else
        koma = Koma(masu)
        sengo = Sengo(masu)
        if islocal(koma)
            if koma == 歩兵
                positions = maptupleadd((x, y), 歩兵の動き方(sengo))
                positions = remove_outofboard(positions)
                positions = remove_ally(kyokumen, positions)
                positions = remove_checked(kyokumen, positions)
            elseif koma == 金将 || 成銀 || 成桂 || 成香 || と金
                positions = maptupleadd((x, y), 金将の動き方(sengo))
                positions = remove_outofboard(positions)
            elseif koma == 桂馬
            elseif koma == 銀将
                movement_ginshou()
            elseif koma == 玉将
                ret = movement_gyoku()
            end
        else
            if koma == 香車
            elseif koma == 飛車
            elseif koma == 角行
            elseif koma == 竜王
            elseif koma == 竜馬
            end
        end
    end
end