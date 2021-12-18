# Copyright 2021-11-25 Koki Fushimi

export Koma
export iskogoma, isoogoma, isgoldlike
export ispromotable, naru, omote, jishogi_score

using Bijections

# 常用漢字を使うことにする。
@enum Koma::Int8 begin
    玉将 = 2
    飛車 = 4
    竜王 = 5
    角行 = 6
    竜馬 = 7
    金将 = 8
    銀将 = 10
    成銀 = 11
    桂馬 = 12
    成桂 = 13
    香車 = 14
    成香 = 15
    歩兵 = 16
    と金 = 17
end

eval(export_instances(Koma))

isoogoma(koma::Koma) = 4 ≤ Integer(koma) ≤ 7
iskogoma(koma::Koma) = 8 ≤ Integer(koma) ≤ 17

const _isgoldlike = Dict(
    玉将 => false,
    飛車 => false,
    竜王 => false,
    角行 => false,
    竜馬 => false,
    金将 => true,
    銀将 => false,
    成銀 => true,
    桂馬 => false,
    成桂 => true,
    香車 => false,
    成香 => true,
    歩兵 => false,
    と金 => true,
)

function isgoldlike(koma::Koma)
    _isgoldlike[koma]
end

# isomote(koma::Koma) = Integer(koma) % 2 == 0
# isura(koma::Koma) = !isomote(koma)
# const isnarigoma = isura
# iskanagoma(koma::Koma) = 8 ≤ Integer(koma) ≤ 11

function ispromotable(koma::Koma)
    n = Integer(koma)
    n % 2 == 0 && (4 ≤ n ≤ 6 || 10 ≤ n ≤ 17)
end

function naru(koma::Koma)
    if ispromotable(koma)
        Koma(Integer(koma) + 1)
    else
        nothing
    end
end

function omote(koma::Koma)
    Koma(2(Integer(koma) ÷ 2))
end

function jishogi_score(koma::Koma)
    if iskogoma(koma)
        1
    elseif isoogoma(koma)
        5
    else
        0
    end
end

# const list_二字竜 = ["玉将", "飛車", "竜王", "角行", "竜馬", "金将", "銀将", "成銀", "桂馬", "成桂", "香車", "成香", "歩兵", "と金"]
# const list_二字龍 = ["玉将", "飛車", "龍王", "角行", "龍馬", "金将", "銀将", "成銀", "桂馬", "成桂", "香車", "成香", "歩兵", "と金"]
# const list_二字龍將 = ["玉將", "飛車", "龍王", "角行", "龍馬", "金將", "銀將", "成銀", "桂馬", "成桂", "香車", "成香", "歩兵", "と金"]
# const list_棋譜竜 = ["玉", "飛", "竜", "角", "馬", "金", "銀", "成銀", "桂", "成桂", "香", "成香", "歩", "と"]
# const list_棋譜龍 = ["玉", "飛", "龍", "角", "馬", "金", "銀", "成銀", "桂", "成桂", "香", "成香", "歩", "と"]
# const list_一字竜 = ["玉", "飛", "竜", "角", "馬", "金", "銀", "全", "桂", "圭", "香", "杏", "歩", "と"]
# const list_一字龍 = ["玉", "飛", "龍", "角", "馬", "金", "銀", "全", "桂", "圭", "香", "杏", "歩", "と"]
# const list_koma_sfen = ["K", "R", "+R", "B", "+B", "G", "S", "+S", "N", "+N", "L", "+L", "P", "+P"]

# function make_bijection_koma_to_string(list)
#     bijection = Bijection{Koma,String}()
#     for (i, koma) in enumerate(instances(Koma))
#         bijection[koma] = list[i]
#     end
#     bijection
# end

# const koma_to_niji = make_bijection_koma_to_string(list_二字竜)
# const koma_to_kifu = make_bijection_koma_to_string(list_棋譜竜)
# const koma_to_ichiji = make_bijection_koma_to_string(list_一字竜)

# function string(koma::Koma; style = :niji)
#     if style == :niji
#         koma_to_niji[koma]
#     elseif style == :kifu
#         koma_to_kifu[koma]
#     elseif style == :ichiji
#         koma_to_ichiji[koma]
#     elseif style == :sfen
#         koma_to_sfen[koma]
#     else
#         error("Invalid style: $style")
#     end
# end

# """
#     Koma(str::AbstractString; style = :niji)

# Construct `Koma` instance from string.
# `:niji` : two-characters style
# `:kifu` : kifu style
# `:ichiji` : one-character style
# `:sfen` : SFEN string
# """
# function Koma(str::AbstractString; style = :niji)
#     if style == :niji
#         koma_to_niji(str)
#     elseif style == :kifu
#         koma_to_kifu(str)
#     elseif style == :ichiji
#         koma_to_ichiji(str)
#     elseif style == :sfen
#         koma_to_sfen(str)
#     else
#         error("Invalid style: $style")
#     end
# end