local Types = require(script.Parent.Parent.Parent.FayeTypes)
local Utility = require(script.Parent.Parent.Parent.Misc.FayeUtility)

type SpecialThread = {
    func: (Thread: Types.Thread, Entity: Instance) -> ();
    Params: Types.SpecialThreadParams;
}
function  CompileFunc(Instance,NewThread: Types.Thread,ParentThread: Types.Thread, SpecialThread: SpecialThread,Index: any,Delete: (remove: boolean) -> (),Compile,IsYielded: boolean?)
    local res1,res2 = SpecialThread.func(NewThread,Instance.Instance)
    local Entity = {Instance = Instance.Instance, Thread = NewThread}
    if res1 ~= nil then
        if Index ~= nil and Utility.tof(Index) ~= Utility.numbertxt then
            Compile(Entity,{[Index] = res1},NewThread)
        else
            if res2 ~= nil then
                Compile(Entity,{[res1] = res2},NewThread)
            else
                Compile(Entity, (Utility.tof(res1) == Utility.tabletxt and res1.__type == nil and res1) or {res1} ,NewThread)
            end
        end
    else
        Delete(true)
    end
    if SpecialThread.Params == nil then return end;
    if IsYielded and SpecialThread.Params.Lifetime then
        task.wait(SpecialThread.Params.Lifetime)
        Delete(true)
    else
        if Utility.tof(SpecialThread.Params) == Utility.numbertxt then
            ParentThread:Delay(SpecialThread.Params,Delete,true)
        elseif SpecialThread.Params.Lifetime ~= nil then
            ParentThread:Delay(SpecialThread.Params.Lifetime,Delete,true)
        end
    end
end
return function (Instance: Types.FayeInstance,Index, SpecialThread: SpecialThread,Compile)
    local ParentThread: Types.Thread = Instance.CleanThread or Instance.Thread;
    if ParentThread == nil then return end;
    local NewThread = ParentThread:Extend(true)
    local Delete; Delete = function(remove)
        --if remove then
            if EqThread ~= nil then
                Utility.RemoveFromThread(EqThread,Delete)
            end
            Utility.RemoveFromEntity(Instance,Delete)
        --end
        if NewThread ~= nil then
            Utility.CallDestroy(NewThread)
            NewThread = nil;
        end

    end
    if Utility.tof(SpecialThread.Params) == Utility.tabletxt and SpecialThread.Params.YieldSafe then
        ParentThread:Spawn(CompileFunc,Instance,NewThread,ParentThread,SpecialThread,Index,Delete,Compile,true)
    else
        CompileFunc(Instance,NewThread,ParentThread,SpecialThread,Index,Delete,Compile)
    end;
    Utility.AddToEntity(Instance,Delete)
    if ParentThread ~= nil then
        EqThread = ParentThread;
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
end