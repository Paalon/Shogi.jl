module JosekiManager

export USIPosition, kifu_splat, kifu_df, NullDataFrame

export save_database, load_database, write_graphviz

export txttodf, txttopdf

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
            from = df[i, :from]
            to = df[i, :to]
            label = df[i, :move]
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

const startpos = "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"

# Parse USI position command to `(usi_kyokumen, usi_moves)`.
# See http://shogidokoro.starfree.jp/usi.html for the detail of Universal Shogi Interface (USI).
# todo: 不正な文字列の処理が雑なので整理する。
function USIPosition(str::AbstractString)
    strs = split(str, " "; limit = 2)
    if length(strs) == 1
        command = strs[1]
        if command == "startpos"
            startpos, String[]
        else
            error("Wrong grammar USI command: position $str")
        end
    else
        command, args = strs
        if command == "sfen"
            args_split = split(args, " "; limit = 6)
            n = length(args_split)
            if n == 6
                banmen, teban, mochigoma, tesuu, moves_str, moves = args_split
                moves_str == "moves" || error("Wrong grammar in USI command: position $str")
                usi_position_sfen = join([banmen, teban, mochigoma, tesuu], " ")
                usi_position_sfen, split(moves, " ")
            elseif n == 4
                banmen, teban, mochigoma, tesuu = args_split
                usi_position_sfen = join([banmen, teban, mochigoma, tesuu], " ")
            else
                error("Wrong grammar USI command: position $str")
            end
        elseif command == "startpos"
            moves_str, moves = split(args, " "; limit = 2)
            moves_str == "moves" || error("Wrong grammar in USI command: position $str")
            startpos, split(moves, " ")
        else
            error("Wrong grammar USI command: position $str")
        end
    end
end

function kifu_splat(str::AbstractString)
    position, moves = USIPosition(str)
    kyokumen = Kyokumen(position)
    history = AbstractString[]
    push!(history, sfen(kyokumen))
    for move in moves
        move!(kyokumen, move)
        push!(history, sfen(kyokumen))
    end
    history, moves
end

function NullDataFrame()
    DataFrame(:from => String[], :to => String[], :move => String[])
end

function kifu_df(history, moves)
    df = NullDataFrame()
    for i = 1:length(moves)
        df = vcat(df, DataFrame(
            :from => history[i],
            :to => history[i+1],
            :move => moves[i],
        ))
    end
    df
end

function kifu_df(str::AbstractString)
    kifu_df(kifu_splat(str)...)
end

function txttodf(fname::AbstractString)
    df = NullDataFrame()
    open(fname, "r") do io
        while !eof(io)
            line = readline(io)
            try
                df_new = kifu_df(line)
                df = vcat(df, df_new)
            catch _
                error("次の棋譜の読み込み中にエラーが発生しました。\n$line")
            end
        end
    end
    unique!(df)
end

function txttopdf(fname::AbstractString)
    df = txttodf(fname)
    write_graphviz("$fname.gv", df)
    run(`dot $fname.gv -T pdf -O`)
    run(`open $fname.gv.pdf`)
end

end # module
