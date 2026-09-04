local Types = require(script.Parent.Parent.Parent.FayeTypes)
local Utility = require(script.Parent.Parent.Parent.Misc.FayeUtility)


return function (Instance: Types.FayeInstance,Index, Signal: Types.Signal)
    local Thread = Instance.CleanThread or Instance.Thread;
    local Entry = {Instance = Instance, Index = (Utility.tof(Index) ~= Utility.numbertxt and Index) or nil}
    local EqThread
    local Delete; Delete = function()
        --| remove from entries
        if Signal ~= nil and Signal.Entries ~= nil then
            local position = Utility.tf(Signal.Entries,Entry)
            if position ~= nil then
                Utility.tr(Signal.Entries,position)
                Signal.Entries.Count -= 1;
                if Signal.Entries.Count == 0 then
                    Signal.Entries.Count = nil;
                    Signal.Entries = nil;
                end
            end
        end
        --|>

        --<
        Utility.RemoveFromEntity(Instance,Delete)
        Utility.RemoveFromThread(EqThread,Delete)
        -->

        --| Delete entry
        if Entry ~= nil then
            if Entry.Thread ~= nil then
                Utility.CallDestroy(Entry.Thread)
                Entry.Thread = nil;
            end
            Utility.tc(Entry)
            Entry = nil;
        end
        --|>
    end
    if Signal.Entries == nil then
        Signal.Entries = {Count = 0};
    end
    Signal.Entries[Signal.Entries.Count + 1] = Entry
    Signal.Entries.Count += 1;
    Utility.AddToEntity(Instance,Delete)
    if Thread ~= nil then
        EqThread = Thread;
        if EqThread._isCleanAncestor then
            local CurrentPos = EqThread
            while CurrentPos ~= nil do
                if CurrentPos._hc then
                    break;
                end
                CurrentPos = CurrentPos.ParentThread;
            end
            EqThread = CurrentPos or EqThread;
        end
        Utility.AddToThread(EqThread,Delete)
    end
end