# Copyright 2021-12-06 Koki Fushimi

using Graphs, MetaGraphs

export ShogiGraph
export Book
export haskyokumen
export addkyokumen!
export rmkyokumen!
export getkyokumen
export hasmove
export addmove!
export addlabel!
export write_graphviz
export read_graphviz

import Base:
    copy, ==, string, setindex!, getindex, merge, merge!, print

abstract type ShogiGraph end

mutable struct Book <: ShogiGraph
    graph::MetaDiGraph
end

Base.copy(book::Book) = Book(copy(book.graph))

function ==(a::Book, b::Book)
    avs = []
    bvs = []
    for v in vertices(a.graph)
        ek = get_prop(a.graph, v, :kyokumen)
        push!(avs, ek)
    end
    for v in vertices(b.graph)
        ek = get_prop(b.graph, v, :kyokumen)
        push!(bvs, ek)
    end
    aes = []
    bes = []
    for e in edges(a.graph)
        em = get_prop(a.graph, e, :move)
        push!(aes, em)
    end
    for e in edges(b.graph)
        em = get_prop(b.graph, e, :move)
        push!(bes, em)
    end
    Set(avs) == Set(bvs) && Set(aes) == Set(bes)
end

function Book()
    Book(MetaDiGraph())
end

# function Book(kifu::Kifu)
#     Book(kifu.graph)
# end

function haskyokumen(book::Book, ek::EncodedKyokumen)
    vertices = filter_vertices(book.graph, :kyokumen, ek)
    !isempty(vertices)
end

function haskyokumen(book::Book, kyokumen::Kyokumen)
    ek = EncodedKyokumen(kyokumen)
    haskyokumen(book, ek)
end

function addkyokumen!(book::Book, ek::EncodedKyokumen)
    vs = filter_vertices(book.graph, :kyokumen, ek)
    if isempty(vs)
        add_vertex!(book.graph, :kyokumen, ek)
        book
    else
        book
    end
end

function addkyokumen!(book::Book, kyokumen::Kyokumen)
    ek = EncodedKyokumen(kyokumen)
    addkyokumen!(book, ek)
end

function getkyokumen(book::Book, v)
    Kyokumen(get_prop(book.graph, v, :kyokumen))
end

function rmkyokumen!(book::Book, v)
    rem_vertex!(book.graph, v)
end

function get_vertex(book::Book, ek::EncodedKyokumen)
    vs = filter_vertices(book.graph, :kyokumen, ek)
    only(vs)
end

function get_vertex(book::Book, kyokumen::Kyokumen)
    ek = EncodedKyokumen(kyokumen)
    get_vertex(book, ek)
end

function hasmove(book::Book, move::EncodedMove)
    v0 = get_vertex(book, gettail(move))
    v1 = get_vertex(book, gethead(move))
    has_edge(book.graph, v0, v1)
end

function addmove!(book::Book, move::EncodedMove; weight=1.0)
    tail = gettail(move)
    head = gethead(move)
    t = filter_vertices(book.graph, :kyokumen, tail)
    h = filter_vertices(book.graph, :kyokumen, head)
    if isempty(t)
        add_vertex!(book.graph, :kyokumen, tail)
    end
    if isempty(h)
        add_vertex!(book.graph, :kyokumen, head)
    end
    v0 = get_vertex(book, tail)
    v1 = get_vertex(book, head)
    if !has_edge(book.graph, v0, v1)
        add_edge!(book.graph, v0, v1, :move, move)
        set_prop!(book.graph, v0, v1, :weight, weight)
    end
    book
end

function addlabel!(book::Book, kyokumen::Union{Kyokumen,EncodedKyokumen}, label::AbstractString)
    v = get_vertex(book, kyokumen)
    set_prop!(book.graph, v, :label, label)
    book
end

function print_graphviz(io::IO, book::Book)
    for v in vertices(book.graph)
        ek = get_prop(book.graph, v, :kyokumen)
        ek_str = string(ek)
        label = if has_prop(book.graph, v, :label)
            val = get_prop(book.graph, v, :label)
            "$val\n$v"
        else
            "$v"
        end
        print(io, "\"$ek_str\" [label=\"$label\"];\n")
    end
    for e in edges(book.graph)
        move = get_prop(book.graph, e, :move)
        weight = get_prop(book.graph, e, :weight)
        weight_str = string(weight)
        ek0 = gettail(move)
        ek1 = gethead(move)
        ek0_str = string(ek0)
        ek1_str = string(ek1)
        try
            move_str = getname(move)
            print(io, "\"$ek0_str\" -> \"$ek1_str\" [label=\"$move_str\", penwidth=\"$weight_str\"];\n")
        catch err
            k0 = Kyokumen(ek0)
            k1 = Kyokumen(ek1)
            println(k0)
            println(k1)
            throw(err)
        end
    end
end

# function print_graphviz_no_label(io::IO, book::Book)
#     for vertex in vertices(book.graph)
#         kyokumen_str = get_prop(book.graph, vertex, :hexadecimal)
#         print(io, "\"$kyokumen_str\" [label=\"\"];\n")
#     end
#     for edge in edges(book.graph)
#         kyokumen = decode(get_prop(book.graph, edge.src, :hexadecimal))
#         move = get_prop(book.graph, edge, :move)
#         move_str = traditional_notation(kyokumen, move)
#         sfen_str = sfen(move)
#         from_str = get_prop(book.graph, edge.src, :hexadecimal)
#         to_str = get_prop(book.graph, edge.dst, :hexadecimal)
#         print(io, "\"$from_str\" -> \"$to_str\"[label=\"$move_str\", sfen=\"$sfen_str\"];\n")
#     end
# end

# mutable struct EncodedShogiGraph
#     graph::MetaDiGraph
# end

# function ShogiGraph(kyokumen::Kyokumen)
#     g = ShogiGraph(MetaDiGraph())
#     add_vertex!(g.graph, Dict(:kyokumen => sfen(kyokumen)))
#     g
# end

# function get_vertex(g::ShogiGraph, kyokumen::Kyokumen)
#     vertices = filter_vertices(g.graph, :kyokumen, sfen(kyokumen))
#     only(collect(vertices))
# end

# function add_move!(g::ShogiGraph, kyokumen::Kyokumen, move::AbstractMove)
#     v = get_vertex(g, kyokumen)
#     # move(kyokumen)
#     add_vertex!(g.graph, Dict(:kyokumen => sfen(kyokumen)))
#     add_edge!(g, kyokumen0, kyokumen1)
# end

function Base.merge(books::Book...)
    ret = Book()
    for book in books
        vs = vertices(book.graph)
        es = edges(book.graph)
        for v in vs
            kyokumen = get_prop(book.graph, v, :kyokumen)
            addkyokumen!(ret, kyokumen)
            if has_prop(book.graph, v, :label)
                label = get_prop(book.graph, v, :label)
                addlabel!(ret, kyokumen, label)
            end
        end
        for e in es
            move = get_prop(book.graph, e, :move)
            weight = get_prop(book.graph, e, :weight)
            addmove!(ret, move; weight=weight)
        end
    end
    ret
end

# function Base.merge!(a::Book, b::Book...) end

function write_graphviz(filename::AbstractString, book::Book)
    open(filename, "w") do io
        print(io, "digraph {\n")
        print(io, "node [fontname=\"Verdana\"]\n")
        print(io, "edge [fontname=\"Verdana\"]\n")
        print_graphviz(io, book)
        print(io, "}\n")
    end
end

function read_graphviz(filename::AbstractString)
    book = Book()
    open(filename, "r") do io
        while !eof(io)
            line = readline(io)
            if length(line) > 0
                if line[1] == '"'
                    if length(line) == 78 && line[68] == '['
                        kyokumen_str = line[2:65]
                        ek = EncodedKyokumen(kyokumen_str)
                        addkyokumen!(book, ek)
                    elseif length(line) ≥ 137 && line[68] == '-'
                        str0 = line[2:65]
                        str1 = line[72:135]
                        ek0 = EncodedKyokumen(str0)
                        ek1 = EncodedKyokumen(str1)
                        em = EncodedMove(ek0, ek1)
                        addmove!(book, em)
                    end
                end
            end
        end
    end
    book
end