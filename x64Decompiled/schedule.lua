local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function CreateScheduleWindow(parent)
  local bg = parent:CreateDrawable(TEXTURE_PATH.EVENT_CENTER_SCHEDULE, "schedule_info", "background")
  bg:AddAnchor("CENTER", parent, 0, 0)
  for i = 1, 15 do
    do
      local label = parent:CreateChildWidget("label", "scheduleTitle", i, true)
      label:SetExtent(153, 28)
      if i == 1 then
        label:AddAnchor("TOPLEFT", parent, 10, 30)
      elseif i == 6 then
        label:AddAnchor("TOPLEFT", parent.scheduleTitle[i - 1], "BOTTOMLEFT", 0, 8)
      else
        label:AddAnchor("TOPLEFT", parent.scheduleTitle[i - 1], "BOTTOMLEFT", 0, 0)
      end
      function label:OnEnter()
        SetTooltip(GetCommonText("event_center_content_schedule_" .. i), label, false, 350)
      end
      label:SetHandler("OnEnter", label.OnEnter)
      function label:OnLeave()
        HideTooltip()
      end
      label:SetHandler("OnLeave", label.OnLeave)
    end
  end
end
