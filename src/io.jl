export string_cli
export Sengo
export Koma
export Masu

using Bijections
import Base: string, show

const sengo_to_cli = Bijection(Dict(
    先手 => "+",
    後手 => "-",
))

const sengo_to_gui = Bijection(Dict(
    先手 => "☗",
    後手 => "☖",
))

string_cli(sengo::Sengo) = sengo_to_cli[sengo]
string_gui(sengo::Sengo) = sengo_to_gui[sengo]

# Sengo(str::AbstractString) = sengo_to_cli(str)

function string_gui(xy::Tuple{Integer, Integer})
    x, y = xy
    x_char = int_to_zenkaku[x]
    y_char = int_to_zenkaku[y]
    "$x_char$y_char"
end

const koma_to_cli = Bijection(Dict(
    歩兵 => "歩",
    香車 => "香",
    桂馬 => "桂",
    銀将 => "銀",
    金将 => "金",
    角行 => "角",
    飛車 => "飛",
    玉将 => "玉",
    と金 => "と",
    成香 => "杏",
    成桂 => "圭",
    成銀 => "全",
    竜馬 => "馬",
    竜王 => "竜",
))

const koma_to_gui = Bijection(Dict(
    歩兵 => "歩",
    香車 => "香",
    桂馬 => "桂",
    銀将 => "銀",
    金将 => "金",
    角行 => "角",
    飛車 => "飛",
    玉将 => "玉",
    と金 => "と",
    成香 => "成香",
    成桂 => "成桂",
    成銀 => "成銀",
    竜馬 => "馬",
    竜王 => "竜",
))

# Koma(str::AbstractString) = koma_to_cli(str)

string_cli(koma::Koma) = koma_to_cli[koma]
string_gui(koma::Koma) = koma_to_gui[koma]

function _masu_to_cli(masu::Masu)
    if isempty(masu)
        " ・"
    else
        sengo = Sengo(masu) |> string_cli
        koma = Koma(masu) |> string_cli
        "$sengo$koma"
    end
end

const masu_to_cli = let
    ret = Dict()
    for masu in instances(Masu)
        ret[masu] = _masu_to_cli(masu)
    end
    ret
end |> Bijection

string_cli(masu::Masu) = masu_to_cli[masu]

# # Masu(str::AbstractString) = masu_to_original(str)

function string(mochigoma::Mochigoma)
    ret = ""
    for (i, n) in enumerate(mochigoma.komasuus)
        if n == 0
        elseif n == 1
            ret *= string_cli(KomaFromMochigomaIndex(i))
        else
            ret *= string_cli(KomaFromMochigomaIndex(i))
            n_str = n |> string
            for n_char in n_str
                ret *= hankaku_suuji_to_zenkaku_suuji[n_char] |> string
            end
        end
    end
    if ret == ""
        ret = "なし"
    end
    ret
end

function show(io::IO, mochigoma::Mochigoma)
    print(io, "持ち駒: $(string(mochigoma))")
end

function show(io::IO, mochigoma::SengoMochigoma)
    println(io, "☗$(mochigoma.sente)")
    print(io, "☖$(mochigoma.gote)")
end

function show(io::IO, banmen::Banmen)
    # if index
    #     print(io, " ９ ８ ７ ６ ５ ４ ３ ２ １\n")
    # end
    for i = 1:9
        for j = 1:9
            masu = banmen[10-j, i]
            print(io, string_cli(masu))
        end
        # if index
        #     print(io, string(int_to_zenkaku[i]))
        # end
        println(io)
    end
end

function show(io::IO, kyokumen::Kyokumen)
    show(io, kyokumen.banmen)
    println(io, kyokumen.mochigoma)
    println(io, kyokumen.teban, "番")
end

# struct Move
#     from::Tuple{Integer,Integer}
#     to::Tuple{Integer,Integer}
#     from_koma::Koma
#     to_koma::Koma
#     sengo::Sengo
# end

# function get_move_name(k0::Kyokumen, k1::Kyokumen)
#     next(k0.teban) == k1.teban || error("手番が入れ替わっていない。")
#     sengo = k0.teban
#     getmochigoma(k0, next(sengo)) == getmochigoma(k1, next(sengo)) || error("相手の持ち駒が変化している。")
#     bitbanmen = bitdiff(k0.banmen, k1.banmen)
#     bitbanmen_size = sum(bitbanmen)
#     if bitbanmen_size == 0
#         error("盤面に変化がない。")
#     elseif bitbanmen_size == 1
#         # 打つ手
#         m0 = getmochigoma(k0, sengo)
#         m1 = getmochigoma(k1, sengo)
#         dm = distance(m0, m1)
#         dm == 1 || error("盤面の変化が１なのに駒を打っていません。")
#         koma = m0.komasuus - m1.komasuus
#         for i = 1:9, j = 1:9
#             if bit_banmen[i, j]
#                 k0[i, j] == 〼 || error("from masu が埋まっている。")
#                 isomote(k1[i, j]) || error("to masu が表でない。")
#                 koma = Koma(k1[i, j])
#                 m0[koma] - 1 == m1[koma] || error("持ち駒が打たれていない。")
#                 return Move((0, 0), (1, 1), koma, koma, sengo)
#             end
#         end
#     elseif bitbanmen_size == 2
#         # 盤上の手
#         indices = []
#         for i = 1:9, j = 1:9
#             if bitbanmen[i, j]
#                 push!(indices, (i, j))
#             end
#         end
#         m0 = getmochigoma(k0, sengo)
#         m1 = getmochigoma(k1, sengo)
#         dm = distance(m0, m1)
#         if dm == 0
#             # 駒を取っていない
#             x = indices[1]
#             y = indices[2]
#             m0x = k0[x...]
#             m0y = k0[y...]
#             m1x = k1[x...]
#             m1y = k1[y...]
#             # 駒をとっていないから、m0x と m0y の片方は 〼 かつ m1x と m1y の片方は 〼
#             ((m0x == 〼 ⊻ m0y == 〼) && (m1x == 〼 ⊻ m1y == 〼)) || error("駒を取らない移動になっていない。")
#             # m0x が 〼 => m1y が 〼 かつ m0y が 〼 => m1x が 〼
#             if m0x == 〼
#                 m1y == 〼
#             else
#                 true
#             end && if m0y == 〼
#                 m1y == 〼
#             else
#                 true
#             end || error("駒を取らない移動になっていない。")
#             x0, x1 = if m0x == 〼 && m1y == 〼
#                 x, y
#             else
#                 y, x
#             end
#             k0x0 = k0[x0...]
#             k1x1 = k1[x1...]
#             if k0x0 == k1x1
#                 # 不成
#                 koma = Koma(k0x0)
#                 Move(x0, x1, koma, koma, sengo)
#             elseif naru(k0x0) == k1x1
#                 # 成
#                 koma = Koma(k0x0)
#                 Move(x0, x1, koma, naru(koma), sengo)
#             else
#                 # おかしい
#                 error("移動中に関係ない駒になっている。")
#             end
#         elseif dm == 1
#             # 駒を取っている
#             x = indices[1]
#             y = indices[2]
#             m0x = k0[x...]
#             m0y = k0[y...]
#             m1x = k1[x...]
#             m1y = k1[y...]
#             # 駒を取っているから、m0x と m0y の両方は 〼 でない かつ m1x と m1y の片方は 〼
#             ((m0x ≠ 〼 && m0y ≠ 〼) && (m1x == 〼 ⊻ m1y == 〼)) || error("駒を取る移動になっていない。")
#             x0, x1 = if m1x == 〼
#                 y, x
#             else
#                 x, y
#             end
#             k0x0 = k0[x0...]
#             k0x1 = k0[x1...]
#             k1x1 = k1[x1...]
#             (Sengo(k0x0) == sengo && Sengo(k1x1) == sengo) && Sengo(k0x1) == next(sengo) || error("駒を取る移動になっていない。")
#             if k0x0 == k1x1
#                 # 不成
#                 koma = Koma(k0x0)
#                 Move(x0, x1, koma, koma, sengo)
#             elseif naru(k0x0) == k1x1
#                 # 成
#                 koma = Koma(k0x0)
#                 Move(x0, x1, koma, naru(koma), sengo)
#             else
#                 # おかしい
#                 error("移動中に関係ない駒になっている。")
#             end
#         else
#             error("持ち駒が２枚以上１手で増えている。")
#         end
#     else
#         error("Not adjacent kyokumens.")
#     end
# end