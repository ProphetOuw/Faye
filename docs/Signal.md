---
sidebar_position: 7
---
# Signal and SignalState
Signal and SignalState let you reactively respond to RBXScriptSignals and return props to compile.

## Signal
Signal creates a reactive connection that <mark>executes a function when signals fire and compiles the returned props</mark>. Unlike regular event connections, Signal integrates with Faye's compilation system.

```lua
Thread:Create "TextButton" {
    Thread:Signal(button.MouseEnter, function(Thread, Entity)
        return {
            BackgroundColor3 = Color3.new(1, 0, 0)
        }
    end)
}
```

The callback receives:
- **Thread**: A thread for creating instances
- **Entity**: The Roblox Instance being worked on
- **...**: Any additional arguments from the signal

### Multiple signals
You can listen to multiple signals at once by passing a table:
```lua
Thread:Create "TextButton" {
    Thread:Signal({button.MouseEnter, button.MouseLeave}, function(Thread, Entity)
        return {
            BackgroundColor3 = Color3.new(1, 1, 1)
        }
    end)
}
```

### Returning props
You can return props in different ways:
```lua
-- Return a props table
return {Text = "Clicked!", TextColor3 = Color3.new(1, 0, 0)}

-- Return a specific property
return "Text", "Clicked!"

-- Return a new instance
return Thread:Create "Frame" { ... }
```

## SignalState
SignalState is like Signal but <mark>cleans up the previous session before running the new one</mark>. This is useful when you're creating instances that should be replaced on each signal fire.

```lua
local Notifications = Thread:Value({})

Thread:Create "Frame" {
    Thread:SignalState(Notifications.Changed, function(Thread, Entity)
        -- Previous notifications are cleaned before this runs
        return Thread:Iterate(Notifications, function(i, notif, Thread, Entity)
            return Thread:Create "TextLabel" {
                Text = notif.message,
                Parent = Entity
            }
        end)
    end)
}
```

### Signal vs SignalState
| Feature | Signal | SignalState |
|---------|--------|-------------|
| Cleans previous content | No | Yes |
| Creates new Thread per fire | No | Yes |
| Use for | Additive changes, property updates | Replacing content entirely |

## Using Signal outside props tables
You can also use Signal standalone for general event handling:
```lua
local signal = Thread:Signal(workspace.ChildAdded, function(Thread, Entity, child)
    print("Child added:", child.Name)
end)

-- Later, to disconnect:
signal:Destroy()
```

:::info
Signal automatically cleans up connections when the parent Thread is destroyed, so you don't need to manually disconnect in most cases.
:::
