using Test

using Shogi

include("sengo.jl")
include("koma.jl")
include("masu.jl")
include("mochigoma.jl")
# include("sengomochigoma.jl")
include("banmen.jl")
include("kyokumen.jl")

include("io.jl")

# SFEN for test

# const kyokumen_sfen_strings = [
#     "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
#     "lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p 2"
#     "lnsgk1snl/6g2/p1pppp2p/6R2/5b3/1rP6/P2PPPP1P/1SG4S1/LN2KG1NL b B4Pp 1"
#     "lnsgk1sn+B/6g2/p1pppp2p/7p1/5b3/2P6/P2PPPP1P/2G4S1/LN2KG1NL w RL4Prs 2"
#     "8l/1l+R2P3/p2pBG1pp/kps1p4/Nn1P2G2/P1P1P2PP/1PS6/1KSG3+r1/LN2+p3L w Sbgn3p 2"
# ]



# include("sfenkyokumen.jl")
# include("move.jl")
# include("coding.jl")
# include("graph.jl")

include("sfen.jl")
include("csa.jl")

# Kifu
# @test sfen(Kifu()) == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
# @test sfen(Kifu("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 2g2f 8c8d")) == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 2g2f 8c8d"

# open("../kifu.txt", "r") do io
#     while !eof(io)
#         str = readline(io)
#         kifu = KifuFromSFEN(str)
#         book = Book(kifu)
#     end
# end 
# str = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2g2f 8c8d 2f2e 8d8e 6i7h 4a3b 7g7f 3c3d 2e2d 2c2d 2h2d 8e8f 8g8f 8b8f 2d3d 2b8h+ 7i8h P*2h 3i2h B*4e 3d2d P*2c B*7g 8f8h+ 7g8h 2c2d 8h1a+"
# kifu = KifuFromSFEN(str)
# book = Book(kifu)
# write_graphviz(book)