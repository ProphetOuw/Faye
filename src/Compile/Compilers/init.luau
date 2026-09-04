local tins, tf, tr = table.insert, table.find, table.remove
local tof = typeof
local tc = table.clear
local repeatedCompile = require(script.repeatedCompile)
local Utility = require(script.Parent.Parent.Misc.FayeUtility)
local m = {
	SetTo = function(Entity,_, Value)
		if Value.Value ~= nil and Value.Value["Set"] ~= nil then
			Value.Value:Set(Entity)
		end
	end,
	YieldSafe = function(Entity, Index, Value, Compile)
		local Thread = Entity.CleanThread or Entity.Thread;
		local taskthread;
		local Yielded = false;
		local mainFunc = function()
			local res1,res2 = Value.func(Thread,Entity.Instance)
			Yielded = true;
			if res1 ~= nil then
				if Index ~= nil and Utility.tof(Index) ~= Utility.numbertxt then
					Compile(Entity,{[Index] = res1})
				else
					if res2 ~= nil then
						Compile(Entity,{[res1] = res2})
					else
						Compile(Entity, (Utility.tof(res1) == Utility.tabletxt and res1.__type == nil and res1) or {res1})
					end
				end
			end
			if taskthread ~= nil and Thread ~= nil then
				
				Utility.RemoveFromThread(Thread,taskthread)
			end
		end
		taskthread = (Value.DelayTime ~= nil and task.delay(Value.DelayTime,mainFunc)) or task.spawn(mainFunc)
		if Thread ~= nil and Yielded == false then
			if Thread._isCleanAncestor then
				local CurrentPos = Thread
				while CurrentPos ~= nil do
					if CurrentPos._hc then
						break;
					end
					CurrentPos = CurrentPos.ParentThread;
				end
				Thread = CurrentPos or Thread;
			end
			Utility.AddToThread(Thread,taskthread)
		end
	end,
	Instance = function(Entity, Index, Value, Compile, From)
		local Props = Value.Props
		local Thread = Entity.Thread
		local CleanThread = Entity.CleanThread
		if Props ~= nil then
			--#thu 17 2025
			if CleanThread ~= nil and CleanThread ~= Thread and ((Value.Props.OnClean == nil and Value.Props.CleanDelay == nil) or CleanThread._isCleanAncestor) then
				if Thread["Remove"] then
					Thread:Remove(Value)
				else
					local pos = tf(Thread, Value)
					if pos ~= nil then
						tr(Thread, pos)
					end
				end
				if CleanThread["Add"] then
					CleanThread:Add(Value)
				else
					tins(CleanThread, Value)
				end
				Value.CleanThread = CleanThread
			end
			if Props.Parent == nil then
				Props.Parent = Entity.Instance
			end
			Value:Compile()
		end
	end,
	OnChanged = function(Entity, Index, Value, Compile, Init)
		local Instance = Entity.Instance
		local Thread = Entity.CleanThread or Entity.Thread;
		if Init == true then
			local Ret,Ret2 = Value(Instance, Instance[Index])
			if Ret ~= nil then
				repeatedCompile(Index, --[[Thread, ]]Ret, Ret2, Compile, Entity)
				Ret = nil
			end
		end
		local Signal = Instance:GetPropertyChangedSignal(Index)
		local func = function()
			if not ((Thread.ParentThread == nil and Thread.IsActive) or Thread.ParentThread.IsActive) then return end;
			local Ret,Ret2 = Value(Instance, Instance[Index])
			if Ret ~= nil then
				repeatedCompile(Index, --[[Thread, ]]Ret, Ret2, Compile, Entity)
				Ret = nil
			end
		end
		if not Utility.ConnectToEntity(Entity,Signal, func) then
			Utility.Connect(Signal,func,Thread)
		end
	end,
	GetSignal = require(script.GetSignal);
	EventCompiler = function(Entity, Index, Value, Compile)
		local Thread = Entity.CleanThread or Entity.Thread;
		local Instance = Entity.Instance;
		local Signal = Instance[Index]
		local func = function(...)
			if not ((Thread.ParentThread == nil and Thread.IsActive) or Thread.ParentThread.IsActive) then return end;
			local Ret,Ret2 = Value(Instance, ...)
			if Ret ~= nil then
				repeatedCompile(Index, --[[Thread, ]]Ret, Ret2, Compile, Entity)
				Ret = nil
			end
		end
		if not Utility.ConnectToEntity(Entity,Signal, func) then 
			Utility.Connect(Signal,func,Thread)
		end;
	end,
	Signal = require(script.CompileSignal),

	Iterate = require(script.CompileIterate),

	--<Do/State
	State = require(script.CompileState); -- covers both Do and State
	--> Do/State
	SpecialThread = require(script.CompileSpecialThread);
	
	DelayProperty = function(Entity, Index, Value, Compile)
		local Init = Value.Init
		local ToCompile = Value.ToCompile
		if Init ~= nil then
			if tof(Init) == Utility.tabletxt and Init.__type == nil then
				Compile(Entity, Init)
				tc(Init)
			else
				Compile(Entity, { [Index] = Init })
			end
			Init = nil
		end
		task.delay(Value.Time, function()
			if Entity ~= nil and Entity.Instance ~= nil then
				if tof(ToCompile) == Utility.tabletxt and ToCompile.__type == nil then
					Compile(Entity, ToCompile)
					tc(ToCompile)
				else
					Compile(Entity, { [Index] = ToCompile })
				end
				ToCompile = nil
			end
		end)
	end,
	Animation = require(script.CompileAnimations);
	Lerp = require(script.CompileLerp);
	Value = require(script.CompileValue)
}

return m
