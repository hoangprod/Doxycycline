local wnd
local function CreateBuildCondition(id, parent)
  if nil == wnd then
    wnd = SetViewOfBuildCondition(id, parent)
    do
      local events = {
        INTERACTION_END = function()
          wnd:Show(false)
        end
      }
      wnd:SetHandler("OnEvent", function(this, event, ...)
        events[event](...)
      end)
      RegistUIEvent(wnd, events)
    end
  else
    wnd:Show(true)
  end
end
local function ShowBuildCondition(param)
  CreateBuildCondition("BuildCondition", "UIParent")
  wnd:SetTitle(GetCommonText(param.title))
  wnd:FillData(param)
  function wnd.okBtn:OnClick()
    wnd:Show(false)
  end
  wnd.okBtn:SetHandler("OnClick", wnd.okBtn.OnClick)
end
UIParent:SetEventHandler("BUILD_CONDITION", ShowBuildCondition)
