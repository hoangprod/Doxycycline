local MAX_VERDICT = 6
local VERDICT_COUNT = 0
local function CreateVerdictWindow(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow(id, parent)
  wnd:Show(false)
  wnd:SetCloseOnEscape(false)
  wnd:SetExtent(userTrialLocale.verdict.windowWidth, 250)
  wnd:EnableHidingIsRemove(true)
  wnd:SetTitle(locale.trial.verdictTitle)
  wnd.titleBar.closeButton:Show(false)
  local desc = wnd:CreateChildWidget("label", "desc", 0, true)
  desc:SetHeight(FONT_SIZE.LARGE)
  desc:SetText(locale.trial.verdictChoose)
  desc:SetAutoResize(true)
  desc.style:SetFontSize(FONT_SIZE.LARGE)
  desc:AddAnchor("TOP", wnd, 0, titleMargin)
  ApplyTextColor(desc, FONT_COLOR.DEFAULT)
  local verdictWarning = wnd:CreateChildWidget("textbox", "verdictWarning", 0, true)
  verdictWarning:Show(true)
  verdictWarning:SetWidth(300)
  verdictWarning:SetText(locale.trial.verdictWarning)
  verdictWarning:SetHeight(verdictWarning:GetTextHeight())
  verdictWarning:AddAnchor("BOTTOMLEFT", wnd, sideMargin * 1.5, -sideMargin * 1.5)
  verdictWarning.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(verdictWarning, FONT_COLOR.RED)
  local bg = CreateContentBackground(verdictWarning, "TYPE6", "gray")
  bg:AddAnchor("TOPLEFT", verdictWarning, -20, -15)
  bg:AddAnchor("BOTTOMRIGHT", verdictWarning, 20, 15)
  local okButton = wnd:CreateChildWidget("button", "okButton", 0, true)
  okButton:AddAnchor("BOTTOMRIGHT", wnd, -sideMargin, -sideMargin)
  okButton:SetText(locale.trial.verdictConfirm)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  local function OkButtonLeftClickFunc()
    X2Trial:ChooseVerdict(wnd.pressedButton.idx)
    wnd:Show(false)
  end
  ButtonOnClickHandler(okButton, OkButtonLeftClickFunc)
  local stepInfoFrame = CreateStepInfoFrame("stepInfoFrame", wnd)
  stepInfoFrame:AddAnchor("RIGHT", okButton, "LEFT", -sideMargin / 2, 0)
  wnd.stepInfoFrame = stepInfoFrame
  wnd.pressedButton = nil
  local function CreateButton(idx)
    local offset = userTrialLocale.verdict.sentenceBtnOffset
    local button = wnd:CreateChildWidget("button", "verdictBtn", idx, true)
    button:SetText(locale.trial.verdictNotGuilty)
    ApplyButtonSkin(button, BUTTON_CONTENTS.VERDICT)
    button:AddAnchor("TOPLEFT", wnd, offset + button:GetWidth() * (idx - 1), 75)
    button.style:SetFontSize(userTrialLocale.verdict.buttonFontSize)
    button.amount = 0
    button.idx = idx
    function button:SetAmount(arg)
      button.amount = arg
      button:SetText(locale.trial.verdictGuilty(arg))
    end
    local function LeftClickFunc()
      if wnd.pressedButton ~= nil then
        SetBGPushed(wnd.pressedButton, false, BUTTON_BASIC.DEFAULT.fontColor)
      end
      SetBGPushed(button, true, GetVerdictSelectedButtonFontColor())
      wnd.pressedButton = button
    end
    ButtonOnClickHandler(button, LeftClickFunc)
  end
  for i = 1, MAX_VERDICT do
    CreateButton(i)
  end
  function wnd:SetVerdictAmount(p1, p2, p3, p4, p5)
    self.verdictBtn[2]:SetAmount(p1)
    self.verdictBtn[3]:SetAmount(p2)
    self.verdictBtn[4]:SetAmount(p3)
    self.verdictBtn[5]:SetAmount(p4)
    self.verdictBtn[6]:SetAmount(p5)
  end
  local function OnHide()
    userTrial.verdictWnd = nil
    VERDICT_COUNT = 0
  end
  wnd:SetHandler("OnHide", OnHide)
  local events = {
    TRIAL_TIMER = function(state, remainTable)
      if state ~= TRIAL_SENTENCE then
        return
      end
      local timeString = locale.time.GetPeriodToMinutesSecondFormat(remainTable)
      local remainString = locale.trial.remainTime(timeString)
      wnd.stepInfoFrame.remainTime:SetText(remainString)
      if VERDICT_COUNT == 0 then
        local verdictString = locale.trial.remainCount("0", "0")
        wnd.stepInfoFrame.step:SetText(verdictString)
      end
    end,
    VERDICT_COUNT = function(count, total)
      VERDICT_COUNT = count
      local verdictString = locale.trial.remainCount(tostring(count), tostring(total))
      wnd.stepInfoFrame.step:SetText(verdictString)
    end,
    RULING_STATUS = function()
      wnd:Show(false)
    end,
    RULING_CLOSED = function()
      wnd:Show(false)
    end,
    TRIAL_CLOSED = function()
      wnd:Show(false)
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
  return wnd
end
local function ShowVerdictWindow(p1, p2, p3, p4, p5)
  if userTrial.verdictWnd == nil then
    userTrial.verdictWnd = CreateVerdictWindow("userTrial.verdictWnd", "UIParent")
  end
  if userTrial.crimeRecords ~= nil then
    userTrial.verdictWnd:AddAnchor("TOP", userTrial.crimeRecords, "BOTTOM", 0, 10)
  elseif userTrial.botRecords ~= nil then
    userTrial.verdictWnd:AddAnchor("TOP", userTrial.botRecords, "BOTTOM", 0, 10)
  else
    userTrial.verdictWnd:AddAnchor("BOTTOM", "UIParent", 0, -80)
  end
  userTrial.verdictWnd:SetVerdictAmount(p1, p2, p3, p4, p5)
  userTrial.verdictWnd:Show(true)
end
UIParent:SetEventHandler("SHOW_VERDICTS", ShowVerdictWindow)
