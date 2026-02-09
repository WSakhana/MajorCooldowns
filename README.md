# MajorCooldowns

A World of Warcraft addon library that provides comprehensive data for Major Spec ability cooldowns across all classes and specializations.

## Overview

MajorCooldowns is a LibStub-based library designed to give addon developers easy access to major cooldown abilities for all WoW classes. It includes detailed information about defensive cooldowns, offensive bursts, healing abilities, and utilities.

## Features

- **Comprehensive Coverage**: All classes and specializations in World of Warcraft
- **Detailed Metadata**: Each ability includes:
  - Spell ID
  - Cooldown duration
  - Category (Defensive, Offensive, Burst, Healing, Utility, Movement, Crowd Control)
  - Priority levels
  - Spec restrictions
  - Stack information where applicable
- **Easy Integration**: LibStub-based for seamless integration with other addons
- **Query API**: Multiple methods to retrieve cooldown data by class, spec, or key

## Installation

### For End Users
1. Download the latest release
2. Extract to your `World of Warcraft/_retail_/Interface/AddOns/` directory
3. Restart WoW or reload UI

### For Addon Developers
Include MajorCooldowns as an optional dependency in your addon's `.toc` file:

```
## OptionalDeps: MajorCooldowns
```

Or embed it directly in your addon's `libs` folder.

## Usage

### Getting the Library

```lua
local MajorCooldowns = LibStub("MajorCooldowns-1.0")
if not MajorCooldowns then
    -- Library not available
    return
end
```

### API Methods

#### Registration Methods

While the library comes pre-populated with all major cooldowns, you can register custom abilities:

```lua
-- Register a class ability
MajorCooldowns:RegisterClassAbility({
    key = "MY_ABILITY",
    class = "WARRIOR",
    specs = { 71, 72 },  -- Arms and Fury
    spellID = 12345,
    duration = 120,
    category = MajorCooldowns.Category.BURST,
    priority = MajorCooldowns.Priority.HIGH,
    defaultEnabled = true,
    stack = 1,  -- Number of charges (optional, defaults to 1)
})

-- Register multiple abilities at once
MajorCooldowns:RegisterBatch(cooldownTable, MajorCooldowns.CooldownType.CLASS_ABILITY)
```

#### Query Methods

```lua
-- Get a specific cooldown by key
local rally = MajorCooldowns:GetByKey("WAR_RALLY")

-- Get all cooldowns for a class
local warriorCDs = MajorCooldowns:GetByClass("WARRIOR")

-- Get applicable cooldowns for a specific class and spec
local _, _, classID = UnitClass("player")
local specID = GetSpecializationInfo(GetSpecialization())
local applicableCDs = MajorCooldowns:GetApplicable(classID, specID)

-- Get all cooldowns
local allCDs = MajorCooldowns:GetAll()
```

#### Enumerations

```lua
-- Cooldown Categories
MajorCooldowns.Category.DEFENSIVE
MajorCooldowns.Category.OFFENSIVE
MajorCooldowns.Category.BURST
MajorCooldowns.Category.UTILITY
MajorCooldowns.Category.HEALING
MajorCooldowns.Category.MOVEMENT
MajorCooldowns.Category.CROWD_CONTROL

-- Priority Levels
MajorCooldowns.Priority.CRITICAL  -- 15
MajorCooldowns.Priority.VERY_HIGH -- 12
MajorCooldowns.Priority.HIGH      -- 10
MajorCooldowns.Priority.MEDIUM    -- 8
MajorCooldowns.Priority.NORMAL    -- 6
MajorCooldowns.Priority.LOW       -- 4

-- Cooldown Types
MajorCooldowns.CooldownType.CLASS_ABILITY
MajorCooldowns.CooldownType.RACIAL
MajorCooldowns.CooldownType.TRINKET
MajorCooldowns.CooldownType.ITEM
```

### Example: Displaying Major Cooldowns

```lua
local MajorCooldowns = LibStub("MajorCooldowns-1.0")

-- Get current player's spec
local _, _, classID = UnitClass("player")
local specID = GetSpecializationInfo(GetSpecialization())

-- Get applicable cooldowns
local cooldowns = MajorCooldowns:GetApplicable(classID, specID)

-- Sort by priority
table.sort(cooldowns, function(a, b)
    return (a.priority or 0) > (b.priority or 0)
end)

-- Display
for _, cd in ipairs(cooldowns) do
    if cd.defaultEnabled then
        local name = GetSpellInfo(cd.spellID)
        print(string.format("%s - %ds cooldown (%s)", 
            name, cd.duration, cd.category))
    end
end
```

### Example: Tracking Cooldowns

```lua
local MajorCooldowns = LibStub("MajorCooldowns-1.0")

local function TrackCooldown(spellID)
    -- Find the cooldown in our database
    local allCDs = MajorCooldowns:GetAll()
    for _, cd in ipairs(allCDs) do
        if cd.spellID == spellID then
            local start, duration = GetSpellCooldown(cd.spellID)
            if start > 0 then
                local remaining = duration - (GetTime() - start)
                print(string.format("%s cooldown: %.1f seconds remaining", 
                    GetSpellInfo(cd.spellID), remaining))
            end
            break
        end
    end
end
```

## Data Structure

Each cooldown entry contains:

```lua
{
    key = "WAR_RALLY",                    -- Unique identifier
    type = "CLASS_ABILITY",               -- Cooldown type
    class = "WARRIOR",                    -- Class ID
    specs = { 71, 72, 73 },              -- Applicable spec IDs (empty = all specs)
    spellID = 97462,                      -- Spell ID for API calls
    duration = 180,                       -- Cooldown duration in seconds
    category = "Defensive",               -- Category
    priority = 12,                        -- Priority level
    defaultEnabled = true,                -- Whether enabled by default
    stack = 1,                           -- Number of charges
    name = "Rallying Cry",               -- Name (optional)
    icon = "ability_warrior_rallyingcry" -- Icon path (optional)
}
```

## Included Cooldowns

The library includes major cooldowns for all classes:

- **Warrior**: Rallying Cry, Die by the Sword, Shield Wall, Last Stand, Avatar, Bladestorm, Recklessness
- **Paladin**: Divine Shield, Blessing of Protection, Aura Mastery, Guardian of Ancient Kings, Ardent Defender, Avenging Wrath, Lay on Hands
- **Priest**: Pain Suppression, Power Word: Barrier, Divine Hymn, Vampiric Embrace, Power Infusion
- **Shaman**: Spirit Link Totem, Healing Tide Totem, Ascendance variations, Feral Spirit
- **Death Knight**: Icebound Fortitude, Vampiric Blood, Dancing Rune Weapon, Pillar of Frost, Apocalypse, Anti-Magic Zone
- **Demon Hunter**: Darkness, Netherwalk, Metamorphosis, Demon Spikes
- **Mage**: Ice Block, Combustion, Icy Veins, Arcane Surge, Arcane Power, Temporal Shield
- **Druid**: Barkskin, Survival Instincts, Incarnation variations, Tranquility, Renewal
- **Rogue**: Cloak of Shadows, Cheat Death, Evasion, Vanish, Shadow Blades, Deathmark, Smoke Bomb
- **Hunter**: Aspect of the Turtle, Bestial Wrath, Coordinated Assault, Trueshot, Exhilaration
- **Warlock**: Unending Resolve, Dark Soul, Summon Darkglare, Summon Demonic Tyrant, Summon Infernal
- **Monk**: Dampen Harm, Diffuse Magic, Touch of Death, Fortifying Brew, Invoke Xuen, Revival
- **Evoker**: Dragonrage, Stasis, Rewind, Dream Flight

## Class and Spec References

Access predefined class and spec data:

```lua
-- Classes
MajorCooldowns.Classes.WARRIOR
MajorCooldowns.Classes.PALADIN
-- etc.

-- Specs
MajorCooldowns.Specs.WARRIOR_ARMS  -- { id = 71, class = "WARRIOR", name = "Arms" }
MajorCooldowns.Specs.PALADIN_HOLY  -- { id = 65, class = "PALADIN", name = "Holy" }
-- etc.
```

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for:
- Missing or incorrect cooldowns
- New features
- Bug fixes
- Documentation improvements

## Version History

See [CHANGELOG.md](CHANGELOG.md) for version history.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

Created by WSakhana

## Support

For bug reports and feature requests, please use the GitHub issue tracker.
