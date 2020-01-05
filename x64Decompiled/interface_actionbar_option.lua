function ShowActionBar(index, visible)
  if actionBar_renewal ~= nil then
    if index == 1 then
      actionBar_renewal[1]:Show(visible)
    else
      if actionBar_renewal[index] ~= nil then
        actionBar_renewal[index]:Show(visible)
      end
      if actionBar_renewal[index + 1] ~= nil then
        actionBar_renewal[index + 1]:Show(visible)
      end
    end
  end
end
function ShowActionBar_1(visible)
  ShowActionBar(1, visible)
end
function ShowActionBar_2(visible)
  ShowActionBar(2, visible)
end
function ShowActionBar_3(visible)
  ShowActionBar(4, visible)
end
function ShowActionBar_4(visible)
  ShowActionBar(6, visible)
end
function ShowActionBar_5(visible)
  ShowActionBar(8, visible)
end
local interfaceActionbarOptions = {
  {
    id = "ShowActionBar_1",
    default = localeView.actionBarOption.ShowActionBar_1,
    saveLevel = OL_CHARACTER,
    funcOnChanged = ShowActionBar_1
  },
  {
    id = "ShowActionBar_2",
    default = localeView.actionBarOption.ShowActionBar_2,
    saveLevel = OL_CHARACTER,
    funcOnChanged = ShowActionBar_2
  },
  {
    id = "ShowActionBar_3",
    default = localeView.actionBarOption.ShowActionBar_3,
    saveLevel = OL_CHARACTER,
    funcOnChanged = ShowActionBar_3
  },
  {
    id = "ShowActionBar_4",
    default = localeView.actionBarOption.ShowActionBar_4,
    saveLevel = OL_CHARACTER,
    funcOnChanged = ShowActionBar_4
  },
  {
    id = "ShowActionBar_5",
    default = localeView.actionBarOption.ShowActionBar_5,
    saveLevel = OL_CHARACTER,
    funcOnChanged = ShowActionBar_5
  },
  {id = OPTION_ITEM_SLOT_COOLDOWN_VISIBLE}
}
RegisterOptionItem(interfaceActionbarOptions)
function CreateInterfaceActionBarOptionFrame(parent, subFrameIndex)
  local localePath = optionTexts.actionBar
  local frame = CreateOptionSubFrame(parent, subFrameIndex)
  frame:InsertNewOption("checkbox", localePath.useDefaultAB, nil, "ShowActionBar_1", ShowActionBar_1)
  frame:InsertNewOption("checkbox", localePath.useExpandedFirstAB, nil, "ShowActionBar_2", ShowActionBar_2)
  frame:InsertNewOption("checkbox", localePath.useExpandedSecondAB, nil, "ShowActionBar_3", ShowActionBar_3)
  frame:InsertNewOption("checkbox", localePath.useExpandedThirdAB, nil, "ShowActionBar_4", ShowActionBar_4)
  frame:InsertNewOption("checkbox", localePath.useExpandedFourthAB, nil, "ShowActionBar_5", ShowActionBar_5)
  local optionControl = frame:InsertNewOption("checkbox", localePath.visibleSkillDuration, nil, OPTION_ITEM_SLOT_COOLDOWN_VISIBLE)
  resolutionWarningTextbox = frame:CreateChildWidget("textbox", "resolutionWarningTextbox", 0, true)
  resolutionWarningTextbox:SetExtent(frame.content:GetWidth() - 10, 20)
  resolutionWarningTextbox.style:SetAlign(ALIGN_LEFT)
  resolutionWarningTextbox:SetText(string.format([[
%s

%s]], GetCommonText("option_short_cur_resolution_warning"), GetCommonText("option_short_cut_recommended_resolution")))
  resolutionWarningTextbox:SetAutoResize(true)
  ApplyTextColor(resolutionWarningTextbox, FONT_COLOR.GRAY)
  resolutionWarningTextbox:AddAnchor("TOPLEFT", optionControl, "BOTTOMLEFT", 0, 15)
  return frame
end
function CheckActionBarVisibleStateByOption()
  for i = 1, 5 do
    local value = X2Option:GetOptionItemValueByName(interfaceActionbarOptions[i].id)
    interfaceActionbarOptions[i].funcOnChanged(value)
  end
end
