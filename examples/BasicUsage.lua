--[[
    Example: Basic Usage of MajorCooldowns Library
    
    This file demonstrates how to use the MajorCooldowns library in your addon.
]]

-- Get the library instance
local MajorCooldowns = LibStub("MajorCooldowns-1.0")
if not MajorCooldowns then
    print("MajorCooldowns library not found!")
    return
end

-- Example 1: Get all cooldowns for a specific class
local function Example_GetClassCooldowns()
    local warriorCooldowns = MajorCooldowns:GetByClass("WARRIOR")
    
    print("Warrior Cooldowns:")
    for _, cd in ipairs(warriorCooldowns) do
        print(string.format("  - %s (Spell ID: %d, Duration: %ds, Category: %s)", 
            cd.key, cd.spellID, cd.duration, cd.category))
    end
end

-- Example 2: Get cooldowns applicable to player's current spec
local function Example_GetPlayerCooldowns()
    local _, _, classID = UnitClass("player")
    local specIndex = GetSpecialization()
    
    if not specIndex then
        print("No spec selected")
        return
    end
    
    local specID = GetSpecializationInfo(specIndex)
    local cooldowns = MajorCooldowns:GetApplicable(classID, specID)
    
    print(string.format("Cooldowns for your spec (ID: %d):", specID))
    for _, cd in ipairs(cooldowns) do
        local spellName = GetSpellInfo(cd.spellID)
        print(string.format("  - %s: %ds cooldown", spellName or cd.key, cd.duration))
    end
end

-- Example 3: Filter cooldowns by category
local function Example_FilterByCategoryAndPriority()
    local _, _, classID = UnitClass("player")
    local specIndex = GetSpecialization()
    if not specIndex then return end
    
    local specID = GetSpecializationInfo(specIndex)
    local cooldowns = MajorCooldowns:GetApplicable(classID, specID)
    
    -- Filter defensive cooldowns with high priority
    print("High Priority Defensive Cooldowns:")
    for _, cd in ipairs(cooldowns) do
        if cd.category == MajorCooldowns.Category.DEFENSIVE and 
           cd.priority >= MajorCooldowns.Priority.HIGH then
            local spellName = GetSpellInfo(cd.spellID)
            print(string.format("  - %s (Priority: %d)", spellName or cd.key, cd.priority))
        end
    end
end

-- Example 4: Get a specific cooldown by key
local function Example_GetSpecificCooldown()
    local rally = MajorCooldowns:GetByKey("WAR_RALLY")
    
    if rally then
        local spellName = GetSpellInfo(rally.spellID)
        print(string.format("Found: %s", spellName or rally.key))
        print(string.format("  Duration: %ds", rally.duration))
        print(string.format("  Category: %s", rally.category))
        print(string.format("  Priority: %d", rally.priority))
        print(string.format("  Stacks: %d", rally.stack))
    end
end

-- Example 5: Track cooldown status
local function Example_TrackCooldownStatus()
    local _, _, classID = UnitClass("player")
    local specIndex = GetSpecialization()
    if not specIndex then return end
    
    local specID = GetSpecializationInfo(specIndex)
    local cooldowns = MajorCooldowns:GetApplicable(classID, specID)
    
    print("Current Cooldown Status:")
    for _, cd in ipairs(cooldowns) do
        local start, duration = GetSpellCooldown(cd.spellID)
        local spellName = GetSpellInfo(cd.spellID)
        
        if start and start > 0 and duration > 0 then
            local remaining = duration - (GetTime() - start)
            if remaining > 0 then
                print(string.format("  - %s: %.1fs remaining", 
                    spellName or cd.key, remaining))
            else
                print(string.format("  - %s: Ready!", spellName or cd.key))
            end
        else
            print(string.format("  - %s: Ready!", spellName or cd.key))
        end
    end
end

-- Example 6: Register a custom cooldown
local function Example_RegisterCustomCooldown()
    -- Register a custom ability (example only, this spell ID may not be valid)
    MajorCooldowns:RegisterClassAbility({
        key = "CUSTOM_ABILITY",
        class = "WARRIOR",
        specs = { 71 }, -- Arms only
        spellID = 999999,
        duration = 60,
        category = MajorCooldowns.Category.OFFENSIVE,
        priority = MajorCooldowns.Priority.MEDIUM,
        defaultEnabled = true,
        stack = 2,
    })
    
    print("Custom cooldown registered!")
    
    -- Retrieve it
    local custom = MajorCooldowns:GetByKey("CUSTOM_ABILITY")
    if custom then
        print(string.format("  Key: %s", custom.key))
        print(string.format("  Duration: %ds", custom.duration))
        print(string.format("  Stacks: %d", custom.stack))
    end
end

-- Example 7: Sort cooldowns by priority
local function Example_SortByPriority()
    local _, _, classID = UnitClass("player")
    local specIndex = GetSpecialization()
    if not specIndex then return end
    
    local specID = GetSpecializationInfo(specIndex)
    local cooldowns = MajorCooldowns:GetApplicable(classID, specID)
    
    -- Sort by priority (highest first)
    table.sort(cooldowns, function(a, b)
        return (a.priority or 0) > (b.priority or 0)
    end)
    
    print("Cooldowns sorted by priority:")
    for i, cd in ipairs(cooldowns) do
        local spellName = GetSpellInfo(cd.spellID)
        print(string.format("  %d. %s (Priority: %d)", 
            i, spellName or cd.key, cd.priority))
    end
end

-- Example 8: Create a simple cooldown frame
local function Example_CreateCooldownDisplay()
    local frame = CreateFrame("Frame", "MajorCooldownsExample", UIParent)
    frame:SetSize(200, 300)
    frame:SetPoint("CENTER")
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetBackdropColor(0, 0, 0, 0.8)
    
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Major Cooldowns")
    
    -- Add cooldown icons (simplified example)
    local _, _, classID = UnitClass("player")
    local specIndex = GetSpecialization()
    if not specIndex then return end
    
    local specID = GetSpecializationInfo(specIndex)
    local cooldowns = MajorCooldowns:GetApplicable(classID, specID)
    
    local yOffset = -40
    for i, cd in ipairs(cooldowns) do
        if i > 5 then break end -- Limit to 5 cooldowns
        
        local iconFrame = CreateFrame("Frame", nil, frame)
        iconFrame:SetSize(32, 32)
        iconFrame:SetPoint("TOPLEFT", 10, yOffset)
        
        local texture = iconFrame:CreateTexture(nil, "ARTWORK")
        texture:SetAllPoints()
        texture:SetTexture(GetSpellTexture(cd.spellID))
        
        local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("LEFT", iconFrame, "RIGHT", 5, 0)
        local spellName = GetSpellInfo(cd.spellID)
        text:SetText(spellName or cd.key)
        
        yOffset = yOffset - 40
    end
    
    frame:Show()
    print("Cooldown display frame created!")
end

-- Run examples when addon loads
local function RunExamples()
    print("=== MajorCooldowns Library Examples ===")
    print("")
    
    -- Uncomment the examples you want to run:
    -- Example_GetClassCooldowns()
    -- Example_GetPlayerCooldowns()
    -- Example_FilterByCategoryAndPriority()
    -- Example_GetSpecificCooldown()
    -- Example_TrackCooldownStatus()
    -- Example_RegisterCustomCooldown()
    -- Example_SortByPriority()
    -- Example_CreateCooldownDisplay()
end

-- Register event to run examples after player login
local exampleFrame = CreateFrame("Frame")
exampleFrame:RegisterEvent("PLAYER_LOGIN")
exampleFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        -- Wait a bit to ensure everything is loaded
        C_Timer.After(2, RunExamples)
    end
end)
