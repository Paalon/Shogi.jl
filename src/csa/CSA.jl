# Copyright 2021-12-14 Koki Fushimi

module CSA

using Bijections

mutable struct Parser
    root::Kifu
end
function Parser(str::String)
end
Parser() = Parser("")
Parser(io::IO) = Parser(read(io, String))

function parse(parser::Parser)::Kifu
    v = tryparse(parser)
    v isa ParserError && throw(v)
    v
end
parse(str::AbstractString) = parse(Parser(String(str)))
parse(io::IO) = parse(read(io, String))

function tryparse(parser::Parser)::Err{Kifu}
    while true
        # ///
    end
    parser.root
end

function parse_toplevel(parser::Parser)::Err{Nothing}
    # ...
end

@enum ErrorType begin
    ErrSengo
    ErrKoma
    ErrMasu
    ErrBanmen
    ErrKyokumen
    ErrMove
    ErrKifu
end

const err_message = Dict(
    ErrInvalidSengo => "invalid sengo",
    ErrInvalidKoma => "invalid koma name",
    ErrInvalidPosition => "invalid position numbers"
)

for err in instances(ErrorType)
    @assert haskey(err_message, err) "$err does not have an error message"
end

mutable struct ParserError <: Exception
    type::ErrorType
end

# Many functions return either a T or a ParserError
const Err{T} = Union{T,ParserError}

"""
    csa(koma::Koma)::String

Returns from Koma to CSA string.
"""
function csa(koma::Koma)
    koma_to_csa[koma]
end

"""
    KomaFromCSA(str::AbstractString)::Koma

Returns from CSA string to Koma.
"""
function KomaFromCSA(str::AbstractString)
    koma_to_csa(str)
end

# Kifu

export KifuFromCSA

"""
    KifuFromCSA(filename::AbstractString)

Returns kifu from CSA string.
"""
function KifuFromCSA(filename::AbstractString)
    kyokumen = Kyokumen()
    moves = CSAMove[]
    open(filename, "r") do io
        while !eof(io)
            str = readline(io)
            if length(str) ≥ 1
                char = str[1]
                if char == '''
                elseif char == 'V'
                elseif char == 'N'
                    # @info "対局者情報は読み飛ばされます。"
                elseif char == '$'
                    # @info "各種棋譜情報は読み飛ばされます。"
                elseif char == '%'
                    if str == "%TORYO"
                    end
                elseif char == '+'
                    if length(str) == 1
                        kyokumen.teban == ☗
                    else
                        push!(moves, CSAMove(str))
                    end
                elseif char == '-'
                    if length(str) == 1
                        kyokumen.teban == ☖
                    else
                        push!(moves, CSAMove(str))
                    end
                elseif char == 'T'
                elseif char == 'P'
                    n = parse(Int, str[2])
                    for k = 1:9
                        kyokumen[10-k, n] = MasuFromCSA(str[3k:3k+2])
                    end
                end
            end
        end
    end
    Kifu(kyokumen, moves)
end

function csa(kifu::Kifu)::String
end

function print(io::IO, data::Kifu)
    
end

end # module CSA

# function next_from_csa!(kyokumen::Kyokumen, str::AbstractString)
#     # check length
#     length(str) == 7 || error("Invalid length")
#     # check teban
#     teban = SengoFromCSA(string(str[1]))
#     kyokumen.teban == teban || error("Invalid teban")
#     # parse coordinate
#     from_x = parse(Int, str[2])
#     from_y = parse(Int, str[3])
#     to_x = parse(Int, str[4])
#     to_y = parse(Int, str[5])
#     to_koma = KomaFromCSA(str[6:7])
#     if from_x == 0 && from_y == 0
#         kyokumen[to_x, to_y] = Masu(to_koma, kyokumen.teban)
#         teban_mochigoma(kyokumen)[to_koma] -= 1
#     else
#         to_koma_prev = Koma(kyokumen[to_x, to_y])
#         if !isnothing(to_koma_prev)
#             teban_mochigoma(kyokumen)[omote(to_koma_prev)] += 1
#         end
#         kyokumen[from_x, from_y] = 〼
#         kyokumen[to_x, to_y] = to_koma
#     end
#     kyokumen.teban = next(kyokumen.teban)
#     kyokumen
# end

# """
#     next_from_csa(kyokumen::Kyokumen, str::AbstractString)

# Construct the next kyokumen from current kyokumen `kyokumen` and CSA move string `str`.
# """
# function next_from_csa(kyokumen::Kyokumen, str::AbstractString)
#     kyokumen = copy(kyokumen)
#     next_from_csa!(kyokumen, str)
# end

# function parse_char_to_int(char::AbstractChar)
#     parse(Int, string(char))
# end

# function MoveFromCSA(kyokumen::Kyokumen, str::AbstractString)
#     length(str) == 5 || error("Invalid CSA move string: $str")
#     sengo = SengoFromCSA(str[1])
#     x0_char, y0_char, x1_char, y1_char = str[2:5]
#     koma = KomaFromCSA(str[6:7])
#     if x0_char == '0' && y0_char == '0'
#         x1, y1 = parse_char_to_int.((x0_char, y0_char))
#         Drop(x1, y1, koma)
#     else
#         x0, y0, x1, y1 = parse_char_to_int.((x0_char, y0_char, x1_char, y1_char))
#         koma0 = Koma(kyokumen[x0, y0])
#         if ispromotable(koma0) && naru(koma0) == koma
#             Move(x0, y0, x1, y1, true)
#         else
#             Move(x0, y0, x1, y1, false)
#         end
#     end
# end

# function MoveDictFromCSA(str::AbstractString)
#     n = length(str)
#     n == 7 || error()
#     sengo = SengoFromCSA(str[1])
#     if str[2:3] == "00"
#         # drop
#         x = int_to_hankaku(str[4])
#         y = int_to_hankaku(str[5])
#         koma = KomaFromCSA(str[6:7])
#         Dict(
#             :teban => sengo,
#             :dst => (x, y),
#             :dst_koma => koma,
#             :motion => [打],
#         )
#     else
#         # not drop
#         x_src = int_to_hankaku(str[2])
#         y_src = int_to_hankaku(str[3])
#         x_dst = int_to_hankaku(str[4])
#         y_dst = int_to_hankaku(str[5])
#         koma = KomaFromCSA(str[6:7])
#         Dict(
#             :teban => sengo,
#             :src => (x_src, y_src),
#             :dst => (x_dst, y_dst),
#             :dst_koma => koma,
#             :motion => [非打],
#         )
#     end
# end

# function csa(kyokumen::Kyokumen, move::Move)
#     x0, y0 = from(move)
#     x1, y1 = to(move)
#     koma = Koma(kyokumen, move)
#     koma = ifelse(move.ispromotion, naru(koma), koma)
#     koma_str = csa(koma)
#     teban_str = csa(kyokumen.teban)
#     "$teban_str$x0$y0$x1$y1$koma_str"
# end

# function csa(::Kyokumen, drop::Drop)
#     x0, y0 = 0, 0
#     x1, y1 = to(drop)
#     koma = Koma(drop)
#     koma_str = csa(koma)
#     teban_str = csa(kyokumen.teban)
#     "$teban_str$x0$y0$x1$y1$koma_str"
# end

# str = """
# V2.2
# N+<先手の対局者名> / optional
# N-<後手の対局者名> / optional
# $<keyword>:(<data>) / optional
# FU
# KY
# KE
# GI
# KKI"""
