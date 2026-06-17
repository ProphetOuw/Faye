local Types = require(script.Parent.FayeTypes)
--[=[
    @method GetSignal
    @within Thread
    @param Method string
    @param Index string
    @param RunOnInitialization boolean?
    Listener for methods, example: 'GetPropertyChangedSignal', 'GetAttributeChangedSignal', etc.
]=]
local typetxt = script.Name;
return function (Method: string,Index: string, RunOnInitialization: boolean?, Thread: Types.Thread?)
    if Method == nil or Index == nil then return end;
    return {Method = Method,Index = Index,RunOnInitialization = RunOnInitialization,Thread = Thread, __type = typetxt};
end