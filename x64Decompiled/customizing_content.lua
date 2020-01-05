local titleMargin, sideMargin, bottomMargin = GetWindowMargin()
local CUSTOMIZING_CONTENT = {}
local RACE, GENDER
local CONTENT_WIDTH = 320
local GetParamCount = function(uiStyle)
  if uiStyle == SELECTION_UI_STYLE then
    return 1
  elseif uiStyle == PALLET_UI_STYLE then
    return 3
  elseif uiStyle == SLIDER_UI_STYLE then
    return 1
  elseif uiStyle == POSITION_UI_STYLE then
    return 2
  elseif uiStyle == MODIFIER_UI_STYLE then
    return 0
  elseif uiStyle == COLOR_SELECTION_UI_STYLE then
    return 1
  elseif uiStyle == PUPIL_RANGE_UI_STYLE then
    return 1
  else
    return 0
  end
end
local ApplyCustomizingUIFunction = function(wnd, parent)
  local uiList = {}
  uiList[#uiList + 1] = wnd.cType
  if wnd.info.childs ~= nil then
    for i = 1, #wnd.info.childs do
      uiList[#uiList + 1] = wnd.info.childs[i]
    end
  end
  function wnd:RefreshUI()
    local funcs = CUSTOMIZING_FUNCTIONAL_INFO[wnd.cType]
    if funcs ~= nil and funcs.getFunc ~= nil then
      local v = {
        funcs:getFunc()
      }
      local vIndex = 1
      for i = 1, #uiList do
        local uiWnd = GetCustomizingContent(uiList[i])
        local info = CUSTOMIZING_TYPE_INFO[uiWnd.cType]
        local uiStyle = info.uiStyle
        if uiStyle == SELECTION_UI_STYLE then
          uiWnd:SelectItem(v[vIndex])
          vIndex = vIndex + 1
        elseif uiStyle == PALLET_UI_STYLE then
          uiWnd.pallet:L_Init(v[vIndex], v[vIndex + 1], v[vIndex + 2])
          vIndex = vIndex + 3
        elseif uiStyle == SLIDER_UI_STYLE then
          uiWnd:SetValue(v[vIndex])
          vIndex = vIndex + 1
        elseif uiStyle == POSITION_UI_STYLE then
          uiWnd:SetPos(v[vIndex], v[vIndex + 1])
          vIndex = vIndex + 2
        elseif uiStyle == COLOR_SELECTION_UI_STYLE then
          uiWnd:SelectItem(v[vIndex])
          vIndex = vIndex + 1
        end
      end
      if RELATION_CUSTOMZIZING_FUNC[wnd.cType] ~= nil then
        RELATION_CUSTOMZIZING_FUNC[wnd.cType]()
      end
    end
  end
  function wnd:UpdateValue()
    local funcs = CUSTOMIZING_FUNCTIONAL_INFO[wnd.cType]
    if funcs ~= nil and funcs.setFunc ~= nil then
      local v = {}
      for i = 1, #uiList do
        local uiWnd = GetCustomizingContent(uiList[i])
        local info = CUSTOMIZING_TYPE_INFO[uiWnd.cType]
        local uiStyle = info.uiStyle
        if uiStyle == SELECTION_UI_STYLE then
          v[#v + 1] = uiWnd.selectIdx
        elseif uiStyle == PALLET_UI_STYLE then
          local r, g, b = uiWnd.pallet:L_GetRGBColor()
          v[#v + 1] = r
          v[#v + 1] = g
          v[#v + 1] = b
        elseif uiStyle == SLIDER_UI_STYLE then
          v[#v + 1] = uiWnd.weight
        elseif uiStyle == POSITION_UI_STYLE then
          v[#v + 1] = uiWnd.posX
          v[#v + 1] = uiWnd.posY
        elseif uiStyle == COLOR_SELECTION_UI_STYLE then
          v[#v + 1] = uiWnd.selectIdx
        end
      end
      funcs.setFunc(unpack(v))
      if CUSTOMIZING_TYPE_INFO[wnd.cType].uiStyle ~= PALLET_UI_STYLE then
        wnd:RefreshUI()
      end
    else
      parent:UpdateValue()
    end
  end
end
local function CreateCustomizingContent(cType, parent)
  local info = CUSTOMIZING_TYPE_INFO[cType]
  local uiStyle = info.uiStyle
  local uiOption = info.uiOption
  local wnd
  if uiStyle == SELECTION_UI_STYLE then
    wnd = CreateCustomizingSelectionUI("content" .. cType, parent)
  elseif uiStyle == PALLET_UI_STYLE then
    wnd = CreateCustomizingPalletUI("content" .. cType, parent)
  elseif uiStyle == SLIDER_UI_STYLE then
    wnd = CreateCustomizingSliderUI("content" .. cType, parent)
  elseif uiStyle == POSITION_UI_STYLE then
    wnd = CreateCustomizingPositionUI("content" .. cType, parent)
  elseif uiStyle == MODIFIER_UI_STYLE then
    wnd = CreateCustomizingModifierUI("content" .. cType, parent)
  elseif uiStyle == COLOR_SELECTION_UI_STYLE then
    wnd = CreateCustomizingColorSelectionUI("content" .. cType, parent)
  elseif uiStyle == PUPIL_RANGE_UI_STYLE then
    wnd = CreateCustomizingSelectionRangeUI("content" .. cType, parent)
  else
    UIParent:LogAlways("CAN NOT FOUND UI STYLE : " .. tostring(uiStyle))
    wnd = CreateCustomizingModifierUI("content" .. cType, parent)
  end
  wnd:SetCustomizingType(cType)
  if info.childs ~= nil then
    for i = 1, #info.childs do
      local cInfo = info.childs[i]
      local child = GetCustomizingContent(cInfo)
      if child == nil then
        child = CreateCustomizingContent(cInfo, wnd)
      end
    end
  end
  function wnd:OnShow()
    if wnd.info.childs ~= nil then
      for i = 1, #wnd.info.childs do
        local child = GetCustomizingContent(wnd.info.childs[i])
        child:Show(true)
      end
    end
  end
  wnd:SetHandler("OnShow", wnd.OnShow)
  ApplyCustomizingUIFunction(wnd, parent)
  CUSTOMIZING_CONTENT[cType] = wnd
  return wnd
end
function GetCustomizingContent(cType, parent)
  if CUSTOMIZING_CONTENT[cType] == nil then
    return nil
  end
  return CUSTOMIZING_CONTENT[cType]
end
local requireUpdate = {}
function SetAllRequireUpdate()
  requireUpdate = {}
end
function CreateCustomizingContentWnd(id, parent)
  local wnd
  if parent == "UIParent" then
    wnd = CreateEmptyWindow(id, "UIParent")
  else
    wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  end
  wnd:SetWidth(CONTENT_WIDTH + 30)
  wnd:Clickable(false)
  local body = wnd:CreateChildWidget("emptywidget", "body", 0, true)
  body:AddAnchor("RIGHT", wnd, -15, 0)
  body:SetWidth(CONTENT_WIDTH)
  body:Clickable(false)
  local topBg = wnd:CreateDrawable(TEXTURE_PATH.CUSTOMIZING, "setting_bg_top", "background")
  topBg:AddAnchor("TOPRIGHT", wnd, 0, 0)
  local bottomBg = wnd:CreateDrawable(TEXTURE_PATH.CUSTOMIZING, "setting_bg_bottom", "background")
  bottomBg:AddAnchor("BOTTOMLEFT", wnd, 0, 0)
  function wnd:CleanUp()
    for type, childWnd in pairs(CUSTOMIZING_CONTENT) do
      childWnd:RemoveAllAnchors()
      childWnd:Show(false)
    end
  end
  function wnd:RefreshUI()
    for i = 1, #wnd.contents do
      local cType = wnd.contents[i]
      local customWnd = GetCustomizingContent(cType)
      if customWnd ~= nil then
        customWnd:RefreshUI()
      end
    end
  end
  function wnd:ShowContents(contents)
    wnd:CleanUp()
    wnd.contents = contents
    local height = 0
    local LAST_WND
    for i = 1, #contents do
      local cType = contents[i]
      if RACIAL_CUSTOMIZING_INFO[cType] == nil or RACIAL_CUSTOMIZING_INFO[cType](RACE, GENDER) == true then
        local customWnd = GetCustomizingContent(cType)
        if customWnd == nil then
          customWnd = CreateCustomizingContent(cType, body)
        end
        if requireUpdate[cType] == nil or requireUpdate[cType] == true then
          customWnd:Update()
          requireUpdate[cType] = false
        end
        local info = CUSTOMIZING_TYPE_INFO[cType]
        if LAST_WND == nil then
          customWnd:AddAnchor("TOPLEFT", body, 0, 0)
        elseif info.uiStyle == MODIFIER_UI_STYLE then
          customWnd:AddAnchor("TOPLEFT", LAST_WND, "BOTTOMLEFT", 0, 15)
        else
          customWnd:AddAnchor("TOPLEFT", LAST_WND, "BOTTOMLEFT", 0, 25)
        end
        if info.childs ~= nil then
          local LAST_CHILD_WND
          for i = 1, #info.childs do
            local childType = info.childs[#info.childs + 1 - i]
            local childWnd = GetCustomizingContent(childType)
            local childInfo = CUSTOMIZING_TYPE_INFO[childType]
            if LAST_CHILD_WND == nil then
              childWnd:AddAnchor("BOTTOMRIGHT", customWnd, 0, 0)
            elseif childInfo.uiStyle == SLIDER_UI_STYLE then
              childWnd:AddAnchor("BOTTOMRIGHT", LAST_CHILD_WND, "TOPRIGHT", 0, -CHILD_OFFSET + 5)
            elseif childInfo.uiStyle == SELECTION_UI_STYLE then
              childWnd:AddAnchor("BOTTOMRIGHT", LAST_CHILD_WND, "TOPRIGHT", 0, -CHILD_OFFSET)
            else
              childWnd:AddAnchor("BOTTOMRIGHT", LAST_CHILD_WND, "TOPRIGHT", 0, -CHILD_OFFSET)
            end
            LAST_CHILD_WND = childWnd
          end
        end
        if cType ~= HAIR_COLOR_SELECT_TYPE then
          if info.uiStyle == MODIFIER_UI_STYLE then
            height = height + 15
          elseif LAST_WND ~= nil then
            height = height + 25
          end
          height = height + customWnd:GetHeight()
          LAST_WND = customWnd
        end
        customWnd:Show(true)
      end
    end
    for i = 1, #contents do
      local cType = contents[i]
      local customWnd = GetCustomizingContent(cType)
      if customWnd ~= nil then
        customWnd:RefreshUI()
      end
    end
    body:SetHeight(height)
    if height + 40 < wnd.menuWnd:GetHeight() then
      wnd:SetHeight(wnd.menuWnd:GetHeight())
    else
      wnd:SetHeight(height + 40)
    end
    wnd:Show(true)
  end
  function wnd:SetMenuWnd(menuWnd)
    wnd.menuWnd = menuWnd
  end
  function wnd:ApplyRaceGender(race, gender)
    RACE = race
    GENDER = gender
    requireUpdate = {}
  end
  return wnd
end
local IconPathStrTable = {
  [WRINKLE_STYLE_TYPE] = "skin",
  [SKIN_COLOR_TYPE] = "skin_color",
  [EYEBROW_STYLE_TYPE] = "decal_eyebrow",
  [EYEMAKEUP_STYLE_TYPE] = "decal_makeup",
  [PUPIL_STYLE_TYPE] = "decal_pupil",
  [CHEEK_STYLE_TYPE] = "decal_deco",
  [TATTO_STYLE_TYPE] = "decal_tattoo",
  [SCAR_STYLE_TYPE] = "decal_scar",
  [BEARD_STYLE_TYPE] = "decal_deco",
  [FACE_MAKEUP_STYLE_TYPE] = "decal_deco",
  [MUSCLE_STYLE_TYPE] = "",
  [TOTAL_PRESET_TYPE] = "preset",
  [EYE_PRESET_TYPE] = "preset_eye",
  [NOSE_PRESET_TYPE] = "preset_nose",
  [MOUTH_PRESET_TYPE] = "preset_lip",
  [SHAPE_PRESET_TYPE] = "preset_face",
  [DRESS_PRESET_TYPE] = "",
  [MUSCLE_STYLE_TYPE] = "muscle"
}
local ItemIconRaceStr = {
  [RACE_NUIAN] = "nuian",
  [RACE_ELF] = "elf",
  [RACE_FERRE] = "fere",
  [RACE_HARIHARAN] = "hariharan",
  [RACE_WARBORN] = "warborn",
  [RACE_DWARF] = "dwarf",
  [RACE_FAIRY] = "fairy",
  [RACE_RETURNED] = "returned"
}
local ItemIconGenderStr = {
  [GENDER_MALE] = "m",
  [GENDER_FEMALE] = "f"
}
function GetCustomizingItemIconInfo(cType, path)
  UIParent:LogAlways(string.format("!!!!!!!!!!! path: %s", path))
  if cType == HAIR_STYLE_TYPE or cType == HAIR_COLOR_SELECT_TYPE or cType == HORN_STYLE_TYPE or cType == DRESS_PRESET_TYPE or cType == SKIN_COLOR_TYPE or cType == MUSCLE_STYLE_TYPE then
    return path
  end
  if cType == HORN_COLOR_TYPE then
    return string.format("ui/login_stage/customizing/horn_color/%s", path)
  end
  return string.format("ui/login_stage/customizing/%s_%s/%s/%s", ItemIconRaceStr[RACE], ItemIconGenderStr[GENDER], IconPathStrTable[cType], path)
end
