local Types = require(script.Parent.FayeTypes)
local Defaults = require(script.Defaults)
local tins = table.insert
local tof = typeof
local mt = require(script.Parent.Misc.FayeInstance)
--[=[
    @method Create
    @within Thread
    @param ClassName CreatableClassName | string
    @return (props: PropertyTypes.Property) -> Create
    [Creates a new instance object.](/docs/Instancing/Create)
]=]
local functiontxt,tabletxt,cleandelaytxt,parenttxt,numbertxt,instancetxt =
	"function", "table", "CleanDelay", "Parent", "number","Instance"
type CreateThread = { Add: (self: {}, Entity: any, IsPriority: boolean?) -> () }
-- CreatableClassName drives editor suggestions; the string half keeps arbitrary class names valid
return function(ClassName: Types.CreatableClassName | string, Thread: CreateThread?) : (props: Types.Properties) -> Types.FayeInstance
	return function(props: Types.Properties)
		local Object = Instance.new(ClassName)
		if Defaults[ClassName] ~= nil then
			Defaults[ClassName](Object)
		end

		local Simple = true
		if props.Properties ~= nil then
			for i, v in pairs(props.Properties) do
				props[i] = v
			end
			props.Properties = nil
		end
		for i, v in pairs(props) do
			local tov = tof(v)
			if tov ~= functiontxt and tov ~= tabletxt and not (tov == instancetxt and v:IsA("ValueBase") ) and i ~= cleandelaytxt and i ~= parenttxt and tof(i) ~= numbertxt then
				Object[i] = v
				props[i] = nil
			else
				Simple = false
			end
		end

		if Simple then
			return Object
		else
			local Wrapper = setmetatable({
				Instance = Object,
				Props = props,
				Thread = Thread,
			},mt)
			if props.Parent then
				Wrapper:Compile()
			end
			if Thread ~= nil then
				if Thread["Add"] then
					Thread:Add(Wrapper,true)
				else
					tins(Thread, Wrapper)
				end
			end
			return Wrapper
		end
	end
end
