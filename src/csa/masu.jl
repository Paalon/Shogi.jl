export csa, MasuFromCSA

using Bijections

function _masu_to_csa(masu::Masu)
    if isempty(masu)
        " * "
    else
        sengo = Sengo(masu)
        koma = Koma(masu)
        csa(sengo) * csa(koma)
    end
end

const masu_to_csa = let
    ret = Dict()
    for masu in instances(Masu)
        ret[masu] = _masu_to_csa(masu)
    end
    ret
end |> Bijection

function csa(masu::Masu)
    masu_to_csa[masu]
end

function MasuFromCSA(str::AbstractString)
    masu_to_csa(str)
end