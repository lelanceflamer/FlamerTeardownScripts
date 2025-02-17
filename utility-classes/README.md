# UTILITY-CLASSES
This folder contains all useful utility classes I need for my newer mods. I'm trying to make them as easy as possible to use (hence why I'm putting documentation inside of the code) so it can be easily
usable in any part of your Teardown code.

I expect that you have at least an intermediate level in Teardown modding, because I don't want having to explain to you what the Teardown API functions like `PlaySound`, `IsHandleValid` or `UiGetMousePos` do.
You have the [official modding API](https://teardowngame.com/modding/api.html) at your disposition for that.

I accept questions about what the code does in these utility classes though, which you can ask through my [Discord server](https://discord.gg/ATWxXhycvV).
## [async-helper.lua](/utility-classes/async-helper.lua)
###### Asynchronous is a big word for Teardown, in this case, it means it runs over multiple frames.
Makes the use of `coroutine` for Teardown easier. It runs a function over multiple frame, and once it has been done being executed, on the next call, it'll run again over multiple frames. Otherwise, the call is ignored.
I recommend using them for checking the `scene` or the `registry` (I think it won't have an impact to add, edit or delete keys) without slowing down the game (each millisecond counts, so always keep performance in mind).
### Why using coroutines?
The usage of `coroutine` can boost performance *a little bit* by putting checks that run every single frame to a check that would run over multiple frames, having a minimised impact on performance compared to a
synchronous execution.
### How to use?
To use `async-helper`, you first need to include it (`#include "path/to/async-helper.lua"`) and then have a function that you want to run asynchronously.
First, you need to use the `asyncHelper` object, and from it, call the `executeAsync` function, with the first parameter being the `function` that you want to run over multiple frames.
### Usage example
Let's say that I want to check whether 3 specific shapes are broken every frame, and if they are broken, then a sound should play.
For the sake of simplicity, I won't include the `init` function since it's **completely useless** for this example.
```lua
--example script location: MOD/script
#include "utility-classes/async-helper.lua"

function init() ... end

function tick()
  if broken then
    if not soundPlayed then
      soundPlayed = true
      PlaySound(brokenSound, Vec(0, 1, 2)) --plays the sound at position x=0, y=1, z=2
    end

    return --prevents further execution of the callback function.
  end

  asyncHelper.executeAsync(checkShapesState) --runs this function over multiple frames
end

function checkShapesState() --checks whether all three shapes (shape1, shape2 and shape3) are broken.
  if (IsShapeBroken(shape1) or not IsHandleValid(shape1)) and
    (IsShapeBroken(shape2) or not IsHandleValid(shape2)) and
    (IsShapeBroken(shape3) or not IsHandleValid(shape3))
  then
    broken = true
  end
end
```

## [events.lua](/utility-classes/events.lua)
Ever wanted to have (simple) **event handlers** for your events? I'm aware that Teardown has an built-in event system but it's very limited for what I can see, at least not that intuitive.
I inspired myself from Roblox's event system and made a similar (but simpler) event system for Teardown. It can be both used for random events in your scripts or events in objects.
### Why not using Teardown's event system?
The game's built-in event system is not that intuitive, first, you can't directly reference a function, instead, you have to have an existing global function in the script context (so it has to
have a name, you can't use anonymous functions) and second, you can only include one parameter. The good thing is that it supports tables, the bad thing is that each of the handling function needs
to be limited to a single argument.

I recognize that my event system is less intuitive to use between different scripts, but I'm sure you can make a centralized script for all of these events then include that script and use its events.
### How to use?
Include this script (`#include "path/to/events.lua"`), then create a variable with the value of `EventFactory.new()`. This will create a new event which can get handlers added through its `:Connect(function)` method,
where function is the handler `function` for this event. Events can have multiple handlers.
### Methods / fields
#### `:Connect(handler)` method
Adds a new handler to this event.

##### **Arguments**:
##### 1. handler `function(...)` - The handler `function` for the event. An event can have 0 parameter, or more, which is why the `...` argument has been used.

##### **Returns**: index `integer` - The index of the handler `function` in the *connections* table, it's the unique id of the handler if you want to disconnect it later on.
#### `:Disconnect(obj)` method
Contrarily to `:Connect`, this method is able to remove an event handler from the *connections* table in order to not have it invoked in further triggers.

##### **Arguments:**
##### 1. obj `function(...)|integer` - The handler function or its index (recommended) to disconnect.

#### `:Fire(...)` method
Invokes the event, causing all of its attached event handlers to be called, with the specified arguments.

##### **Arguments**:
##### ... `any` - The event parameters with who the event handlers will be called with.

### Usage example
I want to handle clicks on a square in a custom UI element, which can have at least one event handler for appearance when it's clicked and the other handlers added in another script using the custom
UI element. As usual, I won't make a code that is made to work, I just want to show where the event would be useful.
```lua
--example script location: "MOD/script/ui-elements"
--events script location: "MOD/script/utility-classes"
#include "../utility-classes/events.lua"

...

--Self is the custom UI element.
self.Clicked = EventFactory.new()
function self:draw()
  --ui stuff that we don't care about in this example
  ...

  if UiIsMouseInRect(200, 50) and InputPressed("lmb") then
    self.Clicked:Fire(UiGetMousePos()) --Fires the event, with the 2 first event arguments being the mouse location (x and y)/
  end
end

--this event handler will be invoked once the :Fire method is called, which is the expected behavior.
self.Clicked:Connect(function(mousePosX, mousePosY)
  DebugPrint("Clicked at " .. mousePosX .. ", " .. mousePosY)
end)
```
