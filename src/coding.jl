# 将棋の局面をハフマン符号で圧縮する。
# 256 bit に圧縮する。
# https://www.nara-wu.ac.jp/math/personal/shinoda/legal.pdf より
# 局面数は 10^60 ~ 10^70, つまり 199 bit ~ 233 bit で可逆圧縮可能であることが証明されている。
# 予想は 10^68 ~ 10^69, つまり 225 bit ~ 233 bit である。

export encode, decode

import Base:
    bitstring

function encode(sengo::Sengo)
    ifelse(issente(sengo), "1", "0")
end

const koma_code = Dict(
    歩兵 => "00",
    と金 => "10",
    香車 => "0001",
    成香 => "1001",
    桂馬 => "0101",
    成桂 => "1101",
    銀将 => "0011",
    成銀 => "1011",
    金将 => "0111",
    角行 => "001111",
    竜馬 => "101111",
    飛車 => "011111",
    竜王 => "111111",
)

function encode(koma::Koma)
    koma_code[koma]
end

const masu_code = let
    ret = Dict{Masu,String}()
    for masu in list_masu
        emptiness = isempty(masu)
        existence, sengo, koma = "", "", ""
        if isempty(masu)
            existence = "0"
        elseif Koma(masu) == 玉将
        else
            existence = "1"
            sengo = encode(Sengo(masu))
            koma = encode(Koma(masu))
        end
        ret[masu] = "$koma$sengo$existence"
    end
    ret
end

function encode(masu::Masu)
    masu_code[masu]
end

function encode(banmen::Banmen)
    sentekp = UInt8(81)
    gotekp = UInt8(81)
    code = ""
    count_empty = 0
    code_empty = ""
    count_pawn = 0
    code_pawn = ""
    for i = 1:9, j = 1:9
        masu = banmen[i, j]
        if masu == ☗玉将
            sentekp = UInt8(9(i - 1) + (j - 1))
        elseif masu == ☖玉将
            gotekp = UInt8(9(i - 1) + (j - 1))
        else
            code = "$code$(encode(masu))"
            if isempty(masu)
                count_empty += 1
                code_empty *= encode(masu)
            elseif Koma(masu) == 歩兵
                count_pawn += 1
                code_pawn *= encode(masu)
            end
        end
    end
    n = bitstring(gotekp)[2:end] * bitstring(sentekp)[2:end]
    code = "$code$n"
    code
end

function encode(mochigoma::@NamedTuple {sente::Mochigoma, gote::Mochigoma})
    code = ""
    for (i, n) in enumerate(mochigoma.sente.komasuus)
        koma = KomaFromMochigomaIndex(i)
        for k = 1:n
            code = "$(encode(koma))$(encode(sente))$(code)"
        end
    end
    for (i, n) in enumerate(mochigoma.gote.komasuus)
        koma = KomaFromMochigomaIndex(i)
        for k = 1:n
            code = "$(encode(koma))$(encode(gote))$(code)"
        end
    end
    code
end

function Base.bitstring(kyokumen::Kyokumen)
    code_banmen = encode(kyokumen.banmen)
    code_mochigoma = encode(kyokumen.mochigoma)
    code_teban = encode(kyokumen.teban)
    code = "$code_mochigoma$code_banmen$code_teban"
    code
end

function encode(kyokumen::Kyokumen; base)
    str = bitstring(kyokumen)
    n = parse(BigInt, str, base = 2)
    string(n, base = base, pad = ceil(Int, 256 / log2(base)))
end

function decode(str::AbstractString; base)
    n = parse(BigInt, str, base = base)
    string(n, base = 2, pad = 256)
end

function decode_kp(str::AbstractString)
    n = parse(Int8, str; base = 2)
    x = n ÷ 9 + 1
    y = n % 9 + 1
    x, y
end

function split_banmen_code(str::AbstractString) end

function decode_banmen(str::AbstractString)
    sentekp = str[end-7+1:end] |> decode_kp
    gotekp = str[end-14+1:end-7] |> decode_kp
    str = str[1:end-14]
    banmen = Banmen()
    banmen[sentekp...] = ☗玉将
    banmen[gotekp...] = ☖玉将
    for i = 1:9, j = 1:9
        if (i, j) ≠ sentekp && (i, j) ≠ gotekp
            # banmen[i, j] = 
        end
    end
    banmen
end