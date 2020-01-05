residentBoard = nil
local CreateBoardWindow = function(id, parent)
  local WND_HEIGHT = 320
  local window = CreateInfomationGuideWindow(id, parent)
  window:SetExtent(POPUP_WINDOW_WIDTH, WND_HEIGHT)
  window:SetSounds("web_note")
  window:EnableHidingIsRemove(true)
  window:SetCloseOnEscape(true)
  window:AddAnchor("CENTER", parent, 0, 0)
  window:Show(false)
  local bg = CreateContentBackground(window, "TYPE13")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  function window:OnHideWindow()
    residentBoard = nil
  end
  window:SetHandler("OnHide", window.OnHideWindow)
  local events = {
    INTERACTION_END = function()
      if window:IsVisible() then
        window:Show(false)
      end
    end,
    RESIDENT_BOARD_TYPE = function(boardType)
      local board = X2Resident:GetResidentBoardContent(boardType)
      if board == nil then
        return
      end
      local contents = ""
      for i = 1, #board.contents do
        if contents == "" then
          contents = board.contents[i]
        else
          contents = contents .. "\n" .. board.contents[i]
        end
      end
      window:SetTitle(board.title)
      BOARD_WINDOW = {
        {
          raw = true,
          title = board.faction,
          content = contents
        }
      }
      window:FillData(BOARD_WINDOW)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
function ToggleResidentBoard(show)
  if residentBoard == nil then
    residentBoard = CreateBoardWindow("residentBoard", "UIParent")
  end
  if show == nil then
    show = not residentBoard:IsVisible()
  end
  residentBoard:Show(show)
end
ADDON:RegisterContentTriggerFunc(UIC_LOCAL_DEVELOPMENT_BOARD, ToggleResidentBoard)
