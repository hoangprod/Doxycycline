local CreatePickBuffList = function(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(POPUP_WINDOW_WIDTH, 430)
  window:SetTitle(GetUIText(COMMON_TEXT, "battlefield_pick_buff_title"))
  window:SetCloseOnEscape(false)
  window.titleBar.closeButton:Show(false)
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local contentWidth = window:GetWidth() - sideMargin * 2
  local description = window:CreateChildWidget("textbox", "description", 0, true)
  description:SetWidth(contentWidth)
  description:SetHeight(85)
  description.style:SetAlign(ALIGN_CENTER)
  description:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  description:SetText(GetUIText(COMMON_TEXT, "battlefield_pick_buff_desc"))
  ApplyTextColor(description, FONT_COLOR.DEFAULT)
  local line = CreateLine(description, "TYPE1")
  line:SetColor(1, 1, 1, 0.5)
  line:AddAnchor("TOPLEFT", description, "BOTTOMLEFT", 0, 3)
  line:AddAnchor("TOPRIGHT", description, "BOTTOMRIGHT", 0, 3)
  local scrollList = W_CTRL.CreateScrollListCtrl("scrollList", window)
  scrollList:SetWidth(contentWidth)
  scrollList:SetHeight(220)
  scrollList:HideColumnButtons()
  scrollList:AddAnchor("TOPLEFT", description, "BOTTOMLEFT", 0, 5)
  window.scrollList = scrollList
  local selectedBuffType = 0
  function window.scrollList:SelChangedProc(selDataViewIdx, selDataIdx, selDataKey, doubleClick)
    window.okButton:Enable(false)
    if selDataIdx <= 0 or selDataIdx > self:GetDataCount() then
      return
    end
    local colData = window.scrollList:GetSelectedData(1)
    if colData == nil then
      return
    end
    selectedBuffType = colData.buff_id
    window.okButton:Enable(true)
  end
  function window:FillBuffInfos(buffInfos)
    self.scrollList:DeleteAllDatas()
    for i = 1, self.scrollList:GetRowCount() do
      if self.scrollList.listCtrl.items[i].line ~= nil then
        self.scrollList.listCtrl.items[i].line:SetVisible(false)
      end
    end
    if buffInfos == nil then
      return
    end
    local visibleCnt = #buffInfos >= scrollList:GetRowCount() and scrollList:GetRowCount() or #buffInfos
    for i = 1, visibleCnt do
      if self.scrollList.listCtrl.items[i].line ~= nil then
        self.scrollList.listCtrl.items[i].line:SetVisible(true)
      end
    end
    for i = 1, #buffInfos do
      self.scrollList:InsertData(i, 1, buffInfos[i])
    end
  end
  local PickBuffDataSetFunc = function(subItem, data, setValue)
    if setValue then
      if data == nil then
        subItem.buffName:Show(false)
        subItem.buff:Show(false)
        return
      end
      subItem.buffName:SetText(data.name)
      subItem.buffName:SetHeight(subItem.buffName:GetTextHeight())
      subItem.buffName:Show(true)
      subItem.buff:SetTooltip(data)
      F_SLOT.SetIconBackGround(subItem.buff, data.path)
      subItem.buff:Show(true)
    else
      subItem.buffName:Show(false)
      subItem.buff:Show(false)
    end
  end
  local PickBuffLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    local buffName = subItem:CreateChildWidget("textbox", "buffName", 0, true)
    buffName:SetWidth(260)
    buffName:AddAnchor("LEFT", subItem, 0, 0)
    buffName.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(buffName, FONT_COLOR.DEFAULT)
    subItem.buffName = buffName
    local buff = CreateItemIconButton(subItem:GetId() .. ".buff", subItem)
    buff:SetExtent(ICON_SIZE.APPELLAITON, ICON_SIZE.APPELLAITON)
    buff:AddAnchor("RIGHT", subItem, "RIGHT", 0, 0)
    F_SLOT.ApplySlotSkin(buff, buff.back, SLOT_STYLE.BUFF)
    subItem.buff = buff
    local buff_deco = buff:CreateDrawable(TEXTURE_PATH.HUD, "buff_deco", "overlay")
    buff_deco:SetTextureColor("buff")
    buff_deco:AddAnchor("BOTTOM", buff, 0, 0)
  end
  scrollList:InsertColumn("", 290, LCCIT_WINDOW, PickBuffDataSetFunc, nil, nil, PickBuffLayoutSetFunc)
  scrollList:InsertRows(6, false)
  scrollList.listCtrl:UseOverClickTexture()
  local okButton = window:CreateChildWidget("button", "okButton", 0, true)
  okButton:SetText(locale.common.ok)
  okButton:AddAnchor("BOTTOM", window, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  window.okButton = okButton
  local function OkButtonLeftClickFunc()
    if selectedBuffType <= 0 then
      return
    end
    X2BattleField:PickBuff(selectedBuffType)
    window:Show(false)
    battlefield.pickBuffList = nil
  end
  ButtonOnClickHandler(okButton, OkButtonLeftClickFunc)
  return window
end
local function PickBuffListFunc()
  if X2BattleField:IsPossiblePickBuff() == true then
    if battlefield.pickBuffList == nil then
      battlefield.pickBuffList = CreatePickBuffList("pickBuffListWnd", "UIParent")
      battlefield.pickBuffList:EnableHidingIsRemove(true)
      battlefield.pickBuffList:FillBuffInfos(X2BattleField:GetMyPickBuffInfos())
    end
    battlefield.pickBuffList:Show(true)
  elseif battlefield.pickBuffList ~= nil then
    battlefield.pickBuffList:Show(false)
    battlefield.pickBuffList = nil
  end
end
UIParent:SetEventHandler("INSTANT_GAME_PICK_BUFFS", PickBuffListFunc)
UIParent:SetEventHandler("ENTERED_WORLD", PickBuffListFunc)
UIParent:SetEventHandler("LEFT_LOADING", PickBuffListFunc)
local EnteredLoading = function()
  if battlefield.pickBuffList ~= nil then
    battlefield.pickBuffList:Show(false)
    battlefield.pickBuffList = nil
  end
end
UIParent:SetEventHandler("ENTERED_LOADING", EnteredLoading)
