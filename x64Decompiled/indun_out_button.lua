local zoneNameInformer = GetIndicators().zoneNameInformer
local indunOutBtn
local function SetViewIndunOutButton()
  local indunOutBtn = UIParent:CreateWidget("button", "indunOutBtn", "UIParent")
  ApplyButtonSkin(indunOutBtn, BUTTON_HUD.ARCHE_MALL_OUT)
  indunOutBtn:EnableHidingIsRemove(true)
  zoneNameInformer:Attach(indunOutBtn)
  indunOutBtn:Show(true)
  return indunOutBtn
end
local function ShowIndunOutButton()
  if not X2Indun:IsEntranceIndunMatch() then
    if indunOutBtn ~= nil then
      indunOutBtn:Show(false)
    end
    return
  end
  if zoneNameInformer == nil then
    return
  end
  if indunOutBtn == nil then
    indunOutBtn = SetViewIndunOutButton()
    local function OnHide()
      indunOutBtn = nil
      zoneNameInformer:Detach()
    end
    indunOutBtn:SetHandler("OnHide", OnHide)
    local LeftClickFunc = function()
      local DialogHandler = function(wnd)
        wnd:SetTitle(GetCommonText("exit_indun_dlg_title"))
        wnd:SetContent(GetCommonText("dialog_indun_out_content"))
        function wnd:OkProc()
          X2Indun:AskLeaveInstantGame()
        end
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, "UIParent")
    end
    ButtonOnClickHandler(indunOutBtn, LeftClickFunc)
    local OnEnter = function(self)
      SetTargetAnchorTooltip(GetCommonText("indun_out_btn_tooltip"), "TOPRIGHT", self, "TOPLEFT", 0, 0)
    end
    indunOutBtn:SetHandler("OnEnter", OnEnter)
    local OnLeave = function()
      HideTooltip()
    end
    indunOutBtn:SetHandler("OnLeave", OnLeave)
  end
end
UIParent:SetEventHandler("LEFT_LOADING", ShowIndunOutButton)
UIParent:SetEventHandler("ENTERED_WORLD", ShowIndunOutButton)
