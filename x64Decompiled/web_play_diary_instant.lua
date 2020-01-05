local diaryInstantWindow
local WIDTH = 434
local HEIGHT = 380
local OFFSET = 0
function ClearWebDiaryInstant()
  diaryInstantWindow = nil
end
local function CreateDiaryInstantWindow(id, parent)
  local window = SetViewOfWebbrowserWindow(id, parent, WIDTH, HEIGHT, OFFSET)
  window:SetSounds("web_play_diary")
  window.clearProc = ClearWebDiaryInstant
  return window
end
local function OnToggleWebDiaryInstant(fileName)
  if not UIParent:GetPermission(UIC_WEB_PLAY_DIARY_INSTANCE) then
    AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(ERROR_MSG, "CANNOT_USE_IN_BATTLE_FIELD"))
    return
  end
  if not X2:IsWebEnable() or not localeView.useWebContent or not baselibLocale.useWebQuickDiary then
    return
  end
  local show = diaryInstantWindow == nil and true or not diaryInstantWindow:IsVisible()
  if diaryInstantWindow == nil then
    diaryInstantWindow = CreateDiaryInstantWindow("diaryInstantWindow", "UIParent")
    diaryInstantWindow.webBrowser:RequestPlayDiaryInstant(fileName)
    ADDON:RegisterContentWidget(UIC_WEB_PLAY_DIARY_INSTANCE, diaryInstantWindow)
  end
  diaryInstantWindow:Show(show)
end
UIParent:SetEventHandler("TOGGLE_WEB_PLAY_DIARY_INSTANT", OnToggleWebDiaryInstant)
