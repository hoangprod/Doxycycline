local USER_FILE_NAMES = {
  "ucc.png",
  "ucc.tga",
  "ucc.dds",
  "ucc.jpg",
  "ucc.bmp"
}
uccSampleIndex = 0
patternIndex = 0
sampleType = 0
local UccSampleColorShow = function(numOfColor)
  if ucc == nil then
    return
  end
  for k = 1, #ucc.sampleColor do
    local visible = k <= numOfColor and true or false
    ucc.sampleColor[k]:Enable(visible)
    if visible == false then
      ucc.sampleColor[k]:SetAlpha(0.2)
    elseif visible == true then
      ucc.sampleColor[k]:SetAlpha(1)
    end
  end
  ucc.palletWindow:Show(false)
end
UccSampleColorShow(0)
local ConvertRGB = function(fR, fG, fB)
  return math.floor(fR * 255), math.floor(fG * 255), math.floor(fB * 255)
end
local function SetPatternColor()
  if ucc == nil then
    return
  end
  local index = ucc.sampleColor[3].colorIndex
  local color = ucc.pallet.colors[index].color:GetColor()
  ucc.previewBg:ChangeColor3(ConvertRGB(color.r, color.g, color.b))
  index = ucc.sampleColor[2].colorIndex
  color = ucc.pallet.colors[index].color:GetColor()
  ucc.previewBg:ChangeColor2(ConvertRGB(color.r, color.g, color.b))
  index = ucc.sampleColor[1].colorIndex
  color = ucc.pallet.colors[index].color:GetColor()
  ucc.previewBg:ChangeColor1(ConvertRGB(color.r, color.g, color.b))
end
local initColorsIndex = {
  91,
  33,
  42
}
local function InitSampleColor()
  if ucc == nil then
    return
  end
  for k = 1, #ucc.sampleColor do
    local btn = ucc.sampleColor[k]
    local idx = initColorsIndex[k]
    local color = ucc.pallet.colors[idx].color:GetColor()
    btn.bg:SetColor(color.r, color.g, color.b, color.a)
    btn.colorIndex = idx
  end
  SetPatternColor()
end
local function SelectPattern(index)
  if ucc == nil then
    return
  end
  patternIndex = index
  local numOfColor = 0
  for k = 1, #ucc.pattern do
    local pattern = ucc.pattern[k]
    if k == index then
      SetBGPushed(pattern, true)
      ucc.previewBg:ChangeImageFile(pattern.typeNumber)
      SetPatternColor()
      numOfColor = pattern.numOfColor
    else
      SetBGPushed(pattern, false)
    end
  end
  ucc.previewBg:SetVisible(numOfColor > 0 and true or false)
  UccSampleColorShow(numOfColor)
end
local SelectSample = function(index)
  if ucc == nil then
    return
  end
  if ucc.sample[index] ~= nil then
    sampleType = ucc.sample[index].typeNumber
  else
    sampleType = 0
  end
  local visible = false
  for k = 1, ucc.totalSample do
    local sample = ucc.sample[k]
    if k == index then
      SetBGPushed(sample, true)
      local path = X2Ucc:GetPatternPath(sample.typeNumber)
      if path ~= "unknown" then
        ucc.previewFg:SetTexture(path)
        visible = true
      end
    else
      SetBGPushed(sample, false)
    end
  end
  ucc.previewFg:SetVisible(visible)
  ucc.window.leftButton:Enable(visible)
end
local SelectUserSample = function(index)
  if ucc == nil then
    return
  end
  uccSampleIndex = index
  local visible = false
  local path = X2Ucc:GetFgUserPath(index)
  if path ~= "unknown" then
    visible = ucc.previewFg:SetTgaTexture(path)
    if not visible then
      AddMessageToSysMsgWindow(string.format("%s%s", FONT_COLOR_HEX.RED, X2Locale:LocalizeUiText(UCC_TEXT, "ucc_format_invalid")))
    end
  end
  ucc.previewFg:SetVisible(visible)
  ucc.window.leftButton:Enable(visible)
end
local SelectColorButton = function(index)
  for k = 1, #ucc.pallet.colors do
    if k == index then
      ucc.pallet.colors[k]:SetBGHighlighted(true)
    else
      ucc.pallet.colors[k]:SetBGHighlighted(false)
    end
  end
end
local function SelectColor(index)
  local color = ucc.pallet.colors[index].color:GetColor()
  ucc.selectedButton.bg:SetColor(color.r, color.g, color.b, color.a)
  ucc.selectedButton.colorIndex = index
  ucc.selectedButton = nil
  ucc.palletWindow:Show(false)
  SetPatternColor()
end
local function CreatePatternItem(id, parent, typeNumbers, filePaths, numOfColors, pagePerPatterns)
  local item = {}
  local disableItem = {}
  for i = 1, #typeNumbers do
    do
      local x = (i - 1) % pagePerPatterns * 58 + 26
      item[i] = CreateEmptyButton(id .. "item" .. i, parent)
      item[i]:Show(false)
      item[i]:AddAnchor("BOTTOMLEFT", parent, x, 0)
      item[i]:SetExtent(48, 48)
      ApplyButtonSkin(item[i], BUTTON_CONTENTS.UCC_ITEM)
      if filePaths[i] == "" then
        filePaths[i] = INVALID_ICON_PATH
      end
      DrawDefaultSlotBackground(item[i])
      item[i].slotBackground:SetExtent(50, 50)
      item[i].slotBackground:AddAnchor("CENTER", item[i], 0, 0)
      item[i].patternTexture = item[i]:CreateImageDrawable(filePaths[i], "background")
      item[i].patternTexture:SetExtent(48, 48)
      item[i].patternTexture:AddAnchor("CENTER", item[i], 0, 0)
      item[i].typeNumber = typeNumbers[i]
      item[i].numOfColor = numOfColors[i]
      item[i]:SetHandler("OnClick", function()
        SelectPattern(i)
      end)
    end
  end
  local leftCount = pagePerPatterns - #filePaths % pagePerPatterns
  ucc.patternLeftCount = leftCount
  return item
end
local function CreateSampleItem(id, parent, typeNumbers, pagePerSamples)
  ucc.totalSample = #typeNumbers
  if ucc.sample == nil then
    ucc.sample = {}
  end
  for i = 1, ucc.totalSample do
    do
      local path = X2Ucc:GetPatternIconPath(typeNumbers[i])
      if path == "unknown" or path == "" then
        path = INVALID_ICON_PATH
      end
      if ucc.sample[i] == nil then
        local x = (i - 1) % pagePerSamples * 58 + 25
        item = CreateEmptyButton(id .. i, parent)
        item:Show(false)
        item:AddAnchor("BOTTOMLEFT", parent, x, 0)
        item:SetExtent(48, 48)
        ApplyButtonSkin(item, BUTTON_CONTENTS.UCC_ITEM)
        DrawDefaultSlotBackground(item)
        item.slotBackground:SetExtent(50, 50)
        item.slotBackground:AddAnchor("CENTER", item, 0, 0)
        item.patternTexture = item:CreateImageDrawable(path, "background")
        item.patternTexture:SetExtent(48, 48)
        item.patternTexture:AddAnchor("CENTER", item, 0, 0)
        item:SetHandler("OnClick", function()
          SelectUserSample(0)
          SelectSample(i)
        end)
        ucc.sample[i] = item
      else
        ucc.sample[i].patternTexture:SetTexture(path)
      end
      ucc.sample[i].typeNumber = typeNumbers[i]
      SetBGPushed(ucc.sample[i], sampleType == typeNumbers[i])
    end
  end
  for i = ucc.totalSample + 1, #ucc.sample do
    ucc.sample[i].typeNumber = 0
    SetBGPushed(ucc.sample[i], false)
    ucc.sample[i]:Show(false)
  end
end
local function InitUccCategory()
  local emblemInfo = {}
  local initValue
  local categoryInfo = X2Ucc:GetUccCategoryInfo()
  if categoryInfo ~= nil then
    local info = {}
    for i = 1, #categoryInfo do
      local cInfo = categoryInfo[i]
      info[i] = {}
      info[i].text = cInfo.name
      if cInfo.subCategories ~= nil then
        info[i].opened = true
        info[i].child = {}
        for j = 1, #cInfo.subCategories do
          info[i].child[j] = {}
          info[i].child[j].text = cInfo.subCategories[j].name
          info[i].child[j].value = cInfo.subCategories[j].categoryId
          if initValue == nil then
            initValue = info[i].child[j].value
          end
          emblemInfo[cInfo.subCategories[j].categoryId] = {
            desc = cInfo.subCategories[j].desc,
            emblems = cInfo.subCategories[j].emblems
          }
        end
      else
        info[i].value = cInfo.categoryId
        if initValue == nil then
          initValue = info[i].value
        end
        emblemInfo[cInfo.categoryId] = {
          desc = cInfo.desc,
          emblems = cInfo.emblems
        }
      end
    end
    ucc.category.content:SetItemTrees(info)
  end
  ucc.category.initValue = initValue
  ucc.category.info = emblemInfo
  function ucc.category:OnSelChanged()
    local value = self.content:GetSelectedValue()
    if self.info[value] ~= nil then
      ucc.categoryDesc:SetText(self.info[value].desc)
      CreateSampleItem("ucc.sample", ucc.sampleWindow, self.info[value].emblems, ucc.sampleWindow.pagePerSamples)
      ucc.sampleWindow:SetPageByItemCount(ucc.totalSample, ucc.sampleWindow.pagePerSamples)
      ucc.sampleWindow:Refresh()
    end
  end
  function ucc.category:Reset()
    ucc.category.content:SelectWithValue(ucc.category.initValue)
  end
end
local uccEvents = {}
local function CreateUCCWindow()
  SetViewOfUCCWindow()
  local okButton = ucc.window.leftButton
  local cancelButton = ucc.window.rightButton
  function ucc.patternWindow:OnPageChanged(pageIndex, countPerPage)
    local totalPattern = #ucc.pattern
    local startIndex = (pageIndex - 1) * countPerPage + 1
    local endIndex = startIndex + countPerPage - 1
    endIndex = math.min(endIndex, totalPattern)
    for i = 1, totalPattern do
      ucc.pattern[i]:Show(false)
    end
    for i = startIndex, endIndex do
      ucc.pattern[i]:Show(true)
    end
    self.prevPageButton:Enable(pageIndex ~= 1)
    self.nextPageButton:Enable(pageIndex ~= self.maxPage)
  end
  ucc.patternWindow.resetBtn:SetHandler("OnClick", function()
    InitSampleColor()
    SelectPattern(0)
    ucc.palletWindow:Show(false)
  end)
  function ucc.sampleWindow:OnPageChanged(pageIndex, countPerPage)
    local totalSamples = ucc.totalSample
    local startIndex = (pageIndex - 1) * countPerPage + 1
    local endIndex = startIndex + countPerPage - 1
    endIndex = math.min(endIndex, totalSamples)
    for i = 1, totalSamples do
      ucc.sample[i]:Show(false)
    end
    for i = startIndex, endIndex do
      ucc.sample[i]:Show(true)
    end
    self.prevPageButton:Enable(pageIndex ~= 1)
    self.nextPageButton:Enable(pageIndex ~= self.maxPage)
  end
  ucc.sampleWindow.resetBtn:SetHandler("OnClick", function()
    SelectSample(0)
    SelectUserSample(0)
  end)
  function ucc.userSample:OnEnter()
    local message = string.format("%s%s %s %s %s %s", locale.ucc.helperTip, locale.ucc.size, locale.ucc.fileName, USER_FILE_NAMES[1], locale.ucc.path, X2Ucc:GetUccUserDirectoryPath())
    SetTooltip(message, self)
  end
  ucc.userSample:SetHandler("OnEnter", ucc.userSample.OnEnter)
  function ucc.userSample:OnLeave()
    HideTooltip()
  end
  ucc.userSample:SetHandler("OnLeave", ucc.userSample.OnLeave)
  for k = 1, #ucc.pallet.colors do
    ucc.pallet.colors[k]:SetHandler("OnClick", function()
      SelectColor(k)
    end)
  end
  for k = 1, #ucc.sampleColor do
    do
      local btn = ucc.sampleColor[k]
      local idx = initColorsIndex[k]
      local color = ucc.pallet.colors[idx].color:GetColor()
      btn.bg:SetColor(color.r, color.g, color.b, color.a)
      btn.colorIndex = idx
      function btn:OnEnter()
        if self:GetAlpha() == 1 then
          SetTooltip(locale.ucc.colorPick, self)
        end
      end
      btn:SetHandler("OnEnter", btn.OnEnter)
      function btn.OnClick()
        ucc.selectedButton = btn
        ucc.palletWindow:Show(true)
      end
      btn:SetHandler("OnClick", btn.OnClick)
      function btn:OnLeave()
        HideTooltip()
      end
      btn:SetHandler("OnLeave", btn.OnLeave)
    end
  end
  if ucc.category ~= nil then
    InitUccCategory()
  end
  function ucc.palletWindow.closeBtn:OnClick()
    ucc.palletWindow:Show(false)
  end
  ucc.palletWindow.closeBtn:SetHandler("OnClick", ucc.palletWindow.closeBtn.OnClick)
  function cancelButton:OnClick()
    ucc.window:Show(false)
  end
  cancelButton:SetHandler("OnClick", cancelButton.OnClick)
  function okButton:OnClick()
    if patternIndex == 0 or sampleType == 0 and uccSampleIndex == 0 then
      X2Ucc:UploadColors(0, 0, 0, 0, 0, 0, 0, 0, 0)
    end
    local useUserImage = uccSampleIndex ~= 0 and true or false
    local uccFrame, moneyString, consumeInfo = X2Ucc:GetMakeUccConsumeInfo(ucc.doodad, useUserImage)
    local function DialogHandler(wnd)
      wnd:SetTitle(X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "confirm_ucc_upload_title"))
      local content = ""
      if useUserImage then
        content = locale.ucc.create_subscription_warning
      end
      if consumeInfo ~= nil and itemCount ~= 0 then
        content = F_TEXT.SetEnterString(content, GetUIText(UCC_TEXT, "check_subscription_consumption", uccFrame.itemInfo.gradeColor, uccFrame.itemInfo.name))
        wnd:UpdateDialogModule("textbox", content)
        local itemData = {
          itemInfo = consumeInfo.itemInfo,
          stack = consumeInfo.requiredCount
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
        if moneyString ~= "0" then
          local costData = {type = "cost", value = moneyString}
          wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", costData)
        end
      else
        content = F_TEXT.SetEnterString(content, GetUIText(UCC_TEXT, "check_consumption", uccFrame.itemInfo.gradeColor, uccFrame.itemInfo.name))
        wnd:UpdateDialogModule("textbox", content)
        local costData = {type = "cost", value = moneyString}
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", costData)
      end
      local textData = {
        type = "warning",
        text = GetUIText(COMMON_TEXT, "ucc_exception")
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
      function wnd:OkProc()
        if patternIndex ~= 0 then
          local index = ucc.sampleColor[1].colorIndex
          local color1 = ucc.pallet.colors[index].color:GetColor()
          index = ucc.sampleColor[2].colorIndex
          local color2 = ucc.pallet.colors[index].color:GetColor()
          index = ucc.sampleColor[3].colorIndex
          local color3 = ucc.pallet.colors[index].color:GetColor()
          local r1, g1, b1 = ConvertRGB(color1.r, color1.g, color1.b)
          local r2, g2, b2 = ConvertRGB(color2.r, color2.g, color2.b)
          local r3, g3, b3 = ConvertRGB(color3.r, color3.g, color3.b)
          X2Ucc:UploadColors(r1, g1, b1, r2, g2, b2, r3, g3, b3)
        end
        local patternTypeNumber = 0
        if ucc.pattern[patternIndex] ~= nil then
          patternTypeNumber = ucc.pattern[patternIndex].typeNumber
        end
        X2Ucc:UploadEmblem(ucc.doodad, patternTypeNumber, sampleType, uccSampleIndex)
        ucc.window:Show(false)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, ucc.window:GetId())
  end
  okButton:SetHandler("OnClick", okButton.OnClick)
  function ucc.window:OnHide()
    ucc = nil
  end
  ucc.window:SetHandler("OnHide", ucc.window.OnHide)
  ucc.window:SetCloseOnEscape(true)
  ucc.window:EnableHidingIsRemove(true)
  ucc.window:SetHandler("OnEvent", function(this, event, ...)
    uccEvents[event](...)
  end)
  ucc.window:RegisterEvent("OPEN_EMBLEM_IMPRINT_UI")
  ucc.window:RegisterEvent("INTERACTION_END")
end
SetPatternColor()
uccEvents = {
  INTERACTION_END = function()
    if ucc ~= nil and ucc.window:IsVisible() == true then
      ucc.window:Show(false)
    end
  end,
  OPEN_EMBLEM_IMPRINT_UI = function(doodad)
    ChatLog(OPEN_EMBLEM_IMPRINT_UI)
  end
}
local function InitPatternWindow()
  local bgTypeNumbers = {}
  local bgPaths = {}
  local bgNumOfColors = {}
  local function SetBgData(typeNumber, bgNumOfColor)
    bgTypeNumbers[#bgTypeNumbers + 1] = typeNumber or 0
    bgPaths[#bgPaths + 1] = X2Ucc:GetPatternIconPath(typeNumber) or ""
    bgNumOfColors[#bgNumOfColors + 1] = bgNumOfColor or 0
  end
  local typeNumbers = X2Ucc:GetPatternTypeNumbers()
  for i = 1, #typeNumbers do
    local kind = X2Ucc:GetPatternKind(typeNumbers[i])
    if kind == "background_1color" then
      SetBgData(typeNumbers[i], 1)
    elseif kind == "background_2color" then
      SetBgData(typeNumbers[i], 2)
    elseif kind == "background_3color" then
      SetBgData(typeNumbers[i], 3)
    end
  end
  ucc.pattern = CreatePatternItem("ucc.pattern", ucc.patternWindow, bgTypeNumbers, bgPaths, bgNumOfColors, ucc.patternWindow.pagePerPatterns)
  ucc.patternWindow:SetPageByItemCount(#ucc.pattern, ucc.patternWindow.pagePerPatterns)
  ucc.patternWindow:Refresh()
end
local function InitSampleWindow()
  local fgTypeNumbers = {}
  local typeNumbers = X2Ucc:GetPatternTypeNumbers()
  for i = 1, #typeNumbers do
    local kind = X2Ucc:GetPatternKind(typeNumbers[i])
    if kind == "foreground" then
      local aa = #fgTypeNumbers
      fgTypeNumbers[#fgTypeNumbers + 1] = typeNumbers[i] or 0
    end
  end
  CreateSampleItem("ucc.sample", ucc.sampleWindow, fgTypeNumbers, ucc.sampleWindow.pagePerSamples)
  ucc.sampleWindow:SetPageByItemCount(ucc.totalSample, ucc.sampleWindow.pagePerSamples)
  ucc.sampleWindow:Refresh()
end
local function InitUserSample()
  local function GetUserFileIndex(count)
    for i = 1, count do
      for x = 1, #USER_FILE_NAMES do
        if USER_FILE_NAMES[x] == X2Ucc:GetFgUserPath(i) then
          return i
        end
      end
    end
    return 0
  end
  ucc.userSampleCreated = GetUserFileIndex(X2Ucc:GetFgUserCount())
  if ucc.userSampleCreated ~= 0 then
    local path = X2Ucc:GetFgUserPath(ucc.userSampleCreated)
    ucc.userSample.texture:SetTgaTexture(path)
    ucc.userSample:SetHandler("OnClick", function()
      SelectSample(0)
      SelectUserSample(ucc.userSampleCreated)
    end)
    SelectUserSample(0)
  end
end
local function OpenEmblemUploadUI(doodad)
  uccSampleIndex = 0
  patternIndex = 0
  sampleType = 0
  if ucc == nil then
    CreateUCCWindow()
  end
  if ucc.pattern == nil then
    InitPatternWindow()
  end
  if ucc.sample == nil then
    if uccLocale.useCategory then
      InitUccCategory()
    elseif ucc.sample == nil then
      InitSampleWindow()
    end
  end
  InitUserSample()
  if uccLocale.useCategory then
    ucc.category:Reset()
  end
  ucc.window:Show(true)
  ucc.doodad = doodad
end
UIParent:SetEventHandler("OPEN_EMBLEM_UPLOAD_UI", OpenEmblemUploadUI)
local CreateOriginUCCItem = function()
  F_SOUND.PlayUISound("event_gain_ucc_item", true)
end
UIParent:SetEventHandler("CREATE_ORIGIN_UCC_ITEM", CreateOriginUCCItem)
