local event = {}

event.Name = "WreckPirate"
event.MinRoundTime = 1
event.MaxRoundTime = 15
event.MinIntensity = 0
event.MaxIntensity = 1
event.ChancePerMinute = 0.15
event.OnlyOncePerRound = true

event.AmountPoints = 800
event.AmountPointsPirate = 500

event.Start = function ()
    if #Level.Loaded.Wrecks == 0 then
        return
    end

    local wreck = Level.Loaded.Wrecks[1]

    local info = CharacterInfo(Identifier("human"))
    info.Name = "Pirate " .. info.Name
    info.Job = Job(JobPrefab.Get("mechanic"))

    local character = Character.Create(info, wreck.WorldPosition, info.Name, 0, false, true)

    event.Character = character
    event.Wreck = wreck
    event.EnteredMainSub = false

    character.CanSpeak = false
    character.TeamID = CharacterTeamType.Team2
    character.GiveJobItems(nil)

    local idCard = character.Inventory.GetItemInLimbSlot(InvSlotType.Card)
    if idCard then
        idCard.NonPlayerTeamInteractable = true
        local prop = idCard.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
        Networking.CreateEntityEvent(idCard, Item.ChangePropertyEventData(prop, idCard))
    end

    local headset = character.Inventory.GetItemInLimbSlot(InvSlotType.Headset)
    if headset then
       local wifi = headset.GetComponentString("WifiComponent")
       if wifi then
            wifi.TeamID = CharacterTeamType.Team1
       end
    end

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.Prefabs["sonarbeacon"], wreck.WorldPosition, nil, nil, function(item)
        item.NonInteractable = true

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.Prefabs["batterycell"], item.OwnInventory, nil, nil, function(bat)
            bat.Indestructible = true

            local interface = item.GetComponentString("CustomInterface")

            interface.customInterfaceElementList[1].State = true
            interface.customInterfaceElementList[2].Signal = "Last known pirate position"

            item.CreateServerEvent(interface, interface)
        end)
    end)

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("shotgun"), character.Inventory, nil, nil, function (item)
        for i = 1, 6, 1 do
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("shotgunshell"), item.OwnInventory)
        end
    end)

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("smg"), character.Inventory, nil, nil, function (item)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("smgmagazinedepletedfuel"), item.OwnInventory)
    end)

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("smgmagazine"), character.Inventory)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("smgmagazine"), character.Inventory)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("antiparalysis"), character.Inventory)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("antiparalysis"), character.Inventory)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("oxygenitetank"), character.Inventory)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("oxygenitetank"), character.Inventory)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("oxygenitetank"), character.Inventory)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("oxygenitetank"), character.Inventory)

    for i = 1, 12, 1 do
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("shotgunshell"), character.Inventory)
    end

    for i = 1, 4, 1 do
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("antibiotics"), character.Inventory)
    end
    local toolbelt = character.Inventory.GetItemInLimbSlot(InvSlotType.Bag)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("antidama1"), toolbelt.OwnInventory)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("antidama1"), toolbelt.OwnInventory)
    for i = 1, 6, 1 do
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("antibleeding1"), toolbelt.OwnInventory)
    end
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("alienblood"), toolbelt.OwnInventory)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("fuelrod"), toolbelt.OwnInventory)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("underwaterscooter"), toolbelt.OwnInventory, nil, nil, function (item)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("batterycell"), item.OwnInventory)
    end)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("handheldsonar"), toolbelt.OwnInventory, nil, nil, function (item)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("batterycell"), item.OwnInventory)
    end)

    local oldClothes = character.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes)
    oldClothes.Drop()
    Entity.Spawner.AddEntityToRemoveQueue(oldClothes)

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("pirateclothes"), character.Inventory, nil, nil, function (item)
        character.Inventory.TryPutItem(item, character.Inventory.FindLimbSlot(InvSlotType.InnerClothes), true, false, character)
    end)

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("pucs"), character.Inventory, nil, nil, function (item)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("combatstimulantsyringe"), item.OwnInventory)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("oxygenitetank"), item.OwnInventory)
    end)

    local text = "There have been reports about a notorious pirate with a PUCS suit terrorizing these waters, the pirate was detected recently inside a wrecked submarine - eliminate the pirate to claim a reward of " .. event.AmountPoints .. " points for the entire crew."
    Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

    Traitormod.GhostRoles.Ask("Wreck Pirate", function (client)
        Traitormod.LostLivesThisRound[client.SteamID] = false
        client.SetClientCharacter(character)

        Traitormod.SendMessageCharacter(character, "You are a pirate! Protect the wreck from any filthy coalitions, it will be eventually home to our center of operations! \n\nSurviving inside the wreck until the end of the round will grant you " .. event.AmountPointsPirate .." points.", "InfoFrameTabButton.Mission")
    end, character)

    Hook.Add("think", "WreckPirate.Think", function ()
        if character.IsDead then
            event.End()
        end

        if character.Submarine == Submarine.MainSub and not event.EnteredMainSub then
            event.EnteredMainSub = true
            Traitormod.RoundEvents.SendEventMessage("Attention! A dangerous PUCS pirate has been detected inside the main submarine!")
        end
    end)
end


event.End = function (isEndRound)
    Hook.Remove("think", "WreckPirate.Think")

    if isEndRound then
        if event.Character and not event.Character.IsDead and event.Character.Submarine == event.Wreck then
            local client = Traitormod.FindClientCharacter(event.Character)
            if client then
                Traitormod.AwardPoints(client, event.AmountPointsPirate)
                Traitormod.SendMessage(client, "You have received " .. event.AmountPointsPirate .. " points.", "InfoFrameTabButton.Mission")
            end
        end

        return
    end

    local text = "The PUCS pirate has been killed, the crew has received a reward of " .. event.AmountPoints .. " points."

    Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

    for _, client in pairs(Client.ClientList) do
        if client.Character and not client.Character.IsDead and client.Character.TeamID == CharacterTeamType.Team1 then
            Traitormod.AwardPoints(client, event.AmountPoints)
            Traitormod.SendMessage(client, "You have received " .. event.AmountPoints .. " points.", "InfoFrameTabButton.Mission")
        end
    end
end

return event