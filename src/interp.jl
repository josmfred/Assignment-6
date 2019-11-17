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

top_env = Env(("+" => PrimV("+")),
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
                PrimV(op) => apply_primop(op, argVs)
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

#=
This is the section for the primops. Status of primops:
    +           Done
    -           TODO
    *           TODO
    /           TODO
    <=          TODO
    equal?      Done
=#

# Adds two values (+ is only defined for NumV)
function val_add(vals :: Vector{<:Value}) :: Value
    @match vals begin
        [NumV(v1), NumV(v2)] => NumV(v1 + v2)
        _ => throw(RGMEError("unable to add values ["
                             * join(map(x -> serialize(x), vals), ", ")
                             * "]"))
    end
end

# Compares two values
function val_eq(vals :: Vector{<:Value}) :: Value
    @match vals begin
        [NumV(l), NumV(r)] => BoolV(l == r)
        [BoolV(l), BoolV(r)] => BoolV(l == r)
        [StrV(l), StrV(r)] => BoolV(l == r)
        _ => BoolV(false)
    end
end

# A mapping from op identifiers to the corresponding functions
prim_map = Dict{String, Function}(("+" => val_add),
                                  ("equal?" => val_eq))

# Applies the appropriate primop for a given identifier
function apply_primop(op :: String, vals :: Vector{<:Value}) :: Value
    prim_map[op](vals)
end
