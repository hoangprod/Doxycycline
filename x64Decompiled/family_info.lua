memberCount = 0
incMemberCount = 0
maxMemberCount = 0
maxIncMemberCount = 0
function ShowFamilyInfoTab(TabWnd)
  SetViewOfFamilyInfo(TabWnd)
  function TabWnd:Refresh()
    local info = X2Family:GetInfo()
    if info == nil then
      return
    end
    local name = info.name
    if name == "" then
      name = string.format("%s%s", info.ownerName, GetCommonText("family_no_name"))
    end
    local expRate = 0
    if info.maxExp then
      expRate = info.exp * 1000 / info.maxExp
    end
    self.expBar.statusBar:SetValue(expRate)
    local width = self.expBar.statusBar:GetWidth() * expRate / 1000 - 10
    self.expBar.barEnd:RemoveAllAnchors()
    self.expBar.barEnd:AddAnchor("LEFT", self.expBar.statusBar, width, 0)
    self.expBar.barEnd:Show(true)
    self.nameLabel:SetText(name)
    self.bossLabel:SetText(string.format("%s : %s", info.ownerRole, info.ownerName))
    self.LevelTextbox:SetText(string.format("%s : %s%s", GetCommonText("family_level"), FONT_COLOR_HEX.BLUE, info.gradeName))
    self.titleLabel:SetText(string.format("%s : %s", GetCommonText("family_title"), info.myTitle))
    self.roleLabel:SetText(string.format("%s : %s", GetCommonText("family_role"), info.myRoleName))
    self.content1:SetText(info.content1)
    self.content2:SetText(info.content2)
    self.livingPointTextbox:SetText(string.format("%s : |l%d", GetCommonText("family_living_point"), info.livingPoint))
    self.livingPointTextbox:SetWidth(self.livingPointTextbox:GetLongestLineWidth() + 50)
    self.memberCountTextbox:SetText(string.format("%s : %s%d|r/%s", GetCommonText("family_member_count"), FONT_COLOR_HEX.BLUE, info.memberCount, info.maxMemberCount))
    memberCount = info.memberCount
    incMemberCount = info.incMemberCount
    maxMemberCount = info.maxMemberCount
    maxIncMemberCount = info.maxIncMemberCount
    self.nameChangeButton:Show(X2Family:IsOwner())
    self.writeButton:Show(X2Family:IsOwner())
    self.icon:Show(false)
    if info.myRoleIcon ~= "" then
      self.icon:SetTexture("ui/icon/" .. info.myRoleIcon)
      self.icon:Show(true)
    end
    function self.expBar.statusBar:OnEnter()
      local tooltip = string.format("%s %d/%d", GetUIText(COMMON_TEXT, "current_exp"), info.exp, info.maxExp)
      SetExpTooltip(tooltip, self)
    end
    self.expBar.statusBar:SetHandler("OnEnter", self.expBar.statusBar.OnEnter)
    function self.expBar.statusBar:OnLeave()
      HideTooltip()
    end
    self.expBar.statusBar:SetHandler("OnLeave", self.expBar.statusBar.OnLeave)
  end
  local familyGuildLevelWnd, familyGuideEffectWnd
  function TabWnd:ClosePopup()
    if familyGuildLevelWnd then
      familyGuildLevelWnd:Show(false)
    end
    if familyGuideEffectWnd then
      familyGuideEffectWnd:Show(false)
    end
    if self.changeName then
      self.changeName:Show(false)
    end
  end
  function TabWnd:OnShow()
    self:Refresh()
    self:ClosePopup()
  end
  TabWnd:SetHandler("OnShow", TabWnd.OnShow)
  function TabWnd:OnHide()
    self:ClosePopup()
  end
  TabWnd:SetHandler("OnHide", TabWnd.OnHide)
  local function ShowFamilyGuide()
    if familyGuildLevelWnd == nil then
      familyGuildLevelWnd = SetViewOfFamilyGuide("familyGuide", TabWnd)
      familyGuildLevelWnd:Show(false)
    end
    local show = true
    if familyGuildLevelWnd:IsVisible() then
      show = false
    end
    familyGuildLevelWnd:Show(show)
    familyGuildLevelWnd:Raise()
  end
  local function GuideButton()
    ShowFamilyGuide()
  end
  TabWnd.guideButton:SetHandler("OnClick", GuideButton)
  local function ShowFamilyGuideEffect()
    if familyGuideEffectWnd == nil then
      familyGuideEffectWnd = SetViewOfFamilyGuideEffect("familyGuideEffect", TabWnd)
      local effects = X2Family:GetEffect()
      for i = 1, #effects do
        familyGuideEffectWnd.levelList:InsertData(i, 1, effects[i])
      end
    end
    local show = true
    if familyGuideEffectWnd:IsVisible() then
      show = false
    end
    familyGuideEffectWnd:Show(show)
    familyGuideEffectWnd:Raise()
    local function okButton()
      familyGuideEffectWnd:Show(false)
    end
    familyGuideEffectWnd.okButton:SetHandler("OnClick", okButton)
  end
  local function EffectGuideButton()
    ShowFamilyGuideEffect()
  end
  TabWnd.effectGuideButton:SetHandler("OnClick", EffectGuideButton)
  function nameChangeButton()
    TabWnd.changeName = ShowFamilyDlgChangeName(TabWnd.nameLabel:GetText())
  end
  TabWnd.nameChangeButton:SetHandler("OnClick", nameChangeButton)
  function livingShopButton()
    DirectOpenStore(1)
  end
  TabWnd.livingShopButton:SetHandler("OnClick", livingShopButton)
  function contentWriteButton()
    local editMode = TabWnd.content1.bg:IsVisible()
    if editMode then
      TabWnd.content1:SetReadOnly(true)
      TabWnd.content1:Enable(false)
      TabWnd.content1.bg:Show(false)
      TabWnd.content1Label:Show(false)
      TabWnd.content2:SetReadOnly(true)
      TabWnd.content2:Enable(false)
      TabWnd.content2.bg:Show(false)
      TabWnd.content2Label:Show(false)
      TabWnd.writeButton:Enable(false)
      TabWnd.time = 0
      TabWnd.waiting = true
      function TabWnd:OnUpdate(dt)
        TabWnd.time = TabWnd.time + dt
        local TIME_OUT = 2000
        if not TabWnd.waiting or TIME_OUT < TabWnd.time then
          TabWnd.time = 0
          TabWnd.waiting = false
          TabWnd:ReleaseHandler("OnUpdate")
          TabWnd.writeButton:Enable(true)
        end
      end
      TabWnd:SetHandler("OnUpdate", TabWnd.OnUpdate)
      X2Family:SetContent(TabWnd.content1:GetText(), TabWnd.content2:GetText())
    else
      TabWnd.content1:SetReadOnly(false)
      TabWnd.content1:Enable(true)
      TabWnd.content1.bg:Show(true)
      TabWnd.content1Label:Show(true)
      TabWnd.content2:SetReadOnly(false)
      TabWnd.content2:Enable(true)
      TabWnd.content2.bg:Show(true)
      TabWnd.content2Label:Show(true)
    end
  end
  TabWnd.writeButton:SetHandler("OnClick", contentWriteButton)
  function OnContent1TextChanged()
    local len = TabWnd.content1:GetTextLength()
    local color
    if len >= TabWnd.content1.textLength then
      color = FONT_COLOR_HEX.DEFAULT
    else
      color = FONT_COLOR_HEX.SOFT_BROWN
    end
    local str = string.format("%s%s|r/%s", color, len, TabWnd.content1.textLength)
    TabWnd.content1Label:SetText(str)
  end
  TabWnd.content1:SetHandler("OnTextChanged", OnContent1TextChanged)
  function OnContent2TextChanged()
    local len = TabWnd.content2:GetTextLength()
    local color
    if len >= TabWnd.content2.textLength then
      color = FONT_COLOR_HEX.DEFAULT
    else
      color = FONT_COLOR_HEX.SOFT_BROWN
    end
    local str = string.format("%s%s|r/%s", color, len, TabWnd.content2.textLength)
    TabWnd.content2Label:SetText(str)
  end
  TabWnd.content2:SetHandler("OnTextChanged", OnContent2TextChanged)
  local events = {
    BAG_UPDATE = function()
      TabWnd:Refresh()
    end,
    PLAYER_LIVING_POINT = function()
      TabWnd:Refresh()
    end
  }
  TabWnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(TabWnd, events)
end
