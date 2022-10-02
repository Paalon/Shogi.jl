export sfen, BanmenFromSFEN

function sfen(banmen::Banmen)
    ret = ""
    for i = 1:9
        for j = 1:9
            n = banmen.matrix[10-j, i]
            ret *= sfen(Masu(n))
        end
        if i != 9
            ret *= "/"
        end
    end
    ret = replace(ret, "111111111" => "9")
    ret = replace(ret, "11111111" => "8")
    ret = replace(ret, "1111111" => "7")
    ret = replace(ret, "111111" => "6")
    ret = replace(ret, "11111" => "5")
    ret = replace(ret, "1111" => "4")
    ret = replace(ret, "111" => "3")
    ret = replace(ret, "11" => "2")
    ret
end

"""
    BanmenFromSFEN(str::AbstractString)::Banmen
"""
function BanmenFromSFEN(str::AbstractString)
    banmen = Banmen()
    iter_res = iterate(str)
    i = 1
    j = 1
    while !isnothing(iter_res)
        char, stat = iter_res
        if isnumeric(char)
            n = parse(Int8, char)
            for _ = 1:n
                banmen[10-j, i] = 〼
                j += 1
            end
        elseif char == '/'
            i += 1
            j = 1
        elseif char == '+'
            char, stat = iterate(str, stat)
            banmen[10-j, i] = MasuFromSFEN("+$char")
            j += 1
        else
            banmen[10-j, i] = MasuFromSFEN(string(char))
            j += 1
        end
        iter_res = iterate(str, stat)
    end
    banmen
end