function CreateGuardTowerFrame(window)
  SetViewOfGuardTowerFrame(window)
  local listCtrl = window.listCtrl
  local okButton = window.okButton
  function window:UpdateGuardTowerStepInfos()
    local guardTowerStepInfo, maxGates, maxWalls, maxDominionBuildings = X2House:GetGuardTowerStepInfo()
    self:FillGuardTowerStepInfoItem(guardTowerStepInfo)
    self:FillGuardTowerMaxInfo(maxGates, maxWalls, maxDominionBuildings)
  end
  function window:AllClearItems()
    for index = 1, MAX_GUARD_TOWER_STEP do
      if listCtrl.items[index].line ~= nil then
        listCtrl.items[index].line:SetVisible(false)
      end
      local subItem = listCtrl.items[index].subItems[1]
      subItem.stepImg:SetVisible(false)
      subItem.buffName:SetText("")
      subItem.info:SetText("")
      subItem.bg:SetVisible(false)
      subItem.buffIconBtn:Show(false)
    end
  end
  local StepImageSetCoords = function(texture, buffId)
    buffId = tostring(buffId)
    local coordsTable = {
      ["4771"] = "step_1",
      ["4772"] = "step_2",
      ["4773"] = "step_3",
      ["4774"] = "step_4",
      ["5392"] = "step_5",
      ["5393"] = "step_6"
    }
    local findCoord = coordsTable[buffId]
    if findCoord == nil then
      LuaAssert(string.format("Can't find id.. %s", buffId))
      return
    end
    texture:SetVisible(true)
    texture:SetTextureInfo(findCoord)
  end
  function window:FillGuardTowerStepInfoItem(guardTowerStepInfo)
    self:AllClearItems()
    for i = 1, #guardTowerStepInfo do
      do
        local subItem = listCtrl.items[i].subItems[1]
        local stepInfo = guardTowerStepInfo[i]
        if i ~= 1 then
          listCtrl.items[i - 1].line:SetVisible(true)
        end
        StepImageSetCoords(subItem.stepImg, stepInfo.buff_id)
        subItem.buffName:SetText(stepInfo.name)
        local isCurStep = stepInfo.isCurStep
        local str = ""
        if isCurStep then
          if stepInfo.curGate then
            str = string.format("%s %d/%d", locale.territory.castleGate, stepInfo.curGate, stepInfo.maxGate)
          end
          if stepInfo.curWall then
            str = string.format([[
%s
%s + %s %d/%d]], str, locale.territory.castleWall, locale.territory.castleTower, stepInfo.curWall, stepInfo.maxWall)
          end
          if stepInfo.nameExtra1 then
            str = string.format([[
%s
%s %d/%d]], str, stepInfo.nameExtra1, stepInfo.curExtra1, stepInfo.maxExtra1)
          end
          subItem.info:SetText(str)
          subItem.info:SetHeight(subItem.info:GetTextHeight())
          subItem.bg:SetVisible(true)
        else
          if stepInfo.maxGate then
            str = string.format("%s %d", locale.territory.castleGate, stepInfo.maxGate)
          end
          if stepInfo.maxWall then
            str = string.format([[
%s
%s + %s %d]], str, locale.territory.castleWall, locale.territory.castleTower, stepInfo.maxWall)
          end
          if stepInfo.nameExtra1 then
            str = string.format([[
%s
%s %d]], str, stepInfo.nameExtra1, stepInfo.maxExtra1)
          end
        end
        subItem.info:SetText(str)
        subItem.info:SetHeight(subItem.info:GetTextHeight())
        subItem.buffIconBtn:Show(true)
        F_SLOT.SetIconBackGround(subItem.buffIconBtn, stepInfo.path)
        local function BuffIconBtnOnEnter()
          ShowTooltip(stepInfo, subItem.buffIconBtn)
        end
        subItem.buffIconBtn:SetHandler("OnEnter", BuffIconBtnOnEnter)
        function BuffIconBtnOnLeave()
          HideTooltip()
        end
        subItem.buffIconBtn:SetHandler("OnLeave", BuffIconBtnOnLeave)
      end
    end
  end
  function window:FillGuardTowerMaxInfo(maxGates, maxWalls, maxDominionBuildings)
    local strMax = string.format("%s : %s %d / %s + %s %d / %s %d", locale.territory.maxCastleLimit, locale.territory.castleGate, maxGates, locale.territory.castleWall, locale.territory.castleTower, maxWalls, GetUIText(COMMON_TEXT, "dominion_buildings"), maxDominionBuildings)
    self.maxInfo:SetText(strMax)
  end
  local ButtonOnClick = function()
    territoryFrame:Show(not territoryFrame:IsVisible())
  end
  okButton:SetHandler("OnClick", ButtonOnClick)
end
