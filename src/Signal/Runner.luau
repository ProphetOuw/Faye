local Utility = require(script.Parent.Parent.Misc.FayeUtility)
local Compile = require(script.Parent.Parent.Compile)
local connecttxt = "Connect"
return function (new: {[any]: any}, Connections: RBXScriptSignal | {RBXScriptSignal}, func: (...any) -> () )
    new.receiverFunc = function(...)
        if new.Entries ~= nil then
            for i = 1,new.Entries.Count do
                local Eq = new.Entries[i]
                if Eq.Instance ~= nil and Eq.Instance.Thread ~= nil then
                    local Thread = Eq.Instance.CleanThread or Eq.Instance.Thread

                    --| state
                    if Eq.Thread ~= nil then
                        Utility.CallDestroy(Eq.Thread)
                    end
                    if new.IsState then
                        Eq.Thread = Thread:Extend()
                    end;
                    --|
                    local res1,res2 = func(Eq.Thread or Thread,Eq.Instance.Instance, ...)

                    local Entity = (new.IsState and {Instance = Eq.Instance.Instance, Thread = Eq.Thread}) or Eq.Instance
                    if res1 ~= nil then
                        if Eq.Index ~= nil and Utility.tof(Eq.Index) ~= Utility.numbertxt then
                            Compile(Entity,{[Eq.Index] = res1},Eq.Thread)
                        else
                            if res2 ~= nil then
                                Compile(Entity,{[res1] = res2},Eq.Thread)
                            else
                                Compile(Entity, (Utility.tof(res1) == Utility.tabletxt and res1.__type == nil and res1) or {res1} ,Eq.Thread)
                            end
                        end
                    else
                        Utility.CallDestroy(Eq.Thread)
                        Eq.Thread = nil;
                    end

                end
            end
        else
            func(...)
        end
    end
    if Connections ~= nil then
        if new.Connections == nil then
            new.Connections = {Count = 0}
        end
        if Utility.tof(Connections) == Utility.tabletxt and Connections[connecttxt] == nil then
            for _,v: RBXScriptSignal in ipairs(Connections) do
                new.Connections[new.Connections.Count + 1] = v:Connect(new.receiverFunc,new.Connections)
                new.Connections.Count += 1;
            end
        else
            new.Connections[new.Connections.Count + 1] = Connections:Connect(new.receiverFunc,new.Connections)
            new.Connections.Count += 1;
        end
    end
end