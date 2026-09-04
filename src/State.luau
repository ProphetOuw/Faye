local Types = require(script.Parent.FayeTypes)
local typetxt = script.Name;

--[=[
    @method State
    @within Thread
    @param func (Grab: any, Thread: Thread, Entity: Instance?) -> ()
    @return State
    Creates a State object that can be used in Faye's reactive system, it deletes the old components before loading the new ones.
]=]

return function(Function: (Grab: any,Thread: Types.Thread,Entity: Instance?) -> ())
    local new = {Func = Function, __type = typetxt,IsState = true};
    return new;
end