export csa, BanmenEmptyCSA, BanmenHirateCSA, BanmenFromCSA

const BanmenEmptyCSA = """
P1 *  *  *  *  *  *  *  *  * 
P2 *  *  *  *  *  *  *  *  * 
P3 *  *  *  *  *  *  *  *  * 
P4 *  *  *  *  *  *  *  *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  *  *  * 
P7 *  *  *  *  *  *  *  *  * 
P8 *  *  *  *  *  *  *  *  * 
P9 *  *  *  *  *  *  *  *  * 
"""

const BanmenHirateCSA = """
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  * -KA * 
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  *  *  * 
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
"""

function csa(banmen::Banmen)
    ret = ""
    for j = 1:9
        ret *= "P$j"
        for i = 9:-1:1
            ret *= csa(banmen[i, j])
        end
        ret *= "\n"
    end
    ret
end

function BanmenFromCSA(str::AbstractString)
    banmen = Banmen()
    lines = split(str, "\n")
    for (i, line) in enumerate(lines[1:9])
        line[1] == 'P' || error()
        string(line[2]) == string(i) || error()
        for j = 1:9
            index = 3(j-1)+3:3(j-1)+5
            banmen[10-j, i] = MasuFromCSA(line[index])
        end
    end
    banmen
end