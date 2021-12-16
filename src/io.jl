export string_original
export Sengo
export Koma
export Masu

using Bijections
import Base: string, show

const sengo_to_original = Bijection(Dict(
    先手 => "+",
    後手 => "-",
))

const koma_to_original = Bijection(Dict(
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

string_original(sengo::Sengo) = sengo_to_original[sengo]

string_original(koma::Koma) = koma_to_original[koma]

string_original(masu::Masu) = masu_to_original[masu]

function _masu_to_original(masu::Masu)
    if isempty(masu)
        " ・"
    else
        sengo = Sengo(masu) |> string_original
        koma = Koma(masu) |> string_original
        "$sengo$koma"
    end
end

const masu_to_original = let
    ret = Dict()
    for masu in instances(Masu)
        ret[masu] = _masu_to_original(masu)
    end
    ret
end |> Bijection

Sengo(str::AbstractString) = sengo_to_original(str)
Koma(str::AbstractString) = koma_to_original(str)
Masu(str::AbstractString) = masu_to_original(str)

function string(mochigoma::Mochigoma)
    ret = ""
    for (i, n) in enumerate(mochigoma.komasuus)
        if n == 0
        elseif n == 1
            ret *= string(KomaFromMochigomaIndex(i); style = :ichiji)
        else
            ret *= string(KomaFromMochigomaIndex(i); style = :ichiji)
            n_str = n |> string
            for n_char in n_str
                ret *= n_char |> hankaku_suuji_to_zenkaku_suuji |> string
            end
        end
    end
    if ret == ""
        ret = "なし"
    end
    ret
end

function show(io::IO, mochigoma::Mochigoma)
    print(io, "持ち駒: $mochigoma")
end

function show(io::IO, banmen::Banmen)
    # print(io, " ９ ８ ７ ６ ５ ４ ３ ２ １\n")
    for i = 1:9
        for j = 1:9
            masu = banmen[10-j, i]
            print(io, string_original(masu))
        end
        n = i |> string |> x -> x[1] |> hankaku_suuji_to_zenkaku_suuji |> string
        println(io)
        # print(io, " $n\n")
    end
end

function show(io::IO, kyokumen::Kyokumen)
    print(io, kyokumen.banmen)
    println(io, "☗持ち駒: ", string(kyokumen.mochigoma.sente))
    println(io, "☖持ち駒: ", string(kyokumen.mochigoma.gote))
    println(io, kyokumen.teban, "番")
end