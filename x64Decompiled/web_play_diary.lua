local diaryWindow
local WIDTH = 604
local HEIGHT = 604
local OFFSET = 38
local TYPE = "NONE"
function ClearWebDiary()
  diaryWindow = nil
  TYPE = "NONE"
end
local function CreateDiaryWindow(id, parent)
  local window = SetViewOfWebbrowserWindow(id, parent, WIDTH, HEIGHT, OFFSET)
  window.clearProc = ClearWebDiary
  function window:RequestPlayDiary(data)
    TYPE = "DIARY"
    if data and type(data) == "string" then
      if data == "target_unit" then
        window.webBrowser:RequestPlayDiaryOnTarget()
      else
        window.webBrowser:RequestPlayDiaryByPcName(data)
      end
    else
      window.webBrowser:RequestPlayDiary()
    end
  end
  function window:RequestMessenger(onTarget)
    TYPE = "MESSENGER"
    if data and type(data) == "string" then
      if data == "target_unit" then
        window.webBrowser:RequestMessengerOnTarget()
      else
        window.webBrowser:RequestMessengerByPcName(data)
      end
    else
      window.webBrowser:RequestMessenger()
    end
  end
  return window
end
function OnToggleWebDiary(show, data)
  if not X2:IsWebEnable() or not localeView.useWebContent or not baselibLocale.useWebDiary then
    return
  end
  if show == nil then
    show = diaryWindow == nil and true or not diaryWindow:IsVisible()
  end
  if diaryWindow == nil then
    diaryWindow = CreateDiaryWindow("diaryWindow", "UIParent")
    diaryWindow:SetSounds("web_play_diary")
  end
  if TYPE ~= "DIARY" then
    diaryWindow:RequestPlayDiary(data)
  end
  diaryWindow:Show(show)
end
ADDON:RegisterContentTriggerFunc(UIC_WEB_PLAY_DIARY, OnToggleWebDiary)
function OnToggleWebMessenger(show, data)
  if not X2:IsWebEnable() or not localeView.useWebContent or not baselibLocale.useWebDiary then
    return
  end
  if show == nil then
    show = diaryWindow == nil and true or not diaryWindow:IsVisible()
  end
  if diaryWindow == nil then
    diaryWindow = CreateDiaryWindow("diaryWindow", "UIParent")
    diaryWindow:SetSounds("web_messenger")
  end
  if TYPE ~= "MESSENGER" then
    diaryWindow:RequestMessenger(data)
  end
  diaryWindow:Show(show)
end
ADDON:RegisterContentTriggerFunc(UIC_WEB_MESSENGER, OnToggleWebMessenger)
