Pkg.add("Match")
Pkg.add("DataStructures")

include("core.jl")

using Match
using DataStructures

abstract type Value end

Env = Dict{String, Value}

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
    params :: Vector{String}
    body :: ExprC
    env :: Env
end

topEnv = Env(("+" => PrimV("+")),
             ("-" => PrimV("-")),
             ("*" => PrimV("*")),
             ("/" => PrimV("/")),
             ("<=" => PrimV("<=")),
             ("equal?" => PrimV("equal?")),
             ("true" => BoolV(true)),
             ("false" => BoolV(false)))

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
                v :: Value => throw(RGMEError(serialize(v) * " is not truthy but used as condition"))
            end
        end
        IdC(id) => lookup(id, env)
        LamC(params, body) => ClosV(params, body, copy(env)) # Deep copy is not needed since Values don't mutate
        AppC(fun, args) => begin
            argVs = map(arg -> interp(arg, env), args)
            @match interp(fun, env) begin
                ClosV(params, body, clos_env) => interp(body, extend_env(clos_env, params, argVs))
                PrimV(op) => error("Primops not implemented yet")
                v :: Value =>  throw(RGMEError("non-procedure " * serialize(v) * " cannot be called"))
            end
        end
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

# Extends the given enviroment with the given bindings, can shadow
function extend_env(env :: Env, ids :: Vector{String}, argVs :: Vector{<:Value}) :: Env
    if length(ids) != length(argVs)
        throw(RGMEError("number of arguments to lambda does not match arity"))
    end
    for (id, argV) in zip(ids, argVs)
        env[id] = argV
    end
    env
end

# Looks up the value bound to an identifier in the enviroment
function lookup(id :: String, env :: Env) :: Value
    if haskey(env, id)
        get(env, id, NullV())
    else
        throw(RGMEError("unbound identifier $id"))
    end
end
