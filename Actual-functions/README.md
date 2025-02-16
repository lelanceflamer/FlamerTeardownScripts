# Actual Functions DOCUMENTATION
This is the documentation for each of the functions in this folder. Maybe, I'll add a Wiki for everything.

## BetterPrint ([BetterPrint.lua](https://github.com/lelanceflamer/FlamerTeardownScripts/blob/main/Actual-functions/BetterPrint.lua))
What is does is just like the default DebugPrint but you can pass an infinite amount of arguments, and everytime there's a new argument, it adds a space between them (my example is: Instead of DebugPrint("hello " .. val .. " world!"), you can do this: BetterPrint("hello", val, "world!")).

To clarify, you can just do BetterPrint("My value is equals to", myValue).
You can also do this: BetterPrint(myValue, myOtherValue, myStringValue).

## ConditionValue ([ConditionValue.lua](https://github.com/lelanceflamer/FlamerTeardownScripts/blob/main/Actual-functions/ConditionValue.lua))
It's an interesting way to use a condition (boolean value) to return a value based off the result.
Originally, it was BoolString, but I wasn't satisfied by how limited and poorly coded it was, so I decided to improve it, especially because I learned ternary conditions in lua (accidentally), but it's a bit unexpected in some cases, so I decided that instead of deleting the function, I rewrite it differently so it has a better equivalent of itself.
Here's a code sample:
```lua
print("True:", ConditionValue(true, "Result is true", "Result is false"))
print("Falsy:", ConditionValue(false, "Falsy check #1: true", "Falsy check #1: false"), ConditionValue(notDefined, "Falsy check #2: true", "Falsy check #2: false"))
print("No params:", ConditionValue())
print("No T, F params:", ConditionValue(true))

local testConditionFunction = function() --A function that once ran, it generates a random number between 0 and 1, and if it's 0 it returns true, otherwise false.
  return math.random(0, 1) == 0
end
print("Condition function:", ConditionValue(testConditionFunction)) --Can either return true or false based on the random value generated.
```
Ouput:
```
True:	Result is true
Falsy:	Falsy check #1: false	Falsy check #2: false
No params:	false
No T, F params:	true
Condition function:	true
```
Parameters documentations, and how they affect the function:
### `condition` (1st parameter)
The `boolean` (or `function`) which represents the condition.
- If set to a **falsy** value (`nil` or `false`), the function will return the `F` parameter, or `"false"` if omitted.
- If set to a **truthy** value (`true` or a non-`nil` value), the function will return the `T` parameter, or `"true"` if omitted.
- In case it is a `function`, it'll be ran and it should return a `boolean` value.
### `T` (2nd parameter)
What is returned by `ConditionValue` if the `condition` parameter is a **truthy** value.
- If omitted or set to `nil`, it'll be set to `"true"`.
### `F` (3rd parameter)
The value returned if the `condition` parameter is a **falsy** value.
- If omitted or set to `nil`, it'll be set to `"false"`.

### If you need any help, then contact me in some way. (I recommend my Discord that is lelanceflamer) or Twitter (X): LeLanceFlamer
