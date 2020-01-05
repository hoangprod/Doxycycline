Tornado = {
  type = "Tornado",
  Properties = {
    Radius = 30,
    fEyeRadius = 0,
    fWanderSpeed = 10,
    FunnelEffect = "wind.tornado.large",
    fCloudHeight = 376,
    fSpinImpulse = 9,
    fAttractionImpulse = 13,
    fUpImpulse = 18,
    CheckTag_1 = 0,
    CheckTag_2 = 0,
    CheckTag_3 = 0,
    Radius_limit_min = 0,
    Radius_limit_max = 350,
    fEyeRadius_limit_min = 0,
    fEyeRadius_limit_max = 350
  },
  Editor = {
    Icon = "Tornado.bmp"
  }
}
function Tornado:OnInit()
  self:OnReset()
end
function Tornado:OnPropertyChange()
  self:OnReset()
end
function Tornado:OnReset()
end
function Tornado:OnSave(tbl)
end
function Tornado:OnLoad(tbl)
end
function Tornado:OnShutDown()
end
function Tornado:Event_TargetReached(sender)
end
function Tornado:Event_Enable(sender)
end
function Tornado:Event_Disable(sender)
end
Tornado.FlowEvents = {
  Inputs = {
    Disable = {
      Tornado.Event_Disable,
      "bool"
    },
    Enable = {
      Tornado.Event_Enable,
      "bool"
    }
  },
  Outputs = {
    Disable = "bool",
    Enable = "bool",
    TargetReached = "bool"
  }
}
