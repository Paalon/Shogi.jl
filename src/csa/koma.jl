export csa, KomaFromCSA

using Bijections

const koma_to_csa = Bijection(Dict(
    歩兵 => "FU",
    香車 => "KY",
    桂馬 => "KE",
    銀将 => "GI",
    金将 => "KI",
    角行 => "KA",
    飛車 => "HI",
    玉将 => "OU",
    と金 => "TO",
    成香 => "NY",
    成桂 => "NK",
    成銀 => "NG",
    竜馬 => "UM",
    竜王 => "RY",
))

function csa(koma::Koma)
    koma_to_csa[koma]
end

function KomaFromCSA(str::AbstractString)
    koma_to_csa(str)
end