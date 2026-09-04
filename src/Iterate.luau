local Types = require(script.Parent.FayeTypes)
local typetxt = script.Name;
--[=[
    @method Iterate
    @within Thread
    @param Tab any
    @param Func (Index: any, Value: any, Thread: Thread?, Entity: Instance?) -> ()
    @return Iterate
    Creates a reactive iterator, when the value changes it refreshes the entire thing.
]=]
return function(Tab: any,Func: (Index: any,Value: any,Thread: Types.Thread?,Entity: Instance?) -> (),Thread: Types.Thread)
    local Iterate = {
        Tab = Tab,
        Function = Func,
        __type = typetxt,
    }
    
    return Iterate;
end