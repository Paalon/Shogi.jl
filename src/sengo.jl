# Copyright 2021-11-25 Koki Fushimi

export Sengo, issente, sfen, next

import Base
show, sign

@enum Sengo::Bool sente = 1 gote = 0

const ☗ = sente
const ☖ = gote

function Sengo(str::AbstractString)
    if str == "b"
        sente
    elseif str == "w"
        gote
    else
        error("Invalid string: $str")
    end
end

Sengo(char::AbstractChar) = Sengo(string(char))

"""
    issente(sengo::Sengo)

Return `true` if the state is sente, `false` otherwise.
"""
issente(sengo::Sengo) = Integer(sengo)

"""
    sfen(sengo::Sengo)

Return SFEN string for the state.
"""
sfen(sengo::Sengo) = ifelse(issente(sengo), "b", "w")

"""
    next(sengo::Sengo)

Return next turn's state.
"""
next(sengo::Sengo) = Sengo(!issente(sengo))

"""
    sign(sengo::Sengo)

Return `+1` if `sengo` is `sente`, `-1` otherwise.
"""
Base.sign(sengo::Sengo) = ifelse(issente(sengo), +1, -1)

# function Base.show(io::IO, sengo::Sengo)
#     if Integer(sengo)
#         print(io, "☗")
#     else
#         print(io, "☖")
#     end
# end

istekijin(sengo::Sengo, y::Int8) = (issente(sengo) && 1 ≤ y ≤ 3) || (!issente(sengo) && 7 ≤ y ≤ 9)
istekijin(sengo::Sengo, ::Int8, y::Int8) = istekijin(sengo, y)