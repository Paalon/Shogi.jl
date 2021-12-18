export sfen, SengoFromSFEN

using Bijections

const sengo_to_sfen = Bijection(Dict(
    先手 => "b",
    後手 => "w",
))

"""
    sfen(sengo::Sengo)

Return SFEN string for the sengo.
"""
function sfen(sengo::Sengo)
    sengo_to_sfen[sengo]
end

"""
    SengoFromSFEN(str::AbstractString)

Create sengo from SFEN string.
"""
function SengoFromSFEN(str::AbstractString)
    sengo_to_sfen(str)
end