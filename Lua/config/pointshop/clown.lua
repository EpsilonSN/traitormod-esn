local category = {}

category.Name = "Clown"
category.Decoration = "Jestmaster"
category.FadeToBlack = true

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and Traitormod.RoleManager.HasRole(client.Character, "Clown")
end

category.Init = function ()
    local replacement = [[
    <overwrite>
      <StatusEffect type="OnUse" target="UseTarget" delay="1" comparison="Or">
        <Conditional speciesname="latcher"/>
        <Conditional speciesname="endworm"/>
        <Conditional speciesname="charybdis"/>
        <TriggerEvent identifier="toyhammeronabyssmonster" />
      </StatusEffect>
      <StatusEffect type="OnUse" target="This" Condition="-50.0" setvalue="true"/>
      <Attack targetimpulse="2">
        <Affliction identifier="stun" strength="22" />
      </Attack>
      <StatusEffect type="OnUse" forceplaysounds="true">
        <Sound type="OnUse" file="Content/Items/Weapons/ToyHammerHit1.ogg" range="800" selectionmode="Random"/>
        <Sound type="OnUse" file="Content/Items/Weapons/ToyHammerHit2.ogg" range="800" />
        <Sound type="OnUse" file="Content/Items/Weapons/ToyHammerHit3.ogg" range="800" />
        <Sound type="OnUse" file="Content/Items/Weapons/ToyHammerHit4.ogg" range="800" />
        <Sound type="OnUse" file="Content/Items/Weapons/ToyHammerHit5.ogg" range="800" />
        <Sound type="OnUse" file="Content/Items/Weapons/ToyHammerHit6.ogg" range="800" />
      </StatusEffect>
      <StatusEffect type="OnBroken" target="This">
         <Remove />
      </StatusEffect>
    </overwrite>
    ]]

    local replacementClownSuit = [[
     <overwrite>
     <Wearable slots="Any,InnerClothes" msg="ItemMsgPickUpSelect">
        <sprite name="Legendary Clown's Costume Torso" texture="clown_rare.png" limb="Torso" hidelimb="false" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Right Hand" texture="clown_rare.png" limb="RightHand" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Left Hand" texture="clown_rare.png" limb="LeftHand" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Right Lower Arm" texture="clown_rare.png" limb="RightArm" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Left Lower Arm" texture="clown_rare.png" limb="LeftArm" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Right Upper Arm" texture="clown_rare.png" limb="RightForearm" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Left Upper Arm" texture="clown_rare.png" limb="LeftForearm" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Waist" texture="clown_rare.png" limb="Waist" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Right Thigh" texture="clown_rare.png" limb="RightThigh" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Left Thigh" texture="clown_rare.png" limb="LeftThigh" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Right Leg" texture="clown_rare.png" limb="RightLeg" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Left Leg" texture="clown_rare.png" limb="LeftLeg" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Left Shoe" texture="clown_rare.png" limb="LeftFoot" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Right Shoe" texture="clown_rare.png" limb="RightFoot" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <!-- HöNK -->
        <damagemodifier armorsector="0.0,360.0" afflictionidentifiers="lacerations" damagemultiplier="0.8" damagesound="LimbClown" />
        <damagemodifier armorsector="0.0,360.0" afflictionidentifiers="gunshotwound, bitewounds" damagemultiplier="0.75" damagesound="LimbClown" />
      </Wearable>
      </overwrite>
    ]]

    local replacementClownMask = [[
        <overwrite>
        <Wearable slots="Any,Head" armorvalue="20.0" msg="ItemMsgPickUpSelect">
            <damagemodifier afflictionidentifiers="lacerations,gunshotwound" armorsector="0.0,360.0" damagemultiplier="0.45" damagesound="LimbArmor" deflectprojectiles="true" />
            <damagemodifier afflictionidentifiers="bitewounds, blunttrauma" armorsector="0.0,360.0" damagemultiplier="0.65" damagesound="LimbArmor" deflectprojectiles="true" />
            <damagemodifier afflictiontypes="bleeding" armorsector="0.0,360.0" damagemultiplier="0.35" damagesound="LimbArmor" deflectprojectiles="true" />
            <damagemodifier afflictionidentifiers="concussion" armorsector="0.0,360.0" damagemultiplier="0.0" damagesound="" deflectprojectiles="true" />
            <sprite name="Clown Mask Wearable" texture="Content/Items/Jobgear/headgears.png" limb="Head" inheritlimbdepth="true" inheritscale="true" ignorelimbscale="true" scale="0.65" sourcerect="414,417,89,71" origin="0.5,0.6" />
            <StatusEffect tags="clown" type="OnWearing" target="Character" HideFace="true" duration="0.1" stackable="false" />
        </Wearable>
        </overwrite>
       ]]

    local hammer = ItemPrefab.GetItemPrefab("toyhammer")
    local mothersuit = ItemPrefab.GetItemPrefab("clownsuitunique")
    local mothermask = ItemPrefab.GetItemPrefab("clownmaskunique")
    local element = hammer.ConfigElement.Element.Element("MeleeWeapon")
    local elementSuit = mothersuit.ConfigElement.Element.Element("Wearable")
    local elementMask = mothermask.ConfigElement.Element.Element("Wearable")
    Traitormod.Patching.RemoveAll(element, "StatusEffect")
    Traitormod.Patching.RemoveAll(elementSuit, "Wearable")
    Traitormod.Patching.RemoveAll(elementMask, "Wearable")
    Traitormod.Patching.Add(element, replacement)
    Traitormod.Patching.Add(elementSuit, replacementClownSuit)
    Traitormod.Patching.Add(elementMask, replacementClownMask)

    Hook.Add("item.use", "Clown.Boom", function (item, itemUser, targetLimb)
        if item.HasTag("medical") and item.HasTag("clownboom") then
            if item.ParentInventory ~= nil and LuaUserData.IsTargetType(item.ParentInventory.Owner, "Barotrauma.Item") then
                local injector = item.ParentInventory.Owner
                if injector.ParentInventory ~= nil and LuaUserData.IsTargetType(injector.ParentInventory.Owner, "Barotrauma.Character") then
                    local character = injector.ParentInventory.Owner
                    if character.Inventory.GetItemInLimbSlot(InvSlotType.Headset) == injector then
                        Game.Explode(character.WorldPosition, 450, 45, 85, 350, 25, 45, 1500)
                    end
                end
            end
        end
    end)

    --[[
        Hook.Add("meleeWeapon.handleImpact",  "Cultist.Stinger", function (melee, target)
            if melee.Item.Prefab.Identifier ~= "huskstinger" then return end
            if not LuaUserData.IsTargetType(target.UserData, "Barotrauma.Limb") then return end
            local character = target.UserData.character
    
            do
                local affliction = AfflictionPrefab.Prefabs["huskinfection"].Instantiate(2)
                character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, affliction)
            end
    
            do -- speed up affliction, since its capped at 50% by default
                local affliction = character.CharacterHealth.GetAffliction("huskinfection", true)
                if affliction then
                    affliction._strength = affliction._strength + 2
                end
            end
        end)
    --]]
end

category.Products = {
    {
        Name = "Clown Mask",
        Price = 100,
        Limit = 15,
        IsLimitGlobal = false,
        Items = {"clownmask"},
    },

    {
        Name = "Clown Ensemble",
        Price = 250,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"clownmask", "clowncostume"},
    },

    {
        Name = "Mother's Ensemble (Armor Plated)",
        Price = 700,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"clownmaskunique", "clownsuitunique"},
    },

    {
        Name = "Clown Diving Mask",
        Price = 100,
        Limit = 2,
        IsLimitGlobal = false,
        Items = {"clowndivingmask"},
    },

    {
        Name = "Enroll into Clown College",
        Price = 750,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client, product, items)
            client.Character.GiveTalent("enrollintoclowncollege")
        end
    },

    {
        Name = "Toy Hammer (Buffed)",
        Price = 550,
        Limit = 2,
        IsLimitGlobal = false,
        Items = {"toyhammer"},
    },

    {
        Name = "Clown Auto-Injector",
        Price = 3950,
        Limit = 1,
        IsLimitGlobal = true,
        Action = function (client)
            local prefabInjector = ItemPrefab.GetItemPrefab("autoinjectorheadset")
            local prefabC4 = ItemPrefab.GetItemPrefab("c4block")
            Entity.Spawner.AddItemToSpawnQueue(prefabInjector, client.Character.Inventory, nil, nil, function (item)
                item.Description = "Praise the honkmother. Has a surprise inside."
                Entity.Spawner.AddItemToSpawnQueue(prefabC4, client.Character.Inventory, nil, nil, function (item2)
                    item.OwnInventory.TryPutItem(item2, 1, false, false, client.Character, true, false)
                    item2.Description = "Praise the honkmother."
                    item2.set_InventoryIconColor(Color(255, 5, 10))
                    item2.SpriteColor = Color(255, 5, 10, 255)
                    item2.AddTag("medical")
                    item2.AddTag("clownboom")

                    local color = item2.SerializableProperties[Identifier("SpriteColor")]
                    Networking.CreateEntityEvent(item2, Item.ChangePropertyEventData(color, item2))
                    local invColor = item2.SerializableProperties[Identifier("InventoryIconColor")]
                    Networking.CreateEntityEvent(item2, Item.ChangePropertyEventData(invColor, item2))
                end)
            end)
        end
    },

    {
        Name = "Summon Insane Clown",
        Price = 1100,
        Limit = 1,
        IsLimitGlobal = true,
        Action = function (client, product, items)
            local info = CharacterInfo(Identifier("human"))
            local possibleNames = {
                "Jestmaster",
                "Joe Hawley",
                "Jester",
                "Funnyman",
                "Honkmother's Disciple",
                "Sansundertale",
                "Haloperidol",
                "Murderous Comedian",
                "Harlequin",
                "Mr. Buffoon",
                "The Prankster",
                "Practical Joke",
                "The Pierrot",
                "Pillars of Fun",
                "Balloon Man",
                "The Grandest of Jesters",
                "Grandmaster Clown",
                "Killer",
                "Hunter",
                "Buddy the Clown"
            }

            info.Name = possibleNames[math.random(1, #possibleNames)]
            info.Job = Job(JobPrefab.Get("securityofficer"))
        
            local character = Character.Create(info, client.Character.WorldPosition, info.Name, 0, false, true)
            local affliction = AfflictionPrefab.Prefabs["deliriuminepoisoning"].Instantiate(35)
            local afflictionInsane = AfflictionPrefab.Prefabs["psychosis"].Instantiate(10)
            local afflictionPressure = AfflictionPrefab.Prefabs["pressurestabilized"].Instantiate(290)
            local afflictionVigor = AfflictionPrefab.Prefabs["vigor"].Instantiate(350)
            character.CanSpeak = false
            character.TeamID = CharacterTeamType.None
            character.GiveTalent("psychoclown", true)
            character.GiveTalent("enrollintoclowncollege", true)
            character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, affliction)
            character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, afflictionInsane)
            character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, afflictionPressure)
            character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, afflictionVigor)
            character.GiveJobItems(nil)

            local oldClothes = character.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes)
            if oldClothes then oldClothes.Drop() Entity.Spawner.AddEntityToRemoveQueue(oldClothes) end

            local oldHat = character.Inventory.GetItemInLimbSlot(InvSlotType.Head)
            if oldHat then oldHat.Drop() Entity.Spawner.AddEntityToRemoveQueue(oldHat) end
            
            for item in character.Inventory.AllItems do
               if item.Prefab.Identifier == "stunbaton" or item.Prefab.Identifier == "handcuffs" or item.Prefab.Identifier == "divingknife" then
                   Entity.Spawner.AddEntityToRemoveQueue(item)
               end
            end
            
            local idCard = character.Inventory.GetItemInLimbSlot(InvSlotType.Card)
            if idCard then
                idCard.NonPlayerTeamInteractable = true
                idCard.AddTag("name: "..info.Name)
                idCard.AddTag("job: clown")
                idCard.Description = "This belongs to "..info.Name.." the clown. Allows limited access to areas of the sub."
                local prop = idCard.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                Networking.CreateEntityEvent(idCard, Item.ChangePropertyEventData(prop, idCard))
            end
        
            local idCard = character.Inventory.GetItemInLimbSlot(InvSlotType.Card)
            if idCard then
                idCard.NonPlayerTeamInteractable = true
                local prop = idCard.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                Networking.CreateEntityEvent(idCard, Item.ChangePropertyEventData(prop, idCard))
            end

            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("clowncostume"), character.Inventory, nil, nil, function (item)
                character.Inventory.TryPutItem(item, character.Inventory.FindLimbSlot(InvSlotType.InnerClothes), true, false, character)
                item.NonPlayerTeamInteractable = true
                local prop = item.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(prop, item))
            end)

            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("clownmask"), character.Inventory, nil, nil, function (item)
                character.Inventory.TryPutItem(item, character.Inventory.FindLimbSlot(InvSlotType.Head), true, false, character)
                item.NonPlayerTeamInteractable = true
                local prop = item.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(prop, item))
            end)

            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("boardingaxe"), character.Inventory, nil, nil, function (item)
                item.NonPlayerTeamInteractable = true
                local prop = item.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(prop, item))
            end)
           
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("divingknife"), character.Inventory, nil, nil, function (item)  end)
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("divingknife"), character.Inventory, nil, nil, function (item)  end)

            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("bikehorn"), character.Inventory, nil, nil, function (item)
                item.NonPlayerTeamInteractable = true
                local prop = item.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(prop, item))
            end)

            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("toyhammer"), character.Inventory, nil, nil, function (item)
                item.NonPlayerTeamInteractable = true
                local prop = item.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(prop, item))
            end)

            Traitormod.GhostRoles.Ask("The Clown", function (client)
                Traitormod.LostLivesThisRound[client.SteamID] = false
                client.SetClientCharacter(character)
        
                Traitormod.SendMessageCharacter(character, "You are a clown! Eliminate them. Protect all fellow clowns.", "InfoFrameTabButton.Mission")
            end, character)

            local text = "Attention! There is a mute clown going rampant in our submarine. Eliminate it!"
            Traitormod.RoundEvents.SendEventMessage(text, "GameModeIcon.pvp", Color.OrangeRed)
        end
    },

    {
        Name = "Chloral Hydrate (x3)",
        Price = 350,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"chloralhydrate", "chloralhydrate", "chloralhydrate"},
    },

    {
        Name = "Detonator",
        Price = 950,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"detonator"},
    },
--[[
    {
        Name = "Call Clown Army",
        Price = 10000,
        Limit = 1,
        IsLimitGlobal = true,

        CanBuy = function (client, product)
            return not Traitormod.RoundEvents.IsEventActive("ClownArmy")
        end,

        Action = function ()
            Traitormod.RoundEvents.TriggerEvent("ClownArmy")
        end
    },
--]]
}

return category
