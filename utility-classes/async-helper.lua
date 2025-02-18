--This uses coroutines, but it has extra functions to make the handling easier over multiple frames.
--In Teardown, only use couroutines for checking entities (shape, body, trigger, screen, ...) or the registry.
--Additionally, I think you can also safely add, modify or delete registry keys without a performance impact on
--the main thread, but I'm not sure about this. The only goal of this in Teardown is to not slow down the
--callback.

asyncHelper = {}
asynchelper.__index = asyncHelper

---@param func fun(...): ...
---@return Task task A task representing the current status.
function asyncHelper.executeAsync(func)
  local task = initTask(func)

  ---@diagnostic disable-next-line: undefined-field
  task:runAsynchronously()

  return task
end

---@param func fun(...): ...
---@return Task
function initTask(func)
  ---@class Task
  local self = setmetatable(asyncHelper, {})
  local isRunning = false

  function self:runAsynchrnously()
    coroutine.wrap(self.run)()
  end

  ---This is untested code. If it doesn't work as expected, make sure to create a new issue.
  function self:await()
    local result = nil
    coroutine.wrap(function()
        result = self.run()
    end)()
    while self:isFunctionRunning() do
      --wait ig
    end
  end

  function self:isFunctionRunning()
    return isRunning
  end

  function self:run()
    local result = nil

    if not self:isFunctionRunning() then
      isRunning = true
      result = func()
      isRunning = false
    end

    return result
  end

  return self
end


---@generic K
---@generic V
---@param t table<K, V>
---@param element V
function table.indexOf(t, element)
    local _, index = table.find(t, function (value) return element == value end)

    return index
end

---Finds an element from a table `t` using a function `func` and whether to start from the end `startsFromEnd`.
---@generic V
---@generic K
---@param t table<K, V> The table to find the element
---@param func fun(value : V, index: K, t: table<K, V>) : boolean The function that looks for the specified element (arg1: current value, arg2: current value's index, arg3: table `t`)
---@param startsFromEnd? boolean Whether to start looking at the end of the table instead of the beginning, default value is `false`.
---@return V? value Found value, or `nil` if not.
---@return K? index Found value's index, or `nil` if not found.
function table.find(t, func, startsFromEnd)
    if startsFromEnd == true then
        t = table.invert(t)
    end

    for key, value in pairs(t) do
        if func(value, key, t) then
            return value, key
        end
    end

    return nil, nil
end
