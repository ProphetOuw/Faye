local m = {tof = typeof,max = math.max, tr = table.remove, tf = table.find, tins = table.insert,tc = table.clear,

tabletxt = "table",numbertxt = "number",instanceTxt = "Instance",valueBaseTxt = "ValueBase",functiontxt = "function"}
local Types = require(script.Parent.Parent.FayeTypes)
local Clean = require(script.Parent.Parent.Clean)
local AddTxt = "Add";
local RemoveTxt = "Remove";
local ConnectTxt = "Connect"
local DestroyTxt = "Destroy"
function m.RemoveFromThread(Thread: Types.Thread, Item: any)
    if Thread == nil or Item == nil then return end;
    if Thread[RemoveTxt] then
        Thread:Remove(Item)
    else
        local f = m.tf(Thread,Item)
        if f ~= nil then
            m.tr(Thread,f)
        end
    end
end
function m.ConnectToEntity(Instance: Types.FayeInstance, Connection: RBXScriptSignal, Function: (...any) -> ())
    if Instance == nil then return false end;
    if Instance[ConnectTxt] ~= nil then
        Instance:Connect(Connection,Function)
        return true;
    else
        return false;
    end
end
function  m.AddToEntity(Instance: Types.FayeInstance, Item: any): boolean
    if Instance == nil then return false end;
    if Instance[AddTxt] then
        Instance:Add(Item)
        return true
    else
        return false;
    end
end
function m.RemoveFromEntity(Instance: Types.Thread, Item: any): boolean
    if Instance == nil or Item == nil then return false end;
    if Instance[RemoveTxt] then
        Instance:Remove(Item)
        return true;
    else
        return false;
    end
end
function m.Connect(Signal: RBXScriptSignal,Function: (...any) -> (),Thread: Types.Thread?)
    if Signal == nil or Function == nil then return end;
    local Connect = Signal:Connect(Function)
    if Thread ~= nil then
        if Thread[ConnectTxt] then
            Thread:Connect(Signal,Function)
        elseif Thread[AddTxt] then
            Thread:Add(Connect)
        else
            m.tins(Thread,Connect)
        end
    else
        Connect:Connect(Function)
    end
end
function m.CallDestroy(Item: any)
    if Item == nil then return end;
    if Item[DestroyTxt] then
        Item:Destroy();
    else
        Clean(Item)
    end
end
function m.TableRemove(Table: {[any]: any}, Item: any)
    if Table == nil or Item == nil then return end;
    local f = m.tf(Table,Item)
    if f ~= nil then
        m.tr(Table,f)
    end
    f = nil;
end
function  m.AddToThread(Thread: Types.Thread, Item: any)
    if Thread == nil or Item == nil then return end;
    if Thread[AddTxt] then
        Thread:Add(Item)
    else
        m.tins(Thread,Item)
    end
end
local disconnecttxt = "Disconnect"
function m.ClearAllConnections(Connections: {[number]: RBXScriptConnection},connectionsNumb: number?)
    for i = connectionsNumb or #Connections,1,-1 do
        if Connections[i] ~= nil and Connections[i][disconnecttxt] ~= nil then
            Connections[i]:Disconnect();
        end
        Connections[i] = nil;
    end
end
local ValueClasses = require(script.Parent.ValueClasses)
function m.GetValue(Info: Types.Value)
    if Info == nil then return end;
    if m.tof(Info) == m.tabletxt and Info.__type ~= nil and ValueClasses[Info.__type] then
        return m.GetValue(Info:Get())
    else
        return Info
    end
end
return m;