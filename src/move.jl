# Copyright 2021-11-25 Koki Fushimi

export AbstractMove, Move, Drop, sfen
export susumeru!, susumeru
export traditional_notation

abstract type AbstractMove end

"""
    Move <: AbstractMove

Type for representing a on-board move.
"""
struct Move <: AbstractMove
    from_x::Int8
    from_y::Int8
    to_x::Int8
    to_y::Int8
    ispromote::Bool
end

function Move(str::AbstractString)
    from_x, from_y, to_x, to_y = parse.(Int8, string.((
        str[1], sfen_suuji_to_hankaku_suuji(str[2]),
        str[3], sfen_suuji_to_hankaku_suuji(str[4]),
    )))
    ispromote = length(str) == 5 && str[5] == '+'
    Move(from_x, from_y, to_x, to_y, ispromote)
end

function to(move::Move)
    move.to_x, move.to_y
end

function from(move::Move)
    move.from_x, move.from_y
end

"""
    Drop <: AbstractMove

Type for representing a drop movement.
"""
struct Drop <: AbstractMove
    to_x::Int8
    to_y::Int8
    koma::Koma
end

"""
    Drop(str::AbstractString)

Construct a drop from SFEN string.
"""
function Drop(str::AbstractString)
    koma = Koma(string(str[1]), style = :sfen)
    to_x = parse(Int8, string(str[3]))
    to_y = parse(Int8, string(sfen_suuji_to_hankaku_suuji(str[4])))
    Drop(to_x, to_y, koma)
end

function to(drop::Drop)
    drop.to_x, drop.to_y
end

# # 投了
# struct Resign <: AbstractMove end

# # 引き分け
# struct Draw <: AbstractMove end

# # 持将棋
# struct Jishogi <: AbstractMove end

# # 反則手
# function isillegal(kyokumen::Kyokumen, move::Move)

#     isnifu(kyokumen, move) &&
#     is
# end

# # 

# # 連続王手の千日手
# struct PerpetualCheck <: AbstractMove end

# # 
# struct Nifu <: AbstractMove end

function AbstractMove(str::AbstractString)
    n = length(str)
    e = ErrorException("Invalid string $str")
    koma_omote_chars = ['K', 'R', 'B', 'G', 'S', 'N', 'L', 'P']
    # 不正な文字列はここで全て排除する。
    if 4 ≤ n ≤ 5
        if str[2] == '*'
            if str[1] in koma_omote_chars && str[3] in '1':'9' && str[4] in 'a':'i' && n == 4
                Drop(str)
            else
                throw(e)
            end
        else
            char_1_to_9 = '1':'9'
            char_a_to_i = 'a':'i'
            if str[1] in char_1_to_9 && str[3] in char_1_to_9 && str[2] in char_a_to_i && str[4] in char_a_to_i
                if n == 5
                    if str[5] == '+'
                        Move(str)
                    else
                        throw(e)
                    end
                else
                    Move(str)
                end
            else
                throw(e)
            end
        end
    else
        throw(e)
    end
end

function Koma(::Kyokumen, drop::Drop)
    drop.koma
end

function Koma(kyokumen::Kyokumen, move::Move)
    Koma(kyokumen[from(move)...])
end

function susumeru!(kyokumen::Kyokumen, drop::Drop)
    mochigoma = teban_mochigoma(kyokumen)
    if mochigoma[drop.koma] ≥ 1 && isempty(kyokumen[to(drop)...])
        mochigoma[drop.koma] -= 1
        kyokumen[to(drop)...] = Masu(drop.koma, kyokumen.teban)
    else
        error("Fail to susumeru!")
    end
    kyokumen.teban = next(kyokumen.teban)
    kyokumen
end

function susumeru!(kyokumen::Kyokumen, move::Move)
    if !isempty(kyokumen[to(move)...])
        toru!(kyokumen, to(move)...)
    end
    kyokumen[to(move)...] = if move.ispromote
        masu = naru(kyokumen[from(move)...])
        if isnothing(masu)
            error("Cannot promote.")
        else
            masu
        end
    else
        kyokumen[from(move)...]
    end
    kyokumen[from(move)...] = Masu(0)
    kyokumen.teban = next(kyokumen.teban)
    kyokumen
end

function susumeru!(kyokumen::Kyokumen, moves::AbstractMove...)
    for move in moves
        susumeru!(kyokumen, move)
    end
    kyokumen
end

function susumeru(kyokumen::Kyokumen, moves::AbstractMove...)
    kyokumen = copy(kyokumen)
    susumeru!(kyokumen, moves...)
end

function susumeru!(kyokumen::Kyokumen, moves::AbstractString...)
    susumeru!(kyokumen, AbstractMove.(moves)...)
end

function susumeru(kyokumen::Kyokumen, moves::AbstractString...)
    kyokumen = copy(kyokumen)
    susumeru!(kyokumen, AbstractMove.(moves)...)
end

"""
    susumeru!(kyokumen::Kyokumen, moves::AbstractMove...)
    susumeru!(kyokumen::Kyokumen, moves::AbstractString...)
    susumeru(kyokumen::Kyokumen, moves::AbstractMove...)
    susumeru(kyokumen::Kyokumen, moves::AbstractString...)

Do the moves to the kyokumen.
"""
susumeru!, susumeru

function ispromotable(sengo::Sengo, from::Tuple{<:Integer,<:Integer}, to::Tuple{<:Integer,<:Integer})
    if issente(sengo)
        _, y0 = from
        _, y1 = to
        1 ≤ y0 ≤ 3 || 1 ≤ y1 ≤ 3
    else
        _, y0 = from
        _, y1 = to
        7 ≤ y0 ≤ 9 || 7 ≤ y1 ≤ 9
    end
end

function ispromotable(kyokumen::Kyokumen, from::Tuple{<:Integer,<:Integer}, to::Tuple{<:Integer,<:Integer})
    ispromotable(kyokumen.teban, from, to)
end

function ispromotable(kyokumen::Kyokumen, move::Move)
    x = ispromotable(kyokumen[from(move)...])
    if isnothing(x)
        error("Invalid move $move")
    elseif x && ispromotable(kyokumen, from(move), to(move))
        true
    else
        false
    end
end

# todo: add relative position and dousa.
function traditional_notation(kyokumen::Kyokumen, move::AbstractMove)
    ret = ""
    if issente(kyokumen)
        ret *= "☗"
    else
        ret *= "☖"
    end
    x, y = to(move)
    ret *= x |> string |> only |> hankaku_suuji_to_zenkaku_suuji |> string
    ret *= y |> string |> only |> hankaku_suuji_to_zenkaku_suuji |> string
    hankaku_suuji_to_kansuuji
    koma = Koma(kyokumen, move)
    ret *= string(koma, style = :kifu)
    if typeof(move) == Drop
        # 
        ret *= "打"
    else
        # typeof(move) == Move
        if ispromotable(kyokumen, move)
            if move.ispromote
                ret *= "成"
            else
                ret *= "不成"
            end
        end
    end
    ret
end