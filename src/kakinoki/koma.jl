export kakinoki, KomaFromKakinoki

using Bijections

const koma_to_kakinoki = Bijection(Dict(
    玉将 => "玉",
    飛車 => "飛",
    竜王 => "龍",
    角行 => "角",
    竜馬 => "馬",
    金将 => "金",
    銀将 => "銀",
    成銀 => "成銀",
    桂馬 => "桂",
    成桂 => "成桂",
    香車 => "香",
    成香 => "成香",
    歩兵 => "歩",
    と金 => "と",
))

function kakinoki(koma::Koma)
    koma_to_kakinoki[koma]
end

function KomaFromKakinoki(str::AbstractString)
    koma_to_kakinoki(str)
end