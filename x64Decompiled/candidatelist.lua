local CANDIDATES_COUNT = 9
local WINDOW_MARGIN = 10
local CANDIDATE_LABEL_WIDTH = 30
local CANDIDATE_STRING_WIDTH = 100
local CANDIDATE_HEIGHT = 20
local candidateListWnd = CreateEmptyWindow("candidateListWnd", "UIParent")
candidateListWnd:SetExtent(CANDIDATE_LABEL_WIDTH + CANDIDATE_STRING_WIDTH + WINDOW_MARGIN * 2, CANDIDATE_HEIGHT * CANDIDATES_COUNT + WINDOW_MARGIN * 2)
candidateListWnd:AddAnchor("BOTTOMRIGHT", "UIParent", 0, -10)
candidateListWnd:SetUILayer("system")
local bg = candidateListWnd:CreateDrawable(TEXTURE_PATH.HUD, "list_chat_bg", "background")
bg:SetTextureColor("candidate")
bg:AddAnchor("TOPLEFT", candidateListWnd, -1, -10)
bg:AddAnchor("BOTTOMRIGHT", candidateListWnd, 1, 10)
candidateListWnd.idxLabel = {}
candidateListWnd.candidateStringLabel = {}
for i = 1, CANDIDATES_COUNT do
  local idxLabel = W_CTRL.CreateLabel("candidateListWnd.idxLabel[" .. i .. "]", candidateListWnd)
  idxLabel:SetExtent(CANDIDATE_LABEL_WIDTH, CANDIDATE_HEIGHT)
  idxLabel:SetText(tostring(i))
  local candidateStringLabel = W_CTRL.CreateLabel("candidateListWnd.candidateStringLabel[" .. i .. "]", candidateListWnd)
  candidateStringLabel:SetExtent(CANDIDATE_STRING_WIDTH, CANDIDATE_HEIGHT)
  if i == 1 then
    idxLabel:AddAnchor("TOPLEFT", candidateListWnd, "TOPLEFT", 10, 10)
  else
    idxLabel:AddAnchor("TOPLEFT", candidateListWnd.idxLabel[i - 1], "BOTTOMLEFT", 0, 0)
  end
  candidateStringLabel:AddAnchor("TOPLEFT", idxLabel, "TOPRIGHT", 0, 0)
  candidateListWnd.idxLabel[i] = idxLabel
  candidateListWnd.candidateStringLabel[i] = candidateStringLabel
end
candidateListWnd:Clickable(false, true)
local candidateListEvent = {
  CANDIDATE_LIST_SHOW = function()
    candidateListWnd:Show(true)
  end,
  CANDIDATE_LIST_HIDE = function()
    candidateListWnd:Show(false)
  end,
  CANDIDATE_LIST_CHANGED = function()
    local retrieveCount = X2:GetCandidateOnceRetrieveCount()
    for i = 1, retrieveCount do
      local candidateString = X2:GetCandidateList(i)
      if candidateString ~= nil and candidateString ~= "" then
        candidateListWnd.candidateStringLabel[i]:SetText(candidateString)
        candidateListWnd.idxLabel[i]:Show(true)
        candidateListWnd.candidateStringLabel[i]:Show(true)
      else
        candidateListWnd.idxLabel[i]:Show(false)
        candidateListWnd.candidateStringLabel[i]:Show(false)
      end
    end
  end,
  CANDIDATE_LIST_SELECTION_CHANGED = function()
    local currentSelected = X2:GetCandidateSelectedIdxOnCurrentPage()
    local retrieveCount = X2:GetCandidateOnceRetrieveCount()
    for i = 1, retrieveCount do
      if i == currentSelected then
        candidateListWnd.idxLabel[i].style:SetColor(0.21, 0.9, 0.59, 1)
        candidateListWnd.candidateStringLabel[i].style:SetColor(0.21, 0.9, 0.59, 1)
      else
        candidateListWnd.idxLabel[i].style:SetColor(1, 1, 1, 1)
        candidateListWnd.candidateStringLabel[i].style:SetColor(1, 1, 1, 1)
      end
    end
  end
}
candidateListWnd:SetHandler("OnEvent", function(this, event, ...)
  candidateListEvent[event](...)
end)
RegistUIEvent(candidateListWnd, candidateListEvent)
