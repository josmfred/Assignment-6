import Base.parse
include("core.jl")

function check_numstr(sexp :: String) :: Bool
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

function parse_numstr(sexp :: String) :: ExprC
    NumC(parse(Float64, sexp))
end

function make_array(sexp :: String) :: Array{String,1}
    return split(sexp, r"[ ]")
end

function remove_paren(sexp :: String) :: String
    return strip(sexp, ['(',')'])
end

function get_element(arr :: Array{String,1}, num :: Integer) :: String
    getindex(arr,num)
end

function parse_sexp(sexp :: String) :: ExprC

    rm_paren = remove_paren(sexp)
    arr_sexp = make_array(rm_paren)

    if (length(arr_sexp) == 1)
        if (check_numstr(sexp))
            parse_numstr(sexp)

        else
            IdC(sexp)

        end
    elseif (length(arr_sexp) >= 3)

        sym = get_element(arr_sexp,1)
        lhs_str = get_element(arr_sexp,2)
        rhs_str = get_element(arr_sexp,3)

        if (sym == "if")
            CondC(StrC(sym),StrC(lhs_str),StrC(rhs_str))

        elseif (sym == "+" || sym == "-" || sym == "*" || sym == "/")
            lhs_numc = parse_numstr(lhs_str)
            rhs_numc = parse_numstr(rhs_str)
            AppC(IdC(sym), [lhs_numc, rhs_numc])

        end
    end
end
