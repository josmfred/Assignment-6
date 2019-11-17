Pkg.add("Match")

function checknumstr(sexp :: String) :: Bool
    try
        num = parse(Float64, sexp)
        if isa(num, Real)
            true
        end
    catch err
        if isa(err, ArgumentError)
            false
        end
    end
end

println(checknumstr("123"))
println(checknumstr("123a"))

function parsenumstr(sexp :: String) :: ExprC
    NumC(parse(Float64, sexp))
end

println(parsenumstr("123"))

function parse(sexp :: String) :: ExprC
    if (checknumstr(sexp))
        parsenumstr(sexp)
    end
end
