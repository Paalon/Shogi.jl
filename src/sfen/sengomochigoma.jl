export sfen, SengoMochigomaFromSFEN

"""
    sfen(mochigoma::SengoMochigoma)::String

Return a SFEN string from a sengo mochigoma object.
"""
function sfen(mochigoma::SengoMochigoma)
    sente = sfen(mochigoma.sente)
    gote = sfen(mochigoma.gote) |> lowercase
    ret = "$sente$gote"
    if ret == ""
        ret = "-"
    end
    ret
end

"""
    SengoMochigomaFromSFEN(str::AbstractString)::NamedTuple{(:sente, :gote), Tuple{Mochigoma, Mochigoma}}
"""
function SengoMochigomaFromSFEN(str::AbstractString)
    mochigoma = (
        sente=Mochigoma(),
        gote=Mochigoma(),
    )
    if str != "-"
        valstate = iterate(str)
        while !isnothing(valstate)
            char, state = valstate
            ns = ""
            while isdigit(char)
                ns *= char
                char, state = iterate(str, state)
            end
            n = if isempty(ns)
                1
            else
                parse(Int, ns)
            end
            if islowercase(char)
                mochigoma.gote[KomaFromSFEN(string(uppercase(char)))] = n
            else
                mochigoma.sente[KomaFromSFEN(string(char))] = n
            end
            valstate = iterate(str, state)
        end
    end
    mochigoma
end