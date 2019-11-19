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
    split(sexp, r"[ ]")
end

function remove_paren(sexp :: String) :: String
    strip(sexp, ['(',')'])
    #=snip(s::String) = s[nextind(s,1):end]
    snip(sexp)
    chop(sexp)=#
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
    elseif (length(arr_sexp) == 3)

        sym = get_element(arr_sexp,1)
        lhs_str = get_element(arr_sexp,2)
        rhs_str = get_element(arr_sexp,3)

        if (sym == "+" || sym == "-" || sym == "*" || sym == "/")
            #lhs_numc = parse_numstr(lhs_str)
            #rhs_numc = parse_numstr(rhs_str)
            AppC(IdC(sym), [parse_sexp(lhs_str), parse_sexp(rhs_str)])
        end

    elseif (length(arr_sexp) > 3)

        sym = get_element(arr_sexp,1)
        tst = get_element(arr_sexp,2)
        thn = get_element(arr_sexp,3)
        els = get_element(arr_sexp,4)

        if (sym == "if")
            CondC(parse_sexp(tst),parse_sexp(thn),parse_sexp(els))
        end

    end
end
