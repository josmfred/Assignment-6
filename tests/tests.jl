include("../src/main.jl")
include("../src/interp.jl")
include("../src/parse.jl")

using Test


@testset "top_interp test" begin
    @test top_interp("10") == "10.0"
    @test top_interp("hello") == "\"hello\""
end

@testset "serialize test" begin
    @test serialize(NumV(12.3)) == "12.3"
    @test serialize(StrV("hello world")) == "\"hello world\""
    @test serialize(BoolV(true)) == "true"
    @test serialize(ClosV(["a"], NumC(13), topEnv)) == "#<procedure>"
    @test serialize(PrimV("+")) == "#<primop>"
end

@testset "interp tests" begin
    @test interp(NumC(10), topEnv) == NumV(10)
    @test interp(StrC("hello"), topEnv) == StrV("hello")
    @test interp(StrC("hello"), topEnv) == StrV("hello")
    @test interp(CondC(IdC("true"), NumC(12), StrC("hello")), topEnv) == NumV(12)
    @test interp(CondC(IdC("false"), NumC(12), StrC("hello")), topEnv) == StrV("hello")
    @test interp(AppC(LamC([], NumC(10)), []), topEnv) == NumV(10)
    @test interp(AppC(LamC(["a", "b"], NumC(10)), [NumC(2), StrC("Hello")]), topEnv) == NumV(10)
    @test_throws RGMEError("4 is not truthy but used as condition") interp(CondC(NumC(4), NumC(12), StrC("hello")), topEnv)
    @test_throws RGMEError("non-procedure 4 cannot be called") interp(AppC(NumC(4), []), topEnv)
    @test_throws RGMEError("number of arguments to lambda does not match arity") interp(AppC(LamC(["a"], NumC(10)), []), topEnv)
    @test_throws RGMEError("number of arguments to lambda does not match arity") interp(AppC(LamC([], NumC(10)), [NumC(4)]), topEnv)
    @test_throws RGMEError("unbound identifier %") interp(AppC(IdC("%"), [NumC(10), NumC(2)]), topEnv)
end

@testset "parse tests" begin
end
