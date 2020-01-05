local CreateDyeingWindow = function(id, parent)
  local window = SetViewOfDyeingWindow(id, parent)
  window:Show(false)
  local r, g, b = 0, 0, 0
  local originR, originG, originB = 0, 0, 0
  local isEquipmentDyeing = false
  local builderEnd = false
  local pallette = window.palletteSection.pallette
  local modelWindow = window.modelWindow
  local function SameOriginColor(r, g, b)
    return r == originR and g == originG and b == originB
  end
  local function SetEnable(enable)
    window.palletteSection:Enable(enable, true)
    pallette:L_SetEnable(enable)
    window.leftButton:Enable(enable and not SameOriginColor(r, g, b))
  end
  function pallette:SetColorProc(r, g, b)
    X2Dyeing:DyeSample(r, g, b)
    if isEquipmentDyeing then
      modelWindow:UpdateColor(r, g, b)
    end
    local enable = not SameOriginColor(r, g, b)
    window.leftButton:Enable(enable)
  end
  local function ResetButtonClickFunc()
    pallette:L_Init(r, g, b)
    window.leftButton:Enable(false)
  end
  ButtonOnClickHandler(window.palletteSection.resetBtn, ResetButtonClickFunc)
  local function LeftButtonClickFunc()
    X2Dyeing:Execute()
    window:Show(false)
  end
  ButtonOnClickHandler(window.leftButton, LeftButtonClickFunc)
  local function RightButtonClickFunc()
    window:Show(false)
  end
  ButtonOnClickHandler(window.rightButton, RightButtonClickFunc)
  window.OnClose = RightButtonClickFunc
  local function OnHide()
    isEquipmentDyeing = false
    modelWindow:Show(false)
    X2Dyeing:Leave()
  end
  window:SetHandler("OnHide", OnHide)
  function window:FillInfo()
    local info = X2Dyeing:GetInfo()
    local targetItemInfo = info.targetItemInfo
    window.content:SetText(GetUIText(COMMON_TEXT, "dyeing_content", FONT_COLOR_HEX.RED))
    window.itemSection.itemIcon:SetItemInfo(targetItemInfo)
    window.itemSection.itemName:SetText(string.format("|c%s%s", targetItemInfo.gradeColor, targetItemInfo.name))
    if targetItemInfo.dyeingColor == nil then
      r = 0
      g = 0
      b = 0
    else
      r = targetItemInfo.dyeingColor.r
      g = targetItemInfo.dyeingColor.g
      b = targetItemInfo.dyeingColor.b
    end
    originR = r
    originG = g
    originB = b
    pallette:L_Init(r, g, b)
    self:AdjustHeight()
    if targetItemInfo.item_impl == "armor" then
      isEquipmentDyeing = true
      modelWindow:Show(true)
      modelWindow:SetDyeingSample(info.targetItemInfo.lookType, info.targetItemInfo.itemGrade, r, g, b)
    end
  end
  local events = {
    DYEING_START = function()
      window:FillInfo()
      window:Show(true)
    end,
    DYEING_END = function()
      if not window:IsVisible() then
        return
      end
      window:Show(false)
    end,
    UPDATE_DYEING_EXCUTABLE = function(executeable)
      SetEnable(executeable)
    end,
    ENTERED_LOADING = function()
      if not window:IsVisible() then
        return
      end
      window:Show(false)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
local dyeingWindow = CreateDyeingWindow("dyeingWindow", "UIParent")
