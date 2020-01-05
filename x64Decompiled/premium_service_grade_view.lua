local premiumServiceGradePoint = {}
local gradePointTable = X2PremiumService:GetPremiumGradePoint()
for i = 1, #gradePointTable.gradePoint do
  premiumServiceGradePoint[i] = gradePointTable.gradePoint[i]
end
function SetViewOfPremiumServiceGradeFrame(id, parent)
  local progressCoords = {
    GetTextureInfo(TEXTURE_PATH.PREMIUM_SERVICE_GRADE_PROGRESS_BAR, "graph_bg"):GetCoords()
  }
  local progressBgCoords = {
    GetTextureInfo(TEXTURE_PATH.PREMIUM_SERVICE_GRADE_PROGRESS_BAR, "graph_color"):GetCoords()
  }
  local defaultGradeProgressBgWidth = premiumServiceLocale.defaultWidth
  local gradeProgressBgRate = defaultGradeProgressBgWidth / progressCoords[3]
  local premiumServiceGradeProgress = {
    {
      6 * gradeProgressBgRate,
      98 * gradeProgressBgRate
    },
    {
      104 * gradeProgressBgRate,
      95 * gradeProgressBgRate
    },
    {
      199 * gradeProgressBgRate,
      92 * gradeProgressBgRate
    },
    {
      291 * gradeProgressBgRate,
      89 * gradeProgressBgRate
    },
    {
      380 * gradeProgressBgRate,
      86 * gradeProgressBgRate
    },
    {
      466 * gradeProgressBgRate,
      83 * gradeProgressBgRate
    },
    {
      549 * gradeProgressBgRate,
      80 * gradeProgressBgRate
    },
    {
      629 * gradeProgressBgRate,
      77 * gradeProgressBgRate
    },
    {
      706 * gradeProgressBgRate,
      74 * gradeProgressBgRate
    },
    {
      780 * gradeProgressBgRate,
      71 * gradeProgressBgRate
    },
    {
      851 * gradeProgressBgRate,
      1 * gradeProgressBgRate
    }
  }
  local frame = CreateEmptyWindow(id, parent)
  frame:Show(true)
  frame:SetExtent(defaultGradeProgressBgWidth + 9, progressCoords[4])
  local progressBg = frame:CreateDrawable(TEXTURE_PATH.PREMIUM_SERVICE_GRADE_PROGRESS_BAR, "graph_bg", "background")
  progressBg:SetExtent(defaultGradeProgressBgWidth + 1, progressCoords[4])
  progressBg:AddAnchor("TOPLEFT", frame, 0, -7 + premiumServiceLocale.progressBarOffsetY)
  frame.progressBg = progressBg
  local statusBar = UIParent:CreateWidget("statusbar", id .. ".statusBar", frame)
  statusBar:SetExtent(defaultGradeProgressBgWidth + 1, progressBgCoords[4])
  statusBar:AddAnchor("TOPLEFT", progressBg, 0, 13)
  statusBar:SetBarTexture(TEXTURE_PATH.PREMIUM_SERVICE_GRADE_PROGRESS_BAR, "background")
  statusBar:SetBarTextureCoords(progressBgCoords[1], progressBgCoords[2], progressBgCoords[3], progressBgCoords[4])
  statusBar:SetOrientation("HORIZONTAL")
  statusBar:SetMinMaxValues(0, defaultGradeProgressBgWidth + 1)
  statusBar:SetValue(0)
  statusBar:Show(true)
  frame.statusBar = statusBar
  local maxGrade = X2PremiumService:GetPremiumMaxGrade()
  for i = 1, maxGrade do
    local label = frame:CreateChildWidget("label", i .. "gradelabel", 0, true)
    label:SetExtent(100, 20)
    label:SetText(locale.premium.grade(tostring(i)))
    label.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
    label.style:SetColor(FONT_COLOR.MIDDLE_TITLE[1], FONT_COLOR.MIDDLE_TITLE[2], FONT_COLOR.MIDDLE_TITLE[3], 1)
    label:SetAutoResize(true)
    label:AddAnchor("TOPLEFT", statusBar, premiumServiceGradeProgress[i][1] + 10, 30)
    local progressGradePointLabel = frame:CreateChildWidget("label", "progressgradepointlabel" .. i, 0, true)
    progressGradePointLabel:SetExtent(40, 20)
    progressGradePointLabel:SetAutoResize(true)
    progressGradePointLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.SMALL)
    progressGradePointLabel.style:SetColor(FONT_COLOR.DEFAULT[1], FONT_COLOR.DEFAULT[2], FONT_COLOR.DEFAULT[3], 1)
    progressGradePointLabel.style:SetAlign(ALIGN_LEFT)
    progressGradePointLabel:SetText(tostring(premiumServiceGradePoint[i]))
    progressGradePointLabel:AddAnchor("BOTTOMLEFT", statusBar, "TOPLEFT", premiumServiceGradeProgress[i][1] + 10, 2)
  end
  local progressPoint = frame:CreateDrawable(TEXTURE_PATH.PREMIUM_SERVICE_GRADE_PROGRESS_BAR, "my_point", "background")
  progressPoint:SetVisible(false)
  local pointtextbox = frame:CreateChildWidget("textbox", "pointtextbox", 0, true)
  pointtextbox:SetExtent(100, 20)
  pointtextbox:AddAnchor("CENTER", progressPoint, 0, -7)
  pointtextbox.style:SetFontSize(FONT_SIZE.MIDDLE)
  pointtextbox.style:SetAlign(ALIGN_CENTER)
  pointtextbox:Show(false)
  local highlight = frame:CreateDrawable(TEXTURE_PATH.PREMIUM_SERVICE_GRADE_PROGRESS_BAR, "bar", "overlay")
  function SetProgressValue(point)
    local progressValue = 6
    if point ~= 0 then
      for i = 1, #premiumServiceGradePoint do
        if i == #premiumServiceGradePoint then
          progressValue = premiumServiceGradeProgress[maxGrade][1] + premiumServiceGradeProgress[maxGrade][2]
        elseif point >= premiumServiceGradePoint[i] and point < premiumServiceGradePoint[i + 1] then
          progressValue = premiumServiceGradeProgress[i][1] + (point - premiumServiceGradePoint[i]) / (premiumServiceGradePoint[i + 1] - premiumServiceGradePoint[i]) * premiumServiceGradeProgress[i][2]
          break
        end
      end
    end
    statusBar:SetValue(progressValue)
    progressPoint:AddAnchor("TOPLEFT", statusBar, progressValue - 38, -45)
    highlight:AddAnchor("TOPLEFT", statusBar, progressValue - 21, -8)
    if point == 0 or point == premiumServiceGradePoint[#premiumServiceGradePoint] then
      highlight:Show(false)
    else
      highlight:Show(true)
    end
  end
  function statusBar:OnEnter()
    pointtextbox:Show(true)
    progressPoint:SetVisible(true)
    pointtextbox:SetText(locale.premium.my_premium_point .. "\n" .. tostring(X2PremiumService:GetPremiumPoint()))
  end
  statusBar:SetHandler("OnEnter", statusBar.OnEnter)
  function statusBar:OnLeave()
    pointtextbox:Show(false)
    progressPoint:SetVisible(false)
  end
  statusBar:SetHandler("OnLeave", statusBar.OnLeave)
  local myPoint = X2PremiumService:GetPremiumPoint()
  SetProgressValue(myPoint)
  return frame
end
