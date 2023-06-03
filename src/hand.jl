using Bijections

export Hand
export clear!

mutable struct Hand
    counts::MVector{7, UInt8}
end

Base.:(==)(a::Hand, b::Hand) = a.counts == b.counts

Base.copy(hand::Hand) = Hand(copy(hand.counts))

Hand() = Hand(MVector{7,UInt8}(0, 0, 0, 0, 0, 0, 0))

const PIECE_TO_INDEX = Bijection(Dict(
    PAWN => 1,
    LANCE => 2,
    KNIGHT => 3,
    SILVER => 4,
    GOLD => 5,
    BISHOP => 6,
    ROOK => 7,
))

Base.getindex(hand::Hand, piece::Piece) = hand.counts[PIECE_TO_INDEX[piece]]

Base.setindex!(hand::Hand, n::Integer, piece::Piece) = hand.counts[PIECE_TO_INDEX[piece]] = n

function clear!(hand::Hand)
    fill!(hand.counts, 0)
end