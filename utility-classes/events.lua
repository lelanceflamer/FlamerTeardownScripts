EventFactory = {}
EventFactory.__index = EventFactory

---comment
---@return EventSignal event
function EventFactory.new()
  ---@class EventSignal
  local self = setmetatable(EventFactory, {})

  ---@type fun(...)[]
  local connections = {}

  ---Adds a new event handler to this event
  ---@param handler fun(...) The event handler
  ---@return integer index The unique event handler function index in the connections table.
  function self:Connect(handler)
    connections[#connections + 1] = handler
    return #connections
  end

  ---Disconnects an event handler from its index or its function from this event.
  ---@param obj integer|fun(...) The event handler function or function index
  function self:Disconnect(obj)
    if type(obj) == "number" then
      table.remove(connections, obj)
    else
      table.remove(connections, table.indexOf(connections, obj))
    end
  end

  ---Fires this event with the specified arguments
  ---@param ... any Event arguments
  function self:Fire(...)
    for i=1, #connections do
      local handler = connections[i]
      if handler then
        handler()
      end
    end
  end

  return self
end
