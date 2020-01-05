SoundSupressor = {
  Client = {},
  Server = {},
  Properties = {radius = 10},
  Editor = {Icon = "Item.bmp", IconOnTop = 1}
}
function SoundSupressor:OnPropertyChange()
  self:OnReset()
end
function SoundSupressor:OnSave(tbl)
end
function SoundSupressor:OnLoad(tbl)
end
function SoundSupressor:OnInit()
  self:OnReset()
end
function SoundSupressor:OnReset()
  AI.RegisterWithAI(self.id, AIOBJECT_SNDSUPRESSOR, self.Properties)
end
function SoundSupressor:Event_TurnOn()
  self:TriggerEvent(AIEVENT_DISABLE)
end
function SoundSupressor:Event_TurnOff()
  self:TriggerEvent(AIEVENT_ENABLE)
end
SoundSupressor.FlowEvents = {
  Inputs = {
    TurnOn = {
      SoundSupressor.Event_TurnOn,
      "bool"
    },
    TurnOff = {
      SoundSupressor.Event_TurnOff,
      "bool"
    }
  },
  Outputs = {}
}
