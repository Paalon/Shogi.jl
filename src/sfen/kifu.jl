export KifuFromSFEN

function KifuFromSFEN(str::AbstractString)
    args = split(str, " ", limit=2)
    if args[1] == "position" && length(args) == 2
        # "position <args>".
        args = split(args[2], " ", limit = 2)
        if args[1] == "sfen" && length(args) == 2
            # "position sfen <args>"
            args = split(args[2], " ", limit=6)
            if length(args) == 4
                # "position sfen <sfen-string>"
                sfen_str = join(args[1:3], " ")
                kyokumen = KyokumenFromSFEN(sfen_str)
                Kifu(kyokumen)
            elseif length(args) ≥ 6 && args[5] == "moves"
                # "position sfen <sfen-string> moves <move-strings>"
                sfen_str = join(args[1:3], " ")
                moves_str = args[6]
                kyokumen = KyokumenFromSFEN(sfen_str)
                moves = SFENMoves(moves_str)
                Kifu(kyokumen, moves)
            else
                error("Does not match to `position sfen <sfenstring> (moves <move-strings>)`. $str")
            end
        elseif args[1] == "startpos"
            # "position startpos (<args>)"
            kyokumen = KyokumenHirate()
            if length(args) == 1
                # "position startpos"
                Kifu(kyokumen)
            else
                # "position startpos <args>"
                args = split(args[2], " ", limit=2)
                if args[1] == "moves"
                    # "position startpos moves <args>"
                    moves_str = args[2]
                    moves = SFENMoves(moves_str)
                    Kifu(kyokumen, moves)
                else
                    error("Does not match to `position startpos (moves <move-strings>)`. $str")
                end
            end
        else
            error("Does not match to `position [sfen <sfenstring> | startpos]`. $str")
        end
    else
        error("Does not satisfy `position <args>` format. $str")
    end
end