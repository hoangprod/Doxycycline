local MAIN_MENU = {}
local SUB_MENU = {}
local FIRST_BTN, LAST_BTN
local INDENT = 30
local MENU_WIDTH = 411
function IsCategory(info)
  if info.childs == nil then
    return false
  end
  if CUSTOMIZING_TYPE_INFO[info.childs[1]].uiStyle ~= nil then
    return false
  end
  return true
end
local function MakeMenu(info, parent)
  if info.uiStyle ~= nil or info.childs == nil then
    return
  end
  local btn
  if info.name ~= nil then
    btn = parent:CreateChildWidget("button", "menuBtn", info.cType, true)
    btn:SetText(info.name)
    if IsCategory(info) then
      ApplyButtonSkin(btn, CUSTOMIZING_MENU_SKIN.NOT_BUTTON)
      btn.depth = 1
      btn.skin = CUSTOMIZING_MENU_SKIN.NOT_BUTTON
      btn:Clickable(false)
    elseif info.cType == RECOMMAND_MENU_TYPE or info.cType == DRESS_MENU_TYPE then
      ApplyButtonSkin(btn, CUSTOMIZING_MENU_SKIN.MENU_BUTTON)
      btn.depth = 1
      btn.skin = CUSTOMIZING_MENU_SKIN.MENU_BUTTON
    else
      ApplyButtonSkin(btn, CUSTOMIZING_MENU_SKIN.SUB_MENU_BUTTON)
      btn.depth = 2
      btn.skin = CUSTOMIZING_MENU_SKIN.SUB_MENU_BUTTON
    end
    if LAST_BTN ~= nil then
      if LAST_BTN.depth < btn.depth then
        local lineBg = LAST_BTN:CreateDrawable(TEXTURE_PATH.CUSTOMIZING, "menu_line", "overlay")
        lineBg:AddAnchor("TOPLEFT", LAST_BTN, "BOTTOMLEFT", 0, -1)
        LAST_BTN.lineBg = lineBg
        btn:AddAnchor("TOPLEFT", LAST_BTN, "BOTTOMLEFT", INDENT, -1)
      elseif LAST_BTN.depth == btn.depth then
        btn:AddAnchor("TOPLEFT", LAST_BTN, "BOTTOMLEFT", 0, -1)
      else
        btn:AddAnchor("TOPLEFT", LAST_BTN, "BOTTOMLEFT", -INDENT, 0)
      end
    else
      FIRST_BTN = btn
    end
    LAST_BTN = btn
    function btn:OnClick()
      parent:SelectCustomizingType(info.cType)
    end
    btn:SetHandler("OnClick", btn.OnClick)
    btn.cType = info.cType
    parent.btns[info.cType] = btn
  end
  for i = 1, #info.childs do
    local childInfo = CUSTOMIZING_TYPE_INFO[info.childs[i]]
    childInfo.cType = info.childs[i]
    MakeMenu(childInfo, parent)
  end
end
function CreateCustomizingMenuWnd(id, parent)
  local wnd
  if parent == "UIParent" then
    wnd = CreateEmptyWindow(id, "UIParent")
  else
    wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  end
  local bg = wnd:CreateDrawable(TEXTURE_PATH.CUSTOMIZING, "menu_bg", "background")
  bg:AddAnchor("TOPLEFT", wnd, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  wnd.btns = {}
  MakeMenu(CUSTOMIZING_MENU_INFO, wnd)
  if FIRST_BTN ~= nil then
    FIRST_BTN:AddAnchor("TOPLEFT", wnd, 0, 34)
  end
  function wnd:SetContentWnd(contenWnd)
    wnd.contentWnd = contenWnd
  end
  function wnd:ApplyRaceGender(race, gender)
    for type, btn in pairs(wnd.btns) do
      if RACIAL_CUSTOMIZING_INFO[type] ~= nil then
        if RACIAL_CUSTOMIZING_INFO[type](race, gender) == true then
          btn:SetHeight(btn.skin.height)
          btn:Show(true)
        else
          btn:SetHeight(0)
          btn:Show(false)
        end
      else
        btn:SetHeight(btn.skin.height)
        btn:Show(true)
      end
    end
    local _, startY = FIRST_BTN:GetOffset()
    local _, endY = LAST_BTN:GetOffset()
    local extentX, extentY = LAST_BTN:GetExtent()
    wnd:SetExtent(MENU_WIDTH ~= nil and MENU_WIDTH or extentX + INDENT, endY - startY + extentY + 60)
  end
  function wnd:SelectCustomizingType(cType)
    for type, btn in pairs(wnd.btns) do
      if type == cType then
        btn:Enable(false)
      else
        btn:Enable(true)
      end
    end
    if wnd.contentWnd ~= nil then
      wnd.contentWnd:ShowContents(CUSTOMIZING_TYPE_INFO[cType].childs)
    end
  end
  function wnd:CleanUp()
    if wnd.contentWnd ~= nil then
      wnd.contentWnd:CleanUp()
    end
  end
  return wnd
end
