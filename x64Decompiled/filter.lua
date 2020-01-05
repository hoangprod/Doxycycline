local normalCheckGroup = mapFrame.scrollFilterWindow.normalCheckGroup
local uiMapIconDatas = {}
local function SaveUIMapIconData()
  X2:SetCharacterUiData("uiMapIconDatas", uiMapIconDatas)
end
local SetMapFilter = function(npcType, isShow)
  X2Map:SetMapFilter(npcType, isShow)
end
local UpdateAllDrawableAnchor = function()
  worldmap:UpdateAllDrawableAnchor()
  roadmap:UpdateAllDrawableAnchor()
end
local function CheckAndDefaultUIMapIconData()
  if uiMapIconDatas == nil then
    uiMapIconDatas = {}
  end
  local default_filter_table = {
    MST_CORPSE_POS,
    MST_NPC_STATION,
    MST_COMMON_FARM,
    MST_FACTION_HQ,
    MST_RESIDENT_HALL,
    MST_NPC_STABLER,
    MST_NPC_STORE_BANK,
    MST_NPC_STORE_AUCTION_HOUSE,
    MST_NPC_ABILITY_CHANGER,
    MST_NPC_SPECIALTY_TRADEGOODS_SELLER,
    MST_NPC_SPECIALTY_TRADEGOODS_BUYER,
    MST_NPC_SPECIALTY_TRADEGOODS_TRADER,
    MST_NPC_SPECIALTY_GOODS_TRADER,
    MST_DOODAD_MAIL,
    MST_DOODAD_INN,
    MST_DOODAD_SPECIAL_PRODUCT,
    MST_LIGHT_HOUSE,
    MST_DOODAD_PORTAL,
    MST_DOODAD_PORTAL_ARCHEMALL,
    MST_DOODAD_PORTAL_DUNGEON,
    MST_DOODAD_RAID_PURITY,
    MST_HOUSE_NORMAL_HOUSE,
    MST_HOUSE_SEA_FARM_HOUSE,
    MST_HOUSE_HIGH_HOUSE,
    MST_HOUSE_PUMPKIN_HOUSE,
    MST_HOUSE_FARM_HOUSE,
    MST_HOUSE_BUNGALOW_HOUSE
  }
  if not X2Player:GetFeatureSet().hero then
    for i = 1, #default_filter_table do
      local index = default_filter_table[i]
      if index == MST_FACTION_HQ then
        table.remove(default_filter_table, i)
      end
    end
  end
  local folderList = GetFilterFolderList()
  for i = 1, #folderList do
    local key = folderList[i].saveName
    if uiMapIconDatas[key] == nil then
      uiMapIconDatas[key] = true
    end
  end
  local checkTableList = {
    default_filter_table,
    X2Map:GetCheckList(FILTER_INVALID)
  }
  for k = 1, #folderList do
    table.insert(checkTableList, X2Map:GetCheckList(folderList[k].filterType))
  end
  for i = 1, #checkTableList do
    local checkTable = checkTableList[i]
    for i = 1, #checkTable do
      local index = checkTable[i]
      if uiMapIconDatas[X2Map:GetMapIconText(index)] == nil then
        uiMapIconDatas[X2Map:GetMapIconText(index)] = true
      end
    end
  end
  for i = 1, MST_MAX do
    local key = X2Map:GetMapIconText(i)
    if uiMapIconDatas[key] ~= nil then
      SetMapFilter(i, uiMapIconDatas[key])
    end
  end
  for i = 1, #folderList do
    local folderInfo = folderList[i]
    X2Map:SetShowFilter(folderInfo.filterType, uiMapIconDatas[folderInfo.saveName])
  end
  UpdateAllDrawableAnchor()
end
local function LoadUIMapIconData()
  uiMapIconDatas = X2:GetCharacterUiData("uiMapIconDatas")
  CheckAndDefaultUIMapIconData()
end
local function SetMapIconCheck()
  local checkTableList = {
    normalCheckGroup.checks
  }
  local folderList = GetFilterFolderList()
  for k = 1, #folderList do
    local subChecks = mapFrame.scrollFilterWindow[folderList[k].id].detailCheck.group.subChecks
    table.insert(checkTableList, subChecks)
  end
  for i = 1, #checkTableList do
    local checkTable = checkTableList[i]
    for i = 1, #checkTable do
      local iconType = checkTable[i].iconType
      local checked = uiMapIconDatas[X2Map:GetMapIconText(iconType)]
      checkTable[i]:SetChecked(checked, false)
    end
  end
  for k = 1, #folderList do
    local checked = uiMapIconDatas[folderList[k].saveName]
    mapFrame.scrollFilterWindow[folderList[k].id].allCheck:SetChecked(checked, false)
  end
end
local function IsAllCheck()
  local folderList = GetFilterFolderList()
  for k = 1, #folderList do
    local isAll = true
    local folder = mapFrame.scrollFilterWindow[folderList[k].id]
    for j = 1, #folder.detailCheck.group.subChecks do
      local iconType = folder.detailCheck.group.subChecks[j].iconType
      local checked = uiMapIconDatas[X2Map:GetMapIconText(iconType)]
      if not uiMapIconDatas[X2Map:GetMapIconText(iconType)] then
        isAll = false
        break
      end
    end
    folder.detailCheck.group.checks[1]:SetChecked(isAll, false)
  end
end
local function CheckFilter(btn, checked)
  uiMapIconDatas[X2Map:GetMapIconText(btn.iconType)] = checked
  SetMapFilter(btn.iconType, checked)
end
local function AttachCheckBtnProcedure()
  function normalCheckGroup:ChildCheckProcedure(btn, checked)
    CheckFilter(btn, checked)
    UpdateAllDrawableAnchor()
    SaveUIMapIconData()
  end
  local folderList = GetFilterFolderList()
  for k = 1, #folderList do
    do
      local folder = mapFrame.scrollFilterWindow[folderList[k].id]
      function folder.allCheck:CheckBtnCheckChagnedProc(checked)
        uiMapIconDatas[folderList[k].saveName] = checked
        X2Map:SetShowFilter(folderList[k].filterType, checked)
        UpdateAllDrawableAnchor()
        SaveUIMapIconData()
      end
      function folder.detailCheck.group:ChildCheckProcedure(btn, checked)
        if btn == folder.detailCheck.group.checks[1] then
          local isChecked = checked
          for i = 1, #folder.detailCheck.group.subChecks do
            uiMapIconDatas[X2Map:GetMapIconText(folder.detailCheck.group.subChecks[i].iconType)] = isChecked
            SetMapFilter(folder.detailCheck.group.subChecks[i].iconType, isChecked)
          end
        else
          CheckFilter(btn, checked)
        end
        UpdateAllDrawableAnchor()
        SaveUIMapIconData()
      end
    end
  end
end
AttachCheckBtnProcedure()
LoadUIMapIconData()
SetMapIconCheck()
IsAllCheck()
