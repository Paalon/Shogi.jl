# Copyright 2021-11-25 Koki Fushimi

export Tesuu

struct Tesuu
    n::Integer
end

function Tesuu(str::AbstractString)
    n = tryparse(Int64, str)
    if isnothing(n)
        error("Invalid string: $str")
    end
    Tesuu(n)
end

Tesuu(char::AbstractChar) = Tesuu(string(char))

sfen(tesuu::Tesuu) = string(tesuu.n)

next(tesuu::Tesuu) = Tesuu(tesuu.n + 1)
