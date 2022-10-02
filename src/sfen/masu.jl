export sfen, MasuFromSFEN

using Bijections

"""
    masu_to_sfen::Bijection{Masu, String}

The bijection from Masu to SFEN string.
"""
const masu_to_sfen = let
    ret = Dict()
    for masu in instances(Masu)
        n = Integer(masu)
        if n == 0
            ret[〼] = "1"
        else
            koma = Koma(abs(n))
            if n > 0
                ret[Masu(koma, ☗)] = sfen(koma)
            else
                ret[Masu(koma, ☖)] = lowercase(sfen(koma))
            end
        end
    end
    ret
end |> Bijection

"""
    sfen(masu::Masu)::String

Return a SFEN string from a masu.
"""
function sfen(masu::Masu)
    masu_to_sfen[masu]
end

"""
    MasuFromSFEN(str::AbstractString)::Masu
"""
function MasuFromSFEN(str::AbstractString)
    masu_to_sfen(str)
end