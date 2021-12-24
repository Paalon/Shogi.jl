using Shogi

function read_sfens(filename::AbstractString)
    book = Book()
    open(filename, "r") do io
        while !eof(io)
            line = readline(io)
            if !isempty(line)
                try
                    if line[1] == '#'
                        # コメント
                    elseif line[1] == 'b'
                        best, weight, line = split(line, " ", limit=3)
                        kifu = KifuFromSFEN(line; weight=parse(Float64, weight))
                        book = merge(book, kifu)
                    elseif line[1] == 'l'
                        _, label = split(line, " ", limit=2)
                        label = replace(label, "nl" => "\n")
                        line = readline(io)
                        kyokumen = KyokumenFromSFEN(line)
                        addlabel!(book, kyokumen, label)
                    else
                        kifu = KifuFromSFEN(line)
                        book = merge(book, kifu)
                    end
                catch e
                    println(line)
                    throw(e)
                end
            end
        end
    end
    book
end

function read_sfenss(path::AbstractString)
    book = Book()
    files = readdir(path, join = true)
    for file in files
        _, ext = splitext(file)
        if ext == ".sfens"
            @info "Reading $file"
            b = read_sfens(file)
            book = merge(book, b)
        end
    end
    book
end

function makepdffromsfens(path)
    book = read_sfens(path)
    write_graphviz("$path.gv", book)
    run(`dot -T pdf $path.gv -O`)
    run(`open $path.gv.pdf`)
end

function makepdffromsfenss(path)
    book = read_sfenss(path)
    @info "Writing 定跡.gv"
    write_graphviz("$path/定跡.gv", book)
    @info "Writing 定跡.pdf"
    run(`dot -T pdf $path/定跡.gv -o $path/定跡.pdf`)
    run(`open $path/定跡.pdf`)
end