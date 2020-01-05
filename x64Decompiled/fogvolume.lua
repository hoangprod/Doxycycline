FogVolume = {
  type = "FogVolume",
  Properties = {
    bActive = 1,
    VolumeType = 0,
    Size = {
      x = 1,
      y = 1,
      z = 1
    },
    color_Color = {
      x = 1,
      y = 1,
      z = 1
    },
    fHDRDynamic = 0,
    bUseGlobalFogColor = 0,
    GlobalDensity = 1,
    FallOffDirLong = 0,
    FallOffDirLati = 90,
    FallOffShift = 0,
    FallOffScale = 1,
    SoftEdges = 1,
    SoftEdgeFactor = 0
  },
  Fader = {fadeTime = 0, fadeToValue = 0},
  Editor = {
    Model = "Editor/Objects/invisiblebox.cgf",
    Icon = "FogVolume.bmp",
    ShowBounds = 1
  }
}
function FogVolume:OnSpawn()
  self:SetFlags(ENTITY_FLAG_CLIENT_ONLY, 0)
end
function FogVolume:InitFogVolumeProperties()
  local props = self.Properties
  self:LoadFogVolume(0, self.Properties)
end
function FogVolume:CreateFogVolume()
  self:InitFogVolumeProperties()
end
function FogVolume:DeleteFogVolume()
  self:FreeSlot(0)
end
function FogVolume:OnInit()
  if self.Properties.bActive == 1 then
    self:CreateFogVolume()
  end
end
function FogVolume:CheckMove()
end
function FogVolume:OnShutDown()
end
function FogVolume:OnPropertyChange()
  if self.Properties.bActive == 1 then
    self:CreateFogVolume()
  else
    self:DeleteFogVolume()
  end
end
function FogVolume:OnReset()
  if self.Properties.bActive == 1 then
    self:CreateFogVolume()
  end
end
function FogVolume:Event_Hide()
  self:DeleteFogVolume()
end
function FogVolume:Event_Show()
  self:CreateFogVolume()
end
function FogVolume:Event_Fade()
  self:FadeGlobalDensity(0, self.Fader.fadeTime, self.Fader.fadeToValue)
end
function FogVolume:Event_FadeTime(i, time)
  self.Fader.fadeTime = time
end
function FogVolume:Event_SetGlobalDensity(i, val)
  self:SetGlobalDensity(0, val)
  self.GlobalDensity = val
end
function FogVolume:Event_FadeValue(i, val)
  self.Fader.fadeToValue = val
end
FogVolume.FlowEvents = {
  Inputs = {
    Hide = {
      FogVolume.Event_Hide,
      "bool"
    },
    Show = {
      FogVolume.Event_Show,
      "bool"
    },
    x_Time = {
      FogVolume.Event_FadeTime,
      "float"
    },
    y_Value = {
      FogVolume.Event_FadeValue,
      "float"
    },
    z_Fade = {
      FogVolume.Event_Fade,
      "bool"
    },
    SetGlobalDensity = {
      FogVolume.Event_SetGlobalDensity,
      "float"
    }
  },
  Outputs = {Hide = "bool", Show = "bool"}
}
