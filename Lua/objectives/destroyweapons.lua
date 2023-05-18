local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "DestroyWeapons"
objective.AmountPoints = 750

function objective:Start(target)
    self.Items = {}
    for key, value in pairs(Submarine.MainSub.GetItems(false)) do
        if value.HasTag("weapon") then
            table.insert(self.Items, value)
            cool = value
        end
    end

    self.Amount = math.min(3, #self.Items)

    if self.Amount == 0 then return false end

    self.Text = string.format("Deconstruct " .. self.Amount .. " weapons.", self.TargetName)

    return true
end

function objective:IsCompleted()
    local destroyed = 0
    for key, value in pairs(self.Items) do
        if value.Removed and value.Condition > 50 then
            destroyed = destroyed + 1
        end
    end

    if destroyed >= self.Amount then
        return true
    end

    return false
end

return objective
