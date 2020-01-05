local styleTable = {
  default = function(list)
    local bg = list:CreateDrawable(TEXTURE_PATH.DEFAULT, "editbox_df", "background")
    bg:AddAnchor("TOPLEFT", list, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", list, 0, 0)
    list.bg = bg
  end,
  chat = function(list)
    local bg = list:CreateDrawable(TEXTURE_PATH.HUD, "list_chat_bg", "background")
    bg:AddAnchor("TOPLEFT", list, -1, -10)
    bg:AddAnchor("BOTTOMRIGHT", list, 1, 5)
    list.bg = bg
  end,
  use_texture = function(list)
    list:SetListItemStateTexture(TEXTURE_PATH.DEFAULT)
    list:SetListItemStateTextureInset(-15, -2, -10, -1)
    list:SetSelectedItemCoord(353, 995, 190, 29)
    list:SetSelectedItemColor(ConvertColor(73), ConvertColor(114), ConvertColor(188), 0.3)
    list:SetOveredItemCoord(353, 995, 190, 29)
    list:SetOveredItemColor(ConvertColor(73), ConvertColor(114), ConvertColor(188), 0.3)
    list:SetDefaultItemCoord(0, 0, 0, 0)
    list:SetDefaultItemColor(1, 1, 1, 0)
  end
}
local AttachListMemberFunc = function(parent, list)
  function parent:AppendItem(v, k, icon)
    if icon ~= nil then
      list:AppendItem(v, k, icon)
    else
      list:AppendItem(v, k)
    end
    if parent.SetMinMaxValues then
      parent:SetMinMaxValues(0, list:GetMaxTop())
    end
  end
  function parent:AppendItemTailIcon(v, k, icon, coord)
    if icon == nil then
      list:AppendItem(v, k)
    else
      local info = {
        text = v,
        value = k,
        tailIconPath = icon,
        tailIconCoord = coord
      }
      list:AppendItemByTable(info)
    end
  end
  function parent:AppendItemWithColor(v, k, color)
    if color ~= nil then
      list:AppendItem(v, k, color[1], color[2], color[3], color[4])
    else
      list:AppendItem(v, k)
    end
    if parent.SetMinMaxValues then
      parent:SetMinMaxValues(0, list:GetMaxTop())
    end
  end
  function parent:SetItemTrees(tables)
    if tables == nil then
      return
    end
    list:SetItemTrees(tables)
    if parent.SetMinMaxValues then
      parent:SetMinMaxValues(0, list:GetMaxTop())
    end
  end
  function parent:ClearAllSelected()
    list:ClearAllSelected()
  end
  function parent:ClearItem()
    list:ClearItem()
    if parent.scroll then
      parent.scroll.vs:SetMinMaxValues(0, 0)
    end
  end
  function parent:GetSelectedValue()
    return list:GetSelectedValue()
  end
  function parent:GetSelectedIndex()
    return list:GetSelectedIndex() + 1
  end
  function parent:GetSelectedText()
    return list:GetSelectedText()
  end
  function parent:Select(index, notify)
    if notify == nil then
      notify = true
    end
    list:Select(index, notify)
  end
  function parent:ItemCount()
    return list:ItemCount()
  end
  function parent:SetTop(arg)
    list:SetTop(arg)
  end
  function parent:GetTop()
    return list:GetTop()
  end
  function parent:GetMaxTop()
    return list:GetMaxTop()
  end
  function parent:SetItem(idx, name, value, r, g, b, a)
    list:SetItem(idx, name, value, r, g, b, a)
  end
  function parent:SetBorder(arg)
    list:SetBorder(arg)
  end
  function parent:SetLineColor(r, g, b, a)
    list:SetLineColor(r, g, b, a)
  end
  function list:OnSelChanged()
    if parent.SetMinMaxValues then
    end
    if parent.OnSelChanged ~= nil then
      parent:OnSelChanged(self:GetSelectedIndex())
    end
  end
  list:SetHandler("OnSelChanged", list.OnSelChanged)
  function list:OnTooltip(text, posX, posY)
    SetTooltipOnPos(text, self, posX, posY)
  end
  list:SetHandler("OnTooltip", list.OnTooltip)
  function list:OnListboxToggled(self)
    if parent.ProcOnListboxToggled ~= nil then
      parent:ProcOnListboxToggled()
    end
    if parent.SetMinMaxValues then
      parent:SetMinMaxValues(0, list:GetMaxTop())
    end
  end
  list:SetHandler("OnListboxToggled", list.OnListboxToggled)
end
local function AttachMemberFunc(parent, list)
  AttachStyleMemberFunc(list, styleTable)
  AttachListMemberFunc(parent, list)
end
function InitList(list)
  list:SetHeight(8)
  list:SetInset(5, 5, 5, 5)
  list.itemStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  list.itemStyle:SetAlign(ALIGN_LEFT)
  list.itemStyle:SetSnap(true)
  list:SetOveredItemColor(0, 0.5, 1, 0.2)
  list:SetSelectedItemColor(0, 0.3, 0.5, 0.3)
  local color = F_COLOR.GetColor("default")
  list:SetDefaultItemTextColor(color[1], color[2], color[3], color[4])
  color = F_COLOR.GetColor("blue")
  list:SetOveredItemTextColor(color[1], color[2], color[3], color[4])
  list:SetSelectedItemTextColor(color[1], color[2], color[3], color[4])
  color = F_COLOR.GetColor("gray")
  list:SetDisableItemTextColor(color[1], color[2], color[3], color[4])
end
function W_CTRL.CreateList(id, parent)
  local list = parent:CreateChildWidgetByType(UOT_LISTBOX, id, 0, true)
  InitList(list)
  AttachMemberFunc(parent, list)
  return list
end
