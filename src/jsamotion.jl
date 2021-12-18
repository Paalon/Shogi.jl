
mutable struct JSAMotion
    suffixes::Vector{JSASuffix}
end

module JSASuffixes

export JSASuffix
export JSARelativeSuffix
export JSAMotionSuffix
export JSAPromotionSuffix
export JSADropSuffix

abstract type JSASuffix end

@enum JSARelativeSuffix 右 直 左
@enum JSAMotionSuffix 上 寄 引
@enum JSAPromotionSuffix 成 不成
@enum JSADropSuffix 打

const jsakifumovesuffix_to_string = Bijection(Dict(
    右 => "右",
    直 => "直",
    左 => "左",
    上 => "上",
    寄 => "寄",
    引 => "引",
    打 => "打",
    成 => "成",
    不成 => "不成",
))

# 打?|(右|直|左)?(上|寄|引)?(成|不成)?

end # module