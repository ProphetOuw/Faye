---
sidebar_position: 8
---
# Utilities
Faye provides several utility functions for common patterns like debouncing, delayed compilation, task batching, and more.

## DelayValue
DelayValue wraps a Value and <mark>debounces its changes by a specified time</mark>. The `Changed` signal only fires after the delay has passed.

```lua
local SearchQuery = Thread:Value("")
local DebouncedQuery = Thread:DelayValue(SearchQuery, 0.5) -- 500ms delay

-- This won't spam API calls
Thread:Reactive(function(Grab)
    local query = Grab(DebouncedQuery)
    if query ~= "" then
        searchAPI(query)
    end
end)
```

### Sensitive mode
When sensitive mode is enabled, if a new update comes in before the delay finishes, the old update is skipped:
```lua
local Debounced = Thread:DelayValue(MyValue, 0.3):Sensitive()
```

### Custom delays per value
You can set different delays for specific values:
```lua
local Status = Thread:DelayValue(StatusValue, 1)
Status:For("loading", 0) -- "loading" fires immediately
Status:For("error", 2)   -- "error" waits 2 seconds
```

### Methods
```lua
Debounced:Get()              -- Get current value
Debounced:Set(newValue)      -- Set new value (with delay)
Debounced:SetTime(0.5)       -- Change delay time
Debounced:ResetTime()        -- Reset to default delay
Debounced:Refresh()          -- Force fire Changed signal
Debounced:SetSignalEnabled(false) -- Disable Changed signal
Debounced:Destroy()          -- Clean up
```

## DelayProperty
DelayProperty lets you <mark>compile props after a delay</mark>. Useful for staged animations or delayed UI updates.

```lua
Thread:Create "Frame" {
    Size = UDim2.fromOffset(0, 0),

    -- After 1 second, animate to full size
    Thread:DelayProperty(
        {Size = Thread:Animation(UDim2.fromOffset(200, 200), Thread.Info(0.5))},
        1, -- delay in seconds
        {Size = UDim2.fromOffset(0, 0)} -- optional "From" state
    )
}
```

Parameters:
- **Props**: The properties to compile after the delay
- **Time**: Delay in seconds
- **From**: Optional initial properties to set immediately

## Space
Space is a <mark>task batching system</mark> that helps manage multiple operations without excessive connections running at once.

```lua
local UpdateUI = Thread:Space(function(playerName, score)
    print(`Updating {playerName}: {score}`)
end)

-- Add tasks to the space
local task1 = UpdateUI:Add({"Player1", 100})
local task2 = UpdateUI:Add({"Player2", 85})

-- Execute all tasks
UpdateUI:Call()
```

### Task methods
```lua
local task = UpdateUI:Add({params})

task:SetId("unique-id")      -- Set an ID for targeted calls
task:Connect(signal)         -- Auto-call when signal fires
task:Call()                  -- Execute this task
task:AddParameter(value)     -- Add parameter
task:Destroy()               -- Remove from space
task.SpaceIndex              -- The task's index in the Space (set on Add)
```

### Space methods
```lua
UpdateUI:Call()              -- Execute all tasks
UpdateUI:Call("specific-id") -- Execute only task with ID
UpdateUI:Connect(signal)     -- Connect signal to call all tasks
UpdateUI:Connect(signal, "id") -- Connect signal to specific task
UpdateUI:Remove(task)        -- Remove a task
UpdateUI:Destroy()           -- Clean up entire space
```

## YieldSafe
YieldSafe lets you <mark>safely use yielding functions in props tables</mark>. Normally, yielding in compilation would block the UI.

```lua
Thread:Create "TextLabel" {
    Thread:YieldSafe(function(Thread, Entity)
        local data = fetchDataFromServer() -- This yields
        return {
            Text = data.message
        }
    end)
}
```

With optional delay before execution:
```lua
Thread:YieldSafe(function(Thread, Entity)
    return {Text = "Delayed!"}
end, 2) -- Wait 2 seconds before running
```

## SetTo
SetTo wraps a Value so that <mark>the property is set directly to the Value's current value</mark> without creating a reactive binding.

```lua
local InitialSize = Thread:Value(UDim2.fromOffset(100, 100))

Thread:Create "Frame" {
    -- Normally this would create a reactive binding
    Size = InitialSize,

    -- With SetTo, it just sets the value once (no reactivity)
    Position = Thread:SetTo(InitialPosition)
}
```

This is useful when you want to use a Value's current state without subscribing to future changes.

## Listener
Listener connects a function to <mark>one or more events on an entity</mark>, passing the event name as the first argument.

```lua
Thread:Listener(textBox, {"FocusLost", "Focused"}, function(eventName, ...)
    if eventName == "Focused" then
        print("TextBox focused")
    elseif eventName == "FocusLost" then
        print("TextBox lost focus")
    end
end)
```

This is useful when you want to handle multiple related events with a single function.

## SpecialThread
SpecialThread creates a <mark>dedicated thread for a function with custom lifecycle settings</mark>.

```lua
Thread:Create "Frame" {
    Thread:SpecialThread(function(Thread, Entity)
        -- This runs in its own thread
        return {
            BackgroundColor3 = Color3.new(1, 0, 0)
        }
    end, {
        Lifetime = 5,    -- Auto-destroy after 5 seconds
        YieldSafe = true -- Allow yielding
    })
}
```

### Parameters
The second parameter can be:
- A **number**: Lifetime in seconds before auto-cleanup
- A **table** with options:
  - `Lifetime`: Seconds before auto-cleanup
  - `YieldSafe`: Allow yielding in the function

```lua
-- Simple lifetime
Thread:SpecialThread(func, 10) -- Cleanup after 10 seconds

-- Full options
Thread:SpecialThread(func, {
    Lifetime = 10,
    YieldSafe = true
})
```
