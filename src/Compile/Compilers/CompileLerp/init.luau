local LerpPlayer = require(script.LerpPlayer)
local FayeUtility = require(script.Parent.Parent.Parent.Misc.FayeUtility)
local ValueClasses = require(script.Parent.Parent.Parent.Misc.ValueClasses)
local Types = require(script.Parent.Parent.Parent.FayeTypes)
return function (Entity: Types.FayeInstance, Index: any, Value: Types.Lerp)
    if Value.Loaded then
        if Value.Workers == nil then
            Value.Workers = {Count = 0}
            local _, Anim = LerpPlayer.Find(Value.__lerpid)
            if Anim then
                Anim.Workers = Value.Workers
            end
        end
        if Value.From ~= nil then
            Entity.Instance[Index] = Value.From
        end
        Value.Workers.Count += 1
        Value.Workers[Value.Workers.Count] = {Entity = Entity.Instance, Property = Index}
    else
        Value.Loaded = true;
        local Thread = Entity.CleanThread or Entity.Thread;
        local id = Value.__lerpid;
        local goalConnectionsLength,goalConnections
        local InitialGoalType = FayeUtility.tof(Value.To)
        local IsInstanceValue = (InitialGoalType == FayeUtility.instanceTxt and Value.To:IsA(FayeUtility.valueBaseTxt))
        local IsValue = IsInstanceValue or ( InitialGoalType == FayeUtility.tabletxt and Value.To.__type ~= nil and ValueClasses[Value.To.__type])
        local Initial = IsValue
        local Delete; Delete = function(IsReplayable)

            --<
            LerpPlayer.Remove(id)
            if not IsReplayable then
                if Thread ~= nil then
                    FayeUtility.RemoveFromThread(Thread,Delete)
                end
                if goalConnectionsLength ~= nil and goalConnectionsLength > 0 then
                    FayeUtility.ClearAllConnections(goalConnections,goalConnectionsLength)
                end
                Value.Loaded = nil;
                Value.Workers = nil;
                FayeUtility.RemoveFromEntity(Entity,Delete)
            end
            -->
        end
        local function  mainGoalFunc(Goal: any,Position: number?)
            if Goal == nil then return end;

            Position = Position or 1;
            local GaolType = typeof(Goal);
            local IsTable = GaolType == FayeUtility.tabletxt
            local IsInstance = not IsTable and GaolType == FayeUtility.instanceTxt and Goal:IsA(FayeUtility.valueBaseTxt)
            if IsTable or IsInstance then
                if IsInstance or (Goal.__type ~= nil and ValueClasses[Goal.__type]) then
                    if goalConnections == nil then goalConnections = {} end;
                    goalConnectionsLength = Position;
                    goalConnections[Position] = Goal.Changed:Connect(function(NewGoal: any)
                        if goalConnectionsLength > Position then
                            for i = goalConnectionsLength,Position+1,-1 do
                                goalConnections[i]:Disconnect();
                                goalConnections[i] = nil;
                            end
                        end
                        goalConnectionsLength = Position;
                        mainGoalFunc(NewGoal,Position + 1)
                    end,goalConnections)
                    mainGoalFunc((IsInstance and Goal.Value) or Goal:Get(), Position + 1)
                end
            else
                if Entity ~= nil and Entity.Instance ~= nil then
                    if Initial then
                        Entity.Instance[Index] = Goal
                        Initial = false
                    elseif IsValue and Value.From ~= nil and not Value.AppliedFrom then
                        Entity.Instance[Index] = Value.From
                        Value.From = nil
                        Value.AppliedFrom = true;
                        LerpPlayer.Add(id,Entity.Instance,Index,Goal,Value.Factor,IsValue,Delete,Value.Workers)
                    else
                        LerpPlayer.Add(id,Entity.Instance,Index,Goal,Value.Factor,IsValue,Delete,Value.Workers)
                    end
                end
            end
        end
        mainGoalFunc(Value.To)

        
        FayeUtility.AddToEntity(Entity,Delete)
        if Thread ~= nil then
            FayeUtility.AddToThread(Thread,Delete)
        end
    end
end