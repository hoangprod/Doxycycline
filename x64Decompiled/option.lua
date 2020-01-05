local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local labelHeight = 17
local RESET_GAME_OPTION = 1
local RESET_KEY_BINDING_OPTION = 2
LIST_BUTTON_HEIGHT = 21
local GAME_OPTION_COUNT = 7
local HOTKEY_OPTION_COUNT = 7
local TOTAL_OPTION_COUNT = GAME_OPTION_COUNT + HOTKEY_OPTION_COUNT
local function ResetGameOption()
  X2Option:Reset()
  local subFrames = optionFrame.contentWindow.pageWindow.subFrames
  for i = 4, GAME_OPTION_COUNT do
    subFrames[i]:Init()
  end
end
local function ResetKeyBindingOption()
  X2Hotkey:InitOptionHotKey()
  local subFrames = optionFrame.contentWindow.pageWindow.subFrames
  for i = GAME_OPTION_COUNT + 1, TOTAL_OPTION_COUNT do
    subFrames[i]:Init()
  end
end
local resetInfos = {
  {
    title = locale.menu.optionwindow.resetUI,
    tooltip = locale.menu.optionwindow.reset_button_tooltip,
    func = ResetGameOption
  },
  {
    title = locale.menu.optionwindow.resetKeyBinding,
    tooltip = locale.menu.optionwindow.key_reset_button_tooltip,
    func = ResetKeyBindingOption
  }
}
local function CreateMenuListFrame(parent)
  local frame = CreateScrollWindow(parent, "menuListFrame", 0)
  frame:RemoveAllAnchors()
  frame:AddAnchor("TOPLEFT", parent, 0, 0)
  local height = parent:GetHeight()
  frame:SetExtent(200, height)
  frame:Show(true)
  frame.totalHeight = 0
  local bg = CreateContentBackground(frame, "TYPE3", "brown")
  bg:AddAnchor("TOPLEFT", frame, -sideMargin, -sideMargin * 2)
  bg:AddAnchor("BOTTOMRIGHT", frame, sideMargin, sideMargin * 2)
  frame.categoryFrames = {}
  function frame:InsertMenuCategory(title, subCategoryTitle, subFrameIndex, resetKind, visibleRestartTip)
    local width = frame:GetWidth() - 30
    local categoryFrame
    for i = 1, #frame.categoryFrames do
      if frame.categoryFrames[i].titleLabel ~= nil and frame.categoryFrames[i].titleLabel:GetText() == title then
        categoryFrame = frame.categoryFrames[i]
      end
    end
    if categoryFrame == nil then
      categoryFrame = frame:CreateChildWidget("emptywidget", "categoryFrames", #frame.categoryFrames + 1, true)
      categoryFrame:Show(true)
      if #frame.categoryFrames == 1 then
        categoryFrame:AddAnchor("TOPLEFT", frame, 15, 0)
      else
        categoryFrame:AddAnchor("TOPLEFT", frame.categoryFrames[#frame.categoryFrames - 1], "BOTTOMLEFT", 0, sideMargin / 2)
      end
      local titleLabel = W_CTRL.CreateLabel(categoryFrame:GetId() .. ".titleLabel", categoryFrame)
      titleLabel:SetText(title)
      titleLabel:SetExtent(width, labelHeight)
      titleLabel:AddAnchor("TOPLEFT", categoryFrame, 0, 0)
      titleLabel.style:SetAlign(ALIGN_LEFT)
      titleLabel.style:SetFontSize(FONT_SIZE.LARGE)
      ApplyTextColor(titleLabel, FONT_COLOR.HIGH_TITLE)
      categoryFrame.titleLabel = titleLabel
      categoryFrame.buttons = {}
    end
    local button = CreateEmptyButton(categoryFrame:GetId() .. ".buttons[" .. #categoryFrame.buttons + 1 .. "]", categoryFrame)
    ApplyButtonSkin(button, BUTTON_CONTENTS.OPTION_LIST)
    if #categoryFrame.buttons == 0 then
      button:AddAnchor("TOPLEFT", categoryFrame.titleLabel, "BOTTOMLEFT", 0, 3)
    else
      button:AddAnchor("TOPLEFT", categoryFrame.buttons[#categoryFrame.buttons], "BOTTOMLEFT", 0, 0)
    end
    button:SetText(subCategoryTitle)
    button:SetExtent(width, LIST_BUTTON_HEIGHT)
    button.style:SetAlign(ALIGN_LEFT)
    categoryFrame.buttons[#categoryFrame.buttons + 1] = button
    button.subFrameIndex = subFrameIndex
    function button:OnClick(arg)
      if arg == "LeftButton" then
        local pageTitle = categoryFrame.titleLabel:GetText() .. " - " .. self:GetText()
        optionFrame.contentWindow.pageWindow.titleLabel:SetText(pageTitle)
        optionFrame:SelectSubFrame(self.subFrameIndex)
        optionFrame:ResetListButtons()
        SetBGPushed(button, true, GetOptionListButtonFontColor())
        local resetBtn = optionFrame.contentWindow.resetBtn
        if resetKind == nil then
          resetBtn:Show(false)
        else
          resetBtn:Show(true)
          resetBtn:SetText(resetInfos[resetKind].title)
          SetButtonTooltip(resetBtn, resetInfos[resetKind].tooltip)
          resetBtn.resetProc = resetInfos[resetKind].func
        end
        optionFrame.contentWindow.restartTip:Show(visibleRestartTip)
      end
    end
    button:SetHandler("OnClick", button.OnClick)
    categoryFrame:SetExtent(width, labelHeight + LIST_BUTTON_HEIGHT * #categoryFrame.buttons + sideMargin / 2)
    local totalHeight = 0
    for i = 1, #frame.categoryFrames do
      totalHeight = totalHeight + frame.categoryFrames[i]:GetHeight()
    end
    self.totalHeight = totalHeight
  end
  parent.menuListFrame = frame
  return frame
end
optionFrame = nil
function CreateOptionFrame()
  local frame = CreateWindow("optionFrame", "UIParent")
  frame:Show(false)
  frame:SetExtent(680, 615)
  frame:SetCloseOnEscape(true)
  frame:AddAnchor("CENTER", "UIParent", 0, 0)
  frame:SetTitle(locale.menu.option)
  frame:SetSounds("option")
  frame:EnableHidingIsRemove(true)
  function frame.titleBar.closeButton:OnClick()
    if frame:IsVisible() then
      ToggleOptionFrame(false)
    end
  end
  frame.titleBar.closeButton:SetHandler("OnClick", frame.titleBar.closeButton.OnClick)
  local contentWindow = frame:CreateChildWidget("emptywidget", "contentWindow", 0, true)
  contentWindow:AddAnchor("TOPLEFT", frame, sideMargin, titleMargin + sideMargin)
  contentWindow:AddAnchor("BOTTOMRIGHT", frame, -sideMargin, bottomMargin + -20)
  contentWindow:Show(true)
  local menuListFrame = CreateMenuListFrame(contentWindow)
  local pageWindow = contentWindow:CreateChildWidget("emptywidget", "pageWindow", 0, true)
  pageWindow:AddAnchor("TOPLEFT", menuListFrame, "TOPRIGHT", sideMargin / 2, 0)
  pageWindow:AddAnchor("BOTTOMRIGHT", contentWindow, 0, 0)
  pageWindow:Show(true)
  pageWindow.parent = contentWindow
  local titleLabel = W_CTRL.CreateLabel(pageWindow:GetId() .. ".titleLabel", pageWindow)
  titleLabel:AddAnchor("TOPLEFT", pageWindow, 0, 0)
  titleLabel:SetHeight(25)
  titleLabel:SetAutoResize(true)
  titleLabel:SetInset(5, 0, 0, 10)
  titleLabel.style:SetFontSize(FONT_SIZE.LARGE)
  titleLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(titleLabel, FONT_COLOR.HIGH_TITLE)
  pageWindow.titleLabel = titleLabel
  local resetBtn = contentWindow:CreateChildWidget("button", "resetBtn", 0, true)
  resetBtn:Show(false)
  resetBtn:SetText(locale.menu.optionwindow.resetUI)
  resetBtn:AddAnchor("BOTTOMLEFT", frame, sideMargin, -sideMargin)
  ApplyButtonSkin(resetBtn, BUTTON_BASIC.DEFAULT)
  local restartTip = contentWindow:CreateChildWidget("label", "restartTip", 0, true)
  restartTip:SetText(locale.menu.optionwindow.restartTip)
  restartTip:SetExtent(200, FONT_SIZE.MIDDLE)
  restartTip:AddAnchor("TOPLEFT", pageWindow, "BOTTOMLEFT", 5, 12)
  restartTip.style:SetFontSize(FONT_SIZE.MIDDLE)
  restartTip.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(restartTip, FONT_COLOR.GRAY)
  function resetBtn:OnClick(arg)
    if arg == "LeftButton" and self.resetProc ~= nil then
      self.resetProc()
    end
  end
  resetBtn:SetHandler("OnClick", resetBtn.OnClick)
  local cancelBtn = contentWindow:CreateChildWidget("button", "cancelBtn", 0, true)
  cancelBtn:SetText(locale.common.cancel)
  cancelBtn:AddAnchor("BOTTOMRIGHT", frame, -sideMargin, -sideMargin)
  ApplyButtonSkin(cancelBtn, BUTTON_BASIC.DEFAULT)
  function cancelBtn:OnClick(arg)
    if arg == "LeftButton" then
      frame:Cancel()
      ToggleOptionFrame(false)
    end
  end
  cancelBtn:SetHandler("OnClick", cancelBtn.OnClick)
  local okBtn = contentWindow:CreateChildWidget("button", "okBtn", 0, true)
  okBtn:SetText(GetUIText(PORTAL_TEXT, "apply"))
  okBtn:AddAnchor("RIGHT", cancelBtn, "LEFT", 0, 0)
  ApplyButtonSkin(okBtn, BUTTON_BASIC.DEFAULT)
  SetButtonTooltip(okBtn, locale.menu.optionwindow.ok_button_tooltip)
  local buttonTable = {cancelBtn, okBtn}
  AdjustBtnLongestTextWidth(buttonTable)
  function okBtn:OnClick(arg)
    if arg == "LeftButton" then
      frame:Save()
    end
  end
  okBtn:SetHandler("OnClick", okBtn.OnClick)
  local localeOptionWnd = locale.optionWindow
  pageWindow.subFrames = {}
  local funcTable = {
    {
      func = CreateBasicScreenOptionFrame,
      titleText = localeOptionWnd.screen.title,
      buttonText = localeOptionWnd.screen.menuText[1],
      resetKind = nil,
      visibleRestartTip = true
    },
    {
      func = CreateAdvancedScreenOptionFrame,
      titleText = localeOptionWnd.screen.title,
      buttonText = localeOptionWnd.screen.menuText[2],
      resetKind = nil,
      visibleRestartTip = true
    },
    {
      func = CreateSoundOptionFrame,
      titleText = localeOptionWnd.sound.title,
      buttonText = localeOptionWnd.sound.setDefault,
      resetKind = nil,
      visibleRestartTip = false
    },
    {
      func = CreateNameTagOptionFrame,
      titleText = localeOptionWnd.interface.title,
      buttonText = localeOptionWnd.interface.menuText[1],
      resetKind = RESET_GAME_OPTION,
      visibleRestartTip = false
    },
    {
      func = CreateGameInfoOptionFrame,
      titleText = localeOptionWnd.interface.title,
      buttonText = localeOptionWnd.interface.menuText[2],
      resetKind = RESET_GAME_OPTION,
      visibleRestartTip = false
    },
    {
      func = CreateFunctionOptionFrame,
      titleText = localeOptionWnd.interface.title,
      buttonText = localeOptionWnd.interface.menuText[3],
      resetKind = RESET_GAME_OPTION,
      visibleRestartTip = false
    },
    {
      func = CreateInterfaceActionBarOptionFrame,
      titleText = localeOptionWnd.interface.title,
      buttonText = localeOptionWnd.interface.menuText[4],
      resetKind = RESET_GAME_OPTION,
      visibleRestartTip = false
    },
    {
      func = CreatekeyBindgingFrame,
      titleText = localeOptionWnd.key.title,
      buttonText = localeOptionWnd.key.menuText[1],
      resetKind = RESET_KEY_BINDING_OPTION,
      visibleRestartTip = false
    },
    {
      func = CreatekeyBindgingFrame,
      titleText = localeOptionWnd.key.title,
      buttonText = localeOptionWnd.key.menuText[2],
      resetKind = RESET_KEY_BINDING_OPTION,
      visibleRestartTip = false
    },
    {
      func = CreatekeyBindgingFrame,
      titleText = localeOptionWnd.key.title,
      buttonText = localeOptionWnd.key.menuText[3],
      resetKind = RESET_KEY_BINDING_OPTION,
      visibleRestartTip = false
    },
    {
      func = CreatekeyBindgingFrame,
      titleText = localeOptionWnd.key.title,
      buttonText = localeOptionWnd.key.menuText[4],
      resetKind = RESET_KEY_BINDING_OPTION,
      visibleRestartTip = false
    },
    {
      func = CreatekeyBindgingFrame,
      titleText = localeOptionWnd.key.title,
      buttonText = localeOptionWnd.key.menuText[5],
      resetKind = RESET_KEY_BINDING_OPTION,
      visibleRestartTip = false
    },
    {
      func = CreatekeyBindgingFrame,
      titleText = localeOptionWnd.key.title,
      buttonText = localeOptionWnd.key.menuText[6],
      resetKind = RESET_KEY_BINDING_OPTION,
      visibleRestartTip = false
    },
    {
      func = CreatekeyBindgingFrame,
      titleText = localeOptionWnd.key.title,
      buttonText = localeOptionWnd.key.menuText[7],
      resetKind = RESET_KEY_BINDING_OPTION,
      visibleRestartTip = false
    }
  }
  for i = 1, #funcTable do
    if i > 3 and (X2:IsEnteredWorld() == false or X2:IsInClientDrivenZone() == true) then
      break
    end
    if funcTable[i].func ~= nil then
      local subFrame = funcTable[i].func(pageWindow, i)
      pageWindow.subFrames[i] = subFrame
    end
    menuListFrame:InsertMenuCategory(funcTable[i].titleText, funcTable[i].buttonText, i, funcTable[i].resetKind, funcTable[i].visibleRestartTip)
  end
  menuListFrame:ResetScroll(menuListFrame.totalHeight)
  function frame:Init()
    X2Hotkey:BindingToOption()
    self:ResetListButtons()
    local button = self.contentWindow.menuListFrame.categoryFrames[1].buttons[1]
    SetBGPushed(button, true, GetOptionListButtonFontColor())
    local pageTitle = self.contentWindow.menuListFrame.categoryFrames[1].titleLabel:GetText() .. " - " .. button:GetText()
    self.contentWindow.pageWindow.titleLabel:SetText(pageTitle)
    for i = 1, #pageWindow.subFrames do
      if pageWindow.subFrames[i] ~= nil then
        pageWindow.subFrames[i]:Init()
      end
    end
    pageWindow.subFrames[2]:AdjustUserSetGraphicQuality()
    X2Option:RemoveModifiedOption()
  end
  function frame:DiableOptimizationAndSave()
    local stampKey = "diable_optimization_by_option"
    local windowTitle = "optimization_button_off"
    local windowContentText = "optimization_disable_by_option_text"
    local savedStamp = UI:GetUIStamp(stampKey)
    if savedStamp ~= nil and savedStamp == "ignore" then
      optimizationToggleButton:OptimizationEnable(false)
      frame:DoSave()
      return
    end
    local function DialogHandler(wnd)
      ApplyDialogStyle(wnd, DIALOG_STYLE.INCLUDE_IGNORE_CHECKBOX)
      local title = GetUIText(WINDOW_TITLE_TEXT, windowTitle)
      local content = GetUIText(COMMON_TEXT, windowContentText)
      wnd:SetContentEx(title, content)
      function wnd:OkProc()
        local checked = self.checkButton:GetChecked()
        if checked then
          UI:SetUIStamp(stampKey, "ignore")
        else
          UI:SetUIStamp(stampKey, "show")
        end
        optimizationToggleButton:OptimizationEnable(false)
        frame:DoSave()
        ToggleOptionFrame(false)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, "")
  end
  function frame:Save()
    if X2:IsEnteredWorld() and X2Option:GetOptionItemValue(OPTION_ITEM_OPTIMIZATION_ENABLE) ~= 0 then
      self:DiableOptimizationAndSave()
      return
    end
    self:DoSave()
  end
  function frame:DoSave()
    for i = 1, #pageWindow.subFrames do
      if pageWindow.subFrames[i] ~= nil then
        pageWindow.subFrames[i]:Save()
      end
    end
    X2Hotkey:SaveHotKey()
    X2NameTag:SetNameTag()
    if frame:IsExistWarningAllSubOptions() == true then
      frame:ShowWarningInAllSubOptions()
    end
    X2Option:Save()
    ToggleOptionFrame(false)
  end
  function frame:Cancel()
    for i = 1, #pageWindow.subFrames do
      if pageWindow.subFrames[i] ~= nil then
        pageWindow.subFrames[i]:Cancel()
      end
    end
  end
  frame:SetHandler("OnCloseByEsc", frame.Cancel)
  function frame:OnHide()
    optionFrame = nil
  end
  frame:SetHandler("OnHide", frame.OnHide)
  function frame:SelectSubFrame(index)
    for i = 1, #pageWindow.subFrames do
      if pageWindow.subFrames[i] ~= nil then
        pageWindow.subFrames[i]:Show(i == index)
      end
    end
  end
  function frame:ResetListButtons()
    for i = 1, #self.contentWindow.menuListFrame.categoryFrames do
      local categoryFrame = self.contentWindow.menuListFrame.categoryFrames[i]
      if categoryFrame ~= nil then
        for j = 1, #categoryFrame.buttons do
          local button = categoryFrame.buttons[j]
          SetBGPushed(button, false, GetOptionListButtonFontColor())
        end
      end
    end
  end
  function frame:ShowProc()
    self:Init()
    self:SelectSubFrame(1)
    if skillAlertOptionWnd ~= nil then
      skillAlertOptionWnd:Show(false)
    end
  end
  function frame:IsExistWarningAllSubOptions()
    for _, wnd in pairs(pageWindow.subFrames) do
      if wnd.IsExistWarning ~= nil and wnd:IsExistWarning() == true then
        return true
      end
    end
    return false
  end
  function frame:ShowWarningInAllSubOptions()
    for _, wnd in pairs(pageWindow.subFrames) do
      if wnd.ShowWarningMessage ~= nil and wnd:ShowWarningMessage() == true then
        return
      end
    end
  end
  return frame
end
function ToggleOptionFrame(show)
  local optionFrameVisible
  if optionFrame == nil then
    optionFrame = CreateOptionFrame()
    ADDON:RegisterContentWidget(UIC_OPTION_FRAME, optionFrame)
    optionFrameVisible = false
  else
    optionFrameVisible = optionFrame:IsVisible()
  end
  if show == false then
    local subFrames = optionFrame.contentWindow.pageWindow.subFrames
    if subFrames[#subFrames].ConfirmHotkeyModifyMode ~= nil then
      subFrames[#subFrames]:ConfirmHotkeyModifyMode()
    end
    ShowSkillAlertOptionWnd(false)
  end
  if show ~= nil then
    optionFrame:Show(show)
  else
    optionFrame:Show(not optionFrameVisible)
  end
end
local DialogChangeResolutionHandler = function(wnd, infoTable)
  wnd:SetTitle(X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_keep_config"))
  wnd:SetContent("")
  function wnd:OnUpdate()
    if wnd.beginMSec == nil then
      wnd.beginMSec = X2Time:GetUiMsec()
    end
    local WAIT_TIME = 15000
    local elapseMSec = X2Time:GetUiMsec() - self.beginMSec
    if WAIT_TIME < elapseMSec then
      wnd:ReleaseHandler("OnUpdate")
      X2DialogManager:OnCancel(wnd:GetId())
    else
      local leftMSec = WAIT_TIME - elapseMSec + 1000
      local leftSec = string.format("%d", leftMSec / 1000)
      local bodyText = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "ask_keep_config", leftSec)
      self:SetContent(bodyText)
    end
  end
  wnd:SetHandler("OnUpdate", wnd.OnUpdate)
end
X2DialogManager:SetHandler(DLG_TASK_CONFIRM_CHANGE_RESOLUTION, DialogChangeResolutionHandler)
