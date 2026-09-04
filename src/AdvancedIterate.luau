local Types = require(script.Parent.FayeTypes)
local typetxt = "Iterate";
--[=[
    @method AdvancedIterate
    @within Thread
    @param Tab any
    @param Func (Index: any,Value: any,Thread: Types.Thread?,Entity: Instance?) -> ()
    Creates a reactive iterator that reacts to the table's individually changes and updates them accordingly.
]=]
return function(Tab: any,Func: (Index: any,Value: any,Thread: Types.Thread?,Entity: Instance?) -> ())
    local Iterate = {
        Tab = Tab,
        Function = Func,
        __type = typetxt,
        Advanced = true;
    }
    
    return Iterate;
end