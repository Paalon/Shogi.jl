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

string_cli(sengo::Sengo) = sengo_to_cli[sengo]

# Sengo(str::AbstractString) = sengo_to_cli(str)

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

# Koma(str::AbstractString) = koma_to_cli(str)

string_cli(koma::Koma) = koma_to_cli[koma]

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

# function show(io::IO, mochigoma::Mochigoma)
#     print(io, "持ち駒: $mochigoma")
# end

# function show(io::IO, mochigoma::SengoMochigoma)
#     println(io, "☗持ち駒: $(mochigoma.sente)")
#     println(io, "☖持ち駒: $(mochigoma.gote)")
# end

# function show(io::IO, banmen::Banmen)
#     # print(io, " ９ ８ ７ ６ ５ ４ ３ ２ １\n")
#     for i = 1:9
#         for j = 1:9
#             masu = banmen[10-j, i]
#             print(io, string_original(masu))
#         end
#         n = i |> string |> x -> x[1] |> hankaku_suuji_to_zenkaku_suuji |> string
#         println(io)
#         # print(io, " $n\n")
#     end
# end

# function show(io::IO, kyokumen::Kyokumen)
#     print(io, kyokumen.banmen)
#     println(io, "☗持ち駒: ", string(kyokumen.mochigoma.sente))
#     println(io, "☖持ち駒: ", string(kyokumen.mochigoma.gote))
#     println(io, kyokumen.teban, "番")
# end