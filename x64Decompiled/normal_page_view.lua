local normal_group1_enables = {
  [CMF_SAY] = true,
  [CMF_ZONE] = true,
  [CMF_WHISPER] = true,
  [CMF_TRADE] = true,
  [CMF_PARTY] = true,
  [CMF_FIND_PARTY] = true,
  [CMF_RAID] = true,
  [CMF_NOTICE] = true,
  [CMF_EXPEDITION] = true,
  [CMF_SYSTEM] = true,
  [CMF_FAMILY] = true,
  [CMF_TRIAL] = true,
  [CMF_FACTION] = true,
  [CMF_RACE] = X2Player:GetFeatureSet().chatRace,
  [CMF_SQUAD] = X2Player:GetFeatureSet().squad
}
local normal_extraValue2 = {CMF_MSG_QUEST}
local function GetNormalGroup1List()
  local list = {
    menuTexts = {},
    extraValue = {}
  }
  for k, v in pairs(locale.chatFiltering.normal_group1) do
    if v ~= nil then
      local enable = normal_group1_enables[k]
      if enable ~= nil and enable == true then
        table.insert(list.menuTexts, v)
        table.insert(list.extraValue, k)
      end
    end
  end
  return list
end
function CreateNormalPageWindow(id, parent, checkBoxs)
  local window = CreateEmptyWindow(id, parent)
  window:Show(true)
  window:AddAnchor("TOPLEFT", parent, 0, 0)
  window:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  window:SetTitleText(locale.chatFiltering.menuName[1])
  window.titleStyle:SetAlign(ALIGN_TOP_LEFT)
  window.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  ApplyTitleFontColor(window, FONT_COLOR.TITLE)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local chatInfoList = GetNormalGroup1List()
  local info = {}
  info.menuTexts = chatInfoList.menuTexts
  info.extraValue = chatInfoList.extraValue
  info.enterCount = math.ceil(#info.menuTexts / 2)
  info.menuChkboxOffset = chatLocale.chatOption.normalPage.menuChkOffset
  info.enterCountOffsetX = chatLocale.chatOption.normalPage.enterCountOffset
  window.groupWindow = {}
  window.groupWindow[1] = CreateColorPickCheckGroup(id .. "groupWindow[1]", window, info, checkBoxs)
  window.groupWindow[1]:AddAnchor("TOPLEFT", window, 0, sideMargin)
  window.groupWindow[1]:AddAnchor("TOPRIGHT", window, 0, sideMargin)
  DrawTargetLine(window.groupWindow[1])
  info.menuTexts = locale.chatFiltering.normal_group2
  info.extraValue = normal_extraValue2
  info.enterCount = 1
  window.groupWindow[2] = CreateColorPickCheckGroup(id .. "groupWindow[2]", window, info, checkBoxs)
  window.groupWindow[2]:AddAnchor("TOPLEFT", window.groupWindow[1], "BOTTOMLEFT", 0, 10)
  window.groupWindow[2]:AddAnchor("TOPRIGHT", window.groupWindow[1], "BOTTOMRIGHT", 0, 10)
  return window
end
