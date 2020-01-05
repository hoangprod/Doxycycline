W_REPUTATION_BUTTON = {}
local CreateReputationWindow = function(id, parent, reputationButton)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:Show(false)
  window:SetExtent(430, 380)
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  window:SetTitle(GetUIText(COMMON_TEXT, "reputation"))
  window:EnableHidingIsRemove(true)
  local width = window:GetWidth() - sideMargin * 2
  local content = window:CreateChildWidget("textbox", "content", 0, false)
  content:SetWidth(width)
  content.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(content, FONT_COLOR.DEFAULT)
  content:SetText(GetUIText(COMMON_TEXT, "ask_reputation", string.format("%s%s|r", FONT_COLOR_HEX.BLUE, X2Unit:UnitName("target"))))
  content:SetHeight(content:GetTextHeight())
  content:AddAnchor("TOP", window, 0, titleMargin)
  local tip = window:CreateChildWidget("textbox", "tip", 0, false)
  tip:SetWidth(width)
  tip:AddAnchor("TOP", content, "BOTTOM", 0, sideMargin / 2)
  ApplyTextColor(tip, FONT_COLOR.DEFAULT)
  tip:SetText(GetUIText(COMMON_TEXT, "reputation_rule"))
  tip:SetHeight(tip:GetTextHeight())
  local _, yOffset = F_LAYOUT.GetExtentWidgets(window.titleBar, tip)
  yOffset = yOffset + sideMargin / 2
  local goodBtn = window:CreateChildWidget("button", "goodBtn", 0, false)
  goodBtn:SetText(GetUIText(COMMON_TEXT, "reputation_good"))
  ApplyButtonSkin(goodBtn, BUTTON_CONTENTS.REPUTATION_GOOD)
  local nogoodBtn = window:CreateChildWidget("button", "nogoodBtn", 0, false)
  nogoodBtn:SetText(GetUIText(COMMON_TEXT, "reputation_nogood"))
  ApplyButtonSkin(nogoodBtn, BUTTON_CONTENTS.REPUTATION_NOGOOD)
  local xOffset = goodBtn:GetWidth() / 2 + 5
  goodBtn:AddAnchor("TOP", window, -xOffset, yOffset)
  nogoodBtn:AddAnchor("TOP", window, xOffset, yOffset)
  local _, height = F_LAYOUT.GetExtentWidgets(window.titleBar, nogoodBtn)
  height = height + sideMargin * 1.5
  window:SetHeight(height)
  local function GoodBtnLeftClickFunc()
    X2Hero:VoteReputation(1)
    window:Show(false)
    reputationButton:Show(false)
  end
  ButtonOnClickHandler(goodBtn, GoodBtnLeftClickFunc)
  local function NoGoodBtnLeftClickFunc()
    X2Hero:VoteReputation(-1)
    window:Show(false)
    reputationButton:Show(false)
  end
  ButtonOnClickHandler(nogoodBtn, NoGoodBtnLeftClickFunc)
  return window
end
function W_REPUTATION_BUTTON.Create(parent)
  local reputationButton = parent:CreateChildWidget("button", "reputationButton", 0, true)
  local reputationWindow
  reputationButton:Show(true)
  ApplyButtonSkin(reputationButton, BUTTON_HUD.REPUTATION)
  local OnEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "reputation_button_tooltip", tostring(X2Hero:GetAbleReputationLevel())), self)
  end
  reputationButton:SetHandler("OnEnter", OnEnter)
  local LeftButtonLeftClickFunc = function(self)
    self:ToggleReputationWindow()
  end
  reputationButton:SetHandler("OnClick", LeftButtonLeftClickFunc)
  function reputationButton:ToggleReputationWindow(show)
    if show == nil then
      show = reputationWindow == nil and true or not reputationWindow:IsVisible()
    end
    if show and reputationWindow == nil then
      reputationWindow = CreateReputationWindow("reputationWindow", "UIParent", self)
      local function OnHide()
        reputationWindow = nil
      end
      reputationWindow:SetHandler("OnHide", OnHide)
    end
    if reputationWindow ~= nil then
      reputationWindow:Show(show)
    end
  end
  return reputationButton
end
