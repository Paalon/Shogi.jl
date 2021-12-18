export sfen, MasuFromSFEN

using Bijections

const masu_to_sfen = let
    ret = Dict()
    for masu in instances(Masu)
        n = Integer(masu)
        if n == 0
            ret[〼] = "1"
        else
            koma = Koma(abs(n))
            if n > 0
                ret[Masu(koma, 先手)] = sfen(koma)
            else
                ret[Masu(koma, 後手)] = lowercase(sfen(koma))
            end
        end
    end
    ret
end |> Bijection

function sfen(masu::Masu)
    masu_to_sfen[masu]
end

function MasuFromSFEN(str::AbstractString)
    masu_to_sfen(str)
end