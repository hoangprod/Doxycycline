local localePath = optionTexts.gameInfo
function ShowPlayerHelmet(visible)
  X2Unit:ShowHelmet(visible)
end
function ShowMyBackHoldable(visible)
  X2Player:ShowBackHoldable(visible)
end
function ShowMyCosplay(visible)
  X2Player:ShowCosplay(visible)
end
function ShowMyBackPackWithCosplay(visible)
  X2Player:ShowBackPackWithCosplay(visible)
end
function ChangeMyCosplayVisual(value)
  X2Unit:ChangeCosplayVisual(value)
end
function UpdateCharacterVisual()
  X2Unit:ShowHelmet(GetOptionItemValue("ShowPlayerHelmet"))
  X2Player:ShowBackHoldable(GetOptionItemValue("ShowMyBackHoldable"))
  X2Player:ShowCosplay(GetOptionItemValue("ShowMyCosplay"))
  X2Player:ShowBackPackWithCosplay(GetOptionItemValue("ShowMyBackPackWithCosplay"))
  X2Unit:ChangeCosplayVisual(GetOptionItemValue("ChangeMyCosplayVisual"))
end
local MakeBackCarryingVisibleOrderControl = function(frame, indentation)
  local itemKeys = X2Player:GetBackCarryingOrderKeys()
  local function CreateControl(texts, optionId)
    local combobox = frame:InsertNewOption("combobox", texts, itemNames, optionId, nil, #texts.controlStr, indentation)
    combobox.title:SetWidth(characetInfoLocale.option.comboboxTitleWidth)
    ApplyTextColor(combobox.title, FONT_COLOR.SOFT_BROWN)
    combobox.title:SetText(texts.titleStr)
    function combobox:SelectedProc()
      SwapIndex(self, self:GetSelectedIndex(), self:GetPrevSelectedIndex())
    end
    return combobox
  end
  local ctrls = {
    {
      optionId = "OptionBackCarryingOrder1st",
      texts = optionTexts.gameInfo.firstOrderBackCarrying
    },
    {
      optionId = "OptionBackCarryingOrder2nd",
      texts = optionTexts.gameInfo.secondOrderBackCarrying
    },
    {
      optionId = "OptionBackCarryingOrder3rd",
      texts = optionTexts.gameInfo.thirdOrderBackCarrying
    },
    {
      optionId = "OptionBackCarryingOrder4th",
      texts = optionTexts.gameInfo.fourthOrderBackCarrying
    }
  }
  local myBackControl = frame:InsertNewOption("checkbox", optionTexts.gameInfo.visibleMyBackHoldable, nil, "ShowMyBackHoldable", ShowMyBackHoldable)
  myBackControl:SetButtonStyle("soft_brown")
  local myBackPackWithCosplay = frame:InsertNewOption("checkbox", optionTexts.gameInfo.visibleBackpackWithCosplay, nil, "ShowMyBackPackWithCosplay", ShowMyBackPackWithCosplay)
  myBackPackWithCosplay:SetButtonStyle("soft_brown")
  for k = 1, #ctrls do
    ctrls[k].ctrl = CreateControl(ctrls[k].texts, ctrls[k].optionId)
  end
  function SwapIndex(ctrl, findIndex, replaceIndex)
    for k = 1, #ctrls do
      if ctrls[k].ctrl:GetId() ~= ctrl:GetId() and findIndex == ctrls[k].ctrl:GetSelectedIndex() then
        ctrls[k].ctrl:Select(replaceIndex)
        return
      end
    end
  end
  function myBackControl:Init()
    local val = GetOptionItemValue("ShowMyBackHoldable")
    if val ~= nil then
      self.originalValue = val
      self:SetChecked(self.originalValue, false)
      self:CheckBtnCheckChagnedProc(self:GetChecked())
    end
  end
  function myBackControl:CheckBtnCheckChagnedProc(checked)
    for k = 1, #ctrls do
      ctrls[k].ctrl:Enable(checked, true)
    end
    myBackPackWithCosplay:Enable(checked, true)
  end
  local ctrl = ctrls[1].ctrl
  function ctrl:Applyfunc()
    local orders = {}
    for x = 1, #ctrls do
      local item = ctrls[x].ctrl:GetSelectedIndex()
      orders[x] = itemKeys[item] or ""
    end
    X2Player:BackCarryingOrders(orders[1], orders[2], orders[3], orders[4])
  end
end
local function MakeCosplayVisualControl(frame)
  local showMyCosplayChk = frame:InsertNewOption("checkbox", localePath.visibleMyCosplay, nil, "ShowMyCosplay", ShowMyCosplay)
  showMyCosplayChk:SetButtonStyle("soft_brown")
  local texts = {
    titleStr = nil,
    tooltipStr = nil,
    controlStr = {
      layout = {
        fontColor = FONT_COLOR.CHECK_BUTTON_LIGHT
      },
      data = {
        {
          text = GetUIText(COMMON_TEXT, "cosplay_original"),
          value = 0
        },
        {
          text = GetUIText(COMMON_TEXT, "cosplay_modify"),
          value = 1
        }
      }
    }
  }
  local cosplayVisualRadio = frame:InsertNewOption("radiobuttonV", texts, nil, nil, nil, nil, 10)
  function showMyCosplayChk:CheckBtnCheckChagnedProc(checked)
    cosplayVisualRadio:Enable(checked)
  end
  function cosplayVisualRadio:Init()
    local dataValue = GetOptionItemValue("ChangeMyCosplayVisual")
    self.originalValue = dataValue
    local index = self:GetIndexByValue(dataValue)
    if index == nil or index == 0 then
      return
    end
    self:Check(index, false)
    showMyCosplayChk:CheckBtnCheckChagnedProc(showMyCosplayChk:GetChecked())
  end
  function cosplayVisualRadio:Save()
    local dataValue = self:GetCheckedData()
    if dataValue == nil then
      return
    end
    SetOptionItemValue("ChangeMyCosplayVisual", dataValue)
    ChangeMyCosplayVisual(dataValue)
  end
  if X2Player:IsInvisibleCosplay() then
    showMyCosplayChk:Enable(false)
    showMyCosplayChk.textButton:Enable(false)
    cosplayVisualRadio:Enable(false)
  end
end
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local charLookOptionFrame
function CreateCharacterOptionFrame(id, parent)
  local frame = CreateSubOptionWindow(id, parent)
  frame:Show(false)
  frame:SetExtent(characetInfoLocale.option.wndWidth, 350)
  frame:SetCloseOnEscape(true)
  frame:AddAnchor("CENTER", "UIParent", 0, 0)
  frame:EnableHidingIsRemove(true)
  local titleLabel = frame:CreateChildWidget("label", "titleLabel", 0, true)
  titleLabel.style:SetFontSize(FONT_SIZE.LARGE)
  titleLabel:SetAutoResize(true)
  titleLabel:SetHeight(30)
  titleLabel:SetText(GetUIText(COMMON_TEXT, "character_look_option"))
  titleLabel:AddAnchor("TOPLEFT", frame, sideMargin, sideMargin / 2)
  ApplyTextColor(titleLabel, FONT_COLOR.SOFT_BROWN)
  local contentFrame = CreateOptionSubFrame(frame, 0)
  contentFrame:Show(true)
  contentFrame.scroll:Show(false)
  contentFrame.scroll:SetEnable(false)
  MakeCosplayVisualControl(contentFrame)
  local helmetChk = contentFrame:InsertNewOption("checkbox", localePath.visibleHelmet, nil, "ShowPlayerHelmet", ShowPlayerHelmet)
  helmetChk:SetButtonStyle("soft_brown")
  MakeBackCarryingVisibleOrderControl(contentFrame, 10)
  local localeOptionWnd = locale.optionWindow
  titleText = localeOptionWnd.interface.title
  buttonText = localeOptionWnd.interface.menuText[2]
  resetKind = RESET_GAME_OPTION
  visibleRestartTip = false
  function frame:Init()
    contentFrame:Init()
    X2Option:RemoveModifiedOption()
  end
  function frame:Save()
    if contentFrame ~= nil then
      contentFrame:Save()
    end
  end
  function frame:ShowProc()
    self:Init()
  end
  function frame:Cancel()
    if contentFrame ~= nil then
      contentFrame:Cancel()
    end
  end
  frame:SetHandler("OnCloseByEsc", frame.Cancel)
  function frame:OnHide()
    self:Save()
    charLookOptionFrame = nil
  end
  frame:SetHandler("OnHide", frame.OnHide)
  return frame
end
function RefeshOptionFrame()
  if charLookOptionFrame and charLookOptionFrame:IsVisible() then
    charLookOptionFrame:Show(false)
  end
end
function ToggleVisualOptionFrame(show)
  local optionFrameVisible
  if show == nil then
    if charLookOptionFrame == nil then
      show = true
    else
      show = not charLookOptionFrame:IsVisible()
    end
  end
  if show and charLookOptionFrame == nil then
    charLookOptionFrame = CreateCharacterOptionFrame("characterInfo.optionWindow", characterInfo.mainWindow)
    charLookOptionFrame:AddAnchor("TOPRIGHT", equippedItem.leftSlots, "TOPLEFT", -20, -50)
  end
  if charLookOptionFrame ~= nil then
    charLookOptionFrame:Show(show)
  end
end
