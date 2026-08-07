---
sidebar_position: 2
---
# Props Tables and Functions
### Props
When Creating or Configuring an item, the table is called a 'Props Table'
```lua
Thread:Create "Frame" {
    --this is a props table
}
```
You can set properties of that entity in the Props Table and you can also use Faye Utilities to achieve reactivity or other stuff.
```lua
Thread:Create "Frame" {
    Parent = Target;
    BackgroundColor3 = Color3.new(1,0,0)
}
```
### Functions
Functions in props tables work like code blocks, everything they return will also be compiled, you can use them to do checks or add conditional components or properties. You can return components, Props tables, etc... if it doesn't error it will probably work.
```lua
Thread:Create "Frame" {
    Parent = Target;
    function()
        if true then
            return Thread:Create "Frame" {
                ...
            }
        else
            return {BackgroundColor3 = Color3.new(1,0,0)}
        end
    end
}
```
You can also set properties to functions
```lua
{
    
    BackgroundColor3 = function()
        if true then
            return Color3.new(1,0,0)
        else
            return Color3.new(0,1,0)
        end
    end
}

```
You can nest Props tables as much as you want and you can have as many functions as you want in them.