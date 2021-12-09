# Copyright 2021-12-07 Koki Fushimi
# 将棋の局面をハフマン符号で圧縮する。
# 256 bit に圧縮する。
# https://www.nara-wu.ac.jp/math/personal/shinoda/legal.pdf より
# 局面数は 10^60 ~ 10^70, つまり 199 bit ~ 233 bit で可逆圧縮可能であることが証明されている。
# 予想は 10^68 ~ 10^69, つまり 225 bit ~ 233 bit である。

export encode, decode

import Base:
    bitstring

function Base.bitstring(sengo::Sengo)
    ifelse(issente(sengo), "1", "0")
end

function decode_sengo(str::AbstractString)
    if str == "1"
        sente
    elseif str == "0"
        gote
    else
        error("Invalid code: $str")
    end
end

function decode_sengo(str::AbstractString, state)
    valstate = iterate(str, state)
    if !isnothing(valstate)
        char, state = valstate
        if char == '1'
            sente, state
        else
            gote, state
        end
    else
        nothing
    end
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

function Base.bitstring(koma::Koma)
    koma_code[koma]
end

function decode_koma(str::AbstractString, state)
    char, state = iterate(str, state)
    koma = if char == '0'
        # 歩兵・と金
        char, state = iterate(str, state)
        if char == '0'
            歩兵
        else
            と金
        end
    else
        # 香車・成香・桂馬・成桂・銀将・成銀・金将・角行・竜馬・飛車・竜王
        char, state = iterate(str, state)
        if char == '0'
            # 香車・成香・桂馬・成桂
            char, state = iterate(str, state)
            if char == '0'
                # 香車・成香
                char, state = iterate(str, state)
                if char == '0'
                    香車
                else
                    成香
                end
            else
                # 桂馬・成桂
                char, state = iterate(str, state)
                if char == '0'
                    桂馬
                else
                    成桂
                end
            end
        else
            # 銀将・成銀・金将・角行・竜馬・飛車・竜王
            char, state = iterate(str, state)
            if char == '0'
                # 銀将・成銀
                char, state = iterate(str, state)
                if char == '0'
                    銀将
                else
                    # 成銀
                    成銀
                end
            else
                # 金将・角行・竜馬・飛車・竜王
                char, state = iterate(str, state)
                if char == '0'
                    # 金将
                    金将
                else
                    # 角行・竜馬・飛車・竜王
                    char, state = iterate(str, state)
                    if char == '0'
                        # 角行・竜馬
                        char, state = iterate(str, state)
                        if char == '0'
                            角行
                        else
                            竜馬
                        end
                    else
                        # 飛車・竜王
                        char, state = iterate(str, state)
                        if char == '0'
                            飛車
                        else
                            竜王
                        end
                    end
                end
            end
        end
    end
    koma, state
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
            sengo = bitstring(Sengo(masu))
            koma = bitstring(Koma(masu))
        end
        ret[masu] = "$koma$sengo$existence"
    end
    ret
end

function Base.bitstring(masu::Masu)
    masu_code[masu]
end

function decode_masu(str::AbstractString, state)
    char, state = iterate(str, state)
    masu = if char == '0'
        空き枡
    else
        sengo, state = decode_sengo(str, state)
        koma, state = decode_koma(str, state)
        Masu(koma, sengo)
    end
    masu, state
end

function Base.bitstring(banmen::Banmen)
    sentekp = UInt8(81)
    gotekp = UInt8(81)
    code = ""
    for i = 9:-1:1, j = 9:-1:1
        masu = banmen[i, j]
        if masu == ☗玉将
            sentekp = UInt8(9(i - 1) + (j - 1))
        elseif masu == ☖玉将
            gotekp = UInt8(9(i - 1) + (j - 1))
        else
            code = "$code$(bitstring(masu))"
        end
    end
    n = bitstring(gotekp)[2:end] * bitstring(sentekp)[2:end]
    code = "$code$n"
    code
end

function Base.bitstring(mochigoma::@NamedTuple {sente::Mochigoma, gote::Mochigoma})
    code = ""
    for (i, n) in enumerate(mochigoma.sente.komasuus)
        koma = KomaFromMochigomaIndex(i)
        for k = 1:n
            code = "$(bitstring(koma))$(bitstring(sente))$(code)"
        end
    end
    for (i, n) in enumerate(mochigoma.gote.komasuus)
        koma = KomaFromMochigomaIndex(i)
        for k = 1:n
            code = "$(bitstring(koma))$(bitstring(gote))$(code)"
        end
    end
    code
end

function Base.bitstring(kyokumen::Kyokumen)
    code_banmen = bitstring(kyokumen.banmen)
    code_mochigoma = bitstring(kyokumen.mochigoma)
    code_teban = bitstring(kyokumen.teban)
    code = "$code_mochigoma$code_banmen$code_teban"
    code
end

"""
    encode(kyokumen::Kyokumen; base=16)

Encode a `kyokumen` to a string in the given `base`.
"""
function encode(kyokumen::Kyokumen; base=16)
    str = bitstring(kyokumen)
    n = parse(BigInt, str, base = 2)
    string(n, base = base, pad = ceil(Int, 256 / log2(base)))
end

function decode_index(n::Integer)
    x = n ÷ 9 + 1
    y = n % 9 + 1
    x, y
end

function decode_kp(str::AbstractString)
    n = parse(Int8, str; base = 2)
    decode_index(n)
end

function decode_kyokumen(str::AbstractString)
    # decode teban
    teban = decode_sengo(str[end:end])

    # decode banmen
    banmen = Banmen()
    sentekp = decode_kp(str[end-7:end-1])
    gotekp = decode_kp(str[end-14:end-8])
    banmen[sentekp...] = ☗玉将
    banmen[gotekp...] = ☖玉将
    banmen_mochigoma_str = reverse(str[1:end-15])
    n = 0
    state = 1
    while n ≠ 81
        # decode masu
        i, j = decode_index(n)
        if (i, j) ≠ sentekp && (i, j) ≠ gotekp
            # 玉将の位置はスキップする。
            masu, state = decode_masu(banmen_mochigoma_str, state)
            banmen[i, j] = masu
        end
        n += 1
    end

    # decode mochigoma
    mochigoma = (sente = Mochigoma(), gote = Mochigoma())
    while checkbounds(Bool, banmen_mochigoma_str, state)
        sengo, state = decode_sengo(banmen_mochigoma_str, state)
        koma, state = decode_koma(banmen_mochigoma_str, state)
        if issente(sengo)
            mochigoma.sente[koma] += 1
        else
            mochigoma.gote[koma] += 1
        end
    end

    Kyokumen(banmen, mochigoma, teban)
end

"""
    decode(str::AbstractString; base=16)

Decode a encoded string in the given `base` to a `kyokumen`.
"""
function decode(str::AbstractString; base = 16)
    n = parse(BigInt, str, base = base)
    bitstr = string(n, base = 2, pad = 256)
    decode_kyokumen(bitstr)
end