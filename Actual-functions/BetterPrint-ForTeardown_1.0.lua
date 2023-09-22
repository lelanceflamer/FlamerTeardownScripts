function BetterPrint(...) --Just made this for convenience, so instead of doing this (for example): DebugPrint("hello " .. val .. " world!"), you can do this: BetterPrint("hello", val, "world!")
    local builtString = ""
    for i, v in ipairs({...}) do
        builtString = builtString .. v .. " "
    end

    DebugPrint(builtString)
end