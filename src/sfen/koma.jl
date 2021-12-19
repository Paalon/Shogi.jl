export sfen, KomaFromSFEN

using Bijections

const koma_to_sfen = Bijection(Dict(
    歩兵 => "P",
    香車 => "L",
    桂馬 => "N",
    銀将 => "S",
    金将 => "G",
    角行 => "B",
    飛車 => "R",
    玉将 => "K",
    と金 => "+P",
    成香 => "+L",
    成桂 => "+N",
    成銀 => "+S",
    竜馬 => "+B",
    竜王 => "+R",
))

"""
    sfen(koma::Koma)

Return SFEN string for the koma.
"""
function sfen(koma::Koma)
    koma_to_sfen[koma]
end

"""
    KomaFromSFEN(str::AbstractString)

Create koma from SFEN string.
"""
function KomaFromSFEN(str::AbstractString)
    koma_to_sfen(str)
end