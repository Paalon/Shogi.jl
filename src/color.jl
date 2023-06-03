
export Color, COLORLESS, BLACK, WHITE
export next, rotate, isblack, iswhite, iscolorless

@enum Color::Int8 begin
    COLORLESS = 0
    BLACK = 1
    WHITE = -1
end

next(color::Color) = Color(-Integer(color))
rotate(color::Color) = Color(-Integer(color))
Base.sign(color::Color) = sign(Integer(color))
isblack(color::Color) = color == BLACK
iswhite(color::Color) = color == WHITE
iscolorless(color::Color) = color == COLORLESS