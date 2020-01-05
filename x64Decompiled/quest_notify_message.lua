function CreateQuestNotifyWindow(id, parent)
  local chatWindow = UIParent:CreateWidget("message", id, parent)
  chatWindow.style:SetAlign(ALIGN_CENTER)
  chatWindow.style:SetSnap(true)
  chatWindow.style:SetShadow(true)
  chatWindow:SetLineSpace(TEXTBOX_LINE_SPACE.MIDDLE)
  chatWindow.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  chatWindow.style:SetColor(ConvertColor(106), ConvertColor(193), ConvertColor(225), 1)
  chatWindow:SetTimeVisible(3)
  chatWindow:SetMaxLines(2)
  return chatWindow
end
quest_notifyWindow = CreateQuestNotifyWindow("quest_notifyWindow", systemLayerParent)
quest_notifyWindow:SetExtent(UIParent:GetScreenWidth(), 50)
quest_notifyWindow:AddAnchor("TOP", "UIParent", "TOP", 0, 250)
notifyWindowBack = quest_notifyWindow:CreateColorDrawable(ConvertColor(106), ConvertColor(193), ConvertColor(225), 0, "background")
notifyWindowBack:AddAnchor("TOPLEFT", quest_notifyWindow, 0, 0)
notifyWindowBack:AddAnchor("BOTTOMRIGHT", quest_notifyWindow, 0, 0)
quest_notifyWindow:Show(true)
quest_notifyWindow:Clickable(false)
