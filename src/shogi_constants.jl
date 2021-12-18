# SFEN Koma Omote ⇄ Int8

const dict_sfen_koma_omote_to_int8 = Dict(
    "K" => Int8(1),
    "R" => Int8(2),
    "B" => Int8(3),
    "G" => Int8(4),
    "S" => Int8(5),
    "N" => Int8(6),
    "L" => Int8(7),
    "P" => Int8(8),
)
const dict_int8_to_koma_omote = keyvalueswap(dict_sfen_koma_omote_to_int8)
sfen_koma_omote_to_int8(str::AbstractString) = dict_sfen_koma_omote_to_int8[str]
sfen_koma_omote_to_int8(char::Char) = dict_sfen_koma_omote_to_int8[string(char)]
int8_to_sfen_koma_omote(n::Int8) = dict_int8_to_koma_omote[n]
int_to_sfen_koma_omote(n::Integer) = Int8(n) |> int8_to_sfen_koma_omote

# SFEN Teban ⇄ Bool
sfen_teban_to_bool(str::AbstractString)::Union{Bool,Nothing} =
    if str == "b"
        true
    elseif str == "w"
        false
    else
        nothing
    end
sfen_teban_to_bool(char::Char) =
    if char == 'b'
        true
    elseif char == 'w'
        false
    else
        nothing
    end
bool_to_sfen_teban(x::Bool) = ifelse(x, "b", "w")

# SFEN Masu ⇄ Int8
const dict_sfen_masu_to_int8 = let
    d = Dict(
        "1" => Int8(0),
        "K" => Int8(1),
        #
        "R" => Int8(3),
        "+R" => Int8(4),
        "B" => Int8(5),
        "+B" => Int8(6),
        "G" => Int8(7),
        #
        "S" => Int8(9),
        "+S" => Int8(10),
        "N" => Int8(11),
        "+N" => Int8(12),
        "L" => Int8(13),
        "+L" => Int8(14),
        "P" => Int8(15),
        "+P" => Int8(16),
    )
    ks = keys(d) |> collect
    for key in ks
        d[lowercase(key)] = -d[key]
    end
    d
end
const dict_int8_to_sfen_masu = keyvalueswap(dict_sfen_masu_to_int8)
sfen_masu_to_int8(str::AbstractString) = dict_sfen_masu_to_int8[str]
sfen_masu_to_int8(char::Char) = sfen_masu_to_int8(string(char))
int_to_sfen_masu(n::Int8) = dict_int8_to_sfen_masu[n]
int_to_sfen_masu(n::Integer) = Int8(n) |> int_to_sfen_masu

function sfen_move_to_int(str::AbstractString)::Union{Int,Nothing}
    if str == "a"
        1
    elseif str == "b"
        2
    elseif str == "c"
        3
    elseif str == "d"
        4
    elseif str == "e"
        5
    elseif str == "f"
        6
    elseif str == "g"
        7
    elseif str == "h"
        8
    elseif str == "i"
        9
    else
        nothing
    end
end

sfen_move_to_int(char::Char)::Union{Int,Nothing} = sfen_move_to_int(string(char))

const sfen_move_alphabet = 'a':'i'

int_to_sfen_move(n::Integer) = string(sfen_move_alphabet[n])

function int_to_kifu_koma(n::Int8)::Union{String,Nothing}
    if n == 1
        "玉"
    elseif n == 3
        "飛"
    elseif n == 4
        "龍"
    elseif n == 5
        "角"
    elseif n == 6
        "馬"
    elseif n == 7
        "金"
    elseif n == 9
        "銀"
    elseif n == 10
        "成銀"
    elseif n == 11
        "桂"
    elseif n == 12
        "成桂"
    elseif n == 13
        "香"
    elseif n == 14
        "成香"
    elseif n == 15
        "歩"
    elseif n == 16
        "と"
    else
        nothing
    end
end

int_to_kifu_koma(n::Integer) = int_to_kifu_koma(Int8(n))

function int_to_kanji1_koma(n::Int8)::Union{String,Nothing}
    if n == 1
        "玉"
    elseif n == 3
        "飛"
    elseif n == 4
        "龍"
    elseif n == 5
        "角"
    elseif n == 6
        "馬"
    elseif n == 7
        "金"
    elseif n == 9
        "銀"
    elseif n == 10
        "全"
    elseif n == 11
        "桂"
    elseif n == 12
        "圭"
    elseif n == 13
        "香"
    elseif n == 14
        "杏"
    elseif n == 15
        "歩"
    elseif n == 16
        "と"
    else
        nothing
    end
end

int_to_kanji1_koma(n::Integer) = int_to_kanji1_koma(Int8(n))

function int_to_masu_string(n::Int8)::String
    an = abs(n)
    ret = ""

    if n < 0
        ret *= "-"
    elseif n > 0
        ret *= "+"
    else
        ret *= " "
    end

    ret *= if an == 0
        "・"
    else
        kanji1_koma = int_to_kanji1_koma(an)
        if isnothing(kanji1_koma)
            "？"
        else
            kanji1_koma
        end
    end
    ret
end

int_to_masu_string(n::Integer) = int_to_masu_string(Int8(n))

const sfen_startpos = "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"