Pkg.add("Match")

struct NumC
    num :: Real
end

struct StrC
    str :: String
end

struct IdC
    str :: String
end

struct CondC{T}
    cond :: T
    success :: T
    fail :: T
end

struct LamC{T}
    params :: Array{String}
    body :: T
end

struct AppC{T}
    fun :: T
    args :: Array{T}
end

ExprC = Union{NumC, StrC, IdC, CondC, LamC, AppC}

struct NumV
    num :: Real
end

struct StrV
    str :: String
end

struct BoolV
    val :: Bool
end

struct PrimV
    op :: String
end

struct ClosV{T}
    args :: Array{String}
    body :: T
    env :: Dict
end

Value = Union{NumV, StrV, BoolV, ClosV, PrimV}

function interp(expr :: ExprC) :: Real
    2
end
Env = AbstractDict{String, Value}



function interp(expr :: ExprC, env :: Env) :: Real
    @match expr begin
        NumC(num) => NumV(num)
        Str(str) => StrV(str)
        IdC(sym) => error("IdC not yet implemented")
        LamC(params, body) => error("LamC not yet implemented")
        AppC(fun, args) => error("AppC not yet implemented")
end

function serialize(val : Value) :: String
    @match expr begin
        NumV(num) => repr(num)
        StrV(str) => repr(str)
        BoolV(bool) => repr(bool)
        _ :: ClosV => "#<procedure>"
        _ :: PrimV => "#<primop>"
end
