local info = {
  {
    image = {
      path = TEXTURE_PATH.RAID_TYPE_ICON,
      key = "icon_attacker",
      anchor = "left"
    },
    value = TMROLE_DEALER,
    fontColor = FONT_COLOR.ROLE_DEALER,
    text = locale.role.dealer
  },
  {
    image = {
      path = TEXTURE_PATH.RAID_TYPE_ICON,
      key = "icon_tanker",
      anchor = "left"
    },
    value = TMROLE_TANKER,
    fontColor = FONT_COLOR.ROLE_TANKER,
    text = locale.role.tanker
  },
  {
    image = {
      path = TEXTURE_PATH.RAID_TYPE_ICON,
      key = "icon_healer",
      anchor = "left"
    },
    value = TMROLE_HEALER,
    fontColor = FONT_COLOR.ROLE_HEALER,
    text = locale.role.healer
  },
  {
    value = TMROLE_NONE,
    fontColor = FONT_COLOR.ROLE_NONE,
    text = locale.role.norole
  }
}
function W_MODULE:GetRoleInfo()
  return info
end
function W_MODULE:GetRoleInfoByRole(role)
  for i, v in ipairs(info) do
    if v.value == role then
      return v
    end
  end
end
local function SetViewRoleFrame(id, parent)
  local window = CreateSubOptionWindow(id, parent)
  local iconWidth = 20
  local radioBtn = CreateRadioGroup("radioBtn", window, "vertical")
  radioBtn:SetAutoWidth(true)
  radioBtn:AddAnchor("TOPLEFT", window, MARGIN.WINDOW_SIDE / 1.5, MARGIN.WINDOW_SIDE * 1.5)
  radioBtn:SetData(info)
  window.radioBtn = radioBtn
  window:SetExtent(MARGIN.WINDOW_SIDE * 1.3 + radioBtn:GetWidth(), radioBtn:GetHeight() + window.closeButton:GetWidth() + MARGIN.WINDOW_SIDE)
  return window
end
function CreateRoleFrame(id, parent)
  local frame = SetViewRoleFrame(id, parent)
  local function OnShow(self)
    local myRole = 0
    if frame.GetMyRole ~= nil then
      myRole = self:GetMyRole()
    end
    local datas = self.radioBtn:GetData()
    for i, v in ipairs(datas) do
      if v.value == myRole then
        self.radioBtn:Check(i, false)
        break
      end
    end
  end
  frame:SetHandler("OnShow", OnShow)
  local function OnRadioChanged(self, index, dataValue)
    if frame.SetMyRole ~= nil then
      frame:SetMyRole(dataValue)
    end
  end
  frame.radioBtn:SetHandler("OnRadioChanged", OnRadioChanged)
  return frame
end
function CreateRoleLabel(id, parent)
  local ICON_INSET = 5
  local label = parent:CreateChildWidget("label", id, 0, true)
  label:SetAutoResize(true)
  label:SetHeight(FONT_SIZE.MIDDLE)
  local icon = label:CreateDrawable(TEXTURE_PATH.RAID_TYPE_ICON, "icon_healer", "background")
  icon:AddAnchor("LEFT", label, 0, 0)
  function label:SetRole(role)
    local info = W_MODULE:GetRoleInfoByRole(role)
    ApplyTextColor(self, info.fontColor)
    if role == TMROLE_NONE then
      icon:SetVisible(false)
      label:SetInset(0, 0, 0, 0)
    else
      icon:SetVisible(true)
      icon:SetTextureInfo(info.image.key)
      label:SetInset(icon:GetWidth() + ICON_INSET, 0, 0, 0)
    end
    label:SetText(info.text)
  end
  return label
end
