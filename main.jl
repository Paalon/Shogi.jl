using Shogi

filename = "db.gv"
book = read_graphviz("db.gv")

function makegv()
    write_graphviz(filename, book)
end

function makepdf()
    run(`dot -T pdf $filename -O`)
end

function get