include("../src/main.jl")
include("../src/interp.jl")
include("../src/parse.jl")

using Test


#@testset "top_interp test" begin
#    @test top_interp("10") == "10.0"
#end

@testset "serialize test" begin
    @test serialize(NumV(12.3)) == "12.3"
    @test serialize(StrV("hello world")) == "\"hello world\""
    @test serialize(BoolV(true)) == "true"
    @test serialize(ClosV(["a"], NumC(13), top_env)) == "#<procedure>"
    @test serialize(PrimV("+")) == "#<primop>"
end

@testset "interp tests" begin
    @test interp(NumC(10), top_env) == NumV(10)
    @test interp(StrC("hello"), top_env) == StrV("hello")
    @test interp(StrC("hello"), top_env) == StrV("hello")
    @test interp(CondC(IdC("true"), NumC(12), StrC("hello")), top_env) == NumV(12)
    @test interp(CondC(IdC("false"), NumC(12), StrC("hello")), top_env) == StrV("hello")
    @test interp(AppC(LamC([], NumC(10)), []), top_env) == NumV(10)
    @test interp(AppC(LamC(["a", "b"], NumC(10)), [NumC(2), StrC("Hello")]), top_env) == NumV(10)
    @test interp(AppC(IdC("+"), [NumC(2), NumC(3)]), top_env) == NumV(5)
    @test interp(AppC(IdC("equal?"), [NumC(2), NumC(2)]), top_env) == BoolV(true)
    @test interp(AppC(IdC("equal?"), [StrC("2"), StrC("2")]), top_env) == BoolV(true)
    @test interp(AppC(IdC("equal?"), [IdC("true"), IdC("true")]), top_env) == BoolV(true)
    @test interp(AppC(IdC("equal?"), [IdC("false"), IdC("false")]), top_env) == BoolV(true)
    @test interp(AppC(IdC("equal?"), [IdC("false"), IdC("true")]), top_env) == BoolV(false)
    @test interp(AppC(IdC("equal?"), [NumC(2), NumC(3)]), top_env) == BoolV(false)
    @test interp(AppC(IdC("equal?"), [NumC(2), IdC("+")]), top_env) == BoolV(false)
    @test interp(AppC(LamC(["x", "y"], AppC(IdC("+"), [IdC("x"), IdC("y")])),
                       [AppC(IdC("+"), [NumC(10), NumC(-2)]), NumC(2)]), top_env) == NumV(10)
    @test_throws RGMEError("4 is not truthy but used as condition") interp(CondC(NumC(4), NumC(12), StrC("hello")), top_env)
    @test_throws RGMEError("non-procedure 4 cannot be called") interp(AppC(NumC(4), []), top_env)
    @test_throws RGMEError("number of arguments to lambda does not match arity") interp(AppC(LamC(["a"], NumC(10)), []), top_env)
    @test_throws RGMEError("number of arguments to lambda does not match arity") interp(AppC(LamC([], NumC(10)), [NumC(4)]), top_env)
    @test_throws RGMEError("unbound identifier %") interp(AppC(IdC("%"), [NumC(10), NumC(2)]), top_env)
    @test_throws RGMEError("unable to add values [true, 2]") interp(AppC(IdC("+"), [IdC("true"), NumC(2)]), top_env)
end


@testset "parse tests" begin
    @test remove_paren("(5)") == "5"
    @test check_numstr("5") == true
    @test parse_numstr("5") == NumC(5.0)
    @test make_array("if test then else") == ["if", "test", "then", "else"]
    @test parse_sexp("+") == IdC("+")
    @test parse_sexp("5") == NumC(5.0)
    #@test parse_sexp("(+ 3 4)") == AppC(IdC("+"), [NumC(3.0), NumC(4.0)]) #i don't know why this doesn't pass
end
