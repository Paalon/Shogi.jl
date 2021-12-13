# Copyright 2021-11-25 Koki Fushimi

export Banmen

import Base:
    copy, ==, iterate, size, getindex, setindex!, length, show, string
using StaticArrays

mutable struct Banmen
    matrix::MMatrix{9,9,Int8,81}
end

function Banmen()
    Banmen(MMatrix{9,9}(zeros(Int8, 9, 9)))
end

function Base.copy(banmen::Banmen)
    Banmen(copy(banmen.matrix))
end

function Base.:(==)(a::Banmen, b::Banmen)
    a.matrix == b.matrix
end

function Base.iterate(banmen::Banmen)
    res = iterate(banmen.matrix)
    if !isnothing(res)
        f, i = res
        Masu(f), i
    else
        res
    end
end

function Base.iterate(banmen::Banmen, state)
    res = iterate(banmen.matrix, state)
    if !isnothing(res)
        f, i = res
        Masu(f), i
    else
        res
    end
end

function Base.size(banmen::Banmen)
    size(banmen.matrix)
end

function Base.getindex(banmen::Banmen, i::Int)
    Masu(banmen.matrix[i])
end

function Base.getindex(banmen::Banmen, i::Int, j::Int)
    Masu(banmen.matrix[i, j])
end

function Base.setindex!(banmen::Banmen, masu::Masu, i::Int)
    banmen.matrix[i] = Integer(masu)
end

function Base.setindex!(banmen::Banmen, masu::Masu, i::Int, j::Int)
    banmen.matrix[i, j] = Integer(masu)
end

function Base.length(banmen::Banmen)
    length(banmen.matrix)
end

function Base.show(io::IO, banmen::Banmen)
    print(io, " ９ ８ ７ ６ ５ ４ ３ ２ １\n")
    for i = 1:9
        for j = 1:9
            masu = banmen[10-j, i]
            print(io, string(masu; style = :original))
        end
        n = i |> string |> x -> x[1] |> hankaku_suuji_to_zenkaku_suuji |> string
        print(io, " $n\n")
    end
end

function Banmen(str::AbstractString)
    banmen = Banmen()
    iter_res = iterate(str)
    i = 1
    j = 1
    while !isnothing(iter_res)
        char, stat = iter_res
        if isnumeric(char)
            n = parse(Int8, char)
            for _ = 1:n
                banmen[10-j, i] = 空き枡
                j += 1
            end
        elseif char == '/'
            i += 1
            j = 1
        elseif char == '+'
            char, stat = iterate(str, stat)
            banmen[10-j, i] = Masu("+$char")
            j += 1
        else
            banmen[10-j, i] = Masu(string(char))
            j += 1
        end
        iter_res = iterate(str, stat)
    end
    banmen
end

function sfen(banmen::Banmen)
    ret = ""
    for i = 1:9
        for j = 1:9
            n = banmen.matrix[10-j, i]
            ret *= string(Masu(n), style = :sfen)
        end
        if i != 9
            ret *= "/"
        end
    end
    ret = replace(ret, "111111111" => "9")
    ret = replace(ret, "11111111" => "8")
    ret = replace(ret, "1111111" => "7")
    ret = replace(ret, "111111" => "6")
    ret = replace(ret, "11111" => "5")
    ret = replace(ret, "1111" => "4")
    ret = replace(ret, "111" => "3")
    ret = replace(ret, "11" => "2")
    ret
end

function jishogi_score(banmen::Banmen)
    sum(jishogi_score.(banmen))
end