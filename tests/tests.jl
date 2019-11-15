using Test

@test interp(NumC(2), Dict{String, Value}()) == NumV(2)
@test interp(StrC("hello"), Dict{String, Value}()) == StrV("hello")
