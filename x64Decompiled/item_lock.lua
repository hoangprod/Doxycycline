local lockWnd
function CreateItemLockWnd(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local isShowEquipItemLock = X2Item:IsShowEquipItemLockUI()
  local height = 280
  if isShowEquipItemLock == true then
    height = 420
  end
  local wnd = CreateWindow(id, parent, "item_lock")
  wnd:Show(false)
  wnd:AddAnchor("CENTER", "UIParent", 0, 0)
  wnd:SetExtent(POPUP_WINDOW_WIDTH, height)
  wnd:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "item_lock"))
  wnd:EnableHidingIsRemove(true)
  wnd:SetCloseOnEscape(true)
  local textbox = wnd:CreateChildWidget("textbox", "textbox", 0, true)
  textbox:SetExtent(POPUP_WINDOW_WIDTH - 50, FONT_SIZE.MIDDLE)
  textbox:SetAutoResize(true)
  textbox:SetText(GetUIText(MSG_BOX_BODY_TEXT, "explan_item_secure"))
  ApplyTextColor(textbox, FONT_COLOR.TITLE)
  textbox:AddAnchor("BOTTOM", wnd.titleBar, 0, 20 + (textbox:GetLineCount() - 1) * 10)
  local function CreateItem(id, buttonStyle, titleColor, titleText, descText)
    local button = wnd:CreateChildWidget("button", id, 0, true)
    ApplyButtonSkin(button, buttonStyle)
    local title = button:CreateChildWidget("label", "title", 0, true)
    title:SetAutoResize(true)
    title:SetHeight(FONT_SIZE.MIDDLE)
    title:SetText(titleText)
    title.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(title, titleColor)
    local desc = button:CreateChildWidget("textbox", "desc", 0, true)
    desc:SetExtent(235, FONT_SIZE.MIDDLE)
    desc:SetText(descText)
    desc:SetHeight(desc:GetTextHeight())
    desc:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, sideMargin / 2.5)
    desc:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
    desc.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(desc, FONT_COLOR.DEFAULT)
    title:AddAnchor("TOPLEFT", button, "RIGHT", 0, -(desc:GetHeight() / 1.2))
  end
  CreateItem("itemLockBtn", BUTTON_CONTENTS.LOCK_ITEM, FONT_COLOR.BLUE, GetUIText(WINDOW_TITLE_TEXT, "item_lock"), locale.inven.lockItemDesc)
  wnd.itemLockBtn:AddAnchor("TOPLEFT", wnd, sideMargin, titleMargin + 35)
  local line = CreateLine(wnd, "TYPE1")
  line:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 3)
  line:AddAnchor("TOPLEFT", wnd.itemLockBtn, "BOTTOMLEFT", 0, sideMargin / 1.5)
  CreateItem("itemUnlockBtn", BUTTON_CONTENTS.UNLOCK_ITEM, FONT_COLOR.RED, GetUIText(INVEN_TEXT, "unlock_item"), locale.inven.unlockItemDesc)
  if isShowEquipItemLock == true then
    CreateItem("equipLockBtn", BUTTON_CONTENTS.LOCK_EQUIP, FONT_COLOR.BLUE, locale.inven.lockEquip, locale.inven.lockEquipDesc)
    wnd.equipLockBtn:AddAnchor("TOPLEFT", wnd.itemLockBtn, "BOTTOMLEFT", 0, 0)
    wnd.itemUnlockBtn:AddAnchor("TOPLEFT", wnd.equipLockBtn, "BOTTOMLEFT", 0, sideMargin * 1.5)
    CreateItem("equipUnlockBtn", BUTTON_CONTENTS.UNLOCK_EQUIP, FONT_COLOR.RED, locale.inven.unlockEquip, locale.inven.unlockEquipDesc)
    wnd.equipUnlockBtn:AddAnchor("TOPLEFT", wnd.itemUnlockBtn, "BOTTOMLEFT", 0, 0)
    do
      local function ShowDialog(lock)
        local key = lock and "lock_equip" or "unlock_equip"
        local function DialogHandler(wnd)
          local delayMin = X2Item:GetSecurityUnlockDelayTime()
          local title = X2Locale:LocalizeUiText(INVEN_TEXT, key)
          local content = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, key, FONT_COLOR_HEX.RED, tostring(delayMin / 60))
          wnd:SetTitle(title)
          wnd:SetContent(content)
          function wnd:OkProc()
            if lock then
              X2Equipment:SecurityLock()
            else
              X2Equipment:SecurityUnlock()
            end
          end
        end
        X2DialogManager:RequestDefaultDialog(DialogHandler, wnd:GetId())
      end
      local function OnClick()
        ShowDialog(true)
      end
      wnd.equipLockBtn:SetHandler("OnClick", OnClick)
      local function OnClick()
        ShowDialog(false)
      end
      wnd.equipUnlockBtn:SetHandler("OnClick", OnClick)
    end
  else
    wnd.itemUnlockBtn:AddAnchor("TOPLEFT", wnd.itemLockBtn, "BOTTOMLEFT", 0, sideMargin * 1.5)
  end
  local function OnHide()
    if X2Item:IsInSecurityLockMode() then
      X2Item:LeaveSecurityLockMode()
    elseif X2Item:IsInSecurityUnlockMode() then
      X2Item:LeaveSecurityUnlockMode()
    end
    lockWnd = nil
  end
  wnd:SetHandler("OnHide", OnHide)
  local LockOnClick = function()
    X2Item:EnterSecurityLockMode()
  end
  wnd.itemLockBtn:SetHandler("OnClick", LockOnClick)
  local UnlockOnClick = function()
    X2Item:EnterSecurityUnlockMode()
  end
  wnd.itemUnlockBtn:SetHandler("OnClick", UnlockOnClick)
  return wnd
end
function ToggleItemLockWindow(isShow)
  if isShow == nil then
    isShow = lockWnd == nil and true or not lockWnd:IsVisible()
  end
  if lockWnd == nil then
    lockWnd = CreateItemLockWnd("itemLockWnd", "UIParent")
  end
  lockWnd:Show(isShow)
end
