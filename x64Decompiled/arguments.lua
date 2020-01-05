local noramlParam2 = {
  {
    W_ICON,
    "CreateItemIconImage"
  },
  {
    W_ICON,
    "CreateLeaderMark"
  },
  {
    W_MONEY,
    "CreateTwoLineMoneyWindow"
  },
  {
    W_MONEY,
    "CreateTwoLineAAPointWindow"
  },
  {
    W_MONEY,
    "CreateAAPointBuyFrame"
  },
  {
    W_CTRL,
    "CreateLabel"
  },
  {
    W_CTRL,
    "CreatePageControl"
  },
  {
    W_CTRL,
    "CreateScroll"
  },
  {W_CTRL, "CreateEdit"},
  {
    W_CTRL,
    "CreateMultiLineEdit"
  },
  {W_CTRL, "CreateList"},
  {
    W_CTRL,
    "CreateScrollListBox"
  },
  {
    W_ETC,
    "CreatePeriodWidget"
  },
  {
    W_ETC,
    "CreateScoreBoardGuageSection"
  },
  {
    W_ETC,
    "CreateSpinner"
  },
  {W_BTN, "CreateTab"},
  {
    W_BTN,
    "CreateImageTab"
  }
}
for k, v in pairs(W_BAR) do
  if type(v) == "function" then
    table.insert(noramlParam2, {W_BAR, k})
  end
end
local noramlParam3 = {
  {
    W_MONEY,
    "CreateMoneyEditsWindow"
  },
  {
    W_MONEY,
    "CreateAAPointEditsWindow"
  }
}
local GetDefaultParam = function(count)
  if count == 2 then
    return {"test", "@widget"}
  elseif count == 3 then
    return {
      "test",
      "@widget",
      "AAAAA"
    }
  end
end
local function SetDefaultParam(tables, count)
  local params = GetDefaultParam(count)
  for i = 1, #tables do
    local item = tables[i]
    funcInfo = GetFuncInfo(item[1], item[2])
    if funcInfo == nil then
      UIParent:Warning(string.format("[Lua Error] failed set default param info... index[%d] name[%s]", i, item[2]))
    else
      funcInfo.paramTable = params
    end
  end
end
SetDefaultParam(noramlParam2, 2)
SetDefaultParam(noramlParam3, 3)
local funcInfo = GetFuncInfo(W_ICON, "DrawMoneyIcon")
funcInfo.paramTable = {"@widget", "gold"}
funcInfo = GetFuncInfo(W_UNIT, "CreateLevelLabel")
funcInfo.paramTable = {
  "test",
  "@widget",
  true
}
funcInfo.desc = "3\235\178\136\236\167\184 \236\157\184\236\158\144 true/false\235\161\156 texture \236\130\172\236\154\169 \236\151\172\235\182\128 \234\178\176\236\160\149"
function funcInfo.showFunc(widget)
  widget:ChangedLevel(50)
end
funcInfo = GetFuncInfo(W_BAR, "CreateCastingBar")
funcInfo.paramTable = {
  "test",
  "@widget",
  "player"
}
funcInfo = GetFuncInfo(W_UNIT, "CreateBuffWindow")
funcInfo.paramTable = {
  "test",
  "@widget",
  1
}
funcInfo = GetFuncInfo(W_ETC, "CreatePeriodWidget")
function funcInfo.showFunc(widget)
  widget:SetPeriod("AAAAAAA", true, true)
end
funcInfo = GetFuncInfo(W_BAR, "CreateDoubleGauge")
function funcInfo.showFunc(widget)
  widget:SetLayout("big")
  widget:UpdateScore(2, 10)
end
funcInfo = GetFuncInfo(W_BTN, "CreateTab")
function funcInfo.showFunc(widget)
  local tabName = {
    "AAA",
    "BBB",
    "CCC"
  }
  widget:AddTabs(tabName)
end
funcInfo = GetFuncInfo(W_BTN, "CreateImageTab")
function funcInfo.showFunc(widget)
  local tabInfos = {
    {
      tooltip = GetUIText(COMMON_TEXT, "grade_enchant"),
      buttonStyle = BUTTON_CONTENTS.ENCHANT_TAB_GRADE
    },
    {
      tooltip = GetUIText(COMMON_TEXT, "socket"),
      buttonStyle = BUTTON_CONTENTS.ENCHANT_TAB_SOCKET
    },
    {
      tooltip = GetUIText(COMMON_TEXT, "gem_enchant"),
      buttonStyle = BUTTON_CONTENTS.ENCHANT_TAB_GEM
    }
  }
  widget:AddTabs(tabInfos)
end
funcInfo = GetFuncInfo(W_ICON, "CreateLeaderMark")
function funcInfo.showFunc(widget)
  widget:SetMarkTexture("leader")
end
funcInfo = GetFuncInfo(W_CTRL, "CreateEdit")
function funcInfo.showFunc(widget)
  widget:SetExtent(100, DEFAULT_SIZE.EDIT_HEIGHT)
end
funcInfo = GetFuncInfo(W_CTRL, "CreateMultiLineEdit")
function funcInfo.showFunc(widget)
  widget:SetExtent(150, 150)
end
funcInfo = GetFuncInfo(W_CTRL, "CreateList")
function funcInfo.showFunc(widget)
  widget:AppendItem("AAA", 1)
  widget:AppendItem("BBBB", 2)
  widget:AppendItem("CCCCC", 3)
  widget:AppendItem("DDDDDD", 4)
  widget:SetExtent(100, 150)
end
funcInfo = GetFuncInfo(W_CTRL, "CreateScrollListBox")
function funcInfo.showFunc(widget)
  widget:AppendItem("S_AAA", 1)
  widget:AppendItem("S_BBBB", 2)
  widget:AppendItem("S_CCCCC", 3)
  widget:AppendItem("S_DDDDDD", 4)
  widget:SetExtent(100, 150)
end
