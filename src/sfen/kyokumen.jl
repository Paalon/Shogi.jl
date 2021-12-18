export sfen, KyokumenFromSFEN

function sfen(kyokumen::Kyokumen)
    banmen = sfen(kyokumen.banmen)
    mochigoma = sfen(kyokumen.mochigoma)
    teban = sfen(kyokumen.teban)
    "$banmen $teban $mochigoma"
end

"""
    KyokumenFromSFEN(str::AbstractString)

Construct a kyokumen from the SFEN kyokumen string.
"""
function KyokumenFromSFEN(str::AbstractString)
    banmen_str, teban_str, mochigoma_str = split(str, " ")
    banmen = BanmenFromSFEN(banmen_str)
    mochigoma = SengoMochigomaFromSFEN(mochigoma_str)
    teban = SengoFromSFEN(teban_str)
    Kyokumen(banmen, mochigoma, teban)
end