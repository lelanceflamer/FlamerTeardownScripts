function BetterPrint(...) --Just made this for convenience, so instead of doing this (for example): DebugPrint("hello " .. val .. " world!"), you can do this: BetterPrint("hello", val, "world!")    
    local builtString = ""
    for i, v in ipairs({...}) do
        if type(v) ~= "table" then
            builtString = builtString .. v .. " "
        else
            for j, w in pairs(v) do
                if not type(w) == "table" then
                    builtString = builtString .. tostring(j) .. " = " .. tostring(w) .. " "
                else
                    --Do something but too lazy
                end
            end
        end
    end

    DebugPrint(builtString)
end
