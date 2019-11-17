Pkg.add("Match")
Pkg.add("DataStructures")

using Match
using DataStructures

abstract type ExprC end
abstract type Value end

struct NumC <: ExprC
    num :: Real
end

struct StrC <: ExprC
    str :: String
end

struct IdC <: ExprC
    str :: String
end

struct CondC <: ExprC
    cond :: ExprC
    success :: ExprC
    fail :: ExprC
end

struct LamC <: ExprC
    params :: LinkedList{String}
    body :: ExprC
end

struct AppC <: ExprC
    fun :: ExprC
    args :: LinkedList{ExprC}
end


struct NumV <: Value
    num :: Real
end

struct StrV <: Value
    str :: String
end

struct BoolV <: Value
    val :: Bool
end

struct PrimV <: Value
    op :: String
end

struct NullV <: Value
end

struct ClosV <: Value
    params :: LinkedList{String}
    body :: ExprC
    env :: Dict
end


Env = AbstractDict{String, Value}

topEnv = Dict{String, Value}(("true" => BoolV(true)),
                             ("false" => BoolV(false)))

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
        CondC(c, s, f) => begin
                            isSuccessV = interp(c, env)
                            @match isSuccessV begin
                                BoolV(isSuccess) => if isSuccess
                                                        interp(s, env)
                                                    else
                                                        interp(f, env)
                                                    end
                                _ :: Value => error("RGME: $serialize(_) is not truthy but used as condition")
                            end
                        end
        IdC(id) => lookup(id, env)
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


function lookup(id :: String, env :: Env) :: Value
    if haskey(env, id)
        get(env, id, NullV())
    else
        error("RGME: unbound identifier $id")
    end
end
