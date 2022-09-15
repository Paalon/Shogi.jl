export makepdffromsfens

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
                        best, weight, line = split(line, " ", limit = 3)
                        kifu = KifuFromSFEN(line; weight = parse(Float64, weight))
                        book = merge(book, kifu)
                    elseif line[1] == 'l'
                        _, label = split(line, " ", limit = 2)
                        # label = replace(label, "nl" => "\n")
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

function read_sfens(filenames::AbstractArray{<:AbstractString})
    book = Book()
    for filename in filenames
        book = merge(book, read_sfens(filename))
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

function makepdffromsfens(path::AbstractString)
    book = read_sfens(path)
    write_graphviz("$path.gv", book)
    run(`dot -T pdf $path.gv -O`)
    run(`open $path.gv.pdf`)
end

function makepdffromsfens(paths::AbstractArray{<:AbstractString}, outputname::AbstractString)
    book = read_sfens(paths)
    write_graphviz("$outputname.gv", book)
    run(`dot -T pdf $outputname.gv -O`)
    run(`open $outputname.gv.pdf`)
end