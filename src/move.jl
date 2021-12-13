# Copyright 2021-11-25 Koki Fushimi

export AbstractMove, Move, Drop, sfen
export susumeru!, susumeru

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

function sfen(move::Move)
    from_x = move.from_x |> string
    from_y = move.from_y |> integer_to_sfen_suuji
    to_x = move.to_x |> string
    to_y = move.to_y |> integer_to_sfen_suuji
    result = "$from_x$from_y$to_x$to_y"
    if move.ispromote
        result *= "+"
    end
    result
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

function sfen(drop::Drop)
    koma = drop.koma |> sfen
    to_x = drop.to_x
    to_y = drop.to_y |> integer_to_sfen_suuji
    "$koma*$to_x$to_y"
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

function susumeru(kyokumen::Kyokumen, move::AbstractMove)
    kyokumen = copy(kyokumen)
    susumeru!(kyokumen, move)
end

"""
    susumeru!(kyokumen::Kyokumen, move::AbstractMove)
    susumeru(kyokumen::Kyokumen, move::AbstractMove)

Do the movement to the kyokumen.
"""
susumeru!, susumeru