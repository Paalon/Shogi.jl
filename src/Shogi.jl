module Shogi

# Export an enum's all instances
# Thanks to Alex Arslan
"""
    @exportinstances(enum)

Export all instances of the enum.
"""
macro exportinstances(enum)
    eval = GlobalRef(Core, :eval)
    return :($eval($__module__, Expr(:export, map(Symbol, instances($enum))...)))
end

include("color.jl")
include("piece.jl")
include("square.jl")
include("coordinate.jl")
include("board.jl")
include("hand.jl")
include("position.jl")
include("motion.jl")
include("move.jl")

include("CSA.jl")
include("USI.jl")
include("JSA.jl")

end # module

# module Shogi

# using StaticArrays
# using Graphs
# using MetaGraphNext

# abstract type AbstractColor end
# abstract type AbstractPiece end
# abstract type AbstractSquare end
# abstract type AbstractBoard end
# abstract type AbstractHand end
# abstract type AbstractPosition end

# struct Color <: AbstractColor
#     n::Int8
# end

# const Black = Color(0)
# const White = Color(1)

# struct Piece <: AbstractPiece
#     n::Int8
# end

# struct Square <: AbstractSquare
#     n::Int8
# end

# struct Board <: AbstractBoard
#     matrix::SMatrix{9,9,Square}
# end

# struct Hand <: AbstractHand
# end

# struct Position <: AbstractPosition
# end

# struct Move
# end

# struct Book
#     graph::MetaGraph
# end

# struct Kifu

# end

# function Book()
#     MetaGraph(Graph(), VertexData = Position, EdgeData = )
# end

# end
