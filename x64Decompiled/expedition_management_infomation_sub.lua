function AssignInfomationSubHandler(parent)
  local IR = GetInterestList()
  function parent:SetViewOffInfomationInterestHandler()
    local wnd = self.interestWindow
    function wnd:OnExit()
      wnd:Show(false)
      local value = {}
      for i = 1, #IR do
        if wnd.interestChks[i]:GetChecked() then
          value[i] = 1
        else
          value[i] = 0
        end
      end
      if parent.SetInterest ~= nil then
        parent:SetInterest(value)
      end
    end
    wnd:SetHandler("OnHide", wnd.OnExit)
    function wnd:SetInterest(value)
      for i = 1, #IR do
        if value[i] == 1 then
          self.interestChks[i]:SetChecked(true, false)
        else
          self.interestChks[i]:SetChecked(false, false)
        end
      end
    end
  end
  function parent:SetViewOffInfomationBuffHandler()
    local wnd = self.buffWindow
    function wnd.okButton:OnClick()
      wnd:Show(false)
    end
    wnd.okButton:SetHandler("OnClick", wnd.okButton.OnClick)
  end
  function parent:SetViewOffInfomationLevelUpHandler()
    local wnd = self.levelUpWindow
    function wnd.cancelButton:OnClick()
      wnd:Show(false)
    end
    wnd.cancelButton:SetHandler("OnClick", wnd.cancelButton.OnClick)
    function wnd.okButton:OnClick()
      X2Faction:SetExpeditionLevelUp()
      parent.frame.upgradeButton.waiting = false
      wnd:Show(false)
    end
    wnd.okButton:SetHandler("OnClick", wnd.okButton.OnClick)
    function wnd:LevelApply()
      local level = X2Faction:GetMyExpeditionLevel()
      local levelInfo = X2Faction:GetExpeditionLevelInfo(level + 1)
      local curLevelInfo = X2Faction:GetExpeditionLevelInfo(level)
      local money = levelInfo[4]
      local items = levelInfo[5]
      local nextBuff = levelInfo[6]
      local prevBuff = curLevelInfo[6]
      local height = wnd.windowHeight
      wnd.buffArrow:Show(false)
      wnd.midWin:SetHeight(wnd.midWin.midHeight)
      wnd:SetHeight(height)
      if items ~= nil and #items > 0 then
        wnd.levelUpItem:SetItemInfo(items[1], 0)
        wnd.levelUpItem:Show(true)
        height = height + wnd.levelUpItem:GetHeight() + 15
        local curCnt = X2Bag:GetCountInBag(items[1].itemType)
        local needCnt = items[1].needCount
        wnd.levelUpItem:SetStack(curCnt, needCnt)
        if tonumber(curCnt) >= tonumber(needCnt) then
          self.okButton:Enable(true)
        else
          self.okButton:Enable(false)
        end
      else
        levelUpItem:Show(false)
        self.okButton:Enable(true)
      end
      if prevBuff ~= nil and #prevBuff > 0 then
        local buffInfo = X2Ability:GetBuffTooltip(prevBuff[1], 1)
        wnd.prevBuff:Show(true)
        wnd.prevBuff:SetTooltip(buffInfo)
        F_SLOT.SetIconBackGround(wnd.prevBuff, buffInfo.path)
        wnd.buffArrow:Show(true)
      else
        wnd.prevBuff:Show(false)
      end
      if nextBuff ~= nil and #nextBuff > 0 then
        local buffInfo = X2Ability:GetBuffTooltip(nextBuff[1], 1)
        wnd.nextBuff:Show(true)
        wnd.nextBuff:SetTooltip(buffInfo)
        F_SLOT.SetIconBackGround(wnd.nextBuff, buffInfo.path)
        wnd.buffArrow:Show(true)
      else
        wnd.nextBuff:Show(false)
      end
      if wnd.buffArrow:IsVisible() then
        wnd.midWin:SetHeight(wnd.midWin.midHeight + wnd.midWin.buffHeight)
        height = height + wnd.midWin.buffHeight
      end
      wnd:SetHeight(height)
    end
  end
  parent:SetViewOffInfomationInterestHandler()
  parent:SetViewOffInfomationBuffHandler()
  parent:SetViewOffInfomationLevelUpHandler()
end
function CreateInfomationSub(id, wnd)
  local interestWindow = CreateExpeditionInterestWnd(id, wnd)
  interestWindow:Show(false)
  interestWindow:AddAnchor("TOPLEFT", wnd, "TOPRIGHT", 0, 10)
  wnd.interestWindow = interestWindow
  local buffWindow = SetViewOfExpeditionInfomationBuff(id, wnd)
  buffWindow:Show(false)
  buffWindow:AddAnchor("TOPRIGHT", wnd, 0, 10)
  wnd.buffWindow = buffWindow
  local expedMgrWnd = wnd:GetParent():GetParent()
  local guideWindow = SetViewOfExpeditionInfomationGuide(id, expedMgrWnd)
  guideWindow:Show(false)
  guideWindow:AddAnchor("TOPRIGHT", wnd, 0, 10)
  wnd.guideWindow = guideWindow
  local levelUpWindow = SetViewOfExpeditionInfomationLevelUp(id, wnd)
  levelUpWindow:Show(false)
  levelUpWindow:AddAnchor("CENTER", wnd, "CENTER", 0, 0)
  wnd.levelUpWindow = levelUpWindow
  AssignInfomationSubHandler(wnd)
end
