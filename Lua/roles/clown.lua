local role = Traitormod.RoleManager.Roles.Antagonist:new()
role.Name = "Clown"

function role:ConvertLoop(first)
    if not Game.RoundStarted then return end
    if self.RoundNumber ~= Traitormod.RoundNumber then return end

    local this = self

    local convert = Traitormod.RoleManager.Objectives.ClownConvert:new()
    convert:Init(self.Character)
    local target = self:FindValidTarget(convert)
    if not self.Character.IsDead and convert:Start(target) then
        self:AssignObjective(convert)

        local num = self:CompletedObjectives("ClownConvert")
        convert.AmountPoints = convert.AmountPoints + (num * self.PointsPerAssassination)

        local client = Traitormod.FindClientCharacter(self.Character)

        convert.OnAwarded = function()
            if client then
                Traitormod.SendMessage(client, Traitormod.Language.ClownConvertNextTarget, "")
                Traitormod.Stats.AddClientStat("TraitorMainObjectives", client, 1)
            end

            local delay = math.random(this.NextObjectiveDelayMin, this.NextObjectiveDelayMax) * 1000
            Timer.Wait(function(...)
                this:ConvertLoop()
            end, delay)
        end


        if client and not first then
            Traitormod.SendMessage(client, string.format(Traitormod.Language.ClownConvertNewObjective, target.Name),
                "GameModeIcon.pvp")
            Traitormod.UpdateVanillaTraitor(client, true, self:Greet())
        end
    else
        Timer.Wait(function()
            this:ConvertLoop()
        end, 5600)
    end
end

function role:Start()
    Traitormod.Stats.AddCharacterStat("Traitor", self.Character, 1)

    self:ConvertLoop(true)

    local pool = {}
    for key, value in pairs(self.SubObjectives) do pool[key] = value end

    local toRemove = {}
    for key, value in pairs(pool) do
        local objective = Traitormod.RoleManager.FindObjective(value)
        if objective ~= nil and objective.AlwaysActive then
            objective = objective:new()

            local character = self.Character

            objective:Init(character)
            objective.OnAwarded = function ()
                Traitormod.Stats.AddCharacterStat("TraitorSubObjectives", character, 1)
            end

            if objective:Start(character) then
                self:AssignObjective(objective)
                table.insert(toRemove, key)
            end
        end
    end
    for key, value in pairs(toRemove) do table.remove(pool, value) end

    for i = 1, math.random(self.MinSubObjectives, self.MaxSubObjectives), 1 do
        local objective = Traitormod.RoleManager.RandomObjective(pool)
        if objective == nil then break end

        objective = objective:new()

        local character = self.Character

        objective:Init(character)
        local target = self:FindValidTarget(objective)

        objective.OnAwarded = function ()
            Traitormod.Stats.AddCharacterStat("TraitorSubObjectives", character, 1)
        end

        if objective:Start(target) then
            self:AssignObjective(objective)
            for key, value in pairs(pool) do
                if value == objective.Name then
                    table.remove(pool, key)
                end
            end
        end
    end

    local text = self:Greet()
    local client = Traitormod.FindClientCharacter(self.Character)
    if client then
        Traitormod.SendTraitorMessageBox(client, text)
        Traitormod.UpdateVanillaTraitor(client, true, text)
    end
end


function role:End(roundEnd)
    local client = Traitormod.FindClientCharacter(self.Character)
    if not roundEnd and client then
        Traitormod.SendMessage(client, Traitormod.Language.TraitorDeath, "InfoFrameTabButton.Traitor")
        Traitormod.UpdateVanillaTraitor(client, false)
    end
end

---@return string mainPart, string subPart
function role:ObjectivesToString()
    local primary = Traitormod.StringBuilder:new()
    local secondary = Traitormod.StringBuilder:new()

    for _, objective in pairs(self.Objectives) do
        -- Assassinate objectives are primary
        local buf = objective.Name == "ClownConvert" and primary or secondary

        if objective:IsCompleted() then
            buf:append(" > ", objective.Text, Traitormod.Language.Completed)
        else
            buf:append(" > ", objective.Text, string.format(Traitormod.Language.Points, objective.AmountPoints))
        end
    end
    if #primary == 0 then
        primary(" > No objectives yet... Stay futile.")
    end

    return primary:concat("\n"), secondary:concat("\n")
end

function role:Greet()
    local partners = Traitormod.StringBuilder:new()
    local traitors = Traitormod.RoleManager.FindAntagonists()
    for _, character in pairs(traitors) do
        if character ~= self.Character then
            partners('"%s" ', character.Name)
        end
    end
    partners = partners:concat(" ")
    local primary, secondary = self:ObjectivesToString()

    local sb = Traitormod.StringBuilder:new()
    sb("You are apart of Honkmother's children. Prove yourself worthy.\n\n")
    sb("Your main objectives are:\n")
    sb(primary)
    sb("\n\nYour secondary objectives are:\n")
    sb(secondary)
    sb("\n\n")
    if #traitors < 2 then
        sb("You are the only clown.")
    elseif self.TraitorMethodCommunication == "Names" then
        sb("Fellow clowns: %s\n", partners)

        if self.TraitorBroadcast then
            sb("Use !tc to communicate with your fellow clowns.")
        end
    elseif self.TraitorMethodCommunication == "Codewords" then
        sb("Use code words the find your partners\n")
        sb("Code Words: ")
        for key, value in pairs(Traitormod.CodeWords[1]) do
            sb("\"%s\" ", value)
        end
        sb("\nCode Responses: ")
        for key, value in pairs(Traitormod.CodeWords[2]) do
            sb("\"%s\" ", value)
        end
    end

    return sb:concat()
end

function role:OtherGreet()
    local sb = Traitormod.StringBuilder:new()
    local primary, secondary = self:ObjectivesToString()
    sb("Honkmotherian %s.", self.Character.Name)
    sb("\nTheir main objectives were:\n")
    sb(primary)
    sb("\nTheir secondary objectives were:\n")
    sb(secondary)
    return sb:concat()
end

function role:FilterTarget(objective, character)
    if not self.SelectBotsAsTargets and character.IsBot then return false end

    if objective.Name == "ClownConvert" and self.SelectUniqueTargets then
        for key, value in pairs(Traitormod.RoleManager.FindCharactersByRole("Clown")) do
            local targetRole = Traitormod.RoleManager.GetRole(value)

            for key, obj in pairs(targetRole.Objectives) do
                if obj.Name == "ClownConvert" and obj.Target == character then
                    return false
                end
            end
        end
    end

    if character.TeamID ~= CharacterTeamType.Team1 and not self.SelectPiratesAsTargets then
        return false
    end

    return Traitormod.RoleManager.Roles.Antagonist.FilterTarget(self, objective, character)
end

return role
