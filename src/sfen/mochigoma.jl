export sfen, MochigomaFromSFEN

"""
    sfen(mochigoma::Mochigoma)::String

Return a SFEN string from a mochigoma.
"""
function sfen(mochigoma::Mochigoma)
    ret = ""
    for (i, n) in enumerate(mochigoma.komasuus)
        if n == 0
            # do nothing
        elseif n == 1
            koma = KomaFromMochigomaIndex(i)
            ret *= sfen(koma)
        elseif n > 1
            ret *= n |> string
            koma = KomaFromMochigomaIndex(i)
            ret *= sfen(koma)
        else
            error("Invalid mochigoma state.")
        end
    end
    ret
end

"""
    MochigomaFromSFEN(str::AbstractString)::Mochigoma

Construct `Mochigoma` object from SFEN Mochigoma string.
See detail http://shogidokoro.starfree.jp/usi.html for SFEN format in USI.
"""
function MochigomaFromSFEN(str::AbstractString)
    mochigoma = Mochigoma()
    valstate = iterate(str)
    while !isnothing(valstate)
        char, state = valstate
        if isdigit(char)
            n = parse(Int8, char)
            char, state = iterate(str, state)
            koma = KomaFromSFEN(string(char))
            mochigoma[koma] = n
        else
            n = 1
            koma = KomaFromSFEN(string(char))
            mochigoma[koma] = n
        end
        valstate = iterate(str, state)
    end
    mochigoma
end