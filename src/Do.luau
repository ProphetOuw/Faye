local Types = require(script.Parent.FayeTypes)
local typetxt = "State";
--[=[
    @method Do
    @within Thread
    @param func (Grab: any, Thread: Thread, Entity: Instance?) ->
    @return Do
    Creates a Do object that can be used in Faye's threading system to execute functions.
]=]
return function(Function: (Grab: any,Thread: Types.Thread,Entity: Instance?) -> any)
    local new = {Func = Function, __type = typetxt};
    return new;
end