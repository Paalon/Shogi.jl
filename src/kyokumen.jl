# Copyright 2021-11-25 Koki Fushimi

export SengoMochigoma
export Kyokumen, sfen, teban_mochigoma, toru!, teban_pieces
export SFENKyokumen, SFENKyokumenFromSFEN
export KyokumenHirate

import Base:
    copy, ==, show, sign,
    getindex, setindex!

"""
    Kyokumen

A position state type of shogi game without history.
"""
mutable struct Kyokumen
    banmen::Banmen
    mochigoma::SengoMochigoma
    teban::Sengo
end

"""
    Kyokumen()

Construct a vacant kyokumen.
"""
function Kyokumen()
    Kyokumen(
        Banmen(),
        (
            sente = Mochigoma(),
            gote = Mochigoma(),
        ),
        先手,
    )
end

"""
    KyokumenHirate()

Construct the hirate initial kyokumen.
"""
function KyokumenHirate()
    Kyokumen(
        BanmenHirate(),
        (
            sente = Mochigoma(),
            gote = Mochigoma(),
        ),
        先手,
    )
end

function ==(a::Kyokumen, b::Kyokumen)
    a.banmen == b.banmen && a.mochigoma == b.mochigoma && a.teban == b.teban
end

function copy(kyokumen::Kyokumen)
    Kyokumen(
        copy(kyokumen.banmen),
        (
            sente = copy(kyokumen.mochigoma.sente),
            gote = copy(kyokumen.mochigoma.gote),
        ),
        kyokumen.teban,
    )
end

function getindex(kyokumen::Kyokumen, i...)
    kyokumen.banmen[i...]
end

function setindex!(kyokumen::Kyokumen, value, i...)
    kyokumen.banmen[i...] = value
end

function issente(kyokumen::Kyokumen)
    issente(kyokumen.teban)
end

function teban_mochigoma(kyokumen::Kyokumen)
    if issente(kyokumen)
        kyokumen.mochigoma.sente
    else
        kyokumen.mochigoma.gote
    end
end

function rot180(kyokumen::Kyokumen)
    Kyokumen(
        rot180(kyokumen.banmen),
        (
            sente = kyokumen.mochigoma.gote,
            gote = kyokumen.mochigoma.sente,
        ),
        next(kyokumen.teban)
    )
end

function rot180!(kyokumen::Kyokumen)
    rot180!(kyokumen.banmen)
    kyokumen.mochigoma.sente, kyokumen.mochigoma.gote = kyokumen.mochigoma.gote, kyokumen.mochigoma.sente
    kyokumen.teban = next(kyokumen.teban)
    kyokumen
end

function swap_sengo(kyokumen::Kyokumen)

end

# function Kyokumen(str::AbstractString; style = :sfen)
#     banmen_str, teban_str, mochigoma_str = split(str, " ")
#     banmen = Banmen(banmen_str)
#     mochigoma = parse_mochigoma(mochigoma_str)
#     teban = Sengo(teban_str)
#     Kyokumen(banmen, mochigoma, teban)
# end

# function Base.string(kyokumen::Kyokumen)
#     sfen(kyokumen)
# end

# function Base.sign(kyokumen::Kyokumen)
#     sign(kyokumen.teban)
# end

# function next!(kyokumen::Kyokumen)
#     kyokumen.teban = next(kyokumen.teban)
#     kyokumen.tesuu = next(kyokumen.tesuu)
#     kyokumen
# end

function toru!(kyokumen::Kyokumen, x::Integer, y::Integer)
    masu = kyokumen[x, y]
    koma = Koma(masu)
    sengo = Sengo(masu)
    if !isnothing(koma) && !isnothing(sengo)
        if kyokumen.teban ≠ sengo
            mochigoma = teban_mochigoma(kyokumen)
            mochigoma[koma] += 1
            kyokumen[x, y] = Masu(0)
        else
            error("Cannot capture own koma.")
        end
    else
        error("There is no koma.")
    end
    kyokumen
end

function remaining_koma_omote(kyokumen::Kyokumen)
    onboard = Mochigoma()
    for i = 1:9, j = 1:9
        koma = omote(Koma(kyokumen[i, j]))
        if !isnothing(koma)
            onboard[koma] += 1
        end
    end
    x = [2, 2, 2, 4, 4, 4, 4, 18] - onboard.matrix - kyokumen.mochigoma.sente.matrix - kyokumen.mochigoma.gote.matrix
    Mochigoma(x)
end

const bitboard_zeros = SMatrix{9,9,Bool}(zeros(Bool, 9, 9))

function bitboard_mutable()
    MMatrix{9,9,Bool}(zeros(Bool, 9, 9))
end

function bitboard_teban_pieces(kyokumen::Kyokumen)
    a = zeros(Bool, 9, 9)
    for x = 1:9, y = 1:9
        masu = kyokumen[x, y]
        a[x, y] = kyokumen.teban == Sengo(masu)
    end
    SMatrix{9,9,Bool}(a)
end

function teban_pieces_index(kyokumen::Kyokumen)
    board = bitboard_teban_pieces(kyokumen)
    ret = Tuple{<:Integer,<:Integer}[]
    for x = 1:9, y = 1:9
        if board[x, y]
            push!(ret, (x, y))
        end
    end
    ret
end

function teban_pieces_index(kyokumen::Kyokumen, koma::Koma)
    board = bitboard_teban_pieces(kyokumen)
    ret = Tuple{<:Integer,<:Integer}[]
    for x = 1:9, y = 1:9
        if board[x, y] && koma == Koma(kyokumen[x, y])
            push!(ret, (x, y))
        end
    end
    ret
end

function remove_outofboard!(xs::Vector{Tuple{Integer,Integer}})
    for x in xs
        i, j = x
        if !(1 ≤ i ≤ 9 && 1 ≤ j ≤ 9)
            pop!(xs)
        end
    end
    xs
end

function bitboard_movable(kyokumen::Kyokumen, x::Integer, y::Integer)
    masu = kyokumen[x, y]
    if isempty(masu)
        bitboard_zeros
    else
        sengo = Sengo(masu)
        koma = Koma(masu)
        if koma == 歩兵
            movements_candidate = movement_fu(sengo)
            # if movements_candidate
        end
        koma
    end
end

function attack(kyokumen::Kyokumen, masu::Masu)

end

"""
    jishogi_score(kyokumen::Kyokumen)
Return score for jishogi.
"""
function jishogi_score(kyokumen::Kyokumen)
    sente, gote = 0, 0
    jishogi_score(kyokumen.banmen)
    sente += jishogi_score(kyokumen.mochigoma_sente)
    gote += jishogi_score(kyokumen.mochigoma_gote)
    jishogi_score(kyokumen.banmen) + sente - gote
end

"""
    SFENKyokumen

A kyokumen with tesuu.
"""
mutable struct SFENKyokumen
    kyokumen::Kyokumen
    tesuu::Integer
end

function sfen(sfenkyokumen::SFENKyokumen)
    "$(sfen(sfenkyokumen.kyokumen)) $(sfenkyokumen.tesuu)"
end

function string(sfenkyokumen::SFENKyokumen; style = :sfen)
    if style == :sfen
        sfen(sfenkyokumen)
    else
        error("Invalid style $style")
    end
end

function issente(sfenkyokumen::SFENKyokumen)
    issente(sfenkyokumen.kyokumen)
end

function SFENKyokumen(str::AbstractString)
    banmen_str, teban_str, mochigoma_str, tesuu_str = split(str, " ")
    kyokumen = Kyokumen(join((banmen_str, teban_str, mochigoma_str), " "))
    tesuu = parse(Int, tesuu_str)
    SFENKyokumen(kyokumen, tesuu)
end

function SFENKyokumenFromSFEN(str::AbstractString)
    banmen_str, teban_str, mochigoma_str, tesuu_str = split(str, " ")
    kyokumen = Kyokumen(join((banmen_str, teban_str, mochigoma_str), " "))
    tesuu = parse(Int, tesuu_str)
    SFENKyokumen(kyokumen, tesuu)
end

function Kyokumen(sfenkyokumen::SFENKyokumen)
    Kyokumen(copy(sfenkyokumen.kyokumen))
end