local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "ClownConvert"
objective.AmountPoints = 850
function objective:Start(target)
    self.Target = target

    if self.Target == nil then return false end

    self.Text = string.format(Traitormod.Language.ObjectiveConvert, self.Target.Name)

    return true
end

function objective:IsCompleted()
    return self.Target.IsDead and character.Inventory.GetItemInLimbSlot(InvSlotType.Head).Prefab.Identifier == "clownmask"
end

return objective