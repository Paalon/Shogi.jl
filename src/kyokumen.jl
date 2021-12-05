# Copyright 2021-11-25 Koki Fushimi

export Kyokumen, sfen

import Base:
    show, sign

"""
    Kyokumen

A position state type of shogi game without history.
"""
mutable struct Kyokumen
    banmen::Banmen
    mochigoma::@NamedTuple begin
        sente::Mochigoma
        gote::Mochigoma
    end
    teban::Sengo
    tesuu::Tesuu
end

function Kyokumen()
    Kyokumen(
        Banmen("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"),
        (
            sente = Mochigoma(),
            gote = Mochigoma(),
        ),
        sente,
        Tesuu(1),
    )
end

function parse_mochigoma(str)
    mochigoma = (
        sente = Mochigoma(),
        gote = Mochigoma(),
    )
    if str != "-"
        iter_res = iterate(str)
        while !isnothing(iter_res)
            s, stat = iter_res
            if isdigit(s)
                n = parse(Int8, s)
                s, stat = iterate(str, stat)
                if islowercase(s)
                    mochigoma.gote[Koma(uppercase(s), style = :sfen)] = n
                else
                    mochigoma.sente[Koma(s, style = :sfen)] = n
                end
            else
                if islowercase(s)
                    mochigoma.gote[Koma(uppercase(s), style = :sfen)] = 1
                else
                    mochigoma.sente[Koma(s, style = :sfen)] = 1
                end
            end
            iter_res = iterate(str, stat)
        end
    end
    mochigoma
end

function Kyokumen(str::AbstractString)
    banmen_str, teban_str, mochigoma_str, tesuu_str = split(str, " ")
    banmen = Banmen(banmen_str)
    mochigoma = parse_mochigoma(mochigoma_str)
    teban = Sengo(teban_str)
    tesuu = Tesuu(tesuu_str)
    Kyokumen(banmen, mochigoma, teban, tesuu)
end

function Base.show(io::IO, kyokumen::Kyokumen)
    println(io, kyokumen.banmen)
    println(io, "先手持ち駒: ", kyokumen.mochigoma.sente)
    println(io, "後手持ち駒: ", kyokumen.mochigoma.gote)
    println(io, kyokumen.teban)
    println(io, "$(kyokumen.tesuu.n - 1) 手目")
end

function sfen(kyokumen::Kyokumen)
    banmen = sfen(kyokumen.banmen)
    mochigoma_sente = sfen(kyokumen.mochigoma.sente)
    mochigoma_gote = sfen(kyokumen.mochigoma.gote) |> lowercase
    mochigoma = "$mochigoma_sente$mochigoma_gote"
    if mochigoma == ""
        mochigoma = "-"
    end
    teban = sfen(kyokumen.teban)
    tesuu = sfen(kyokumen.tesuu)
    "$banmen $teban $mochigoma $tesuu"
end

function Base.string(kyokumen::Kyokumen)
    sfen(kyokumen)
end

function issente(kyokumen::Kyokumen)
    issente(kyokumen.teban)
end

function Base.sign(kyokumen::Kyokumen)
    sign(kyokumen.teban)
end

function teban_mochigoma(kyokumen::Kyokumen)
    if issente(kyokumen)
        kyokumen.mochigoma_sente
    else
        kyokumen.mochigoma_gote
    end
end

function next!(kyokumen::Kyokumen)
    kyokumen.teban = next(kyokumen.teban)
    kyokumen.tesuu = next(kyokumen.tesuu)
    kyokumen
end

function capture!(kyokumen::Kyokumen, x::Integer, y::Integer)
    koma_omote = KomaOmote(abs(kyokumen.banmen[x, y]).n ÷ 2)
    if koma_omote.n == 0
        error("No koma in $x$y.")
    end
    if issente(kyokumen)
        increment!(kyokumen.mochigoma_sente, koma_omote)
    else
        increment!(kyokumen.mochigoma_gote, koma_omote)
    end
    kyokumen.banmen[x, y] = Masu(0)
    kyokumen
end

"""
    jishogi_score(kyokumen::Kyokumen)
Return score for jishogi.
"""
function jishogi_score(kyokumen::Kyokumen)
    sente, gote = 0, 0
    jishogi_score(kyokumen.banmen)
    sente += jishogi_score(kyokumen.mochigoma_sente)
    gote += jishogi_score(kyokumen.mochigoma_gote)
    jishogi_score(kyokumen.banmen) + sente - gote
end