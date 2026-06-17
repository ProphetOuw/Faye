local to = typeof
local sf = string.find
local sb = string.sub
--local tc = table.clear
local banned = {
    Value = true;
    Lerp = true;
}
local tins = table.insert
local ValueClasses = require(script.Parent.Misc.ValueClasses)
local Compilers = require(script.Compilers)
local tablestr,numberstr,functionstr,RBXScriptSignalstr,stringstr = "table","number","function","RBXScriptSignal","string"
local OnChangedInitstr,OnChangedstr,Valuestr,Instancestr,Addstr,valuebasestr = "OnChangedInit","OnChanged","Value","Instance","Add","ValueBase"
local Aftertxt,BeforeTxt = "After","Before"
local UseCompile = require(script.Parent.Misc.UseCompilePassRecursiveness)
local GetSignalstr = "GetSignal"
-- Caches whether `<ClassName>.<propName>` resolves to an RBXScriptSignal so we don't
-- pay a real Roblox property read on every unknown key in the slow path.
local signalCache = {}
local function Recursive(Entity: {Instance: any, Thread: any, InnerThread: any}, Props: any,InstanceThread: any)
    -- Main loop
    if Props[BeforeTxt] then
        local Beforetype = to(Props.Before)
        if Beforetype == functionstr then
            local r1,r2 = Props.Before(Entity.Instance)
            if r1 ~= nil then
                UseCompile(Recursive, r1,r2,Entity,Entity.InnerThread or Entity.Thread)
            end
        elseif Beforetype == tablestr then
            Recursive(Entity, Props.Before,InstanceThread)
        end
    end
    local deferredSignals = nil
    local Inst = Entity.Instance
    for i, v in Props do
        if i == Aftertxt or i == BeforeTxt then continue end;
        local tov = to(v)
        local toi = --[[tov == "table" and v.__type and to(v.__type) or]] to(i)
        -- Fast path: string-keyed scalar property with no compiler and not an OnChanged signal.
        -- Covers the common `Size = ...`, `BackgroundColor3 = ...`, etc. case in one branch.
        if toi == stringstr and tov ~= tablestr and tov ~= functionstr and tov ~= Instancestr
           and (Compilers[i] == nil or banned[i]) and sb(i, 1, 2) ~= "On" then
            Inst[i] = v
            continue
        end
        local compilerFunc = (toi ~= tablestr and Compilers[i]) or nil
        if compilerFunc and not banned[i] then
            if i == GetSignalstr then
                if deferredSignals == nil then deferredSignals = {} end
                tins(deferredSignals, {i, v})
            else
                compilerFunc(Entity, i, v, Recursive)
            end
        elseif tov == Instancestr then
            --> instance compile
            if toi == numberstr then
                --object parenting
                v.Parent = Inst
                if InstanceThread ~= nil then
                    if InstanceThread[Addstr] ~= nil then
                        InstanceThread:Add(v)
                    else
                        tins(Instance,v);
                    end
                end
            else
                -- supported values
                if v:IsA(valuebasestr) then
                    Compilers.Value(Entity, i, v)
                end
            end
        elseif tov == tablestr then
            local Type = v.__type and (ValueClasses[v.__type] and Valuestr or v.__type)

            if Type and Compilers[Type] then
                Compilers[Type](Entity, i, v, Recursive)
            else
                Recursive(Entity, v,InstanceThread)
            end
        elseif toi == tablestr and Compilers[i.__type] then
            Compilers[i.__type](Entity, i, v, Recursive)
        else
            if tov == functionstr and toi == numberstr then
                local ret,ret2 = v(Inst)
                if ret then
                    UseCompile(Recursive, ret,ret2,Entity,Entity.InnerThread or Entity.Thread)
                end
            else
                local onChangedIndex = sf(i, OnChangedstr, 1, true)
                if onChangedIndex then
                    if deferredSignals == nil then deferredSignals = {} end
                    tins(deferredSignals, {i, v})
                else
                    local className = Inst.ClassName
                    local cache = signalCache[className]
                    if cache == nil then
                        cache = {}
                        signalCache[className] = cache
                    end
                    local isSignal = cache[i]
                    if isSignal == nil then
                        isSignal = to(Inst[i]) == RBXScriptSignalstr
                        cache[i] = isSignal
                    end
                    if isSignal then
                        Compilers.EventCompiler(Entity, i, v, Recursive)
                    elseif tov == functionstr then
                        local result = v(Inst)
                        if result ~= nil then
                            Inst[i] = result;
                        end
                    else
                        Inst[i] = v
                    end
                end
            end
        end
    end
    -- Compile OnChanged/OnChangedInit/GetSignal signals last
    if deferredSignals ~= nil then
        for _, entry in deferredSignals do
            local i, v = entry[1], entry[2]
            if i == GetSignalstr then
                Compilers.GetSignal(Entity, i, v, Recursive)
            else
                local onChangedIndex = sf(i, OnChangedstr, 1, true)
                local prop = sb(i, 1, onChangedIndex - 1)
                local Init = sf(i, OnChangedInitstr, 1, true) ~= nil
                Compilers.OnChanged(Entity, prop, v, Recursive, Init)
            end
        end
    end
    if Props[Aftertxt] then
        local aftertype = to(Props.After)
        if aftertype == functionstr then
            local r1,r2 = Props.After(Entity.Instance)
            if r1 ~= nil then
                UseCompile(Recursive,r1,r2,Entity,Entity.InnerThread or Entity.Thread)
            end
        elseif aftertype == tablestr then
            Recursive(Entity, Props.After,InstanceThread)
        end
    end
    --tc(Props)
end

return function(Entity: {Instance: Instance, Thread: any, InnerThread: any}, Props: {},...)
    Recursive(Entity, Props,...)
end
