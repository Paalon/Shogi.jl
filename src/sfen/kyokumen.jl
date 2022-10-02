export sfen, KyokumenFromSFEN

"""
    sfen(kyokumen::Kyokumen)::String

Return a SFEN string from a kyokumen.
"""
function sfen(kyokumen::Kyokumen)
    banmen = sfen(kyokumen.banmen)
    mochigoma = sfen(kyokumen.mochigoma)
    teban = sfen(kyokumen.teban)
    "$banmen $teban $mochigoma"
end

"""
    KyokumenFromSFEN(str::AbstractString; verbose::Bool=false)::Kyokumen

Construct a kyokumen from the SFEN kyokumen string.
If `verbose` is `true`, this function only accepts verbose SFEN string, e.g. `"sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"`.
Otherwise only accepts essencial part of the SFEN string: `"lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -"`.
"""
function KyokumenFromSFEN(str::AbstractString; verbose::Bool=false)
    banmen_str, teban_str, mochigoma_str = "", "", ""
    if verbose
        sfen_str, banmen_str, teban_str, mochigoma_str, tesuu_str = split(str, " ")
        sfen_str == "sfen" || throw(Error("Invalid SFEN string. Does not have `sfen`."))
        !isnothing(tryparse(Int, tesuu_str)) || throw(Error("Invalid SFEN string. Does not have valid tesuu number."))
    else
        banmen_str, teban_str, mochigoma_str = split(str, " ")
    end
    banmen = BanmenFromSFEN(banmen_str)
    mochigoma = SengoMochigomaFromSFEN(mochigoma_str)
    teban = SengoFromSFEN(teban_str)
    Kyokumen(banmen, mochigoma, teban)
end