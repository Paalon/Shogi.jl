# Copyright 2021-11-25 Koki Fushimi

module Shogi

export AbstractKifu
export AbstractMetaKifu
export Kifu
export MetaKifu

# Export an enum's all instances
# Thanks to Alex Arslan
"""
    @exportinstances(enum)

Export all instances of the enum.
"""
macro exportinstances(enum)
    eval = GlobalRef(Core, :eval)
    return :($eval($__module__, Expr(:export, map(Symbol, instances($enum))...)))
end

# include("util.jl")
include("sengo.jl")
include("koma.jl")
include("masu.jl")
include("mochigoma.jl")
include("sengomochigoma.jl")
include("banmen.jl")
include("kyokumen.jl")
# include("coding.jl")

"""
    AbstractKifu

棋譜を表す型。
"""
abstract type AbstractKifu end

"""
    AbstractMetaKifu

メタデータ付き棋譜を表す型。
"""
abstract type AbstractMetaKifu <: AbstractKifu end

"""
    Kifu

棋譜を表す型。
"""
mutable struct Kifu <: AbstractKifu
end

"""
    MetaKifu

メタデータ付き棋譜を表す型。
"""
mutable struct MetaKifu <: AbstractMetaKifu
end

# module CSA
# import ..AbstractMetaKifu
# mutable struct CSAKifu <: AbstractMetaKifu
# end
# end # module CSA

# module JKF
# using JSON
# # import ..CSA
# import ..AbstractMetaKifu
# mutable struct JKFKifu <: AbstractMetaKifu
# end
# end # module JKF

# module KI2
# import ..AbstractMetaKifu
# mutable struct KI2Kifu <: AbstractMetaKifu
# end
# end # module KI2

# include("SFEN.jl")
# include("CSA.jl")
# include("JKF.jl")

# using .SFEN, .CSA, .JKF
# export SFEN, CSA, JKF

# @enum KifuFormat kifu_sfen kifu_csa kifu_jkf kifu_ki2 kifu_kif

# const kifu_format_to_module = Dict(
#     kifu_sfen => SFEN,
#     kifu_csa => CSA,
#     kifu_jkf => JKF
# )

# function Sengo(str::AbstractString, f::KifuFormat)
#     kifu_format_to_module[f].Sengo(str)
# end
# Sengo(str::AbstractString, m::Module) = m.Sengo(str)
# Koma(str::AbstractString, m::Module) = m.Koma(str)
# Masu(str::AbstractString, m::Module) = m.Masu(str)
# Banmen(str::AbstractString, m::Module) = m.Banmen(str)
# Kyokumen(str::AbstractString, m::Module) = m.Kyokumen(str)
# SengoFromSFEN(str::AbstractString) = Sengo(str, SFEN)
# export SengoFromSFEN

include("encodedkyokumen.jl")

# # include("jsamotion.jl")
include("move.jl")

# include("attack.jl")

# include("io.jl")

# include("book.jl")
# include("kifu.jl")

# include("sfen/SFEN.jl")
# include("csa/CSA.jl")
# include("kakinoki/kakinoki.jl")

# include("usi.jl")

# include("makeimage.jl")

end