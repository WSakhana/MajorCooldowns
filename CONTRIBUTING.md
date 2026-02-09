# Contributing to MajorCooldowns

Thank you for considering contributing to MajorCooldowns! This document provides guidelines for contributing to the project.

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:

1. Check if the issue already exists in the [GitHub Issues](https://github.com/WSakhana/MajorCooldowns/issues)
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - WoW version and addon version

### Adding or Updating Cooldowns

The most common contribution is adding missing cooldowns or updating existing ones.

#### Cooldown Data Format

Each cooldown entry should follow this structure:

```lua
{
    key = "UNIQUE_KEY",              -- Unique identifier (e.g., "WAR_RALLY")
    class = Classes.CLASSNAME.id,    -- Class ID
    specs = { specID1, specID2 },    -- Spec IDs (empty = all specs)
    spellID = 12345,                 -- Spell ID from game
    duration = 180,                  -- Cooldown duration in seconds
    category = Category.TYPE,        -- Category (see below)
    priority = Priority.LEVEL,       -- Priority level (see below)
    defaultEnabled = true/false,     -- Whether enabled by default
    stack = 1,                       -- Number of charges (optional, default 1)
}
```

#### Categories

Use the appropriate category:
- `Category.DEFENSIVE` - Defensive cooldowns (shields, damage reduction)
- `Category.OFFENSIVE` - Offensive cooldowns
- `Category.BURST` - Burst damage/throughput cooldowns
- `Category.HEALING` - Healing cooldowns
- `Category.UTILITY` - Utility abilities
- `Category.MOVEMENT` - Movement abilities
- `Category.CROWD_CONTROL` - CC abilities

#### Priority Levels

- `Priority.CRITICAL` (15) - Game-changing abilities
- `Priority.VERY_HIGH` (12) - Major defensive/offensive CDs
- `Priority.HIGH` (10) - Important cooldowns
- `Priority.MEDIUM` (8) - Useful abilities
- `Priority.NORMAL` (6) - Standard cooldowns
- `Priority.LOW` (4) - Minor abilities

#### Adding a Cooldown

1. Find the class section in `MajorCooldowns-1.0.lua`
2. Add your cooldown to the `classAbilities` table
3. Follow the existing format and style
4. Test your addition with the validation script

Example:
```lua
-- In the WARRIOR section
{ 
    key = "WAR_NEW_ABILITY", 
    class = Classes.WARRIOR.id, 
    specs = { Specs.WARRIOR_ARMS.id }, 
    spellID = 12345, 
    duration = 120, 
    category = Category.BURST, 
    priority = Priority.HIGH, 
    defaultEnabled = true 
},
```

### Finding Spell IDs

To find the correct spell ID:

1. In-game, use `/dump GetSpellInfo("Spell Name")`
2. Check [Wowhead](https://www.wowhead.com/) - the spell ID is in the URL
3. Use the [WoW API documentation](https://warcraft.wiki.gg/)

### Testing Your Changes

Before submitting:

1. Ensure the addon loads without errors in WoW
2. Run the validation script: `lua5.3 validate.lua`
3. Test that your cooldown appears correctly when queried
4. Verify the spell ID is correct in-game

### Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/add-new-cooldown`)
3. Make your changes
4. Test thoroughly
5. Commit with a clear message
6. Push to your fork
7. Create a Pull Request with:
   - Description of changes
   - Which cooldowns were added/modified
   - Testing performed
   - Screenshots if applicable

### Code Style

- Use 4 spaces for indentation (not tabs)
- Keep lines under 100 characters when possible
- Follow the existing naming conventions:
  - `UPPER_SNAKE_CASE` for keys (e.g., `WAR_RALLY`)
  - `PascalCase` for table names (e.g., `Classes`, `Priority`)
  - Descriptive but concise names
- Add comments for complex logic
- Keep code organized by class

### Cooldown Naming Convention

Use these prefixes for keys:
- `WAR_` - Warrior
- `PAL_` - Paladin
- `PRI_` - Priest
- `SHA_` - Shaman
- `DK_` - Death Knight
- `DH_` - Demon Hunter
- `MAG_` - Mage
- `DRU_` - Druid
- `ROG_` - Rogue
- `HUN_` - Hunter
- `WL_` - Warlock
- `MNK_` - Monk
- `EVO_` - Evoker

### Version Updates

When making changes:

1. Update the CHANGELOG.md with your changes
2. If adding new features, consider if the version number should change
3. Update README.md if adding new API methods

### Documentation

- Update README.md for new features or API changes
- Add examples if introducing new functionality
- Keep documentation clear and concise
- Include code examples where helpful

## Getting Help

If you need help:
- Open a GitHub Discussion
- Ask in the Issues section
- Check the examples folder for reference

## Code of Conduct

- Be respectful and constructive
- Focus on the code, not the person
- Help others learn and improve
- Keep discussions on-topic

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

Thank you for helping make MajorCooldowns better!
