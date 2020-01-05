function CreateCraftingWindow(id, parent)
  local window = SetViewOfCraftingWindow(id, parent)
  local CategoryAPage = window.CategoryAPage
  local CategoryBPage = window.CategoryBPage
  local detailPage = window.detailPage
  local stepFrame = window.stepFrame
  local searchBar = window.searchBar
  local productInfoFrame = detailPage.productInfoFrame
  local materialFrame = detailPage.materialFrame
  local categoryList = detailPage.categoryList
  local buttonFrame = detailPage.buttonFrame
  local craftOrderFrame = detailPage.craftOrderFrame
  local ALL_CATEGORY = 1
  local selACategoryIdx = 0
  local selActAbilityGroupIdx = 0
  local searchKeyword = ""
  local VIEW_CRAFTABLE = 999
  local craftSet = {}
  local filter = {
    a = 0,
    b = 0,
    c = 0,
    d = 0,
    craft = 0,
    actabilityGroup = 0,
    requireActabilityGroup = 0,
    condition = 0,
    entryBySearch = 0
  }
  local function SetFilter(key, value)
    filter[key] = value
  end
  local function GetFilter(key)
    return filter[key]
  end
  local function ClearFilter()
    for k, v in pairs(filter) do
      filter[k] = 0
    end
  end
  local function FillStepFrame(step)
    stepFrame:SetStep(step)
    stepFrame:ExceptionByCategory(GetFilter("a"), GetFilter("actabilityGroup"))
  end
  local function PageChange(visibleTarget)
    local targets = {
      CategoryAPage,
      CategoryBPage,
      detailPage
    }
    for i = 1, #targets do
      if targets[i] == visibleTarget then
        targets[i]:Show(true)
        FillStepFrame(i)
      else
        targets[i]:Show(false)
      end
    end
  end
  local function FillCategoriesUpdate()
    local infos = categoryList.content:GetViewItemsInfo()
    for i = 1, #infos do
      local value = infos[i].value
      local datas = {
        indexing = infos[i].indexing,
        subtext = ""
      }
      if value ~= 0 then
        local info = X2Craft:GetCraftBaseInfo(value)
        local color = info.actability_satisfied and F_COLOR.GetColor("default") or F_COLOR.GetColor("gray")
        local color2 = info.actability_satisfied and F_COLOR.GetColor("blue") or F_COLOR.GetColor("gray")
        datas.subColor = color
        datas.defaultColor = color
        datas.overColor = color2
        datas.selectColor = color2
        local craftCount = X2Craft:GetExecutableCraftCount(value)
        if craftCount > VIEW_CRAFTABLE then
          datas.subtext = string.format("(%d)", VIEW_CRAFTABLE)
        elseif craftCount > 0 then
          datas.subtext = string.format("(%d)", craftCount)
        end
      end
      categoryList.content:UpdateItem(datas)
    end
  end
  local function FillDetailPageList(categoryA, categoryB)
    categoryList:ClearItem()
    local list = X2Craft:GetList(categoryA, categoryB, detailPage.craftableCheck:GetChecked())
    if list == nil or #list == 0 then
      AddMessageToSysMsgWindow(GetUIText(COMMON_TEXT, "crafting_search_empty_result"))
      return
    end
    SetFilter("entryBySearch", 0)
    SetFilter("b", categoryB)
    SetFilter("condition", searchBar.conditionRadio:GetChecked())
    PageChange(detailPage)
    detailPage:Init()
    local blueColor = F_COLOR.GetColor("blue")
    local listboxInfo = {}
    for depth1, valueC in ipairs(list) do
      listboxInfo[depth1] = {}
      listboxInfo[depth1].text = valueC.CCategoryName
      listboxInfo[depth1].opened = true
      if valueC.crafts ~= nil then
        listboxInfo[depth1].child = {}
        for depth2, craftInfo in ipairs(valueC.crafts) do
          listboxInfo[depth1].child[depth2] = {}
          listboxInfo[depth1].child[depth2].text = craftInfo.name
          listboxInfo[depth1].child[depth2].value = craftInfo.type
          listboxInfo[depth1].child[depth2].useColor = true
          listboxInfo[depth1].child[depth2].defaultColor = FONT_COLOR.DEFAULT
          listboxInfo[depth1].child[depth2].selectColor = blueColor
          listboxInfo[depth1].child[depth2].overColor = blueColor
          listboxInfo[depth1].child[depth2].subtext = ""
          listboxInfo[depth1].child[depth2].subColor = FONT_COLOR.DEFAULT
        end
      else
        listboxInfo[depth1].child = {}
        for depth2, valueD in ipairs(valueC) do
          listboxInfo[depth1].child[depth2] = {}
          listboxInfo[depth1].child[depth2].text = valueD.DCategoryName
          if valueD.crafts ~= nil then
            listboxInfo[depth1].child[depth2].child = {}
            for depth3, craftInfo in ipairs(valueD.crafts) do
              listboxInfo[depth1].child[depth2].child[depth3] = {}
              listboxInfo[depth1].child[depth2].child[depth3].text = craftInfo.name
              listboxInfo[depth1].child[depth2].child[depth3].value = craftInfo.type
              listboxInfo[depth1].child[depth2].child[depth3].useColor = true
              listboxInfo[depth1].child[depth2].child[depth3].defaultColor = FONT_COLOR.DEFAULT
              listboxInfo[depth1].child[depth2].child[depth3].selectColor = blueColor
              listboxInfo[depth1].child[depth2].child[depth3].overColor = blueColor
              listboxInfo[depth1].child[depth2].child[depth3].subtext = ""
              listboxInfo[depth1].child[depth2].child[depth3].subColor = FONT_COLOR.DEFAULT
            end
          end
        end
      end
    end
    categoryList:SetItemTrees(listboxInfo)
    FillCategoriesUpdate()
  end
  local function FillList(list, lastDepthOpen)
    local blueColor = F_COLOR.GetColor("blue")
    for depth1, valueA in ipairs(list) do
      list[depth1].opened = true
      for depth2, valueB in pairs(valueA.child) do
        list[depth1].child[depth2].opened = true
        for depth3, valueC in pairs(valueB.child) do
          list[depth1].child[depth2].child[depth3].opened = true
          for depth4, valueD in pairs(valueC.child) do
            list[depth1].child[depth2].child[depth3].child[depth4].opened = lastDepthOpen
            if valueD.child ~= nil then
              for depth5, craftInfo in pairs(valueD.child) do
                list[depth1].child[depth2].child[depth3].child[depth4].child[depth5].useColor = true
                list[depth1].child[depth2].child[depth3].child[depth4].child[depth5].defaultColor = FONT_COLOR.DEFAULT
                list[depth1].child[depth2].child[depth3].child[depth4].child[depth5].selectColor = blueColor
                list[depth1].child[depth2].child[depth3].child[depth4].child[depth5].overColor = blueColor
                list[depth1].child[depth2].child[depth3].child[depth4].child[depth5].subtext = ""
                list[depth1].child[depth2].child[depth3].child[depth4].child[depth5].subColor = FONT_COLOR.DEFAULT
              end
            else
              list[depth1].child[depth2].child[depth3].child[depth4].useColor = true
              list[depth1].child[depth2].child[depth3].child[depth4].defaultColor = FONT_COLOR.DEFAULT
              list[depth1].child[depth2].child[depth3].child[depth4].selectColor = blueColor
              list[depth1].child[depth2].child[depth3].child[depth4].overColor = blueColor
              list[depth1].child[depth2].child[depth3].child[depth4].subtext = ""
              list[depth1].child[depth2].child[depth3].child[depth4].subColor = FONT_COLOR.DEFAULT
            end
          end
        end
      end
    end
    categoryList:SetItemTrees(list)
  end
  local function FillDetailPageByItemType(itemType, craftType)
    categoryList:ClearItem()
    local list = X2Craft:GetListByItemType(itemType)
    if list == nil then
      return
    end
    PageChange(detailPage)
    detailPage:Init()
    FillList(list, true)
    FillCategoriesUpdate()
    categoryList.content:SelectWithValue(craftType)
  end
  local function FillDetailPageListBySearching(categoryA, actabilityGroup, keyword)
    categoryList:ClearItem()
    local list = X2Craft:GetListBySearching(categoryA, actabilityGroup, GetFilter("condition") == CRAFT_SEARCH_CONDITION.PRODUCT and true or false, detailPage.craftableCheck:GetChecked(), keyword)
    if list == nil or #list == 0 then
      AddMessageToSysMsgWindow(GetUIText(COMMON_TEXT, "crafting_search_empty_result"))
      return
    end
    PageChange(detailPage)
    detailPage:Init()
    FillList(list, keyword ~= "" and true or false)
    FillCategoriesUpdate()
  end
  local FillCombobox = function(target, data)
    local dropdowns = {}
    local firstData = {
      text = GetUIText(INVEN_TEXT, "allTab"),
      value = 0,
      color = FONT_COLOR.DEFAULT,
      disableColor = FONT_COLOR.GRAY,
      useColor = true,
      enable = true
    }
    table.insert(dropdowns, firstData)
    for i = 1, #data do
      local item = {
        text = data[i].name,
        value = data[i].type
      }
      table.insert(dropdowns, item)
    end
    target:AppendItems(dropdowns)
    target:SetVisibleItemCount(10)
  end
  local function FillSearchBar()
    searchBar.conditionRadio:Check(CRAFT_SEARCH_CONDITION.PRODUCT, true)
    FillCombobox(searchBar.categoryACombo, X2Craft:GetACategories())
    FillCombobox(searchBar.actCombo, X2Craft:GetActabilityGroup())
  end
  local function ResetCombobox()
    searchBar.categoryACombo:Select(ALL_CATEGORY)
    searchBar.actCombo:Select(ALL_CATEGORY)
  end
  function searchBar.categoryACombo:SelectedProc(selIndex)
    local info = self:GetSelectedInfo()
    if info == nil then
      return
    end
    selACategoryIdx = info.value
  end
  function searchBar.actCombo:SelectedProc(selIndex)
    local info = self:GetSelectedInfo()
    if info == nil then
      return
    end
    selActAbilityGroupIdx = info.value
  end
  local FindType = function(comboboxWidget, realValue)
    return comboboxWidget:GetIndexByValue(realValue)
  end
  local function UpdateDetailPageList()
    if not detailPage:IsVisible() then
      return
    end
    local a = GetFilter("a")
    local b = GetFilter("b")
    local entryBySearch = GetFilter("entryBySearch")
    local actGroup = GetFilter("actabilityGroup")
    if entryBySearch == 1 then
      FillDetailPageListBySearching(a, actGroup, searchKeyword)
    else
      FillDetailPageList(a, b)
    end
  end
  function detailPage.craftableCheck:CheckBtnCheckChagnedProc()
    UpdateDetailPageList()
  end
  local function FillCategoryBPage(categoryA)
    SetFilter("a", categoryA)
    PageChange(CategoryBPage)
    CategoryBPage:SetPage(categoryA)
    searchBar.categoryACombo:Select(FindType(searchBar.categoryACombo, categoryA))
    local buttons = CategoryBPage:GetCurrentPageButtons(categoryA)
    if X2Craft:IsEquipmnetACategory(categoryA) then
      local enableCount = 0
      for k = 1, #buttons do
        do
          local button = buttons[k]
          button:FillData(X2Craft:GetList(categoryA, button.category, detailPage.craftableCheck:GetChecked()) ~= nil)
          if button:IsEnabled() then
            enableCount = enableCount + 1
          end
          local function OnLeftClickFunc()
            FillDetailPageList(categoryA, button.category)
          end
          ButtonOnClickHandler(button, OnLeftClickFunc)
        end
      end
      if enableCount == 0 then
        return
      end
    else
      local categories = X2Craft:GetBCategories(categoryA)
      if categories == nil then
        return
      end
      for k = 1, #categories do
        do
          local info = categories[k]
          local button = buttons[k]
          button:FillData(info, X2Craft:GetList(categoryA, info.type, detailPage.craftableCheck:GetChecked()) ~= nil)
          local function OnLeftClickFunc()
            FillDetailPageList(categoryA, button.category)
          end
          ButtonOnClickHandler(button, OnLeftClickFunc)
        end
      end
    end
  end
  local function FillCategoryAPage()
    local categories = X2Craft:GetACategories()
    if categories == nil then
      return
    end
    PageChange(CategoryAPage)
    CategoryAPage:Init()
    local target
    local inset = 4
    local offsetX = 0
    local offsetY = 0
    local foundEquipment = false
    for i, v in ipairs(categories) do
      do
        local button = CategoryAPage.button[i]
        button:Show(true)
        button.name:SetText(v.name)
        button.category = v.type
        local function OnLeftClickFunc()
          FillCategoryBPage(button.category)
        end
        ButtonOnClickHandler(button, OnLeftClickFunc)
        local width, strOffset = 0, 0
        local anchor = "RIGHT"
        if X2Craft:IsEquipmnetACategory(v.type) then
          CategoryAPage:SetButtonStyle(button, true)
          button:RemoveAllAnchors()
          button:AddAnchor("TOPLEFT", CategoryAPage, offsetX, offsetY)
          offsetX = 0
          offsetY = button:GetHeight() + inset
          foundEquipment = true
        else
          CategoryAPage:SetButtonStyle(button, false)
          button:RemoveAllAnchors()
          button:AddAnchor("TOPLEFT", CategoryAPage, offsetX, offsetY)
          if foundEquipment then
            offsetX = i % 2 ~= 0 and 0 or button:GetWidth() + inset
            offsetY = offsetY + (i % 2 ~= 0 and button:GetHeight() + inset or 0)
          else
            offsetX = i % 2 == 0 and 0 or button:GetWidth() + inset
            offsetY = offsetY + (i % 2 == 0 and button:GetHeight() + inset or 0)
          end
        end
        button.deco:SetTextureInfo(v.deco_key)
        local combining = ""
        local str = {}
        local target = {
          button.category1,
          button.category2,
          button.category3
        }
        for i2, v2 in ipairs(v.child) do
          if combining ~= "" then
            local temp = string.format("%s\194\183%s", combining, v2)
            if target[1].style:GetTextWidth(temp) >= target[1]:GetWidth() then
              str[#str + 1] = combining
              combining = v2
            else
              combining = temp
            end
          else
            combining = v2
          end
        end
        if combining ~= "" then
          if #str >= #target then
            str[#str] = string.format("%s%s", str[#str], combining)
          else
            str[#str + 1] = combining
          end
        end
        local extentTarget
        for i, v in ipairs(str) do
          target[i]:Show(true)
          target[i]:SetText(v)
          extentTarget = target[i]
        end
        local height = button.name:GetHeight()
        if extentTarget ~= nil then
          _, height = F_LAYOUT.GetExtentWidgets(button.name, extentTarget)
        end
        button.strFrame:SetHeight(height)
      end
    end
  end
  local function LeftClickFunc()
    ClearFilter()
    PageChange(CategoryAPage)
    ResetCombobox()
    searchBar.editbox:Reset()
    searchKeyword = ""
  end
  ButtonOnClickHandler(stepFrame.stepButton[1], LeftClickFunc)
  local function LeftClickFunc()
    FillCategoryBPage(GetFilter("a"))
  end
  ButtonOnClickHandler(stepFrame.stepButton[2], LeftClickFunc)
  local function FillCraftButtonFrame(craftType)
    if X2Craft:GetInteratcionTargetId() == 0 then
      buttonFrame:Show(false)
      craftOrderFrame:Show(true)
      return
    end
    craftOrderFrame:Show(false)
    buttonFrame:Show(true)
    local count = X2Craft:GetLeftBatchCount()
    if count > 0 then
      buttonFrame.spinner:SetMinMaxValues(0, math.min(count, VIEW_CRAFTABLE))
      buttonFrame.spinner:SetValue(tostring(count))
      return
    end
    count = 0
    if craftType ~= nil and craftType > 0 then
      count = X2Craft:GetExecutableCraftCount(craftType)
      buttonFrame.spinner:SetMinMaxValues(0, math.min(count, VIEW_CRAFTABLE))
      if count > 0 then
        count = 1
      else
        count = 0
      end
    end
    buttonFrame.spinner:SetValue(tostring(count))
  end
  function window:Init()
    FillStepFrame(CRAFT_STEP.MAIN)
    FillSearchBar()
    FillCategoryAPage()
    FillCraftButtonFrame()
    SetFilter("condition", CRAFT_SEARCH_CONDITION.PRODUCT)
    detailPage.craftableCheck:SetChecked(false)
  end
  function categoryList:ProcOnListboxToggled()
    FillCategoriesUpdate()
  end
  function categoryList:ProcSliderChanged()
    FillCategoriesUpdate()
  end
  local function SearchFunc(self, isDoodadInteraction)
    local temp = string.gsub(searchBar.editbox.selector:GetText(), "%s", "")
    if isDoodadInteraction ~= true and selACategoryIdx == 0 and selActAbilityGroupIdx == 0 and temp == "" then
      AddMessageToSysMsgWindow(GetUIText(COMMON_TEXT, "fail_to_craft_search"))
      return
    end
    searchKeyword = searchBar.editbox.selector:GetText()
    SetFilter("a", selACategoryIdx)
    SetFilter("actabilityGroup", selActAbilityGroupIdx)
    SetFilter("condition", searchBar.conditionRadio:GetChecked())
    SetFilter("entryBySearch", 1)
    FillDetailPageListBySearching(selACategoryIdx, selActAbilityGroupIdx, searchKeyword)
    searchBar.editbox:HideDropdown()
  end
  searchBar.editbox.selector:SetHandler("OnEnterPressed", SearchFunc)
  searchBar.searchButton:SetHandler("OnClick", SearchFunc)
  function window:ExternalSearch(itemType)
    SetItemLinkCraftFrame(X2Item:Name(itemType))
    ToggleRecipeBook(true)
    local craftType = X2Craft:GetCraftTypeByItemType(itemType)
    if craftType == nil then
      AddMessageToSysMsgWindow(GetUIText(COMMON_TEXT, "crafting_search_empty_result"))
      return
    end
    FillDetailPageByItemType(itemType, craftType)
  end
  function FillRequireActability(frame, info)
    SetFilter("requireActabilityGroup", info.required_actability_type)
    frame.statusBarFrame:Show(false)
    frame.gradeText:Show(false)
    frame.statusBarFrame.valueStr.tip = ""
    if info.required_actability_point == nil or info.required_actability_point <= 0 then
      return
    end
    local myAcInfo = X2Ability:GetMyActabilityInfo(info.required_actability_type)
    if myAcInfo == nil then
      return
    end
    frame.actability:UpdateText(info.required_actability_name)
    ApplyTextColor(frame.actability, info.actability_satisfied and F_COLOR.GetColor("default") or F_COLOR.GetColor("red"))
    if info.use_only_actability then
      local key = info.actability_satisfied and "grade_11" or "grade_11_dis"
      frame.gradeText:Show(true)
      frame.gradeText.icon:SetTextureInfo(key)
      local strKey = info.actability_satisfied and "actabilty_grade_satisfied" or "actabilty_grade_unsatisfied"
      frame.gradeText:SetText(GetUIText(COMMON_TEXT, strKey))
      ApplyTextColor(frame.gradeText, info.actability_satisfied and F_COLOR.GetColor("green") or F_COLOR.GetColor("red"))
      frame.gradeText.tip = string.format("|,%d;/|,%d;", myAcInfo.point, info.required_actability_point)
    else
      local colorKey = info.actability_satisfied and "grade_craft_possible" or "grade_craft_impossible"
      local color = GetTextureInfo(TEXTURE_PATH.COMMON_GAUGE, "gage"):GetColors()[colorKey]
      frame.statusBarFrame:Show(true)
      frame.statusBarFrame:SetBarColor(color)
      local cur = myAcInfo.point + myAcInfo.modifyPoint
      local max = info.required_actability_point
      frame.statusBarFrame:SetMinMaxValues(0, max)
      frame.statusBarFrame:SetValue(cur)
      frame.statusBarFrame.valueStr:SetText(string.format("|,%d;/|,%d;", cur, max))
      local visible = cur > 0 and cur < max
      frame.statusBarFrame.shadowDeco:SetVisible(visible)
      if myAcInfo.modifyPoint ~= 0 then
        frame.statusBarFrame.valueStr.tip = string.format("|,%d;+%s|,%d;|r/|,%d;", myAcInfo.point, FONT_COLOR_HEX.SINERGY, myAcInfo.modifyPoint, info.required_actability_point)
      else
        frame.statusBarFrame.valueStr.tip = string.format("|,%d;/|,%d;", myAcInfo.point, info.required_actability_point)
      end
    end
  end
  local function FillCraftActability(info)
    local cur = GetFilter("craft")
    if cur == 0 then
      return
    end
    if info == nil then
      info = X2Craft:GetCraftBaseInfo(cur)
    end
    FillRequireActability(detailPage.conditionFrame, info)
  end
  function FillRequireLaborPower(widget, info)
    local needed = info.needed_lp == nil and 0 or info.needed_lp
    if info.laborpower_satisfied then
      if info.consume_lp > info.needed_lp then
        ApplyTextColor(widget, F_COLOR.GetColor("green"))
      else
        ApplyTextColor(widget, F_COLOR.GetColor("default"))
      end
    else
      ApplyTextColor(widget, F_COLOR.GetColor("red"))
    end
    local laborPowerStr = string.format("%s%d", GetUIText(CRAFT_TEXT, "require_labor_power"), needed)
    widget:Show(true)
    widget:SetText(laborPowerStr)
  end
  local function FillCraftRequireLaborPower(info)
    local cur = GetFilter("craft")
    if cur == 0 then
      return
    end
    if info == nil then
      info = X2Craft:GetCraftBaseInfo(cur)
    end
    FillRequireLaborPower(detailPage.resourcesFrame.larborPower, info)
  end
  local function EnableCraftButtonFrame(enable, cancelable)
    buttonFrame:EnableFrame(enable, cancelable)
  end
  local ToggleCraftOrderBoard = function()
    ToggleCraftOrderBoardWnd(true)
  end
  ButtonOnClickHandler(craftOrderFrame.showBoardBtn, ToggleCraftOrderBoard)
  local function MakeOrder()
    local curCraftType = GetFilter("craft")
    if curCraftType ~= nil then
      ToggleMakeOrder(curCraftType)
    end
  end
  ButtonOnClickHandler(craftOrderFrame.makeOrderBtn, MakeOrder)
  local function EnableCraftOrderFrame(enable)
    craftOrderFrame:EnableFrame(enable)
  end
  local function FillStepInfo(stepInfo)
    detailPage.stepFrame:FillData(stepInfo)
  end
  local function FillProductInfo(baseInfo, productInfo, materialInfo)
    if productInfo == nil or #productInfo == 0 then
      return
    end
    local pInfo = productInfo[1]
    local itemInfo = X2Item:GetItemInfoByType(pInfo.itemType, NORMAL_ITEM_GRADE, IIK_IMPL)
    local itemGrade = NORMAL_ITEM_GRADE
    if not pInfo.useGrade then
      for i, v in ipairs(materialInfo) do
        if v.mainGrade then
          itemGrade = v.item_info.itemGrade
          break
        elseif v.item_info.item_impl == itemInfo.item_impl and itemGrade < v.item_info.itemGrade then
          itemGrade = v.item_info.itemGrade
        end
      end
    else
      itemGrade = pInfo.productGrade
    end
    itemInfo = X2Item:GetItemInfoByType(pInfo.itemType, itemGrade)
    itemInfo.recommend_level = baseInfo.recommend_level
    local nameStr = ""
    local stack = 0
    if itemInfo.slotType == "backpack" and itemInfo.category ~= GetUIText(AUCTION_TEXT, "item_category_glider") and itemInfo.category ~= GetCommonText("item_category_wing") then
      nameStr = string.format("[%s] %s", locale.common.equipSlotType.backpack, pInfo.item_name)
    elseif 1 < pInfo.amount then
      nameStr = string.format("[%s] %s", locale.common.GetAmount(pInfo.amount), pInfo.item_name)
      stack = pInfo.amount
    else
      nameStr = pInfo.item_name
    end
    detailPage.productInfoFrame:FillData(itemInfo, stack, nameStr)
  end
  local function FillRequireConditionInfo(baseInfo)
    detailPage.conditionFrame:FillData(baseInfo)
    FillCraftActability(baseInfo)
  end
  local function FillResourcesInfo(baseInfo, materialInfo)
    local materialSatisfied = true
    local money = 0
    local discount = 0
    local materialItemInfo = {}
    for i = 1, #materialInfo do
      local mInfo = materialInfo[i]
      if mInfo.item_info.itemType == MONEY_ITEM_TYPE then
        money = mInfo.amount
        discount = mInfo.discount
      else
        materialItemInfo[#materialItemInfo + 1] = mInfo
      end
    end
    FillCraftRequireLaborPower(baseInfo)
    detailPage.resourcesFrame:FillData(money, discount, materialItemInfo)
  end
  local GetEnableCraftButtonFrame = function(baseInfo, craftType)
    return X2Craft:GetExecutableCraftCount(craftType) > 0 and not X2Craft:IsWorkingCraft() and baseInfo.actability_satisfied and baseInfo.laborpower_satisfied
  end
  local function FillDetailPage(craftType)
    SetFilter("craft", craftType)
    detailPage:Init()
    local baseInfo = X2Craft:GetCraftBaseInfo(craftType)
    local materialInfo = X2Craft:GetCraftMaterialInfo(craftType, X2Craft:GetInteratcionTargetId())
    FillStepInfo(X2Craft:GetCraftStepInfo(craftType))
    FillProductInfo(baseInfo, X2Craft:GetCraftProductInfo(craftType), materialInfo)
    FillRequireConditionInfo(baseInfo)
    FillResourcesInfo(baseInfo, materialInfo)
    FillCraftButtonFrame(craftType)
    EnableCraftButtonFrame(GetEnableCraftButtonFrame(baseInfo, craftType), X2Craft:IsWorkingCraft())
    EnableCraftOrderFrame(baseInfo.orderable and not X2Craft:IsWorkingCraft())
  end
  local function LinkCraftDetailPage()
    for i, v in ipairs(detailPage.stepFrame.button) do
      do
        local function OnClick()
          if v.craftType == 0 then
            return
          end
          FillDetailPage(v.craftType)
        end
        ButtonOnClickHandler(v, OnClick)
      end
    end
    for i, v in ipairs(detailPage.resourcesFrame.items) do
      function v:OnClickProc(arg)
        if arg ~= "LeftButton" then
          return
        end
        if v.info == nil then
          return
        end
        local craftType = X2Craft:GetCraftTypeByItemType(v.info.itemType)
        if craftType == nil then
          return
        end
        FillDetailPage(craftType)
      end
    end
  end
  LinkCraftDetailPage()
  local function FillSpinner(self, count)
    local curCraftType = GetFilter("craft")
    if curCraftType == 0 then
      return
    end
    if count == nil then
      count = X2Craft:GetExecutableCraftCount(curCraftType)
    end
    buttonFrame.spinner:SetMinMaxValues(0, math.min(count, VIEW_CRAFTABLE))
    buttonFrame.spinner:SetValue(tostring(count))
  end
  ButtonOnClickHandler(buttonFrame.maxCraftBtn, FillSpinner)
  local function CraftBtnLeftClickFunc()
    local curCraftType = GetFilter("craft")
    if curCraftType == 0 then
      return
    end
    local doodadId = X2Craft:GetInteratcionTargetId()
    local count = tonumber(buttonFrame.spinner:GetCurValue())
    local playerLevel = X2Unit:UnitLevel("player") + X2Unit:UnitHeirLevel("player")
    local productItemInfo = productInfoFrame.item.info
    local recommendLevel = productItemInfo.recommend_level
    if recommendLevel == nil then
      X2Craft:ExecuteBatchCraftByType(curCraftType, doodadId, count)
    elseif playerLevel < recommendLevel then
      local function DialogHandler(wnd)
        wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "warning_craft_title"))
        wnd:UpdateDialogModule("textbox", GetUIText(MSG_BOX_TITLE_TEXT, "warning_craft_body"))
        local itemData = {itemInfo = productItemInfo, stack = 1}
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
        local textData = {
          type = "warning",
          text = GetUIText(CRAFT_TEXT, "warning_recomment_level")
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
        function wnd:OkProc()
          X2Craft:ExecuteBatchCraftByType(curCraftType, doodadId, count)
        end
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetId())
    else
      X2Craft:ExecuteBatchCraftByType(curCraftType, doodadId, count)
    end
  end
  ButtonOnClickHandler(buttonFrame.craftBtn, CraftBtnLeftClickFunc)
  local CraftCancelBtnLeftClickFunc = function()
    X2Craft:StopBatchCrafting()
  end
  ButtonOnClickHandler(buttonFrame.cancelBtn, CraftCancelBtnLeftClickFunc)
  local function ResetBtnLeftClickFunc()
    searchBar.editbox:Reset()
    searchBar.categoryACombo:Select(FindType(searchBar.categoryACombo, GetFilter("a")))
    searchBar.actCombo:Select(FindType(searchBar.actCombo, GetFilter("actabilityGroup")))
    if GetFilter("condition") ~= 0 or not CRAFT_SEARCH_CONDITION.PRODUCT then
    end
    searchBar.conditionRadio:Check(GetFilter("condition"), true)
  end
  ButtonOnClickHandler(searchBar.resetBtn, ResetBtnLeftClickFunc)
  function detailPage.categoryList:OnSelChanged()
    local index = self:GetSelectedIndex()
    if index == 0 or index == -1 then
      return
    end
    local value = self:GetSelectedValue()
    if value == 0 then
      return
    end
    FillDetailPage(value)
  end
  function searchBar.conditionRadio:RadioBtnCheckChangedProc(checked)
    if checked == CRAFT_SEARCH_CONDITION.PRODUCT then
      searchBar.editbox:SetAutocomplete("item", "craftProduct")
    elseif checked == CRAFT_SEARCH_CONDITION.MATERIAL then
      searchBar.editbox:SetAutocomplete("item", "craftMaterial")
    end
  end
  local events = {
    CRAFTING_START = function(doodadId, count)
      window:Show(false)
      window:Init()
      window:SetCategory("craft")
      window:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "craft"))
      window:Show(true)
      SearchFunc(nil, true)
    end,
    BAG_UPDATE = function(bagId, slotId)
      if bagId ~= -1 or slotId ~= -1 then
        return
      end
      if not window:IsVisible() then
        return
      end
      if not window.detailPage:IsVisible() then
        return
      end
      local curCraftType = GetFilter("craft")
      if curCraftType == 0 then
        return
      end
      FillDetailPage(curCraftType)
      FillCategoriesUpdate()
    end,
    PLAYER_MONEY = function()
      if not window:IsVisible() then
        return
      end
      if not window.detailPage:IsVisible() then
        return
      end
      local curCraftType = GetFilter("craft")
      if curCraftType == 0 then
        return
      end
      FillDetailPage(curCraftType)
      FillCategoriesUpdate()
    end,
    CRAFT_STARTED = function(leftCount)
      if not window:IsVisible() then
        return
      end
      if not window.detailPage:IsVisible() then
        return
      end
      EnableCraftButtonFrame(false, true)
      buttonFrame.spinner:ClearFocus()
      EnableCraftOrderFrame(false)
      if leftCount < 1 then
        return
      end
      FillSpinner(nil, leftCount)
    end,
    CRAFT_ENDED = function(leftCount)
      if not window:IsVisible() then
        return
      end
      if not window.detailPage:IsVisible() then
        return
      end
      local curCraftType = GetFilter("craft")
      if curCraftType == nil then
        buttonFrame.spinner:SetMinMaxValues(0, 0)
        return
      end
      if leftCount ~= nil then
        FillSpinner(nil, leftCount)
      else
        local baseInfo = X2Craft:GetCraftBaseInfo(curCraftType)
        buttonFrame.spinner:SetMinMaxValues(0, math.min(X2Craft:GetExecutableCraftCount(curCraftType), VIEW_CRAFTABLE))
        EnableCraftButtonFrame(GetEnableCraftButtonFrame(baseInfo, curCraftType), false)
        EnableCraftOrderFrame(baseInfo.orderable)
      end
    end,
    INTERACTION_END = function()
      if X2Craft:GetInteratcionTargetId() == 0 then
        return
      end
      X2DialogManager:DeleteByOwnerWindow(window:GetId())
      X2Craft:EndCraftingInteraction()
      window:Show(false)
    end,
    LABORPOWER_CHANGED = function()
      if not window:IsVisible() then
        return
      end
      if not window.detailPage:IsVisible() then
        return
      end
      local curCraftType = GetFilter("craft")
      if curCraftType == 0 then
        return
      end
      FillCraftRequireLaborPower()
    end,
    ACTABILITY_EXPERT_CHANGED = function(actabilityId)
      if not window:IsVisible() then
        return
      end
      if not window.detailPage:IsVisible() then
        return
      end
      if actabilityId ~= GetFilter("requireActabilityGroup") then
        return
      end
      FillCraftActability()
    end,
    CHANGE_ACTABILITY_DECO_NUM = function()
      if not window:IsVisible() then
        return
      end
      if not window.detailPage:IsVisible() then
        return
      end
      FillCraftActability()
    end,
    ACTABILITY_MODIFIER_UPDATE = function()
      if not window:IsVisible() then
        return
      end
      if not window.detailPage:IsVisible() then
        return
      end
      FillCraftActability()
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  local function OnHide()
    ClearFilter()
    detailPage:Init()
    searchKeyword = ""
    searchBar.editbox:Reset()
  end
  window:SetHandler("OnHide", OnHide)
  return window
end
local craftFrame = CreateCraftingWindow("craftFrame", "UIParent")
craftFrame:AddAnchor("CENTER", "UIParent", 0, 0)
AddUISaveHandlerByKey("craftFrame", craftFrame)
craftFrame:ApplyLastWindowOffset()
function ToggleRecipeBook(show)
  if show == nil then
    show = not craftFrame:IsVisible()
  end
  if show then
    X2Craft:EndCraftingInteraction()
    craftFrame:Init()
    craftFrame:SetCategory("craft_book")
    craftFrame:SetTitle(locale.craft.craftBook)
    craftFrame:Show(true)
  else
    craftFrame:Show(false)
  end
end
ADDON:RegisterContentTriggerFunc(UIC_CRAFT_BOOK, ToggleRecipeBook)
function VisibleCraftFrame()
  return craftFrame:IsVisible()
end
function SetItemLinkCraftFrame(nameStr)
  craftFrame.searchBar.editbox:LinkText(nameStr)
end
function ExternalCraftSearch(itemType)
  craftFrame:Show(false)
  craftFrame:ExternalSearch(itemType)
  craftFrame:Raise()
end
