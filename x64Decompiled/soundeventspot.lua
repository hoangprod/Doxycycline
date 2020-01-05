SoundEventSpot = {
  type = "Sound",
  Properties = {
    soundName = "",
    bPlay = 0,
    bOnce = 0,
    bEnabled = 1,
    bIgnoreCulling = 0,
    bIgnoreObstruction = 0
  },
  bBlockNow = 0,
  Editor = {
    Model = "Editor/Objects/Sound.cgf",
    Icon = "Sound.bmp"
  }
}
function SoundEventSpot:OnSpawn()
  self:SetFlags(ENTITY_FLAG_CLIENT_ONLY, 0)
  if System.IsEditor() then
    Sound.Precache(self.Properties.soundName, SOUND_PRECACHE_LOAD_SOUND)
  end
end
function SoundEventSpot:OnSave(save)
  save.bBlockNow = self.bBlockNow
  save.bEnabled = self.Properties.bEnabled
  save.bOnce = self.Properties.bOnce
  save.bIgnoreCulling = self.Properties.bIgnoreCulling
  save.bIgnoreObstruction = self.Properties.bIgnoreObstruction
end
function SoundEventSpot:OnLoad(load)
  self.bBlockNow = load.bBlockNow
  self.Properties.bEnabled = load.bEnabled
  self.Properties.bOnce = load.bOnce
  self.Properties.bIgnoreCulling = load.bIgnoreCulling
  self.Properties.bIgnoreObstruction = load.bIgnoreObstruction
  if self.bPlay then
    self:Play()
  end
end
function SoundEventSpot:OnPostSerialize()
  self:OnReset()
end
function SoundEventSpot:OnPropertyChange()
  self:OnReset()
end
function SoundEventSpot:OnReset()
  self.bBlockNow = 0
  self:Stop()
  if self.Properties.bPlay ~= 0 then
    self:Play()
  end
end
SoundEventSpot.Server = {
  OnInit = function(self)
    self.bBlockNow = 0
    self:NetPresent(0)
  end,
  OnShutDown = function(self)
  end
}
SoundEventSpot.Client = {
  OnInit = function(self)
    self.bBlockNow = 0
    self.soundName = ""
    self.soundid = nil
    self:NetPresent(0)
  end,
  OnShutDown = function(self)
    self:Stop()
  end,
  OnSoundDone = function(self)
    self:ActivateOutput("Done", true)
    self.soundid = nil
  end,
  OnStartGame = function(self)
    self:OnReset()
  end
}
function SoundEventSpot:Play()
  if self.Properties.bEnabled == 0 then
    return
  end
  if self.soundid ~= nil then
    self:Stop()
  end
  if self.bBlockNow == 1 then
    return
  end
  local sndFlags = SOUND_EVENT
  sndFlags = bor(sndFlags, SOUND_START_PAUSED)
  if self.Properties.bIgnoreCulling == 0 then
    sndFlags = bor(sndFlags, SOUND_CULLING)
  end
  if self.Properties.bIgnoreObstruction == 0 then
    sndFlags = bor(sndFlags, SOUND_OBSTRUCTION)
  end
  self.soundid = self:PlaySoundEvent(self.Properties.soundName, g_Vectors.v000, g_Vectors.v010, sndFlags, SOUND_SEMANTIC_SOUNDSPOT)
  self.soundName = self.Properties.soundName
  if self.soundid ~= nil then
    local bIsEvent = Sound.IsEvent(self.soundid)
    if not bIsEvent then
      System.LogToConsole("<Sound> SoundEventSpot: (" .. self:GetName() .. ") trys to play " .. self.soundName .. ". Cannot play non Events on SoundEventSpot!")
      self:Stop()
    else
      Sound.SetSoundPaused(self.soundid, 0)
    end
  end
  if self.Properties.bOnce == 1 then
    self.bBlockNow = 1
  end
end
function SoundEventSpot:Stop()
  if self.soundid ~= nil then
    self:StopSound(self.soundid)
    self.soundid = nil
  end
end
function SoundEventSpot:Event_Play(sender)
  if self.soundid ~= nil then
    self:Stop()
  end
  self:Play()
end
function SoundEventSpot:Event_SoundName(sender, sSoundName)
  self.Properties.soundName = sSoundname
  self:OnPropertyChange()
end
function SoundEventSpot:Event_Enable(sender)
  self.Properties.bEnabled = true
  self:OnPropertyChange()
end
function SoundEventSpot:Event_Disable(sender)
  self.Properties.bEnabled = false
  self:OnPropertyChange()
end
function SoundEventSpot:Event_Stop(sender)
  self:Stop()
end
function SoundEventSpot:Event_Once(sender, bOnce)
  if bOnce == true then
    self.Properties.bOnce = 1
  else
    self.Properties.bOnce = 0
  end
end
SoundEventSpot.FlowEvents = {
  Inputs = {
    sound_SoundName = {
      SoundEventSpot.Event_SoundName,
      "string"
    },
    Enable = {
      SoundEventSpot.Event_Enable,
      "bool"
    },
    Disable = {
      SoundEventSpot.Event_Disable,
      "bool"
    },
    Play = {
      SoundEventSpot.Event_Play,
      "bool"
    },
    Stop = {
      SoundEventSpot.Event_Stop,
      "bool"
    },
    Once = {
      SoundEventSpot.Event_Once,
      "bool"
    }
  },
  Outputs = {Done = "bool"}
}
