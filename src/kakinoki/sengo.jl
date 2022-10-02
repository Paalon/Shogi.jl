export kakinoki, SengoFromKakinoki

using Bijections

"""
    sengo_to_kakinoki::Bijection{Sengo, String}
"""
const sengo_to_kakinoki = Bijection(Dict(
    ☗ => "▲",
    ☖ => "△",
))

function kakinoki(sengo::Sengo)
    sengo_to_kakinoki[sengo]
end

function SengoFromKakinoki(str::AbstractString)
    sengo_to_kakinoki(str)
end