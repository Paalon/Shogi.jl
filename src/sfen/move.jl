export SFENMove, SFENMoves
export next!, next

import Base.string

"""
    SFENMove <: KyokumenMove

Type for a SFEN move.
"""
abstract type SFENMove <: KyokumenMove end

"""
    SFENOnBoardMove <: SFENMove

Type for a SFEN on board move.
"""
struct SFENOnBoardMove <: SFENMove
    src::Tuple{Integer,Integer}
    dst::Tuple{Integer,Integer}
    ispromotion::Bool
end

"""
    SFENDrop <: SFENMove

Type for a SFEN drop move.
"""
struct SFENDrop <: SFENMove
    koma::Koma
    dst::Tuple{Integer,Integer}
end

function SFENDropNoCheck(str::AbstractString)
    koma = KomaFromSFEN(string(str[1]))
    x = int_to_hankaku(str[3])
    y = int_to_sfen_dan(str[4])
    dst = (x, y)
    SFENDrop(koma, dst)
end

function SFENDrop(str::AbstractString)
    (length(str) == 4 && str[2] == '*') || error()
    SFENDropNoCheck(str)
end

function SFENOnBoardMove(str::AbstractString)
    n = length(str)
    4 ≤ n ≤ 5 || error()
    src = int_to_hankaku(str[1]), int_to_sfen_dan(str[2])
    dst = int_to_hankaku(str[3]), int_to_sfen_dan(str[4])
    ispromotion_ = ifelse(n == 5 && str[5] == '+', true, false)
    SFENOnBoardMove(src, dst, ispromotion_)
end

"""
    SFENMove(str::AbstractString)

Construct a SFEN move from SFEN string `str`.
"""
function SFENMove(str::AbstractString)
    if length(str) == 4 && str[2] == '*'
        SFENDropNoCheck(str)
    else
        SFENOnBoardMove(str)
    end
end

function Base.string(move::SFENOnBoardMove)
    x0, y0 = move.src
    x1, y1 = move.dst
    y0_char = int_to_sfen_dan[y0]
    y1_char = int_to_sfen_dan[y1]
    if move.ispromotion
        "$x0$y0_char$x1$y1_char+"
    else
        "$x0$y0_char$x1$y1_char"
    end
end

function Base.string(move::SFENDrop)
    x, y = move.dst
    y_char = int_to_sfen_dan[y]
    koma_str = sfen(move.koma)
    "$koma_str*$x$y_char"
end

function next!(kyokumen::Kyokumen, move::SFENDrop)
    koma = move.koma
    mochigoma = gettebanmochigoma(kyokumen)
    mochigoma[koma] ≥ 1 || error("$kyokumen\n$move")
    mochigoma[koma] -= 1
    kyokumen[move.dst...] = Masu(kyokumen.teban, koma)
    kyokumen.teban = next(kyokumen.teban)
    kyokumen
end

function next!(kyokumen::Kyokumen, move::SFENOnBoardMove)
    dst_koma = Koma(kyokumen[move.dst...])
    if !isnothing(dst_koma)
        gettebanmochigoma(kyokumen)[dst_koma] += 1
    end
    if move.ispromotion
        kyokumen[move.dst...] = naru(kyokumen[move.src...])
        kyokumen[move.src...] = 〼
    else
        kyokumen[move.dst...] = kyokumen[move.src...]
        kyokumen[move.src...] = 〼
    end
    kyokumen.teban = next(kyokumen.teban)
    kyokumen
end

function next(kyokumen::Kyokumen, move::SFENMove)
    kyokumen = copy(kyokumen)
    next!(kyokumen, move)
end

# function sfen(move::EncodedMove)

# end

function SFENMoves(str::AbstractString)
    SFENMove.(split(str, " "))
end