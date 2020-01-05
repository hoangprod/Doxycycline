local ELEMENT_WIDTH = 200
local ELEMENT_HIGHT = 28
local ELEMENT_ANCHOR_OFFSET_Y = 7
function ChildSlaveKeyByAttachPoint(attachPoint)
  return "childSlave" .. tostring(attachPoint)
end
function CreateCombatResourceFrame()
  local window = UIParent:CreateWidget("window", "combatResource", "UIParent")
  window:SetExtent(230, 170)
  local bg = window:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  bg:SetTextureColor("alpha40")
  bg:AddAnchor("TOPLEFT", window, "TOPLEFT", 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, "BOTTOMRIGHT", 0, 0)
  window:Show(false)
  function window:MakeOriginWindowPos(reset)
    window:RemoveAllAnchors()
    if reset then
      window:AddAnchor("TOPRIGHT", "UIParent", F_LAYOUT.CalcDontApplyUIScale(-317), F_LAYOUT.CalcDontApplyUIScale(425))
    else
      window:AddAnchor("TOPRIGHT", "UIParent", -317, 425)
    end
  end
  window:MakeOriginWindowPos()
  local title = window:CreateChildWidget("label", "title", 0, true)
  title:SetExtent(230, 25)
  bg = title:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  bg:SetTextureColor("alpha40")
  bg:AddAnchor("TOPLEFT", title, "TOPLEFT", 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", title, "BOTTOMRIGHT", 0, 0)
  title:AddAnchor("TOPLEFT", window, "TOPLEFT", 0, 0)
  title.style:SetAlign(ALIGN_CENTER)
  title.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  ApplyTextColor(title, FONT_COLOR.SOFT_YELLOW)
  title:EnableDrag(true)
  local function OnDragStart()
    X2Cursor:ClearCursor()
    X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
    window:StartMoving()
    return true
  end
  title:SetHandler("OnDragStart", OnDragStart)
  local function OnDragStop()
    X2Cursor:ClearCursor()
    window:StopMovingOrSizing()
  end
  title:SetHandler("OnDragStop", OnDragStop)
  function window:SetTitle(text)
    self.title:SetText(text)
  end
  local innerRect = window:CreateChildWidget("emptywidget", "innerRect", 0, true)
  innerRect:SetExtent(ELEMENT_WIDTH, 10)
  innerRect:AddAnchor("TOPLEFT", window.title, "BOTTOMLEFT", 15, 0)
  function window:MakeElement(index, anchorTarget, anchorTargetPoint)
    if self.innerRect.elements ~= nil and self.innerRect.elements[index] ~= nil then
      self.innerRect.elements[index]:Show(true)
      return self.innerRect.elements[index]
    end
    local element = self.innerRect:CreateChildWidget("emptywidget", "elements", index, true)
    element:SetExtent(ELEMENT_WIDTH, ELEMENT_HIGHT)
    element:AddAnchor("TOPLEFT", anchorTarget, anchorTargetPoint, 0, ELEMENT_ANCHOR_OFFSET_Y)
    local cooldownIcon = CreateCoolDownIcon(element)
    cooldownIcon:AddAnchor("TOPLEFT", element, "TOPLEFT", 0, 0)
    function element:SetElementIcon(iconPath)
      cooldownIcon:SetIcon(iconPath)
    end
    local nameLabel = element:CreateChildWidget("label", "name", 0, true)
    nameLabel:SetExtent(162, 11)
    nameLabel:AddAnchor("TOPLEFT", cooldownIcon, "TOPRIGHT", 10, 0)
    nameLabel.style:SetAlign(ALIGN_LEFT)
    nameLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.SMALL)
    ApplyTextColor(nameLabel, FONT_COLOR.WHITE)
    function element:SetElementName(name)
      self.name:SetText(name)
    end
    local cunstomInfo = {
      path = TEXTURE_PATH.SIEGE_HP_BAR,
      textureKey = "siege_gauge",
      coords = {
        GetTextureInfo(TEXTURE_PATH.SIEGE_HP_BAR, "siege_gauge"):GetCoords()
      }
    }
    local combatResourceBar = W_BAR.CreateCustomHpBar("combatResource.innerRect.element[" .. tostring(index) .. "].combatResourceBar", element, cunstomInfo)
    combatResourceBar:SetExtent(162, 14)
    combatResourceBar:AddAnchor("TOPLEFT", nameLabel, "BOTTOMLEFT", 0, 3)
    combatResourceBar:ChangeStatusBarColor(GetTextureInfo(TEXTURE_PATH.SIEGE_HP_BAR, "siege_gauge"):GetColors().blue)
    combatResourceBar:ChangeStatusBarBgColor(GetTextureInfo(TEXTURE_PATH.HUD, "siege_gauge_bg"):GetColors().black)
    element.combatResourceBar = combatResourceBar
    local combatResourceText = element:CreateChildWidget("label", "combatResourceText", 0, true)
    combatResourceText:SetExtent(162, 14)
    combatResourceText:AddAnchor("TOPLEFT", combatResourceBar, "TOPLEFT", 0, 0)
    combatResourceText.style:SetFontSize(FONT_SIZE.SMALL)
    combatResourceText.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(combatResourceText, FONT_COLOR.WHITE)
    function element:SetCombatResource(currentCombatResource, maxCombatResource)
      local cooldownTotal = 100
      self.combatResourceBar:SetMinMaxValues(0, math.floor(maxCombatResource / cooldownTotal))
      self.combatResourceBar:SetValue(math.floor(currentCombatResource / cooldownTotal))
      self.combatResourceText:SetText(string.format("%d/%d", currentCombatResource / cooldownTotal, maxCombatResource / cooldownTotal))
      local remain = 0
      if math.floor(currentCombatResource / cooldownTotal) ~= math.floor(maxCombatResource / cooldownTotal) then
        remain = cooldownTotal - currentCombatResource % cooldownTotal
      end
      self.cooldownIcon:SetCoolDown(remain, cooldownTotal)
    end
    element:Show(true)
    return element
  end
  window.elementWidgetMap = {}
  function window:UpdateLayout(infos)
    self.elementWidgetMap = {}
    if self.innerRect.elements ~= nil then
      for i = 1, #self.innerRect.elements do
        self.innerRect.elements[i]:Show(false)
      end
    end
    local index = 1
    local anchorTarget = self.innerRect
    local anchorTargetPoint = "TOPLEFT"
    if infos.boundslave ~= nil then
      self.elementWidgetMap.boundslave = {
        elementWidget = nil,
        childSlaves = {}
      }
      if infos.boundslave.name ~= nil then
        local element = self:MakeElement(index, anchorTarget, anchorTargetPoint)
        element:SetElementName(infos.boundslave.name)
        element:SetElementIcon(infos.boundslave.iconPath)
        self.elementWidgetMap.boundslave.elementWidget = element
        anchorTarget = element
        anchorTargetPoint = "BOTTOMLEFT"
        index = index + 1
      end
      if infos.boundslave.childSlaveInfos ~= nil then
        local count = #infos.boundslave.childSlaveInfos
        for i = 1, count do
          local childSlaveInfo = infos.boundslave.childSlaveInfos[i]
          local element = self:MakeElement(index, anchorTarget, anchorTargetPoint)
          element:SetElementName(childSlaveInfo.name)
          element:SetElementIcon(childSlaveInfo.iconPath)
          self.elementWidgetMap.boundslave.childSlaves[ChildSlaveKeyByAttachPoint(childSlaveInfo.attachPoint)] = {elementWidget = element}
          anchorTarget = element
          anchorTargetPoint = "BOTTOMLEFT"
          index = index + 1
        end
      end
    end
    self.innerRect:SetHeight((index - 1) * (ELEMENT_HIGHT + ELEMENT_ANCHOR_OFFSET_Y))
    self:SetHeight(self.title:GetHeight() + self.innerRect:GetHeight() + 12)
  end
  window.timeCheck = 0
  function window:OnUpdate(dt)
    self.timeCheck = self.timeCheck + dt
    if self.timeCheck < 1000 then
      return
    end
    self.timeCheck = dt
    local needUpdate = false
    for unitText, value in pairs(self.elementWidgetMap) do
      needUpdate = true
      break
    end
    if needUpdate == false then
      return
    end
    for unitText, value in pairs(self.elementWidgetMap) do
      local combatResourceInfo = X2Unit:UnitCombatResource(unitText)
      if combatResourceInfo ~= nil then
        local elementWidgetInfo = self.elementWidgetMap[unitText]
        if elementWidgetInfo ~= nil then
          if elementWidgetInfo.elementWidget ~= nil then
            elementWidgetInfo.elementWidget:SetCombatResource(combatResourceInfo.preciseCombatResource, combatResourceInfo.maxCombatResource)
          end
          if combatResourceInfo.childSlaveInfos ~= nil then
            for i = 1, #combatResourceInfo.childSlaveInfos do
              local childSlaveInfo = combatResourceInfo.childSlaveInfos[i]
              local otherElementWidgetInfo = elementWidgetInfo.childSlaves[ChildSlaveKeyByAttachPoint(childSlaveInfo.attachPoint)]
              if otherElementWidgetInfo ~= nil and otherElementWidgetInfo.elementWidget ~= nil then
                otherElementWidgetInfo.elementWidget:SetCombatResource(childSlaveInfo.preciseCombatResource, childSlaveInfo.maxCombatResource)
              end
            end
          end
        end
      end
    end
  end
  window:SetHandler("OnUpdate", window.OnUpdate)
  return window
end
function CreateCoolDownIcon(parent, path)
  local cooldownIcon = parent:CreateChildWidget("cooldownbutton", "cooldownIcon", 0, true)
  cooldownIcon:SetExtent(28, 28)
  cooldownIcon:Clickable(false)
  cooldownIcon:EnableFocus(false)
  local drawable = cooldownIcon:CreateIconImageDrawable("ui/icon/cooldown_mask.dds", "background")
  drawable:SetExtent(28, 28)
  drawable:AddAnchor("CENTER", cooldownIcon, 0, 0)
  drawable:SetCoords(0, 0, 256, 256)
  drawable:SetColor(1, 1, 1, 1)
  cooldownIcon:SetNormalBackground(drawable)
  cooldownIcon:SetDisabledBackground(drawable)
  cooldownIcon:SetHighlightBackground(drawable)
  cooldownIcon:SetPushedBackground(drawable)
  cooldownIcon.currentIconPath = INVALID_ICON_PATH
  local normalImage = cooldownIcon:CreateStateDrawable(UI_BUTTON_NORMAL, UOT_ICON_IMAGE_DRAWABLE, cooldownIcon.currentIconPath, "background")
  normalImage:SetColor(1, 1, 1, 1)
  normalImage:SetExtent(28, 28)
  normalImage:AddAnchor("CENTER", cooldownIcon, 0, 0)
  cooldownIcon.normalImage = normalImage
  local overImage = cooldownIcon:CreateStateDrawable(UI_BUTTON_HIGHLIGHTED, UOT_ICON_IMAGE_DRAWABLE, cooldownIcon.currentIconPath, "background")
  overImage:SetColor(1, 1, 1, 1)
  overImage:SetExtent(28, 28)
  overImage:AddAnchor("CENTER", cooldownIcon, 0, 0)
  cooldownIcon.overImage = overImage
  local pushImage = cooldownIcon:CreateStateDrawable(UI_BUTTON_PUSHED, UOT_ICON_IMAGE_DRAWABLE, cooldownIcon.currentIconPath, "background")
  pushImage:SetColor(1, 1, 1, 1)
  pushImage:SetExtent(28, 28)
  pushImage:AddAnchor("CENTER", cooldownIcon, 0, 0)
  cooldownIcon.pushImage = pushImage
  local disableImage = cooldownIcon:CreateStateDrawable(UI_BUTTON_DISABLED, UOT_ICON_IMAGE_DRAWABLE, cooldownIcon.currentIconPath, "background")
  disableImage:SetColor(1, 1, 1, 1)
  disableImage:SetExtent(28, 28)
  disableImage:AddAnchor("CENTER", cooldownIcon, 0, 0)
  cooldownIcon.disableImage = disableImage
  cooldownIcon:SetCoolDownMask("ui/icon/cooldown_mask.dds")
  cooldownIcon:SetCoolDownMaskCoords(0, 0, 256, 256)
  function cooldownIcon:SetIcon(iconPath)
    if iconPath == nil or self.currentIconPath == iconPath then
      return
    end
    self.normalImage:ClearAllTextures()
    self.normalImage:AddTexture(iconPath)
    self.overImage:ClearAllTextures()
    self.overImage:AddTexture(iconPath)
    self.pushImage:ClearAllTextures()
    self.pushImage:AddTexture(iconPath)
    self.disableImage:ClearAllTextures()
    self.disableImage:AddTexture(iconPath)
    self.currentIconPath = iconPath
  end
  return cooldownIcon
end
local combatResourceFrame = CreateCombatResourceFrame()
combatResourceFrame:SetTitle(GetCommonText("combat_resource"))
AddUISaveHandlerByKey("combatResourceFrame", combatResourceFrame)
local function ToggleCombatResource()
  local infos = X2Unit:GetCombatResourceUnitInfos()
  for unitText, info in pairs(infos) do
    combatResourceFrame:UpdateLayout(infos)
    combatResourceFrame:Show(true)
    return
  end
  combatResourceFrame:Show(false)
end
local combatResourceFrameEvents = {
  MODE_ACTIONS_UPDATE = function()
    ToggleCombatResource()
  end,
  ENTERED_WORLD = function()
    ToggleCombatResource()
  end,
  LEFT_LOADING = function()
    ToggleCombatResource()
  end
}
combatResourceFrame:SetHandler("OnEvent", function(this, event, ...)
  combatResourceFrameEvents[event](...)
end)
RegistUIEvent(combatResourceFrame, combatResourceFrameEvents)
