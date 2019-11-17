function check_str(num)
    try
        parse(Float64,num)
        true
    catch
        false
    end
