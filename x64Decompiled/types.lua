WINDOW_MODULE_TYPE = {
  TITLE_BOX = 1,
  VALUE_BOX = 2,
  VERTICAL_HEADER_TABLE = 3
}
WINDOW_MODULE_PRESET = {
  TITLE_BOX = {
    TYPE1 = {
      body_bg = {coords = "common_bg", color = "bg_02"},
      title_bg = {coords = "common_bg", color = "alpha40"},
      title_inset = {
        15,
        8,
        15,
        7
      }
    }
  }
}
function CreateWithPreset(a, b)
  local c = {}
  for k, v in pairs(a) do
    c[k] = v
  end
  for k, v in pairs(b) do
    c[k] = v
  end
  return c
end
