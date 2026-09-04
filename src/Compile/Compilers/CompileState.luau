local Types = require(script.Parent.Parent.Parent.FayeTypes)
local Utility = require(script.Parent.Parent.Parent.Misc.FayeUtility)

local firsttxt = "is_first123"
return function (Instance: Types.FayeInstance,Index, State: Types.Value,Compile: (Entity: Types.FayeInstance, Props: {[any]: any},...any) -> ())
    local Thread = Instance.CleanThread or Instance.Thread;
    if State.IsState and (Thread == nil or Thread["Extend"] == nil) then
        warn("State only works if the entity has a thread and the thread has an :Extend method")
        return
    end
    local Log;
    local Connections;
    local Grab,Trigger;
    local Delete;
    --| Trigger
    local StateThread;
    Trigger = function(ft: string?)
        if StateThread ~= nil then
            Utility.CallDestroy(StateThread)
            StateThread = nil;
        end
        if State.IsState then
            StateThread = Thread:Extend(true);
        end
        
        local res1,res2 = State.Func(Grab,StateThread or Thread,Instance.Instance)
        local Entity = (State.IsState and {Instance = Instance.Instance, Thread = StateThread}) or Instance
        if res1 ~= nil then
            if Index ~= nil and Utility.tof(Index) ~= Utility.numbertxt then
                Compile(Entity,{[Index] = res1},StateThread)
            else
                if res2 ~= nil then
                    Compile(Entity,{[res1] = res2},StateThread)
                else
                    Compile(Entity,{res1},StateThread)
                end
            end
        else
            if ft == firsttxt and Log == nil then
                Delete()
            else
                if StateThread ~= nil then
                    Utility.CallDestroy(StateThread)
                    StateThread = nil;
                end
            end
            
        end
    end
    --|> Trigger
    --| grab
    
    Grab = function(Value: any)
        if Value == nil then return end;
        if Utility.tof(Value) == "table" and Value.__type == "Instance" then
            Value = Value.Instance;
        end
        if Log == nil then Log = {}; Connections = {} end;
        if Value.ClassName ~= nil then
            if Log[Value] == nil then
                Log[Value] = true;
                Utility.tins(Connections,Value.Changed:Connect(Trigger))
            end
            return Value.Value;
        else
            if Log[Value.Id] == nil then
                Log[Value.Id] = true;
                Utility.tins(Connections,Value.Changed:Connect(Trigger,Connections))
            end
    
            return Value:Get();
        end
    end
    
    --| delete
    local EqThread
    Delete = function()
        if EqThread ~= nil then
            Utility.RemoveFromThread(EqThread,Delete)
        end;
        Utility.RemoveFromEntity(Instance,Delete)
        if StateThread ~= nil then
            Utility.CallDestroy(StateThread)
            StateThread = nil;
        end
        if Log ~= nil then
            Utility.tc(Log);
            Log = nil;
        end;
        if Connections ~= nil then
            Utility.ClearAllConnections(Connections)
            Connections = nil;
        end
        Grab = nil;
        Trigger = nil;
        Delete = nil;
    end
    task.spawn(Trigger,firsttxt)
    Utility.AddToEntity(Instance,Delete)
    if Thread == nil then return end;
    EqThread = Thread;
    if EqThread._isCleanAncestor then
        local CurrentPos = EqThread
        while CurrentPos ~= nil do
            if CurrentPos._hc then
                break;
            end
            CurrentPos = CurrentPos.ParentThread;
        end
        EqThread = CurrentPos or EqThread;
    end
    Utility.AddToThread(EqThread,Delete)
end