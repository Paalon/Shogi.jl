export csa, KyokumenFromCSA, KyokumenHirateCSA

const KyokumenHirateCSA = """
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  * -KA * 
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  *  *  * 
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
+
"""

function csa(kyokumen::Kyokumen)
    ret = ""
    ret *= csa(kyokumen.banmen)
    if !isempty(kyokumen.mochigoma.sente)
        ret *= "P+"
        ret *= csa(kyokumen.mochigoma.sente)
        ret *= "\n"
    end
    if !isempty(kyokumen.mochigoma.gote)
        ret *= "P-"
        ret *= csa(kyokumen.mochigoma.gote)
        ret *= "\n"
    end
    ret *= csa(kyokumen.teban)
    ret *= "\n"
end

function KyokumenFromCSA(str::AbstractString)
    kyokumen = Kyokumen()
    lines = split(str, "\n")
    for line in lines
        if length(line) ≥ 2 && line[1:2] == "PI"
            # 2.5 (1)
            kyokumen.banmen = BanmenHirate()
            n = length(line) - 2
            if n > 0
                komaochi_str = lines[3:end]
                komaochi_n = Int(n / 4)
                for i = 1:komaochi_n
                    komaochi = komaochi_str[4(i-1)+1:4(i-1)+1+4]
                    x = parse(Int, komaochi[1])
                    y = parse(Int, komaochi[2])
                    koma = KomaFromCSA(komaochi[3:4])
                    masu = kyokumen[x, y]
                    Koma(masu) == koma || error("Does not match between the specified masu and koma.")
                    kyokumen[x, y] == 〼
                end
            end
        elseif length(line) ≥ 2
            line[1] == 'P' && isdigit(line[2]) && line[2] ≠ '0'
            # 2.5 (2)
            n = parse(Int, line[2])
            str = line[3:end]
            for i = 1:9
                masu = MasuFromCSA(str[3i-2:3i])
                kyokumen[10-i, n] = masu
            end
        elseif length(line) ≥ 2 && line[1] == 'P' && (line[2] == '+' || line[2] == '-')
            n = length(line) - 2
            sengo = SengoFromCSA(line[2])
            if n > 0
                str = line[3:end]
                k = length(str)
                koma_n = Int(k / 4)
                for i = 1:koma_n
                    s = str[4i-3:4i]
                    x, y = parse(Int, s[1]), parse(Int, s[2])
                    if s[3, 4] == "AL"
                        # add 残り without OU
                        x = remaining_koma_omote(kyokumen)
                        if issente(sengo)
                            kyokumen.mochigoma.sente.matrix[2:8] += x[2:8]
                        else
                            kyokumen.mochigoma.gote.matrix[2:8] += x[2:8]
                        end
                    else
                        koma = KomaFromCSA(s[3, 4])
                        if x == 0 && y == 0
                            if issente(sengo)
                                kyokumen.mochigoma.sente[koma] += 1
                            else
                                kyokumen.mochigoma.gote[koma] += 1
                            end
                        else
                            kyokumen[x, y] = Masu(koma, sengo)
                        end
                    end
                end
            end
        elseif length(line) == 1 && (line[1] == '+' || line[1] == '-')
            kyokumen.teban = SengoFromCSA(string(line[1]))
        end
    end
    kyokumen
end