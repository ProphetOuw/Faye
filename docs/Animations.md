---
sidebar_position: 5
---
There are two ways to play animations in Faye
## Reactive Animations
Before creating reactive animations, you need to know about the Info tables and the Modification tables
### Info
```lua
local Info = require(Faye.Info)
local SpringInfo = require(Faye.SpringInfo)

local AnimInfo = Info( -- or Thread.Info or Faye.Info
    Time: number?,
    EasingStyle: Enum.EasingStyle?,
    EasingDirection: Enum.EasingDirection?,
    RepeatCount: number?,
    Reverse: boolean?,
    DelayTime: number?
)
local AnimSpringInfo = SpringInfo( -- or Thread.SpringInfo or Faye.SpringInfo
    Time: number?,
    Frequency: number?, -- frequency
    Damping: number?, --loss of energy
    RepeatCount: number?,
    Reverse: boolean?,
    DelayTime: number?
)
```
These are similar to TweenService's TweenInfo, with the addition of **SpringInfo**. If you want to use Springs instead of the plain roblox easings you substitute the Info with a SpringInfo when creating an animation, it's that easy.
:::note
If you leave any empty fields, it will automatically fill it with default values. You can also use a table for the info, these 'Info' and 'SpringInfo' functions just help you structure it with suggestions
:::
### Modification Tables
```lua
local Modifications = {
	FirstGoal: any; -- The goal for the first play
	FirstDelayTime: number?; -- the DelayTime for the first play
	FirstInfo: (Info | SpringInfo)?; -- the Info for the first play
	From: any; -- makes it so the animation starts from this once
	AlwaysFrom: any; --makes it so the animation always starts from this
}
```
These are self explanatory and allow you to have special modifications for your animations
### Animation Creation
The first parameter is the goal, the second the Info, and the third the modification table, the only mandatory parameter is the goal, the rest can be left empty.
```lua
Thread:Create "Frame" {
    BackgroundColor3 = Thread:Animation(Color3.new(1,1,0),InfoTable); -- tweens smoothly to the color
}
```
Above we have a tween that starts from the current Frame Color to the Goal
```lua
--test this code yourself in studio
local Faye = require(...) -- set this to the right path
return function(Target)
    local Thread = Faye.new()

    Thread:Create "Frame" {
        Parent = Target;
        BackgroundColor3 = Thread:Animation(  Color3.new(1,1,0)  ,  Thread.Info(.5)  ,  {From = Color3.new(1,0,0)}  ); -- Starts from red
    }

    return function()
        Thread:Destroy()
    end
end
```
![Gif](https://gyazo.com/9cfa4070d03658f6c98b4f10b85c63de.gif)

Rather than our goal, we can substitute it with a Faye Value, and every time we update it, our Frame will react to its change
```lua
local Goal = Thread:Value(Color3.new(1,1,0))
Thread:Create "Frame" {
    Parent = Target;
    BackgroundColor3 = Thread:Animation(  Goal  ,  Thread.Info(.5)  ,  {From = Color3.new(1,0,0)}  ); -- Starts from red
    MouseEnter = function()
        Goal:Set(Color3.new(0,0,1))
    end,

    MouseLeave = function()
        Goal:Reset()
    end
}
```
![Gif](https://gyazo.com/c6b601305261de58015af47f4ee6f1b2.gif)
:::note
When using Faye values as Goal, the animation won't tween to the goal for the first iteration, it will always set the Instance's property to the Goal's initial value first, so if you want it to tween, you must specify the From in the Animation modifications table, then it will tween to the Goal rather than setting the object's property on initialization.
:::
### Modifying already created Animations
Let's say you cloned an animation using table.clone and want to add special modifications to it, you can use the ModifyAnimation utility
```lua
local Anim = Thread:Animation(Color3.new(1,0,0),Info)
local AnimClone = table.clone(Anim)
Thread:ModifyAnimation(AnimClone, ModificationsTable)
```
You can also skip the Cloning part, because Faye has a built in function to do all of this in one go
```lua
local Anim = Thread:Animation(Color3.new(1,0,0),Info)
local AnimClone = Thread:CloneAnimation(Anim,ModificationsTable)

Thread:Create "Frame" {
    BackgroundColor3 = AnimClone
}
```
## Quick animations
If you just want to play animations and you don't want to set up reactivity, you can use Faye's LoadAnimation utility. Use it within a thread for the Thread to manage cleaning, but it's not necessary, you can use it in any script in your game.
```lua
Thread:LoadAnimation(  Entity  ,  {Size = UDim2.fromOffset(200,200)}  ,  Thread.Info(.2)  ):Play()
```
You can tween multiple properties in one object at the same time just like regular roblox tweening, the Info parameter is optional, but the Object and Goal table must be specified.

### LoadAnimation Methods
```lua
local anim = Thread:LoadAnimation(entity, {Size = UDim2.fromOffset(200, 200)}, Thread.Info(0.5))

anim:Play()    -- Start the animation
anim:Pause()   -- Pause at current position
anim:Resume()  -- Resume from paused position
anim:Stop()    -- Stop and reset
anim:Skip()    -- Jump to end state immediately
anim:Destroy() -- Clean up the animation object
```

### Example: Button hover animation
```lua
local button = Thread:Create "TextButton" {
    Parent = parent,
    Size = UDim2.fromOffset(100, 50),
}

local hoverAnim = Thread:LoadAnimation(button.Instance, {
    Size = UDim2.fromOffset(110, 55)
}, Thread.Info(0.2, Enum.EasingStyle.Quad))

button.Instance.MouseEnter:Connect(function()
    hoverAnim:Play()
end)

button.Instance.MouseLeave:Connect(function()
    hoverAnim:Stop()
end)
```

:::info
You can reuse 1 animation utility on multiple objects
:::