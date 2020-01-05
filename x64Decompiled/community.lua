local communityWnd
local function ProcVisibleFrame(idx)
  if idx == nil then
    idx = COMMUNITY.RELATION
  end
  local contentBtns = communityWnd.contentBtns
  local contentFrames = communityWnd.contentFrames
  for i = 1, #contentBtns do
    local isShow = i == idx
    SetBGPushed(contentBtns[i], isShow)
    contentFrames[i]:Show(isShow)
  end
end
local function AttachContentBtnsHandler()
  local contentBtns = communityWnd.contentBtns
  function contentBtns:SetBGPushedOnly(idx)
    for i = 1, #self do
      if i == idx then
        SetBGPushed(self[idx], true, GetCommunityButtonFontColor())
      else
        SetBGPushed(self[i], false, GetCommunityButtonFontColor())
      end
    end
  end
  for i = 1, #contentBtns do
    do
      local cotentBtn = contentBtns[i]
      function cotentBtn:OnClick()
        contentBtns:SetBGPushedOnly(i)
        ProcVisibleFrame(i)
      end
      cotentBtn:SetHandler("OnClick", cotentBtn.OnClick)
    end
  end
end
local function AttachCommunityConetents()
  local contentFrames = communityWnd.contentFrames
  CreateRelationshipFrame("relationshipFrame", contentFrames[COMMUNITY.RELATION])
  CreateFamilyFrame("familyFrame", contentFrames[COMMUNITY.FAMILY])
  CreateExpeditionFrame("expedMgmt", contentFrames[COMMUNITY.EXPEDITION])
  CreateNationFrame("nationFrame", contentFrames[COMMUNITY.NATION])
end
local function CreateCommunityWnd()
  communityWnd = SetViewOfCommunity("communityWnd", "UIParent")
  coolTimeGroup.InitCoolTimeGroup(communityWnd)
  AttachContentBtnsHandler()
  communityWnd:Show(false)
  AttachCommunityConetents()
  function communityWnd:ShowProc()
    X2Team:RaidRecruitList()
  end
  function communityWnd:OnHide()
    for i = 1, #communityWnd.contentFrames do
      if communityWnd.contentFrames[i]:IsVisible() then
        communityWnd.contentFrames[i]:Show(false)
        return
      end
    end
  end
  communityWnd:SetHandler("OnHide", communityWnd.OnHide)
  function communityWnd:OnUpdate(dt)
    coolTimeGroup.UpdateGlobalCoolTime(dt)
  end
  communityWnd.contentBtns:SetBGPushedOnly(1)
  return communityWnd
end
communityWnd = CreateCommunityWnd()
function ToggleCommunityWindow(show, tabIdx)
  if show == nil then
    show = not communityWnd:IsVisible()
  end
  communityWnd:Show(show)
  if communityWnd:IsVisible() then
    ProcVisibleFrame(tabIdx)
  end
end
