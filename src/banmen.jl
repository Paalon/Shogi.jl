# Copyright 2021-11-25 Koki Fushimi

export Banmen
export swap_sengo, swap_sengo!
export rot180!
export BanmenHirate

using StaticArrays
import Base:
    copy, ==, iterate, size, getindex, setindex!, length, show, string, strides, rot180

mutable struct Banmen
    matrix::MMatrix{9,9,Int8,81}
end

function Banmen()
    Banmen(MMatrix{9,9}(zeros(Int8, 9, 9)))
end

function copy(banmen::Banmen)
    Banmen(copy(banmen.matrix))
end

function ==(a::Banmen, b::Banmen)
    a.matrix == b.matrix
end

function iterate(banmen::Banmen)
    res = iterate(banmen.matrix)
    if !isnothing(res)
        f, i = res
        Masu(f), i
    else
        res
    end
end

function iterate(banmen::Banmen, state)
    res = iterate(banmen.matrix, state)
    if !isnothing(res)
        f, i = res
        Masu(f), i
    else
        res
    end
end

function size(banmen::Banmen)
    size(banmen.matrix)
end

function getindex(banmen::Banmen, i...)
    Masu.(banmen.matrix[i...])
end

function setindex!(banmen::Banmen, masu, i...)
    banmen.matrix[i...] = Integer.(masu)
end

function strides(banmen::Banmen)
    strides(banmen.matrix)
end

function length(banmen::Banmen)
    length(banmen.matrix)
end

function jishogi_score(banmen::Banmen)
    sum(jishogi_score.(banmen))
end

function swap_sengo(banmen::Banmen)
    Banmen(-banmen.matrix)
end

function swap_sengo!(banmen::Banmen)
    banmen.matrix = -banmen.matrix
end

function rot180(banmen::Banmen)
    Banmen(rot180(banmen.matrix))
end

function rot180!(banmen::Banmen)
    banmen.matrix = rot180(banmen.matrix)
end

const _BanmenHirate = let
    banmen = Banmen()
    banmen[:, 7] = Masu.(Integer(☗歩兵) * ones(Int8, 9))
    banmen[:, 9] = [☗香車, ☗桂馬, ☗銀将, ☗金将, ☗玉将, ☗金将, ☗銀将, ☗桂馬, ☗香車]
    banmen[[8, 2], 8] = [☗角行, ☗飛車]
    banmen[:, 1:3] = swap_sengo(rot180(banmen))[:, 1:3]
    banmen
end

"""
    BanmenHirate

Return the hirate initial banmen.
"""
function BanmenHirate()
    copy(_BanmenHirate)
end

function bitdiff(b0::Banmen, b1::Banmen)
    x = b1.matrix - b0.matrix
    x .= 0
end