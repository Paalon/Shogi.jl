export Coordinate, File, Rank

@enum File::Int8 begin
    FILE1 = 1
    FILE2
    FILE3
    FILE4
    FILE5
    FILE6
    FILE7
    FILE8
    FILE9
end

@exportinstances File

@enum Rank::Int8 begin
    RANK1 = 1
    RANK2
    RANK3
    RANK4
    RANK5
    RANK6
    RANK7
    RANK8
    RANK9
end

@exportinstances Rank

@enum Coordinate::Int8 begin
    COORDINATE11 = 1
    COORDINATE12
    COORDINATE13
    COORDINATE14
    COORDINATE15
    COORDINATE16
    COORDINATE17
    COORDINATE18
    COORDINATE19
    COORDINATE21
    COORDINATE22
    COORDINATE23
    COORDINATE24
    COORDINATE25
    COORDINATE26
    COORDINATE27
    COORDINATE28
    COORDINATE29
    COORDINATE31
    COORDINATE32
    COORDINATE33
    COORDINATE34
    COORDINATE35
    COORDINATE36
    COORDINATE37
    COORDINATE38
    COORDINATE39
    COORDINATE41
    COORDINATE42
    COORDINATE43
    COORDINATE44
    COORDINATE45
    COORDINATE46
    COORDINATE47
    COORDINATE48
    COORDINATE49
    COORDINATE51
    COORDINATE52
    COORDINATE53
    COORDINATE54
    COORDINATE55
    COORDINATE56
    COORDINATE57
    COORDINATE58
    COORDINATE59
    COORDINATE61
    COORDINATE62
    COORDINATE63
    COORDINATE64
    COORDINATE65
    COORDINATE66
    COORDINATE67
    COORDINATE68
    COORDINATE69
    COORDINATE71
    COORDINATE72
    COORDINATE73
    COORDINATE74
    COORDINATE75
    COORDINATE76
    COORDINATE77
    COORDINATE78
    COORDINATE79
    COORDINATE81
    COORDINATE82
    COORDINATE83
    COORDINATE84
    COORDINATE85
    COORDINATE86
    COORDINATE87
    COORDINATE88
    COORDINATE89
    COORDINATE91
    COORDINATE92
    COORDINATE93
    COORDINATE94
    COORDINATE95
    COORDINATE96
    COORDINATE97
    COORDINATE98
    COORDINATE99
end

@exportinstances Coordinate

function Coordinate(file::Integer, rank::Integer)
    Coordinate(9 * (file - 1) + rank)
end

function Coordinate(file::File, rank::Rank)
    Coordinate(9 * (Integer(file) - 1) + Integer(rank))
end

File(coordinate::Coordinate) = File(cld(Integer(coordinate), 9))

function Rank(coordinate::Coordinate)
    Rank(9 + rem(Integer(coordinate), 9, RoundUp))
end

function Base.Tuple{T, T}(coordinate::Coordinate) where T <: Integer
    T(cld(Integer(coordinate), 9)), T(9 + rem(Integer(coordinate), 9, RoundUp))
end