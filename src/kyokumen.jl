# Copyright 2021-11-25 Koki Fushimi

export Kyokumen, sfen, teban_mochigoma, toru!
export SFENKyokumen

import Base:
    copy, ==, show, sign,
    getindex, setindex!

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
end

function Kyokumen()
    Kyokumen(
        Banmen("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"),
        (
            sente = Mochigoma(),
            gote = Mochigoma(),
        ),
        sente,
    )
end

function Base.copy(kyokumen::Kyokumen)
    kyokumen = Kyokumen(
        copy(kyokumen.banmen),
        (
            sente = copy(kyokumen.mochigoma.sente),
            gote = copy(kyokumen.mochigoma.gote),
        ),
        kyokumen.teban,
    )
end

function Base.:(==)(a::Kyokumen, b::Kyokumen)
    a.banmen == b.banmen &&
    a.mochigoma == b.mochigoma &&
    a.teban == b.teban
end

function parse_mochigoma(str::AbstractString)
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

function Kyokumen(str::AbstractString; style = :sfen)
    banmen_str, teban_str, mochigoma_str = split(str, " ")
    banmen = Banmen(banmen_str)
    mochigoma = parse_mochigoma(mochigoma_str)
    teban = Sengo(teban_str)
    Kyokumen(banmen, mochigoma, teban)
end

function Base.show(io::IO, kyokumen::Kyokumen)
    println(io, kyokumen.banmen)
    println(io, "先手持ち駒: ", kyokumen.mochigoma.sente)
    println(io, "後手持ち駒: ", kyokumen.mochigoma.gote)
    println(io, kyokumen.teban)
    # println(io, "$(kyokumen.tesuu.n - 1) 手目")
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
    "$banmen $teban $mochigoma"
end

function Base.string(kyokumen::Kyokumen)
    sfen(kyokumen)
end

function issente(kyokumen::Kyokumen)
    issente(kyokumen.teban)
end

# function Base.sign(kyokumen::Kyokumen)
#     sign(kyokumen.teban)
# end

function teban_mochigoma(kyokumen::Kyokumen)
    if issente(kyokumen)
        kyokumen.mochigoma.sente
    else
        kyokumen.mochigoma.gote
    end
end

function Base.getindex(kyokumen::Kyokumen, i::Integer)
    kyokumen.banmen[i]
end

function Base.getindex(kyokumen::Kyokumen, i::Integer, j::Integer)
    kyokumen.banmen[i, j]
end

function Base.setindex!(kyokumen::Kyokumen, masu::Masu, i::Integer)
    kyokumen.banmen[i] = masu
end

function Base.setindex!(kyokumen::Kyokumen, masu::Masu, i::Integer, j::Integer)
    kyokumen.banmen[i, j] = masu
end

# function next!(kyokumen::Kyokumen)
#     kyokumen.teban = next(kyokumen.teban)
#     kyokumen.tesuu = next(kyokumen.tesuu)
#     kyokumen
# end

function toru!(kyokumen::Kyokumen, x::Integer, y::Integer)
    masu = kyokumen[x, y]
    koma = Koma(masu)
    sengo = Sengo(masu)
    if !isnothing(koma) && !isnothing(sengo)
        if kyokumen.teban ≠ sengo
            mochigoma = teban_mochigoma(kyokumen)
            mochigoma[koma] += 1
            kyokumen[x, y] = Masu(0)
        else
            error("Cannot capture own koma.")
        end
    else
        error("There is no koma.")
    end
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

"""
    SFENKyokumen

A kyokumen with tesuu.
"""
mutable struct SFENKyokumen
    kyokumen::Kyokumen
    tesuu::Tesuu
end

function sfen(sfenkyokumen::SFENKyokumen)
    "$(sfen(sfenkyokumen.kyokumen)) $(sfen(sfenkyokumen.tesuu))"
end

function Base.string(sfenkyokumen::SFENKyokumen; style=:sfen)
    if style == :sfen
        sfen(sfenkyokumen)
    else
        error("Invalid style $style")
    end
end

function issente(sfenkyokumen::SFENKyokumen)
    issente(sfenkyokumen.kyokumen)
end

function SFENKyokumen(str::AbstractString)
    banmen_str, teban_str, mochigoma_str, tesuu_str = split(str, " ")
    kyokumen = Kyokumen(join((banmen_str, teban_str, mochigoma_str), " "))
    tesuu = Tesuu(tesuu_str)
    SFENKyokumen(kyokumen, tesuu)
end