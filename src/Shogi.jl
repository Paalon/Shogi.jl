# Copyright 2021-11-25 Koki Fushimi

module Shogi

include("util.jl")
include("sengo.jl")
include("koma.jl")
include("masu.jl")
include("mochigoma.jl")
include("sengomochigoma.jl")
include("banmen.jl")
include("kyokumen.jl")
include("coding.jl")
# include("jsamotion.jl")
include("move.jl")

include("attack.jl")
# include("kifu.jl")
# include("book.jl")

include("io.jl")

include("sfen/sfen.jl")
include("csa/csa.jl")
include("kakinoki/kakinoki.jl")

end