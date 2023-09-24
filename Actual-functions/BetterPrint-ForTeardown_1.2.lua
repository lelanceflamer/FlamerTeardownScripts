function BetterPrint(...) --Just made this for convenience, so instead of doing this (for example): DebugPrint("hello " .. val .. " world!"), you can do this: BetterPrint("hello", val, "world!")
    function getTableString(table)
        local newString = ""
        if type(table) == "table" then
            for i, v in pairs(table) do
                if not type(v) == "table" then
                    newString = newString .. i .. " = " .. v .. " "
                else
                    newString = newString .. i .. " = " .. getTableString(v)
                end
            end
        end

        return newString
    end
    
    local builtString = ""
    for i, v in ipairs({...}) do
        if type(v) ~= "table" then
            builtString = builtString .. v .. " "
        else
            for j, w in pairs(v) do
                if not type(w) == "table" then
                    builtString = builtString .. tostring(j) .. " = " .. tostring(w) .. " "
                else
                    builtString = builString .. tostring(j) .. " = " .. getTableString(w)
                end
            end
        end
    end

    DebugPrint(builtString)
end
