--[=[
    @class Thread
    Threads help us contain/clean our components.
    ```lua
    local Threader = require(Faye)
    
    local Thread = Threader();
    ```
    You will most likely use this for all of your components as it wraps the **Faye** features and automatically add them to the cleaner to be cleaned when it's necessary.

]=]
local mt = {};
mt.__index = mt;
local tins,tf,tr = table.insert,table.find,table.remove
local destroytxt,tabletxt,cleantxt,instancetxt,functiontxt,rbxlscripttxt,threadtxt = "Destroy","table","Clean","Instance","function","RBXScriptConnection","thread"
--types
local Types = require(script.FayeTypes);

--methods
local Create = require(script.Create)
function mt:Create(ClassName: string)
    return Create(ClassName,self)
end
--Configure
local Configure = require(script.Configure)
function mt:Configure(Entity: any)
    return Configure(Entity,self)
end
--thread extension
--[=[
    @within Thread
    @method Extend
    @param NoLink boolean
    @return Thread
    Creates a sub-thread. Leave the NoLink to nil and the thread will be linked to the parent thread(will delete with parent), set NoLink to true for the thread to be independent.
]=]
function mt:Extend(IsOrphan: boolean?) : Types.Thread
    --[[
        You shoudn't call this function as a replacement for thread creation, it will always have some type of connection to the parent thread wether or not it has a no deletion attachment to it.
    ]]
    local new: any = {IsActive = true};
    setmetatable(new,mt);
    if IsOrphan == nil then
        new._isCleanAncestor = self._isCleanAncestor
        table.insert(self,new);
    end
    new.ParentThread = self
    return new;
end
--[=[
    @within Thread
    @method Spawn
    Similar to Task.spawn, not to be used within a compileable table.
]=]
local removetxt = "Remove"
function mt:Spawn(func: (...any) -> (),...)
    if func == nil then return end;
    local Yielded = false;
    local tsk; tsk = task.spawn(function(...)
        func(...)
        Yielded = true;
        if tsk ~= nil and self[removetxt] ~= nil then
            self:Remove(tsk)
        end
    end,...)
    if Yielded == false then
        self:Add(tsk)
    end
end
--[=[
    @within Thread
    @method Defer
    Similar to Task.defer, not to be used within a compileable table.
]=]
function mt:Defer(func: (...any) -> (),...)
    if func == nil then return end;
    local Yielded = false;
    local tsk; tsk = task.defer(function(...)
        func(...)
        Yielded = true;
        if tsk ~= nil and self[removetxt] ~= nil then
            self:Remove(tsk)
        end
    end,...)
    if Yielded == false then
        self:Add(tsk)
    end
end
--[=[
    @within Thread
    @method Delay
    Similar to Task.Delay, not to be used within a compileable table.
]=]
function mt:Delay(time: number, func: (...any) -> (),...)
    if func == nil or time == nil then return end;
    local Yielded = false;
    local tsk; tsk = task.delay(time,function(...)
        func(...)
        Yielded = true;
        if tsk ~= nil and self[removetxt] ~= nil then
            self:Remove(tsk)
        end
    end,...)
    if Yielded == false then
        self:Add(tsk)
    end
end
--[=[
    @within Thread
    @method Debris
    Similar to game.debris:AddItem, not to be used within a compileable table.
]=]
function mt:Debris(Item: any,Lifetime: number)
    if Item == nil or Lifetime == nil or Item[destroytxt] == nil then return end;
    self:Delay(Lifetime,Item.Destroy,Item)
end
--[=[
    @within Thread
    @method Clean
    This method cleans everything added to the thread, and the thread itself. After this method gets called the thread is no longer useable.
]=]
local Clean = require(script.Clean)
function mt:Destroy() : ()
    if self.ParentThread ~= nil then
        if self.ParentThread[removetxt] ~= nil then
            self.ParentThread:Remove(self)
        end;
        self.ParentThread = nil;
    end
    Clean(self)
end
--Value
local Value = require(script.Value);
function mt:Value(Initial: any)
    return Value(Initial,self)
end

--Animation
local Animation = require(script.Animation)
function mt:Animation(Goal: any, Info: (Types.Info | Types.SpringInfo | Types.Value)?,Modifications: Types.AnimationModifications?)
    return Animation(Goal,Info,Modifications,self);
end
local Lerp = require(script.Lerp)
function mt:Lerp(To: any, Factor: number?, From: any?)
    return Lerp(To,Factor,From,self);
end
--| Animation functions
local ModifyAnimation = require(script.ModifyAnimation)
function mt.ModifyAnimation(Animaiton: {[any]: any},Modifications: Types.AnimationModifications?)
    return ModifyAnimation(Animaiton,Modifications)
end
local CloneAnimation = require(script.CloneAnimation)
function mt:CloneAnimation(Animaiton: {[any]: any},Modifications: Types.AnimationModifications?)
    return CloneAnimation(Animaiton,Modifications,self)
end
--|

--TweenInfo
local Info = require(script.Info)
function mt.Info(Time: number,EasingStyle: Enum.EasingStyle,EasingDirection: Enum.EasingDirection, RepeatCount: number,Reverse: boolean,DelayTime: number)
   local Ret = Info(Time,EasingStyle,EasingDirection,RepeatCount,Reverse,DelayTime);
   --self:Add(Ret);
   return Ret
end
--SpringInfo
local Spring = require(script.SpringInfo)
function mt.SpringInfo(Time: number,Frequency: number,Damping: number, RepeatCount: number,Reverse: boolean,DelayTime: number)
    local Ret = Spring(Time,Frequency,Damping,RepeatCount,Reverse,DelayTime);
    --self:Add(Ret);
    return Ret
end

--[=[
    @within Thread
    @method Connect
    @param Connection RBXScriptSignal
    @param Function: () -> ()
    Signal connection
]=]
--connect
function mt:Connect(Connection: RBXScriptSignal,Function: () -> ())
    return self:Add(Connection:Connect(Function),true)
end
--[=[
    @within Thread
    @method Add
    @param Entity any
    The entity to add to the thread
]=]
local tof = typeof
function mt:Add(Entity: any,IsPriority: boolean?)
    if Entity == nil then return end;
    if IsPriority then
        if self.Priority == nil then
            self.Priority = {};
        end
        if tof(Entity) == tabletxt and Entity.__simplesignalconnection and Entity.lists == nil then
            Entity.lists = self.Priority;
        end
        tins(self.Priority,Entity)
    else
        tins(self,Entity)
    end
    
    return Entity;
end
--[=[
    @within Thread
    @method Remove
    @param Entity any
    The entity to remove from the thread, meaning when the thread is cleaned it won't be cleaned with it.
]=]
function mt:Remove(Entity: any)
    if Entity == nil then return end;
    local find = tf(self,Entity)
    if find ~= nil then
        tr(self,find)
        return true;
    elseif self.Priority ~= nil then
        find = tf(self.Priority,Entity)
        if find ~= nil then
            tr(self.Priority,find)
        end
    end
    return
end
--Do
local Do = require(script.Do)
function mt:Do(Function: (Grab: any,Thread: Types.Thread, Entity: Instance?) -> ())
    return Do(Function)
end
--Do
local YieldSafe = require(script.YieldSafe)
function mt:YieldSafe(func: (...any) -> (),DelayTime: number?)
    return YieldSafe(func,DelayTime,self)
end

--State
local State = require(script.State)
function mt:State(Function: (Grab: any, Thread: Types.Thread,Entity: Instance?) -> ())
    return State(Function)
end
--Iterate
local Iterate = require(script.Iterate)
function mt:Iterate(Table: any, Function: (Index: any,Value: any,Thread: Types.Thread?,Entity: Instance?) -> ())
    return Iterate(Table,Function,self)
end
--AdvancedIterate
local AdvancedIterate = require(script.AdvancedIterate)
function mt:AdvancedIterate(Table: any, Function: (Index: any,Value: any,Thread: Types.Thread?,Entity: Instance?) -> ())
    return AdvancedIterate(Table,Function)
end
--Delay value
local DelayValue = require(script.DelayValue)
function mt:DelayValue(Value: Types.Value, Time: number) : Types.DelayValue
    return DelayValue(Value,Time,self)
end
--Delay
local DelayProperty = require(script.DelayProperty)
function mt:DelayProperty(Props: Types.Properties | any,Time: number,From: Types.Properties?) : Types.Delay
    return DelayProperty(Props,Time,From,self)
end
--Property value
local InstancePropertySync = require(script.InstancePropertySync)
function mt:InstancePropertySync(Instance: Instance,Property: string)
    return InstancePropertySync(Instance,Property,self);
end
--Attribute
local InstanceAttributeSync = require(script.InstanceAttributeSync)
function mt:InstanceAttributeSync(Instance: Instance,Property: string)
    return InstanceAttributeSync(Instance,Property,self);
end

--SetTo
local SetTo = require(script.SetTo)
function mt:SetTo(Value: Types.Value)
    return SetTo(Value,self)
end
--Listener
local Listener = require(script.Listener)
function mt:Listener(Entity: any, Event: any, Function: () -> ()) : ()
    return Listener(Entity,Event,Function,self)
end
local Space = require(script.Space)
function mt:Space(func: (...any) -> ())
    return Space(func,self);
end
local Signal = require(script.Signal)
function mt:Signal(Connections: RBXScriptSignal | {RBXScriptSignal},func: (...any) -> ()?)
    return Signal(Connections, func,self);
end
local SignalState = require(script.SignalState)
function mt:SignalState(Connections: RBXScriptSignal | {RBXScriptSignal},func: (...any) -> ()?)
    return SignalState(Connections, func,self);
end
local GetSignal = require(script.GetSignal)
function mt:GetSignal(Method: string, Index: string,RunOnInitialization: boolean?)
    return GetSignal(Method,Index,RunOnInitialization, self);
end
local LoadAnimation = require(script.LoadAnimation)
function mt:LoadAnimation(Entity: Instance,Goals: any, Info: (Types.Info | Types.SpringInfo)?)
    return LoadAnimation(Entity, Goals, Info, self)
end
local Reactive = require(script.Reactive)
function mt:Reactive(func: (Grab: (Value: Instance | Types.Value) -> any) -> ())
    return Reactive(func,self)
end
local CloneTable = require(script.CloneTable)
function mt.CloneTable(Table: {[any]: any}, cloneFunction: (Index: any, Value: any) -> (any?, any?)?)
    return CloneTable(Table,cloneFunction)
end
local SpecialThread = require(script.SpecialThread)
function mt:SpecialThread(func: (Thread: Types.Thread, Entity: Instance) -> (),Params: Types.SpecialThreadParams)
    return SpecialThread(func,Params)
end
local tc = table.clear
--[=[
    @within Thread
    @method Schedule
    @param Time number?
    @param Item any
    @param ... any
    @return item
    Cleans an item individually based off the time. can also be used to call functions after a time has passed.
]=]
function  mt:Schedule(Time: number?,Item: any,...)
    if Item == nil then return end;
    local d;
    local func = function(...)
        local type = tof(Item)
        if type == tabletxt then
            if Item[destroytxt] ~= nil or Item[cleantxt] ~= nil then
                if Item[destroytxt] then
                    Item:Destroy()
                elseif Item[cleantxt] then
                    Item:Clean()
                end
            else
                tc(Item)
            end
        elseif type == instancetxt then
            Item:Destroy()
        elseif type == functiontxt then
            Item(...)
        elseif type == rbxlscripttxt then
            Item:Disconnect()
        elseif type == threadtxt then
            task.cancel(Item)
        end
        if d ~= nil then
            self:Remove(d)
            d = nil;
        end;
    end
    
    if Time  ~= nil and Time >0 then
        d = task.delay(Time,func,...)
        self:Add(d)
    else
        task.spawn(func,...)
    end
    return Item;
end

local scriptName = script.Name;

function mt.__tostring()
    return scriptName;
end

--< export types
export type Thread = Types.Thread
export type Value = Types.Value
export type Properties = Types.Properties
export type FayeInstance = Types.FayeInstance
export type Info = Types.Info
export type SpringInfo = Types.SpringInfo
export type AnimationModifications = Types.AnimationModifications
export type LoadAnimation = Types.LoadAnimation
export type DelayValue = Types.DelayValue
export type Delay = Types.Delay
export type Space = Types.Space
export type YieldSafe = Types.YieldSafe
export type Signal = Types.Signal
export type SpecialThreadParams = Types.SpecialThreadParams
export type SpaceTask = Types.SpaceTask
export type UserInputType = Types.UserInputType
export type Animation = Types.Animation
export type Connection = Types.Connection
export type Lerp = Types.Lerp
-->
return {
    new = function()
        local new = {IsActive = true}
        setmetatable(new,mt)
        return new;
    end :: () -> Types.Thread;
    Animation = Animation;
    Create = Create;
    Configure = Configure;
    Value = Value;
    Info = Info;
    SpringInfo = Spring;
    Do = Do;
    State = State;
    Iterate = Iterate;
    InstancePropertySync = InstancePropertySync;
    InstanceAttributeSync = InstanceAttributeSync;
    DelayValue = DelayValue;
    DelayProperty = DelayProperty;
    SetTo = SetTo;
    Listener = Listener;
    Space = Space;
    YieldSafe = YieldSafe;
    Signal = Signal;
    SignalState = SignalState;
    GetSignal = GetSignal;
    LoadAnimation = LoadAnimation;
    ModifyAnimation = ModifyAnimation;
    CloneAnimation = CloneAnimation;
    Reactive = Reactive;
    CloneTable = CloneTable;
    AdvancedIterate = AdvancedIterate;
    Lerp = Lerp;
}