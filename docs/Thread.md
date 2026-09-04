---
sidebar_position: 9
---
# Thread Methods
Threads are the core lifecycle containers in Faye. They help you manage and clean up resources automatically.

## Creating Threads
```lua
local Faye = require(path.to.Faye)
local Thread = Faye.new()
```

## Extend
Creates a sub-thread (child thread). <mark>Child threads are destroyed when their parent is destroyed</mark>.

```lua
local ChildThread = Thread:Extend()

-- Create independent thread (won't be destroyed with parent)
local IndependentThread = Thread:Extend(true)
```

When to use:
- Creating scoped sections of your UI
- Isolating cleanup for specific features
- Creating threads for State/Iterate that need independent cleanup

### NoAttachment (Independent Threads)
When you pass `true` to Extend, the thread becomes independent:

```lua
local IndependentThread = Thread:Extend(true)
```

**What this means:**
- The thread itself is **NOT** destroyed when the parent is destroyed
- You must manually call `:Destroy()` on it when done
- The `ParentThread` reference is still kept for cleanup traversal

**Important:** Even though the thread is independent, <mark>cleanup functions inside it (from OnClean, Iterate, Signal, etc.) can still register with an ancestor thread</mark>. Faye walks up the `ParentThread` chain to find the nearest thread with cleanup responsibility. So:

```lua
local Parent = Faye.new()
local Independent = Parent:Extend(true)

Independent:Create "Frame" {
    Parent = someGui,
    OnClean = function(Thread, Entity)
        -- This cleanup function registers with Parent (via ParentThread traversal)
        -- It WILL run when Parent is destroyed
        print("Cleaning up")
    end
}

Parent:Destroy()
-- The OnClean runs, but Independent thread itself still exists
-- You'd need to call Independent:Destroy() separately
```

This design lets you have long-lived threads while still connecting specific cleanup behaviors to parent lifecycles.

## Add / Remove
Manually add or remove items from the thread's cleanup list.

```lua
-- Add items to be cleaned when thread is destroyed
Thread:Add(connection)
Thread:Add(instance)
Thread:Add(function() print("cleanup") end)

-- Add as priority (cleaned first)
Thread:Add(importantConnection, true)

-- Remove from cleanup list
Thread:Remove(connection)
```

Supported types for cleanup:
- **Instances**: `:Destroy()` is called
- **Connections**: `:Disconnect()` is called
- **Tables with Destroy/Clean**: Method is called
- **Functions**: Executed
- **Threads**: `task.cancel()` is called

## Connect
Shorthand for connecting signals and adding to cleanup.

```lua
-- Instead of:
local conn = signal:Connect(handler)
Thread:Add(conn, true)

-- Just do:
Thread:Connect(signal, handler)
```

## Spawn / Delay
Like `task.spawn` and `task.delay` but <mark>automatically tracked for cleanup</mark>.

```lua
-- Spawn a function
Thread:Spawn(function()
    print("Running immediately")
end)

-- Delay a function
Thread:Delay(2, function()
    print("Running after 2 seconds")
end)
```

If the thread is destroyed before the delayed function runs, it's automatically cancelled.

## Debris
Like `game.Debris:AddItem` but tracked by the thread.

```lua
local part = Instance.new("Part")
Thread:Debris(part, 5) -- Destroy after 5 seconds
```

## Schedule
Clean an item after a delay, or call a function after a delay.

```lua
-- Destroy instance after 3 seconds
Thread:Schedule(3, myInstance)

-- Disconnect after 2 seconds
Thread:Schedule(2, myConnection)

-- Call function after 1 second
Thread:Schedule(1, function(arg1, arg2)
    print(arg1, arg2)
end, "hello", "world")

-- Immediate cleanup (Time = 0 or nil)
Thread:Schedule(0, myInstance)
```

## Destroy
Destroys the thread and all its tracked resources.

```lua
Thread:Destroy()
```

This will:
1. Remove thread from parent (if any)
2. Clean priority items first
3. Clean all tracked resources in reverse order
4. Clean child threads recursively

:::warning
After calling `:Destroy()`, the thread is no longer usable. Don't try to add or create things with a destroyed thread.
:::

## Recommended Component Pattern
```lua
local Faye = require(path.to.Faye)

return function(Parent: Instance)
    local Thread = Faye.new()

    Thread:Create "Frame" {
        Parent = Parent,
        -- ... your UI
    }

    -- Return cleanup function
    return function()
        Thread:Destroy()
    end
end
```

Usage:
```lua
local MyComponent = require(path.to.MyComponent)

local cleanup = MyComponent(playerGui)

-- Later, when done:
cleanup()
```
