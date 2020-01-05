local CreateSelectionIcon = function(id, parent, idx)
  local btn = parent:CreateChildWidget("button", id, idx, true)
  ApplyButtonSkin(btn, BUTTON_STYLE.CUSTOMIZING_SELECTION)
  local icon = btn:CreateImageDrawable(INVALID_ICON_PATH, "background")
  icon:AddAnchor("TOPLEFT", btn, 0, 0)
  icon:AddAnchor("BOTTOMRIGHT", btn, 0, 0)
  btn.icon = icon
  local newIcon = btn:CreateDrawable(TEXTURE_PATH.CUSTOMIZING, "new_icon", "overlay")
  newIcon:AddAnchor("TOPLEFT", btn, 1, 1)
  newIcon:SetVisible(false)
  function btn:SetItemInfo(path, new)
    icon:SetTexture(path)
    newIcon:Show(new == true)
  end
  return btn
end
local CreateCustomizingScrollWnd = function(id, parent)
  local wnd = CreateScrollWindow(parent, id, 0)
  ApplyButtonSkin(wnd.scroll.upButton, CUSTOM_SCROLL_WND.TOP)
  ApplyButtonSkin(wnd.scroll.downButton, CUSTOM_SCROLL_WND.BOTTOM)
  ApplyButtonSkin(wnd.scroll.vs.thumb, CUSTOM_SCROLL_WND.THUMB)
  wnd.scroll.vs:RemoveAllAnchors()
  wnd.scroll.vs:AddAnchor("TOPLEFT", wnd.scroll.upButton, "BOTTOMLEFT", -1, 0)
  wnd.scroll.vs:AddAnchor("BOTTOMRIGHT", wnd.scroll.downButton, "TOPRIGHT", 1, 0)
  wnd.scroll.bg:SetTexture(TEXTURE_PATH.DEFAULT_NEW)
  wnd.scroll.bg:SetTextureInfo("scroll_bar")
  wnd.scroll:SetBgColor(GetTextureInfo(TEXTURE_PATH.DEFAULT_NEW, "scroll_bar"):GetColors().default)
  wnd.scroll.bg:RemoveAllAnchors()
  wnd.scroll.bg:AddAnchor("TOPLEFT", wnd.scroll.vs, 5, -5)
  wnd.scroll.bg:AddAnchor("BOTTOMRIGHT", wnd.scroll.vs, -5, 5)
  wnd.scroll:SetWidth(16)
  return wnd
end
local CreateCusomizingSlider = function(id, parent)
  local slider = CreateSlider(id, parent)
  slider:SetHeight(18)
  slider.bg:SetTexture(TEXTURE_PATH.DEFAULT_NEW)
  slider.bg:SetTextureInfo("control_bar")
  slider:SetBgColor({
    ConvertColor(115),
    ConvertColor(142),
    ConvertColor(146),
    1
  })
  slider:SetMinThumbLength(27)
  ApplyButtonSkin(slider.thumb, CUSTOM_SLIDER_WND.THUMB)
  return slider
end
function CreateCustomizingSelectionUI(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetWidth(parent:GetWidth())
  wnd.items = {}
  local fontSize = FONT_SIZE.LARGE
  local titleLabel = wnd:CreateChildWidget("label", "titleLabel", 0, true)
  titleLabel:SetHeight(fontSize)
  titleLabel:SetAutoResize(true)
  titleLabel:AddAnchor("TOPLEFT", wnd, 0, 0)
  ApplyTextColor(titleLabel, F_COLOR.GetColor("light_gray"))
  titleLabel.style:SetFont(FONT_PATH.DEFAULT, fontSize)
  local scrollWnd = CreateCustomizingScrollWnd("scrollWnd", wnd)
  scrollWnd:SetWidth(parent:GetWidth())
  scrollWnd:AddAnchor("TOPLEFT", titleLabel, "BOTTOMLEFT", 0, 5)
  scrollWnd:Lock(true)
  local resetBtn = wnd:CreateChildWidget("button", "resetBtn", 0, true)
  ApplyButtonSkin(resetBtn, CUSTOMIZING_BUTTON_SKIN.RESET)
  resetBtn:AddAnchor("BOTTOMRIGHT", scrollWnd.content, "TOPRIGHT", 0, -3)
  local checkBtn = CreateCheckButton("checkBtn", wnd, GetUIText(CHARACTER_CREATE_TEXT, "smileCustom"))
  checkBtn:AddAnchor("TOPRIGHT", wnd, -(checkBtn.textButton:GetWidth() + 20), -1)
  SetButtonFontColorByKey(checkBtn.textButton, "check_btn")
  function checkBtn:CheckBtnCheckChagnedProc(checked)
    local funcs = CUSTOMIZING_FUNCTIONAL_INFO[wnd.cType]
    if funcs ~= nil and funcs.checkFunc ~= nil then
      funcs.checkFunc(checked)
    end
  end
  local function OnHide()
    checkBtn:SetChecked(false, true)
  end
  wnd:SetHandler("OnHide", OnHide)
  local cols = 5
  local rows = 2
  local SELECTION_OFFSET, SELECTION_SIZE
  function resetBtn:OnClick()
    local funcs = CUSTOMIZING_FUNCTIONAL_INFO[wnd.cType]
    if funcs ~= nil and funcs.setFunc ~= nil then
      wnd.selectIdx = 0
      wnd:UpdateValue()
    end
  end
  resetBtn:SetHandler("OnClick", resetBtn.OnClick)
  function wnd:SelectItem(idx)
    if idx == nil then
      idx = 0
    end
    for i = 1, #wnd.items do
      SetBGPushed(wnd.items[i], i == idx)
    end
    if idx ~= 0 then
      local item = wnd.items[idx]
      local viewRow = math.floor((idx + (cols - 1)) / cols)
      local minHeight = (viewRow - 1) * (SELECTION_SIZE + SELECTION_OFFSET)
      local maxHeight = minHeight + SELECTION_SIZE
      local minScroll = scrollWnd.scroll.vs:GetValue()
      local maxScroll = minScroll + scrollWnd:GetHeight()
      if minHeight < minScroll then
        scrollWnd.scroll.vs:SetValue(minHeight, true)
      elseif maxHeight > maxScroll then
        scrollWnd.scroll.vs:SetValue(minScroll + maxHeight - maxScroll, true)
      end
    end
    wnd.selectIdx = idx
  end
  function wnd:Update()
    local count = cols * rows
    local funcs = CUSTOMIZING_FUNCTIONAL_INFO[wnd.cType]
    if funcs ~= nil and funcs.getCountFunc ~= nil then
      count = funcs.getCountFunc()
    end
    if count == nil or count == 0 then
      titleLabel:Show(false)
      resetBtn:Show(false)
      checkBtn:Show(false)
      self:SetHeight(0)
      scrollWnd:Show(false)
      return
    end
    titleLabel:Show(true)
    scrollWnd:Show(true)
    local readRow = rows
    if count < cols * (rows - 1) then
      readRow = math.floor((count + cols - 1) / cols)
    end
    scrollWnd:SetHeight(readRow * (SELECTION_SIZE + SELECTION_OFFSET) - SELECTION_OFFSET + 1)
    scrollWnd:ResetScroll(0)
    scrollWnd:Lock(false)
    for i = 1, math.max(#wnd.items, count) do
      if count < i then
        wnd.items[i]:Show(false)
      else
        if wnd.items[i] == nil then
          local item = CreateSelectionIcon("item", scrollWnd.content, i)
          item:SetExtent(SELECTION_SIZE, SELECTION_SIZE)
          wnd.items[i] = item
          function item:OnClick()
            if funcs ~= nil and funcs.setFunc ~= nil then
              wnd.selectIdx = i
              wnd:UpdateValue()
            end
          end
          item:SetHandler("OnClick", item.OnClick)
        end
        wnd.items[i]:AddAnchor("TOPLEFT", scrollWnd.content, (SELECTION_SIZE + SELECTION_OFFSET) * ((i - 1) % cols), (SELECTION_SIZE + SELECTION_OFFSET) * math.floor((i - 1) / cols))
        wnd.items[i]:Show(true)
        local path = "ui/login_stage/no_image.dds"
        local isNew = false
        if funcs ~= nil and funcs.getInfoFunc ~= nil then
          local itemInfo = funcs:getInfoFunc(i)
          if itemInfo ~= nil then
            if type(itemInfo) == "table" then
              path = GetCustomizingItemIconInfo(wnd.cType, itemInfo.iconPath)
              isNew = itemInfo.new
            else
              path = GetCustomizingItemIconInfo(wnd.cType, itemInfo)
            end
          end
        end
        wnd.items[i]:SetItemInfo(path, isNew)
      end
    end
    local scrollHeight = math.floor((count + cols - 1) / cols) * (SELECTION_SIZE + SELECTION_OFFSET) - SELECTION_OFFSET
    scrollWnd:ResetScroll(scrollHeight)
    scrollWnd:Lock(scrollHeight <= scrollWnd.content:GetHeight())
    local height = 0
    if wnd.info.childs ~= nil then
      for i = 1, #wnd.info.childs do
        local child = GetCustomizingContent(wnd.info.childs[i])
        child:Update()
        if CUSTOMIZING_TYPE_INFO[wnd.info.childs[i]].uiStyle == SLIDER_UI_STYLE then
          height = height + child:GetHeight() + CHILD_OFFSET - 5
        else
          height = height + child:GetHeight() + CHILD_OFFSET
        end
      end
    end
    height = height + titleLabel:GetHeight() + scrollWnd:GetHeight() + 5
    wnd:SetHeight(height)
    wnd.selectIdx = nil
  end
  function wnd:SetCustomizingType(cType)
    local info = CUSTOMIZING_TYPE_INFO[cType]
    wnd.info = info
    wnd.cType = cType
    titleLabel:SetText(info.name)
    if info.uiOption ~= nil then
      if info.uiOption.rows ~= nil then
        rows = info.uiOption.rows
      end
      if info.uiOption.cols ~= nil then
        cols = info.uiOption.cols
      end
      resetBtn:Show(info.uiOption.clear == true)
      checkBtn:Show(info.uiOption.check == true)
    end
    checkBtn:SetChecked(false, true)
    SELECTION_OFFSET = 5
    if cols > 5 then
      SELECTION_OFFSET = 4
    end
    SELECTION_SIZE = math.floor((scrollWnd.content:GetWidth() - SELECTION_OFFSET * (cols - 1)) / cols)
    SELECTION_OFFSET = math.floor((scrollWnd.content:GetWidth() - SELECTION_SIZE * cols) / (cols - 1))
    scrollWnd:SetHeight(rows * (SELECTION_SIZE + SELECTION_OFFSET) - SELECTION_OFFSET)
  end
  return wnd
end
function CreateCustomizingPalletUI(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetWidth(parent:GetWidth())
  local fontSize = FONT_SIZE.LARGE
  local titleLabel = wnd:CreateChildWidget("label", "titleLabel", 0, true)
  titleLabel:SetHeight(fontSize)
  titleLabel:SetAutoResize(true)
  titleLabel:AddAnchor("TOPLEFT", wnd, 0, 0)
  ApplyTextColor(titleLabel, F_COLOR.GetColor("light_gray"))
  titleLabel.style:SetFont(FONT_PATH.DEFAULT, fontSize)
  local pallet = W_PALLECT.CreatePallette("pallette", wnd, "loginStage")
  pallet:AddAnchor("TOPLEFT", titleLabel, "BOTTOMLEFT", 2, 7)
  wnd.pallet = pallet
  function pallet:SetColorProc(r, g, b)
    wnd:UpdateValue()
  end
  function wnd:Update()
    local height = 0
    if wnd.info.childs ~= nil then
      for i = 1, #wnd.info.childs do
        local child = GetCustomizingContent(wnd.info.childs[i])
        child:Update()
        if CUSTOMIZING_TYPE_INFO[wnd.info.childs[i]].uiStyle == SLIDER_UI_STYLE then
          height = height + child:GetHeight() + CHILD_OFFSET - 5
        else
          height = height + child:GetHeight() + CHILD_OFFSET
        end
      end
    end
    height = height + titleLabel:GetHeight() + pallet:GetHeight() + 9
    wnd:SetHeight(height)
  end
  function wnd:SetCustomizingType(cType)
    local info = CUSTOMIZING_TYPE_INFO[cType]
    wnd.info = info
    wnd.cType = cType
    titleLabel:SetText(info.name)
  end
  function wnd:SetEnable(enable)
    wnd:Enable(enable, true)
    pallet:L_SetEnable(enable)
  end
  return wnd
end
function CreateCustomizingSliderUI(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetWidth(parent:GetWidth())
  local fontSize = FONT_SIZE.LARGE
  local offset = 3
  local titleLabel = wnd:CreateChildWidget("label", "titleLabel", 0, true)
  titleLabel:SetHeight(fontSize)
  titleLabel:SetAutoResize(true)
  titleLabel:AddAnchor("TOPLEFT", wnd, 0, 0)
  ApplyTextColor(titleLabel, F_COLOR.GetColor("light_gray"))
  titleLabel.style:SetFont(FONT_PATH.DEFAULT, fontSize)
  local valueLabel = wnd:CreateChildWidget("label", "valueLabel", 0, true)
  valueLabel:SetHeight(fontSize)
  valueLabel:SetAutoResize(true)
  valueLabel:AddAnchor("TOPRIGHT", wnd, 0, 0)
  ApplyTextColor(valueLabel, F_COLOR.GetColor("light_gray"))
  valueLabel.style:SetFont(FONT_PATH.DEFAULT, fontSize)
  valueLabel.style:SetAlign(ALIGN_RIGHT)
  local slider = CreateCusomizingSlider("slider", wnd)
  slider:SetMinMaxValues(0, 100)
  slider:SetInitialValue(100, false)
  slider:AddAnchor("TOPLEFT", titleLabel, "BOTTOMLEFT", 0, offset)
  slider:AddAnchor("TOPRIGHT", valueLabel, "BOTTOMRIGHT", 0, offset)
  function slider:OnSliderChanged(value)
    wnd.weight = math.floor(value)
    valueLabel:SetText(tostring(wnd.weight))
    if wnd.mInfo ~= nil then
      ModifierSetFunc(wnd.mInfo.index, wnd.weight)
    elseif wnd.UpdateValue ~= nil then
      wnd:UpdateValue()
    end
  end
  slider:SetHandler("OnSliderChanged", slider.OnSliderChanged)
  function wnd:SetValue(value)
    if value ~= nil then
      value = math.floor(value)
      slider:SetValue(value, false)
      valueLabel:SetText(tostring(value))
      wnd.weight = value
    end
    wnd:Enable(value ~= nil, true)
    slider:SetEnable(value ~= nil)
  end
  function wnd:Update()
    local height = 0
    if wnd.info ~= nil and wnd.info.childs ~= nil then
      for i = 1, #wnd.info.childs do
        local child = GetCustomizingContent(wnd.info.childs[i])
        child:Update()
        if CUSTOMIZING_TYPE_INFO[wnd.info.childs[i]].uiStyle == SLIDER_UI_STYLE then
          height = height + child:GetHeight() + CHILD_OFFSET - 5
        else
          height = height + child:GetHeight() + CHILD_OFFSET
        end
      end
    end
    height = height + titleLabel:GetHeight() + slider:GetHeight() + offset
    wnd:SetHeight(height)
    if wnd.cType == SCAR_SIZE_TYPE or wnd.cType == SCAR_ROTATE_TYPE then
      wnd:SetValue(50)
    else
      wnd:SetValue(100)
    end
  end
  function wnd:SetCustomizingType(cType)
    local info = CUSTOMIZING_TYPE_INFO[cType]
    wnd.info = info
    wnd.cType = cType
    titleLabel:SetText(info.name)
  end
  function wnd:SetModifierInfo(mInfo)
    wnd.mInfo = nil
    titleLabel:SetText(mInfo.name)
    slider:SetMinMaxValues(mInfo.minValue, mInfo.maxValue)
    wnd.mInfo = mInfo
  end
  return wnd
end
function CreateCustomizingPositionUI(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetWidth(parent:GetWidth())
  wnd.items = {}
  local fontSize = FONT_SIZE.MIDDLE
  local offset = 5
  local titleLabel = wnd:CreateChildWidget("label", "titleLabel", 0, true)
  titleLabel:SetHeight(fontSize)
  titleLabel:SetAutoResize(true)
  titleLabel:AddAnchor("TOPLEFT", wnd, 0, 0)
  ApplyTextColor(titleLabel, F_COLOR.GetColor("light_gray"))
  titleLabel.style:SetFont(FONT_PATH.DEFAULT, fontSize)
  local posWindow = wnd:CreateChildWidget("emptywidget", "posWindow", 0, true)
  posWindow:SetExtent(parent:GetWidth(), 96)
  posWindow:AddAnchor("TOPLEFT", titleLabel, "BOTTOMLEFT", 0, offset)
  local bg = posWindow:CreateDrawable(TEXTURE_PATH.CUSTOMIZING, "tattoo_bg", "background")
  bg:AddAnchor("TOPLEFT", posWindow, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", posWindow, 0, 0)
  local posButton = posWindow:CreateChildWidget("button", "posButton", 0, true)
  posButton:AddAnchor("CENTER", posWindow, 0, 0)
  ApplyButtonSkin(posButton, BUTTON_STYLE.POS_PICKER)
  function posWindow:OnUpdate(dt)
    if self:IsEnabled() == false then
      return
    end
    local mPos = {}
    mPos.x, mPos.y = X2Input:GetMousePos()
    local sOffset = {}
    sOffset.x, sOffset.y = posWindow:GetEffectiveOffset()
    local sExtent = {}
    sExtent.x, sExtent.y = posWindow:GetEffectiveExtent()
    local x = mPos.x - sOffset.x - sExtent.x / 2
    local y = mPos.y - sOffset.y - sExtent.y / 2
    if math.abs(x) > sExtent.x / 2 then
      x = sExtent.x / 2 * x / math.abs(x)
      posWindow:ReleaseHandler("OnUpdate")
    end
    if math.abs(y) > sExtent.y / 2 then
      y = sExtent.y / 2 * y / math.abs(y)
      posWindow:ReleaseHandler("OnUpdate")
    end
    x = F_LAYOUT.CalcDontApplyUIScale(x)
    y = F_LAYOUT.CalcDontApplyUIScale(y)
    posButton:SetPos(x, y)
    wnd:UpdateValue()
  end
  function posButton:SetPos(x, y)
    if x == nil or y == nil then
      x = 0
      y = 0
    end
    posButton:AddAnchor("CENTER", posWindow, x, y)
    wnd.posX = x
    wnd.posY = y
  end
  local function OnMouseDown(self, arg)
    if arg ~= "LeftButton" then
      return
    end
    if posWindow:IsEnabled() then
      posWindow:SetHandler("OnUpdate", posWindow.OnUpdate)
    end
    return true
  end
  posWindow:SetHandler("OnMouseDown", OnMouseDown)
  posButton:SetHandler("OnMouseDown", OnMouseDown)
  local function OnMouseUp(self, arg)
    if arg ~= "LeftButton" then
      return
    end
    if posWindow:IsEnabled() then
      posWindow:ReleaseHandler("OnUpdate")
    end
  end
  posWindow:SetHandler("OnMouseUp", OnMouseUp)
  posButton:SetHandler("OnMouseUp", OnMouseUp)
  function wnd:SetPos(x, y)
    wnd:Enable(x ~= nil and y ~= nil, true)
    posButton:SetPos(x, y)
  end
  function wnd:Update()
    local height = 0
    if wnd.info.childs ~= nil then
      for i = 1, #wnd.info.childs do
        local child = GetCustomizingContent(wnd.info.childs[i])
        child:Update()
        if CUSTOMIZING_TYPE_INFO[wnd.info.childs[i]].uiStyle == SLIDER_UI_STYLE then
          height = height + child:GetHeight() + CHILD_OFFSET - 5
        else
          height = height + child:GetHeight() + CHILD_OFFSET
        end
      end
    end
    height = height + titleLabel:GetHeight() + posWindow:GetHeight() + offset
    wnd:SetHeight(height)
    wnd:SetPos(0, 0)
  end
  function wnd:SetCustomizingType(cType)
    local info = CUSTOMIZING_TYPE_INFO[cType]
    wnd.info = info
    wnd.cType = cType
    titleLabel:SetText(info.name)
  end
  return wnd
end
function CreateCustomizingModifierUI(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetWidth(parent:GetWidth())
  local scrollWnd = CreateCustomizingScrollWnd("scrollWnd", wnd)
  scrollWnd:SetWidth(parent:GetWidth())
  scrollWnd:AddAnchor("TOPLEFT", wnd, "TOPLEFT", 0, 0)
  scrollWnd:Lock(true)
  local modifiers = {}
  function wnd:UpdateModifier()
    for i = 1, #modifiers do
      if modifiers[i].mInfo ~= nil and modifiers[i].mInfo.index ~= nil then
        local value = ModifierGetFunc(modifiers[i].mInfo.index)
        modifiers[i]:SetValue(value)
      end
    end
  end
  function wnd:Update()
    scrollWnd:ResetScroll(0)
    local LAST_WND
    local height = 0
    local count = 0
    local add_offset = 0
    local list = GetModifierList(wnd.cType)
    if list == nil then
      list = {}
    end
    for i = 1, math.max(#list, #modifiers) do
      if modifiers[i] == nil then
        modifiers[i] = CreateCustomizingSliderUI("modifier" .. i, scrollWnd.content)
        modifiers[i]:SetWidth(scrollWnd.content:GetWidth())
      end
      modifiers[i]:Show(false)
      if i <= #list then
        local info = list[i]
        if info.morphStr == nil then
          add_offset = 15
        elseif info.index ~= nil then
          modifiers[i]:SetModifierInfo(info)
          modifiers[i]:Update()
          modifiers[i]:RemoveAllAnchors()
          count = count + 1
          if LAST_WND == nil then
            modifiers[i]:AddAnchor("TOPLEFT", scrollWnd.content, 0, 0)
            height = height + modifiers[i]:GetHeight()
          else
            modifiers[i]:AddAnchor("TOPLEFT", LAST_WND, "BOTTOMLEFT", 0, add_offset)
            height = height + modifiers[i]:GetHeight() + add_offset
            add_offset = 3
          end
          LAST_WND = modifiers[i]
          modifiers[i]:Show(true)
        end
      end
    end
    if #modifiers > 1 then
      scrollWnd:SetHeight(437)
      wnd:SetHeight(scrollWnd:GetHeight())
    else
      scrollWnd:SetHeight(0)
      wnd:SetHeight(0)
    end
    scrollWnd:ResetScroll(height)
    scrollWnd:Lock(height <= scrollWnd.content:GetHeight())
    wnd:UpdateModifier()
  end
  function wnd:SetCustomizingType(cType)
    local info = CUSTOMIZING_TYPE_INFO[cType]
    wnd.info = info
    wnd.cType = cType
  end
  return wnd
end
function CreateCustomizingColorSelectionUI(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetWidth(parent:GetWidth())
  wnd.items = {}
  local fontSize = FONT_SIZE.LARGE
  local titleLabel = wnd:CreateChildWidget("label", "titleLabel", 0, true)
  titleLabel:SetHeight(fontSize)
  titleLabel:SetAutoResize(true)
  titleLabel:AddAnchor("TOPLEFT", wnd, 0, 0)
  ApplyTextColor(titleLabel, F_COLOR.GetColor("light_gray"))
  titleLabel.style:SetFont(FONT_PATH.DEFAULT, fontSize)
  local scrollWnd = CreateCustomizingScrollWnd("scrollWnd", wnd, 0)
  scrollWnd:SetWidth(parent:GetWidth())
  scrollWnd:AddAnchor("TOPLEFT", titleLabel, "BOTTOMLEFT", 0, 10)
  scrollWnd.scroll.vs:SetMinThumbLength(30)
  scrollWnd:Lock(true)
  local cols = 10
  local rows = 2
  local SELECTION_OFFSET, SELECTION_SIZE, colors
  function wnd:Update()
    local COLOR_BTN_SKIN = {
      drawableType = "colorDrawable",
      drawableColor = {
        normal = {
          0,
          0,
          0,
          0.3
        },
        over = {
          0.078431375,
          0.627451,
          0.9411765,
          0.3
        },
        click = {
          0.078431375,
          0.627451,
          0.9411765,
          0.6
        },
        disable = {
          0,
          0,
          0,
          0.3
        }
      },
      width = SELECTION_SIZE,
      height = SELECTION_SIZE
    }
    local count = #colors
    for i = 1, math.max(#wnd.items, count) do
      if count < i then
        wnd.items[i]:Show(false)
      else
        if wnd.items[i] == nil then
          local color = colors[i]
          wnd.items[i] = scrollWnd.content:CreateChildWidget("button", "colorBtn", i, true)
          COLOR_BTN_SKIN.drawableColor.normal = {
            color[1] / 255,
            color[2] / 255,
            color[3] / 255,
            1
          }
          COLOR_BTN_SKIN.drawableColor.over = {
            color[1] / 255,
            color[2] / 255,
            color[3] / 255,
            1
          }
          COLOR_BTN_SKIN.drawableColor.click = {
            color[1] / 255,
            color[2] / 255,
            color[3] / 255,
            1
          }
          COLOR_BTN_SKIN.drawableColor.disable = {
            color[1] / 255,
            color[2] / 255,
            color[3] / 255,
            1
          }
          ApplyButtonSkin(wnd.items[i], COLOR_BTN_SKIN)
        end
        wnd.items[i]:AddAnchor("TOPLEFT", scrollWnd.content, (SELECTION_SIZE + SELECTION_OFFSET) * ((i - 1) % cols), (SELECTION_SIZE + SELECTION_OFFSET) * math.floor((i - 1) / cols))
        wnd.items[i]:Show(true)
      end
    end
    local scrollHeight = math.floor((count + cols - 1) / cols) * (SELECTION_SIZE + SELECTION_OFFSET) - SELECTION_OFFSET
    scrollWnd:ResetScroll(scrollHeight)
    scrollWnd:Lock(scrollHeight <= scrollWnd.content:GetHeight())
    local height = 0
    if wnd.info.childs ~= nil then
      for i = 1, #wnd.info.childs do
        local child = GetCustomizingContent(wnd.info.childs[i])
        child:Update()
        height = height + child:GetHeight() + CHILD_OFFSET
      end
    end
    height = height + titleLabel:GetHeight() + scrollWnd:GetHeight() + 10
    wnd:SetHeight(height)
    wnd:Show(true)
  end
  function wnd:SetCustomizingType(cType)
    local info = CUSTOMIZING_TYPE_INFO[cType]
    wnd.info = info
    wnd.cType = cType
    titleLabel:SetText(info.name)
    if info.uiOption ~= nil then
      if info.uiOption.rows ~= nil then
        rows = info.uiOption.rows
      end
      if info.uiOption.cols ~= nil then
        cols = info.uiOption.cols
      end
      colors = info.uiOption.list
    end
    SELECTION_OFFSET = 3
    SELECTION_SIZE = math.floor(scrollWnd.content:GetWidth() / cols) - SELECTION_OFFSET
    SELECTION_OFFSET = math.floor((scrollWnd.content:GetWidth() - SELECTION_SIZE * cols) / (cols - 1))
    scrollWnd:SetHeight(rows * (SELECTION_SIZE + SELECTION_OFFSET) - SELECTION_OFFSET)
  end
  return wnd
end
function CreateCustomizingSelectionRangeUI(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetWidth(parent:GetWidth())
  local fontSize = FONT_SIZE.LARGE
  local titleLabel = wnd:CreateChildWidget("label", "titleLabel", 0, true)
  titleLabel:SetHeight(fontSize)
  titleLabel:SetAutoResize(true)
  titleLabel:AddAnchor("TOPLEFT", wnd, 0, 0)
  ApplyTextColor(titleLabel, F_COLOR.GetColor("light_gray"))
  titleLabel.style:SetFont(FONT_PATH.DEFAULT, fontSize)
  local tab = W_BTN.CreateTab("tab", wnd, "customizing_pupil_range")
  tab:RemoveAllAnchors()
  tab:SetExtent(parent:GetWidth(), 50)
  tab:AddAnchor("TOPLEFT", titleLabel, "BOTTOMLEFT", 0, 15)
  wnd.range = PR_LEFT
  local bothSelectBtn = wnd:CreateChildWidget("button", "bothSelectBtn", 0, true)
  bothSelectBtn:AddAnchor("TOPRIGHT", tab, 0, 28)
  bothSelectBtn:SetText(GetUIText(COMMON_TEXT, "apply_both"))
  ApplyButtonSkin(bothSelectBtn, BUTTON_STYLE.PLAIN)
  bothSelectBtn:SetHeight(20)
  bothSelectBtn.style:SetFontSize(FONT_SIZE.MIDDLE)
  local function BothSelectBtnLeftClickFunc()
    wnd.value = tab:GetSelectedTab() == 1 and PR_RIGHT or PR_LEFT
    if wnd.info.childs ~= nil then
      for i = 1, #wnd.info.childs do
        local child = GetCustomizingContent(wnd.info.childs[i])
        if child ~= nil then
          child:UpdateValue()
        end
      end
    end
    wnd.value = tab:GetSelectedTab() == 1 and PR_LEFT or PR_RIGHT
  end
  ButtonOnClickHandler(bothSelectBtn, BothSelectBtnLeftClickFunc)
  function OnTabChangedProc(self, selected)
    local range = selected == 1 and PR_LEFT or PR_RIGHT
    wnd.value = range
    wnd:RefreshUI()
  end
  function wnd:Update()
    local useOddEye = false
    local funcs = CUSTOMIZING_FUNCTIONAL_INFO[wnd.cType]
    if funcs ~= nil and funcs.getInfoFunc ~= nil then
      useOddEye = funcs.getInfoFunc()
    end
    self.titleLabel:Show(useOddEye)
    self.bothSelectBtn:Show(useOddEye)
    self.tab:Show(useOddEye)
    if not useOddEye then
      wnd.value = PR_BOTH
    end
    local height = 0
    if wnd.info.childs ~= nil then
      for i = 1, #wnd.info.childs do
        local child = GetCustomizingContent(wnd.info.childs[i])
        child:Update()
        if CUSTOMIZING_TYPE_INFO[wnd.info.childs[i]].uiStyle == PALLET_UI_STYLE then
          height = height + child:GetHeight() + CHILD_OFFSET
        else
          height = height + child:GetHeight() + CHILD_OFFSET
        end
      end
    end
    if useOddEye then
      height = height + titleLabel:GetHeight() + tab:GetHeight()
    end
    self:SetHeight(height)
    self.tab:SelectTab(1)
  end
  function wnd:SetCustomizingType(cType)
    local info = CUSTOMIZING_TYPE_INFO[cType]
    wnd.info = info
    wnd.cType = cType
    self.titleLabel:SetText(info.name)
    self.tab:AddTabs(info.uiOption.tabTexts)
    self.tab.OnTabChangedProc = OnTabChangedProc
  end
  return wnd
end
