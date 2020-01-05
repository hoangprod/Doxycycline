local CreateDefaultDrawable = function(widget, type, path, layer)
  layer = layer or "background"
  local bg
  if type == "threePart" then
    bg = widget:CreateThreePartDrawable(path, layer)
  end
  if type == "drawable" then
    bg = widget:CreateImageDrawable(path, layer)
  end
  if type == "ninePart" then
    bg = widget:CreateNinePartDrawable(path, layer)
  end
  return bg
end
function CreateCheckButtonBackGround(button, path, drawableType, count)
  button.bgs = {}
  for i = 1, count or 4 do
    button.bgs[i] = CreateDefaultDrawable(button, drawableType, path)
    button.bgs[i]:SetExtent(16, 16)
    button.bgs[i]:AddAnchor("CENTER", button, 0, 0)
    if button.bgs[i].SetTexture ~= nil then
      button.bgs[i]:SetTexture(path)
    end
  end
end
function SetViewOfCheckButton(id, parent, text, path)
  local button = UIParent:CreateWidget("checkbutton", id, parent)
  if path == nil then
    CreateCheckButtonBackGround(button, "ui/button/check_button.dds", "drawable", 6)
  else
    CreateCheckButtonBackGround(button, path, "drawable", 6)
  end
  if text ~= nil then
    local textButton = CreateEmptyButton(id .. ".textButton", button)
    textButton:AddAnchor("LEFT", button, "RIGHT", 0, 0)
    ButtonInit(textButton)
    textButton:SetAutoResize(true)
    textButton:SetHeight(16)
    textButton:SetText(text)
    textButton.style:SetAlign(ALIGN_LEFT)
    button.textButton = textButton
  end
  function button:SetButtonStyle(style)
    local coords = {}
    if style == "eyeShape" then
      if self.textButton ~= nil then
        self.textButton:RemoveAllAnchors()
        self.textButton:AddAnchor("RIGHT", button, "LEFT", -5, 0)
        SetButtonFontColor(self.textButton, GetDefaultCheckButtonFontColor())
      end
      self:SetExtent(GetTextureInfo(TEXTURE_PATH.CHECK_EYE_SHAPE, "eye_btn_df"):GetWidth(), GetTextureInfo(TEXTURE_PATH.CHECK_EYE_SHAPE, "eye_btn_df"):GetHeight())
      coords[1] = {
        GetTextureInfo(TEXTURE_PATH.CHECK_EYE_SHAPE, "eye_btn_df"):GetCoords()
      }
      coords[2] = {
        GetTextureInfo(TEXTURE_PATH.CHECK_EYE_SHAPE, "eye_btn_df"):GetCoords()
      }
      coords[3] = {
        GetTextureInfo(TEXTURE_PATH.CHECK_EYE_SHAPE, "eye_btn_df"):GetCoords()
      }
      coords[4] = {
        GetTextureInfo(TEXTURE_PATH.CHECK_EYE_SHAPE, "eye_btn_dis"):GetCoords()
      }
      coords[5] = {
        GetTextureInfo(TEXTURE_PATH.CHECK_EYE_SHAPE, "eye_btn_sel"):GetCoords()
      }
      coords[6] = {
        GetTextureInfo(TEXTURE_PATH.CHECK_EYE_SHAPE, "eye_btn_dis"):GetCoords()
      }
    elseif style == "soft_brown" then
      if self.textButton ~= nil then
        self.textButton:RemoveAllAnchors()
        self.textButton:AddAnchor("LEFT", button, "RIGHT", 0, 0)
        SetButtonFontColor(self.textButton, GetSoftCheckButtonFontColor())
      end
      self:SetExtent(GetTextureInfo("ui/button/check_button.dds", "btn_df"):GetWidth(), GetTextureInfo("ui/button/check_button.dds", "btn_df"):GetHeight())
      coords[1] = {
        GetTextureInfo("ui/button/check_button.dds", "btn_df"):GetCoords()
      }
      coords[2] = {
        GetTextureInfo("ui/button/check_button.dds", "btn_ov"):GetCoords()
      }
      coords[3] = {
        GetTextureInfo("ui/button/check_button.dds", "btn_on"):GetCoords()
      }
      coords[4] = {
        GetTextureInfo("ui/button/check_button.dds", "btn_dis"):GetCoords()
      }
      coords[5] = {
        GetTextureInfo("ui/button/check_button.dds", "btn_chk_df"):GetCoords()
      }
      coords[6] = {
        GetTextureInfo("ui/button/check_button.dds", "btn_chk_dis"):GetCoords()
      }
    elseif style == "quest_notifier" then
      if self.textButton ~= nil then
        self.textButton:RemoveAllAnchors()
        self.textButton:AddAnchor("LEFT", button, "RIGHT", 0, 0)
        SetButtonFontColor(self.textButton, GetDefaultCheckButtonFontColor())
      end
      self:SetExtent(18, 17)
      coords[1] = {
        57,
        54,
        7,
        10
      }
      coords[2] = {
        0,
        0,
        18,
        17
      }
      coords[3] = {
        0,
        0,
        18,
        17
      }
      coords[4] = {
        0,
        17,
        18,
        17
      }
      coords[5] = {
        18,
        0,
        18,
        17
      }
      coords[6] = {
        18,
        17,
        18,
        17
      }
    elseif style == "tutorial" then
      if self.textButton ~= nil then
        self.textButton:RemoveAllAnchors()
        self.textButton:AddAnchor("LEFT", button, "RIGHT", 0, 0)
        SetButtonFontColor(self.textButton, GetBlackCheckButtonFontColor())
      end
      self:SetExtent(18, 18)
      coords[1] = {
        0,
        0,
        18,
        17
      }
      coords[2] = {
        0,
        0,
        18,
        17
      }
      coords[3] = {
        0,
        0,
        18,
        17
      }
      coords[4] = {
        0,
        17,
        18,
        17
      }
      coords[5] = {
        18,
        0,
        18,
        17
      }
      coords[6] = {
        18,
        17,
        18,
        17
      }
    elseif style == "raid_hud" then
      if self.textButton ~= nil then
        self.textButton.style:SetFontSize(FONT_SIZE.LARGE)
        self.textButton:RemoveAllAnchors()
        self.textButton:AddAnchor("RIGHT", button, -5, 4)
        SetButtonFontColor(self.textButton, GetWhiteCheckButtonFontColor())
      end
      self:SetExtent(GetTextureInfo("ui/hud/raid_tab.dds", "raid_tab_df"):GetWidth(), GetTextureInfo("ui/hud/raid_tab.dds", "raid_tab_df"):GetHeight())
      coords[1] = {
        GetTextureInfo("ui/hud/raid_tab.dds", "raid_tab_df"):GetCoords()
      }
      coords[2] = {
        GetTextureInfo("ui/hud/raid_tab.dds", "raid_tab_ov"):GetCoords()
      }
      coords[3] = {
        GetTextureInfo("ui/hud/raid_tab.dds", "raid_tab_on"):GetCoords()
      }
      coords[4] = {
        GetTextureInfo("ui/hud/raid_tab.dds", "raid_tab_dis"):GetCoords()
      }
      coords[5] = {
        GetTextureInfo("ui/hud/raid_tab.dds", "raid_tab_chk"):GetCoords()
      }
      coords[6] = {
        GetTextureInfo("ui/hud/raid_tab.dds", "raid_tab_dis"):GetCoords()
      }
    else
      if self.textButton ~= nil then
        self.textButton:RemoveAllAnchors()
        self.textButton:AddAnchor("LEFT", button, "RIGHT", 0, 0)
        SetButtonFontColor(self.textButton, GetDefaultCheckButtonFontColor())
      end
      self:SetExtent(GetTextureInfo("ui/button/check_button.dds", "btn_df"):GetWidth(), GetTextureInfo("ui/button/check_button.dds", "btn_df"):GetHeight())
      coords[1] = {
        GetTextureInfo("ui/button/check_button.dds", "btn_df"):GetCoords()
      }
      coords[2] = {
        GetTextureInfo("ui/button/check_button.dds", "btn_ov"):GetCoords()
      }
      coords[3] = {
        GetTextureInfo("ui/button/check_button.dds", "btn_on"):GetCoords()
      }
      coords[4] = {
        GetTextureInfo("ui/button/check_button.dds", "btn_dis"):GetCoords()
      }
      coords[5] = {
        GetTextureInfo("ui/button/check_button.dds", "btn_chk_df"):GetCoords()
      }
      coords[6] = {
        GetTextureInfo("ui/button/check_button.dds", "btn_chk_dis"):GetCoords()
      }
    end
    for i = 1, #coords do
      SetButtonBackground(button)
      SetButtonCoordsForBg(button, button.bgs[i], coords[i])
    end
  end
  button:SetButtonStyle(nil)
  SetButtonBackground(button)
  return button
end
function CreateCheckButton(id, parent, text, path)
  local button = SetViewOfCheckButton(id, parent, text, path)
  function button:SetEnableCheckButton(enable)
    self:Enable(enable, true)
    if self.textButton ~= nil then
      self.textButton:Enable(enable)
    end
  end
  function button:OnCheckChanged()
    if self.CheckBtnCheckChagnedProc ~= nil then
      self:CheckBtnCheckChagnedProc(self:GetChecked())
    end
  end
  button:SetHandler("OnCheckChanged", button.OnCheckChanged)
  if button.textButton ~= nil then
    function button.textButton:OnClick()
      if button:IsEnabled() then
        button:SetChecked(not button:GetChecked())
      end
    end
    button.textButton:SetHandler("OnClick", button.textButton.OnClick)
  end
  return button
end
