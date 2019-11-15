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

Env = AbstractDict{String, Value}

function interp(expr :: ExprC, env :: Env) :: Real
    @match expr begin
        NumC(num) => NumV(num)
        Str(str) => StrV(str)
        IdC(sym) =>
end
