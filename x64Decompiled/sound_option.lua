local soundOptions = {
  {id = OPTION_ITEM_SOUND_QUALITY},
  {id = OPTION_ITEM_MASTER_VOLUME},
  {id = OPTION_ITEM_BGM_VOLUME},
  {id = OPTION_ITEM_SFX_VOLUME},
  {id = OPTION_ITEM_USE_COMBAT_SOUND},
  {id = OPTION_ITEM_CINEMA_VOLUME},
  {id = OPTION_ITEM_USER_MUSIC_VOLUME},
  {id = OPTION_ITEM_USER_MUSIC_DISABLE_OTHERS}
}
RegisterOptionItem(soundOptions)
local MakeBackgroundImg = function(startCtrl, lastCtrl)
  local bg = CreateContentBackground(startCtrl:GetParent(), "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", startCtrl, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", lastCtrl, 0, 0)
  startCtrl.bg = bg
end
function CreateSoundOptionFrame(parent, subFrameIndex)
  local frame = CreateOptionSubFrame(parent, subFrameIndex)
  local volume = {}
  volume[1] = "0"
  volume[2] = "10"
  local function CreateSoundSlider(titleText, optionId, drawBackground)
    local volumeControl = frame:InsertNewOption("sliderbar", titleText, volume, optionId, nil, true)
    volumeControl:SetMinMaxValues(0, 10)
    volumeControl:SetValue(10, false)
    local target = volumeControl:GetParent()
    target.optionTitle.style:SetFontSize(FONT_SIZE.LARGE)
    if drawBackground then
      local bg = CreateContentBackground(target, "TYPE2", "brown")
      bg:AddAnchor("TOPLEFT", target, 0, 0)
      bg:AddAnchor("BOTTOMRIGHT", target, 0, 0)
    end
    function volumeControl:SetVolume(value)
      value = math.floor(value)
      SetOptionItemValue(optionId, value * 0.1)
      self:SetValue(value, false)
      local str = string.format("%d", value)
      self.percentLabel:SetText(str)
    end
    function volumeControl:Init()
      if optionId ~= nil then
        self.originalValue = GetOptionItemValue(optionId)
        if self.originalValue == nil then
          self.originalValue = 0
        end
        local value = math.floor(self.originalValue * 10)
        self:SetValue(value, true)
        local str = string.format("%d", value)
        self.percentLabel:SetText(str)
      end
    end
    function volumeControl:Save()
      local value = math.floor(self:GetValue()) / 10
      SetOptionItemValue(optionId, value)
    end
    function volumeControl:Cancel()
      self:SetVolume(self.originalValue * 10)
    end
    local width = volumeControl:GetExtent()
    volumeControl:SetWidth(width - 37)
    local percentLabel = W_CTRL.CreateLabel(".percentLabel", volumeControl)
    percentLabel:SetExtent(30, 20)
    percentLabel:AddAnchor("LEFT", volumeControl, "RIGHT", 5, 0)
    percentLabel.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(percentLabel, FONT_COLOR.BLUE)
    volumeControl.percentLabel = percentLabel
    percentLabel.style:SetFontSize(FONT_SIZE.LARGE)
    return volumeControl
  end
  local function CreateSoundQualitySlider()
    local sound_quality_slider = frame:InsertNewOption("sliderbar", optionTexts.sound.quality, nil, OPTION_ITEM_SOUND_QUALITY)
    sound_quality_slider:SetMinMaxValues(1, #optionTexts.sound.quality.controlStr)
    sound_quality_slider:SetValueStep(1)
    sound_quality_slider:SetPageStep(1)
    local target = sound_quality_slider:GetParent()
    MakeBackgroundImg(target, target)
    target.bg:SetTextureColor("blue_3")
    target.optionTitle.style:SetFontSize(FONT_SIZE.LARGE)
  end
  local function CreateCheckboxSlider(sliderText, sliderValue, checkboxText, checkboxValue)
    local slider = CreateSoundSlider(sliderText, sliderValue)
    local checkbox = frame:InsertNewOption("checkbox", checkboxText, nil, checkboxValue)
    MakeBackgroundImg(slider:GetParent(), checkbox:GetParent())
    return slider, checkbox
  end
  CreateSoundQualitySlider()
  local master_volume_slider = CreateSoundSlider(optionTexts.sound.masterVolume, OPTION_ITEM_MASTER_VOLUME, true)
  local bgm_volume_slider, use_combat_bgm_checkbox = CreateCheckboxSlider(optionTexts.sound.bgmVolume, OPTION_ITEM_BGM_VOLUME, optionTexts.sound.useCombatSound, OPTION_ITEM_USE_COMBAT_SOUND)
  local sfx_volume_slider = CreateSoundSlider(optionTexts.sound.sfxVolume, OPTION_ITEM_SFX_VOLUME, true)
  local cinema_volume_slider = CreateSoundSlider(optionTexts.sound.cinemaVolume, OPTION_ITEM_CINEMA_VOLUME, true)
  local user_music_volume_slider, user_music_disable_others_checkbox = CreateCheckboxSlider(optionTexts.sound.userMusicVolume, OPTION_ITEM_USER_MUSIC_VOLUME, optionTexts.sound.useUserMusicOthers, OPTION_ITEM_USER_MUSIC_DISABLE_OTHERS)
  local function UpdateCheckboxEnable(slider, checkbox)
    local disable = master_volume_slider:GetValue() == 0 or slider:GetValue() == 0
    checkbox:Enable(not disable)
    checkbox.textButton:Enable(not disable)
  end
  local function MasterVolumeSliderOnSliderChanged(self)
    local value = math.floor(self:GetValue() or 0)
    self:SetVolume(value)
    bgm_volume_slider:SetEnable(value ~= 0)
    UpdateCheckboxEnable(bgm_volume_slider, use_combat_bgm_checkbox)
    sfx_volume_slider:SetEnable(value ~= 0)
    cinema_volume_slider:SetEnable(value ~= 0)
    user_music_volume_slider:SetEnable(value ~= 0)
    UpdateCheckboxEnable(user_music_volume_slider, user_music_disable_others_checkbox)
  end
  local function BgmVolumeSliderOnSliderChanged(self)
    local value = math.floor(self:GetValue() or 0)
    self:SetVolume(value)
    UpdateCheckboxEnable(self, use_combat_bgm_checkbox)
  end
  local SfxVolumeSliderOnSliderChanged = function(self)
    local value = self:GetValue() or 0
    self:SetVolume(value)
  end
  local CinemaVolumeSliderOnSliderChanged = function(self)
    local value = self:GetValue() or 0
    self:SetVolume(value)
  end
  local function UserMusicVolumeSliderOnSliderChanged(self)
    local value = math.floor(self:GetValue() or 0)
    self:SetVolume(value)
    UpdateCheckboxEnable(self, user_music_disable_others_checkbox)
  end
  master_volume_slider:SetHandler("OnSliderChanged", MasterVolumeSliderOnSliderChanged)
  bgm_volume_slider:SetHandler("OnSliderChanged", BgmVolumeSliderOnSliderChanged)
  sfx_volume_slider:SetHandler("OnSliderChanged", SfxVolumeSliderOnSliderChanged)
  cinema_volume_slider:SetHandler("OnSliderChanged", CinemaVolumeSliderOnSliderChanged)
  user_music_volume_slider:SetHandler("OnSliderChanged", UserMusicVolumeSliderOnSliderChanged)
  return frame
end
