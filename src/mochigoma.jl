# Copyright 2021-11-25 Koki Fushimi

export Mochigoma

import Base:
    copy, ==, getindex, setindex!, string, show, isempty
using StaticArrays

"""
    Mochigoma

Type for mochigoma of shogi.
"""
mutable struct Mochigoma
    komasuus::MVector{8,Int8}
end

function Mochigoma()
    Mochigoma(MVector{8,Int8}(zeros(Int8, 8)))
end

function copy(mochigoma::Mochigoma)
    Mochigoma(copy(mochigoma.komasuus))
end

function ==(a::Mochigoma, b::Mochigoma)
    a.komasuus == b.komasuus
end

mochigoma_index(koma::Koma) = Integer(koma) ÷ 2
KomaFromMochigomaIndex(index::Integer) = Koma(2index)

function getindex(mochigoma::Mochigoma, koma::Koma)
    mochigoma.komasuus[mochigoma_index(koma)]
end

function setindex!(mochigoma::Mochigoma, n::Integer, koma::Koma)
    mochigoma.komasuus[mochigoma_index(koma)] = n
end

function isempty(mochigoma::Mochigoma)
    mochigoma == Mochigoma()
end

function jishogi_score(mochigoma::Mochigoma)
    sum(mochigoma.komasuus .* [0, 5, 5, 1, 1, 1, 1, 1])
end

function distance(m0::Mochigoma, m1::Mochigoma)
    sum(abs.(m1.komasuus - m0.komasuus))
end