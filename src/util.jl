# Copyright 2021-11-25 Koki Fushimi

using Bijections

"""
    Reteurn dictionary swapped keys and values.
"""
keyvalueswap(dict::Dict) = Dict(value => key for (key, value) in dict)

# 半角数字, 全角数字, 漢数字, SFEN 数字の変換

const hankaku_suujis = '0':'9'
const zenkaku_suujis = '０':'９'
const kansuujis = ['〇', '一', '二', '三', '四', '五', '六', '七', '八', '九']
const sfen_suujis = 'a':'i'
const sfen_dans = 'a':'i'
const int8_0_to_9 = Int8(0):Int8(9)

const hankaku_suuji_to_zenkaku_suuji = Bijection(Dict(hankaku_suujis .=> zenkaku_suujis))
const hankaku_suuji_to_kansuuji = Bijection(Dict(hankaku_suujis .=> kansuujis))
const hankaku_suuji_to_sfen_suuji = Bijection(Dict(hankaku_suujis[2:end] .=> sfen_suujis))

# Int8 ⇄ Char

const dict_hankaku_suuji_to_int8 = Dict(hankaku_suujis .=> int8_0_to_9)
const dict_int8_to_hankaku_suuji = Dict(int8_0_to_9 .=> hankaku_suujis)
hankaku_suuji_to_int8(char::AbstractChar) = dict_hankaku_suuji_to_int8[char]
int8_to_hankaku_suuji(n::Int8) = dict_int8_to_hankaku_suuji[n]

const int_to_hankaku = Bijection(Dict(0:9 .=> hankaku_suujis))
const int_to_zenkaku = Bijection(Dict(0:9 .=> zenkaku_suujis))
const int_to_kansuuji = Bijection(Dict(0:9 .=> kansuujis))
const int_to_sfen_dan = Bijection(Dict(1:9 .=> sfen_dans))

# Integer -- SFEN

integer_to_sfen_suuji(n::Integer) = n |> string |> x -> x[1] |> hankaku_suuji_to_sfen_suuji |> string

# Export an enum's all instances
# Thanks to Alex Arslan
macro exportinstances(enum)
    eval = GlobalRef(Core, :eval)
    return :($eval($__module__, Expr(:export, map(Symbol, instances($enum))...)))
end