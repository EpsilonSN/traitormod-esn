local config = {}
config.DebugLogs = true

----- USER FEEDBACK -----
config.Language = "English"
config.SendWelcomeMessage = true
config.ChatMessageType = ChatMessageType.Private    -- Error = red | Private = green | Dead = blue | Radio = yellow

config.Extensions = {
    dofile(Traitormod.Path .. "/Lua/extensions/weaponnerfs.lua"),
    --dofile(Traitormod.Path .. "/Lua/extensions/paralysisnerf.lua"),
    dofile(Traitormod.Path .. "/Lua/extensions/pressuremidjoin.lua"),
    --dofile(Traitormod.Path .. "/Lua/extensions/alivecrewmenuremover.lua"),
}

----- GAMEPLAY -----
config.Codewords = {
    "hull", "tabacco", "nonsense", "fish", "clown", "quartermaster", "fast", "possibility",
	"thalamus", "hungry", "water", "looks", "renegade", "angry", "green", "sink", "rubber",
	"mask", "sweet", "ice", "charybdis", "cult", "secret", "frequency",
	"husk", "rust", "ruins", "red", "boat", "cats", "rats", "blast",
	"tire", "trunk", "weapons", "threshers", "cargo", "method", "monkey", "sans", "honkmother"
}

config.AmountCodeWords = 2

config.OptionalTraitors = true        -- players can use !toggletraitor
config.RagdollOnDisconnect = false
config.EnableControlHusk = false     -- EXPERIMENTAL: enable to control husked character after death
config.DeathLogBook = true

-- This overrides the game's respawn shuttle, and uses it as a submarine injector, to spawn submarines in game easily. Respawn should still work as expected, but the shuttle submarine file needs to be manually added here.
-- Note: If this is disabled, traitormod will disable all functions related to submarine spawning.
-- Warning: Only respawn shuttles will be used, the option to spawn people directly into the submarine doesnt work.
config.OverrideRespawnSubmarine = true
config.RespawnSubmarineFile = "Content/Submarines/Selkie.sub"
config.RespawnText = "Separatist agents incoming. ETA in %s seconds."
config.RespawnTeam = CharacterTeamType.Team1
config.RespawnOnKillPoints = 500

-- Allows players that just joined the server to instantly spawn
config.EnableMidRoundSpawn = true

----- POINTS + LIVES -----
config.PermanentPoints = true      -- sets if points and lives will be stored in and loaded from a file
config.RemotePoints = nil
config.RemoteServerAuth = {}
config.PermanentStatistics = true  -- sets if statistics be stored in and loaded from a file
config.MaxLives = 5
config.MinRoundTimeToLooseLives = 210
config.RespawnedPlayersDontLooseLives = true
config.MaxExperienceFromPoints = 100000     -- if not nil, this amount is the maximum experience players gain from stored points (30k = lvl 10 | 38400 = lvl 12)

config.FreeExperience = 800         -- temporary experience given every ExperienceTimer seconds
config.ExperienceTimer = 200

config.PointsGainedFromSkill = {
    medical = 5,
    weapons = 5,
    mechanical = 4,
    electrical = 4,
    helm = 3,
}

config.PointsLostAfterNoLives = function (x)
    return x * 0.75
end

config.AmountExperienceWithPoints = function (x)
    return x
end

-- Give weight based on the logarithm of experience
-- 100 experience = 4 chance
-- 1000 experience = 6 chance
config.AmountWeightWithPoints = function (x)
    return math.log(x + 10) -- add 1 because log of 0 is -infinity
end

----- GAMEMODE -----
config.GamemodeConfig = {
    Secret = {
        EndOnComplete = true,           -- end round everyone but traitors are dead
        EnableRandomEvents = true,
        EndGameDelaySeconds = 5,

        TraitorSelectDelayMin = 90,
        TraitorSelectDelayMax = 175,

        PointsGainedFromHandcuffedTraitors = 1000,
        DistanceToEndOutpostRequired = 7500,

        MissionPoints = {
            Salvage = 1100,
            Monster = 1050,
            Cargo = 1000,
            Beacon = 1200,
            Nest = 1700,
            Mineral = 1000,
            Combat = 1400,
            AbandonedOutpost = 3,
            Escort = 1200,
            Pirate = 1300,
            GoTo = 1000,
            ScanAlienRuins = 1600,
            ClearAlienRuins = 2000,
            Default = 1000,
        },
        PointsGainedFromCrewMissionsCompleted = 1200,
        LivesGainedFromCrewMissionsCompleted = 2,

        TraitorTypeSelectionMode = "Vote", -- Vote | Random
        TraitorTypeChance = {
            Traitor = 34, -- Traitors have 34% chance of being a normal traitor
            Cultist = 33,
            Clown = 33,
        },

        AmountTraitors = function (amountPlayers)
            config.TestMode = false
            if amountPlayers > 18 and math.random() < 0.25 then return 4 end
            if amountPlayers > 12 then return 3 end
            if amountPlayers > 7 then return 2 end            
            if amountPlayers > 3 then return 1 end
            if amountPlayers == 1 then 
                Traitormod.SendMessageEveryone("1P testing mode - no points can be gained or lost") 
                config.TestMode = true
                return 1
            end
            print("Not enough players to start traitor mode.")
            return 0
        end,

        -- 0 = 0% chance
        -- 1 = 100% chance
        TraitorFilter = function (client)
            if client.Character.TeamID ~= CharacterTeamType.FriendlyNPC then return 0 end
            if not client.Character.IsHuman then return 0 end
            if client.Character.HasJob("captain") then return 0 end
            if client.Character.HasJob("securityofficer") then return 0 end
            if client.Character.HasJob("medicaldoctor") then return 0.5 end

            return 1
        end
    },

    PvP = {
        EnableRandomEvents = false, -- most events are coded to only affect the main submarine
        WinningPoints = 1000,
        WinningDeadPoints = 500,
        MinimumPlayersForPoints = 4,
        ShowSonar = true,
        IdCardAllAccess = true,
        CrossTeamCommunication = true,
        BannedItems = {"coilgunammoboxexplosive", "nuclearshell"}
    },
}

config.RoleConfig = {
    Crew = {
        AvailableObjectives = {
            ["captain"] = {"KillLargeMonsters", "FinishRoundFast", "SecurityTeamSurvival"},
            ["engineer"] = {"RepairElectrical", "RepairMechanical", "KillSmallMonsters"},
            ["mechanic"] = {"RepairMechanical", "RepairHull", "KillSmallMonsters"},
            ["securityofficer"] = {"KillLargeMonsters", "KillSmallMonsters"},
            ["medicaldoctor"] = {"HealCharacters", "KillSmallMonsters"},
            ["assistant"] = {"RepairElectrical", "RepairMechanical", "KillPets"},
        }
    },

    Cultist = {
        SubObjectives = {"Assassinate", "Kidnap", "TurnHusk", "DestroyCaly", "SuffocateCrew"},
        MinSubObjectives = 2,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 30,
        NextObjectiveDelayMax = 60,

        TraitorBroadcast = true,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = true,                  -- traitors can send direct messages to other players using !tdm

        -- Names, None
        TraitorMethodCommunication = "Names",

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
    },

    HuskServant = {
        TraitorBroadcast = true,
    },

    Traitor = {
        SubObjectives = {"StealCaptainID", "Survive", "Kidnap", "PoisonCaptain", "SuffocateCrew"},
        MinSubObjectives = 2,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 30,
        NextObjectiveDelayMax = 60,

        TraitorBroadcast = true,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = true,                  -- traitors can send direct messages to other players using !tdm

        -- Names, Codewords, None
        TraitorMethodCommunication = "Names",

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
        SelectUniqueTargets = true,     -- every traitor target can only be chosen once per traitor (respawn+false -> no end)
        PointsPerAssassination = 100,
    },

    Clown = {
        SubObjectives = {"Survive", "AssassinatePressure", "DrunkSailor", "GrowMudraptors", "DestroyWeapons", "SuffocateCrew", "BananaSlip"},
        MinSubObjectives = 3,
        MaxSubObjectives = 4,

        NextObjectiveDelayMin = 25,
        NextObjectiveDelayMax = 85,

        TraitorBroadcast = true,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = true,                  -- traitors can send direct messages to other players using !tdm

        -- Names, Codewords, None
        TraitorMethodCommunication = "Names",

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
        SelectUniqueTargets = true,     -- every traitor target can only be chosen once per traitor (respawn+false -> no end)
        PointsPerAssassination = 150,
    },
}

config.ObjectiveConfig = {
    Assassinate = {
        AmountPoints = 600,
    },

    Survive = {
        AlwaysActive = true,
        AmountPoints = 500,
        AmountLives = 1,
    },

    StealCaptainID = {
        AmountPoints = 1300,
    },

    Kidnap = {
        AmountPoints = 2500,
        Seconds = 100,
    },

    PoisonCaptain = {
        AmountPoints = 1600,
    },

    Husk = {
        AmountPoints = 800,
    },

    TurnHusk = {
        AmountPoints = 500,
        AmountLives = 1,
    },

    DestroyCaly = {
        AmountPoints = 500,
    },
}

----- EVENTS -----
config.RandomEventConfig = {
    Events = {
        dofile(Traitormod.Path .. "/Lua/config/randomevents/communicationsoffline.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/superballastflora.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/maintenancetoolsdelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/medicaldelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/ammodelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/hiddenpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/electricalfixdischarge.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/wreckpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/beaconpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/abysshelp.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/lightsoff.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/emergencyteam.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/piratecrew.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/outpostpirateattack.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/shadymission.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/oxygengenpoison.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/oxygengenhusk.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/prisoner.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/randomlights.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/clownmagic.lua"),
    }
}

config.PointShopConfig = {
    Enabled = true,
    DeathTimeoutTime = 100,
    ItemCategories = {
        dofile(Traitormod.Path .. "/Lua/config/pointshop/cultist.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/clown.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/traitor.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/security.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/maintenance.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/materials.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/medical.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/ores.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/other.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/experimental.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/deathspawn.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/ships.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/advert.lua"),
    }
}

config.GhostRoleConfig = {
    Enabled = true,
    MiscGhostRoles = {
        ["Mudraptor_pet"] = true,
        ["Peanut"] = true,
        ["Psilotoad"] = true,
        ["Orangeboy"] = true,
    }
}

return config
