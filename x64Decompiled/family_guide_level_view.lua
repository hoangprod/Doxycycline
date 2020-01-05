function SetViewOfFamilyGuide(id, parent)
  FAMILY_GUIDE_TEXT = {
    {
      title = "family_guide_title",
      content = "family_guide_content"
    },
    {
      title = "family_guide_title_1",
      content = "family_guide_content_1"
    },
    {
      title = "family_guide_title_2",
      content = "family_guide_content_2"
    }
  }
  local guideWindow = CreateInfomationGuideWindow(id, parent, "family_guide", FAMILY_GUIDE_TEXT)
  guideWindow:AddAnchor("CENTER", parent, 0, 0)
  return guideWindow
end
