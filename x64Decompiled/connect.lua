local background = CreateEmptyWindow("background", "UIParent")
background:ApplyUIScale(false)
background:SetUILayer("background")
background:AddAnchor("TOPLEFT", "UIParent", 0, 0)
background:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
background:Show(false)
background:Clickable(false)
local gameHealthWnd = CreateGameHealthWnd("gameHealthWnd", "UIParent")
gameHealthWnd:Show(false)
local gameRatingWnd = CreateGameRatingWnd("gameRatingWnd", "UIParent")
gameRatingWnd:Show(false)
local loginWnd = CreateLoginWnd("loginWnd")
loginWnd:Show(false)
local serverWnd = CreateServerWnd("serverWnd")
serverWnd:Show(false)
local menu = CreateMenuWnd("menu", "UIParent")
menu:AddAnchor("TOPRIGHT", background, -20, 20)
menu:Show(true)
local blackBgWidget = UIParent:CreateWidget("emptywidget", "blackBgWidget", "UIParent")
blackBgWidget:AddAnchor("TOPLEFT", background, 0, 0)
blackBgWidget:AddAnchor("BOTTOMRIGHT", background, 0, 0)
local blackBg = blackBgWidget:CreateColorDrawable(0, 0, 0, 1, "background")
blackBg:AddAnchor("TOPLEFT", blackBgWidget, 0, 0)
blackBg:AddAnchor("BOTTOMRIGHT", blackBgWidget, 0, 0)
local stage = X2LoginCharacter:GetCurrentStage()
if stage == STAGE_LOGIN then
  loginWnd:Show(true)
elseif stage == STAGE_SERVER then
  serverWnd:Show(true)
end
local eventHandler = {
  SHOW_HEALTH_NOTICE = function()
    blackBgWidget:Show(false)
    gameHealthWnd:Show(true)
    gameRatingWnd:Show(false)
  end,
  SHOW_GAME_RATING = function()
    blackBgWidget:Show(false)
    gameHealthWnd:Show(false)
    gameRatingWnd:Show(true)
  end,
  ENTERED_LOGIN = function()
    blackBgWidget:Show(false)
    gameHealthWnd:Show(false)
    gameRatingWnd:Show(false)
    loginWnd:Show(true, 500)
    serverWnd:Show(false)
  end,
  LEFT_LOGIN = function()
    blackBgWidget:Show(false)
    gameHealthWnd:Show(false)
    gameRatingWnd:Show(false)
    loginWnd:Show(false, 500)
  end,
  ENTERED_WORLD_SELECT = function()
    blackBgWidget:Show(false)
    gameHealthWnd:Show(false)
    gameRatingWnd:Show(false)
    serverWnd:Show(true, 500)
  end,
  MOVIE_START = function()
    blackBgWidget:Show(true)
  end
}
background:SetHandler("OnEvent", function(this, event, ...)
  eventHandler[event](...)
end)
RegistUIEvent(background, eventHandler)
