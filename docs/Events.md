---
sidebar_position: 3
---
# Instance Events and Utilties
### Basics
Placing events in the props tables, will connect the listener
```lua
{
    Touched = function()

    end
}
```
The first parameter of the events is always the Instance being worked on and following is all the other parameters
```lua
{
    Touched = function(Entity, PartTouched)
    
    end
}
```
:::note
Yes i am using an event reserved for parts, you can create anything with Faye.
:::
Utilities help you implement special properties, reactivity, and animations to your Faye Instances. Utilities also work on Instances that are Configured using the Configure function.
### GetSignal Utility
The **GetSignal** utility allows you to listen to complex instance events like, GetAttributeChangedSignal, GetPropertyChangedSignal, etc...
```lua
{
    [Thread:GetSignal("GetPropertyChangedSignal","Size")] = function(Entity)
        local Size = Entity.AbsoluteSize
        print(Size)
    end,
}
```
Its important to remember that complex roblox instance events don't return any parameters, so the only one that will be there is the one Faye automatically adds there which is the Entity in the first parameter position.

#### More GetSignal examples
```lua
-- Listen to attribute changes
Thread:Create "Frame" {
    [Thread:GetSignal("GetAttributeChangedSignal", "CustomData")] = function(Entity)
        local data = Entity:GetAttribute("CustomData")
        print("CustomData changed to:", data)
    end
}

-- Run callback on initialization too
Thread:Create "Frame" {
    [Thread:GetSignal("GetPropertyChangedSignal", "AbsoluteSize", true)] = function(Entity)
        -- The third parameter `true` makes it run immediately on creation
        print("Size is:", Entity.AbsoluteSize)
    end
}
```

### Returning props from events
Event handlers can return props to compile, just like Do and State:
```lua
Thread:Create "TextButton" {
    MouseEnter = function(Entity)
        return {
            BackgroundColor3 = Color3.new(1, 0, 0)
        }
    end,

    MouseLeave = function(Entity)
        return {
            BackgroundColor3 = Color3.new(1, 1, 1)
        }
    end
}
```

### Common events
| Event | Description | Parameters |
|-------|-------------|------------|
| `MouseEnter` | Mouse enters the GUI element | Entity |
| `MouseLeave` | Mouse leaves the GUI element | Entity |
| `MouseButton1Click` | Left mouse click | Entity |
| `MouseButton2Click` | Right mouse click | Entity |
| `Activated` | Button activated (click/touch) | Entity, InputObject |
| `InputBegan` | Input started on element | Entity, InputObject |
| `InputEnded` | Input ended on element | Entity, InputObject |
| `Touched` | Part touched (for BaseParts) | Entity, OtherPart |

:::tip
For more complex event handling with cleanup between fires, see [Signal and SignalState](./Signal.md).
:::