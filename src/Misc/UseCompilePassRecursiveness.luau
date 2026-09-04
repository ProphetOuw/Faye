local Utility = require(script.Parent.FayeUtility);
local Types = require(script.Parent.Parent.FayeTypes)

return function (Compile: any,  res1: any,res2: any,Entity: Types.FayeInstance, Thread: Types.Thread)
	if res1 == nil and res2 == nil then return end;
	local NewCompile
	if res2 == nil and res1 ~= nil then
		NewCompile = (Utility.tof(res1) == Utility.tabletxt and res1.__type == nil and res1) or {res1}
	elseif res1 ~= nil and res2 ~= nil then
		NewCompile = {[res1] = res2}
	end
	if NewCompile ~= nil then
		Compile(Entity, NewCompile, Thread or (Entity.CleanThread or Entity.Thread) )
	end;

	NewCompile = nil;
end