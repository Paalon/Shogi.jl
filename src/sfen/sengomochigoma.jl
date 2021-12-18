export sfen, SengoMochigomaFromSFEN

function sfen(mochigoma::SengoMochigoma)
    sente = sfen(mochigoma.sente)
    gote = sfen(mochigoma.gote) |> lowercase
    ret = "$sente$gote"
    if ret == ""
        ret = "-"
    end
    ret
end

function SengoMochigomaFromSFEN(str::AbstractString)
    mochigoma = (
        sente = Mochigoma(),
        gote = Mochigoma(),
    )
    if str != "-"
        valstate = iterate(str)
        while !isnothing(valstate)
            char, state = valstate
            if isdigit(char)
                n = parse(Int8, char)
                char, state = iterate(str, state)
                if islowercase(char)
                    mochigoma.gote[KomaFromSFEN(string(uppercase(char)))] = n
                else
                    mochigoma.sente[KomaFromSFEN(string(char))] = n
                end
            else
                if islowercase(char)
                    mochigoma.gote[KomaFromSFEN(string(uppercase(char)))] = 1
                else
                    mochigoma.sente[KomaFromSFEN(string(char))] = 1
                end
            end
            valstate = iterate(str, state)
        end
    end
    mochigoma
end