function GetRecruitTypeIconList()
  return {
    "dungeon",
    "raid",
    "influence_war",
    "etc"
  }
end
function GetRiadJoinTextList(withToolTip)
  local radioItems = {
    {
      text = GetCommonText("raid_join_auto"),
      tooltip = withToolTip == true and GetCommonText("raid_join_auto_explain") or nil
    },
    {
      text = GetCommonText("raid_join_manual"),
      tooltip = withToolTip == true and GetCommonText("raid_join_manual_explain") or nil
    }
  }
  return radioItems
end
