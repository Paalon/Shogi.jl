export csa, SengoFromCSA

using Bijections

"""
    sengo_to_csa::Bijections.Bijection{Sengo, String}

The bijection from sengo to CSA-format string.
"""
const sengo_to_csa = Bijection(Dict(先手 => "+", 後手 => "-"))

"""
    csa(sengo::Sengo)

Returns CSA-format string of sengo.
"""
function csa(sengo::Sengo)
    sengo_to_csa[sengo]
end

"""
    SengoFromCSA(str::AbstractString)

Return sengo from CSA-format string.
"""
function SengoFromCSA(str::AbstractString)
    sengo_to_csa(str)
end