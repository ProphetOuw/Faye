local ValueClasses = require(script.Parent.Parent.Parent.Misc.ValueClasses)
local Types = require(script.Parent.Parent.Parent.FayeTypes)
local Utility = require(script.Parent.Parent.Parent.Misc.FayeUtility)

local tabletxt,niltxt,numbertxt,stringtxt,instancetxt,ValueBasetxt = "table","nil","number","string","Instance","ValueBase";
return function (Entity: Types.FayeInstance, Index: any, Value: Types.Value)
    local Instance = Entity.Instance or Entity

    local connectionslength = 0;
    local connections = {};

    local mainFunc; mainFunc = function(Gotten: any,Position: number?)
        local GottenType = Utility.tof(Gotten)
        local gottenIsTable = GottenType == tabletxt
        local gottenIsInstance = not gottenIsTable and GottenType == instancetxt and Gotten:IsA(ValueBasetxt)
        Position = Position or 1;
        if gottenIsInstance or (gottenIsTable and Gotten.__type ~= nil and ValueClasses[Gotten.__type]) then
            connectionslength = Position;
            connections[Position] = Gotten.Changed:Connect(function(new)
                if connectionslength > Position then
                    for i = connectionslength,Position+1,-1 do
                        connections[i]:Disconnect();
                        connections[i] = nil;
                    end
                end
                connectionslength = Position;
                mainFunc(new,Position + 1)
            end,connections)
            mainFunc( (gottenIsInstance and Gotten.Value) or Gotten:Get(),Position + 1)
        else
             if Entity ~= nil and Instance ~= nil then
                if gottenIsTable then
                    Gotten = Gotten.Instance or Gotten
                end
                local tofIndex = Utility.tof(Instance[Index])
                local tofNew = Utility.tof(Gotten)
                if tofIndex == tofNew or (tofIndex == niltxt and tofNew ~= nil) or ((tofIndex == numbertxt or tofIndex == stringtxt) and (tofNew == numbertxt or tofNew == stringtxt)) then
                    Instance[Index] = Gotten
                end
                tofIndex = nil
                tofNew = nil
            end
        end
    end
    mainFunc(Value)
    local Thread = Entity.CleanThread or Entity.Thread
    local ValueConnection
    local clean; clean = function()
        if ValueConnection ~= nil then
            ValueConnection:Disconnect();
            ValueConnection = nil;
        end
        Utility.RemoveFromEntity(Entity,clean)
        if Thread ~= nil then
            Utility.RemoveFromThread(Thread,clean)
        end;
        Thread = nil;
        if connections ~= nil then
            Utility.ClearAllConnections(connections,connectionslength)
            Utility.tc(connections)
            connections = nil;
        end;
    end
    if Value.ClassName ~= nil then
        ValueConnection = Value:GetPropertyChangedSignal("Parent"):Connect(function()
            if Value == nil or Value.Parent == nil then
                clean()
            end
        end)
    end
    if Thread ~= nil then
        Utility.AddToThread(Thread,clean)
    end
    Utility.AddToEntity(Entity,clean)
end