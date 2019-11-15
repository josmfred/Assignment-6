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

ExprC = Union{NumC, StrC, IdC, CondC{ExprC}, LamC{ExprC}, AppC{ExprC}}
