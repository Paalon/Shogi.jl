# Copyright 2021-11-25 Koki Fushimi

export SengoMochigoma
export Kyokumen, sfen, toru!, teban_pieces
export Sengo
export gettebanmochigoma
export SFENKyokumen, SFENKyokumenFromSFEN
export KyokumenHirate

import Base:
    copy, ==, show, sign,
    getindex, setindex!

"""
    Kyokumen::DataType

Type representing a shogi kyokumen without the history.
"""
mutable struct Kyokumen
    banmen::Banmen
    mochigoma::SengoMochigoma
    teban::Sengo
end
const GameState = Kyokumen

"""
    Kyokumen()::Kyokumen

Construct a vacant kyokumen. Use `KyokumenHirate` for standard shogi initial kyokumen.
"""
function Kyokumen()
    Kyokumen(
        Banmen(),
        (
            sente=Mochigoma(),
            gote=Mochigoma(),
        ),
        sente,
    )
end

"""
    KyokumenHirate()::Kyokumen

Construct the initial hirate kyokumen.
"""
function KyokumenHirate()
    Kyokumen(
        BanmenHirate(),
        (
            sente=Mochigoma(),
            gote=Mochigoma(),
        ),
        sente,
    )
end

function ==(a::Kyokumen, b::Kyokumen)
    a.banmen == b.banmen && a.mochigoma == b.mochigoma && a.teban == b.teban
end

function copy(kyokumen::Kyokumen)
    Kyokumen(
        copy(kyokumen.banmen),
        (
            sente=copy(kyokumen.mochigoma.sente),
            gote=copy(kyokumen.mochigoma.gote),
        ),
        kyokumen.teban,
    )
end

getindex(kyokumen::Kyokumen, i...) = kyokumen.banmen[i...]
setindex!(kyokumen::Kyokumen, value, i...) = kyokumen.banmen[i...] = value

issente(kyokumen::Kyokumen) = issente(kyokumen.teban)
Sengo(kyokumen::Kyokumen) = kyokumen.teban

function gettebanmochigoma(kyokumen::Kyokumen)
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
            sente=kyokumen.mochigoma.gote,
            gote=kyokumen.mochigoma.sente,
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
    (!isnothing(koma) && !isnothing(sengo)) || error("There is no koma.")
    kyokumen.teban ≠ sengo || error("Cannot capture own koma.")
    mochigoma = gettebanmochigoma(kyokumen)
    mochigoma[koma] += 1
    kyokumen[x, y] = Masu(0)
    kyokumen
end
const capture! = toru!

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

# function distance(a::Kyokumen, b::Kyokumen)
#     x = a.banmen.matrix - b.banmen.matrix
#     d_kyokumen = sum(x .≠ 0)
#     d_mochigoma = sum(abs.(a.mochigoma.sengo.komasuus - b.mochigoma.sengo.komasuus))
#     d_sengo = a.teban ≠ b.teban
#     d_kyokumen + d_mochigoma + d_sengo
# end

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

Return a jishogi score.
"""
function jishogi_score(kyokumen::Kyokumen)
    sente, gote = 0, 0
    jishogi_score(kyokumen.banmen)
    sente += jishogi_score(kyokumen.mochigoma_sente)
    gote += jishogi_score(kyokumen.mochigoma_gote)
    jishogi_score(kyokumen.banmen) + sente - gote
end

# """
#     SFENKyokumen::DataType

# Type representing a kyokumen with a tesuu.
# """
# mutable struct SFENKyokumen
#     kyokumen::Kyokumen
#     tesuu::Integer
# end

mutable struct GameStateWithPlyCount
    gamestate::GameState
    plycount::Integer
end
const 手番付き局面 = GameStateWithPlyCount

# function string(sfenkyokumen::GameStateWithPlyCount; style=:sfen)
#     if style == :sfen
#         sfen(sfenkyokumen)
#     else
#         error("Invalid style $style")
#     end
# end

issente(s::GameStateWithPlyCount) = issente(s.gamestate)
GameState(s::GameStateWithPlyCount) = GameState(copy(s.gamestate))
plycount(s::GameStateWithPlyCount) = s.plycount