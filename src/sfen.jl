# Copyright 2021-11-25 Koki Fushimi

export sfen
export SengoFromSFEN
export KomaFromSFEN
export MasuFromSFEN
export MochigomaFromSFEN
export BanmenFromSFEN
export SengoMochigomaFromSFEN
export KyokumenFromSFEN
# KifuFromSFEN

using Bijections

const sengo_to_sfen = Bijection(Dict(
    先手 => "b",
    後手 => "w",
))

"""
    sfen(sengo::Sengo)

Return SFEN string for the sengo.
"""
function sfen(sengo::Sengo)
    sengo_to_sfen[sengo]
end

"""
    SengoFromSFEN(str::AbstractString)

Create sengo from SFEN string.
"""
function SengoFromSFEN(str::AbstractString)
    sengo_to_sfen(str)
end

const koma_to_sfen = Bijection(Dict(
    歩兵 => "P",
    香車 => "L",
    桂馬 => "N",
    銀将 => "S",
    金将 => "G",
    角行 => "B",
    飛車 => "R",
    玉将 => "K",
    と金 => "+P",
    成香 => "+L",
    成桂 => "+N",
    成銀 => "+S",
    竜馬 => "+B",
    竜王 => "+R",
))

"""
    sfen(koma::Koma)

Return SFEN string for the koma.
"""
function sfen(koma::Koma)
    koma_to_sfen[koma]
end

"""
    KomaFromSFEN(str::AbstractString)

Create koma from SFEN string.
"""
function KomaFromSFEN(str::AbstractString)
    koma_to_sfen(str)
end

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
    MochigomaFromSFEN(str::AbstractString)

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

# function sfen(tesuu::Tesuu) end

# function TesuuFromSFEN(str::AbstractString) end

function sfen(kyokumen::Kyokumen)
    banmen = sfen(kyokumen.banmen)
    mochigoma = sfen(kyokumen.mochigoma)
    teban = sfen(kyokumen.teban)
    "$banmen $teban $mochigoma"
end

"""
    KyokumenFromSFEN(str::AbstractString)

Construct a kyokumen from the SFEN kyokumen string.
"""
function KyokumenFromSFEN(str::AbstractString)
    banmen_str, teban_str, mochigoma_str = split(str, " ")
    banmen = BanmenFromSFEN(banmen_str)
    mochigoma = SengoMochigomaFromSFEN(mochigoma_str)
    teban = SengoFromSFEN(teban_str)
    Kyokumen(banmen, mochigoma, teban)
end

# function sfen(move::Move)
#     from_x = move.from_x |> string
#     from_y = move.from_y |> integer_to_sfen_suuji
#     to_x = move.to_x |> string
#     to_y = move.to_y |> integer_to_sfen_suuji
#     result = "$from_x$from_y$to_x$to_y"
#     if move.ispromote
#         result *= "+"
#     end
#     result
# end

# function sfen(drop::Drop)
#     koma = drop.koma |> sfen
#     to_x = drop.to_x
#     to_y = drop.to_y |> integer_to_sfen_suuji
#     "$koma*$to_x$to_y"
# end

# function sfen(kifu::Kifu) end

# function KifuFromSFEN(str::AbstractString) end