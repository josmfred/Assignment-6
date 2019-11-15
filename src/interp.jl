
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
