export EncodedKyokumen

struct EncodedKyokumen
    n1::UInt128
    n2::UInt128
end

function EncodedKyokumen(kyokumen::Kyokumen)
    str = bitstring(kyokumen)
    n1 = parse(UInt128, str[1:128], base = 2)
    n2 = parse(UInt128, str[129:256], base = 2)
    EncodedKyokumen(n1, n2)
end

function Kyokumen(ek::EncodedKyokumen)
    s1 = bitstring(ek.n1)
    s2 = bitstring(ek.n2)
    decode("$s1$s2", base=2)
end

function EncodedKyokumen(str::AbstractString)
    length(str) == 64 || error()
    n1 = parse(UInt128, str[1:32], base=16)
    n2 = parse(UInt128, str[33:64], base=16)
    EncodedKyokumen(n1, n2)
end

function bitstring(ek::EncodedKyokumen)
    s1 = string(ek.n1, base = 2, pad = 128)
    s2 = string(ek.n2, base = 2, pad = 128)
    "$s1$s2"
end

function string(ek::EncodedKyokumen)
    s1 = string(ek.n1, base=16, pad=32)
    s2 = string(ek.n2, base=16, pad=32)
    "$s1$s2"
end

function Sengo(ek::EncodedKyokumen)
    if ek.n2 % 2 == 0
        後手
    else
        先手
    end
end