local wnd
function ShowRaidApplicant(parent, info)
  if nil == wnd then
    wnd = SetViewOfRaidApplicant("raidApplicant", parent)
    wnd:Show(false)
  end
  function SetInfo(info)
    local subTypeInfo = X2Team:GetRaidRecruitSubType(info.type, info.subType)
    if subTypeInfo == nil then
      return
    end
    local RECRUIT_TYPE_ICON = GetRecruitTypeIconList()
    wnd.typeIcon:SetTextureInfo("icon_" .. RECRUIT_TYPE_ICON[info.type])
    wnd.recruitSubType:SetText(info.subTypeName)
    wnd.description:SetText(subTypeInfo.comment)
    wnd.departureTime:SetText(locale.time.GetDateToDateFormat(info, FORMAT_FILTER.HOUR + FORMAT_FILTER.MINUTE):match("^%s*(.-)%s*$"))
    wnd.levelLimit:SetText(GetLevelToString(info.limitLevel, nil, nil, true))
    wnd.ownerName:SetText(info.ownerName)
    wnd.ownerLevel:SetText(GetLevelToString(info.ownerLevel, nil, nil, true))
    if "" == info.ownerExpedition then
      info.ownerExpedition = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "nobody")
    end
    wnd.ownerExpedition:SetText(info.ownerExpedition)
    if X2Team:IsSiegeRaidRecruitType(info.type, info.subType) then
      wnd:SetTitle(GetCommonText("siege_raid_join"))
      wnd.guide:SetText(GetCommonText("siege_raid_recruit_msg"))
      wnd.questionTextbox:SetText(GetCommonText("siege_raid_applicant_question", tostring(X2Player:GetForceAttackLimitLevel())))
    else
      wnd:SetTitle(GetCommonText("raid_join"))
      wnd.guide:SetText(info.msg)
      wnd.questionTextbox:SetText(GetCommonText("raid_applicant_question"))
    end
    wnd:Show(true)
    return wnd
  end
  function RegisterButtonClick()
    X2Team:RaidApplicantAdd(info.ownerId, wnd.roleRadioBoxes:GetCheckedData(), info.createTime)
    wnd:Show(false)
  end
  wnd.registerButton:SetHandler("OnClick", RegisterButtonClick)
  function CancelButtonClick()
    wnd:Show(false)
  end
  wnd.cancelButton:SetHandler("OnClick", CancelButtonClick)
  return SetInfo(info)
end
