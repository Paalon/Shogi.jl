# Copyright 2021-11-25 Koki Fushimi

"""
    Reteurn dictionary swapped keys and values.
"""
keyvalueswap(dict::Dict) = Dict(value => key for (key, value) in dict)

# 半角数字, 全角数字, 漢数字, SFEN 数字の変換

const hankaku_suujis = '0':'9'
const zenkaku_suujis = '０':'９'
const kansuujis = ['〇', '一', '二', '三', '四', '五', '六', '七', '八', '九']
const sfen_suujis = 'a':'i'
const int8_0_to_9 = Int8(0):Int8(9)

const dict_hankaku_suuji_to_zenkaku_suuji = Dict(hankaku_suujis .=> zenkaku_suujis)
const dict_zenkaku_suuji_to_hankaku_suuji = Dict(zenkaku_suujis .=> hankaku_suujis)

const dict_hankaku_suuji_to_kansuuji = Dict(hankaku_suujis .=> kansuujis)
const dict_kansuuji_to_hankaku_suuji = Dict(kansuujis .=> hankaku_suujis)

const dict_hankaku_suuji_to_sfen_suuji = Dict(hankaku_suujis[2:end] .=> sfen_suujis)
const dict_sfen_suuji_to_hankaku_suuji = Dict(sfen_suujis .=> hankaku_suujis[2:end])

hankaku_suuji_to_zenkaku_suuji(char::AbstractChar) = dict_hankaku_suuji_to_zenkaku_suuji[char]
zenkaku_suuji_to_hankaku_suuji(char::AbstractChar) = dict_zenkaku_suuji_to_hankaku_suuji[char]

hankaku_suuji_to_kansuuji(char::AbstractChar) = dict_hankaku_suuji_to_kansuuji[char]
kansuuji_to_hankaku_suuji(char::AbstractChar) = dict_kansuuji_to_hankaku_suuji[char]

hankaku_suuji_to_sfen_suuji(char::AbstractChar) = dict_hankaku_suuji_to_sfen_suuji[char]
sfen_suuji_to_hankaku_suuji(char::AbstractChar) = dict_sfen_suuji_to_hankaku_suuji[char]

# Int8 ⇄ Char

const dict_hankaku_suuji_to_int8 = Dict(hankaku_suujis .=> int8_0_to_9)
const dict_int8_to_hankaku_suuji = Dict(int8_0_to_9 .=> hankaku_suujis)
hankaku_suuji_to_int8(char::AbstractChar) = dict_hankaku_suuji_to_int8[char]
int8_to_hankaku_suuji(n::Int8) = dict_int8_to_hankaku_suuji[n]

# Integer -- SFEN

integer_to_sfen_suuji(n::Integer) = n |> string |> x -> x[1] |> hankaku_suuji_to_sfen_suuji |> string