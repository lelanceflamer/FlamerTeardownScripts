# Actual Functions DOCUMENTATION
This is the documentation for each of the functions in this folder. Maybe, I'll add a Wiki for everything.

## BetterPrint (BetterPrint-ForTeardown_1.0.lua)
What is does is just like the default DebugPrint but you can pass an infinite amount of arguments, and everytime there's a new argument, it adds a space between them (my example is: Instead of DebugPrint("hello " .. val .. " world!"), you can do this: BetterPrint("hello", val, "world!")).

To clarify, you can just do BetterPrint("My value is equals to", myValue).
You can also do this: BetterPrint(myValue, myOtherValue, myStringValue).
File: [Actual-functions/BetterPrint-ForTeardown_1.0.lua](https://github.com/LlFPrograms/TeardownScripts-Only/blob/4c4891276f22c8a880382114c5a9146cb4e92c96/Actual-functions/BetterPrint-ForTeardown_1.0.lua)

## BoolString (BoolString.lua)
It's a better way to convert a boolean value to a string value.
Here's a code sample:
```lua
local myBool = true
local myOtherBool = false

local myString = BoolString(myBool) --Returns "True" (just like tostring(myBool)) because "myBool" is true.
local myOtherString = BoolString(myOtherBool, "Disabled", "Enabled") --Returns "Disabled" because "myOtherBool" is false.
```
If you don't put any other parameters other than the bool one, the function returns just like tostring(true) or tostring(false) does.
If you put one or two parameters (for example, for the "stringTrue" parameter), it would return "False" if the boolean is false, otherwise the value that is set for "stringTrue".
If both of the parameters are set, returns "stringFalse" if the value is false, otherwise "stringTrue".

### If you need any help, then contact me in some way. (I recommend my Discord that is lelanceflamer) or Twitter (X): LeLanceFlamer
