local STATE = {BUILD = 1, REBUILD = 2}
local build_guide
function CreateBuildGuide(state)
  local frame = UIParent:CreateWidget("window", "housing_build_guide", "UIParent")
  frame:Show(true)
  frame:Raise()
  frame:SetExtent(hudLocale.buildGuide.frame.extent.width, hudLocale.buildGuide.frame.extent.height)
  frame:AddAnchor("BOTTOM", "UIParent", 0, -100)
  frame:EnablePick(false)
  local bg = frame:CreateDrawable(TEXTURE_PATH.TUTORIAL, "bg", "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", frame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", frame, hudLocale.buildGuide.bg.AnchorOffset.x, hudLocale.buildGuide.bg.AnchorOffset.y)
  if state == nil then
    state = STATE.BUILD
  end
  local texts = {
    [STATE.BUILD] = {
      GetUIText(COMMON_TEXT, "build_guide_2"),
      GetUIText(COMMON_TEXT, "build_guide_3"),
      GetUIText(COMMON_TEXT, "build_guide_4"),
      GetUIText(COMMON_TEXT, "build_guide_1")
    },
    [STATE.REBUILD] = {
      GetUIText(COMMON_TEXT, "rebuilding_camera_tip"),
      GetUIText(COMMON_TEXT, "build_guide_3"),
      GetUIText(COMMON_TEXT, "build_guide_4")
    }
  }
  local COMMON_PATH = "ui/housing/build_guide.dds"
  local textureInfo = {
    [STATE.BUILD] = {
      {
        {
          path = COMMON_PATH,
          key = "mouse",
          anchorX = 80,
          anchorY = 25
        }
      },
      {
        {
          path = COMMON_PATH,
          key = "alt",
          anchorX = 50,
          anchorY = 83
        },
        {
          path = COMMON_PATH,
          key = "mouse_plus",
          anchorX = 100,
          anchorY = 80
        }
      },
      {
        {
          path = COMMON_PATH,
          key = "shift",
          anchorX = 43,
          anchorY = 138
        },
        {
          path = COMMON_PATH,
          key = "mouse_plus",
          anchorX = 100,
          anchorY = 135
        }
      },
      {
        {
          path = COMMON_PATH,
          key = "ctrl",
          anchorX = 50,
          anchorY = 193
        },
        {
          path = COMMON_PATH,
          key = "mouse_plus",
          anchorX = 100,
          anchorY = 190
        }
      }
    },
    [STATE.REBUILD] = {
      {
        {
          path = "ui/housing/keyboard.dds",
          key = "keys",
          anchorX = 42,
          anchorY = 30
        }
      },
      {
        {
          path = COMMON_PATH,
          key = "alt",
          anchorX = 50,
          anchorY = 112
        },
        {
          path = COMMON_PATH,
          key = "mouse_plus",
          anchorX = 100,
          anchorY = 109
        }
      },
      {
        {
          path = COMMON_PATH,
          key = "shift",
          anchorX = 43,
          anchorY = 175
        },
        {
          path = COMMON_PATH,
          key = "mouse_plus",
          anchorX = 100,
          anchorY = 172
        }
      }
    }
  }
  local inset = {
    [STATE.BUILD] = {startY = 35, between = 55},
    [STATE.REBUILD] = {startY = 50, between = 70}
  }
  for i = 1, #texts[state] do
    local guide_text = frame:CreateChildWidget("textbox", "guide_text", i, true)
    ApplyTextColor(guide_text, FONT_COLOR.BLACK)
    guide_text:SetText(texts[state][i])
    guide_text:SetWidth(hudLocale.buildGuide.guide_text.width)
    guide_text.style:SetAlign(ALIGN_LEFT)
    guide_text:SetHeight(guide_text:GetTextHeight())
    guide_text:AddAnchor("TOPLEFT", frame, 160, inset[state].startY + (i - 1) * inset[state].between)
  end
  local function CreateTexture(path, textureKey, anchorx, anchory)
    local img = frame:CreateDrawable("ui/housing/keyboard.dds", "keys", "background")
    img:SetTexture(path)
    img:SetTextureInfo(textureKey)
    img:AddAnchor("TOPLEFT", frame, anchorx, anchory)
  end
  for i = 1, #textureInfo[state] do
    for j = 1, #textureInfo[state][i] do
      local info = textureInfo[state][i][j]
      CreateTexture(info.path, info.key, info.anchorX, info.anchorY)
    end
  end
  return frame
end
function ShowBuildGuide(show, state)
  if show and build_guide == nil then
    build_guide = CreateBuildGuide(state)
    build_guide:EnableHidingIsRemove(true)
    do
      local events = {
        BUILDER_END = function()
          ShowBuildGuide(false)
        end,
        CANCEL_REBUILD_HOUSE_CAMERA_MODE = function()
          ShowBuildGuide(false)
        end
      }
      build_guide:SetHandler("OnEvent", function(this, event, ...)
        events[event](...)
      end)
      RegistUIEvent(build_guide, events)
      function build_guide:OnHide()
        build_guide = nil
      end
      build_guide:SetHandler("OnHide", build_guide.OnHide)
    end
  end
  if build_guide ~= nil then
    build_guide:Show(show)
  end
end
local function BuilderStep(step)
  if step == "rotation" then
    ShowBuildGuide(true, STATE.BUILD)
  else
    ShowBuildGuide(false)
  end
end
UIParent:SetEventHandler("BUILDER_STEP", BuilderStep)
local function SetRebuildMode()
  ShowBuildGuide(true, STATE.REBUILD)
end
UIParent:SetEventHandler("SET_REBUILD_HOUSE_CAMERA_MODE", SetRebuildMode)
