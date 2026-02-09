-- ----------------------------------------------------------------------------
-- MajorCooldowns-1.0
-- ----------------------------------------------------------------------------
local MAJOR, MINOR = "MajorCooldowns-1.0", 1
local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end -- Library already loaded or newer version exists

-- ----------------------------------------------------------------------------
-- 1. ENUMS (From Enums.lua)
-- ----------------------------------------------------------------------------

lib.Classes = {
    WARRIOR     = { id = "WARRIOR", name = "Warrior", color = "C79C6E" },
    PALADIN     = { id = "PALADIN", name = "Paladin", color = "F58CBA" },
    PRIEST      = { id = "PRIEST", name = "Priest", color = "FFFFFF" },
    SHAMAN      = { id = "SHAMAN", name = "Shaman", color = "0070DE" },
    DEATHKNIGHT = { id = "DEATHKNIGHT", name = "Death Knight", color = "C41F3B" },
    DEMONHUNTER = { id = "DEMONHUNTER", name = "Demon Hunter", color = "A330C9" },
    MAGE        = { id = "MAGE", name = "Mage", color = "40C7EB" },
    DRUID       = { id = "DRUID", name = "Druid", color = "FF7D0A" },
    ROGUE       = { id = "ROGUE", name = "Rogue", color = "FFF569" },
    HUNTER      = { id = "HUNTER", name = "Hunter", color = "A9D271" },
    WARLOCK     = { id = "WARLOCK", name = "Warlock", color = "8787ED" },
    MONK        = { id = "MONK", name = "Monk", color = "00FF96" },
    EVOKER      = { id = "EVOKER", name = "Evoker", color = "33937F" },
}

lib.Specs = {
    -- Warrior
    WARRIOR_ARMS = { id = 71, class = "WARRIOR", name = "Arms" },
    WARRIOR_FURY = { id = 72, class = "WARRIOR", name = "Fury" },
    WARRIOR_PROT = { id = 73, class = "WARRIOR", name = "Protection" },
    -- Paladin
    PALADIN_HOLY = { id = 65, class = "PALADIN", name = "Holy" },
    PALADIN_PROT = { id = 66, class = "PALADIN", name = "Protection" },
    PALADIN_RET = { id = 70, class = "PALADIN", name = "Retribution" },
    -- Priest
    PRIEST_DISC = { id = 256, class = "PRIEST", name = "Discipline" },
    PRIEST_HOLY = { id = 257, class = "PRIEST", name = "Holy" },
    PRIEST_SHADOW = { id = 258, class = "PRIEST", name = "Shadow" },
    -- Mage
    MAGE_ARCANE = { id = 62, class = "MAGE", name = "Arcane" },
    MAGE_FIRE = { id = 63, class = "MAGE", name = "Fire" },
    MAGE_FROST = { id = 64, class = "MAGE", name = "Frost" },
    -- Druid
    DRUID_BALANCE = { id = 102, class = "DRUID", name = "Balance" },
    DRUID_FERAL = { id = 103, class = "DRUID", name = "Feral" },
    DRUID_GUARDIAN = { id = 104, class = "DRUID", name = "Guardian" },
    DRUID_RESTO = { id = 105, class = "DRUID", name = "Restoration" },
    -- Rogue
    ROGUE_ASSA = { id = 259, class = "ROGUE", name = "Assassination" },
    ROGUE_OUTLAW = { id = 260, class = "ROGUE", name = "Outlaw" },
    ROGUE_SUB = { id = 261, class = "ROGUE", name = "Subtlety" },
    -- Hunter
    HUNTER_BM = { id = 253, class = "HUNTER", name = "Beast Mastery" },
    HUNTER_MM = { id = 254, class = "HUNTER", name = "Marksmanship" },
    HUNTER_SURV = { id = 255, class = "HUNTER", name = "Survival" },
    -- Shaman
    SHAMAN_ELE = { id = 262, class = "SHAMAN", name = "Elemental" },
    SHAMAN_ENH = { id = 263, class = "SHAMAN", name = "Enhancement" },
    SHAMAN_RESTO = { id = 264, class = "SHAMAN", name = "Restoration" },
    -- Warlock
    WARLOCK_AFF = { id = 265, class = "WARLOCK", name = "Affliction" },
    WARLOCK_DEMO = { id = 266, class = "WARLOCK", name = "Demonology" },
    WARLOCK_DESTRO = { id = 267, class = "WARLOCK", name = "Destruction" },
    -- Death Knight
    DK_BLOOD = { id = 250, class = "DEATHKNIGHT", name = "Blood" },
    DK_FROST = { id = 251, class = "DEATHKNIGHT", name = "Frost" },
    DK_UNHOLY = { id = 252, class = "DEATHKNIGHT", name = "Unholy" },
    -- Monk
    MONK_BREW = { id = 268, class = "MONK", name = "Brewmaster" },
    MONK_WW = { id = 269, class = "MONK", name = "Windwalker" },
    MONK_MW = { id = 270, class = "MONK", name = "Mistweaver" },
    -- Demon Hunter
    DH_HAVOC = { id = 577, class = "DEMONHUNTER", name = "Havoc" },
    DH_VENGEANCE = { id = 581, class = "DEMONHUNTER", name = "Vengeance" },
    DH_DEVOURER = { id = 586, class = "DEMONHUNTER", name = "Devourer" },
    -- Evoker
    EVOKER_DEV = { id = 1467, class = "EVOKER", name = "Devastation" },
    EVOKER_PRES = { id = 1468, class = "EVOKER", name = "Preservation" },
    EVOKER_AUG = { id = 1473, class = "EVOKER", name = "Augmentation" },
}

lib.CooldownType = {
    CLASS_ABILITY = "CLASS_ABILITY",
    RACIAL        = "RACIAL",
    TRINKET       = "TRINKET",
    ITEM          = "ITEM",
}

lib.Category = {
    DEFENSIVE     = "Defensive",
    OFFENSIVE     = "Offensive",
    BURST         = "Burst",
    UTILITY       = "Utility",
    HEALING       = "Healing",
    MOVEMENT      = "Movement",
    CROWD_CONTROL = "Crowd Control",
}

lib.Priority = {
    CRITICAL  = 15,
    VERY_HIGH = 12,
    HIGH      = 10,
    MEDIUM    = 8,
    NORMAL    = 6,
    LOW       = 4,
}

-- ----------------------------------------------------------------------------
-- 2. REGISTRY (From CooldownRegistry.lua)
-- ----------------------------------------------------------------------------

-- Internal storage (Upvalues)
local registry = lib.registry or {
    classAbilities = {},
    racials = {},
    trinkets = {},
    items = {},
}
lib.registry = registry -- Expose for debugging/persistence

local lookupByKey = lib.lookupByKey or {}
local lookupByClass = lib.lookupByClass or {}
local lookupBySpec = lib.lookupBySpec or {}

lib.lookupByKey = lookupByKey
lib.lookupByClass = lookupByClass
lib.lookupBySpec = lookupBySpec

-- Internal Helpers
local function validateCooldown(data, cooldownType)
    assert(data.key, "Cooldown must have a unique key")

    if data.stack ~= nil then
        assert(type(data.stack) == "number", "Cooldown stack must be a number")
        assert(data.stack >= 1, "Cooldown stack must be >= 1")
    end
    
    if cooldownType == lib.CooldownType.CLASS_ABILITY then
        assert(data.class, "Class ability must specify a class")
        assert(data.spellID, "Class ability must have a spellID")
    elseif cooldownType == lib.CooldownType.RACIAL then
        assert(data.spellID, "Racial must have a spellID")
    elseif cooldownType == lib.CooldownType.TRINKET then
        assert(data.itemID or data.spellID, "Trinket must have itemID or spellID")
    elseif cooldownType == lib.CooldownType.ITEM then
        assert(data.itemID or data.spellID, "Item must have itemID or spellID")
    end
end

local function indexCooldown(cooldown)
    -- Index by key
    lookupByKey[cooldown.key] = cooldown
    
    -- Index by class
    if cooldown.class then
        lookupByClass[cooldown.class] = lookupByClass[cooldown.class] or {}
        table.insert(lookupByClass[cooldown.class], cooldown)
    end
    
    -- Index by spec
    if cooldown.specs then
        for _, specID in ipairs(cooldown.specs) do
            lookupBySpec[specID] = lookupBySpec[specID] or {}
            table.insert(lookupBySpec[specID], cooldown)
        end
    end
end

-- --- API METHODS ---

function lib:RegisterClassAbility(data)
    validateCooldown(data, lib.CooldownType.CLASS_ABILITY)
    
    -- Avoid duplicate registration by Key
    if lookupByKey[data.key] then return lookupByKey[data.key] end

    local cooldown = {
        key = data.key,
        type = lib.CooldownType.CLASS_ABILITY,
        class = data.class,
        specs = data.specs or {},
        spellID = data.spellID,
        duration = data.duration,
        category = data.category or lib.Category.UTILITY,
        priority = data.priority or lib.Priority.NORMAL,
        defaultEnabled = data.defaultEnabled or false,
        stack = data.stack or 1,
        name = data.name,
        icon = data.icon,
    }
    
    table.insert(registry.classAbilities, cooldown)
    indexCooldown(cooldown)
    return cooldown
end

function lib:RegisterRacial(data)
    validateCooldown(data, lib.CooldownType.RACIAL)
    if lookupByKey[data.key] then return lookupByKey[data.key] end
    
    local cooldown = {
        key = data.key,
        type = lib.CooldownType.RACIAL,
        races = data.races or {},
        spellID = data.spellID,
        duration = data.duration,
        category = data.category or lib.Category.UTILITY,
        priority = data.priority or lib.Priority.LOW,
        stack = data.stack or 1,
        name = data.name,
        icon = data.icon,
    }
    
    table.insert(registry.racials, cooldown)
    indexCooldown(cooldown)
    return cooldown
end

function lib:RegisterBatch(cooldowns, cooldownType)
    for _, data in ipairs(cooldowns) do
        if cooldownType == lib.CooldownType.CLASS_ABILITY then
            self:RegisterClassAbility(data)
        elseif cooldownType == lib.CooldownType.RACIAL then
            self:RegisterRacial(data)
        end
        -- Add Trinket/Item support here if needed
    end
end

-- Query API

function lib:GetByKey(key)
    return lookupByKey[key]
end

function lib:GetByClass(classID)
    return lookupByClass[classID] or {}
end

function lib:GetApplicable(classID, specID)
    local result = {}
    
    -- Get class abilities
    local classCDs = lookupByClass[classID] or {}
    for _, cd in ipairs(classCDs) do
        if cd.type == lib.CooldownType.CLASS_ABILITY then
            -- Check if applicable to spec (empty specs = all specs)
            if #cd.specs == 0 then
                table.insert(result, cd)
            else
                for _, sid in ipairs(cd.specs) do
                    if sid == specID then
                        table.insert(result, cd)
                        break
                    end
                end
            end
        end
    end
    return result
end

function lib:GetAll()
    local all = {}
    for _, cd in ipairs(registry.classAbilities) do table.insert(all, cd) end
    for _, cd in ipairs(registry.racials) do table.insert(all, cd) end
    return all
end

-- ----------------------------------------------------------------------------
-- 3. DATA POPULATION (From Cooldowns.lua)
-- ----------------------------------------------------------------------------
-- We wrap this in a block to keep local variables clean
do
    local Specs = lib.Specs
    local Classes = lib.Classes
    local Category = lib.Category
    local Priority = lib.Priority

    local classAbilities = {
        -- WARRIOR
        { key = "WAR_RALLY", class = Classes.WARRIOR.id, specs = {}, spellID = 97462, duration = 180, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "WAR_DIE_SWORD", class = Classes.WARRIOR.id, specs = { Specs.WARRIOR_ARMS.id }, spellID = 118038, duration = 120, category = Category.DEFENSIVE, priority = Priority.HIGH, defaultEnabled = true },
        { key = "WAR_WALL", class = Classes.WARRIOR.id, specs = { Specs.WARRIOR_PROT.id }, spellID = 871, duration = 240, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "WAR_LAST_STAND", class = Classes.WARRIOR.id, specs = { Specs.WARRIOR_PROT.id }, spellID = 12975, duration = 180, category = Category.DEFENSIVE, priority = Priority.HIGH, defaultEnabled = true },
        { key = "WAR_AVATAR", class = Classes.WARRIOR.id, specs = { Specs.WARRIOR_ARMS.id }, spellID = 107574, duration = 90, category = Category.BURST, priority = Priority.MEDIUM, defaultEnabled = true },
        { key = "WAR_BLADESTORM", class = Classes.WARRIOR.id, specs = { Specs.WARRIOR_ARMS.id }, spellID = 227847, duration = 60, category = Category.BURST, priority = Priority.MEDIUM, defaultEnabled = true },
        { key = "WAR_RECK", class = Classes.WARRIOR.id, specs = { Specs.WARRIOR_FURY.id }, spellID = 1719, duration = 90, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },

        -- PALADIN
        { key = "PAL_BUBBLE", class = Classes.PALADIN.id, specs = {}, spellID = 642, duration = 300, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "PAL_BOP", class = Classes.PALADIN.id, specs = {}, spellID = 1022, duration = 300, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "PAL_AURA_MASTERY", class = Classes.PALADIN.id, specs = { Specs.PALADIN_HOLY.id }, spellID = 31821, duration = 180, category = Category.UTILITY, priority = Priority.HIGH, defaultEnabled = true },
        { key = "PAL_GUARDIAN", class = Classes.PALADIN.id, specs = { Specs.PALADIN_PROT.id }, spellID = 86659, duration = 300, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "PAL_ARDENT", class = Classes.PALADIN.id, specs = { Specs.PALADIN_PROT.id }, spellID = 31850, duration = 120, category = Category.DEFENSIVE, priority = Priority.HIGH, defaultEnabled = true },
        { key = "PAL_AW", class = Classes.PALADIN.id, specs = { Specs.PALADIN_RET.id }, spellID = 31884, duration = 120, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "PAL_LOH", class = Classes.PALADIN.id, specs = {}, spellID = 633, duration = 600, category = Category.UTILITY, priority = Priority.VERY_HIGH, defaultEnabled = true },

        -- PRIEST
        { key = "PRI_PAIN_SUP", class = Classes.PRIEST.id, specs = { Specs.PRIEST_DISC.id }, spellID = 33206, duration = 180, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true, stack = 2},
        { key = "PRI_BARRIER", class = Classes.PRIEST.id, specs = { Specs.PRIEST_DISC.id }, spellID = 62618, duration = 180, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "PRI_DIVINE_HYMN", class = Classes.PRIEST.id, specs = { Specs.PRIEST_HOLY.id }, spellID = 64843, duration = 180, category = Category.UTILITY, priority = Priority.HIGH, defaultEnabled = true },
        { key = "PRI_VAMP_EMBRACE", class = Classes.PRIEST.id, specs = { Specs.PRIEST_SHADOW.id }, spellID = 15286, duration = 75, category = Category.UTILITY, priority = Priority.MEDIUM, defaultEnabled = true },
        { key = "PRI_PI", class = Classes.PRIEST.id, specs = {}, spellID = 10060, duration = 120, category = Category.UTILITY, priority = Priority.VERY_HIGH, defaultEnabled = true },

        -- SHAMAN
        { key = "SHA_LINK", class = Classes.SHAMAN.id, specs = { Specs.SHAMAN_RESTO.id }, spellID = 98008, duration = 180, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "SHA_HEALING_TIDE", class = Classes.SHAMAN.id, specs = { Specs.SHAMAN_RESTO.id }, spellID = 108280, duration = 180, category = Category.UTILITY, priority = Priority.HIGH, defaultEnabled = true },
        { key = "SHA_ASC_RESTO", class = Classes.SHAMAN.id, specs = { Specs.SHAMAN_RESTO.id }, spellID = 114052, duration = 180, category = Category.BURST, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "SHA_ASC_ELE", class = Classes.SHAMAN.id, specs = { Specs.SHAMAN_ELE.id }, spellID = 114051, duration = 180, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "SHA_FERAL_SPIRIT", class = Classes.SHAMAN.id, specs = { Specs.SHAMAN_ENH.id }, spellID = 51533, duration = 90, category = Category.BURST, priority = Priority.MEDIUM, defaultEnabled = true },

        -- DEATHKNIGHT
        { key = "DK_IBF", class = Classes.DEATHKNIGHT.id, specs = {}, spellID = 48792, duration = 180, category = Category.DEFENSIVE, priority = Priority.HIGH, defaultEnabled = true },
        { key = "DK_VAMP_BLOOD", class = Classes.DEATHKNIGHT.id, specs = { Specs.DK_BLOOD.id }, spellID = 55233, duration = 90, category = Category.DEFENSIVE, priority = Priority.HIGH, defaultEnabled = true },
        { key = "DK_DRW", class = Classes.DEATHKNIGHT.id, specs = { Specs.DK_BLOOD.id }, spellID = 49028, duration = 120, category = Category.DEFENSIVE, priority = Priority.HIGH, defaultEnabled = true },
        { key = "DK_PILLAR", class = Classes.DEATHKNIGHT.id, specs = { Specs.DK_FROST.id }, spellID = 51271, duration = 60, category = Category.BURST, priority = Priority.MEDIUM, defaultEnabled = true },
        { key = "DK_APOCALYPSE", class = Classes.DEATHKNIGHT.id, specs = { Specs.DK_UNHOLY.id }, spellID = 275699, duration = 90, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "DK_ZONE", class = Classes.DEATHKNIGHT.id, specs = {}, spellID = 51052, duration = 120, category = Category.DEFENSIVE, priority = Priority.HIGH, defaultEnabled = true },

        -- DEMONHUNTER
        { key = "DH_DARKNESS", class = Classes.DEMONHUNTER.id, specs = { Specs.DH_HAVOC.id }, spellID = 196718, duration = 180, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "DH_NETHER", class = Classes.DEMONHUNTER.id, specs = { Specs.DH_HAVOC.id, Specs.DH_DEVOURER.id }, spellID = 196555, duration = 180, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "DH_META", class = Classes.DEMONHUNTER.id, specs = { Specs.DH_HAVOC.id, Specs.DH_DEVOURER.id }, spellID = 187827, duration = 240, category = Category.BURST, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "DH_SPIKES", class = Classes.DEMONHUNTER.id, specs = { Specs.DH_VENGEANCE.id }, spellID = 203720, duration = 40, category = Category.DEFENSIVE, priority = Priority.NORMAL, defaultEnabled = true },

        -- MAGE
        { key = "MAG_ICEBLOCK", class = Classes.MAGE.id, specs = {}, spellID = 45438, duration = 240, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "MAG_COMBUST", class = Classes.MAGE.id, specs = { Specs.MAGE_FIRE.id }, spellID = 190319, duration = 120, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "MAG_ICYVEINS", class = Classes.MAGE.id, specs = { Specs.MAGE_FROST.id }, spellID = 12472, duration = 180, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "MAG_ARCANE_SURGE", class = Classes.MAGE.id, specs = { Specs.MAGE_ARCANE.id }, spellID = 365362, duration = 90, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "MAG_ARCANE_POWER", class = Classes.MAGE.id, specs = { Specs.MAGE_ARCANE.id }, spellID = 12042, duration = 90, category = Category.BURST, priority = Priority.MEDIUM, defaultEnabled = true },
        { key = "MAG_TEMPORAL", class = Classes.MAGE.id, specs = {}, spellID = 198111, duration = 45, category = Category.DEFENSIVE, priority = Priority.NORMAL },

        -- DRUID
        { key = "DRU_BARKSKIN", class = Classes.DRUID.id, specs = {}, spellID = 22812, duration = 60, category = Category.DEFENSIVE, priority = Priority.NORMAL, defaultEnabled = true },
        { key = "DRU_SURVIVAL", class = Classes.DRUID.id, specs = { Specs.DRUID_FERAL.id, Specs.DRUID_GUARDIAN.id }, spellID = 61336, duration = 180, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "DRU_INCARN_TREE", class = Classes.DRUID.id, specs = { Specs.DRUID_RESTO.id }, spellID = 33891, duration = 180, category = Category.BURST, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "DRU_INCARN_FERAL", class = Classes.DRUID.id, specs = { Specs.DRUID_FERAL.id }, spellID = 102543, duration = 180, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "DRU_INCARN_BALANCE", class = Classes.DRUID.id, specs = { Specs.DRUID_BALANCE.id }, spellID = 102560, duration = 180, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "DRU_TRANQ", class = Classes.DRUID.id, specs = { Specs.DRUID_RESTO.id }, spellID = 740, duration = 180, category = Category.UTILITY, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "DRU_RENEWAL", class = Classes.DRUID.id, specs = {}, spellID = 108238, duration = 90, category = Category.DEFENSIVE, priority = Priority.LOW },

        -- ROGUE
        { key = "ROG_CLOAK", class = Classes.ROGUE.id, specs = {}, spellID = 31224, duration = 60, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "ROG_CHEAT_DEATH", class = Classes.ROGUE.id, specs = {}, spellID = 31230, duration = 360, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "ROG_EVASION", class = Classes.ROGUE.id, specs = {}, spellID = 5277, duration = 120, category = Category.DEFENSIVE, priority = Priority.MEDIUM, defaultEnabled = true },
        { key = "ROG_VANISH", class = Classes.ROGUE.id, specs = {}, spellID = 1856, duration = 120, category = Category.UTILITY, priority = Priority.MEDIUM, defaultEnabled = true },
        { key = "ROG_SHADOW_BLADES", class = Classes.ROGUE.id, specs = { Specs.ROGUE_SUB.id }, spellID = 121471, duration = 180, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "ROG_DEATHMARK", class = Classes.ROGUE.id, specs = { Specs.ROGUE_ASSA.id }, spellID = 360194, duration = 120, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "ROG_SMOKE_BOMB", class = Classes.ROGUE.id, specs = {}, spellID = 212182, duration = 180, category = Category.UTILITY, priority = Priority.HIGH, defaultEnabled = true },

        -- HUNTER
        { key = "HUN_TURTLE", class = Classes.HUNTER.id, specs = {}, spellID = 186265, duration = 180, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "HUN_WILD", class = Classes.HUNTER.id, specs = { Specs.HUNTER_BM.id }, spellID = 193530, duration = 120, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "HUN_COOR_ASSAULT", class = Classes.HUNTER.id, specs = { Specs.HUNTER_SURV.id }, spellID = 266779, duration = 120, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "HUN_TRUESHOT", class = Classes.HUNTER.id, specs = { Specs.HUNTER_MM.id }, spellID = 288613, duration = 120, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "HUN_EXHIL", class = Classes.HUNTER.id, specs = {}, spellID = 109304, duration = 120, category = Category.DEFENSIVE, priority = Priority.NORMAL, defaultEnabled = true },

        -- WARLOCK
        { key = "WL_UNENDING", class = Classes.WARLOCK.id, specs = {}, spellID = 104773, duration = 180, category = Category.DEFENSIVE, priority = Priority.HIGH, defaultEnabled = true },
        { key = "WL_DARKSOUL", class = Classes.WARLOCK.id, specs = { Specs.WARLOCK_AFF.id }, spellID = 113860, duration = 120, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "WL_DARKGLARE", class = Classes.WARLOCK.id, specs = { Specs.WARLOCK_AFF.id }, spellID = 205180, duration = 180, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "WL_TYRANT", class = Classes.WARLOCK.id, specs = { Specs.WARLOCK_DEMO.id }, spellID = 265187, duration = 90, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "WL_INFERNAL", class = Classes.WARLOCK.id, specs = { Specs.WARLOCK_DESTRO.id }, spellID = 1122, duration = 180, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },

        -- MONK
        { key = "MNK_DAMPEN", class = Classes.MONK.id, specs = {}, spellID = 122278, duration = 120, category = Category.DEFENSIVE, priority = Priority.MEDIUM, defaultEnabled = true },
        { key = "MNK_DIFFUSE", class = Classes.MONK.id, specs = {}, spellID = 122783, duration = 90, category = Category.DEFENSIVE, priority = Priority.MEDIUM, defaultEnabled = true },
        { key = "MNK_TOD", class = Classes.MONK.id, specs = { Specs.MONK_WW.id, Specs.MONK_BREW.id }, spellID = 115080, duration = 180, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "MNK_FORT", class = Classes.MONK.id, specs = { Specs.MONK_BREW.id }, spellID = 115203, duration = 420, category = Category.DEFENSIVE, priority = Priority.HIGH, defaultEnabled = true },
        { key = "MNK_XUEN", class = Classes.MONK.id, specs = { Specs.MONK_WW.id }, spellID = 123904, duration = 120, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "MNK_REVIVAL", class = Classes.MONK.id, specs = { Specs.MONK_MW.id }, spellID = 115310, duration = 180, category = Category.UTILITY, priority = Priority.VERY_HIGH, defaultEnabled = true },

        -- EVOKER
        { key = "EVO_DRAGONRAGE", class = Classes.EVOKER.id, specs = { Specs.EVOKER_DEV.id }, spellID = 375087, duration = 120, category = Category.BURST, priority = Priority.HIGH, defaultEnabled = true },
        { key = "EVO_STASIS", class = Classes.EVOKER.id, specs = { Specs.EVOKER_PRES.id }, spellID = 370537, duration = 90, category = Category.UTILITY, priority = Priority.MEDIUM, defaultEnabled = true },
        { key = "EVO_REWIND", class = Classes.EVOKER.id, specs = { Specs.EVOKER_PRES.id }, spellID = 363534, duration = 240, category = Category.DEFENSIVE, priority = Priority.VERY_HIGH, defaultEnabled = true },
        { key = "EVO_DREAMFLIGHT", class = Classes.EVOKER.id, specs = { Specs.EVOKER_PRES.id }, spellID = 359816, duration = 120, category = Category.UTILITY, priority = Priority.HIGH, defaultEnabled = true },
    }

    -- Auto-register on load
    lib:RegisterBatch(classAbilities, lib.CooldownType.CLASS_ABILITY)
end