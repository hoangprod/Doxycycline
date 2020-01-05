local inactivateAlphaValue = 0.6
local activateAlphaValue = 1
function SetViewOfMegaphoneFrame(id, parent)
  local frame = UIParent:CreateWidget("window", id, parent)
  frame:SetExtent(487, 125)
  frame:SetAlpha(inactivateAlphaValue)
  frame:EnableDrag(true)
  frame.showMessage = false
  local textureInfo = GetTextureInfo(TEXTURE_PATH.MEGAPHONE_CHAT, "frame_light")
  local effect = frame:CreateEffectDrawable(TEXTURE_PATH.MEGAPHONE_CHAT, "overlay")
  effect:SetInternalDrawType("ninepart")
  effect:SetCoords(textureInfo:GetCoords())
  local inset = textureInfo:GetInset()
  effect:SetInset(inset[1], inset[2], inset[3], inset[4])
  effect:SetExtent(textureInfo:GetExtent())
  effect:SetVisible(true)
  local bg = frame:CreateNinePartDrawable(TEXTURE_PATH.MEGAPHONE_CHAT, "background")
  bg:SetTextureInfo("frame")
  bg:AddAnchor("TOPLEFT", frame, 0, 0)
  effect:AddAnchor("CENTER", bg, -2, 2)
  frame.allDrawableAnimInfos = {
    {
      effectDrawable = effect,
      animData = {
        {
          startTime = 0.5,
          playTime = 0.2,
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              1
            }
          }
        },
        {
          startTime = 0.7,
          playTime = 0.2,
          color = {
            {
              1,
              1,
              1,
              1
            },
            {
              1,
              1,
              1,
              0
            }
          }
        },
        {
          startTime = 0.9,
          playTime = 0.2,
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              1
            }
          }
        },
        {
          startTime = 1.1,
          playTime = 0.2,
          color = {
            {
              1,
              1,
              1,
              1
            },
            {
              1,
              1,
              1,
              0
            }
          }
        },
        {
          startTime = 1.3,
          playTime = 0.2,
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              1
            }
          }
        },
        {
          startTime = 1.5,
          playTime = 0.2,
          color = {
            {
              1,
              1,
              1,
              1
            },
            {
              1,
              1,
              1,
              0
            }
          }
        },
        {
          startTime = 1.7,
          playTime = 0.2,
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              1
            }
          }
        },
        {
          startTime = 1.9,
          playTime = 0.2,
          color = {
            {
              1,
              1,
              1,
              1
            },
            {
              1,
              1,
              1,
              0
            }
          }
        },
        {
          startTime = 2.1,
          playTime = 0.2,
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              1
            }
          }
        },
        {
          startTime = 2.3,
          playTime = 0.2,
          color = {
            {
              1,
              1,
              1,
              1
            },
            {
              1,
              1,
              1,
              0
            }
          }
        }
      }
    }
  }
  F_ANIMATION.SetEffectDrawableAnimInfos(frame.allDrawableAnimInfos)
  local icon = frame:CreateImageDrawable(TEXTURE_PATH.MEGAPHONE_CHAT, "artwork")
  icon:SetExtent(22, 18)
  icon:AddAnchor("TOPLEFT", frame, 20, 20)
  icon:SetVisible(false)
  frame.icon = icon
  local guide = W_ICON.CreateGuideIconWidget(frame)
  guide:AddAnchor("TOP", icon, "BOTTOM", 0, 5)
  local OnEnter = function(self)
    SetTooltip(GetCommonText("megaphone_chat_tooltip"), self)
  end
  guide:SetHandler("OnEnter", OnEnter)
  local contentWidth = frame:GetWidth() - icon:GetWidth() - 60
  local name = frame:CreateChildWidget("label", "name", 0, true)
  name:SetExtent(contentWidth, FONT_SIZE.MIDDLE)
  name:AddAnchor("TOPLEFT", icon, "TOPRIGHT", 10, 0)
  name.style:SetAlign(ALIGN_LEFT)
  name:Clickable(false)
  local content = frame:CreateChildWidget("message", "content", 0, true)
  content:SetExtent(contentWidth, 40)
  content:ChangeTextStyle()
  content:SetMaxLines(1)
  content:EnableItemLink(true)
  content:SetTimeVisible(45)
  AddItemLinkHandlerToMessageWidget(content)
  content:AddAnchor("TOPLEFT", name, "BOTTOMLEFT", 0, 10)
  content.style:SetAlign(ALIGN_LEFT)
  content:EnableDrag(true)
  local inputShortcut = frame:CreateChildWidget("label", "inputShortcut", 0, true)
  inputShortcut:SetExtent(90, FONT_SIZE.MIDDLE)
  inputShortcut:AddAnchor("BOTTOMRIGHT", content, -8, 0)
  inputShortcut.style:SetAlign(ALIGN_RIGHT)
  local color = FONT_COLOR.GRAY
  inputShortcut.style:SetColor(color[1], color[2], color[3], color[4])
  inputShortcut:SetText("[Ctrl + Enter]")
  inputShortcut:Clickable(false)
  local editbox = frame:CreateChildWidget("megaphonechatedit", "editbox", 0, true)
  editbox:SetCursorColor(EDITBOX_CURSOR.WHITE[1], EDITBOX_CURSOR.WHITE[2], EDITBOX_CURSOR.WHITE[3], EDITBOX_CURSOR.WHITE[4])
  editbox:AddAnchor("BOTTOMLEFT", frame, "BOTTOMLEFT", 1, 2)
  editbox.style:SetAlign(ALIGN_LEFT)
  DrawChatEditBackground(editbox)
  editbox:Show(false)
  editbox:SetHistoryLines(20)
  local costWnd = editbox:CreateChildWidget("textbox", "costWnd", 0, true)
  costWnd:SetExtent(100, editbox:GetHeight())
  costWnd:SetInset(0, 0, 5, 0)
  costWnd:AddAnchor("RIGHT", editbox, -20, 0)
  costWnd.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(costWnd, FONT_COLOR.WHITE)
  costWnd:Show(false)
  local costIcon = costWnd:CreateImageDrawable(TEXTURE_PATH.MEGAPHONE_CHAT, "artwork")
  costIcon:SetExtent(20, 15)
  costIcon:AddAnchor("LEFT", costWnd, "RIGHT", 0, 0)
  costIcon:SetVisible(false)
  local imeToggleBtn = editbox:CreateChildWidget("button", "imeToggleBtn", 0, true)
  ApplyButtonSkin(imeToggleBtn, BUTTON_HUD.IME_KOREA)
  imeToggleBtn:RemoveAllAnchors()
  imeToggleBtn:AddAnchor("LEFT", editbox, "RIGHT", 0, 1)
  editbox:SetExtent(frame:GetWidth() - imeToggleBtn:GetWidth(), DEFAULT_SIZE.CHAT_EDIT_HEIGHT)
  function imeToggleBtn:UpdateImeMode()
    local inputLanguage = X2Input:GetInputLanguage()
    if inputLanguage == "English" then
      ChangeButtonSkin(imeToggleBtn, BUTTON_HUD.IME_ENGLISH)
    else
      ChangeButtonSkin(imeToggleBtn, BUTTON_HUD.IME_KOREA)
    end
  end
  function imeToggleBtn:OnClick()
    editbox:SetFocus()
    local inputLanguage = X2Input:GetInputLanguage()
    if inputLanguage ~= "English" then
      X2Input:SetInputLanguage("English")
    else
      X2Input:SetInputLanguage("Native")
    end
    self:UpdateImeMode()
  end
  imeToggleBtn:SetHandler("OnClick", imeToggleBtn.OnClick)
  function imeToggleBtn:OnEvent(event)
    self:UpdateImeMode()
  end
  imeToggleBtn:SetHandler("OnEvent", imeToggleBtn.OnEvent)
  imeToggleBtn:RegisterEvent("IME_STATUS_CHANGED")
  imeToggleBtn:UpdateImeMode()
  local chatTypeBtn = editbox:CreateChildWidget("button", "chatTypeBtn", 0, true)
  chatTypeBtn:SetExtent(chatLocale.chatTypeExtent.w, chatLocale.chatTypeExtent.h)
  chatTypeBtn:AddAnchor("LEFT", editbox, 0, 0)
  chatTypeBtn:SetInset(30, 0, 0, 0)
  local icon = chatTypeBtn:CreateImageDrawable(TEXTURE_PATH.MEGAPHONE_CHAT, "artwork")
  icon:SetExtent(25, 20)
  icon:AddAnchor("LEFT", chatTypeBtn, 5, 0)
  editbox:SetInset(chatTypeBtn:GetWidth(), 0, 5, 0)
  local listbox = W_CTRL.CreateList("listbox", editbox)
  listbox:Show(false)
  listbox:AddAnchor("BOTTOMLEFT", chatTypeBtn, "TOPLEFT", 0, 0)
  listbox:SetInset(0, 3, 0, 3)
  listbox:SetExtent(chatTypeBtn:GetWidth(), 50)
  listbox.itemStyle:SetShadow(true)
  local infosByChatType = {}
  local infos = X2Chat:GetMegaphoneChannelInfos()
  for i = 1, #infos do
    local color = infos[i].filterColor
    local chatType = infos[i].chatType
    listbox:AppendItem(infos[i].name, chatType, color[1], color[2], color[3], color[4])
    if chatType == CHAT_BIG_MEGAPHONE then
      infos[i].maxTextLength = 45
      infos[i].iconTextureInfo = "icon_big_megaphone"
      infos[i].menuTextureInfo = "icon_big_megaphone_menu"
      if infos[i].spendItemType ~= 0 then
        infos[i].costItemTextureInfo = "big_megaphone_cost"
        infos[i].costStr = string.format("%d", infos[i].spendItemCount)
      end
    elseif chatType == CHAT_SMALL_MEGAPHONE then
      infos[i].maxTextLength = 35
      infos[i].iconTextureInfo = "icon_small_megaphone"
      infos[i].menuTextureInfo = "icon_small_megaphone_menu"
      if infos[i].spendItemType ~= 0 then
        infos[i].costItemTextureInfo = "small_megaphone_cost"
        infos[i].costStr = string.format("%d", infos[i].spendItemCount)
      end
    end
    infosByChatType[chatType] = infos[i]
  end
  frame.infosByChatType = infosByChatType
  local count = listbox:ItemCount()
  local size = listbox.itemStyle:GetLineHeight() + 3
  local height = count * size + 15
  listbox:SetExtent(listbox:GetWidth(), height)
  listbox:SetStyle("chat")
  function costWnd:SetValue(textureInfo, str, len)
    if textureInfo ~= nil and str ~= nil then
      costIcon:SetTextureInfo(textureInfo)
      costIcon:SetVisible(true)
      costWnd:SetWidth(200)
      costWnd:SetText(str)
      local width = costWnd:GetLongestLineWidth() + 5
      costWnd:SetWidth(width)
      costWnd:Show(true)
      editbox:SetInset(30 + len + 10, 0, 22 + width + 20, 0)
    else
      costWnd:Show(false)
      costIcon:SetVisible(false)
      editbox:SetInset(30 + len + 10, 0, 22, 0)
    end
  end
  function listbox:OnSelChanged()
    local idx = self:GetSelectedIndex()
    self:Select(idx)
    self:Show(false)
    local info = infos[idx + 1]
    icon:SetTextureInfo(info.menuTextureInfo)
    local len = chatTypeBtn.style:GetTextWidth(info.name)
    chatTypeBtn:SetExtent(len + 38, chatLocale.chatTypeExtent.h)
    local color = info.filterColor
    chatTypeBtn:SetTextColor(color[1], color[2], color[3], color[4])
    chatTypeBtn:SetPushedTextColor(color[1], color[2], color[3], color[4])
    chatTypeBtn:SetHighlightTextColor(color[1], color[2], color[3], color[4])
    chatTypeBtn:SetText(info.name)
    editbox:SetMaxTextLength(info.maxTextLength)
    editbox:SetChannel(info.chatType)
    editbox:SetFocus()
    costWnd:SetValue(info.costItemTextureInfo, info.costStr, len)
  end
  listbox:SetHandler("OnSelChanged", listbox.OnSelChanged)
  listbox:Select(0)
  local drag = false
  local timeCheck = 0
  local function OnDragStop()
    drag = false
    frame:StopMovingOrSizing()
    X2Cursor:ClearCursor()
    F_ACTIONBAR.HideAllAnchorTarget()
    F_ACTIONBAR.TryDocking(frame)
    frame:Raise()
  end
  frame:SetHandler("OnDragStop", OnDragStop)
  content:SetHandler("OnDragStop", OnDragStop)
  local function OnUpdate(self, dt)
    timeCheck = timeCheck + dt
    if timeCheck < 100 then
      return
    end
    timeCheck = dt
    if drag then
      local shift = X2Input:IsShiftKeyDown()
      if not shift then
        OnDragStop()
      end
    end
  end
  frame:SetHandler("OnUpdate", OnUpdate)
  local function OnDragStart(self)
    local shift = X2Input:IsShiftKeyDown()
    if shift then
      frame:StartMoving()
      drag = true
      X2Cursor:ClearCursor()
      X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
      F_ACTIONBAR.ReleaseDocking(frame)
      F_ACTIONBAR.ShowAnchorTargetWithoutDocked()
    end
  end
  frame:SetHandler("OnDragStart", OnDragStart)
  content:SetHandler("OnDragStart", OnDragStart)
  local function OnEnter(self)
    self:SetAlpha(activateAlphaValue)
  end
  frame:SetHandler("OnEnter", OnEnter)
  local function OnLeave(self)
    if frame.showMessage == false and frame.editbox:IsVisible() == false then
      self:SetAlpha(inactivateAlphaValue)
    end
  end
  frame:SetHandler("OnLeave", OnLeave)
  return frame
end
function CreateMegaphoneFrame(id, parent)
  local frame = SetViewOfMegaphoneFrame(id, parent)
  local function ChatTypeBtnLeftClickFunc()
    local listbox = frame.editbox.listbox
    listbox:Show(not listbox:IsVisible())
  end
  ButtonOnClickHandler(frame.editbox.chatTypeBtn, ChatTypeBtnLeftClickFunc)
  local events = {
    TOGGLE_MEGAPHONE_CHAT = function()
      if not UIParent:GetPermission(UIC_MEGAPHONE) then
        frame:Show(false)
        return
      end
      if frame.editbox:IsVisible() == true then
        if frame.showMessage == false then
          frame:SetAlpha(inactivateAlphaValue)
        end
        frame.editbox.listbox:Show(false)
        frame.editbox:Show(false)
        frame.editbox:ClearFocus()
      else
        frame:SetAlpha(activateAlphaValue)
        frame.editbox:Show(true)
        frame.editbox:Raise()
        frame.editbox:SetFocus()
      end
    end,
    UI_PERMISSION_UPDATE = function()
      frame:Show(UIParent:GetPermission(UIC_MEGAPHONE))
    end,
    MEGAPHONE_MESSAGE = function(show, channel, name, message, isMyMessage)
      if show == true then
        frame.showMessage = true
        frame:SetAlpha(activateAlphaValue)
        local info = frame.infosByChatType[channel]
        frame.icon:SetTextureInfo(info.iconTextureInfo)
        frame.icon:SetVisible(true)
        if not isMyMessage or not FONT_COLOR.NATION_GREEN then
          local nameColor = {
            248,
            189,
            71,
            255
          }
        end
        frame.name.style:SetColor(nameColor[1], nameColor[2], nameColor[3], nameColor[4])
        frame.name:SetText(string.format("[%s: %s]", info.name, name))
        local color = info.filterColor
        frame.content.style:SetColor(color[1], color[2], color[3], color[4])
        frame.content:AddMessage(message)
        F_ANIMATION.StartEffectDrawableAnimation(nil, frame.allDrawableAnimInfos)
      else
        frame.showMessage = false
        frame:SetAlpha(inactivateAlphaValue)
        frame.icon:SetVisible(false)
        frame.name:SetText("")
        frame.content:Clear("")
      end
    end,
    REQUIRE_ITEM_TO_CHAT = function(channel)
      if channel ~= CHAT_BIG_MEGAPHONE and channel ~= CHAT_SMALL_MEGAPHONE then
        return
      end
      local info = frame.infosByChatType[channel]
      frame.icon:SetTextureInfo(info.iconTextureInfo)
      frame.icon:SetVisible(true)
      if info.spendItemCount > 0 then
        local msgStr = X2Item:GetItemLinkedTextByItemType(info.spendItemType)
        if msgStr ~= nil and info.spendItemCount > 1 then
          msgStr = string.format("%sX%d ", msgStr, info.spendItemCount)
        end
        frame.name:SetText("")
        frame.content:AddMessage(FONT_COLOR_HEX.RED .. GetCommonText("notify_require_for_chat", info.name, msgStr))
        X2Chat:SetMegaphoneWarningMsgState()
        frame.showMessage = true
      end
    end
  }
  frame:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(frame, events)
  return frame
end
if X2Chat:UseMegaphone() == false then
  return
end
local _, offsetY = chatTabWindow[1]:GetOffset()
local megaphoneFrame = CreateMegaphoneFrame("megaphoneFrame", "UIParent")
megaphoneFrame:Show(true)
megaphoneFrame:AddAnchor("TOPLEFT", "UIParent", 0, offsetY - megaphoneFrame:GetHeight())
megaphoneFrame:Raise()
AddUISaveHandlerByKey("megaphone_frame", megaphoneFrame)
megaphoneFrame:ApplyLastWindowOffset()
