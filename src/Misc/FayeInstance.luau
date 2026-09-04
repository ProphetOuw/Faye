local ValueClasses = require(script.Parent.Parent.Misc.ValueClasses)
local Compilers = require(script.Parent.Parent.Compile.Compilers)
local Compile = require(script.Parent.Parent.Compile)
local Clean = require(script.Parent.Parent.Clean)
local Types = require(script.Parent.Parent.FayeTypes)
local tof = typeof
local tr = table.remove
local tf = table.find
local tins = table.insert
local functiontxt = "function"
local tabletxt = "table"
local animtxt = "Animation"
local lerptxt = "Lerp"
--Animations/Lerps in a direct props table were registered on the creating thread at build
--time; mark them so that thread's cleanup sweep skips them - they now belong to the
--CleanThread compile and would otherwise be killed mid exit-animation
local function MarkCleanDescriptors(t)
	for _, v in pairs(t) do
		if tof(v) == tabletxt then
			local vt = v.__type
			if vt == animtxt or vt == lerptxt then
				v.__Destroying = true
			elseif vt == nil then
				MarkCleanDescriptors(v)
			end
		end
	end
end
--OnClean/CleanFunction accept a props table directly or a function returning one
local function RunClean(f, Thread, Entity)
	if tof(f) == tabletxt then
		MarkCleanDescriptors(f)
		return f
	end
	return f(Thread, Entity)
end
local mt = { __type = "Instance" }
mt.__index = mt
--[=[
    @class FayeInstance
    A faye instance class.
]=]
function removefunc(t: Types.Thread, v: any)
	if t == nil or v == nil then
		return
	end
	if t["Remove"] then
		return t:Remove(v)
	else
		local pos = tf(t, v)
		if pos ~= nil then
			tr(t, pos)
		end
	end
	return false
end
--[=[
    @method SetAttribute
    @within FayeInstance
    @param Attribute string
    @param Value any
    @return Create
    Similar to SetAttribute method for roblox instances
]=]
function mt:SetAttribute(Attribute: string, Value: any)
	if self.Instance ~= nil then
		self.Instance:SetAttribute(Attribute,Value)
	end
	return self;
end
--[=[
    @method GetAttribute
    @within FayeInstance
    @param Attribute string
    @return Value
    Similar to the GetAttribute method for roblox instances
]=]
function mt:GetAttribute(Attribute: string)
	if self.Instance ~= nil then
		return self.Instance:GetAttribute(Attribute)
	end
end
--[=[
    @method GetAttributes
    @within FayeInstance
    Similar to the GetAttributes method for roblox instances
]=]
function mt:GetAttributes(Attribute: string)
	if self.Instance ~= nil then
		return self.Instance:GetAttributes()
	end
end

--[=[
    @method AddTag
    @within FayeInstance
    @param Tag string
    Similar to the AddTag method for roblox instances
]=]
function mt:AddTag(Tag: string)
	if self.Instance ~= nil then
		self.Instance:AddTag(Tag)
	end
	return self;
end
--[=[
    @method RemoveTag
    @within FayeInstance
    @param Tag string
    Similar to the RemoveTag method for roblox instances
]=]
function mt:RemoveTag(Tag: string)
	if self.Instance ~= nil then
		self.Instance:RemoveTag(Tag)
	end
	return self;
end
--[=[
    @method HasTag
    @within FayeInstance
    @param Tag string
    Similar to the HasTag method for roblox instances
]=]
function mt:HasTag(Tag: string)
	if self.Instance ~= nil then
		return self.Instance:HasTag(Tag)
	end
end
--[=[
    @method GetTags
    @within FayeInstance
    Similar to the GetTags method for roblox instances
]=]
function mt:GetTags()
	if self.Instance ~= nil then
		return self.Instance:GetTags()
	end
end
--[=[
    @method Clone
    @within FayeInstance
    Clone the roblox object(Not faye Instance)
]=]
function mt:Clone()
	if self.Instance ~= nil then
		return self.Instance:Clone();
	end
end
--[=[
    @method Compile
    @within FayeInstance
    Compiles the properties of the instance.
]=]

local repCompile = require(script.Parent.UseCompile)
function mt:Compile()
	local Props = self.Props
	if Props ~= nil then
		local AddClean = nil
		local ThreadUsing = self.CleanThread or self.Thread;
		local PropsOrCleanCheck = Props.CleanDelay ~= nil or Props.OnClean ~= nil
		if (ThreadUsing ~= nil and (ThreadUsing._hc or ThreadUsing._isCleanAncestor) ) and PropsOrCleanCheck and self.CleanThread ~= nil and self.CleanThread._isCleanAncestor and ThreadUsing.ParentThread ~= nil then
			if Props.CleanFunction == nil and Props.OnClean ~= nil then
				AddClean = true;
				Props.CleanFunction = Props.OnClean
			end
			Props.CleanDelay = nil;
			Props.OnClean = nil;
		else
			if PropsOrCleanCheck then
				if self.Thread ~= nil then
					self.Thread._hc = true --hc = hasclean
					self.Thread._isCleanAncestor = true
				end
				if self.CleanThread == nil then
					self.CleanThread = (self.Thread ~= nil and self.Thread:Extend(true)) or {}
					self.CleanThread._isCleanAncestor = true
				end

				if Props.CleanDelay ~= nil then
					self.CleanDelay = Props.CleanDelay
					Props.CleanDelay = nil
				end
				if Props.OnClean ~= nil then
					self.OnClean = Props.OnClean
					Props.OnClean = nil
				end
				if Props.CleanFunction ~= nil then
					AddClean = true
				end
				if Props.CleanFunction ~= nil then
					AddClean = true
				end
			elseif Props.CleanFunction ~= nil or Props.OnClean ~= nil then
				if Props.CleanFunction == nil and Props.OnClean ~= nil then
					Props.CleanFunction = Props.OnClean
				end
				Props.OnClean = nil;
				Props.CleanDelay = nil;
				AddClean = true;
			end
		end

		PropsOrCleanCheck = nil;
		ThreadUsing = nil;
		if AddClean == true then
			if (self.Thread ~= nil and self.Thread._isCleanAncestor) and self.CleanDelay == nil then
				local f = Props.CleanFunction
				local connected;
				local CleanThread = self.CleanThread or self.Thread;
				local Instance = self.Instance;
				local cf; cf = function()
					if f == nil then
						return
					end
					if self.Cache ~= nil then
						self:ClearCache()
					end
					local res1,res2 = RunClean(f, CleanThread, Instance)
					repCompile(res1,res2,self)
					removefunc(connected,cf)
					f = nil
					cf = nil
					connected = nil;
				end
				local eq = self.Thread
				if eq.ParentThread ~= nil then
					local current = eq
					while current ~= nil do
						if current._hc then
							break
						end
						current = current.ParentThread
					end
					eq = current or eq;
				end
				eq:Add(cf)
				connected = eq;
			else
				self.CleanFunction = Props.CleanFunction
			end
		end
		AddClean = nil
		Props.CleanFunction = nil
		Props.CleanDelay = nil
		if Props.Parent ~= nil then
			local Parent = Props.Parent
			Props.Parent = nil
			local eqistable = typeof(Parent) == "table"
			local EqType = (
				eqistable and (Parent.__type ~= nil and ((ValueClasses[Parent.__type] and "Value") or Parent.__type))
			) or nil
			if EqType ~= nil and EqType ~= "Instance" then
				Compilers[EqType](self, "Parent", Parent)
			else
				if eqistable then
					self.Instance.Parent = Parent.Instance or Parent
				else
					self.Instance.Parent = Parent
				end
			end
		end
		self.Props = nil
		Compile(self, Props)
	else
		self:Destroy()
	end
	return self;
end

--[=[
    @method Destroy
    @within FayeInstance
    Destroys the instance.
]=]
local CleanPortion = require(script.Parent.CleanPortion)
--|<
function mt:ClearCache()
	if self.Cache == nil then return end;
	if self.Cache.Priority ~= nil then
		CleanPortion(self.Cache.Priority)
		self.Cache.Priority = nil;
	end
	CleanPortion(self.Cache)
	self.Cache = nil;
end
function mt:Connect(Connection: RBXScriptSignal, Function: (...any) -> ())
	return self:Add(Connection:Connect(Function),true)
end
function mt:Add(Item: any,IsPriority: boolean?)
	if self.Cache == nil then
		self.Cache = {};
	end
	if IsPriority then
		if self.Cache.Priority == nil then
			self.Cache.Priority = {};
		end
		if tof(Item) == tabletxt and Item.__simplesignalconnection and Item.lists == nil then
			Item.lists = self.Cache.Priority;
		end
		tins(self.Cache.Priority,Item)
	else
		tins(self.Cache,Item)
	end
	
	return Item;
end

function mt:Remove(Item: any)
	if self.Cache ~= nil then
		local Pos = tf(self.Cache,Item)
		if Pos ~= nil then
			tr(self.Cache,Pos)
		else
			if self.Cache.Priority ~= nil then
				Pos = tf(self.Cache.Priority,Item)
				if Pos ~= nil then
					tr(self.Cache.Priority,Item)
				end
			end
		end
	end
end
--|>


function mt:Destroy()
	local Removed = false;
	if self.Thread ~= nil then
		if self.Thread["Remove"] then
			Removed = self.Thread:Remove(self)
		else
			local Find = tf(self.Thread, self)
			if Find ~= nil then
				tr(self.Thread, Find)
				Removed = true;
			end
		end
	end
	if not Removed and self.CleanThread ~= nil then
		if self.CleanThread["Remove"] then
			self.CleanThread:Remove(self)
		else
			local Find = tf(self.CleanThread, self)
			if Find ~= nil then
				tr(self.CleanThread, Find)
			end
		end
	end
	Removed = nil;
	--< clear cache
	if self.Cache ~= nil then
		self:ClearCache();
	end
	-->

	--| clean function
	if self.CleanFunction ~= nil then
		local res1,res2 = RunClean(self.CleanFunction, self.CleanThread or self.Thread, self.Instance)
		repCompile(res1,res2,self)
	end
	--|> clean function

	
	if self.OnClean ~= nil then
		if self.CleanThread["Add"] then
			self.CleanThread:Add(self.Instance)
		else
			table.insert(self.CleanThread, self.Instance)
		end
		local res1,res2 = RunClean(self.OnClean, self.CleanThread, self.Instance)
		repCompile(res1,res2,self)
		if self.CleanThread ~= nil then
			if self.CleanThread.AnimationsAmount == nil or self.CleanThread.AnimationsAmount <= 0 then
				Clean(self.CleanThread)
			else
				self.CleanThread.CleanWhenDone = true
			end
			self.CleanThread = nil
		end
		self.Instance = nil
		self.OnClean = nil
	else
		if self.CleanDelay ~= nil then
			local delaytime = self.CleanDelay
			if tof(delaytime) == functiontxt then
				delaytime = delaytime(self.CleanThread,self.Instance)
			end

			task.delay(delaytime, function()
				self.Instance:Destroy()
				self.Instance = nil
				Clean(self.CleanThread)
				self.CleanFunction = nil
				self.OnClean = nil
				self.CleanThread = nil
			end)
			self.CleanDelay = nil
		else
			self.Instance:Destroy()
			self.Instance = nil
			self.CleanFunction = nil
			self.OnClean = nil
			self.CleanThread = nil
		end
	end
	self.CleanDelay = nil
	self.Props = nil
	self.Thread = nil
end

local scriptName = script.Name
function mt.__tostring()
	return scriptName;
end
return mt