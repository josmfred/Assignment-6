include("parse.jl")
include("interp.jl")

# Combines parsing and interpreting at the top level
function top_interp(expr :: String) :: String
    serialize(interp(exprParse(expr), topEnv))
end
