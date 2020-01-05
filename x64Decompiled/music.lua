local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local function CreateMethodWnd()
  local window = CreateWindow("composition.methodWnd", composition.score)
  window:Show(false)
  window:SetExtent(510, 730)
  window:SetTitle(locale.composition.method)
  local tab = W_BTN.CreateTab("tab", window)
  local tabName = {
    GetCommonText("normalUserType"),
    GetUIText(COMPOSITION_TEXT, "percussion")
  }
  tab:AddTabs(tabName)
  CreateNormalTabPage(tab.window[1])
  CreatePercussionTabPage(tab.window[2])
  local height = 0
  for i = 1, #tab.window do
    local tab = tab.window[i]
    if height < tab:GetContentHeight() then
      height = tab:GetContentHeight()
    end
  end
  height = height + sideMargin + titleMargin + BUTTON_SIZE.TAB_SELECT.HEIGHT + sideMargin / 2
  window:SetHeight(height)
  local OnHide = function()
    composition.methodWnd = nil
  end
  window:SetHandler("OnHide", OnHide)
  return window
end
function ShowCompositionMethodWnd(isShow)
  if composition.score == nil then
    return
  end
  if composition.methodWnd == nil then
    if isShow then
      composition.methodWnd = CreateMethodWnd()
      composition.methodWnd:Show(true)
      composition.methodWnd:AddAnchor("TOPRIGHT", composition.score, "TOPLEFT", -10, sideMargin)
      local OnTabChanged = function(self, selected)
        if composition.methodWnd.tabSelected == selected then
          return
        end
        ReAnhorTabLine(self, selected)
        composition.methodWnd.tabSelected = selected
      end
      composition.methodWnd.tab:SetHandler("OnTabChanged", OnTabChanged)
    else
      return
    end
  else
    composition.methodWnd:Show(not composition.methodWnd:IsVisible())
  end
end
local ShowScoreWindow = function(isShow, itemIdString, isWide)
  if isShow == nil then
    isShow = true
  end
  if isShow and composition.score == nil then
    do
      local score = CreateScoreWindow("composition.score", "UIParent", isWide)
      score:Show(true)
      score:EnableHidingIsRemove(true)
      local events = {
        CLOSE_MUSIC_SHEET = function()
          score:Show(false)
        end
      }
      score:SetHandler("OnEvent", function(this, event, ...)
        events[event](...)
      end)
      RegistUIEvent(score, events)
      composition.score = score
    end
  end
  if composition.score ~= nil then
    composition.score:Show(isShow)
  end
  composition.score.itemIdString = itemIdString
end
UIParent:SetEventHandler("OPEN_MUSIC_SHEET", ShowScoreWindow)
