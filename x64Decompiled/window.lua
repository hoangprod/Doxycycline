function CreateTitleBar(id, parent)
  local title = SetViewOfTitleBar(id, parent)
  title:EnableDrag(true)
  local AddCloseEvent = function(button, parent, closeType)
    button.closeType = closeType
    function button:OnClick(arg)
      if arg == "RightButton" then
        return
      end
      if button.Init ~= nil then
        button:Init()
      end
      if parent.OnClose ~= nil then
        parent:OnClose()
      end
      parent:Show(false)
      X2Cursor:ClearCursor()
    end
    button:SetHandler("OnClick", button.OnClick)
  end
  AddCloseEvent(title.closeButton, parent)
  local function OnDragStart()
    X2Cursor:ClearCursor()
    X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
    parent:StartMoving()
    return true
  end
  title:SetHandler("OnDragStart", OnDragStart)
  local function OnDragStop()
    X2Cursor:ClearCursor()
    parent:StopMovingOrSizing()
  end
  title:SetHandler("OnDragStop", OnDragStop)
  return title
end
function CreateEmptyWindow(id, parent, category)
  local window = CreateBaseWindow(id, parent, category)
  window.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  window.titleStyle:SetAlign(ALIGN_CENTER)
  window.titleStyle:SetColor(1, 1, 1, 1)
  window.titleStyle:SetSnap(true)
  function window:EnableUIAnimation()
    SetttingUIAnimation(self)
    self:ReleaseHandler("OnShow")
    function self:OnShow()
      self:SetStartAnimation(true, true)
      if self.ShowProc ~= nil then
        self:ShowProc()
      end
    end
    self:SetHandler("OnShow", self.OnShow)
  end
  function window:OnShow()
    if self.ShowProc ~= nil then
      self:ShowProc()
    end
  end
  window:SetHandler("OnShow", window.OnShow)
  return window
end
function CreateWindow(id, parent, category, tabInfo)
  local window = CreateBaseWindow(id, parent, category)
  window:SetSounds("dialog_common")
  window:SetCloseOnEscape(true)
  SetttingUIAnimation(window)
  local titleBar = CreateTitleBar("titleBar", window)
  window.titleBar = titleBar
  function window:SetTitle(text)
    self.titleBar:SetTitleText(text)
  end
  function window:OnShow()
    if self.ShowProc ~= nil then
      self:ShowProc()
    end
    if self.skipSettingWindowSkin ~= true then
      SettingWindowSkin(self)
    end
    self:SetStartAnimation(true, true)
  end
  window:SetHandler("OnShow", window.OnShow)
  if tabInfo ~= nil then
    local tabListTitles = {}
    local tabListInfo = {}
    for i = 1, #tabInfo do
      if tabInfo[i].validationCheckFunc() then
        table.insert(tabListTitles, tabInfo[i].title)
        table.insert(tabListInfo, tabInfo[i])
      end
    end
    if #tabListTitles > 0 then
      local tab = W_BTN.CreateTab("tab", window)
      tab:AddTabs(tabListTitles)
      for i = 1, #tab.window do
        if tabListInfo[i].subWindowConstructor ~= nil then
          tabListInfo[i].subWindowConstructor(tab.window[i])
        end
      end
    end
  end
  return window
end
function CreateSubOptionWindow(id, parent)
  local window = SetViewOfSubOptionWindow(id, parent)
  function window.closeButton:OnClick()
    if window:IsVisible() then
      window:Show(false)
    end
  end
  window.closeButton:SetHandler("OnClick", window.closeButton.OnClick)
  local OnClick = function()
  end
  window:SetHandler("OnClick", OnClick)
  return window
end
function CreateSplitItemWindow(id, parent)
  local window = SetViewOfSplitItemWindow(id, parent)
  function window:SetCurrent(_value)
    window.spinner.value = _value
  end
  function window:SetFocus()
    self.spinner:SetFocus()
  end
  function window:ShowProc()
    window.spinner.text:SetText("1")
    window.spinner:SetFocus()
  end
  function window:SetMinMaxValues(_min, _max)
    window.spinner:SetMinMaxValues(_min, _max)
  end
  function window:OnTextChanged(lastChar)
    if window.toggleKey ~= nil and string.lower(window.toggleKey) == string.lower(lastChar) and window.Toggle ~= nil then
      window:Toggle()
    end
  end
  function window:GetText(arg)
    return window.spinner.curValue
  end
  function window:SetText(arg)
    window.spinner:SetValue(arg)
    window.spinner.curValue = tonumber(arg)
    self.current = tonumber(arg)
  end
  function window:ProcOnEnterPressed()
    self.button:OnClick()
  end
  function window.button:OnClick()
    if window.spinner.text:GetText() == "" then
      window:Show(false)
      return
    end
    if window.Click ~= nil then
      window:Click()
    end
    if window.spinner.curValue > 0 then
      window.current = window.spinner.curValue
      if 0 < window.storeIndex then
        window.actor:Action(window.storeIndex)
      end
    end
    window:Show(false)
  end
  window.button:SetHandler("OnClick", window.button.OnClick)
  return window
end
function CreateCheckGroupWindow(id, parent, info)
  local window = SetViewOfCheckGroupWindow(id, parent, info)
  local function GetCheckedAllChild()
    local checkItems = {}
    for j = 1, #window.subChecks do
      local button = window.subChecks[j]
      checkItems[j] = button:GetChecked()
    end
    for i = 1, #checkItems do
      if not checkItems[i] then
        return false
      end
    end
    return true
  end
  for i = 1, #window.checks do
    local button = window.checks[i]
    function button:CheckBtnCheckChagnedProc(checked)
      if window.subChecks == nil then
        return
      end
      for j = 1, #window.subChecks do
        window.subChecks[j]:SetChecked(checked)
      end
      if window.ChildCheckProcedure ~= nil then
        window:ChildCheckProcedure(self, checked)
      end
    end
  end
  for j = 1, #window.subChecks do
    local button = window.subChecks[j]
    function button:CheckBtnCheckChagnedProc(checked)
      self.parentCheck:SetChecked(GetCheckedAllChild(), false)
      if window.ChildCheckProcedure ~= nil then
        window:ChildCheckProcedure(self, checked)
      end
    end
  end
  return window
end
