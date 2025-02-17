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
