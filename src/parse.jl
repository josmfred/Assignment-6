import Base.parse

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

function parse(sexp :: String) :: ExprC
    rm_paren = remove_paren(sexp)
    arr_sexp = make_array(rm_paren)

    if (length(arr_sexp) == 1)
        if (check_numstr(arr_sexp))
            (parse_numstr(arr_sexp))
        end
    #=
    else if (length(arr_sexp) == 3)
        # make an AppC
    =#
    end
end
