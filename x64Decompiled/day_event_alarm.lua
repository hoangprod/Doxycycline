local dayEventAlarm
local function CreateDayEventAlarm(id, parent)
  local alarm = CreateEmptyWindow(id, parent)
  alarm:SetHeight(64)
  alarm:SetUILayer("system")
  alarm:EnableHidingIsRemove(true)
  alarm:Clickable(false)
  local textbox = alarm:CreateChildWidget("textbox", "textbox", 0, true)
  textbox:SetExtent(1000, 64)
  textbox:AddAnchor("CENTER", alarm, 0, 0)
  textbox:SetInset(0, 3, 0, 0)
  textbox.style:SetAlign(ALIGN_CENTER)
  textbox.style:SetSnap(true)
  textbox.style:SetShadow(true)
  textbox.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(textbox, FONT_COLOR.DAY_EVENT)
  local bg = CreateContentBackground(alarm, "TYPE8", "black")
  bg:AddAnchor("TOPLEFT", alarm, -30, 0)
  bg:AddAnchor("BOTTOMRIGHT", alarm, 50, 0)
  function alarm:FillEventInfo(msg)
    self.textbox:SetTextAutoWidth(1000, msg, 10)
    local width = self.textbox:GetWidth()
    if width <= 250 then
      width = 250
    end
    self:SetWidth(width + 100)
    self.textbox:SetWidth(width)
    local showTime = 0
    local function OnUpdate(self, dt)
      showTime = dt + showTime
      if showTime >= 3500 then
        self:Show(false, 1000)
        self:ReleaseHandler("OnUpdate")
      end
    end
    self:SetHandler("OnUpdate", OnUpdate)
  end
  local function OnEndFadeOut()
    dayEventAlarm = nil
    StartNextImgEvent()
  end
  alarm:SetHandler("OnEndFadeOut", OnEndFadeOut)
  return alarm
end
function ShowDayEventAlarm(msg)
  if dayEventAlarm == nil then
    dayEventAlarm = CreateDayEventAlarm("dayEventAlarm", "UIParent")
  end
  dayEventAlarm:Show(true, 500)
  dayEventAlarm:FillEventInfo(msg)
  dayEventAlarm:AddAnchor("TOP", "UIParent", 0, 80)
  dayEventAlarm:Raise()
  return true
end
