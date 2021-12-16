push!(LOAD_PATH, pwd())
using JosekiManager

txttopdf("kifu.txt")

kifus = """
startpos moves 2g2f 8c8d 2f2e 8d8e 6i7h 4a3b 7g7f 3c3d
startpos moves 7g7f 3c3d 2g2f 8c8d 2f2e 8d8e 2e2d 2c2d 2h2d 4a3b 6i7h 8e8f 8g8f 8b8f
startpos moves 7g7f 3c3d 2g2f 8c8d 2f2e 8d8e 6i7h 4a3b 2e2d 2c2d 2h2d 8e8f 8g8f 8b8f
startpos moves 7g7f 8c8d 2g2f 3c3d
startpos moves 7g7f 3c3d 2g2f 8c8d 2f2e 8d8e 2e2d 2c2d 2h2d 4a3b 6i7h 8e8f 8g8f 8b8f 2d3d
sfen lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p 16 moves 2b8h+ 7i8h
sfen lnsgk1snl/6g2/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1SG6/LN2KGSNL w B3Pb2p 18 moves 8f7f
sfen lnsgk1snl/6g2/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1SG6/LN2KGSNL w B3Pb2p 18 moves P*2h 3i2h B*4e 3d2d P*2c B*7g 8f8h+ 7g8h 2c2d 8h1a+ S*8g 1a7g 8g7f 7g6h P*8h R*4f 8h8i+ 4f4e 8i9i L*3d
sfen lnsgk1sn1/6g2/p1pppp2p/6Lp1/5R3/2s6/P2PPPP1P/2G+B3S1/+p3KG1NL w B4Prnl 38 moves 2a3c 4e3e 3a4b
"""

kifu_array = split(kifus, "\n")
df = JosekiManager.NullDataFrame()
for kifu in kifu_array
    if kifu != ""
        df = vcat(df, kifu_df(kifu))
    end
end

history, moves = kifu_splat("startpos moves 2g2f 8c8d 2f2e 8d8e 6i7h 4a3b 7g7f 3c3d")

df = make_dataframe_from_usi_positions(usi_positions)

# df = merge_database(df, load_database("database.feather"))

try
    save_database("database.feather", df)
    write_graphviz("database.gv", df)
    run(`dot -T pdf database.gv -O`)
    run(`open database.gv.pdf`)
catch e
    throw(e)
end

