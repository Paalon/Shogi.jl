# Copyright 2021-11-25 Koki Fushimi

export Koma
export Piece
export isgyokushou, isoogoma, iskogoma, iskanagoma
export isking, isminor, ismajor, ismetal
export jishogi_score
export isnareru, naru, omote
export ispromotable, front #= promote, =#

using Bijections

"""
    Koma::DataType

The type for komas.
"""
@enum Koma::Int8 begin # 常用漢字を使うことにする。
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
@exportinstances Koma
const Piece = Koma

"""
    isking(koma::Koma)::Bool

Return `true` if the `koma` is a king, and return `false` if not.
駒が玉将かどうかを返す。
"""
isgyokushou(koma::Koma) = koma == 玉将
const isking = isgyokushou

"""
    ismajor(koma::Koma)::Bool

Return `true` if the `koma` is a major piece, and return `false` if not.
駒が大駒かどうかを返す。
"""
isoogoma(koma::Koma) = 4 ≤ Integer(koma) ≤ 7
const ismajor = isoogoma

"""
    iskogoma(koma::Koma)::Bool

Return `true` if the `koma` is a minor piece, and return `false` if not.
駒が小駒かどうかを返す。
"""
iskogoma(koma::Koma) = 8 ≤ Integer(koma) ≤ 17
const isminor = iskogoma

const dict_iskanagoma = Dict(
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

"""
    iskanagoma(koma::Koma)::Bool

駒が金駒かどうかを返す。
"""
function iskanagoma(koma::Koma)
    dict_iskanagoma[koma]
end
const ismetal = iskanagoma

# isomote(koma::Koma) = Integer(koma) % 2 == 0
# isura(koma::Koma) = !isomote(koma)
# const isnarigoma = isura
# iskanagoma(koma::Koma) = 8 ≤ Integer(koma) ≤ 11

"""
    isnareru(koma::Koma)::Bool

Return `true` if a koma is promotable, otherwise `false`.
駒が成れるかどうかを返す。
"""
function isnareru(koma::Koma)
    n = Integer(koma)
    n % 2 == 0 && (4 ≤ n ≤ 6 || 10 ≤ n ≤ 17)
end
const ispromotable = isnareru

"""
    naru(koma::Koma)::Union{Nothing, Koma}

Return promoted koma. If it can't promote, return `nothing`.
成駒を返す。
"""
function naru(koma::Koma)::Union{Nothing,Koma}
    if ispromotable(koma)
        Koma(Integer(koma) + 1)
    else
        nothing
    end
end
const promote = naru

function omote(koma::Koma)
    Koma(2(Integer(koma) ÷ 2))
end
const front = omote

"""
    jishogi_score(koma::Koma)::Int

Return the jishogi score of a koma.
駒の持将棋における点数を返す。
"""
function jishogi_score(koma::Koma)
    if isminor(koma)
        1
    elseif ismajor(koma)
        5
    else
        0
    end
end

# const koma_to_name = Bijection(Dict(
#     玉将 => "玉将",
#     飛車 => "飛車",
#     竜王 => "竜王",
#     角行 => "角行",
#     竜馬 => "竜馬",
#     金将 => "金将",
#     銀将 => "銀将",
#     成銀 => "成銀",
#     桂馬 => "桂馬",
#     成桂 => "成桂",
#     香車 => "香車",
#     成香 => "成香",
#     歩兵 => "歩兵",
#     と金 => "と金",
# ))

# function Base.print(io::IO, koma::Koma)
#     print(io, koma_to_name[koma])
# end

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