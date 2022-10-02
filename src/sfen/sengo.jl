export sfen, SengoFromSFEN

using Bijections

"""
    sengo_to_sfen::Bijection{Sengo, String}
"""
const sengo_to_sfen = Bijection(Dict(
    ☗ => "b",
    ☖ => "w",
))

"""
    sfen(sengo::Sengo)::String

Return a SFEN string from a sengo.
"""
function sfen(sengo::Sengo)
    sengo_to_sfen[sengo]
end

"""
    SengoFromSFEN(str::AbstractString)::Sengo

Create sengo from SFEN string.
"""
function SengoFromSFEN(str::AbstractString)
    sengo_to_sfen(str)
end