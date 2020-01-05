local MAX_RADIO_COLUMN_COUNT = 100
local FRAME_AUTO_WIDTH = {
  vertical = false,
  horizen = true,
  grid = false
}
RADIO_TEXTURE_TYPE = {DEFAULT = 1}
local RADIO_TEXTURE_TYPE_DATA = {
  [RADIO_TEXTURE_TYPE.DEFAULT] = {
    path = TEXTURE_PATH.DEFAULT,
    key = "radio_button"
  }
}
local GetRadioGroupMaxRowWidth = function(firstInRow, lastInRow)
  local startX, _ = firstInRow:GetOffset()
  local endX, _ = lastInRow:GetOffset()
  endX = endX + lastInRow:GetWidth()
  return math.max(0, endX - startX)
end
local SetAutoTextWidth = function(text, state)
  if state == true then
    text:SetAutoResize(true)
    text:SetAutoWordwrap(false)
  else
    text:SetAutoResize(true)
    text:SetAutoWordwrap(true)
  end
end
local function SetRadioButtonStyle(checkButton, radioTextureType)
  local path = TEXTURE_PATH.DEFAULT
  local key = "radio_button"
  if radioTextureType ~= nil and radioTextureType ~= RADIO_TEXTURE_TYPE.DEFAULT then
    path = RADIO_TEXTURE_TYPE_DATA[radioTextureType].path
    key = RADIO_TEXTURE_TYPE_DATA[radioTextureType].key
  end
  CreateButtonBackGround(checkButton, "drawable", path, "background", 6)
  checkButton.bgs[1]:SetTextureInfo(string.format("%s_df", key))
  checkButton.bgs[2]:SetTextureInfo(string.format("%s_ov", key))
  checkButton.bgs[3]:SetTextureInfo(string.format("%s_on", key))
  checkButton.bgs[4]:SetTextureInfo(string.format("%s_dis", key))
  checkButton.bgs[5]:SetTextureInfo(string.format("%s_chk_df", key))
  checkButton.bgs[6]:SetTextureInfo(string.format("%s_chk_dis", key))
  local coords = {
    GetTextureInfo(path, string.format("%s_df", key)):GetCoords()
  }
  checkButton:SetExtent(coords[3], coords[4])
  SetButtonBackground(checkButton)
end
local function CreateRadioItem(radioGroup, index, data)
  local dataValue = data.value
  if dataValue == nil then
    dataValue = index
  end
  local radioItemFrame = radioGroup:CreateRadioItem(dataValue)
  if radioItemFrame == nil then
    return nil
  end
  local radio = radioItemFrame.check
  if radio == nil then
    return nil
  end
  ButtonInit(radio)
  SetRadioButtonStyle(radio, radioGroup.radioTextureType)
  radioItemFrame.fixedWidth = 0
  function radioItemFrame:GetWidthForGroupLayout()
    if radioGroup.autoWidth == true then
      return radioItemFrame:GetWidth()
    end
    return self.fixedWidth
  end
  local inset = 5
  local image
  local imageAnchor = "left"
  if data.image ~= nil and data.image.path ~= nil and data.image.key ~= nil then
    image = radio:CreateDrawable(data.image.path, data.image.key, "background")
    if data.image.anchor then
      imageAnchor = data.image.anchor
    end
  end
  local text = radio:CreateChildWidget("textbox", "text", 0, false)
  text.style:SetAlign(ALIGN_LEFT)
  text.style:SetFontSize(radioGroup.fontSize)
  if data.fontColor == nil then
    ApplyTextColor(text, radioGroup.fontColor)
  else
    ApplyTextColor(text, data.fontColor)
  end
  if data.tooltip then
    local function OnEnter(self)
      SetTooltip(data.tooltip, self)
    end
    text:SetHandler("OnEnter", OnEnter)
  end
  local function RadioClick()
    radioGroup:Check(index, true)
  end
  text:SetHandler("OnClick", RadioClick)
  local function RadioItemImageAnchor()
    if image ~= nil then
      if imageAnchor == "right" then
        image:AddAnchor("LEFT", text, "RIGHT", inset, 0)
      else
        image:AddAnchor("LEFT", radio, "RIGHT", inset, 0)
      end
    end
  end
  local function RadioItemTextAnchor()
    local imageInset = 0
    if image ~= nil and imageAnchor == "left" then
      imageInset = image:GetWidth() + inset
    end
    if text:GetLineCount() == 1 then
      text:AddAnchor("LEFT", radio, "RIGHT", imageInset + inset, 0)
    else
      text:AddAnchor("TOPLEFT", radio, "TOPRIGHT", imageInset + inset, 0)
    end
  end
  local function UpdateRadioItemFrameView()
    local rx, ry = radio:GetOffset()
    local rw, rh = radio:GetExtent()
    local tx, ty = text:GetOffset()
    local tw, th = text:GetExtent()
    local minX = math.min(rx, tx)
    local maxX = math.max(rx + rw, tx + tw)
    local minY = math.min(ry, ty)
    local maxY = math.max(ry + rh, ty + th)
    if image ~= nil then
      local ix, iy = image:GetOffset()
      local iw, ih = image:GetExtent()
      minX = math.min(minX, ix)
      maxX = math.max(maxX, ix + iw)
      minY = math.min(minY, iy)
      maxY = math.max(maxY, iy + ih)
    end
    local fw = maxX - minX
    local fh = maxY - minY
    if fw < 0 then
      fw = 0
    end
    if fh < 0 then
      fh = 0
    end
    radioItemFrame:SetExtent(fw, fh)
    local anchorHeight = minY - ry
    radio:AddAnchor("TOPLEFT", radioItemFrame, "TOPLEFT", 0, anchorHeight)
  end
  local function RadioItemSetText(str)
    if radioGroup.autoWidth == true then
      SetAutoTextWidth(text, true)
    else
      local columnCount = radioGroup:GetMaxColumnCount()
      if columnCount == nil or columnCount <= 0 then
        columnCount = 1
      end
      local gapWidths = (columnCount - 1) * radioGroup.gapWidth
      local remainWidth = radioGroup:GetWidth() - gapWidths - inset
      local radioItemWidth = remainWidth / columnCount
      local textWidth = radioItemWidth - radioItemFrame:GetWidth()
      if image ~= nil then
        textWidth = textWidth - image:GetWidth()
      end
      radioItemFrame.fixedWidth = radioItemWidth
      text:SetWidth(textWidth)
      local strWidth = text.style:GetTextWidth(str)
      if textWidth > strWidth then
        SetAutoTextWidth(text, true)
      else
        SetAutoTextWidth(text, false)
      end
    end
    text:SetText(str)
  end
  local function OnEnableChanged(self, enabled)
    local alpha = enabled and 1 or radioGroup.disableAlpha
    radio:SetAlpha(alpha)
    text:SetAlpha(alpha)
    radio:Enable(enabled)
    text:Enable(enabled)
  end
  radioItemFrame:SetHandler("OnEnableChanged", OnEnableChanged)
  RadioItemSetText(data.text)
  RadioItemImageAnchor()
  RadioItemTextAnchor()
  UpdateRadioItemFrameView()
  return radioItemFrame
end
function CreateRadioGroup(id, parent, radioGroupType)
  local radioGroupFrame = parent:CreateChildWidget("radiogroup", id, 0, true)
  radioGroupFrame:Show(true)
  radioGroupFrame.radioGroupType = radioGroupType
  radioGroupFrame.gapWidth = 5
  radioGroupFrame.gapHeight = 5
  radioGroupFrame.maxColumnCount = 2
  radioGroupFrame.disableAlpha = 0.5
  radioGroupFrame.data = nil
  radioGroupFrame.autoWidth = FRAME_AUTO_WIDTH[radioGroupType]
  radioGroupFrame.radioTextureType = RADIO_TEXTURE_TYPE.DEFAULT
  radioGroupFrame.fontSize = FONT_SIZE.MIDDLE
  radioGroupFrame.fontColor = FONT_COLOR.DEFAULT
  function radioGroupFrame:SetFontColor(color)
    self.fontColor = color
  end
  function radioGroupFrame:SetFontSize(size)
    self.fontSize = size
  end
  function radioGroupFrame:SetRadioTextureType(radioTextureType)
    self.radioTextureType = radioTextureType
  end
  function radioGroupFrame:SetAutoWidth(state)
    self.autoWidth = state
  end
  function radioGroupFrame:SetMaxColumnCount(cnt)
    self.maxColumnCount = cnt
  end
  function radioGroupFrame:GetMaxColumnCount()
    local radioGroupType = self.radioGroupType
    if radioGroupType == "vertical" then
      return 1
    elseif radioGroupType == "horizen" then
      return #self.data
    end
    return self.maxColumnCount
  end
  function radioGroupFrame:SetGap(w, h)
    self:SetGapWidth(w)
    self:SetGapHeight(h)
  end
  function radioGroupFrame:SetGapWidth(w)
    self.gapWidth = w
  end
  function radioGroupFrame:SetGapHeight(h)
    self.gapHeight = h
  end
  function radioGroupFrame:SetDisableAlphaValue(value)
    self.disableAlpha = value
  end
  function radioGroupFrame:AnchorItems()
    if #self.items == 0 then
      return
    end
    local columnCount = self:GetMaxColumnCount()
    local autoWidth = self.autoWidth
    local maxRowWidth = 0
    local maxRowHeight = 0
    local _, startY = self:GetOffset()
    local maxEndY = startY
    local prev, firstInRow, lastInRow
    for i = 1, #self.items do
      local radioItem = self.items[i]
      if prev == nil then
        radioItem:AddAnchor("TOPLEFT", self, 0, 0)
        firstInRow = radioItem
      elseif (i - 1) % columnCount ~= 0 then
        local anchorWidth = prev:GetWidthForGroupLayout() + self.gapWidth
        radioItem:AddAnchor("TOPLEFT", prev, anchorWidth, 0)
      else
        local anchorHeight = maxRowHeight + self.gapHeight
        radioItem:AddAnchor("TOPLEFT", firstInRow, 0, anchorHeight)
        local rowWidth = GetRadioGroupMaxRowWidth(firstInRow, lastInRow)
        maxRowWidth = math.max(maxRowWidth, rowWidth)
        firstInRow = radioItem
        maxRowHeight = 0
      end
      prev = radioItem
      lastInRow = radioItem
      maxRowHeight = math.max(maxRowHeight, radioItem:GetHeight())
      local _, itemEndY = radioItem:GetOffset()
      itemEndY = itemEndY + radioItem:GetHeight()
      maxEndY = math.max(maxEndY, itemEndY)
    end
    if autoWidth == true then
      local rowWidth = GetRadioGroupMaxRowWidth(firstInRow, lastInRow)
      maxRowWidth = math.max(maxRowWidth, rowWidth)
      self:SetWidth(maxRowWidth)
    end
    self:SetHeight(math.max(0, maxEndY - startY))
  end
  function radioGroupFrame:GetData()
    return self.data
  end
  function radioGroupFrame:SetData(data)
    if data == nil or type(data) ~= "table" or #data == 0 then
      return
    end
    radioGroupFrame:Clear()
    self.data = data
    self.items = {}
    for i = 1, #data do
      local radioItem = CreateRadioItem(self, i, data[i])
      if radioItem == nil then
        UIParent:LogAlways(string.format("UIERROR : can not create a radio item.(%d)", i))
        return
      end
      table.insert(self.items, radioItem)
    end
    self:AnchorItems()
  end
  local OnEnableChanged = function(self, enabled)
    for i = 1, #self.items do
      local radioItem = self.items[i]
      radioItem:Enable(enabled, true)
    end
  end
  radioGroupFrame:SetHandler("OnEnableChanged", OnEnableChanged)
  return radioGroupFrame
end
