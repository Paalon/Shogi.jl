export SengoMochigoma
"""
    SengoMochigoma

先手と後手の持ち駒を表す型。
"""
const SengoMochigoma = @NamedTuple{sente::Mochigoma, gote::Mochigoma}