ROADMAP_OFFSET_X = -10
ROADMAP_OFFSET_Y = 50
roadmapWindow = UIParent:CreateWidget("window", "roadmapWindow", "UIParent")
roadmapWindow:SetExtent(926, 556)
roadmapWindow:AddAnchor("TOPRIGHT", "UIParent", ROADMAP_OFFSET_X, ROADMAP_OFFSET_Y)
roadmapWindow:SetUILayer("game")
roadmapWindow:EnableScroll(true)
roadmapWindow:EnablePick(false)
local background = roadmapWindow:CreateNinePartDrawable(TEXTURE_PATH.DEFAULT, "background")
background:AddAnchor("TOPLEFT", roadmapWindow, 0, 0)
background:AddAnchor("BOTTOMRIGHT", roadmapWindow, 0, 0)
background:SetTextureInfo("background", "black")
background:SetVisible(false)
roadmapWindow.background = background
roadmap = UIParent:CreateWidget("roadmap", "roadmap", roadmapWindow)
local playerDrawable = roadmap:CreateDrawable("ui/map/icon/player_cursor.dds", "player_cursor", "overlay")
playerDrawable:SetColor(1, 1, 1, 1)
roadmap:SetPlayerDrawable(playerDrawable)
roadmapWindow.player = playerDrawable
roadmap:AddAnchor("TOPLEFT", roadmapWindow, "TOPLEFT", 0, 0)
roadmap:AddAnchor("BOTTOMRIGHT", roadmapWindow, "BOTTOMRIGHT", 0, 0)
roadmap:SetTooltipColor(M_QUEST_OBJECTIVE_TOOLTIP_COLOR, M_NPC_NICKNAME_TOOLTIP_COLOR)
