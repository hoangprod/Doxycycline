local CreateTrialStatusWindow = function(id)
  local window = CreateEmptyWindow(id, "UIParent")
  window:Show(false)
  window:AddAnchor("TOP", "UIParent", 0, 90)
  local bg = window:CreateImageDrawable(TEXTURE_PATH.USER_TRIAL_STATUS, "background")
  bg:SetTextureInfo("background")
  bg:AddAnchor("TOPLEFT", window, -50, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 50, 0)
  local iconDisableCoords = {
    "opencourt_dis",
    "charges_dis",
    "pleas_dis",
    "judge_dis",
    "sentence_dis"
  }
  local height = 0
  window.icons = {}
  local offsetX = 30
  for i = 1, 5 do
    local icon = window:CreateDrawable(TEXTURE_PATH.USER_TRIAL_STATUS, iconDisableCoords[i], "background")
    icon:AddAnchor("LEFT", window, offsetX, 0)
    window.icons[i] = icon
    offsetX = offsetX + icon:GetWidth() + 15
    height = icon:GetHeight()
  end
  window:SetExtent(offsetX + 30, height + 20)
  for i = 1, 4 do
    local arrowImage = window:CreateDrawable(BUTTON_TEXTURE_PATH.PAGE, "page_btn_big", "background")
    arrowImage:SetExtent(9, 18)
    arrowImage:AddAnchor("LEFT", window.icons[i], "RIGHT", 5, 0)
    arrowImage:SetTextureColor("default")
  end
  function window:SelectInitIcon()
    self.icons[1]:SetTextureInfo("opencourt_df")
  end
  function window:SelectTestimonyIcon()
    self.icons[2]:SetTextureInfo("charges_df")
  end
  function window:SelectFinalStatementIcon()
    self.icons[3]:SetTextureInfo("pleas_df")
  end
  function window:SelectSentenceIcon()
    self.icons[4]:SetTextureInfo("judge_df")
  end
  function window:SelectRulingIcon()
    self.icons[5]:SetTextureInfo("sentence_df")
  end
  function window:ResetAllIcon()
    for i = 1, #self.icons do
      self.icons[i]:SetTextureInfo(iconDisableCoords[i])
    end
  end
  return window
end
local trialStatusWnd = CreateTrialStatusWindow("trialStatusBar")
local function TrialStatus(state, cur)
  trialStatusWnd:ResetAllIcon()
  if state > TRIAL_FREE and state < TRIAL_TESTIMONY then
    trialStatusWnd:SelectInitIcon()
  end
  if state == TRIAL_TESTIMONY then
    trialStatusWnd:SelectTestimonyIcon()
  end
  if state == TRIAL_FINAL_STATEMENT then
    trialStatusWnd:SelectFinalStatementIcon()
  end
  if state == TRIAL_SENTENCE then
    trialStatusWnd:SelectSentenceIcon()
  end
  if state > TRIAL_SENTENCE then
    trialStatusWnd:SelectRulingIcon()
  end
  curJury = cur
  if state > TRIAL_FREE then
    local stateString = locale.trial.stateMessage[state + 1]
    X2Chat:DispatchChatMessage(CMF_SYSTEM, stateString)
    trialStatusWnd:Show(true)
  end
end
UIParent:SetEventHandler("TRIAL_STATUS", TrialStatus)
local function TrialClosed()
  trialStatusWnd:Show(false)
end
UIParent:SetEventHandler("TRIAL_CLOSED", TrialClosed)
local TrialCanceled = function()
  local stateString = locale.trial.canceled
  X2Chat:DispatchChatMessage(CMF_SYSTEM, stateString)
end
UIParent:SetEventHandler("TRIAL_CANCELED", TrialCanceled)
