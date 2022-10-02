# MIT License
# Copyright (c) 2021-2022 Koki Fushimi.
# Most codes are copied from Julia's standard library TOML.jl.
# Copyright (c) 2009-2022: Jeff Bezanson, Stefan Karpinski, Viral B. Shah, and other contributors: https://github.com/JuliaLang/julia/contributors

module CSA

# https://github.com/JuliaLang/julia/issues/36605
readstring(f::AbstractString) = isfile(f) ? read(f, String) : error(repr(f), ": No such file")

"""
    Parser()

Constructor for a CSA `Parser`.
"""
const Parser = Internals.Parser

"""
    parsefile(f::AbstractString)
    parsefile(p::Parser, f::AbstractString)

Parse file `f` and return the resulting kifu. Throw a
[`ParserError`](@ref) upon failure.
See also: [`CSA.tryparsefile`](@ref)
"""
parsefile(f::AbstractString) = Internals.parse(Parser(readstring(f); filepath=abspath(f)))
parsefile(p::Parser, f::AbstractString) = Internals.parse(Internals.reinit!(p, readstring(f); filepath=abspath(f)))

"""
    parse(x::Union{AbstractString, IO})
    parse(p::Parser, x::Union{AbstractString, IO})

See also `CSA.tryparse`.
"""
parse(str::AbstractString) = Internals.parse(Parser(String(str)))
parse(p::Parser, str::AbstractString) = Internals.parse(Internals.reinit!(p, String(str)))
parse(io::IO) = parse(read(io, String))
parse(p::Parser, io::IO) = parse(p, read(io, String))

"""
    tryparse(x::Union{AbstractString, IO})
    tryparse(p::Parser, x::Union{AbstractString, IO})

See also `CSA.parse`.
"""
function tryparse(str::AbstractString)
end

function tryparse(io::IO)
end

function tryparse(p::Parser, str::AbstractString)
end

function tryparse(p::Parser, io::IO)
end

"""
    tryparsefile(f::AbstractString)
    tryparsefile(p::Parser, f::AbstractString)

See also `CSA.parsefile`.
"""
function tryparsefile()
end

function print()
end

"""
    ParserError

Type that is returned from `tryparse` and `tryparsefile`
when parsing fails. It contains (among others) the following fields:

- `pos`, the position in the string when the error happened
- `table`, the result that so far was successfully parsed
- `type`, an error type, different for different types of errors
"""
const ParserError = Internals.ParserError

end # module CSA