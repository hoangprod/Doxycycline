RESIDENT_TAB_VIEW = {}
for i = 1, #RESIDENT_TAB_INFO do
  if RESIDENT_TAB_INFO[i].show then
    table.insert(RESIDENT_TAB_VIEW, RESIDENT_TAB_INFO[i])
  end
end
function RESIDENT_TAB_I2V(idx)
  if RESIDENT_TAB_INFO[idx] == nil then
    return
  end
  for i = 1, #RESIDENT_TAB_VIEW do
    if RESIDENT_TAB_INFO[idx].text == RESIDENT_TAB_VIEW[i].text then
      return i
    end
  end
  return
end
RESIDENT_MEMBER_VIEW = {}
for i = 1, #RESIDENT_MEMBER_INFO do
  if RESIDENT_MEMBER_INFO[i].show then
    table.insert(RESIDENT_MEMBER_VIEW, RESIDENT_MEMBER_INFO[i])
  end
end
NUONS_ARROW_VIEW = {}
for i = 1, #NUONS_ARROW_INFO do
  if NUONS_ARROW_INFO[i].show then
    table.insert(NUONS_ARROW_VIEW, NUONS_ARROW_INFO[i])
  end
end
