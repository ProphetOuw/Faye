---
sidebar_position: 6
---
# Iterate, AdvancedIterate, and CloneTable
Iterate and AdvancedIterate let you reactively render lists of items based on tables or Values.

## Iterate
Iterate creates a reactive iterator that <mark>refreshes the entire list when the source value changes</mark>. Use it when you want to re-render all items on any change.

```lua
local Items = Thread:Value({"Apple", "Banana", "Cherry"})

Thread:Create "Frame" {
    Thread:Iterate(Items, function(Index, Value, Thread, Entity)
        return Thread:Create "TextLabel" {
            Text = Value,
            LayoutOrder = Index,
            Parent = Entity
        }
    end)
}
```

The callback function receives:
- **Index**: The current key/index in the table
- **Value**: The current value at that index
- **Thread**: A thread for creating instances (use this for proper cleanup)
- **Entity**: The parent Roblox Instance

You can return properties to compile, a single instance, or a table of instances.

:::warning
If the parent instance has `OnClean` or `CleanDelay`, items built by Iterate are destroyed instantly when cleanup starts - they don't wait for the parent's exit animation. Give the topmost instance you return its own `CleanDelay` to keep it visible during the parent's exit. See [Cleanup](/docs/Cleanup#iterate-and-state-children-during-cleanup) for details.
:::

### Iterating over numbers
You can also iterate over a number to create N items:
```lua
local Count = Thread:Value(5)

Thread:Create "Frame" {
    Thread:Iterate(Count, function(Index, Value, Thread, Entity)
        return Thread:Create "TextButton" {
            Text = `Button {Index}`,
            Parent = Entity
        }
    end)
}
```
When `Count` changes, all buttons are cleaned and recreated.

## AdvancedIterate
AdvancedIterate is smarter - it <mark>only updates items that actually changed</mark> instead of refreshing everything. Each item gets its own dedicated thread for cleanup.

```lua
local Players = Thread:Value({
    Player1 = {Name = "Alice", Score = 100},
    Player2 = {Name = "Bob", Score = 85}
})

Thread:Create "Frame" {
    Thread:AdvancedIterate(Players, function(Index, Value, Thread, Entity)
        return Thread:Create "TextLabel" {
            Text = `{Value.Name}: {Value.Score}`,
            Parent = Entity
        }
    end)
}
```

When you add or remove items from the Value:
```lua
Players:Add("Player3", {Name = "Charlie", Score = 90}) -- Only creates Player3's UI
Players:Remove("Player1") -- Only removes Player1's UI
```

### When to use which?
| Use Case | Recommended |
|----------|-------------|
| Small lists that change entirely | `Iterate` |
| Large lists with individual add/remove | `AdvancedIterate` |
| Number-based iteration | `Iterate` |
| Performance-critical lists | `AdvancedIterate` |

:::info
For AdvancedIterate to work properly with add/remove detection, you must use the Value's `:Add()` and `:Remove()` methods rather than replacing the entire table.
:::

## CloneTable
CloneTable is a utility for cloning tables with optional transformation.

### Basic usage
```lua
local Original = {a = 1, b = 2, c = 3}
local Copy = Thread:CloneTable(Original)
-- Copy is now {a = 1, b = 2, c = 3}
```

### With transformation function
You can provide a function to transform each entry during cloning:
```lua
local Original = {a = 1, b = 2, c = 3}

-- Double all values
local Doubled = Thread:CloneTable(Original, function(Index, Value)
    return Index, Value * 2
end)
-- Doubled is {a = 2, b = 4, c = 6}
```

The transform function can:
- Return `newIndex, newValue` to change both key and value
- Return just `newValue` to keep the original key
- Return `nil` to exclude the entry from the clone

```lua
-- Filter and transform
local Filtered = Thread:CloneTable(Original, function(Index, Value)
    if Value > 1 then
        return Index, Value * 10
    end
    return nil -- Exclude entries where Value <= 1
end)
-- Filtered is {b = 20, c = 30}
```
