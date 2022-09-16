using Statistics
using Printf

export parse_info
export parse_infos

function parse_info(str::AbstractString)
    words = split(str, " ")
    n = length(words)
    i = 1
    ret = Dict()
    while i <= n
        word = words[i]
        if word == "depth"
            i += 1
            word = words[i]
            ret["depth"] = parse(Int, word)
        elseif word == "seldepth"
            i += 1
            word = words[i]
            ret["seldepth"] = parse(Int, word)
        elseif word == "score"
            i += 1
            word = words[i]
            if word == "cp"
                i += 1
                word = words[i]
                ret["score cp"] = parse(Int, word)
            elseif word == "mate"
                i += 1
                word = words[i]
                x = tryparse(Int, word)
                if isnothing(x)
                    if word == "+"
                        x = 1
                    elseif word == "-"
                        x = -1
                    else
                        error()
                    end
                end
                ret["score cp"] = ifelse(sign(x), +Inf, -Inf)
            else
                error("score ?")
            end
        elseif word == "nodes"
            i += 1
            word = words[i]
            ret["nodes"] = parse(Int, word)
        elseif word == "nps"
            i += 1
            word = words[i]
            ret["nps"] = parse(Int, word)
        elseif word == "hashfull"
            i += 1
            word = words[i]
            ret["hashfull"] = parse(Int, word)
        elseif word == "time"
            i += 1
            word = words[i]
            ret["time"] = parse(Int, word)
        elseif word == "pv"
            i += 1
            ret["pv"] = SFENMove.(words[i:n])
        end
        i += 1
    end
    ret
end

function parse_infos(str::AbstractString)
    lines = split(str, "\n")
    dicts = parse_info.(lines)
    score_cps = [dict["score cp"] for dict in dicts]
    depth0 = dicts[begin]["depth"]
    depth1 = dicts[end]["depth"]
    nodes = dicts[end]["nodes"]
    @sprintf "%.1f ± %.1f %i:%i %.3f" mean(score_cps) std(score_cps) depth0 depth1 log10(nodes)
end