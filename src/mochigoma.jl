# Copyright 2021-11-25 Koki Fushimi

export Mochigoma

import Base:
    getindex, setindex!, string, show

"""
    Mochigoma

Type for mochigoma of shogi.
"""
mutable struct Mochigoma
    komasuus::Vector{Int8}
end

function Mochigoma()
    Mochigoma(zeros(Int8, 8))
end

mochigoma_index(koma::Koma) = Integer(koma) ÷ 2
KomaFromMochigomaIndex(index::Integer) = Koma(2index)

function getindex(mochigoma::Mochigoma, koma::Koma)
    mochigoma.komasuus[mochigoma_index(koma)]
end

function setindex!(mochigoma::Mochigoma, n::Integer, koma::Koma)
    mochigoma.komasuus[mochigoma_index(koma)] = n
end

"""
    Mochigoma(str::AbstractString)

Construct `Mochigoma` object from SFEN Mochigoma string.
See detail http://shogidokoro.starfree.jp/usi.html for SFEN format in USI.
"""
function Mochigoma(str::AbstractString; style=:sfen)
    if style == :sfen
        mochigoma = Mochigoma()
        iter_res = iterate(str)
        while !isnothing(iter_res)
            char, stat = iter_res
            if isdigit(char)
                n = hankaku_suuji_to_int8(char)
                char, stat = iterate(str, stat)
                index = mochigoma_index(Koma(string(char), style = :sfen))
                mochigoma.komasuus[index] = n
            else
                n = 1
                index = mochigoma_index(Koma(string(char), style = :sfen))
                mochigoma.komasuus[index] = n
            end
            iter_res = iterate(str, stat)
        end
        mochigoma
    else
        error("Invalid style: $style")
    end
end

function Base.string(mochigoma::Mochigoma; style=:sfen)
    if style == :sfen
        ret = ""
        for (i, n) in enumerate(mochigoma.komasuus)
            if n == 0
                # do nothing
            elseif n == 1
                koma = KomaFromMochigomaIndex(i)
                ret *= sfen(koma)
            elseif n > 1
                ret *= n |> string
                koma = KomaFromMochigomaIndex(i)
                ret *= sfen(koma)
            else
                error("Invalid mochigoma state.")
            end
        end
        ret
    elseif style == :ichiji
        ret = ""
        for (i, n) in enumerate(mochigoma.komasuus)
            if n == 0
            elseif n == 1
                ret *= string(KomaFromMochigomaIndex(i); style = :ichiji)
            else
                ret *= string(KomaFromMochigomaIndex(i); style = :ichiji)
                n_str = n |> string
                for n_char in n_str
                    ret *= n_char |> hankaku_suuji_to_zenkaku_suuji |> string
                end
            end
        end
        ret
    end
end

"""
    sfen(mochigoma::Mochigoma)

Return SFEN string.
"""
function sfen(mochigoma::Mochigoma)
    string(mochigoma; style=:sfen)
end

# function Base.AbstractVecOrTupleshow(io::IO, mochigoma::Mochigoma)
#     print(io, string(mochigoma))
# end

function jishogi_score(mochigoma::Mochigoma)
    sum(mochigoma.komasuus .* [0, 5, 5, 1, 1, 1, 1, 1])
end