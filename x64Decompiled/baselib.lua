MAX = {MY_ABILITY_COUNT = 3}
COMBAT_ABILITY_MAX = X2Ability:GetCombatAbilityMax()
UNIT_VISIBLE_MAX_DISTANCE = 130
AUTO_REGISTER_ACTIONBAR_NUM = 3
MAX_SILVER = 100000000
BUTTON_STATE = {
  NORMAL = 1,
  HIGHLIGHTED = 2,
  PUSHED = 3,
  DISABLED = 4
}
PLAYER_EQUIP_SLOTS = {
  ES_HEAD,
  ES_NECK,
  ES_CHEST,
  ES_WAIST,
  ES_LEGS,
  ES_HANDS,
  ES_FEET,
  ES_ARMS,
  ES_BACK,
  ES_EAR_1,
  ES_EAR_2,
  ES_FINGER_1,
  ES_FINGER_2,
  ES_UNDERSHIRT,
  ES_UNDERPANTS,
  ES_MAINHAND,
  ES_OFFHAND,
  ES_RANGED,
  ES_MUSICAL,
  ES_BACKPACK,
  ES_COSPLAY
}
ICON_SIZE = {
  SOCKET = 18,
  BUFF = 24,
  SET_ITEM = 24,
  APPELLAITON = 30,
  AUCTION = 35,
  DEFAULT = 42,
  LARGE = 48,
  XLARGE = 50,
  SLAVE = 52
}
BUTTON_COMMON_INSET = {TWO_BUTTON_BETEEN = 43, MESSAGEBOX_BOTTOM = -30}
MARGIN = {
  WINDOW_SIDE = 20,
  WINDOW_TITLE = 50,
  WINDOW_BOTTOM = -65
}
EDITBOX_GUIDE_INSET = {
  7,
  1,
  0,
  0
}
DEFAULT_SIZE = {
  DIALOG_CONTENT_WIDTH = 312,
  EDIT_HEIGHT = 26,
  SPINNER = {65, 34},
  COMBOBOX_HEIGHT = 26,
  INVENTORY_TAB_BUTTON_WIDTH = 40,
  TOOLTIP_MAX_WIDTH = 350,
  CHAT_EDIT_HEIGHT = 23
}
TEXTBOX_LINE_SPACE = {
  SMALL = 3,
  MIDDLE = 5,
  LARGE = 7,
  TOOLTIP = 4,
  QUESTGUIDE = 5
}
WINDOW_SIZE = {SMALL = 300}
FONT_SIZE = {
  SMALL = 11,
  MIDDLE = 13,
  LARGE = 15,
  XLARGE = 18,
  XXLARGE = 22
}
FONT_PATH = {
  DEFAULT = "ui/font/yd_ygo540.ttf",
  LEEYAGI = "ui/font/SD_LeeyagiL.ttf"
}
EDITBOX_CURSOR = {
  DEFAULT = {
    0.3,
    0.3,
    0.3,
    1
  },
  LOGIN_STAGE = {
    ConvertColor(192),
    ConvertColor(192),
    ConvertColor(192),
    1
  },
  WHITE = {
    1,
    1,
    1,
    1
  }
}
BUTTON_SIZE = {
  ICON = {WIDTH = 54, HEIGHT = 54},
  IMAGE_TAB = {WIDTH = 40, HEIGHT = 30},
  TAB_SELECT = {WIDTH = 95, HEIGHT = 29},
  TAB_UNSELECT = {WIDTH = 95, HEIGHT = 25},
  DEFAULT_SMALL = {WIDTH = 84, HEIGHT = 33},
  DEFAULT_MIDDLE = {WIDTH = 115, HEIGHT = 33},
  DEFAULT_LARGE = {WIDTH = 130, HEIGHT = 33},
  DEFAULT_XLARGE = {WIDTH = 150, HEIGHT = 33},
  DEFAULT_XXLARGE = {WIDTH = 160, HEIGHT = 33}
}
MAX_HERO = 6
MAX_HERO_COND = 10
function ChatLog(arg)
  if X2Debug ~= nil and X2Debug:GetDevMode() then
    X2Chat:DispatchChatMessage(CMF_SAY, tostring(arg))
  end
end
function LuaAssert(msg)
  if X2Debug ~= nil and X2Debug:GetDevMode() then
    X2Chat:DispatchChatMessage(CMF_SAY, tostring(msg))
  end
  X2Util:RaiseLuaCallStack(msg)
end
function DumpTable(o)
  if X2Debug == nil or not X2Debug:GetDevMode() then
    return
  end
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = "\"" .. k .. "\""
      end
      s = s .. "[" .. k .. "]: " .. DumpTable(v) .. ", "
    end
    return s .. "}"
  else
    return tostring(o)
  end
end
function AddOnUpdateCooldown(target, windowType)
  target:SetCoolDownMask("ui/icon/cooldown_mask.dds")
  target:SetCoolDownMaskCoords(0, 0, 256, 256)
  function target:OnContentUpdated(kind, arg1, arg2)
    local totalTime, remainTime = arg2, arg1
    if 0 < (remainTime or 0) then
      if self.coolTimeAni ~= nil then
        self.coolTimeAni:Animation(false, false)
        self.isCoolDownAnimationDone = false
      end
      self:SetCoolDown(remainTime, totalTime)
    else
      if self.coolTimeAni ~= nil and self.isCoolDownAnimationDone == false then
        self.coolTimeAni:Animation(true, false)
        self.isCoolDownAnimationDone = true
      end
      self:SetCoolDown(0, 0)
    end
  end
  target:SetHandler("OnContentUpdated", target.OnContentUpdated)
end
function RegistUIEvent(window, eventTable)
  for key, _ in pairs(eventTable) do
    window:RegisterEvent(key)
  end
end
W_CTRL = {}
function AttachStyleMemberFunc(controlWidget, styleTable)
  function controlWidget:SetStyle(style)
    if style == nil then
      style = "default"
    end
    local styleFunc = styleTable[style]
    if styleFunc == nil then
      UIParent:Warning(string.format("[Lua] invalid style type... %s / %s", controlWidget:GetName(), style))
      styleTable.default(self)
      return
    end
    styleFunc(self)
  end
  function controlWidget:GetStyleList()
    return styleTable
  end
end
local alreadyNotified = false
function ShowDisconnectMsg(title, body)
  if alreadyNotified then
    return
  end
  local function DialogHandler(wnd)
    wnd:SetTitle(title)
    wnd:SetContent(body)
    function wnd:OkProc()
      X2World:LeaveWorld(EXIT_CLIENT)
    end
    function wnd:OnUpdate()
      self:Raise()
      self:SetUILayer("system")
    end
    wnd:SetHandler("OnUpdate", wnd.OnUpdate)
  end
  local id = X2DialogManager:RequestNoticeDialog(DialogHandler, "")
  alreadyNotified = id ~= "0"
end
UIParent:SetEventHandler("DISCONNECTED_BY_WORLD", ShowDisconnectMsg)
function GetAdjustCamera(race, gender)
  local height = {
    nuian = {
      male = {
        height = 0.13,
        zoom = -0.6,
        center = -0.4
      },
      female = {
        height = 0.2,
        zoom = -0.5,
        center = -0.35
      }
    },
    elf = {
      male = {
        height = 0.1,
        zoom = -0.7,
        center = -0.5
      },
      female = {
        height = 0.2,
        zoom = -0.7,
        center = -0.7
      }
    },
    hariharan = {
      male = {
        height = 0.15,
        zoom = -0.5,
        center = -0.4
      },
      female = {
        height = 0.15,
        zoom = -0.5,
        center = -0.32
      }
    },
    ferre = {
      male = {
        height = 0.13,
        zoom = -0.8,
        center = -0.55
      },
      female = {
        height = 0.1,
        zoom = -0.5,
        center = -0.35
      }
    },
    dwarf = {
      male = {
        height = 0.2,
        zoom = -0.5,
        center = -0.35
      },
      female = {
        height = 0.25,
        zoom = -0.5,
        center = -0.4
      }
    },
    warborn = {
      male = {
        height = 0,
        zoom = 0.15,
        center = 0.22
      },
      female = {
        height = 0.15,
        zoom = -0.5,
        center = -0.35
      }
    }
  }
  if height[race] == nil then
    local errorStr = string.format("!!!!!!!!!!!!!!!!!!!!! check model cammera value, doesn't exist %s value", race)
    ChatLog(errorStr)
    UIParent:LogAlways(errorStr)
    return height.nuian[gender]
  else
    return height[race][gender]
  end
end
function IsHeirLevel(level)
  local heirLevel = level - X2Player:GetMinHeirLevel()
  if heirLevel > 0 then
    return true
  end
  return false
end
function GetLevelToString(level, hex_color, disable_heir_icon, useLevelText)
  local colorStr = ""
  if hex_color then
    colorStr = string.format("%s", hex_color)
  end
  if level > X2Player:GetMinHeirLevel() then
    local heirLevel = level - X2Player:GetMinHeirLevel()
    local levelStr = useLevelText and GetCommonText("level_with_value", tostring(heirLevel)) or tostring(heirLevel)
    if hex_color == nil then
      colorStr = string.format("%s", F_COLOR.GetColor("successor_deep", true))
    end
    if disable_heir_icon then
      return string.format("%s|E%s;|r", colorStr, levelStr)
    else
      return string.format("%s|e%s;|r", colorStr, levelStr)
    end
  end
  local levelStr = useLevelText and GetCommonText("level_with_value", tostring(level)) or tostring(level)
  return string.format("%s%s|r", colorStr, levelStr)
end
