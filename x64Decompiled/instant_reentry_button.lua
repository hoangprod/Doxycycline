local instantReentryBtn
local zoneNameInformer = GetIndicators().zoneNameInformer
local function SetViewReentryButton(countDownTime, zoneName)
  local reentryBtn = UIParent:CreateWidget("button", "instantReentryBtn", alertManager)
  ApplyButtonSkin(reentryBtn, BUTTON_HUD.INSTANT_REENTRY)
  reentryBtn:EnableHidingIsRemove(true)
  reentryBtn:Show(true)
  reentryBtn.countDownTime = countDownTime
  reentryBtn.zoneName = zoneName
  reentryBtn.checkTime = countDownTime
  local function OnUpdate(self, dt)
    if instantReentryBtn == nil or instantReentryBtn:IsVisible() == false then
      return
    end
    self.checkTime = math.min(self.checkTime, self.checkTime - dt)
    if self.checkTime > 0 then
      return
    end
    local DialogHandler = function(wnd)
      wnd:SetTitle(X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "notice_battle_field"))
      wnd:SetContent(GetCommonText("reentry_notify_end"))
      wnd.btnCancel:Enable(false)
      wnd.btnCancel:Show(false)
      wnd.btnCancel:RemoveAllAnchors()
      wnd.btnOk:RemoveAllAnchors()
      wnd.btnOk:AddAnchor("BOTTOM", wnd, 0, -20)
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, "UIParent")
    self.countDownTime = 0
    self:Show(false)
  end
  reentryBtn:SetHandler("OnUpdate", OnUpdate)
  local function OnHide()
    instantReentryBtn = nil
    zoneNameInformer:Detach()
  end
  reentryBtn:SetHandler("OnHide", OnHide)
  local function LeftClickFunc()
    local function DialogHandler(wnd)
      ApplyDialogStyle(wnd, DIALOG_STYLE.INCLUDE_SEPERATE_TEXT)
      wnd:SetTextColor(FONT_COLOR.DEFAULT, FONT_COLOR.DEFAULT)
      wnd:SetTitle(GetCommonText("reentry"))
      wnd:SetContent(GetCommonText("reentry_instant_content", string.format("%s", zoneName)), GetCommonText("reentry_instant_content_left_time", 0, 0))
      function wnd:OkProc()
        reentryBtn:Show(false)
        X2BattleField:RequestTryReentry()
      end
      function wnd:RetireProc()
        reentryBtn.countDownTime = 0
        reentryBtn:Show(false)
        X2BattleField:RequestCancelReentry()
        wnd:OnCancel()
      end
      wnd.btnOk:SetText(GetCommonText("reentry"))
      wnd.btnCancel:SetText(GetCommonText("reentry_cancel"))
      ButtonOnClickHandler(wnd.btnCancel, wnd.RetireProc)
      function wnd:OnUpdate()
        local remainTime = 0
        if instantReentryBtn ~= nil then
          remainTime = instantReentryBtn.checkTime
        end
        if instantReentryBtn == nil then
          self:ReleaseHandler("OnUpdate")
          X2DialogManager:OnCancel(self:GetId())
        else
          local remainMin = math.floor(remainTime / 60000)
          local remainSec = math.floor(remainTime % 60000 / 1000)
          self.lowerText:SetText(GetCommonText("reentry_instant_content_left_time", remainMin, remainSec))
        end
      end
      wnd:SetHandler("OnUpdate", wnd.OnUpdate)
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, "UIParent")
  end
  ButtonOnClickHandler(reentryBtn, LeftClickFunc)
  local OnEnter = function(self)
    SetTooltip(GetCommonText("reentry_notify_tooltip"), self)
  end
  reentryBtn:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  reentryBtn:SetHandler("OnLeave", OnLeave)
  return reentryBtn
end
local function ShowReentryButton(param)
  if param[1] == false or X2Indun:IsEntranceIndunMatch() then
    if instantReentryBtn ~= nil then
      instantReentryBtn:Show(false)
    end
    return
  end
  local instantName = ""
  if param[3] ~= nil then
    instantName = param[3]
  end
  if instantReentryBtn ~= nil and instantReentryBtn:IsVisible() then
    return
  end
  instantReentryBtn = SetViewReentryButton(param[2], instantName)
  zoneNameInformer:Attach(instantReentryBtn)
end
UIParent:SetEventHandler("REENTRY_NOTIFY_ENABLE", ShowReentryButton)
local function ReentryCheck()
  if instantReentryBtn == nil then
    X2BattleField:RequestTryReentryCheck()
  end
end
UIParent:SetEventHandler("LEFT_LOADING", ReentryCheck)
UIParent:SetEventHandler("ENTERED_WORLD", ReentryCheck)
local function HideReentryButton()
  if instantReentryBtn ~= nil then
    instantReentryBtn:Show(false)
  end
end
UIParent:SetEventHandler("ENTERED_LOADING", HideReentryButton)
UIParent:SetEventHandler("REENTRY_NOTIFY_DISABLE", HideReentryButton)
