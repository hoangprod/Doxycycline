CRAFT_MAX_COUNT = {
  PAGE_PER_HIGH_RANK_ITEM = 5,
  MATERIAL_ITEM = craftingLocale.maxMaterial,
  VIEW_CRAFTABLE = 999
}
CRAFT_SEARCH_CONDITION = {PRODUCT = 1, MATERIAL = 2}
CRAFT_STEP = {
  MAIN = 1,
  SUB = 2,
  DETAIL = 3
}
local CreateStepFrame = function(id, parent)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  frame:SetExtent(150, 20)
  local texturePath = TEXTURE_PATH.CRAFT_POSITION_BUTTON
  local BUTTON_STYLE = {
    {
      drawableType = "drawable",
      path = texturePath,
      coordsKey = "home"
    },
    {
      drawableType = "drawable",
      path = texturePath,
      coordsKey = "category"
    },
    {
      drawableType = "drawable",
      path = texturePath,
      coordsKey = "detail"
    }
  }
  local selectedKeys = {
    "home_selected",
    "category_selected",
    "detail_selected"
  }
  local step = 3
  for i = 1, step do
    local button = frame:CreateChildWidget("button", "stepButton", i, true)
    ApplyButtonSkin(button, BUTTON_STYLE[i])
    local selected = button:CreateDrawable(texturePath, selectedKeys[i], "artwork")
    selected:SetVisible(false)
    selected:AddAnchor("CENTER", button, 0, 0)
    button.selected = selected
  end
  for i = 1, step - 1 do
    local division = frame:CreateChildWidget("label", "division", i, true)
    division:SetExtent(10, 20)
    division:SetText("<")
    ApplyTextColor(division, F_COLOR.GetColor("default"))
  end
  local widgets = {
    frame.stepButton[1],
    frame.division[1],
    frame.stepButton[2],
    frame.division[2],
    frame.stepButton[3]
  }
  local offset = 0
  for i = 1, #widgets do
    widgets[i]:AddAnchor("LEFT", frame, offset, 0)
    offset = offset + widgets[i]:GetWidth()
  end
  local curStep = CRAFT_STEP.MAIN
  function frame:SetStep(step)
    for i = 1, #widgets do
      widgets[i]:Show(false)
    end
    for i = 1, #self.stepButton do
      self.stepButton[i]:Show(i <= step)
      self.stepButton[i].selected:SetVisible(false)
    end
    for i = 1, #self.division do
      self.division[i]:Show(i <= step - 1)
    end
    curStep = step
    self.stepButton[curStep].selected:SetVisible(true)
  end
  function frame:ExceptionByCategory(a, actabilityGroup)
    self.stepButton[2]:Enable(a ~= 0 or actabilityGroup ~= 0)
  end
  function frame:GetStep()
    return curStep
  end
  return frame
end
local CreateSearchFrame = function(id, parent)
  local inset = 5
  local barFrame = parent:CreateChildWidget("emptywidget", id, 0, true)
  barFrame:SetExtent(parent:GetWidth() - MARGIN.WINDOW_SIDE * 2, 35)
  local bg = barFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bg:SetTextureColor("bg_01")
  bg:AddAnchor("TOPLEFT", barFrame, -5, 0)
  bg:AddAnchor("BOTTOMRIGHT", barFrame, 5, 0)
  local categoryACombo = W_CTRL.CreateComboBox("categoryACombo", barFrame)
  categoryACombo:AddAnchor("LEFT", barFrame, inset, 0)
  categoryACombo:SetEllipsis(true)
  categoryACombo:ShowDropdownTooltip(true)
  local actCombo = W_CTRL.CreateComboBox("actCombo", barFrame)
  actCombo:AddAnchor("LEFT", categoryACombo, "RIGHT", inset, 0)
  actCombo:SetEllipsis(true)
  actCombo:ShowDropdownTooltip(true)
  local editbox = W_CTRL.CreateAutocomplete("editbox", barFrame)
  editbox:SetHeight(DEFAULT_SIZE.EDIT_HEIGHT)
  editbox:AddAnchor("LEFT", actCombo, "RIGHT", inset, 0)
  editbox:SetAutocomplete("item", "craftProduct")
  editbox:CreateGuideText(locale.auction.guideText, ALIGN_LEFT, EDITBOX_GUIDE_INSET)
  local searchButton = barFrame:CreateChildWidget("button", "searchButton", 0, true)
  searchButton:SetText(GetUIText(COMMON_TEXT, "search"))
  ApplyButtonSkin(searchButton, BUTTON_BASIC.DEFAULT)
  searchButton:AddAnchor("LEFT", editbox, "RIGHT", 3, 0)
  local resetBtn = barFrame:CreateChildWidget("button", "resetBtn", 0, true)
  ApplyButtonSkin(resetBtn, BUTTON_STYLE.RESET_BIG)
  resetBtn:AddAnchor("LEFT", searchButton, "RIGHT", 0, 0)
  local radioData = {
    {
      text = GetUIText(COMMON_TEXT, "crafting_product"),
      value = 1
    },
    {
      text = GetUIText(AUCTION_TEXT, "item_group_material"),
      value = 2
    }
  }
  local radioWidth, ridioHeight = 0, 0
  local conditionRadio = CreateRadioGroup("conditionRadio", barFrame, "vertical")
  conditionRadio:AddAnchor("LEFT", resetBtn, "RIGHT", 3, 0)
  conditionRadio:SetAutoWidth(true)
  conditionRadio:SetFontSize(FONT_SIZE.SMALL)
  conditionRadio:SetData(radioData)
  conditionRadio:Check(CRAFT_SEARCH_CONDITION.PRODUCT)
  barFrame.conditionRadio = conditionRadio
  radioWidth = conditionRadio:GetWidth()
  local lineLeft, lintRight = CreateLine(barFrame, "TYPE2")
  lineLeft:SetWidth(barFrame:GetWidth() / 2)
  lintRight:SetWidth(barFrame:GetWidth() / 2)
  lineLeft:AddAnchor("BOTTOMLEFT", barFrame, 0, MARGIN.WINDOW_SIDE / 1.5)
  lintRight:AddAnchor("BOTTOMRIGHT", barFrame, 0, MARGIN.WINDOW_SIDE / 1.5)
  local leftWidth = barFrame:GetWidth() - resetBtn:GetWidth() - searchButton:GetWidth() - radioWidth - MARGIN.WINDOW_SIDE * 1.5
  categoryACombo:SetWidth(leftWidth * 0.3)
  actCombo:SetWidth(leftWidth * 0.24)
  editbox:SetWidth(leftWidth * 0.46)
  return barFrame
end
local CreateCategoryAPage = function(id, parent)
  local window = parent:CreateChildWidget("emptywidget", id, 0, true)
  window:SetExtent(parent:GetWidth() - MARGIN.WINDOW_SIDE * 2, parent:GetHeight() * 0.8)
  local CreateSubCategory = function(id, parent)
    local category = parent:CreateChildWidget("label", id, 0, true)
    category:SetHeight(craftingLocale.APage.descFontSzie + 4)
    category:Clickable(false)
    category.style:SetFontSize(craftingLocale.APage.descFontSzie)
    ApplyTextColor(category, F_COLOR.GetColor("default"))
    local bg = category:CreateDrawable(TEXTURE_PATH.CRAFT_TEXT_BOX, "text_box", "background")
    bg:AddAnchor("TOPLEFT", category, -2, -2)
    bg:AddAnchor("BOTTOMRIGHT", category, 2, 1)
    return category
  end
  for i = 1, 9 do
    local button = window:CreateChildWidget("button", "button", i, true)
    local deco = button:CreateImageDrawable(INVALID_ICON_PATH, "artwork")
    deco:AddAnchor("LEFT", button, 0, 0)
    button.deco = deco
    local strFrame = button:CreateChildWidget("emptywidget", "strFrame", 0, true)
    strFrame:Clickable(false)
    local name = button:CreateChildWidget("label", "name", 0, true)
    name:Clickable(false)
    name:AddAnchor("TOP", strFrame, 0, 0)
    name:SetHeight(craftingLocale.APage.titleFontSize)
    name.style:SetFontSize(craftingLocale.APage.titleFontSize)
    ApplyTextColor(name, F_COLOR.GetColor("middle_title"))
    local category1 = CreateSubCategory("category1", button)
    category1:AddAnchor("TOP", name, "BOTTOM", 0, 10)
    local category2 = CreateSubCategory("category2", button)
    category2:AddAnchor("TOP", category1, "BOTTOM", 0, 5)
    local category3 = CreateSubCategory("category3", button)
    category3:AddAnchor("TOP", category2, "BOTTOM", 0, 5)
  end
  function window:Init()
    for i, v in ipairs(self.button) do
      self.button[i]:Show(false)
      self.button[i].category1:Show(false)
      self.button[i].category2:Show(false)
      self.button[i].category3:Show(false)
    end
  end
  local BUTTON_STYLE = {
    EQUIPMENT = {
      drawableType = "drawable",
      path = TEXTURE_PATH.CRAFT_EQUIPMENT_A_CATEGORY,
      coordsKey = "big_btn"
    },
    DEFAULT = {
      drawableType = "drawable",
      path = TEXTURE_PATH.CRAFT_DEFAULT_A_CATEGORY,
      coordsKey = "middle_btn"
    }
  }
  function window:SetButtonStyle(button, isEquipmentCategory)
    if isEquipmentCategory then
      ApplyButtonSkin(button, BUTTON_STYLE.EQUIPMENT)
      local width = button:GetWidth() - 280
      button.name:SetWidth(width)
      button.deco:RemoveAllAnchors()
      button.deco:SetTexture(TEXTURE_PATH.CRAFT_EQUIPMENT_A_CATEGORY)
      button.deco:AddAnchor("RIGHT", button, 0, 0)
      button.category1:SetWidth(width)
      button.category2:SetWidth(width)
      button.category3:SetWidth(width)
      button.strFrame:SetWidth(width)
      button.strFrame:RemoveAllAnchors()
      button.strFrame:AddAnchor("LEFT", button, craftingLocale.APage.equipmentTitleOffset, 0)
    else
      ApplyButtonSkin(button, BUTTON_STYLE.DEFAULT)
      local width = button:GetWidth() - 100
      button.name:SetWidth(width)
      button.deco:RemoveAllAnchors()
      button.deco:SetTexture(TEXTURE_PATH.CRAFT_DEFAULT_A_CATEGORY)
      button.deco:AddAnchor("LEFT", button, 0, 0)
      button.category1:SetWidth(width)
      button.category2:SetWidth(width)
      button.category3:SetWidth(width)
      button.strFrame:SetWidth(width)
      button.strFrame:RemoveAllAnchors()
      button.strFrame:AddAnchor("RIGHT", button, -10, 0)
    end
  end
  return window
end
local CreateCategoryBPage = function(id, parent)
  local window = parent:CreateChildWidget("emptywidget", id, 0, true)
  window:SetExtent(parent:GetWidth() - MARGIN.WINDOW_SIDE * 2, parent:GetHeight() * 0.8)
  local function CreateDefaultPage()
    local defaultPage = window:CreateChildWidget("emptywidget", "defaultPage", 0, true)
    defaultPage:AddAnchor("TOPLEFT", window, 0, 0)
    defaultPage:AddAnchor("BOTTOMRIGHT", window, 0, 0)
    local texturePath = TEXTURE_PATH.CRAFT_2ND_CATEGORY
    local bg = defaultPage:CreateDrawable(texturePath, "bg_img", "background")
    bg:AddAnchor("BOTTOMRIGHT", defaultPage, 0, 0)
    local STYLE = {
      drawableType = "drawable",
      path = texturePath,
      coordsKey = "btn"
    }
    local offsetY = 0
    for i = 1, 10 do
      do
        local button = defaultPage:CreateChildWidget("button", "button", i, true)
        ApplyButtonSkin(button, STYLE)
        local offsetX = i % 2 == 0 and button:GetWidth() + 4 or 0
        button:AddAnchor("TOPLEFT", defaultPage, offsetX, offsetY)
        offsetY = offsetY + (i % 2 == 0 and button:GetHeight() + 4 or 0)
        local textWidth = button:GetWidth() - 20
        local name = button:CreateChildWidget("label", "name", 0, true)
        name:SetExtent(textWidth, craftingLocale.BPage.titleFontSize)
        name:Clickable(false)
        name.style:SetFontSize(FONT_SIZE.XXLARGE)
        ApplyTextColor(name, F_COLOR.GetColor("middle_title"))
        local inset = 10
        local desc = button:CreateChildWidget("textbox", "desc", 0, true)
        desc:SetExtent(textWidth, 50)
        desc:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
        desc:Clickable(false)
        desc:AddAnchor("TOP", name, "BOTTOM", 0, inset)
        desc.style:SetFontSize(craftingLocale.BPage.descFontSzie)
        ApplyTextColor(desc, F_COLOR.GetColor("default"))
        desc:SetAutoResize(true)
        function button:FillData(info)
          self:Show(true)
          self.category = info.type
          self.name:SetText(info.name)
          self.desc:SetText(info.desc)
          self.name:RemoveAllAnchors()
          local offset = self.desc:GetTextLength() > 0 and 0 or -(self.desc:GetHeight() / 2) + -(inset / 2)
          self.name:AddAnchor("CENTER", button, 0, offset)
        end
      end
    end
    function defaultPage:Init()
      for i = 1, #self.button do
        self.button[i]:Show(false)
        self.button[i].category = nil
      end
    end
  end
  local function CreateEquipmentPage()
    local equipmentPage = window:CreateChildWidget("emptywidget", "equipmentPage", 0, true)
    equipmentPage:AddAnchor("TOPLEFT", window, 0, 0)
    equipmentPage:AddAnchor("BOTTOMRIGHT", window, 0, 0)
    local SMALL_EQUIPMENT = {
      drawableType = "drawable",
      path = TEXTURE_PATH.CRAFT_EQUIPMENT_B_CATEGORY,
      coordsKey = "small_btn"
    }
    local deco = equipmentPage:CreateDrawable(TEXTURE_PATH.CRAFT_EQUIPMENT_B_CATEGORY, "char_img", "background")
    deco:AddAnchor("TOP", equipmentPage, 0, 0)
    local guide = equipmentPage:CreateChildWidget("textbox", "guide", 0, true)
    guide:SetExtent(180, FONT_SIZE.MIDDLE)
    guide:SetAutoResize(true)
    guide:SetText(GetUIText(COMMON_TEXT, "select_equipment_to_craft"))
    guide:AddAnchor("BOTTOM", deco, 0, -10)
    guide.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(guide, F_COLOR.GetColor("default"))
    local intervalIndex = {
      5,
      8,
      10,
      17
    }
    local function CheckIntervel(index)
      for i, v in ipairs(intervalIndex) do
        if v == index then
          return true
        end
      end
      return false
    end
    local offsetY = 0
    local categories = X2Craft:GetEquipmentBCateoryInfo()
    for i = 1, #categories do
      local categoryInfo = categories[i]
      local button = equipmentPage:CreateChildWidget("button", "button", i, true)
      button:Show(true)
      ApplyButtonSkin(button, SMALL_EQUIPMENT)
      button.category = categoryInfo.type
      local deco = button:CreateDrawable(TEXTURE_PATH.CRAFT_EQUIPMENT_B_CATEGORY, categoryInfo.deco_key, "background")
      deco:AddAnchor("LEFT", button, 0, 0)
      button.deco = deco
      local name = button:CreateChildWidget("label", "name", 0, true)
      name:SetExtent(100, FONT_SIZE.MIDDLE)
      name:Clickable(false)
      name:AddAnchor("RIGHT", button, -26, 0)
      name.style:SetAlign(ALIGN_LEFT)
      ApplyTextColor(name, F_COLOR.GetColor("middle_title"))
      name:SetText(categoryInfo.name)
      if i >= 10 then
        if i == 10 then
          offsetY = 0
        end
        button:AddAnchor("TOPRIGHT", equipmentPage, 0, offsetY)
      else
        button:AddAnchor("TOPLEFT", equipmentPage, 0, offsetY)
      end
      offsetY = offsetY + button:GetHeight() + 4
      if CheckIntervel(i) then
        offsetY = offsetY + 18
      end
      function button:FillData(enable)
        self:Enable(enable)
      end
    end
    function equipmentPage:Init()
      for i, v in ipairs(self.button) do
        self.button[i]:Enable(false)
      end
    end
  end
  CreateDefaultPage()
  CreateEquipmentPage()
  function window:SetPage(categoryA)
    if X2Craft:IsEquipmnetACategory(categoryA) then
      self.defaultPage:Show(false)
      self.equipmentPage:Init()
      self.equipmentPage:Show(true)
    else
      self.defaultPage:Show(true)
      self.defaultPage:Init()
      self.equipmentPage:Show(false)
    end
  end
  function window:GetCurrentPageButtons(categoryA)
    if X2Craft:IsEquipmnetACategory(categoryA) then
      return self.equipmentPage.button
    else
      return self.defaultPage.button
    end
  end
  return window
end
local CreateDetailPage = function(id, parent)
  local categoryListFontSize = FONT_SIZE.LARGE
  local countListFontSize = FONT_SIZE.MIDDLE
  local categoryListHeight = FONT_SIZE.MIDDLE
  local detailPage = UIParent:CreateWidget("emptywidget", id, parent)
  detailPage:SetExtent(parent:GetWidth() - MARGIN.WINDOW_SIDE * 2, parent:GetHeight() * 0.79)
  local detailRightWidth = craftingLocale.DetailPage.rightSectionWidth
  local function CreateTitle(id, parent, text)
    local title = parent:CreateChildWidget("label", id, 0, true)
    title:AddAnchor("TOPLEFT", parent, 0, 0)
    title:SetExtent(detailRightWidth, FONT_SIZE.LARGE)
    title:SetText(text)
    title.style:SetFontSize(FONT_SIZE.LARGE)
    title.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(title, F_COLOR.GetColor("middle_title"))
    local dingbat = title:CreateDrawable(TEXTURE_PATH.DINGBAT, "dot", "background")
    dingbat:AddAnchor("RIGHT", title, "LEFT", -3, 0)
    return title
  end
  local function CreateCraftStepFrame(id, parent)
    local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
    frame:SetExtent(detailRightWidth, 55)
    local title = CreateTitle("title", frame, GetUIText(COMMON_TEXT, "craft_step"))
    local stepName = frame:CreateChildWidget("label", "stepName", 0, true)
    stepName:SetExtent(detailRightWidth, FONT_SIZE.MIDDLE)
    stepName:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, 5)
    stepName.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(stepName, F_COLOR.GetColor("default"))
    local texturePath = "ui/craft/step_button.dds"
    local STEP = {
      drawableType = "drawable",
      path = texturePath,
      coordsKey = "circle"
    }
    local line = frame:CreateColorDrawable(1, 0, 0, 1, "background")
    line:SetExtent(frame:GetWidth(), 2)
    local offset = 0
    local max = 10
    for i = 1, max do
      local button = frame:CreateChildWidget("button", "button", i, true)
      ApplyButtonSkin(button, STEP)
      button:AddAnchor("BOTTOMLEFT", frame, offset, 0)
      offset = offset + button:GetWidth() + 13
      local selected = button:CreateDrawable(texturePath, "circle_selected", "background")
      selected:SetVisible(false)
      selected:AddAnchor("CENTER", button, 0, 0)
      button.selected = selected
    end
    local warning = frame:CreateChildWidget("textbox", "warning", 0, true)
    warning:Show(false)
    warning:SetExtent(frame:GetWidth(), FONT_SIZE.MIDDLE)
    warning:SetText(GetUIText(COMMON_TEXT, "craft_has_no_step"))
    warning:SetAutoResize(true)
    warning:AddAnchor("CENTER", line, 0, 0)
    ApplyTextColor(warning, F_COLOR.GetColor("red"))
    function frame:Init()
      stepName:SetText("")
      for i = 1, #frame.button do
        frame.button[i]:Show(false)
        frame.button[i].selected:SetVisible(false)
        frame.button[i]:ReleaseHandler("OnEnter")
        frame.button[i].craftType = 0
      end
      line:SetVisible(false)
      warning:Show(false)
    end
    local LINE_COLOR = {
      ENABLE = {
        ConvertColor(83),
        ConvertColor(63),
        ConvertColor(20),
        ConvertColor(255)
      },
      DISABLE = {
        ConvertColor(83),
        ConvertColor(63),
        ConvertColor(20),
        ConvertColor(30)
      }
    }
    local function Disable()
      line:SetVisible(true)
      line:RemoveAllAnchors()
      line:AddAnchor("LEFT", frame.button[1], 0, 0)
      line:AddAnchor("RIGHT", frame.button[#frame.button], 0, 0)
      ApplyTextureColor(line, LINE_COLOR.DISABLE)
      warning:Show(craftingLocale.DetailPage.showNoStepWarning)
      for i = 1, #frame.button do
        frame.button[i]:Show(true)
        frame.button[i]:Enable(false)
      end
    end
    local function SetStep(info, current)
      line:SetVisible(true)
      line:RemoveAllAnchors()
      line:AddAnchor("LEFT", frame.button[1], 0, 0)
      line:AddAnchor("RIGHT", frame.button[#info], 0, 0)
      ApplyTextureColor(line, LINE_COLOR.ENABLE)
      for i, v in ipairs(info) do
        do
          local button = frame.button[i]
          button:Show(true)
          button:Enable(true)
          button.selected:SetVisible(i == current)
          button.craftType = v
          local function OnEnter(self)
            SetTooltip(X2Craft:GetCraftName(v), self)
          end
          button:SetHandler("OnEnter", OnEnter)
        end
      end
    end
    function frame:FillData(info)
      self:Init()
      if info == nil then
        Disable()
        return
      end
      local str = string.format("%s %s", info.name, GetUIText(TOOLTIP_TEXT, "skill_level", tostring(info.currentStep)))
      stepName:SetText(str)
      SetStep(info.component, info.currentStep)
    end
    return frame
  end
  local stepFrame = CreateCraftStepFrame("stepFrame", detailPage)
  stepFrame:AddAnchor("TOPRIGHT", detailPage, 0, 5)
  local function CreateProductInfoFrame(id, parent)
    local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
    frame:SetExtent(detailRightWidth, 75)
    local title = CreateTitle("title", frame, GetUIText(CRAFT_TEXT, "craft_item"))
    local item = CreateItemIconButton("item", frame)
    item:SetExtent(ICON_SIZE.SLAVE, ICON_SIZE.SLAVE)
    item:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, 5)
    frame.item = item
    local name = frame:CreateChildWidget("textbox", "name", 0, true)
    name:SetExtent(frame:GetWidth() - item:GetWidth() - 10, FONT_SIZE.LARGE)
    name:SetAutoResize(true)
    name:AddAnchor("LEFT", item, "RIGHT", 5, 0)
    name.style:SetAlign(ALIGN_LEFT)
    function frame:Init()
      item:Init()
      name:SetText("")
    end
    function frame:FillData(info, stack, nameStr)
      item:SetItemInfo(info)
      item:SetStack(stack)
      name:SetText(nameStr)
      local gradeColor = Hex2Dec(info.gradeColor)
      ApplyTextColor(name, gradeColor)
      name:SetHeight(name:GetTextHeight())
    end
    return frame
  end
  local productInfoFrame = CreateProductInfoFrame("productInfoFrame", detailPage)
  productInfoFrame:AddAnchor("TOPRIGHT", stepFrame, "BOTTOMRIGHT", 0, craftingLocale.DetailPage.productInfoFrameOffset)
  local CreateLabel = function(id, parent, text)
    local label = parent:CreateChildWidget("label", id, 0, true)
    label:SetExtent(parent:GetWidth(), FONT_SIZE.MIDDLE)
    label.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(label, F_COLOR.GetColor("default"))
    label.style:SetEllipsis(true)
    function label:UpdateText(add)
      self:Show(add ~= "")
      self:SetText(string.format("%s: %s", text, add))
    end
    local OnEnter = function(self)
      local str = self:GetText()
      if self.style:GetTextWidth(str) < self:GetWidth() then
        return
      end
      SetTooltip(str, self)
    end
    label:SetHandler("OnEnter", OnEnter)
    return label
  end
  local function CreateConditionFrame(id, parent)
    local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
    frame:SetExtent(detailRightWidth, 70)
    local title = CreateTitle("title", frame, GetUIText(COMMON_TEXT, "require_condition"))
    local doodad = CreateLabel("doodad", frame, GetUIText(CRAFT_TEXT, "require_doodad"))
    doodad:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, 5)
    local actability = CreateLabel("actability", frame, GetUIText(CRAFT_TEXT, "require_mastery"))
    actability:SetExtent(frame:GetWidth(), FONT_SIZE.MIDDLE)
    actability:AddAnchor("TOPLEFT", doodad, "BOTTOMLEFT", 0, 5)
    local textWidth = actability.style:GetTextWidth(GetUIText(CRAFT_TEXT, "require_mastery"))
    local calcWidth = frame:GetWidth() - textWidth - 8
    local offset = textWidth + 6
    local gradeText = CreateLabel("gradeText", frame)
    gradeText:SetExtent(calcWidth, FONT_SIZE.MIDDLE)
    gradeText:AddAnchor("TOPLEFT", actability, "BOTTOMLEFT", offset, 8)
    local icon = gradeText:CreateDrawable(TEXTURE_PATH.CRAFT_GRADE, "grade_11", "background")
    icon:AddAnchor("LEFT", gradeText, 0, 0)
    frame.gradeText.icon = icon
    gradeText:SetInset(icon:GetWidth() + 3, 0, 0, 0)
    local statusBarFrame = W_BAR.CreateStatusBar("statusBar", frame, "craft")
    statusBarFrame:SetWidth(calcWidth)
    statusBarFrame:AddAnchor("TOPLEFT", actability, "BOTTOMLEFT", offset, 5)
    frame.statusBarFrame = statusBarFrame
    local shadowDeco = statusBarFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "gage_shadow", "artwork")
    statusBarFrame.statusBar:AddAnchorChildToBar(shadowDeco, "TOPLEFT", "TOPRIGHT", 0, 0)
    statusBarFrame.shadowDeco = shadowDeco
    local valueStr = statusBarFrame:CreateChildWidget("textbox", "valueStr", 0, true)
    valueStr:SetExtent(statusBarFrame:GetWidth(), statusBarFrame:GetHeight())
    valueStr:AddAnchor("CENTER", statusBarFrame, 0, 0)
    valueStr.style:SetFontSize(FONT_SIZE.SMALL)
    local OnEnter = function(self)
      if self.tip == "" then
        return
      end
      SetTooltip(self.tip, self)
    end
    valueStr:SetHandler("OnEnter", OnEnter)
    gradeText:SetHandler("OnEnter", OnEnter)
    function frame:Init()
      doodad:SetText("")
      actability:SetText("")
      gradeText:Show(false)
      statusBarFrame:Show(false)
      gradeText.tip = ""
      statusBarFrame.valueStr.tip = ""
    end
    function frame:FillData(info)
      if info.doodad_name ~= nil then
        doodad:UpdateText(info.doodad_name)
      end
    end
    return frame
  end
  local conditionFrame = CreateConditionFrame("conditionFrame", detailPage)
  conditionFrame:AddAnchor("TOPRIGHT", productInfoFrame, "BOTTOMRIGHT", 0, 17)
  local function CreateResourcesFrame(id, parent)
    local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
    frame:SetExtent(detailRightWidth, CRAFT_MAX_COUNT.MATERIAL_ITEM > 6 and 167 or 125)
    local title = CreateTitle("title", frame, GetUIText(COMMON_TEXT, "require_resources"))
    local larborPower = CreateLabel("larborPower", frame, 0, true)
    larborPower:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, 5)
    local offsetX = 0
    local offsetY = 5
    frame.items = {}
    for i = 1, CRAFT_MAX_COUNT.MATERIAL_ITEM do
      local item = CreateItemIconButton(string.format("item[%d]", i), frame)
      item:SetExtent(ICON_SIZE.LARGE, ICON_SIZE.LARGE)
      item:AddAnchor("TOPLEFT", larborPower, "BOTTOMLEFT", offsetX, offsetY)
      if i == 6 then
        offsetX = 0
        offsetY = ICON_SIZE.LARGE + 8
      else
        offsetX = offsetX + ICON_SIZE.LARGE + craftingLocale.DetailPage.materialIconOffset
      end
      frame.items[i] = item
    end
    local cost = W_MONEY.CreateTitleMoneyWindow("cost", frame, GetUIText(STABLER_TEXT, "cost"), "horizon")
    cost:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
    local discountIcon = cost:CreateDrawable(TEXTURE_PATH.CRAFT_DISCOUNT, "icon_discount", "background")
    discountIcon:SetVisible(false)
    discountIcon:AddAnchor("RIGHT", cost, "LEFT", -8, 0)
    cost.discountIcon = discountIcon
    local discountText = cost:CreateChildWidget("textbox", "discountText", 0, true)
    discountText:Show(false)
    discountText:SetText(GetUIText(REPAIR_TEXT, "myMoney"))
    discountText:SetHeight(FONT_SIZE.MIDDLE)
    discountText.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(discountText, F_COLOR.GetColor("red"))
    discountText:AddAnchor("RIGHT", discountIcon, "LEFT", -4, 0)
    function frame:Init()
      for j = 1, #frame.items do
        frame.items[j]:Init()
        frame.items[j].itemType = nil
      end
      larborPower:Show(false)
      cost:Show(true)
      cost:Update(0)
    end
    function frame:FillData(money, discount, materialItemInfo)
      local materialSatisfied = true
      cost:Update(money)
      if discount ~= nil and discount > 0 then
        cost.title:Show(false)
        local title = string.format("%d%%", math.floor(discount / 10))
        cost.discountText:SetText(title)
        cost.discountText:SetWidth(cost.discountText.style:GetTextWidth(title) + 2)
        discountText:Show(true)
        discountIcon:SetVisible(true)
      else
        cost.title:Show(true)
        discountText:Show(false)
        discountIcon:SetVisible(false)
      end
      for i, v in ipairs(materialItemInfo) do
        if frame.items[i] ~= nil then
          local item = frame.items[i]
          local info = materialItemInfo[i]
          item:SetItemInfo(info.item_info)
          item:SetStack(info.count, info.amount)
          if info.count < info.amount then
            materialSatisfied = false
          end
        end
      end
      return materialSatisfied
    end
    return frame
  end
  local resourcesFrame = CreateResourcesFrame("resourcesFrame", detailPage)
  resourcesFrame:AddAnchor("TOPRIGHT", conditionFrame, "BOTTOMRIGHT", 0, 20)
  local function CreateButtonFrame(id, parent)
    local frame = parent:CreateChildWidget("window", id, 0, true)
    frame:Show(false)
    frame:SetExtent(detailRightWidth, DEFAULT_SIZE.SPINNER[2])
    local spinner = W_ETC.CreateSpinner("spinner", frame)
    spinner:AddAnchor("LEFT", frame, 0, 0)
    spinner.text.style:SetAlign(ALIGN_CENTER)
    spinner.text:SetInset(0, 0, 12, 0)
    frame.spinner = spinner
    local buttonWidth = 73
    local maxCraftBtn = frame:CreateChildWidget("button", "maxCraftBtn", 0, true)
    maxCraftBtn:SetText(locale.craft.maximum)
    maxCraftBtn:AddAnchor("LEFT", spinner, "RIGHT", 3, 0)
    ApplyButtonSkin(maxCraftBtn, BUTTON_BASIC.DEFAULT)
    maxCraftBtn:SetWidth(buttonWidth)
    local cancelBtn = frame:CreateChildWidget("button", "cancelBtn", 0, true)
    cancelBtn:SetText(locale.craft.cancel)
    cancelBtn:AddAnchor("RIGHT", frame, 0, 0)
    ApplyButtonSkin(cancelBtn, BUTTON_BASIC.DEFAULT)
    local craftBtn = frame:CreateChildWidget("button", "craftBtn", 0, true)
    craftBtn:SetText(GetUIText(WINDOW_TITLE_TEXT, "craft"))
    craftBtn:AddAnchor("RIGHT", cancelBtn, "LEFT", -3, 0)
    ApplyButtonSkin(craftBtn, BUTTON_BASIC.DEFAULT)
    local buttonTable = {cancelBtn, craftBtn}
    AdjustBtnLongestTextWidth(buttonTable, buttonWidth)
    function frame:Init()
      self:EnableFrame(false, false)
    end
    function frame:EnableFrame(enable, cancelable)
      spinner:SetEnable(enable)
      maxCraftBtn:Enable(enable)
      craftBtn:Enable(enable)
      cancelBtn:Enable(cancelable)
    end
    return frame
  end
  local buttonFrame = CreateButtonFrame("buttonFrame", detailPage)
  detailPage.buttonFrame = buttonFrame
  local function CreateCraftOrderFrame(id, parent)
    local frame = parent:CreateChildWidget("window", id, 0, true)
    frame:Show(false)
    frame:SetExtent(detailRightWidth, DEFAULT_SIZE.SPINNER[2])
    local buttonWidth = 73
    local makeOrderBtn = frame:CreateChildWidget("button", "makeOrderBtn", 0, true)
    makeOrderBtn:SetText(GetCommonText("make_craft_order_sheet"))
    makeOrderBtn:AddAnchor("RIGHT", frame, 0, 0)
    ApplyButtonSkin(makeOrderBtn, BUTTON_BASIC.DEFAULT)
    local showBoardBtn = frame:CreateChildWidget("button", "showBoardBtn", 0, true)
    showBoardBtn:SetText(GetCommonText("toggle_craft_order_board"))
    showBoardBtn:AddAnchor("RIGHT", makeOrderBtn, "LEFT", -3, 0)
    ApplyButtonSkin(showBoardBtn, BUTTON_BASIC.DEFAULT)
    local buttonTable = {showBoardBtn, makeOrderBtn}
    AdjustBtnLongestTextWidth(buttonTable, buttonWidth)
    function frame:Init()
      self:EnableFrame(false)
    end
    function frame:EnableFrame(enable)
      makeOrderBtn:Enable(enable)
    end
    return frame
  end
  local craftOrderFrame = CreateCraftOrderFrame("craftOrderFrame", detailPage)
  detailPage.craftOrderFrame = craftOrderFrame
  local leftWidth = detailPage:GetWidth() - detailRightWidth - MARGIN.WINDOW_SIDE / 1.5
  local checkBgHeight = 23
  local categoryList = W_CTRL.CreateScrollListBox("categoryList", detailPage, parent, "TYPE11")
  categoryList:SetExtent(leftWidth, detailPage:GetHeight() - checkBgHeight - 35)
  categoryList:AddAnchor("TOPLEFT", detailPage, 0, checkBgHeight)
  categoryList.content:UseChildStyle(true)
  categoryList.content:EnableSelectParent(false)
  categoryList.content.itemStyle:SetFontSize(FONT_SIZE.LARGE)
  categoryList.content.childStyle:SetFontSize(FONT_SIZE.MIDDLE)
  categoryList.content.itemStyle:SetAlign(ALIGN_LEFT)
  categoryList.content:SetTreeTypeIndent(true, 20, 20)
  categoryList.content:SetHeight(categoryListHeight)
  categoryList.content:ShowTooltip(true)
  categoryList.content:SetSubTextOffset(20, 0, true)
  local color = FONT_COLOR.DEFAULT
  categoryList.content.childStyle:SetColor(color[1], color[2], color[3], color[4])
  categoryList:SetTreeImage()
  local bg = detailPage:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "artwork")
  bg:SetTextureColor("bg_01")
  bg:SetExtent(leftWidth, checkBgHeight)
  bg:AddAnchor("TOPLEFT", detailPage, 0, 0)
  categoryList.bg:RemoveAllAnchors()
  categoryList.bg:AddAnchor("TOPLEFT", detailPage, 0, 0)
  categoryList.bg:AddAnchor("BOTTOMRIGHT", categoryList, 0, 0)
  local craftableCheck = CreateCheckButton("craftableCheck", detailPage, GetUIText(COMMON_TEXT, "show_craftable_list"))
  craftableCheck:AddAnchor("LEFT", bg, 5, 0)
  craftableCheck.textButton:SetWidth(categoryList:GetWidth() - craftableCheck:GetWidth() - 25)
  craftableCheck.textButton:SetAutoResize(false)
  craftableCheck.textButton.style:SetEllipsis(true)
  detailPage.craftableCheck = craftableCheck
  local tip = detailPage:CreateChildWidget("textbox", "tip", 0, true)
  tip:SetExtent(detailPage:GetWidth(), FONT_SIZE.MIDDLE)
  tip:SetAutoResize(true)
  tip.style:SetFontSize(FONT_SIZE.SMALL)
  tip.style:SetAlign(ALIGN_LEFT)
  tip:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  ApplyTextColor(tip, F_COLOR.GetColor("red"))
  tip:SetText(string.format([[
%s
%s%s|r]], GetUIText(CRAFT_TEXT, "material_tip"), F_COLOR.GetColor("gray", true), GetUIText(CRAFT_TEXT, "count_tip")))
  tip:AddAnchor("BOTTOMLEFT", detailPage, 0, 0)
  buttonFrame:AddAnchor("BOTTOMLEFT", categoryList, "BOTTOMRIGHT", 13, 2)
  craftOrderFrame:AddAnchor("BOTTOMLEFT", categoryList, "BOTTOMRIGHT", 13, 2)
  function detailPage:Init()
    stepFrame:Init()
    productInfoFrame:Init()
    conditionFrame:Init()
    resourcesFrame:Init()
    buttonFrame:Init()
    craftOrderFrame:Init()
  end
  return detailPage
end
function SetViewOfCraftingWindow(id, parent)
  local windowWidth = craftingLocale.windowWidth
  local window = CreateWindow(id, parent, "craft_book")
  window:SetTitle(locale.craft.craftBook)
  function window:MakeOriginWindowPos()
    if window == nil then
      return
    end
    window:RemoveAllAnchors()
    window:SetExtent(windowWidth, 630)
    window:AddAnchor("CENTER", "UIParent", 0, 0)
  end
  window:SetExtent(windowWidth, 630)
  window:SetSounds("craft")
  local stepFrame = CreateStepFrame("stetFrame", window)
  window.stepFrame = stepFrame
  local searchBar = CreateSearchFrame("searchBar", window)
  searchBar:AddAnchor("TOP", window, 0, MARGIN.WINDOW_TITLE)
  window.searchBar = searchBar
  stepFrame:AddAnchor("BOTTOMLEFT", searchBar, "TOPLEFT", 5, 0)
  local offset = MARGIN.WINDOW_SIDE * 1.2
  local CategoryAPage = CreateCategoryAPage("CategoryAPage", window)
  CategoryAPage:Show(true)
  CategoryAPage:AddAnchor("TOP", searchBar, "BOTTOM", 0, offset)
  window.CategoryAPage = CategoryAPage
  local CategoryBPage = CreateCategoryBPage("CategoryBPage", window)
  CategoryBPage:AddAnchor("TOP", searchBar, "BOTTOM", 0, offset)
  CategoryBPage:Show(false)
  window.CategoryBPage = CategoryBPage
  local detailPage = CreateDetailPage("detailPage", window)
  detailPage:Show(false)
  detailPage:AddAnchor("TOP", searchBar, "BOTTOM", 0, offset)
  window.detailPage = detailPage
  return window
end
