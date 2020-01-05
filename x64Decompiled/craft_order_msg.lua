local message
local function CreateCraftOrderMsg(id, parent)
  local frame = CreateCenterMessageFrame(id, parent, "TYPE5")
  frame:EnableHidingIsRemove(true)
  frame.body:SetText(GetCommonText("complete_craft_order_center_msg"))
  function frame:SetInfo(info)
    local craftType = info.craftType
    local count = info.craftCount
    local grade = info.craftGrade
    local productInfo = X2Craft:GetCraftProductInfo(craftType)
    local pInfo = productInfo[1]
    local pItemInfo = X2Item:GetItemInfoByType(pInfo.itemType, grade)
    frame.itemIcon:SetItemIconImage(pItemInfo)
    if not frame:HasHandler("OnUpdate") then
      frame:SetHandler("OnUpdate", frame.OnUpdate)
    end
  end
  local function OnEndFadeOut()
    message = nil
    StartNextImgEvent()
  end
  frame:SetHandler("OnEndFadeOut", OnEndFadeOut)
  return frame
end
function ShowCraftOrderMsg(info)
  if message == nil then
    message = CreateCraftOrderMsg("craftOrderMsg", systemLayerParent)
  end
  message:SetInfo(info)
  message:Show(true)
  return true
end
