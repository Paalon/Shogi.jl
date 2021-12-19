export KifuFromCSA

function KifuFromCSA(filename::AbstractString)
    kyokumen = Kyokumen()
    moves = CSAMove[]
    open(filename, "r") do io
        while !eof(io)
            str = readline(io)
            if length(str) ≥ 1
                char = str[1]
                if char == '''
                elseif char == 'V'
                elseif char == 'N'
                    # @info "対局者情報は読み飛ばされます。"
                elseif char == '$'
                    # @info "各種棋譜情報は読み飛ばされます。"
                elseif char == '%'
                    if str == "%TORYO"
                    end
                elseif char == '+'
                    if length(str) == 1
                        kyokumen.teban == 先手
                    else
                        push!(moves, CSAMove(str))
                    end
                elseif char == '-'
                    if length(str) == 1
                        kyokumen.teban == 後手
                    else
                        push!(moves, CSAMove(str))
                    end
                elseif char == 'T'
                elseif char == 'P'
                    n = parse(Int, str[2])
                    for k = 1:9
                        kyokumen[10-k, n] = MasuFromCSA(str[3k:3k+2])
                    end
                end
            end
        end
    end
    Kifu(kyokumen, moves)
end