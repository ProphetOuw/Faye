---
sidebar_position: 5
---
# Do, State, and Reactive
Do and State work like functions, but they react to Value changes
## Do
```lua
local Value = Thread:Value(33)
Thread:Create "TextLabel" {
    Thread:Do(function(Grab, Thread, Entity)
    
    end)
}
```
As you can see the first param is a **Grab** function, <mark>if you use it on any value it will return that Value's current value and will recall the Do utility every time that value is updated</mark>. The second is the **Thread** that created the Do utility, for State it's vital that you use it correctly but for Do since it's just the Thread that created it, it isn't that important, and the **Entity** is the current Faye Instance in question just like in a function.
```lua
local Value = Thread:Value(33)
Thread:Create "TextLabel" {
    Text = Thread:Do(function(Grab, Thread, Entity)
        local CurrentValue = Grab(Value)
        return `{CurrentValue} is the current number`
    end)
}
```
Just like functions, <mark>you can create new Faye Instances with Do</mark> but it doesn't have a rinse and repeat like system, so it will never delete the old stuff it created when it receives a new changed signal calling.
## State
State uses a rinse and repeat like system, so it will clean the last session before running the new one, so it solves the entire problem of the Do code block
```lua
local Value = Thread:Value(false)
Thread:Create "TextLabel" {
    Thread:State(function(Grab, InnerThread, Entity)
        local CurrentValue = Grab(Value)
        if CurrentValue then
            return InnerThread:Create "Frame" {
                ...
            }
        else
            return {
                Text = "Unable to create frame"
            }
        end
    end)
}
```
<mark>**Everything created within the State utility must be created using the InnerThread provided on the 2nd parameter**</mark> otherwise it won't clean previous sessions properly.

:::warning
If the parent instance has `OnClean` or `CleanDelay`, instances built by State are destroyed instantly when cleanup starts - they don't wait for the parent's exit animation. Give the topmost instance you return its own `CleanDelay` to keep it visible during the parent's exit. See [Cleanup](/docs/Cleanup#iterate-and-state-children-during-cleanup) for details. (`Do` is unaffected since it doesn't own session instances.)
:::
## Reactive
As you have probably already guessed, State and Do only work in props tables, if you want a similar system to use outside of a props table you can use the **Reactive** utility.
```lua
local Value = Thread:Value(12)
local ValueButAdd30 = Thread:Value()
Thread:Reactive(function(Grab)
    local Current = Grab(Value)
    ValueButAdd30:Set(Current + 30)
end)
```
The Reactive Utility only has 1 parameter and it's the Grab function.
:::info
You can grab as many Values as you want and it will react to all of their changes, there's no rule of when you can grab them, it can be now or in the future
:::