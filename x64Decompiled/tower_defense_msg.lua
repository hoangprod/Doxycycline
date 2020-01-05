local towerDefenseMsg
local function CreateTowerDefenseMsg(id, parent)
  local frame = CreateCenterMessageFrame(id, parent, "TYPE1")
  frame:EnableHidingIsRemove(true)
  frame.icon:RemoveAllAnchors()
  frame.icon:AddAnchor("BOTTOM", frame.bg, "TOP", 0, 31)
  frame.iconBg:RemoveAllAnchors()
  frame.iconBg:AddAnchor("BOTTOM", frame.bg, "TOP", 0, MARGIN.WINDOW_SIDE)
  local title = frame:CreateChildWidget("textbox", "title", 0, true)
  title:SetAutoResize(true)
  title:AddAnchor("TOP", frame.bg, 0, MARGIN.WINDOW_SIDE)
  title:SetExtent(frame:GetWidth(), FONT_SIZE.XLARGE)
  title.style:SetFontSize(FONT_SIZE.XLARGE)
  title.style:SetShadow(true)
  frame.body:SetWidth(1000)
  frame.body:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  frame.body:AddAnchor("TOP", title, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 3)
  frame.body.style:SetFontSize(FONT_SIZE.LARGE)
  local function OnEndFadeOut()
    towerDefenseMsg = nil
    StartNextImgEvent()
  end
  frame:SetHandler("OnEndFadeOut", OnEndFadeOut)
  function frame:FillMsg(text, title)
    self.title:SetText(title)
    self.body:SetTextAutoWidth(1000, text, 5)
    self.body:SetHeight(self.body:GetTextHeight())
  end
  return frame
end
function ShowCustomIconMeesage(text, title, path, iconKey)
  if towerDefenseMsg == nil then
    towerDefenseMsg = CreateTowerDefenseMsg("towerDefenseMsg", systemLayerParent)
  end
  towerDefenseMsg.icon:SetVisible(false)
  towerDefenseMsg.iconBg:SetVisible(false)
  local iconPath = string.format(path, iconKey)
  if X2:IsExistFileInAFS(iconPath) then
    towerDefenseMsg.icon:SetTexture(iconPath)
    towerDefenseMsg.icon:SetTextureInfo(iconKey)
    towerDefenseMsg.icon:SetVisible(true)
    towerDefenseMsg.iconBg:SetVisible(true)
  else
    UIParent:Warning(string.format("[Lua Error] can't find icon image.. [%s]", tostring(iconPath)))
  end
  towerDefenseMsg:FillMsg(text, title)
  towerDefenseMsg:SetHandler("OnUpdate", towerDefenseMsg.OnUpdate)
  towerDefenseMsg:Show(true)
  return true
end
