# Copyright 2021-11-25 Koki Fushimi

export Sengo, sente, gote
export Color, black, white
export ☗, ☖
export issente
export isblack
export next
import Base.sign

"""
    Sengo::DataType

The type for sengo.
"""
@enum Sengo::Bool sente = 1 gote = 0
const Color = Sengo
const black = sente
const white = gote
const ☗ = sente
const ☖ = gote

"""
    issente(sengo::Sengo)::Bool

Return `true` if `sengo` is sente, otherwise `false`.
"""
issente(sengo::Sengo) = Integer(sengo)
const isblack = issente

"""
    next(sengo::Sengo)::Sengo

Return next turn's sengo.
"""
next(sengo::Sengo) = Sengo(!issente(sengo))

"""
    sign(sengo::Sengo)::Int

Return `+1` if `sengo` is `sente`, otherwise `-1`.
"""
sign(sengo::Sengo) = ifelse(issente(sengo), +1, -1)