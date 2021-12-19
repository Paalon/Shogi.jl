# Copyright 2021-11-25 Koki Fushimi

export Sengo
# @defer @exportinstances Sengo
export issente, next

import Base.sign

"""
    Sengo

先後を表す型。
"""
@enum Sengo::Bool 先手 = 1 後手 = 0

@exportinstances Sengo

"""
    issente(sengo::Sengo)

Return `true` if the state is sente, `false` otherwise.
"""
issente(sengo::Sengo) = Integer(sengo)

"""
    next(sengo::Sengo)

Return next turn's state.
"""
next(sengo::Sengo) = Sengo(!issente(sengo))

"""
    sign(sengo::Sengo)

Return `+1` if `sengo` is `sente`, `-1` otherwise.
"""
sign(sengo::Sengo) = ifelse(issente(sengo), +1, -1)