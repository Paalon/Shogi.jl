push!(LOAD_PATH, pwd())
using Shogi
using DataFrames
using Feather

function load_database(file::String)
    Feather.read(file)
end

function save_database(file::String, df::DataFrame)
    Feather.write(file, df)
end

function write_graphviz(file::String, df::DataFrame; nodelabel = :nonodelabel, fontname = "Verdana")
    open(file, "w") do f
        println(f, "digraph {")
        println(f, "node [fontname=\"$fontname\"]")
        println(f, "edge [fontname=\"$fontname\"]")
        n = size(df, 1)
        for i = 1:n
            from = df[i, :from_sfen]
            to = df[i, :to_sfen]
            label = df[i, :move_sfen]
            if nodelabel == :nonodelabel
                println(f, "\"$from\" [label=\"\"];")
                println(f, "\"$to\" [label=\"\"];")
            end
            text = "\"$from\" -> \"$to\" [label=\"$label\"];"
            println(f, text)
        end
        println(f, "}")
    end
end

import Base.show
using Test

function add_move!(df::DataFrame, from_sfen::String, to_sfen::String, move_sfen::String)
    append!(df, DataFrame(from_sfen = from_sfen, to_sfen = to_sfen, move_sfen = move_sfen))
end

# function load_graphviz()
# end

# function sfen_to_kifu()
# end

const koma_omotes_string = "KRBGSNLP"

function replace_number_to_1(x)
    d = Dict(
        "9" => "111111111",
        "8" => "11111111",
        "7" => "1111111",
        "6" => "111111",
        "5" => "11111",
        "4" => "1111",
        "3" => "111",
        "2" => "11",
        #"1"=>"1",
    )
    for pair in d
        x = replace(x, pair)
    end
    x
end

function split_sfen_dan(sfen_dan)
    dan = String[]
    as = split(sfen_dan, "")
    iter_result = iterate(as)
    while !isnothing(iter_result)
        (a, state) = iter_result
        if a == "+"
            (a, state) = iterate(as, state)
            push!(dan, "+$a")
            iter_result = iterate(as, state)
        else
            push!(dan, a)
            iter_result = iterate(as, state)
        end
    end
    dan
end

# 将棋盤

mutable struct Shogiban
    state::Matrix{Int8}
end

function ShogibanFromSFEN(sfen::AbstractString)
    # sfen
    # 91, 81, 71, ...
    # ..., 39, 29, 19.
    sfen = replace_number_to_1(sfen)
    dans = split(sfen, "/")
    state = Matrix{Int8}(undef, 9, 9)
    for (j, dan) in enumerate(dans)
        masu_strings = split_sfen_dan(dan)
        for (i, masu_string) in enumerate(masu_strings)
            masu_int = sfen_masu_to_int8(masu_string)
            state[10-i, j] = masu_int
        end
    end
    Shogiban(state)
end

function make_sfen(shogiban::Shogiban)
    ret = ""
    for j = 1:1:9
        for i = 9:-1:1
            ret *= int_to_sfen_masu(shogiban.state[i, j])
        end
        if j != 9
            ret *= "/"
        end
    end
    ret = replace(ret, "111111111" => "9")
    ret = replace(ret, "11111111" => "8")
    ret = replace(ret, "1111111" => "7")
    ret = replace(ret, "111111" => "6")
    ret = replace(ret, "11111" => "5")
    ret = replace(ret, "1111" => "4")
    ret = replace(ret, "111" => "3")
    ret = replace(ret, "11" => "2")
    # replace!(ret, "1" => "1")
    ret
end

function show(io::IO, shogiban::Shogiban)
    # 91
    # 81
    # 71
    # ...
    # 39
    # 29
    # 19
    for j = 1:1:9
        for i = 9:-1:1
            print(io, shogiban.state[i, j] |> int_to_masu_string)
            # print(i, j)
        end
        if j != 9
            print(io, "\n")
        end
    end
end

# 駒台

mutable struct Komadai
    koma_numbers::Vector{Int8}
end

function Komadai()
    Komadai(zeros(Int8, length(koma_omotes_string)))
end

function KomadaiFromSFEN(sfen::AbstractString)
    komas_sente = uppercase(koma_omotes_string)
    komas_gote = lowercase(koma_omotes_string)
    komas = komas_sente * komas_gote
    komas_length = length(komas)
    mochigoma_numbers = zeros(Int8, komas_length)

    # 4P syntax

    if sfen == "-"
        # do nothing
    else
        iterator_result = iterate(sfen)
        while !isnothing(iterator_result)
            character, iterator_state = iterator_result
            n = 1
            if isdigit(character)
                n = parse(Int8, string(character))
                iterator_result = iterate(sfen, iterator_state)
                if isnothing(iterator_result)
                    throw(ErrorException("Invalid SFEN in mochigoma information: $sfen"))
                end
                character, iterator_state = iterator_result
            end
            for i = 1:komas_length
                if character == komas[i]
                    mochigoma_numbers[i] = n
                    @goto end_for
                end
            end
            throw(ErrorException("Invalid SFEN in mochigoma information: $sfen"))
            @label end_for
            iterator_result = iterate(sfen, iterator_state)
        end
    end

    # P4 syntax

    # iterator_result = iterate(sfen)
    # while !isnothing(iterator_result)
    #     character, iterator_state = iterator_result
    #     for i = 1:komas_length
    #         if character == komas[i]
    #             iterator_result = iterate(sfen, iterator_state)
    #             if isnothing(iterator_result)
    #                 # 次の文字がないとき
    #                 mochigoma_numbers[i] = 1
    #                 @goto end_loop_2
    #             end
    #             character, iterator_state = iterate(sfen, iterator_state)
    #             if isdigit(character)
    #                 # 次の文字が数字のとき
    #                 n = parse(Int8, string(character))
    #                 mochigoma_numbers[i] = n
    #                 @goto end_loop_1_with_iterate
    #             else # 次の文字がアルファベットのとき
    #                 mochigoma_numbers[i] = 1
    #                 @goto end_loop_1_without_iterate
    #             end
    #         end
    #     end
    #     @label end_loop_1_with_iterate
    #     iterator_result = iterate(sfen, iterator_state)
    #     @label end_loop_1_without_iterate
    # end
    # @label end_loop_2

    Komadai(mochigoma_numbers[1:komas_length÷2]), Komadai(mochigoma_numbers[komas_length÷2+1:end])
end

function Base.show(io::IO, komadai::Komadai)
    komas = [
        "玉"
        "飛"
        "角"
        "金"
        "銀"
        "桂"
        "香"
        "歩"
    ]
    if sum(komadai.koma_numbers) == 0
        print(io, "なし")
    else
        for (i, komasuu) in enumerate(komadai.koma_numbers)
            if komasuu == 0
                continue
            elseif komasuu == 1
                print(io, komas[i])
            else
                print(io, komas[i], komasuu)
            end
        end
    end
end

function make_sfen(komadai::Komadai)
    ret = ""
    for (i, n) in enumerate(komadai.koma_numbers)
        if n == 0
            continue
        elseif n == 1
            ret *= int_to_sfen_koma_omote(i)
        else
            ret *= "$n$(int_to_sfen_koma_omote(i))"
        end
    end
    ret
end

# 局面

mutable struct Kyokumen
    shogiban::Shogiban
    komadai_sente::Komadai
    komadai_gote::Komadai
    teban::Bool
    tesuu::Integer
end

function KyokumenFromSFEN(sfen::String)
    shogiban_sfen, teban_sfen, komadai_sfen, tesuu_string = split(sfen, " ")
    shogiban = ShogibanFromSFEN(shogiban_sfen)
    teban = sfen_teban_to_bool(teban_sfen)
    if isnothing(teban)
        throw(Error("invalid teban string"))
    end
    tesuu = tryparse(Int, tesuu_string)
    if isnothing(tesuu)
        throw(Error("invalid tesuu string"))
    end
    komadai_sente, komadai_gote = KomadaiFromSFEN(komadai_sfen)
    Kyokumen(shogiban, komadai_sente, komadai_gote, teban, tesuu)
end

function KyokumenFromUSIPosition(usi_position::USIPosition)

end

function Base.show(io::IO, kyokumen::Kyokumen)
    println(io, "局面")
    println(io, kyokumen.shogiban)
    println(io, "先手持ち駒: ", kyokumen.komadai_sente)
    println(io, "後手持ち駒: ", kyokumen.komadai_gote)
    if kyokumen.teban
        println(io, "先手番")
    else
        println(io, "後手番")
    end
    println(io, "$(kyokumen.tesuu - 1) 手目")
end

function make_sfen(kyokumen::Kyokumen)
    shogiban = make_sfen(kyokumen.shogiban)
    teban = if kyokumen.teban
        "b"
    else
        "w"
    end
    komadai_sente = make_sfen(kyokumen.komadai_sente)
    komadai_gote = lowercase(make_sfen(kyokumen.komadai_gote))
    komadai = komadai_sente * komadai_gote
    if komadai == ""
        komadai = "-"
    end
    "$shogiban $teban $komadai $(kyokumen.tesuu)"
end

function parse_sfen_move(sfen_move::AbstractString)
    4 <= length(sfen_move) <= 5 || error("Invalid SFEN move string length: $sfen_move")
    if sfen_move[2] !== '*'
        from_x = tryparse(Int, string(sfen_move[1]))
        if isnothing(from_x)
            throw(ErrorException("Invalid SFEN move string in from_x: $sfen_move"))
        end
        to_x = tryparse(Int, string(sfen_move[3]))
        if isnothing(to_x)
            throw(ErrorException("Invalid SFEN move string in to_x: $sfen_move"))
        end
        ispromoting = length(sfen_move) == 5 && sfen_move[5] == '+'
        try
            from_y = sfen_move_to_int(sfen_move[2])
            to_y = sfen_move_to_int(sfen_move[4])
            Dict(
                :type => "move",
                :from_x => from_x,
                :from_y => from_y,
                :to_x => to_x,
                :to_y => to_y,
                :ispromoting => ispromoting
            )
        catch _
            throw(ErrorException("Invalid SFEN move string in: $sfen_move"))
        end
    else
        # 打
        koma = sfen_masu_to_int8(sfen_move[1])
        to_x = tryparse(Int, string(sfen_move[3]))
        if isnothing(to_x)
            throw(ErrorException("Invalid SFEN move string: $sfen_move"))
        end
        try
            to_y = sfen_move_to_int(sfen_move[4])
            Dict(
                :type => "drop",
                :koma => koma,
                :x => to_x,
                :y => to_y,
            )
        catch _
            throw(ErrorException("Invalid SFEN move string: $sfen_move"))
        end
    end
end

function next!(kyokumen::Kyokumen)
    kyokumen.teban = !kyokumen.teban
    kyokumen.tesuu += 1
end

function move!(kyokumen::Kyokumen, sfen_move::AbstractString)
    dict = parse_sfen_move(sfen_move)
    if dict[:type] == "move"
        to_state = kyokumen.shogiban.state[dict[:to_x], dict[:to_y]]
        from_state = kyokumen.shogiban.state[dict[:from_x], dict[:from_y]]
        if to_state == 0
            kyokumen.shogiban.state[dict[:to_x], dict[:to_y]] = from_state + sign(from_state) * dict[:ispromoting]
            kyokumen.shogiban.state[dict[:from_x], dict[:from_y]] = 0
        else
            kyokumen.shogiban.state[dict[:to_x], dict[:to_y]] = from_state + sign(from_state) * dict[:ispromoting]
            kyokumen.shogiban.state[dict[:from_x], dict[:from_y]] = 0
            n = (abs(to_state) + 1) ÷ 2
            if kyokumen.teban
                kyokumen.komadai_sente.koma_numbers[n] += 1
            else
                kyokumen.komadai_gote.koma_numbers[n] += 1
            end
        end
    elseif dict[:type] == "drop"
        kyokumen.shogiban.state[dict[:x], dict[:y]] = dict[:koma]
    end
    next!(kyokumen)
    kyokumen
end

function test()
    kyokumen = KyokumenFromSFEN(sfen_startpos)
    println(kyokumen)

    @test make_sfen(kyokumen) == sfen_startpos

    sfen_test = "lnsgk1sn1/6g2/p1pppp2p/7p1/5b3/2s2R3/P2PPPP1P/1pG+B3S1/LN2KG1NL w L4Pr 34"
    kyokumen = KyokumenFromSFEN(sfen_test)
    println(kyokumen)
    @test make_sfen(kyokumen) == sfen_test

    sfen_test = "lnsgk1s2/6g2/p1ppppn1p/6Lp1/6R2/2s6/P2PPPP1P/2G+B3S1/+p3KG1NL w B4Prnl 40"
    kyokumen = KyokumenFromSFEN(sfen_test)
    println(kyokumen)
    @test make_sfen(kyokumen) == sfen_test

    sfen_test = "lnsgk1snl/1r4gb1/p1ppppppp/9/1p5P1/9/PPPPPPP1P/1BG4R1/LNS1KGSNL b - 7"
    kyokumen = KyokumenFromSFEN(sfen_test)
    println(kyokumen)
    @test make_sfen(kyokumen) == sfen_test
    move!(kyokumen, "2e2d")
    println(kyokumen)
    println(make_sfen(kyokumen))
    move!(kyokumen, "2c2d")
    println(kyokumen)
    println(make_sfen(kyokumen))
    move!(kyokumen, "2h2d")
    println(kyokumen)
    println(make_sfen(kyokumen))

end

function make_dataframe(from_sfen::AbstractString, move_sfen::AbstractString)
    from = KyokumenFromSFEN(from_sfen)
    to = move!(from, move_sfen)
    to_sfen = make_sfen(to)
    DataFrame(:from_sfen => from_sfen, :to_sfen => to_sfen, :move_sfen => move_sfen)
end

function null_df()
    DataFrame("from_sfen" => String[], "to_sfen" => String[], "move_sfen" => String[])
end

function make_dataframe_from_sfen_moves(init_sfen::AbstractString, moves::Vector{<:AbstractString})
    df = DataFrame("from_sfen" => "-", "to_sfen" => init_sfen, "move_sfen" => "-")
    for move in moves
        df_new = make_dataframe(df.to_sfen[end], move)
        df = vcat(df, df_new)
    end
    delete!(df, 1)
end

function make_dataframe_from_sfen_moves(init_sfen::AbstractString, moves_str::AbstractString)
    make_dataframe_from_sfen_moves(init_sfen, split(moves_str, " "))
end

function merge_database(df, df_add)
    unique(vcat(df, df_add))
end

function dataframe_from_sfen_kifus(kifus::AbstractString)
    df = null_df()
    kifus = kifus[1:end-1]

    for kifu in split(kifus, "\n")
        df_new = make_dataframe_from_sfen_moves(sfen_startpos, kifu)
        df = vcat(df, df_new)
    end
    unique!(df)
end

# Parse USI position command to `(usi_kyokumen, usi_moves)`.
# See http://shogidokoro.starfree.jp/usi.html for the detail of Universal Shogi Interface (USI).
function parse_usi_position(usi_position::AbstractString)
    command, args = split(usi_position, " "; limit = 2)
    if command == "sfen"
        盤面, 手番, 持ち駒, 手数, moves_str, moves = split(args, " "; limit = 6)
        moves_str == "moves" || error("Wrong grammar in USI command `position`: $usi_position")
        usi_position_sfen = join([盤面, 手番, 持ち駒, 手数], " ")
        usi_position_sfen, moves
    elseif command == "startpos"
        moves_str, moves = split(args, " "; limit = 2)
        moves_str == "moves" || error("Wrong grammar in USI command `position`: $usi_position")
        usi_position_sfen = sfen_startpos
        usi_position_sfen, moves
    else
        error("Wrong grammar in USI command `position`: $usi_position")
    end
end

function make_dataframe_from_usi_position(usi_position::AbstractString)
    usi_position_sfen, moves = parse_usi_position(usi_position)
    make_dataframe_from_sfen_moves(usi_position_sfen, moves)
end

function make_dataframe_from_usi_positions(usi_positions::Vector{<:AbstractString})
    df = null_df()
    for usi_position in usi_positions
        if !isempty(usi_position)
            df_ = make_dataframe_from_usi_position(usi_position)
            df = vcat(df, df_)
        end
    end
    unique!(df)
end

function make_dataframe_from_usi_positions(usi_positions::AbstractString)
    usi_positions_ = split(usi_positions, "\n")
    make_dataframe_from_usi_positions(usi_positions_)
end