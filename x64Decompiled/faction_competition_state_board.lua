local factionCompetitionStateWnd
local CreateFactionCompetitionStateWnd = function()
  local window = CreateFactionCompetitionStateBoardWindow("factionCompetitionStateBoardWnd", "UIParent")
  local function OnShow()
    window:MakeOriginWindowPos()
    AddUISaveHandlerByKey("factionCompetition_state", window)
    window:ApplyLastWindowOffset()
  end
  window:SetHandler("OnShow", OnShow)
  local events = {
    LEFT_LOADING = function()
      window:Show(false)
      X2Map:GetZoneFactionCompetitionInfo()
    end,
    ENTERED_WORLD = function()
      window:Show(false)
      X2Map:GetZoneFactionCompetitionInfo()
    end,
    FACTION_COMPETITION_INFO = function(info)
      if info == nil then
        window:Show(false)
      end
      if info.zoneIn and info.remainTime ~= nil and info.remainTime > 0 then
        InitComeptitionInfo(info)
        if window:HasHandler("OnUpdate") == false then
          window:SetHandler("OnUpdate", window.OnUpdateTime)
        end
        window:Show(true)
        return
      end
      if window:HasHandler("OnUpdate") == true then
        window:ReleaseHandler("OnUpdate")
      end
      window:Show(false)
    end,
    FACTION_COMPETITION_RESULT = function(info)
      if window:HasHandler("OnUpdate") == true then
        window:ReleaseHandler("OnUpdate")
      end
      window:Show(false)
    end,
    FACTION_COMPETITION_UPDATE_POINT = function(info)
      if info == nil then
        window:Show(false)
      end
      if not window:IsVisible() then
        window:Show(true)
        if window:HasHandler("OnUpdate") == false then
          window:SetHandler("OnUpdate", window.OnUpdateTime)
        end
      end
      if info.pointList ~= nil then
        UpdatePoint(info.pointList)
      end
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
local factionCompetitionStateWnd = CreateFactionCompetitionStateWnd()
