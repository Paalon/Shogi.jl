# Copyright 2021-11-25 Koki Fushimi

export Masu
# @defer @exportinstances Masu
export jishogi_score, ispromotable, naru
export isempty, isomote, issente, isgote

import Base:
    isempty, sign
using Bijections

@enum Masu::Int8 begin
    〼 = 0
    ☗玉将 = 2
    ☗飛車 = 4
    ☗竜王 = 5
    ☗角行 = 6
    ☗竜馬 = 7
    ☗金将 = 8
    ☗銀将 = 10
    ☗成銀 = 11
    ☗桂馬 = 12
    ☗成桂 = 13
    ☗香車 = 14
    ☗成香 = 15
    ☗歩兵 = 16
    ☗と金 = 17
    ☖玉将 = -2
    ☖飛車 = -4
    ☖竜王 = -5
    ☖角行 = -6
    ☖竜馬 = -7
    ☖金将 = -8
    ☖銀将 = -10
    ☖成銀 = -11
    ☖桂馬 = -12
    ☖成桂 = -13
    ☖香車 = -14
    ☖成香 = -15
    ☖歩兵 = -16
    ☖と金 = -17
end

@exportinstances Masu

function issente(masu::Masu)
    Integer(masu) > 0
end

function isgote(masu::Masu)
    Integer(masu) < 0
end

function isempty(masu::Masu)
    masu == 〼
end

function isomote(masu::Masu)
    if isempty(masu)
        false
    else
        Integer(masu) % 2 == 0
    end
end

function Sengo(masu::Masu)
    if issente(masu)
        先手
    elseif isgote(masu)
        後手
    else
        nothing
    end
end

sign(masu::Masu) = sign(Integer(masu))

function Koma(masu::Masu)
    n = Integer(masu)
    if n == 0
        nothing
    else
        Koma(abs(n))
    end
end

Masu(koma::Koma, sengo::Sengo) = Masu(sign(sengo) * Integer(koma))
Masu(sengo::Sengo, koma::Koma) = Masu(sign(sengo) * Integer(koma))

function ispromotable(masu::Masu)
    koma = Koma(masu)
    if isnothing(koma)
        false
    else
        ispromotable(koma)
    end
end

function naru(masu::Masu)
    if ispromotable(masu)
        Masu(naru(Koma(masu)), Sengo(masu))
    else
        nothing
    end
end

function string_original(masu::Masu)
    masu_to_original[masu]
end

# function jishogi_score(masu::Masu)
#     if Integer(masu) == 0
#         0
#     else
#         sign(masu) * jishogi_score(Koma(masu))
#     end
# end

# function string(masu::Masu; style = :sfen)
#     if style == :sfen
#         masu_to_sfen[masu]
#     elseif style == :yaneuraou
#         masu_to_yaneuraou[masu]
#     elseif style == :original
#         masu_to_original[masu]
#     else
#         error("Invalid style: $style")
#     end
# end

# function Masu(str::AbstractString; style = :sfen)
#     if style == :sfen
#         masu_to_sfen(str)
#     elseif style == :yaneuraou
#         masu_to_yaneuraou(str)
#     elseif style == :original
#         masu_to_original(str)
#     else
#         error("Invalid style: $style")
#     end
# end

# const list_masu = [
#     空き枡,
#     ☗玉将, ☗飛車, ☗竜王, ☗角行, ☗竜馬, ☗金将, ☗銀将, ☗成銀, ☗桂馬, ☗成桂, ☗香車, ☗成香, ☗歩兵, ☗と金,
#     ☖玉将, ☖飛車, ☖竜王, ☖角行, ☖竜馬, ☖金将, ☖銀将, ☖成銀, ☖桂馬, ☖成桂, ☖香車, ☖成香, ☖歩兵, ☖と金,
# ]

# const list_masu_to_original = [
#     " ・",
#     "+玉", "+飛", "+竜", "+角", "+馬", "+金", "+銀", "+全", "+桂", "+圭", "+香", "+杏", "+歩", "+と",
#     "-玉", "-飛", "-竜", "-角", "-馬", "-金", "-銀", "-全", "-桂", "-圭", "-香", "-杏", "-歩", "-と",
# ]

# const list_masu_to_yaneuraou = [
#     " 口",
#     " 玉", " 飛", " 竜", " 角", " 馬", " 金", " 銀", " 全", " 桂", " 圭", " 香", " 杏", " 歩", " と",
#     "^玉", "^飛", "^竜", "^角", "^馬", "^金", "^銀", "^全", "^桂", "^圭", "^香", "^杏", "^歩", "^と",
# ]

# function make_bijection_masu_to_string(list_string)
#     bijection = Bijection{Masu,String}()
#     for (i, masu) in enumerate(list_masu)
#         bijection[masu] = list_string[i]
#     end
#     bijection
# end


# const masu_to_yaneuraou = make_bijection_masu_to_string(list_masu_to_yaneuraou)