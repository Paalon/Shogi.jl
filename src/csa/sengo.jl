export csa, SengoFromCSA

using Bijections

const sengo_to_csa = Bijection(Dict(先手 => "+", 後手 => "-"))

function csa(sengo::Sengo)
    sengo_to_csa[sengo]
end

function SengoFromCSA(str::AbstractString)
    sengo_to_csa(str)
end