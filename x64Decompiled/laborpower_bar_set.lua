local GetLaborPowerTexts = function()
  local payMethod = X2Player:GetPayMethod()
  local payLocation = X2Player:GetPayLocation()
  local featureSet = X2Player:GetFeatureSet()
  local str
  local lp = X2Player:GetGlobalLaborPower()
  local maxLp = X2Player:GetMaxLaborPower()
  local maxLocalLp = X2Player:GetMaxLocalLaborPower()
  local font_color = F_COLOR.GetColor("light_green", true)
  if maxLocalLp > 0 then
    local localLp = X2Player:GetLocalLaborPower()
    str = string.format("%s: |,%d; (|,%d; + %s|,%d;|r) / |,%d; (|,%d; + %s|,%d;|r)", locale.attribute("labor_power"), lp + localLp, lp, font_color, localLp, maxLp + maxLocalLp, maxLp, font_color, maxLocalLp)
  else
    str = string.format("%s: |,%d; / |,%d;", locale.attribute("labor_power"), lp, maxLp)
  end
  local onlineLpUp = X2Player:GetOnlineLaborPowerChargeAmount()
  local offlineLpUp = X2Player:GetOfflineLaborPowerChargeAmount()
  if onlineLpUp > 0 then
    if offlineLpUp > 0 then
      str = string.format([[
%s
%s]], str, GetUIText(INFOBAR_MENU_TIP_TEXT, "labor_power_update_tip_with_online_and_offline", tostring(onlineLpUp), tostring(offlineLpUp)))
    else
      str = string.format([[
%s
%s]], str, GetUIText(INFOBAR_MENU_TIP_TEXT, "labor_power_update_tip_with_online", tostring(onlineLpUp)))
    end
  end
  if maxLocalLp > 0 then
    str = string.format([[
%s
%s%s|r]], str, F_COLOR.GetColor("light_green", true), GetUIText(INFOBAR_MENU_TIP_TEXT, "local_labor_power_tip"))
  end
  local info = X2Player:GetRechargedLaborPowerInfo()
  if 0 < info.maxRechargedLp then
    local percent = info.rechargedLp / info.maxRechargedLp * 100
    local rechargedLpStr, maxRechargedLpStr
    if percent >= 100 then
      rechargedLpStr = string.format("%s|,%d;|r", F_COLOR.GetColor("red", true), info.rechargedLp)
      maxRechargedLpStr = string.format("%s|,%d;|r", F_COLOR.GetColor("red", true), info.maxRechargedLp)
    else
      rechargedLpStr = string.format("|,%d;", info.rechargedLp)
      maxRechargedLpStr = string.format("|,%d;", info.maxRechargedLp)
    end
    local rechargedStr = string.format("%s: %d%% (%s / %s)", GetCommonText("recharged_labor_power"), percent, rechargedLpStr, maxRechargedLpStr)
    str = string.format([[
%s

%s
%s
%s]], str, rechargedStr, GetCommonText("recharged_lp_desc1"), GetCommonText("recharged_lp_desc2"))
    str = string.format([[
%s

%s
%s]], str, GetCommonText("recharged_lp_efficiency"), GetCommonText("recharged_lp_desc3"))
    local goodStr = string.format("%s%s|r: %s %d%% ~ %d%%", F_COLOR.GetColor("bright_green", true), GetCommonText("good"), GetCommonText("lp_efficiency"), info.good, info.normal + 1)
    local normalStr = string.format("%s%s|r: %s %d%% ~ %d%%", F_COLOR.GetColor("mustard_yellow", true), GetCommonText("normal"), GetCommonText("lp_efficiency"), info.normal, info.bad + 1)
    local badStr = string.format("%s%s|r: %s %d%% ~ %d%%", F_COLOR.GetColor("red", true), GetCommonText("bad"), GetCommonText("lp_efficiency"), info.bad, 0)
    str = string.format([[
%s
%s %s %s]], str, goodStr, normalStr, badStr)
  end
  return str
end
local CreateMileageTextbox = function(id, parent)
  local textbox = parent:CreateChildWidget("textbox", id, 0, true)
  textbox.style:SetAlign(ALIGN_LEFT)
  textbox:SetHeight(FONT_SIZE.MIDDLE)
  textbox.style:SetShadow(true)
  ApplyTextColor(textbox, FONT_COLOR.MILEAGE)
  function textbox:SetMileage()
    local str = string.format("%s |bm%s;", locale.bmmileage.bmmileage, X2Player:GetBmPoint())
    textbox:SetWidth(800)
    textbox:SetText(str)
    textbox:SetWidth(textbox:GetLongestLineWidth() + 10)
  end
  textbox:SetMileage()
  local OnEnter = function(self)
    SetTargetAnchorTooltip(locale.main_menu_bar.bmmileage_tip, "BOTTOMLEFT", self, "TOPLEFT", -1, -1)
  end
  textbox:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  textbox:SetHandler("OnLeave", OnLeave)
end
local GetRechargedEfficiencyStr = function()
  local Efficiencystr = {
    GetCommonText("good"),
    GetCommonText("normal"),
    GetCommonText("bad")
  }
  local info = X2Player:GetRechargedLaborPowerInfo()
  local percent = info.reducer * 100
  local type = 3
  local color = F_COLOR.GetColor("red", true)
  if percent <= info.good and percent > info.normal then
    color = F_COLOR.GetColor("bright_green", true)
    type = 1
  elseif percent <= info.normal and percent > info.bad then
    color = F_COLOR.GetColor("medium_yellow", true)
    type = 2
  end
  local str = string.format("%s|%s|r", color, Efficiencystr[type])
  return str
end
local function CreateLaborPowerTextbox(id, parent, anchorInfos)
  local textbox = parent:CreateChildWidget("textbox", id, 0, true)
  textbox:SetHeight(FONT_SIZE.MIDDLE)
  textbox.style:SetAlign(ALIGN_LEFT)
  textbox.style:SetShadow(true)
  ApplyTextColor(textbox, FONT_COLOR.LABORPOWER_YELLOW)
  function textbox:SetLaborPower()
    local str
    local lp = X2Player:GetGlobalLaborPower()
    local maxLocalLp = X2Player:GetMaxLocalLaborPower()
    local info = X2Player:GetRechargedLaborPowerInfo()
    if info.maxRechargedLp > 0 then
      local percent = info.rechargedLp / info.maxRechargedLp * 100
      local rechargedPercent = string.format("%d%%", percent)
      if maxLocalLp > 0 then
        local localLp = X2Player:GetLocalLaborPower()
        str = string.format("%s |,%d; (|,%d; + %s|,%d;|r, %s) %s", locale.attribute("labor_power"), lp + localLp, lp, F_COLOR.GetColor("light_green", true), X2Player:GetLocalLaborPower(), rechargedPercent, GetRechargedEfficiencyStr())
      else
        str = string.format("%s |,%d; (%s) %s", locale.attribute("labor_power"), lp, rechargedPercent, GetRechargedEfficiencyStr())
      end
    elseif maxLocalLp > 0 then
      local localLp = X2Player:GetLocalLaborPower()
      str = string.format("%s |,%d; (|,%d; + %s|,%d;|r)", locale.attribute("labor_power"), lp + localLp, lp, F_COLOR.GetColor("light_green", true), X2Player:GetLocalLaborPower())
    else
      str = string.format("%s |,%d;", locale.attribute("labor_power"), lp)
    end
    textbox:SetWidth(800)
    textbox:SetText(str)
    textbox:SetWidth(textbox:GetLongestLineWidth() + 10)
  end
  textbox:SetLaborPower()
  local function OnEnter(self)
    SetTargetAnchorTooltip(GetLaborPowerTexts(), "BOTTOMLEFT", self, "TOPLEFT", -1, -1, 570)
  end
  textbox:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  textbox:SetHandler("OnLeave", OnLeave)
end
function SetViewOfLaborPowerBarSet(id, parent)
  local h = 0
  local frame = UIParent:CreateWidget("emptywidget", id, parent)
  frame:Show(true)
  CreateLaborPowerTextbox("laborPowerText", frame)
  frame.laborPowerText:AddAnchor("BOTTOMLEFT", frame, "TOPLEFT", 0, -5)
  local laborpower_bar = W_BAR.CreateLaborPowerBar(frame:GetId() .. ".laborpower_bar", frame)
  laborpower_bar:AddAnchor("TOPLEFT", frame, 0, 0)
  frame.laborpower_bar = laborpower_bar
  h = h + laborpower_bar:GetHeight()
  local laborpower_bar_left_round_deco = laborpower_bar:CreateDrawable(TEXTURE_PATH.HUD, "bar_left_round_deco", "overlay")
  laborpower_bar_left_round_deco:AddAnchor("LEFT", laborpower_bar, 0, 0)
  local laborpower_bar_right_round_deco = laborpower_bar:CreateDrawable(TEXTURE_PATH.HUD, "bar_right_round_deco", "overlay")
  laborpower_bar_right_round_deco:AddAnchor("RIGHT", laborpower_bar, 0, 0)
  if X2Player:GetFeatureSet().bm_mileage then
    CreateMileageTextbox("bmMileageText", frame)
    frame.bmMileageText:AddAnchor("LEFT", frame.laborPowerText, "RIGHT", 0, 0)
  end
  local maxLocalLp = X2Player:GetMaxLocalLaborPower()
  if maxLocalLp > 0 then
    local local_laborpower_bar = W_BAR.CreateLaborPowerBar(frame:GetId() .. ".local_laborpower_bar", frame)
    local_laborpower_bar:AddAnchor("BOTTOMLEFT", frame, 0, 0)
    local color = GetTextureInfo(TEXTURE_PATH.HUD, "default_guage"):GetColors().local_labor_power_bar
    local_laborpower_bar.statusBar:SetBarColor(color[1], color[2], color[3], color[4])
    local_laborpower_bar.bg:SetTextureColor("local_labor_power_bar_bg")
    frame.local_laborpower_bar = local_laborpower_bar
    h = h + local_laborpower_bar:GetHeight()
    local local_laborpower_bar_left_round_deco = local_laborpower_bar:CreateDrawable(TEXTURE_PATH.HUD, "bar_left_round_deco", "overlay")
    local_laborpower_bar_left_round_deco:AddAnchor("LEFT", local_laborpower_bar, 0, 0)
    local local_laborpower_bar_right_round_deco = local_laborpower_bar:CreateDrawable(TEXTURE_PATH.HUD, "bar_right_round_deco", "overlay")
    local_laborpower_bar_right_round_deco:AddAnchor("RIGHT", local_laborpower_bar, 0, 0)
  end
  local w = frame.laborpower_bar:GetWidth()
  frame:SetExtent(w, h)
  return frame
end
function CreateLaborPowerBarSet(id, parent)
  local frame = SetViewOfLaborPowerBarSet(id, parent)
  frame.laborpower_bar:SetMinMaxValues(0, X2Player:GetMaxLaborPower())
  frame.laborpower_bar:SetValue(X2Player:GetGlobalLaborPower())
  local function OnEnter()
    SetTargetAnchorTooltip(GetLaborPowerTexts(), "BOTTOMLEFT", frame.laborPowerText, "TOPLEFT", -1, -1, 570)
  end
  frame.laborpower_bar:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  frame.laborpower_bar:SetHandler("OnLeave", OnLeave)
  if frame.local_laborpower_bar ~= nil then
    frame.local_laborpower_bar:SetMinMaxValues(0, X2Player:GetMaxLocalLaborPower())
    frame.local_laborpower_bar:SetValue(X2Player:GetLocalLaborPower())
    frame.local_laborpower_bar:SetHandler("OnEnter", OnEnter)
    frame.local_laborpower_bar:SetHandler("OnLeave", OnLeave)
  end
  local function UpdateLaborPower()
    frame.laborPowerText:SetLaborPower()
    frame.laborpower_bar:SetValue(X2Player:GetGlobalLaborPower())
    frame.laborpower_bar:SetMinMaxValues(0, X2Player:GetMaxLaborPower())
    if frame.local_laborpower_bar ~= nil then
      frame.local_laborpower_bar:SetMinMaxValues(0, X2Player:GetMaxLocalLaborPower())
      frame.local_laborpower_bar:SetValue(X2Player:GetLocalLaborPower())
    end
  end
  local events = {
    LABORPOWER_CHANGED = function()
      UpdateLaborPower()
    end,
    LEFT_LOADING = function()
      UpdateLaborPower()
    end,
    PLAYER_BM_POINT = function(oldBmPoint)
      local nowBmPoint = X2Player:GetBmPoint()
      local subtract = tonumber(X2Util:StrNumericSub(nowBmPoint, oldBmPoint))
      if subtract > 0 then
        X2Chat:DispatchChatMessage(CMF_SYSTEM, locale.chatSystem.GetGainBmMileage(subtract, nowBmPoint))
      elseif subtract < 0 then
        X2Chat:DispatchChatMessage(CMF_SYSTEM, locale.chatSystem.GetUseBmMileage(subtract * -1, nowBmPoint))
      end
      if frame.bmMileageText ~= nil then
        frame.bmMileageText:SetMileage()
      end
    end,
    PREMIUM_GRADE_CHANGE = function(prevPremiumGrade, presentPremiumGrade)
      frame.laborpower_bar:SetMinMaxValues(0, X2Player:GetMaxLaborPower())
    end,
    CHANGE_PAY_INFO = function(oldPayMethod, newPayMethod, oldPayLocation, newPayLocation)
      frame.laborpower_bar:SetMinMaxValues(0, X2Player:GetMaxLaborPower())
      if not X2Player:GetFeatureSet().nexonPcRoom and oldPayLocation ~= newPayLocation and string.find(newPayLocation, "pcbang") == nil then
        local DialogHandler = function(wnd)
          wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "error_message"))
          wnd:SetContent(GetUIText(MSG_BOX_BODY_TEXT, "pcbang_advantage_off"))
        end
        X2DialogManager:RequestNoticeDialog(DialogHandler, "")
      end
    end
  }
  frame:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(frame, events)
  return frame
end
