# Copyright 2021-11-25 Koki Fushimi

export Sengo
# @defer @exportinstances Sengo
export issente, next

import Base.sign

"""
    Sengo::DataType

The type for sente and gote.
"""
@enum Sengo::Bool ☗ = 1 ☖ = 0

"""
    ☗::Sengo
Sente.
"""
☗

"""
    ☖::Sengo
Gote.
"""
☖

@exportinstances Sengo

"""
    issente(sengo::Sengo)::Bool

Return `true` if the state is sente, `false` otherwise.
"""
issente(sengo::Sengo) = Integer(sengo)

"""
    next(sengo::Sengo)::Sengo

Return next turn's state.
"""
next(sengo::Sengo) = Sengo(!issente(sengo))

"""
    sign(sengo::Sengo)::Int

Return `+1` if `sengo` is `sente`, `-1` otherwise.
"""
sign(sengo::Sengo) = ifelse(issente(sengo), +1, -1)