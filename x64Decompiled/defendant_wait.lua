local CreateDefendantWaitWindow = function(id)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local frame = CreateWindow(id, "UIParent")
  frame:Show(false)
  frame:SetCloseOnEscape(false)
  frame:SetExtent(POPUP_WINDOW_WIDTH, 190)
  frame:AddAnchor("CENTER", "UIParent", 0, 0)
  frame:SetTitle(locale.trial.waitTrialTitle)
  frame:EnableHidingIsRemove(true)
  local content = frame:CreateChildWidget("textbox", "content", 0, true)
  content:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 60)
  content:AddAnchor("TOP", frame, 0, titleMargin)
  ApplyTextColor(content, FONT_COLOR.DEFAULT)
  local recognitionBtn = frame:CreateChildWidget("button", "recognitionBtn", 0, true)
  recognitionBtn:AddAnchor("BOTTOM", frame, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  recognitionBtn:SetText(locale.trial.waitCancelTrial)
  ApplyButtonSkin(recognitionBtn, BUTTON_BASIC.DEFAULT)
  local function RecognitionBtnLeftClickFunc()
    X2Trial:CancelTrial()
    frame:Show(false)
  end
  ButtonOnClickHandler(recognitionBtn, RecognitionBtnLeftClickFunc)
  local OnHide = function()
    userTrial.defendantWaitWnd = nil
  end
  frame:SetHandler("OnHide", OnHide)
  local events = {
    SHOW_CRIME_RECORDS = function()
      frame:Show(false)
    end,
    RULING_CLOSED = function()
      frame:Show(false)
    end,
    TRIAL_CLOSED = function()
      frame:Show(false)
    end
  }
  frame:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(frame, events)
  function frame:SetFrameHeight()
    local height = titleMargin + self.recognitionBtn:GetHeight() + self.content:GetHeight() + sideMargin * 2
    self:SetHeight(height)
  end
  return frame
end
local function ShowDependantWaitJury(count, total, sentenceTime)
  local waitTime = sentenceTime / 60000
  local function FillData()
    if userTrial.defendantWaitWnd == nil then
      return
    end
    local str = locale.trial.waitJury(waitTime, count, total)
    userTrial.defendantWaitWnd.content:SetText(str)
    userTrial.defendantWaitWnd.content:SetHeight(userTrial.defendantWaitWnd.content:GetTextHeight())
    userTrial.defendantWaitWnd.recognitionBtn:Enable(count == 0)
    userTrial.defendantWaitWnd:SetFrameHeight()
  end
  if userTrial.defendantWaitWnd == nil then
    userTrial.defendantWaitWnd = CreateDefendantWaitWindow("userTrial.defendantWaitWnd")
    FillData()
    userTrial.defendantWaitWnd:Show(true)
  else
    FillData()
    userTrial.defendantWaitWnd:Show(true)
  end
end
UIParent:SetEventHandler("SHOW_DEPENDANT_WAIT_JURY", ShowDependantWaitJury)
local function ShowDependantWaitTrial(order, sentenceTime)
  local waitTime = sentenceTime / 60000
  local function FillData()
    if userTrial.defendantWaitWnd == nil then
      return
    end
    local str = locale.trial.waitTrial(waitTime, order)
    userTrial.defendantWaitWnd.content:SetText(str)
    userTrial.defendantWaitWnd.content:SetHeight(userTrial.defendantWaitWnd.content:GetTextHeight())
    userTrial.defendantWaitWnd.recognitionBtn:Enable(true)
    userTrial.defendantWaitWnd:SetFrameHeight()
  end
  if userTrial.defendantWaitWnd == nil then
    userTrial.defendantWaitWnd = CreateDefendantWaitWindow("userTrial.defendantWaitWnd")
    FillData()
    userTrial.defendantWaitWnd:Show(true)
  else
    FillData()
    userTrial.defendantWaitWnd:Show(true)
  end
end
UIParent:SetEventHandler("SHOW_DEPENDANT_WAIT_TRIAL", ShowDependantWaitTrial)
