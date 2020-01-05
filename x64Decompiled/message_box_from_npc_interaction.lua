local w = CreateEmptyWindow("message_box_from_npc_interaction", "UIParent")
local function CreateNpcInteractionMessageBoxHandleWindow(id)
  local wnd = w:CreateChildWidget("window", id, 0, true)
  wnd:Show(false)
  return wnd
end
local ShowErrorMessageBox = function(title, content, parent)
  local function DialogHandler(wnd)
    wnd:SetTitle(title)
    wnd:SetContent(content)
    function wnd:OkProc()
      parent:Show(false)
    end
  end
  X2DialogManager:RequestNoticeDialog(DialogHandler, parent:GetId())
end
local wnd = CreateNpcInteractionMessageBoxHandleWindow("stabler")
function wnd:OnShow()
  local cost = X2:GetTotalRepairsForPetItems()
  if cost == 0 then
    local title = locale.stabler.title
    local content = string.format("%s", locale.stabler.needPet)
    ShowErrorMessageBox(title, content, wnd)
    return
  end
  local function DialogHandler(dlgWnd)
    dlgWnd:SetTitle(locale.stabler.title)
    dlgWnd:UpdateDialogModule("textbox", GetUIText(STABLER_TEXT, "confirmRevivePet"))
    local data = {type = "cost", value = cost}
    dlgWnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", data)
    function dlgWnd:OkProc()
      X2:RepairPetItems()
      wnd:Show(false)
    end
    function dlgWnd:CancelProc()
      wnd:Show(false)
    end
  end
  X2DialogManager:RequestDefaultDialog(DialogHandler, self:GetId())
end
wnd:SetHandler("OnShow", wnd.OnShow)
w.stabler = wnd
local wnd = CreateNpcInteractionMessageBoxHandleWindow("createExpedition")
ADDON:RegisterContentWidget(UIC_CREATE_EXPEDITION, wnd)
function wnd:OnShow()
  if X2Faction:GetMyExpeditionId() ~= 0 then
    local function DialogHandler(dlgWnd)
      dlgWnd:SetTitle(locale.expedition.creationFailTitle)
      dlgWnd:SetContent(locale.expedition.creationFailMsg)
      function dlgWnd:OkProc()
        wnd:Show(false)
      end
    end
    X2DialogManager:RequestNoticeDialog(DialogHandler, self:GetId())
    return
  end
  local function DialogHandler(dlgWnd)
    dlgWnd:SetTitle(locale.expedition.notificationTitle)
    dlgWnd:SetContent(locale.expedition.notification)
    function dlgWnd:OkProc()
      local alliance = X2Faction:GetMyTopLevelFaction()
      ShowCreateExpedition(true, alliance)
    end
    function dlgWnd:CancelProc()
      wnd:Show(false)
    end
    function dlgWnd:GetOkSound()
      return "message_box_create_expedtion"
    end
  end
  X2DialogManager:RequestDefaultDialog(DialogHandler, self:GetId())
end
wnd:SetHandler("OnShow", wnd.OnShow)
w.createExpedition = wnd
local wnd = CreateNpcInteractionMessageBoxHandleWindow("changeExpeditionName")
ADDON:RegisterContentWidget(UIC_RENAME_EXPEDITION, wnd)
function wnd:OnShow()
  if X2Faction:GetMyExpeditionId() ~= 0 then
    ShowRenameExpedition(true, nil, wnd)
  end
end
wnd:SetHandler("OnShow", wnd.OnShow)
local events = {
  NPC_INTERACTION_END = function()
    if w.stabler:IsVisible() == true then
      w.stabler:Show(false)
    end
    if w.createExpedition:IsVisible() == true then
      w.createExpedition:Show(false)
    end
  end
}
w:SetHandler("OnEvent", function(this, event, ...)
  events[event](...)
end)
RegistUIEvent(w, events)
function GetStablerMessageBoxHandleWindow()
  return w.stabler
end
function GetCreateExpeditionMessageBoxHandleWindow()
  return w.createExpedition
end
