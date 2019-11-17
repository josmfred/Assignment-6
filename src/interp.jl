Pkg.add("Match")
Pkg.add("DataStructures")

using Match
using DataStructures

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
    params :: LinkedList{String}
    body :: T
end

struct AppC{T}
    fun :: T
    args :: LinkedList{T}
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
    params :: LinkedList{String}
    body :: T
    env :: Dict
end

Value = Union{NumV, StrV, BoolV, ClosV, PrimV}

Env = AbstractDict{String, Value}
topEnv = Dict{String, Value}()

# Combines parsing and interpreting at the top level
# Currently does not support pasing
#  TODO Change expr type to String and add parsing
function top_interp(expr :: ExprC) :: String
    serialize(interp(expr, topEnv))
end

#Interprets an expression in the given enviroment.
function interp(expr :: ExprC, env :: Env) :: Value
    @match expr begin
        NumC(num) => NumV(num)
        StrC(str) => StrV(str)
        IdC(sym) => error("IdC not yet implemented")
        LamC(params, body) => error("LamC not yet implemented")
        AppC(fun, args) => error("AppC not yet implemented")
    end
end

# Serializes a value into a human readable string
function serialize(val :: Value) :: String
    @match val begin
        NumV(num) => repr(num)
        StrV(str) => repr(str)
        BoolV(bool) => repr(bool)
        _ :: ClosV => "#<procedure>"
        _ :: PrimV => "#<primop>"
    end
end
