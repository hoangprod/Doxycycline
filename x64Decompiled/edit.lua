local AttachMemberFunc = function(edit)
  local textureInfo = {
    default = {},
    disable = {}
  }
  if X2LoginCharacter:GetCurrentStage() == STAGE_WORLD then
    textureInfo.default.path = TEXTURE_PATH.DEFAULT
    textureInfo.default.key = "editbox_df"
  else
    textureInfo.default.path = TEXTURE_PATH.DEFAULT_NEW
    textureInfo.default.key = "enter_box"
  end
  textureInfo.default.fontColor = FONT_COLOR.DEFAULT
  textureInfo.disable.path = TEXTURE_PATH.DEFAULT
  textureInfo.disable.key = "editbox_dis"
  textureInfo.disable.fontColor = F_COLOR.GetColor("off_gray")
  local bg = edit:CreateDrawable(textureInfo.default.path, textureInfo.default.key, "background")
  bg:AddAnchor("TOPLEFT", edit, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", edit, 0, 0)
  edit.bg = bg
  ApplyTextColor(edit, textureInfo.default.fontColor)
  local function OnEnableChanged(self, enabled)
    local target = enabled and textureInfo.default or textureInfo.disable
    bg:SetTexture(target.path)
    bg:SetTextureInfo(target.key)
    ApplyTextColor(self, target.fontColor)
  end
  edit:SetHandler("OnEnableChanged", OnEnableChanged)
  function edit:CreateGuideText(msg, align, inset)
    self:SetGuideText(msg)
    if inset ~= nil then
      self:SetGuideTextInset(inset[1], inset[2], inset[3], inset[4])
    end
    self.guideTextStyle:SetColor(0, 0, 0, 0.5)
    if align == nil then
      align = ALIGN_LEFT
    end
    self.guideTextStyle:SetAlign(align)
    function self:OnTextChanged()
      if self.TextChangedFunc ~= nil then
        self:TextChangedFunc(self)
      end
    end
    self:SetHandler("OnTextChanged", self.OnTextChanged)
  end
end
local function CommonEditInit(edit)
  edit:SetCursorColor(EDITBOX_CURSOR.DEFAULT[1], EDITBOX_CURSOR.DEFAULT[2], EDITBOX_CURSOR.DEFAULT[3], EDITBOX_CURSOR.DEFAULT[4])
  edit.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  baselibLocale:SetEditCursor(edit)
  edit.style:SetSnap(true)
  edit.style:SetShadow(false)
  AttachMemberFunc(edit)
end
function InitEdit(edit)
  CommonEditInit(edit)
  edit:SetInset(5, 5, 5, 5)
  edit:UseSelectAllWhenFocused(true)
  edit.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(edit, FONT_COLOR.TITLE)
end
function W_CTRL.CreateEdit(id, parent)
  local edit = parent:CreateChildWidgetByType(UOT_X2_EDITBOX, id, 0, true)
  InitEdit(edit)
  return edit
end
function W_CTRL.CreateMultiLineEdit(id, parent)
  local edit = parent:CreateChildWidgetByType(UOT_EDITBOX_MULTILINE, id, 0, true)
  local function InitMultiline(edit)
    CommonEditInit(edit)
    edit:SetInset(20, 20, 30, 20)
    edit.style:SetAlign(ALIGN_TOP_LEFT)
  end
  InitMultiline(edit)
  return edit
end
