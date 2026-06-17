local Types = require(script.Parent.Parent.Parent.FayeTypes)
local repeatedCompile = require(script.Parent.repeatedCompile)
local tins = table.insert
local Utility = require(script.Parent.Parent.Parent.Misc.FayeUtility)
return function (Entity: Types.FayeInstance, Index: any, Value: Types.Value,Compile: (Entity: Types.FayeInstance, Props: {[any]: any},...any) -> () )
    local Instance = Entity.Instance
    local Thread = Entity.InnerThread or Entity.Thread;
    local Signal = Instance[Index.Method](Instance,Index.Index)
    local func = function(...)
        if Thread ~= nil and not Thread.IsActive then print("Thread is no longer active"); return end;
        local Ret,Ret2 = Value(Instance,...)
        if Ret ~= nil then
            repeatedCompile(Index, Ret, Ret2, Compile, Entity)
            Ret = nil
        end
    end
    if Index.RunOnInitialization ~= nil then
        func()
    end
    if not Entity:Connect(Signal, func) then
        Utility.Connect(Signal,func,Thread)
    end
    Signal = nil;
end