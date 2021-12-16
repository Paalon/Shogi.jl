# Copyright 2021-12-06 Koki Fushimi

using Graphs, MetaGraphs

export ShogiGraph
export Book, has_kyokumen, has_move, get_node, add_bud!
export write_graphviz

import Base:
    copy, ==, string, setindex!, getindex, merge, merge!, print

abstract type ShogiGraph end

mutable struct Book <: ShogiGraph
    graph::MetaDiGraph
end

Base.copy(book::Book) = Book(copy(book.graph))
Base.:(==)(a::Book, b::Book) = a.graph == b.graph

function Book(kifu::Kifu)
    Book(kifu.graph)
end

function has_kyokumen(book::Book, kyokumen::Kyokumen)
    vertices = filter_vertices(book.graph, :hexadecimal, encode(kyokumen))
    !isempty(vertices)
end

function has_move(book::Book, kyokumen::Kyokumen, move::AbstractMove)
    kyokumen_next = susumeru(kyokumen, move)
    has_edge(book.graph, encode(kyokumen), encode(kyokumen_next))
end

function get_node(book::Book, kyokumen::Kyokumen)
    v = filter_vertices(book.graph, :hexadecimal, encode(kyokumen))
    if !isempty(v)
        only(v)
    else
        nothing
    end
end

function add_bud!(book::Book, kyokumen::Kyokumen, move::AbstractMove)
    v0 = get_node(book, kyokumen)
    kyokumen_next = susumeru(kyokumen, move)
    if has_kyokumen(book, kyokumen_next)
        # it already has the kyokumen
        if has_move(book, kyokumen, move)
            # do nothing
        else
            # add edge
            v1 = get_node(book, kyokumen_next)
            add_edge!(book.graph, v0, v1, :move, move)
        end
    else
        add_vertex!(book.graph, :hexadecimal, encode(kyokumen_next))
        v1 = get_node(book, kyokumen_next)
        add_edge!(book.graph, v0, v1, :move, move)
    end
    book
end

function print_graphviz_with_label(io::IO, book::Book; labelbase=16)
    for vertex in vertices(book.graph)
        kyokumen_str = get_prop(book.graph, vertex, :hexadecimal)
        lbl = encode(decode(kyokumen_str), base = labelbase)
        print(io, "\"$kyokumen_str\" [label=\"$lbl\"];\n")
    end
    for edge in edges(book.graph)
        kyokumen = decode(get_prop(book.graph, edge.src, :hexadecimal))
        move = get_prop(book.graph, edge, :move)
        move_str = traditional_notation(kyokumen, move)
        from_str = get_prop(book.graph, edge.src, :hexadecimal)
        to_str = get_prop(book.graph, edge.dst, :hexadecimal)
        print(io, "\"$from_str\" -> \"$to_str\"[label=\"$move_str\"];\n")
    end
end

function print_graphviz_no_label(io::IO, book::Book)
    for vertex in vertices(book.graph)
        kyokumen_str = get_prop(book.graph, vertex, :hexadecimal)
        print(io, "\"$kyokumen_str\" [label=\"\"];\n")
    end
    for edge in edges(book.graph)
        kyokumen = decode(get_prop(book.graph, edge.src, :hexadecimal))
        move = get_prop(book.graph, edge, :move)
        move_str = traditional_notation(kyokumen, move)
        sfen_str = sfen(move)
        from_str = get_prop(book.graph, edge.src, :hexadecimal)
        to_str = get_prop(book.graph, edge.dst, :hexadecimal)
        print(io, "\"$from_str\" -> \"$to_str\"[label=\"$move_str\", sfen=\"$sfen_str\"];\n")
    end
end

# mutable struct EncodedShogiGraph
#     graph::MetaDiGraph
# end

# function ShogiGraph(kyokumen::Kyokumen)
#     g = ShogiGraph(MetaDiGraph())
#     add_vertex!(g.graph, Dict(:kyokumen => sfen(kyokumen)))
#     g
# end

function get_vertex(g::ShogiGraph, kyokumen::Kyokumen)
    vertices = filter_vertices(g.graph, :kyokumen, sfen(kyokumen))
    only(collect(vertices))
end

function add_move!(g::ShogiGraph, kyokumen::Kyokumen, move::AbstractMove)
    v = get_vertex(g, kyokumen)
    # move(kyokumen)
    add_vertex!(g.graph, Dict(:kyokumen => sfen(kyokumen)))
    add_edge!(g, kyokumen0, kyokumen1)
end

function Base.merge(books::Book...)
    ret = Book(MetaDiGraph())
    for book in books
        vs = vertices(book.graph)
        es = edges(book.graph)
        for v in vs
            val = get_prop(book.graph, v, :hexadecimal)
            add_vertex!(ret.graph, v, :hexadecimal, val)
        end
        for e in es
            val = get_prop(book.graph, e, :move)
            add_edge!(ret.graph, e, :move, val)
        end
    end
end

function Base.merge!(a::Book, b::Book...) end

function write_graphviz(filename::AbstractString, book::Book)
    open(filename, "w") do f
        print(f, "digraph {\n")
        print(f, "node [fontname=\"Menlo\"]\n")
        print(f, "edge [fontname=\"Menlo\"]\n")
        print_graphviz_no_label(f, book)
        print(f, "}\n")
    end
end

function read_graphviz(filename::AbstractString)
    open(filename, "r") do io
        while !eof(io)
            readline(io)
        end
    end
end