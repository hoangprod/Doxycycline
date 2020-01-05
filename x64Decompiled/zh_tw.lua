if X2Util:GetGameProvider() == PLAYWITH then
  userTrialLocale.rulingStatusWnd = {
    fontSize = {
      crimeListWndTitle = FONT_SIZE.LARGE,
      notGuilty = 60,
      guilty = 60
    },
    statusFontPath = "combat",
    statusTitleAnchor = {
      myPoint = "BOTTOMLEFT",
      targetPoint = "TOPLEFT",
      x = -10,
      y = -2
    },
    crimeTypeIcon = {
      offset = 60,
      width = 60,
      inset = 30
    }
  }
  userReportBadUser.BadUserRecords = {
    suspectedstringLimit = 17,
    reporttypestringLimit = 11,
    columnWidth = {
      228,
      151,
      162
    }
  }
end
