module SFENJosekiScript

book = Book()

macro label(kyokumen::Union{Kyokumen,EncodedKyokumen}, label::AbstractString)
    v = get_vertex(book, kyokumen)
    set_prop!(book.graph, v, :label, label)
end

macro label(str::AbstractString, label::AbstractString)
    
end

macro moves(str::AbstractString)
    
end

end