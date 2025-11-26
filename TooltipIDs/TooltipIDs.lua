-- Tooltip IDs – 3.3.5a

local function AddLineSafe(tooltip, text)
    for i = 1, tooltip:NumLines() do
        local line = _G[tooltip:GetName().."TextLeft"..i]
        if line and line:GetText() == text then
            return
        end
    end
    tooltip:AddLine(text, 0.6, 0.8, 1)
end

-- ITEM ID
GameTooltip:HookScript("OnTooltipSetItem", function(self)
    local name, link = self:GetItem()
    if not link then return end
    local itemID = tonumber(link:match("item:(%d+)"))
    if itemID then
        AddLineSafe(self, "|cff33ff99Item ID:|r "..itemID)
    end
end)

-- SPELL ID
local function ExtractSpellIDFromTooltip(self)
    -- Primeiro tenta via GetSpell() (só funciona no Spellbook)
    local name, rank, spellID = self:GetSpell()
    if spellID and spellID > 0 then
        AddLineSafe(self, "|cff33ff99Spell ID:|r "..spellID)
        return
    end

    local numLines = self:NumLines()
    for i = 1, numLines do
        local line = _G[self:GetName().."TextLeft"..i]
        if line then
            local text = line:GetText()
            if text then
                -- detecta hyperlinks internos
                local spellid = text:match("|Hspell:(%d+)")
                if spellid then
                    AddLineSafe(self, "|cff33ff99Spell ID:|r "..spellid)
                    return
                end
            end
        end
    end
end

GameTooltip:HookScript("OnTooltipSetSpell", ExtractSpellIDFromTooltip)
ItemRefTooltip:HookScript("OnTooltipSetSpell", ExtractSpellIDFromTooltip)
GameTooltip:HookScript("OnShow", ExtractSpellIDFromTooltip)

-- BUFFS / DEBUFFS (UNIT AURAS)
hooksecurefunc(GameTooltip, "SetUnitAura", function(self)
    ExtractSpellIDFromTooltip(self)
end)

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self)
    ExtractSpellIDFromTooltip(self)
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self)
    ExtractSpellIDFromTooltip(self)
end)

-- ACTION BUTTONS / MACROS / CHAT LINKS
hooksecurefunc(GameTooltip, "SetHyperlink", function(self, link)
    if not link then return end

    local sid = link:match("spell:(%d+)")
    if sid then
        AddLineSafe(self, "|cff33ff99Spell ID:|r "..sid)
    end
end)
