local archeMallOutBtn
local function ShowArcheMallOutButton()
  if not X2World:CanExitArchemall() then
    if archeMallOutBtn ~= nil then
      archeMallOutBtn:Show(false)
    end
    return
  end
  local zoneNameInformer = GetIndicators().zoneNameInformer
  if zoneNameInformer == nil then
    return
  end
  if archeMallOutBtn == nil then
    archeMallOutBtn = UIParent:CreateWidget("button", "archeMallOutBtn", "UIParent")
    ApplyButtonSkin(archeMallOutBtn, BUTTON_HUD.ARCHE_MALL_OUT)
    archeMallOutBtn:EnableHidingIsRemove(true)
    local function OnHide()
      archeMallOutBtn = nil
      zoneNameInformer:Detach()
    end
    archeMallOutBtn:SetHandler("OnHide", OnHide)
    local LeftClickFunc = function()
      local DialogHandler = function(wnd)
        wnd:SetTitle(GetCommonText("dialog_arche_mall_out_title"))
        wnd:SetContent(GetCommonText("dialog_arche_mall_out_content"))
        function wnd:OkProc()
          X2World:ExitArchemall()
        end
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, "UIParent")
    end
    ButtonOnClickHandler(archeMallOutBtn, LeftClickFunc)
    local OnEnter = function(self)
      SetTargetAnchorTooltip(GetCommonText("arche_mall_out_btn_tooltip"), "TOPRIGHT", self, "TOPLEFT", 0, 0)
    end
    archeMallOutBtn:SetHandler("OnEnter", OnEnter)
    local OnLeave = function()
      HideTooltip()
    end
    archeMallOutBtn:SetHandler("OnLeave", OnLeave)
  end
  archeMallOutBtn:Show(true)
  zoneNameInformer:Attach(archeMallOutBtn)
end
UIParent:SetEventHandler("LEFT_LOADING", ShowArcheMallOutButton)
UIParent:SetEventHandler("ENTERED_WORLD", ShowArcheMallOutButton)
