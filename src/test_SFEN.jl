using Test

push!(LOAD_PATH, pwd())

using SFEN

function test_next(x::Teban)
    @test next(x) == Teban(!x.teban)
    @test next(next(x)) == x
end

function test_next!(x::Teban)
    y = copy(x)
    next!(y)
    @test next(x) == y
end

@test Teban(true) == Teban("b")
@test Teban(true) == Teban('b')
@test Teban(false) == Teban("w")
@test Teban(false) == Teban('w')

test_next(Teban(true))
test_next(Teban(false))
test_next!(Teban(true))
test_next!(Teban(false))

function test_next(x::Tesuu)
    @test next(x) == Tesuu(x.tesuu + 1)
    @test next(next(x)) == Tesuu(x.tesuu + 2)
end

function test_next!(x::Tesuu)
    y = copy(x)
    next!(y)
    @test next(x) == y
end

@test Tesuu(1) == Tesuu("1")
@test Tesuu(1) == Tesuu('1')
@test Tesuu(2) == Tesuu("2")
@test Tesuu(2) == Tesuu('2')
@test Tesuu(100) == Tesuu("100")

test_next(Tesuu(1))
test_next(Tesuu(2))
test_next(Tesuu(100))

test_next!(Tesuu(1))
test_next!(Tesuu(2))
test_next!(Tesuu(100))