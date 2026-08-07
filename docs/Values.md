---
sidebar_position: 4
---
Values are the most important part of Faye and its reactive features.
:::note
You can use Faye utilities with a Thread or you can require the utilities individually and use them. Moving on, I will be using the Thread for the utilities.
:::
```lua
local Size = Thread:Value(UDim2.fromOffset(100,100))
```
You can set a Value to anything, it's like a roblox variable. You can also use regular roblox variables in places where you can use values, only issue is that they won't be reactive. Here are some basic value functions
```lua
Size:Set(UDim2.fromOffset(200,200)) -- set the value
print(Size:Get()) -- get the value


if Size:Compare(UDim2.fromOffset(200,200)) then --compare the Value
    print("Success")
end

Size:Reset() -- reset the value to its initial value
Size.Initial -- the Initial value of the Value
```
The **Value:Get** function has a recursive property where if the value is a Faye Instance it will return the roblox instance inside that faye instance, and if the value is another value it will call :Get on the nested value. There is a way to get the Value of a Faye Value without the recursiveness
```lua
print(Size.Value) -- the non-recursive value
```
## Special Faye Values
Faye also offers some utilities that let you sync Values to properties and Attributes
```lua
local Value = Thread:InstanceAttributeSync(Instance,"SomeAttribute") -- Attribute sync
local Value = Thread:InstancePropertySync(Instance,"Size") -- Property sync
```
You can use these special values like you would regular values, it has support for almost all functions if not all.

## Useful Value functions
You can use :Add and :Remove to increment or decrement a Value's value, using + or - also works in their place.
```lua
local Value = Thread:Value(25)
Value:Add(30)
Value += 5 -- now the current value is 60
Value:Remove(40)
Value -= 10 -- now its 10
Value = Value - 10 -- now its 0
```
This also works with table values
```lua
local tab = Thread:Value({
    "Hello world",
    "Second"
})

tab -= "Second" -- removes second from the table
```
### Refreshing a Value
If you made no changes to a value, but want to fire the signal so that it triggers reactivity, you can force this by doing
```lua
Value:Refresh();
```

## Listening to Value changes
Every Value has a `Changed` signal you can connect to directly:
```lua
local Health = Thread:Value(100)

Thread:Connect(Health.Changed, function(newValue)
    print("Health changed to:", newValue)
end)
```

## Table Values with keys
When working with table Values, you can add and remove with specific keys:
```lua
local Players = Thread:Value({})

-- Add with key
Players:Add("player1", {name = "Alice", score = 100})

-- Remove by key
Players:Remove("player1")
```

This is especially useful with [AdvancedIterate](./Iterate.md) which can react to individual key changes.

There are more functions like this in the [Api](/api) section.