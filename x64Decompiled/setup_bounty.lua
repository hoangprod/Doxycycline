local BOUNTY_TARGET_ID = "0"
local BOUNTY_TARGET_NAME = ""
function CreateSetupBountyWindow(id, parent)
  local wnd = CreateWindow(id, parent)
  wnd:SetCloseOnEscape(false)
  wnd:SetExtent(POPUP_WINDOW_WIDTH, 240)
  wnd:SetTitle(locale.trial.bountyTitle)
  local bountyContent = wnd:CreateChildWidget("label", "bountyContent", 0, true)
  bountyContent:SetAutoResize(true)
  bountyContent:SetHeight(FONT_SIZE.LARGE)
  bountyContent:AddAnchor("TOP", wnd, 0, titleMargin)
  bountyContent.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(bountyContent, FONT_COLOR.DEFAULT)
  local moneyEditsWindow = W_MONEY.CreateMoneyEditsWindow(wnd:GetId() .. ".moneyEditsWindow", wnd)
  moneyEditsWindow:AddAnchor("TOP", bountyContent, "BOTTOM", 0, sideMargin / 2)
  wnd.moneyEditsWindow = moneyEditsWindow
  local balanceText = wnd:CreateChildWidget("label", "balanceText", 0, true)
  balanceText:SetHeight(FONT_SIZE.LARGE)
  balanceText:SetAutoResize(true)
  balanceText:SetText(locale.trial.balanceText)
  balanceText:AddAnchor("TOP", moneyEditsWindow, "BOTTOM", 0, sideMargin)
  balanceText.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(balanceText, FONT_COLOR.DEFAULT)
  local info = {
    leftButtonStr = GetUIText(TRIAL_TEXT, "add_bounty"),
    leftButtonLeftClickFunc = function()
      local moneyStr = wnd.moneyEditsWindow:GetAmountStr()
      local price = tonumber(moneyStr)
      if BOUNTY_TARGET_ID ~= "0" and BOUNTY_TARGET_NAME ~= "" then
        X2Trial:SendBountyUpdate(BOUNTY_TARGET_ID, BOUNTY_TARGET_NAME, price)
      end
      wnd:Show(false)
    end,
    rightButtonStr = GetUIText(TRIAL_TEXT, "cancel_bounty"),
    rightButtonLeftClickFunc = function()
      wnd:Show(false)
    end
  }
  CreateWindowDefaultTextButtonSet(wnd, info)
  function wnd:FillData(targetName, curBountyMoney)
    local text = locale.trial.bountyText(targetName)
    self.bountyContent:SetText(text)
  end
  local function OnHide()
    userTrial.setupBountyWnd = nil
    BOUNTY_TARGET_ID = "0"
    BOUNTY_TARGET_NAME = ""
    wnd.bountyContent:SetText("")
  end
  wnd:SetHandler("OnHide", OnHide)
  return wnd
end
function ShowSetupBountyWindow(targetId, targetName, curBountyMoney)
  BOUNTY_TARGET_ID = targetId
  BOUNTY_TARGET_NAME = targetName
  if userTrial.setupBountyWnd == nil then
    userTrial.setupBountyWnd = CreateSetupBountyWindow("userTrial.setupBountyWnd", "UIParent")
  end
  userTrial.setupBountyWnd:FillData(targetName, curBountyMoney)
  userTrial.setupBountyWnd:Show(true)
  userTrial.setupBountyWnd:AddAnchor("TOP", "UIParent", 0, 160)
end
UIParent:SetEventHandler("TOGGLE_BOUNTY_BULLETIN", ShowBountyBulletWindow)
