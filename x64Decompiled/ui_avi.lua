local uiAviWindow
local WIDTH = 900
local HEIGHT = 430
local BROWSER_WIDTH = 640
local BROWSER_HEIGHT = 360
local function CreateUiAviWindow(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:ApplyUIScale(false)
  window:SetExtent(WIDTH, HEIGHT)
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  window:Clickable(true)
  window:SetTitle(locale.tutorial.uiAvi)
  window:Show(true)
  local categoryListHeight = FONT_SIZE.MIDDLE
  local categoryList = W_CTRL.CreateScrollListBox("categoryList", window, window)
  categoryList:SetExtent(194, 360)
  categoryList:AddAnchor("TOPLEFT", window, sideMargin + 5, titleMargin)
  categoryList.content:UseChildStyle(true)
  categoryList.content:EnableSelectParent(false)
  categoryList.content:SetInset(5, 5, 8, 5)
  categoryList.content.itemStyle:SetFontSize(FONT_SIZE.LARGE)
  categoryList.content.childStyle:SetFontSize(FONT_SIZE.MIDDLE)
  categoryList.content.itemStyle:SetAlign(ALIGN_LEFT)
  categoryList.content:SetTreeTypeIndent(true, 20, 20)
  categoryList.content:SetHeight(categoryListHeight)
  categoryList.content:ShowTooltip(true)
  local aviTable = X2Tutorial:GetUiAviTable()
  categoryList:SetItemTrees(aviTable)
  local color = FONT_COLOR.DEFAULT
  categoryList.content.childStyle:SetColor(color[1], color[2], color[3], color[4])
  categoryList:SetTreeImage()
  local avi = window:CreateChildWidget("avi", "avi", 0, true)
  window.avi:SetExtent(BROWSER_WIDTH, BROWSER_HEIGHT)
  window.avi:RemoveAllAnchors()
  window.avi:AddAnchor("TOPLEFT", categoryList, "TOPRIGHT", sideMargin, 0)
  window.avi:Show(true)
  function categoryList:OnSelChanged()
    local value = self:GetSelectedValue()
    window.avi:SetAviNum(value)
  end
  function window:SetFocusHandler()
    function avi:OnEnter()
      avi:SetFocus()
    end
    avi:SetHandler("OnEnter", avi.OnEnter)
    function avi:OnLeave()
      avi:ClearFocus()
    end
    avi:SetHandler("OnLeave", avi.OnLeave)
  end
  function window:OnShow()
    avi:Show(true)
  end
  window:SetHandler("OnShow", window.OnShow)
  function window:OnHide()
    avi:Show(false)
  end
  window:SetHandler("OnHide", window.OnHide)
  return window
end
function OnToggleUiAvi()
  if uiAviWindow == nil then
    uiAviWindow = CreateUiAviWindow("UiAviWindow", "UIParent")
    uiAviWindow:Show(true)
    uiAviWindow.avi:Show(true)
  else
    uiAviWindow:Show(not uiAviWindow:IsVisible())
  end
end
ADDON:RegisterContentTriggerFunc(UIC_UI_AVI, OnToggleUiAvi)
