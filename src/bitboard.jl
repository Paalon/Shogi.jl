
export Bitboard, OccupiedBitboard

struct Bitboard
    n::UInt128
end

function OccupiedBitboard(kyokumen::Kyokumen)
    str = ""
    for x in 9:-1:1, y in 9:-1:1
        masu = kyokumen[x, y]
        if isempty(masu)
            str *= "0"
        else
            str *= "1"
        end
    end
    Bitboard(parse(UInt128, str, base=2))
end



function parse_bitstr(str)
    parse(UInt128, str; base = 2)
end
function rm_slash(str)
    replace(str, "/" => "")
end
a = "111111111/111111111/111111111/111111111/111111111/111111111/111111111/111111111/111111111" |> rm_slash |> parse_bitstr
b = "111111111/010000010/111111111/000000000/000000000/000000000/111111111/010000010/111111111" |> rm_slash |> parse_bitstr
bitstring(b)[end-80:end]