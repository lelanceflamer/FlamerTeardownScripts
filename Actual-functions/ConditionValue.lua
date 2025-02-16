--Well, I've made this script because I'm so stupid, especially before I discovered that in lua
--you can just also make single line conditions. The goal of the BoolString function below was
--to replicate this behavior, but since I've discovered:
--local variable = condition and "value1" or "value2", but it can have an unexpected behavior if
--the "value1" expression is a falsy value (value is false or nil), it'll always return the "value2"
--exoression even though condition is true.
--Source: https://stackoverflow.com/a/72021612
--Sure, there are ways to bypass this behavior, as shown by the StackOverflow answer above, but it doesn't
--feel lualistic (if you see what I mean). So, BoolString prevents this unexpected behavior.
--I inspired myself of one of the answers of that StackOverflow question, but I made it a bit different.
--I have reviewed the code and decided to rename the function too, so it isn't limited by strings only.
--Have fun :D

function ConditionValue(condition, T, F)
    T = T or "true"
    F = F or "false"

    if condition == nil then
        condition = false
    elseif type(condition) == "function" then
        condition = condition() --executes the condition function, the result is expected to be a boolean
    end

    if condition == true then
        return T
    end

    return F --returning false, whether because the condition is falsy (expected) or because it's not even a boolean or nil to start with (shouldn't be the case if you use this function correctly).
end
