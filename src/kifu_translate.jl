# 棋譜形式
# 到達地点の筋, 到達地点の段, 駒の種類, 駒の相対位置, 駒の動作, 成・不成・打
# 駒の相対位置: 右・左
# 駒の動作: 上・寄・引

# 筋・段・駒は書くが、
# １手前と同じ筋・段の場合、同と書く。
# 成ることが可能な場合、成・不成を書く。


function issame(kifu::Kifu, move::AbstractMove)

end

function 棋譜()
    for move in moves
        str *= sengo
        if issame(kifu, move)
            str *= "同"
        else
            str *= suji |> zenkaku
            str *= dan |> zenkaku
        end
        str *= koma

    end
end

function jkf() end

function kif() end

function ki2() end

function csa() end

function sfen() end