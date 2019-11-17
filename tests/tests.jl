using Test


@testset "top_interp test" begin
    @test top_interp(NumC(10)) == "10"
    @test top_interp(StrC("hello")) == "\"hello\""
end

@testset "serialize test" begin
    @test serialize(NumV(12.3)) == "12.3"
    @test serialize(StrV("hello world")) == "\"hello world\""
    @test serialize(BoolV(true)) == "true"
    @test serialize(ClosV(list("a"), NumC(13), topEnv)) == "#<procedure>"
    @test serialize(PrimV("+")) == "#<primop>"
end

@testset "interp tests" begin
    @test interp(NumC(10), Dict{String, Value}()) == NumV(10)
    @test interp(StrC("hello"), Dict{String, Value}()) == StrV("hello")
end

@testset "parse tests" begin
end
