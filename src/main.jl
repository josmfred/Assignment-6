include("parse.jl")
include("interp.jl")

# Combines parsing and interpreting at the top level
function top_interp(expr :: String) :: String
    serialize(interp(parse_sexp(expr), top_env))
end
