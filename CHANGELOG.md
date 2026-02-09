# Changelog

All notable changes to the MajorCooldowns library will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-09

### Added
- Initial release of MajorCooldowns library
- Complete LibStub-based library structure
- Comprehensive cooldown data for all 13 WoW classes
- Support for all specializations including new Evoker specs
- Class ability registration and tracking
- Racial ability support (framework)
- Query API methods:
  - `GetByKey(key)` - Retrieve cooldown by unique key
  - `GetByClass(classID)` - Get all cooldowns for a class
  - `GetApplicable(classID, specID)` - Get spec-specific cooldowns
  - `GetAll()` - Retrieve all registered cooldowns
- Registration API methods:
  - `RegisterClassAbility(data)` - Register individual class abilities
  - `RegisterRacial(data)` - Register racial abilities
  - `RegisterBatch(cooldowns, type)` - Batch registration
- Enumerations for:
  - Classes with color codes
  - All spec IDs
  - Cooldown categories (Defensive, Offensive, Burst, Healing, Utility, Movement, Crowd Control)
  - Priority levels (Critical to Low)
  - Cooldown types (Class Ability, Racial, Trinket, Item)
- Pre-populated database with 80+ major cooldowns including:
  - Warrior: Rally, Die by the Sword, Shield Wall, Last Stand, Avatar, Bladestorm, Recklessness
  - Paladin: Divine Shield, BoP, Aura Mastery, Guardian, Ardent Defender, Avenging Wrath, Lay on Hands
  - Priest: Pain Suppression, Barrier, Divine Hymn, Vampiric Embrace, Power Infusion
  - Shaman: Spirit Link, Healing Tide, Ascendance (all specs), Feral Spirit
  - Death Knight: IBF, Vampiric Blood, DRW, Pillar of Frost, Apocalypse, AMZ
  - Demon Hunter: Darkness, Netherwalk, Metamorphosis, Demon Spikes
  - Mage: Ice Block, Combustion, Icy Veins, Arcane Surge, Arcane Power, Temporal Shield
  - Druid: Barkskin, Survival Instincts, Incarnation (all specs), Tranquility, Renewal
  - Rogue: Cloak, Cheat Death, Evasion, Vanish, Shadow Blades, Deathmark, Smoke Bomb
  - Hunter: Turtle, Bestial Wrath, Coordinated Assault, Trueshot, Exhilaration
  - Warlock: Unending Resolve, Dark Soul, Darkglare, Demonic Tyrant, Summon Infernal
  - Monk: Dampen Harm, Diffuse Magic, Touch of Death, Fortifying Brew, Xuen, Revival
  - Evoker: Dragonrage, Stasis, Rewind, Dream Flight
- Stack/charge support for abilities with multiple charges
- Validation for cooldown data integrity
- Comprehensive documentation and usage examples

### Features
- Automatic indexing by key, class, and spec for efficient lookups
- Duplicate registration prevention
- Extensible architecture for custom cooldowns
- No dependencies beyond LibStub
- Minimal memory footprint
- Compatible with WoW Interface 11.0.2 (The War Within)

## [Unreleased]

### Planned
- Extended racial ability database
- Trinket cooldown support
- Item cooldown tracking
- Optional integration with spell database addons
- Cooldown event callbacks
- Configuration API for addon-specific overrides
