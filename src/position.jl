export Position

mutable struct Position
    board::Board
    hands::Tuple{Hand, Hand}
    side::Color
end

Position() = Position(Board(), (Hand(), Hand()), BLACK)

Base.:(==)(a::Position, b::Position) = a.board == b.board && a.hands == b.hands && a.side == b.side

Base.copy(position::Position) = Position(copy(position.board), (copy(position.hands[1]), copy(position.hands[2])), position.side)

function Base.show(io::IO, position::Position)
    print(io, CSA.string(position))
end

Color(position::Position) = position.side

getboard(position::Position) = position.board

function gethand(position::Position, color::Color)
    if isblack(color)
        position.hands[1]
    else
        position.hands[2]
    end
end

Base.getindex(position::Position, inds...) = getindex(position.board, inds...)
Base.setindex!(position::Position, X, inds...) = setindex!(position.board, X, inds...)

Base.sign(position::Position) = sign(position.board)

function kingcoordinate(position::Position, side::Color)
    kingsquare = Square(side, KING)
    for x in 1:9
        for y in 1:9
            if position[x, y] == kingsquare
                return Coordinate(x, y)
            end
        end
    end
end