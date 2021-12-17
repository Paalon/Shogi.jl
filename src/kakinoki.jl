# http://kakinoki.o.oo7.jp/kif_format.html

export kakinoki
export SengoFromKakinoki
export KomaFromKakinoki

const sengo_to_kakinoki = Bijection(Dict(
    先手 => "▲",
    後手 => "△",
))

function kakinoki(sengo::Sengo)
    sengo_to_kakinoki[sengo]
end

function SengoFromKakinoki(str::AbstractString)
    sengo_to_kakinoki(str)
end

const koma_to_kakinoki = Bijection(Dict(
    玉将 => "玉",
    飛車 => "飛",
    竜王 => "龍",
    角行 => "角",
    竜馬 => "馬",
    金将 => "金",
    銀将 => "銀",
    成銀 => "成銀",
    桂馬 => "桂",
    成桂 => "成桂",
    香車 => "香",
    成香 => "成香",
    歩兵 => "歩",
    と金 => "と",
))

function kakinoki(koma::Koma)
    koma_to_kakinoki[koma]
end

function KomaFromKakinoki(str::AbstractString)
    koma_to_kakinoki(str)
end

"""
    KifuFromKakinoki(str::AbstractString)

Construct a kifu from a kakinoki KIF format string.
"""
function KifuFromKakinoki(str::AbstractString)

end

# return dict to construct move
# return nothing if it is end of kifu.
# throw error otherwise
function parse_kakinoki_sashite(str::AbstractString)
    ret = Dict(
        :from => missing,
        :to => missing,
        :same => missing,
        :drop => missing,
        :promote => missing,
        :from_koma => missing,
        :to_koma => missing,
    )
    if str == "中断"
    elseif str == "投了"
    elseif str == "持将棋"
    elseif str == "千日手"
    elseif str == "詰み"
    elseif str == "切れ負け"
    elseif str == "反則勝ち"
    elseif str == "反則負け"
    elseif str == "入玉勝ち"
    elseif str == "不戦勝"
    elseif str == "不戦敗"
    elseif length(str) > 0
        valstate = iterate(str)
        char, state = valstate
        x_char, state = valstate
        y_char, state = iterate(str, state)
        if x_char == '同' && y_char == '　'
            ret[:same] = true
            char, state = iterate(str, state)
        else
            ret[:same] = false
            ret[:to] = int_to_zenkaku(x_char), int_to_kansuuji(y_char)
        end
        char1, state = iterate(str, state)
        koma_str = if char1 == '成'
            char2, state = iterate(str, state)
            "$char1$char2"
        else
            string(char1)
        end
        koma = KomaFromKakinoki(koma_str)
        ret[:from_koma] = koma
        char, state = iterate(str, state)
        if char == '成'
            ret[:promote] = true
            ret[:drop] = false
            ret[:to_koma] = naru(koma)
            char, state = iterate(str, state)
            if char == '('
                # ok
            else
                error("$str")
            end
        elseif char == '打'
            ret[:promote] = false
            ret[:drop] = true
            ret[:to_koma] = koma
            valstate = iterate(str, state)
            if isnothing(valstate)
                return ret
            else
                error("$str")
            end
        elseif char == '('
            ret[:promote] = false
            ret[:drop] = false
            ret[:to_koma] = koma
        else
            error()
        end
        x_char, state = iterate(str, state)
        y_char, state = iterate(str, state)
        ret[:from] = int_to_hankaku(x_char), int_to_hankaku(y_char)
        char, state = iterate(str, state)
        if char == ')'
            # ok
        else
            error("$str")
        end
        ret
    else
        error("$str")
    end
end

# function KifuFromKakinoki(io::IO)
#     kifu = Kifu()
#     while !eof(io)
#         line = readline(io)
#         if length(line) > 0
#             if line[1] == '#'
#                 # comment
#             elseif isdigit(line[1])
#                 # move
#                 tesuu, sashite, shyouhijikan = split(line, " ")
#                 dict = parse_kakinoki_sashite(sashite)
#                 if isnothing(dict)
#                     return kifu
#                 else
#                     # add node to kifu
#                 end
#             else
#                 # others
#             end
#         end
#     end
#     kifu
# end

# # <指し手>={<手番>}<to><koma>{<decorator>}<from>
# # <to>=<x><y>|"同　"

# function x_kakinoki()
# function coordinate_kif(x::Integer, y::Integer)
#     int_to_zenkaku(x), int_to_kansuuji(y)
# end

# function coordinate_kif()
# end

# function coordinate_sfen(x::Integer, y::Integer)
# end

# function next!_from_kakinoki(kyokumen::Kyokumen, str::AbstractString)
#     if str == "中断"
#     elseif str == "投了"
#     elseif str == "持将棋"
#     elseif str == "千日手"
#     elseif str == "詰み"
#     elseif str == "切れ負け"
#     elseif str == "反則勝ち"
#     elseif str == "反則負け"
#     elseif str == "入玉勝ち"
#     elseif str == "不戦勝"
#     elseif str == "不戦敗"
#     else
#         valstate = iterate(str)
#         while !isnothing(valstate)
#             char, state = valstate
#             if char == '▲'
#             elseif char == '△'
#             else
#                 if char == '同'
#             end
#         end
#     end
# end