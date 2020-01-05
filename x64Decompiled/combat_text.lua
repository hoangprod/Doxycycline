COMBAT_TEXT_MAX_COUNT = 30
COMBAT_TEXT_COLOR = {}
COMBAT_TEXT_COLOR.DAMAGED_SWING = {
  r = 0.9,
  g = 0.75,
  b = 0.75,
  a = 1
}
COMBAT_TEXT_COLOR.DAMAGED_SWING.CRITICAL = {
  r = 0.9,
  g = 0.75,
  b = 0.75,
  a = 1
}
COMBAT_TEXT_COLOR.DAMAGED_SPELL = {
  r = 0.83,
  g = 0.16,
  b = 0.23,
  a = 1
}
COMBAT_TEXT_COLOR.DAMAGED_SPELL.DOT = {
  r = 0.83,
  g = 0.16,
  b = 0.23,
  a = 1
}
COMBAT_TEXT_COLOR.DAMAGED_SPELL.CRITICAL = {
  r = 0.83,
  g = 0.16,
  b = 0.23,
  a = 1
}
COMBAT_TEXT_COLOR.DEBUFF = {
  r = 0.7,
  g = 0.17,
  b = 0.8,
  a = 1
}
COMBAT_TEXT_COLOR.MISSED = {
  r = 0.9,
  g = 0.75,
  b = 0.75,
  a = 1
}
COMBAT_TEXT_COLOR.MISSED.MISS = {
  r = 0.9,
  g = 0.75,
  b = 0.75,
  a = 1
}
COMBAT_TEXT_COLOR.MISSED.DODGE = {
  r = 0.9,
  g = 0.75,
  b = 0.75,
  a = 1
}
COMBAT_TEXT_COLOR.SWING = {
  r = 1,
  g = 1,
  b = 1,
  a = 1
}
COMBAT_TEXT_COLOR.SWING.MISS = {
  r = 0.77,
  g = 0.84,
  b = 0.88,
  a = 1
}
COMBAT_TEXT_COLOR.SWING.DODGE = {
  r = 0.77,
  g = 0.85,
  b = 0.88,
  a = 1
}
COMBAT_TEXT_COLOR.SWING.BLOCK = {
  r = 0.77,
  g = 0.85,
  b = 0.88,
  a = 1
}
COMBAT_TEXT_COLOR.SWING.PARRY = {
  r = 0.77,
  g = 0.85,
  b = 0.88,
  a = 1
}
COMBAT_TEXT_COLOR.SWING.IMMUNE = {
  r = 0.77,
  g = 0.85,
  b = 0.88,
  a = 1
}
COMBAT_TEXT_COLOR.SWING.RESIST = {
  r = 0.77,
  g = 0.85,
  b = 0.88,
  a = 1
}
COMBAT_TEXT_COLOR.SWING.CRITICAL = {
  r = 1,
  g = 1,
  b = 1,
  a = 1
}
COMBAT_TEXT_COLOR.SWING.ABSORB = {
  r = 0.77,
  g = 0.85,
  b = 0.88,
  a = 1
}
COMBAT_TEXT_COLOR.SWING.REFLECT = {
  r = 0.77,
  g = 0.85,
  b = 0.88,
  a = 1
}
COMBAT_TEXT_COLOR.SKILL = {
  r = 1,
  g = 0.82,
  b = 0.05,
  a = 1
}
COMBAT_TEXT_COLOR.DOT = {
  r = 1,
  g = 0.82,
  b = 0.05,
  a = 1
}
COMBAT_TEXT_COLOR.HEAL = {
  r = 0.3,
  g = 0.85,
  b = 0.2,
  a = 1
}
COMBAT_TEXT_COLOR.ENERGIZE_MP = {
  r = 0.06,
  g = 0.36,
  b = 0.93,
  a = 1
}
COMBAT_TEXT_COLOR.DAMAGE_MP = {
  r = 0.06,
  g = 0.36,
  b = 0.93,
  a = 1
}
COMBAT_TEXT_COLOR.SYNERGY = {
  r = 1,
  g = 0.82,
  b = 0.05,
  a = 1
}
COMBAT_TEXT_COLOR.COMBAT_START = {
  r = 0.83,
  g = 0.08,
  b = 0.08,
  a = 1
}
COMBAT_TEXT_COLOR.COMBAT_END = {
  r = 0.83,
  g = 0.08,
  b = 0.08,
  a = 1
}
COMBAT_TEXT_COLOR.GAIN_EXP = {
  r = 0.98,
  g = 0.34,
  b = 0.47,
  a = 1
}
COMBAT_TEXT_COLOR.GAIN_HONOR_POINT = {
  r = 0.51,
  g = 0.9,
  b = 1,
  a = 1
}
COMBAT_TEXT_COLOR.LOSE_HONOR_POINT = {
  r = 0.83,
  g = 0.08,
  b = 0.08,
  a = 1
}
COMBAT_TEXT_COLOR.COLLISION_ME = {
  r = 0.92,
  g = 0.8,
  b = 0.78,
  a = 1
}
COMBAT_TEXT_COLOR.COLLISION_OTHER = {
  r = 0.94,
  g = 0.36,
  b = 0.35,
  a = 1
}
local gainExpWidget
local oldGainExp = 0
function CreateCombatTextFrame(id, parent, maxCount)
  local frame = CreateEmptyWindow(id, parent)
  frame:Clickable(false)
  for i = 1, maxCount do
    local combatText = frame:CreateChildWidget("damagedisplay", "combatTexts", i, true)
    combatText:Clickable(false)
    combatText:SetExtent(142, 82)
    combatText:Show(false)
    combatText.style:SetFont(combatTextLocale.fontPath, combatTextLocale.fontSize)
    combatText.style:SetColor(0.96, 0.96, 0.96, 1)
    combatText.style:SetAlign(ALIGN_CENTER)
    combatText.extraStyle:SetFont("ui/font/yoon_firedgothic_b.ttf", combatTextLocale.fontSize)
    combatText.extraStyle:SetColor(0.96, 0.96, 0.96, 1)
    combatText.extraStyle:SetAlign(ALIGN_CENTER)
    local drawable = combatText:CreateImageDrawable("ui/hud/critical.dds", "background")
    drawable:AddAnchor("CENTER", combatText, combatTextLocale.drawableAnchor.x, combatTextLocale.drawableAnchor.y)
    drawable:SetExtent(142, 82)
    drawable:SetColor(1, 1, 1, 0.8)
    combatText.drawable = drawable
    if i == maxCount then
      gainExpWidget = combatText
    end
  end
  return frame
end
combatTextFrame = CreateCombatTextFrame("combatTextFrame", "UIParent", COMBAT_TEXT_MAX_COUNT)
combatTextFrame:Show(true)
local ClockPositionCount = 1
local function SetClockPosition(pos)
  local Randompos
  Randompos = {
    x = pos.x,
    y = pos.y,
    z = pos.z
  }
  if ClockPositionCount == 1 then
    Randompos.x = Randompos.x - 50
    Randompos.y = Randompos.y - 50
    ClockPositionCount = ClockPositionCount + 1
  elseif ClockPositionCount == 2 then
    Randompos.x = Randompos.x - 50
    Randompos.y = Randompos.y + 50
    ClockPositionCount = ClockPositionCount + 1
  elseif ClockPositionCount == 3 then
    Randompos.x = Randompos.x + 50
    Randompos.y = Randompos.y - 50
    ClockPositionCount = ClockPositionCount + 1
  elseif ClockPositionCount == 4 then
    Randompos.x = Randompos.x + 50
    Randompos.y = Randompos.y + 50
    ClockPositionCount = ClockPositionCount + 1
  elseif ClockPositionCount == 5 then
    Randompos.x = Randompos.x
    Randompos.y = Randompos.y - 70
    ClockPositionCount = ClockPositionCount + 1
  elseif ClockPositionCount == 6 then
    Randompos.x = Randompos.x - 80
    Randompos.y = Randompos.y
    ClockPositionCount = ClockPositionCount + 1
  elseif ClockPositionCount == 7 then
    Randompos.x = Randompos.x
    Randompos.y = Randompos.y + 70
    ClockPositionCount = ClockPositionCount + 1
  elseif ClockPositionCount == 8 then
    Randompos.x = Randompos.x + 80
    Randompos.y = Randompos.y
    ClockPositionCount = 1
  end
  return Randompos
end
local SetRandomPosition = function(pos)
  local Randompos = {
    x = pos.x,
    y = pos.y,
    z = pos.z
  }
  Randompos.x = Randompos.x + math.random(-3, 3) * 20
  Randompos.y = Randompos.y + math.random(-5, 5) * 3
  return Randompos
end
local function CorrentPosition(skillType, hitOrMissType)
  local pos = {
    x = 0,
    y = 0,
    z = 0
  }
  if skillType == "DAMAGED_SWING" then
    pos.y = pos.y + 60
  elseif skillType == "MISSED" then
    pos.x = pos.x - 120
    pos.y = pos.y - 20
  elseif skillType == "DAMAGED_SPELL" then
    pos = SetRandomPosition(pos)
    pos.y = pos.y + 10
  elseif skillType == "SWING" then
    pos = SetRandomPosition(pos)
    pos.y = pos.y - 100
  elseif skillType == "SKILL" then
    pos = SetClockPosition(pos)
    pos.y = pos.y - 120
  elseif skillType == "DOT" then
    pos = SetRandomPosition(pos)
    pos.y = pos.y - 70
  elseif skillType == "ENERGIZE_MP" then
    pos = SetRandomPosition(pos)
  elseif skillType == "DAMAGE_MP" then
    pos = SetRandomPosition(pos)
  elseif skillType == "HEAL" then
    pos = SetRandomPosition(pos)
    pos.y = pos.y - 100
  elseif skillType == "SYNERGY" then
    pos.x = pos.x + 140
    pos.y = pos.y - 30
  elseif skillType == "COMBAT_START" then
    pos.y = pos.y - 150
  elseif skillType == "COMBAT_END" then
    pos.y = pos.y - 150
  elseif skillType == "GAIN_EXP" then
    pos.y = pos.y - 120
  elseif skillType == "BUFF_REMOVED" then
    pos.y = pos.y + 100
  elseif skillType == "GAIN_HONOR_POINT" then
    pos.x = pos.x + 100
  elseif skillType == "LOSE_HONOR_POINT" then
    pos.x = pos.x + 100
    pos.y = pos.y + 50
  elseif skillType == "COLLISION" then
    pos.x = pos.x + 100
    pos.y = pos.y - 100
  end
  if hitOrMissType == "MISS" then
    pos.y = pos.y - 0.7
    pos.z = pos.z - 2
  elseif hitOrMissType == "DODGE" then
    pos.y = pos.y - 1
    pos.z = pos.z - 0.8
  elseif hitOrMissType == "BLOCK" then
    pos.y = pos.y - 1
    pos.z = pos.z - 2.8
  elseif hitOrMissType == "PARRY" then
    pos.y = pos.y - 1.3
    pos.z = pos.z - 2.2
  elseif hitOrMissType == "IMMUNE" then
    pos.y = pos.y + 1
    pos.z = pos.z - 2.8
  elseif hitOrMissType == "RESIST" then
    pos.y = pos.y - 1
    pos.z = pos.z - 2
  elseif hitOrMissType == "CRITICAL" or hitOrMissType == "ABSORB" or hitOrMissType == "REFLECT" then
    pos.y = pos.y + 1
    pos.z = pos.z - 2.8
  end
  return pos
end
local SetTextColor = function(skillType, hitOrMissType)
  local color = {
    r = 0.84,
    g = 0.84,
    b = 0.84,
    a = 1
  }
  local damage_color = COMBAT_TEXT_COLOR[skillType]
  if damage_color ~= nil then
    local hitColor = damage_color[hitOrMissType]
    if damage_color.r ~= nil and damage_color.g ~= nil and damage_color.b ~= nil and damage_color.a ~= nil then
      color = damage_color
    end
    if hitColor ~= nil then
      color = hitColor
    end
  end
  return color
end
local function CombatText_Add(sourceUnitId, targetUnitId, combatText, skillType, hitOrMissType, animType, distance, posCalcType)
  local combatTextWidget
  if skillType == "GAIN_EXP" then
    combatTextWidget = gainExpWidget
  else
    for i = 1, COMBAT_TEXT_MAX_COUNT - 1 do
      if combatTextFrame.combatTexts[i]:IsVisible() == false then
        combatTextWidget = combatTextFrame.combatTexts[i]
      end
    end
  end
  if combatTextWidget == nil then
    return
  end
  if combatTextWidget:IsVisible() == false then
    if targetUnitId == nil then
      targetUnitId = X2Unit:GetUnitId("player")
    end
    combatTextWidget:SetUnitId(sourceUnitId or "", targetUnitId)
    combatTextWidget:SetText(combatText)
    combatTextWidget:SetPositionCalculationType(posCalcType or PCT_DEFAULT)
    local pos = CorrentPosition(skillType, hitOrMissType)
    local color = SetTextColor(skillType, hitOrMissType)
    if pos ~= nil then
      combatTextWidget:SetInitPos(pos.x, pos.y)
    else
      combatTextWidget:SetInitPos(UIParent:GetScreenWidth() / 2, UIParent:GetScreenHeight() / 2)
    end
    combatTextWidget.extraStyle:SetColor(color.r, color.g, color.b, color.a)
    combatTextWidget.style:SetColor(color.r, color.g, color.b, color.a)
    local effectFrame = GetCombatTextEffect(animType)
    if effectFrame ~= nil then
      combatTextWidget.drawable:SetAnimFrameInfo(effectFrame)
      combatTextWidget.drawable:Animation(true, false)
    else
      combatTextWidget.drawable:SetVisible(false)
    end
    local animFrame = GetCombatTextAnimation(animType)
    if animFrame == nil then
      animFrame = GetCombatTextAnimation(CTA_DMGPOPUP)
    end
    if animFrame ~= nil then
      combatTextWidget:SetAnimFrameInfo(animFrame)
      combatTextWidget:Animation(true)
    end
    return
  end
end
local hitOrMissTypeToStr = function(hitOrMissType)
  if hitOrMissType == "CRITICAL" then
    return locale.combat.critical
  end
end
local missTypeToStr = function(missType)
  if missType == "MISS" then
    return locale.combat.miss
  elseif missType == "DODGE" then
    return locale.combat.dodge
  elseif missType == "BLOCK" then
    return locale.combat.block
  elseif missType == "PARRY" then
    return locale.combat.parry
  elseif missType == "IMMUNE" then
    return locale.combat.immune
  elseif missType == "RESIST" then
    return locale.combat.resist
  end
end
local function DamageToMe(targetUnitId, combatEvent, source, target, ...)
  if targetUnitId ~= X2Unit:GetUnitId("player") then
    return
  end
  local pos = combatEvent:find("_")
  local prefix = combatEvent:sub(1, pos - 1)
  local suffix = combatEvent:sub(pos + 1)
  local result = ParseCombatMessage(combatEvent, ...)
  local combatText = ""
  if result.damage ~= nil then
    combatText = tostring(-result.damage)
  end
  if combatEvent == "MELEE_DAMAGE" then
    if result.hitType == "HIT" then
      if result.weaponUsageDamage > 0 then
        CombatText_Add(nil, nil, combatText, "DAMAGED_SWING", nil, CTA_WEAPONATTACK)
      else
        CombatText_Add(nil, nil, combatText, "DAMAGED_SWING", nil, CTA_BASICATTACK)
      end
    elseif result.hitType == "CRITICAL" then
      if result.weaponUsageDamage > 0 then
        CombatText_Add(nil, nil, combatText, "DAMAGED_SPELL", result.hitType, CTA_WEAPONFATALME)
      else
        CombatText_Add(nil, nil, combatText, "DAMAGED_SPELL", result.hitType, CTA_FATALATTACKME)
      end
    end
  elseif prefix == "SPELL" then
    if suffix == "DAMAGE" or suffix == "DRAIN" or suffix == "LEECH" then
      if result.hitType == "HIT" then
        if result.weaponUsageDamage > 0 then
          if result.synergy == true then
            CombatText_Add(nil, nil, combatText, "DAMAGED_SPELL", nil, CTA_WEAPONCHAIN)
          else
            CombatText_Add(nil, nil, combatText, "DAMAGED_SPELL", nil, CTA_WEAPONATTACK)
          end
        elseif result.synergy == true then
          CombatText_Add(nil, nil, combatText, "DAMAGED_SPELL", nil, CTA_CHAINNEW)
        else
          CombatText_Add(nil, nil, combatText, "DAMAGED_SPELL", nil, CTA_BASICATTACK)
        end
      elseif result.hitType == "CRITICAL" then
        if result.weaponUsageDamage > 0 then
          if result.synergy == true then
            CombatText_Add(nil, nil, combatText, "DAMAGED_SPELL", result.hitType, CTA_WEAPONCHAINFATALME)
          else
            CombatText_Add(nil, nil, combatText, "DAMAGED_SPELL", result.hitType, CTA_WEAPONFATALME)
          end
        elseif result.synergy == true then
          CombatText_Add(nil, nil, combatText, "DAMAGED_SPELL", result.hitType, CTA_CHAINFATALME)
        else
          CombatText_Add(nil, nil, combatText, "DAMAGED_SPELL", result.hitType, CTA_FATALATTACKME)
        end
      end
    elseif suffix == "DOT_DAMAGE" then
      if result.hitType == "HIT" then
        if result.synergy == true then
          CombatText_Add(nil, nil, combatText, "DAMAGED_SPELL", "DOT", CTA_DOTCHAIN)
        else
          CombatText_Add(nil, nil, combatText, "DAMAGED_SPELL", "DOT", CTA_DOTDAM)
        end
      elseif result.hitType == "CRITICAL" then
        if result.synergy == true then
          CombatText_Add(nil, nil, combatText, "DAMAGED_SPELL", "DOT", CTA_DOTCHAINFATAL)
        else
          CombatText_Add(nil, nil, combatText, "DAMAGED_SPELL", "DOT", CTA_DOTFATAL)
        end
      end
    elseif suffix == "AURA_APPLIED" and result.combatText == true then
      if result.auraType == "BUFF" then
        CombatText_Add(nil, nil, result.spellName, "HEAL", nil, CTA_TEXTINFOBUFF)
      elseif result.auraType == "DEBUFF" then
        CombatText_Add(nil, nil, result.spellName, "DEBUFF", nil, CTA_TEXTINFOBUFF)
      end
    elseif suffix == "AURA_REMOVED" and result.combatText == true then
      CombatText_Add(nil, nil, result.spellName .. " " .. locale.combat.spell_aura_removed, "BUFF_REMOVED", nil, CTA_MESSAGEDOWN)
    end
  elseif combatEvent == "ENVIRONMENTAL_DAMAGE" then
    CombatText_Add(nil, nil, combatText .. "(" .. envSourceToStr(result.source) .. ")", "DAMAGED_SWING", nil, CTA_BASICATTACK)
  end
  if suffix == "MISSED" then
    if result.missType == "MISS" then
      CombatText_Add(nil, nil, missTypeToStr(result.missType), "MISSED", result.hitOrMissType, CTA_TEXTINFOCHAIN)
    elseif result.missType == "DODGE" then
      CombatText_Add(nil, nil, missTypeToStr(result.missType), "MISSED", result.hitOrMissType, CTA_TEXTINFOCHAIN)
    elseif result.missType == "BLOCK" or result.missType == "PARRY" then
      combatText = missTypeToStr(result.missType) .. " " .. combatText
      CombatText_Add(nil, nil, combatText, "MISSED", nil, CTA_TEXTINFOCHAIN)
    else
      CombatText_Add(nil, nil, missTypeToStr(result.missType), "MISSED", nil, CTA_TEXTINFOCHAIN)
    end
  elseif suffix == "HEALED" and 0 < result.heal then
    if result.hitType == "HIT" then
      if result.synergy == true then
        CombatText_Add(nil, nil, "+" .. tostring(result.heal), "HEAL", nil, CTA_HEALCHAIN)
      else
        CombatText_Add(nil, nil, "+" .. tostring(result.heal), "HEAL", nil, CTA_NEWHEAL)
      end
    elseif result.hitType == "CRITICAL" then
      if result.synergy == true then
        CombatText_Add(nil, nil, "+" .. tostring(result.heal), "HEAL", nil, CTA_HEALCHAINFATAL)
      else
        CombatText_Add(nil, nil, "+" .. tostring(result.heal), "HEAL", nil, CTA_HEALFATAL)
      end
    end
  elseif suffix == "ENERGIZE" and 0 < result.amount then
    if result.powerType == "HEALTH" then
      CombatText_Add(nil, nil, "+" .. tostring(result.amount), "HEAL", nil, CTA_MPENERGIZE)
    else
      CombatText_Add(nil, nil, "+" .. tostring(result.amount), "ENERGIZE_MP", nil, CTA_MPENERGIZE)
    end
  end
end
local function DamageToOthers(sourceUnitId, targetUnitId, amount, skillType, hitOrMissType, weaponDamage, isSynergy, distance)
  if W_UNIT.IsMyUnitId(targetUnitId) then
    return
  end
  local animType = CTA_DMGPOPUP
  local combatText = tostring(-amount)
  if skillType == "SWING" then
    if hitOrMissType == "CRITICAL" then
      if weaponDamage ~= nil and weaponDamage > 0 then
        if isSynergy == true then
          animType = CTA_WEAPONCHAINFATAL
        else
          animType = CTA_WEAPONFATAL
        end
      elseif isSynergy == true then
        animType = CTA_CHAINFATAL
      else
        animType = CTA_FATALATTACK
      end
    elseif weaponDamage ~= nil and weaponDamage > 0 then
      if isSynergy == true then
        animType = CTA_WEAPONCHAIN
      else
        animType = CTA_WEAPONATTACK
      end
    elseif isSynergy == true then
      animType = CTA_CHAINNEW
    else
      animType = CTA_BASICATTACK
    end
  elseif skillType == "SKILL" then
    if hitOrMissType == "CRITICAL" then
      if weaponDamage ~= nil and weaponDamage > 0 then
        if isSynergy == true then
          animType = CTA_WEAPONCHAINFATAL
        else
          animType = CTA_WEAPONFATAL
        end
      elseif isSynergy == true then
        animType = CTA_CHAINFATAL
      else
        animType = CTA_FATALATTACKME
      end
    elseif weaponDamage ~= nil and weaponDamage > 0 then
      if isSynergy == true then
        animType = CTA_WEAPONCHAIN
      else
        animType = CTA_WEAPONATTACK
      end
    elseif isSynergy == true then
      animType = CTA_CHAINNEW
    else
      animType = CTA_BASICATTACK
    end
  elseif skillType == "DOT" then
    combatText = tostring(-amount)
    if hitOrMissType == "CRITICAL" then
      if isSynergy == true then
        animType = CTA_DOTCHAINFATAL
      else
        animType = CTA_DOTFATAL
      end
    elseif isSynergy == true then
      animType = CTA_DOTCHAIN
    else
      animType = CTA_DOTDAM
    end
  elseif skillType == "MANA" then
    if amount > 0 then
      skillType = "ENERGIZE_MP"
      animType = CTA_MPENERGIZE
      combatText = "+" .. tostring(amount)
    else
      skillType = "DAMAGE_MP"
      animType = CTA_MPDAMAGE
      combatText = tostring(amount)
    end
  elseif skillType == "HEAL" and amount > 0 then
    if hitOrMissType == "CRITICAL" then
      if isSynergy == true then
        animType = CTA_HEALCHAINFATAL
      else
        animType = CTA_HEALFATAL
      end
    elseif isSynergy == true then
      animType = CTA_HEALCHAIN
    else
      animType = CTA_NEWHEAL
    end
    combatText = "+" .. tostring(amount)
  end
  if hitOrMissType == "MISS" or hitOrMissType == "DODGE" or hitOrMissType == "IMMUNE" or hitOrMissType == "RESIST" then
    animType = CTA_TEXTINFOCHAIN
    combatText = missTypeToStr(hitOrMissType) or hitOrMissType
  end
  if hitOrMissType == "BLOCK" or hitOrMissType == "PARRY" then
    animType = CTA_TEXTINFOCHAIN
    combatText = tostring(-amount)
    combatText = missTypeToStr(hitOrMissType) .. " " .. combatText
  end
  if isSynergy == true then
    combatText = locale.combat.combat_text_synergy_damage .. " " .. combatText
  end
  CombatText_Add(sourceUnitId, targetUnitId, combatText, skillType, hitOrMissType, animType, distance)
end
local function DamageFromCollision(targetUnitId, combatEvent, source, target, ...)
  local pos = combatEvent:find("_")
  local prefix = combatEvent:sub(1, pos - 1)
  local suffix = combatEvent:sub(pos + 1)
  local result = ParseCombatMessage(combatEvent, ...)
  local combatText = ""
  if result.damage ~= nil then
    combatText = tostring(-result.damage)
  end
  local skillType = "COLLISION_ME"
  if not result.mySlave then
    skillType = "COLLISION_OTHER"
  end
  CombatText_Add(nil, targetUnitId, combatText .. "(" .. envSourceToStr(result.source, result.subType) .. ")", skillType, nil, CTA_BASICATTACK, nil, PCT_SHIP_COLLISION)
end
local damageDisplayEvents = {
  COMBAT_MSG = function(...)
    DamageToMe(unpack(arg))
  end,
  COMBAT_TEXT = function(...)
    DamageToOthers(unpack(arg))
  end,
  COMBAT_TEXT_COLLISION = function(...)
    DamageFromCollision(unpack(arg))
  end,
  COMBAT_TEXT_SYNERGY = function(...)
    CombatText_Add(nil, nil, locale.combat.combat_text_synergy, "SYNERGY", nil, CTA_TEXTINFOCHAIN)
  end,
  UNIT_COMBAT_STATE_CHANGED = function(...)
    if arg[2] == X2Unit:GetUnitId("player") then
      if arg[1] == true then
        CombatText_Add(nil, nil, locale.combat.player_enter_combat, "COMBAT_START", nil, CTA_FIGHTSTART)
      else
        CombatText_Add(nil, nil, locale.combat.player_leave_combat, "COMBAT_END", nil, CTA_FIGHTSTART)
      end
    end
  end,
  MILEAGE_CHANGED = function(...)
  end,
  EXP_CHANGED = function(...)
    if X2Unit:GetUnitId("player") == arg[1] and 1 <= arg[2] then
      local amount = arg[3]
      if gainExpWidget ~= nil then
        if gainExpWidget:IsVisible() then
          oldGainExp = X2Util:StrNumericAdd(oldGainExp, amount)
          gainExpWidget:SetText(GetUIText(COMMON_TEXT, "exp") .. " +" .. oldGainExp)
          return
        else
          oldGainExp = amount
        end
      end
      CombatText_Add(nil, nil, GetUIText(COMMON_TEXT, "exp") .. " +" .. amount, "GAIN_EXP", nil, CTA_EXPUP)
    end
  end,
  PLAYER_HONOR_POINT_CHANGED_IN_HPW = function(amount)
    local sign = amount > 0 and "+" or ""
    local msg = string.format("%s %s%d", GetUIText(COMMON_TEXT, "honor_point"), sign, amount)
    if amount > 0 then
      CombatText_Add(nil, nil, msg, "GAIN_HONOR_POINT", nil, CTA_EXPUP)
    else
      CombatText_Add(nil, nil, msg, "LOSE_HONOR_POINT", nil, CTA_MOVEDOWN)
    end
  end
}
combatTextFrame:SetHandler("OnEvent", function(this, event, ...)
  damageDisplayEvents[event](...)
end)
RegistUIEvent(combatTextFrame, damageDisplayEvents)
