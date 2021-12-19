export kakinoki, SengoFromKakinoki

using Bijections

const sengo_to_kakinoki = Bijection(Dict(
    先手 => "▲",
    後手 => "△",
))

function kakinoki(sengo::Sengo)
    sengo_to_kakinoki[sengo]
end

function SengoFromKakinoki(str::AbstractString)
    sengo_to_kakinoki(str)
end