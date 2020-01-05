function CreateBlockTabWindow(window)
  SetViewOfBlockTabWindow(window)
  local MAX_COUNT = 10
  BLOCK_COL = {NAME = 1}
  local frame = window.frame
  local listCtrl = window.frame.listCtrl
  local inputName = window.inputName
  local addBlockButton = window.addBlockButton
  function inputName:OnTextChanged()
    self:CheckNamePolicy(VNT_CHAR)
    local name = self:GetText()
    if string.len(name) >= 1 then
      addBlockButton:Enable(true)
    else
      addBlockButton:Enable(false)
    end
  end
  inputName:SetHandler("OnTextChanged", inputName.OnTextChanged)
  function addBlockButton:OnClick()
    local name = inputName:GetText()
    if name == "" then
      X2Chat:DispatchChatMessage(CMF_BLOCK_INFO, "no add block pc name")
    else
      X2Friend:BlockUser(name)
      inputName:SetText("")
    end
  end
  addBlockButton:SetHandler("OnClick", addBlockButton.OnClick)
  function window:OnShow()
    inputName:SetText("")
    addBlockButton:Enable(false)
  end
  window:SetHandler("OnShow", window.OnShow)
  function window:FillMemberData()
    frame:DeleteAllDatas()
    local members, totalMembers = X2Friend:GetBlockList()
    if members == nil then
      return
    end
    for i = 1, totalMembers do
      if i == totalMembers then
        frame:InsertData(i, 1, members[i], true)
      else
        frame:InsertData(i, 1, members[i], false)
      end
    end
  end
  for i = 1, MAX_COUNT do
    do
      local item = listCtrl.items[i]
      function item:OnClick(arg)
        if arg == "RightButton" then
          local data = frame:GetDataByViewIndex(i, 1)
          ActivateBlockMemberPopupMenu(self, data[BLOCK_COL.NAME])
        end
      end
      item:SetHandler("OnClick", item.OnClick)
    end
  end
  window:FillMemberData()
  local blockEvents = {
    BLOCKED_USER_UPDATE = function()
      window:FillMemberData()
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    blockEvents[event](...)
  end)
  window:RegisterEvent("BLOCKED_USER_UPDATE")
end
