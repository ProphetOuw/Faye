---
sidebar_position: 10
---
# Cleanup and Lifecycle
Faye provides special props to control how instances are cleaned up.

## OnClean
`OnClean` is called <mark>before the instance is destroyed</mark>. It behaves differently depending on whether `CleanDelay` is also present:

### OnClean without CleanDelay
When used on its own, `OnClean` adds the instance to its InnerThread and <mark>waits for all animations in the InnerThread to finish before destroying</mark>. This is the recommended way to do cleanup animations.

```lua
Thread:Create "Frame" {
    Parent = parent,

    OnClean = function(InnerThread, Entity)
        -- Entity is added to InnerThread automatically
        -- Faye waits for these animations to complete before destroying
        return {
            BackgroundTransparency = InnerThread:Animation(1, Thread.Info(0.3))
        }
    end
}
```

### OnClean with CleanDelay
When both are present, <mark>`OnClean` becomes a `CleanFunction`</mark> - it runs during cleanup but the instance destruction is controlled by the `CleanDelay` timer instead of waiting for animations.

```lua
Thread:Create "Frame" {
    Parent = parent,

    OnClean = function(InnerThread, Entity)
        -- This runs as a CleanFunction since CleanDelay is present
        -- Destruction timing is controlled by CleanDelay, not animations
        return {
            BackgroundTransparency = InnerThread:Animation(1, Thread.Info(0.5))
        }
    end,

    CleanDelay = 0.5
}
```

The callback receives:
- **InnerThread**: A dedicated thread for cleanup operations
- **Entity**: The Roblox Instance being cleaned

### Passing a props table directly
If you don't need the callback parameters, both `OnClean` and `CleanFunction` also accept a props table directly - it is compiled at cleanup exactly like a returned one:

```lua
Thread:Create "Frame" {
    Parent = parent,

    OnClean = {
        BackgroundTransparency = Thread:Animation(1, Faye.Info(0.3))
    }
}
```

Note that the table's contents are built when the instance is created, not at cleanup - use the function form if a value has to be computed at cleanup time (for example reading the Entity's current state).

## CleanDelay
`CleanDelay` delays the destruction of an instance by a specified time (in seconds).

```lua
Thread:Create "Frame" {
    Parent = parent,

    CleanDelay = 2 -- Wait 2 seconds before destroying
}
```

### Dynamic delay
You can also pass a function to calculate the delay:

```lua
Thread:Create "Frame" {
    Parent = parent,

    CleanDelay = function(InnerThread, Entity)
        -- Calculate delay based on some condition
        return Entity.AbsoluteSize.X > 100 and 1 or 0.5
    end
}
```

## CleanFunction
`CleanFunction` runs during cleanup but <mark>does not control when the instance is destroyed</mark>. Unlike `OnClean` (without CleanDelay), it won't wait for animations to finish.

```lua
Thread:Create "Frame" {
    CleanFunction = function(InnerThread, Entity)
        -- Runs during cleanup, but doesn't delay destruction
        print("Cleaning up")
    end
}
```

Like `OnClean`, it also accepts a [props table directly](#passing-a-props-table-directly) instead of a function:

```lua
Thread:Create "Frame" {
    CleanFunction = {
        BackgroundColor3 = Color3.new(1, 0, 0) -- applied during cleanup
    }
}
```

:::info
When you use `OnClean` together with `CleanDelay`, the `OnClean` is internally treated as a `CleanFunction`. Use `OnClean` alone if you want Faye to automatically wait for animations to finish.
:::

## InnerThread
When you use `OnClean` or `CleanDelay`, Faye automatically creates an `InnerThread` for the instance. This thread:

- Is a child of the main thread
- Gets destroyed after the instance cleanup completes
- Can be used to track cleanup-specific resources

```lua
Thread:Create "Frame" {
    Parent = parent,

    OnClean = function(InnerThread, Entity)
        -- InnerThread is automatically created
        -- Use it for cleanup animations/operations

        InnerThread:Create "Frame" {
            Parent = Entity,
            -- This child will also be cleaned properly
        }
    end
}
```

## Cleanup Order
When a thread is destroyed:

1. **Priority items** are cleaned first (connections added with `Thread:Add(item, true)`)
2. **Regular items** are cleaned in reverse order (last added = first cleaned)
3. **Child threads** are recursively cleaned
4. **Instance cleanup** runs (`CleanFunction` if present, then `OnClean` if present)
5. For `OnClean` without `CleanDelay`: waits for all InnerThread animations to finish, then destroys
6. For `CleanDelay`: waits the delay duration, then destroys

## Iterate and State children during cleanup
`Iterate`, `AdvancedIterate` and `State` don't register their teardown on the instance's InnerThread - <mark>they walk up the `ParentThread` chain and register on the nearest ancestor thread with cleanup responsibility</mark>. (`Do` is unaffected - it runs on the parent's thread and doesn't own session instances.) This has an important consequence:

When a parent instance has `OnClean` or `CleanDelay`, the items built by an `Iterate` or `State` inside it are <mark>destroyed instantly the moment cleanup starts</mark> - they do **not** inherit the parent's exit animation or delay. The parent frame will fade out with its list items already gone.

To keep them on screen during the parent's exit, give the first ancestor each callback creates (the topmost instance it returns) its own `CleanDelay` matching the parent's exit duration, or its own `OnClean`:

```lua
Thread:Create "Frame" {
    Parent = parent,

    OnClean = function(InnerThread, Entity)
        return {
            BackgroundTransparency = InnerThread:Animation(1, Faye.Info(0.3))
        }
    end,

    Thread:Iterate(Items, function(Index, Value, InnerThread, Entity)
        return InnerThread:Create "TextLabel" {
            Text = Value,
            Parent = Entity,
            CleanDelay = 0.3 -- keeps this item alive while the parent fades out
        }
    end)
}
```

Only the topmost instance of each item needs it - its descendants live under it in the Roblox tree, so they disappear together with it.

## Best Practices

### Do use OnClean for:
- Fade out animations
- Logging/analytics
- Notifying other systems
- Cleaning external resources

### Don't use OnClean for:
- Long-running operations (blocks cleanup)
- Creating new permanent UI (it will be destroyed)
- Heavy computations

### Example: Notification with auto-dismiss
```lua
local function Notification(message, duration)
    local Thread = Faye.new()

    Thread:Create "Frame" {
        Parent = notificationContainer,

        Thread:Create "TextLabel" {
            Text = message
        },

        OnClean = function(InnerThread, Entity)
            return {
                Position = InnerThread:Animation(
                    UDim2.new(1, 0, 0, 0),
                    Thread.Info(0.3)
                )
            }
        end,

        CleanDelay = 0.3
    }

    -- Auto-destroy after duration
    Thread:Delay(duration, function()
        Thread:Destroy()
    end)

    return Thread
end
```
