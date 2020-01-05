F_SOUND = {}
function F_SOUND.PlayUISound(soundPackItemName, duplicable)
  if duplicable == nil then
    duplicable = false
  end
  return X2Sound:PlayUISound(soundPackItemName, duplicable)
end
function F_SOUND:StopSound(soundId, force)
  if force then
    X2Sound:StopSound(soundId, SOUND_STOP_MODE_AT_ONCE)
  else
    X2Sound:StopSound(soundId)
  end
end
function F_SOUND.PlayMusic(soundPackItemName)
  X2Sound:PlayMusic(soundPackItemName)
end
function F_SOUND.StopMusic()
  X2Sound:StopMusic()
end
