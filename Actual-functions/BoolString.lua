function BoolString(value, stringTrue, stringFalse)
    local fString = "False"
    local tString = "True"

    if stringFalse then
        fString = stringFalse
    end

    if stringTrue then
        tString = stringTrue
    end

    if value then
        return tString
    end

    return fString
end
