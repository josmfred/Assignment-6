# Contains the core language forms and errors for RGME

# Represents the errors that a RGME Programmer would see.
struct RGMEError <: Exception
    errorMesg :: AbstractString
end
Base.showerror(io::IO, e::RGMEError) = print(io, "RGME: ", e.errorMesg, "!")

abstract type ExprC end

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
    params :: Vector{String}
    body :: ExprC
end

struct AppC <: ExprC
    fun :: ExprC
    args :: Vector{ExprC}
end
