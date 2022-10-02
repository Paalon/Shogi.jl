module JKF

using Bijections
using JSON
using ..CSA
import ..Koma
import Base: string, Dict
import ..KifuFormat

mutable struct JSONKifuFormat <: KifuFormat
    header
    initial
    moves
end

@enum Color::Bool 先手 = 0 後手 = 1

struct TimeFormat
    h::Union{Nothing,Int}
    m::Int
    s::Int
end
TimeFormat(d::Dict) = TimeFormat(get(d, "h", nothing), d["m"], d["s"])
Dict(f::TimeFormat) = if isnothing(f.h)
    Dict("m" => f.m, "s" => f.s)
else
    Dict("h" => f.h, "m" => f.m, "s" => f.s)
end
json(f::TimeFormat) = JSON.json(Dict(f))

struct PlaceFormat
    x::Int
    y::Int
end
PlaceFormat(d::Dict) = PlaceFormat(d["x"], d["y"])
# Dict(f::PlaceFormat) = Dict("x" => f.x, "y" => f.y)
# json(f::PlaceFormat) = JSON.json(Dict(f))

struct MoveFormatTime
    now::TimeFormat
    total::TimeFormat
end

const SpecialMove = CSA.SpecialMove

const Piece = Koma

struct RelativeString
    str::String
end

@enum InitialPresetString begin
    平手
    香落ち
    右香落ち
    角落ち
    飛車落ち
    飛香落ち
    二枚落ち
    三枚落ち
    四枚落ち
    五枚落ち
    左五枚落ち
    六枚落ち
    左七枚落ち
    右七枚落ち
    八枚落ち
    十枚落ち
    その他
end

const initial_preset_string_to_string = Bijection(Dict(
    平手 => "HIRATE",
    香落ち => "KY",
    右香落ち => "KY_R",
    角落ち => "KA",
    飛車落ち => "HI",
    飛香落ち => "HIKY",
    二枚落ち => "2",
    三枚落ち => "3",
    四枚落ち => "4",
    五枚落ち => "5",
    左五枚落ち => "5_L",
    六枚落ち => "6",
    左七枚落ち => "7_L",
    右七枚落ち => "7_R",
    八枚落ち => "8",
    十枚落ち => "10",
    その他 => "OTHER"
))
string(x::InitialPresetString) = initial_preset_string_to_string[x]

# Move

struct Move
    color::Color
    from::Union{PlaceFormat,Nothing}
    to::PlaceFormat
    piece::Piece
    same::Union{Bool,Nothing}
    promote::Union{Bool,Nothing}
    capture::Union{Piece,Nothing}
    relative::Union{RelativeString,Nothing}
end

function Move(d::Dict)
    color = d["color"] |> Color
    from = if haskey(d, "from")
        PlaceFormat(d["from"])
    else
        nothing
    end
    to = d["to"] |> PlaceFormat
    piece = CSA.KomaFromCSA(d["piece"])
    same = get(d, "same", nothing)
    promote = get(d, "promote", nothing)
    capture = if haskey(d, "capture")
        CSA.KomaFromCSA(d["capture"])
    else
        nothing
    end
    relative = if haskey(d, "relative")
        RelativeString(d["relative"])
    else
        nothing
    end
    Move(color, from, to, piece, same, promote, capture, relative)
end
Move(str::AbstractString) = Move(JSON.parse(str))
Move(io::IO) = Move(read(io, String))
Move(color::Color, from::Union{PlaceFormat,Nothing}, to::PlaceFormat, piece::Piece) = Move(color, from, to, piece, nothing, nothing, nothing, nothing)
Drop(color::Color, to::PlaceFormat, piece::Piece) = Move(color, nothing, to, piece)

# end Move

# MoveFormat

mutable struct MoveFormat
    comments::Union{String,Nothing}
    move::Union{Move,Nothing}
    time::Union{MoveFormatTime,Nothing}
    special::Union{SpecialMove,Nothing}
    forks::Union{Array{MoveFormat},Nothing}
end

MoveFormat() = MoveFormat(nothing, nothing, nothing, nothing, nothing)
MoveFormat(move::Move) = MoveFormat(nothing, move, nothing, nothing, nothing)
MoveFormat(special::SpecialMove) = MoveFormat(nothing, nothing, nothing, special, nothing)

function MoveFormat(d::Dict)
    comments = get(d, "comments", nothing)
    move = get(d, "move", nothing)
    to = d["to"]
    piece = d["piece"]
    same = get(d, "same", nothing)
    promote = get(d, "promote", nothing)
    capture = get(d, "capture", nothing)
    relative = get(d, "relative", nothing)
    MoveFormat(comments)
end
MoveFormat(str::AbstractString) = MoveFormat(JSON.parse(str))
MoveFormat(io::IO) = MoveFormat(read(io, String))

function json(f::MoveFormat)
    d = Dict()
    if !isnothing(f.comments)
        d["comments"] = json(f.comments)
    end
    if !isnothing(f.move)
        d["move"] = json(f.move)
    end
    d["to"] = json(f.to)
    d["piece"] = json(f.piece)
    if !isnothing(f.same)
        d["same"] = json(f.same)
    end
    if !isnothing(f.promote)
        d["promote"] = json(f.promote)
    end
    if !isnothing(f.capture)
        d["capture"] = json(f.capture)
    end
    if !isnothing(f.relative)
        d["relative"] = json(f.relative)
    end
    d
end

# end MoveFormat

end # module JKF