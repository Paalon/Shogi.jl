export csa, MasuFromCSA

using Bijections

import ..Masu

function _masu_to_csa(masu::Masu)
    if isempty(masu)
        " * "
    else
        sengo = Sengo(masu)
        koma = Koma(masu)
        csa(sengo) * csa(koma)
    end
end

"""
    masu_to_csa::Bijection{Masu, String}

The bijection from Masu to CSA string.
"""
const masu_to_csa = let
    ret = Dict()
    for masu in instances(Masu)
        ret[masu] = _masu_to_csa(masu)
    end
    ret
end |> Bijection

"""
    csa(masu::Masu)::String

Convert masu to CSA string.
"""
function csa(masu::Masu)
    masu_to_csa[masu]
end

"""
    MasuFromCSA(str::AbstractString)::Masu

Convert CSA string to masu.
"""
function MasuFromCSA(str::AbstractString)
    masu_to_csa(str)
end