export Motion

const UP = [0, -1]
const DOWN = -UP
const LEFT = [1, 0]
const RIGHT = -LEFT
const UP_RIGHT = UP + RIGHT
const UP_LEFT = UP + LEFT
const DOWN_RIGHT = DOWN + RIGHT
const DOWN_LEFT = DOWN + LEFT

struct Motion
    direct::Vector{Vector{Int64}}
    projective::Vector{Vector{Int64}}
end

const PIECE_TO_MOTION = Dict(
    PAWN => Motion([UP], []),
    LANCE => Motion([], [UP]),
    KNIGHT => Motion([2UP + LEFT, 2UP + RIGHT], []),
    SILVER => Motion([UP, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT], []),
    GOLD => Motion([UP, UP_LEFT, UP_RIGHT, LEFT, RIGHT, DOWN], []),
    KING => Motion([UP, UP_LEFT, UP_RIGHT, LEFT, RIGHT, DOWN_LEFT, DOWN_RIGHT, DOWN], []),
    BISHOP => Motion([], [UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT]),
    ROOK => Motion([], [UP, LEFT, RIGHT, DOWN]),
    PROMOTED_PAWN => Motion([UP, UP_LEFT, UP_RIGHT, LEFT, RIGHT, DOWN], []),
    PROMOTED_LANCE => Motion([UP, UP_LEFT, UP_RIGHT, LEFT, RIGHT, DOWN], []),
    PROMOTED_KNIGHT => Motion([UP, UP_LEFT, UP_RIGHT, LEFT, RIGHT, DOWN], []),
    PROMOTED_SILVER => Motion([UP, UP_LEFT, UP_RIGHT, LEFT, RIGHT, DOWN], []),
    PROMOTED_BISHOP => Motion([UP, LEFT, RIGHT, DOWN], [UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT]),
    PROMOTED_ROOK => Motion([UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT], [UP, LEFT, RIGHT, DOWN]),
)