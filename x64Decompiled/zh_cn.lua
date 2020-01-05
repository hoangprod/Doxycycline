if X2Util:GetGameProvider() == TENCENT then
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
  userTrialLocale.TrailType = {
    text = {
      locale.reportBadUser.reportTypeBot,
      locale.reportBadUser.reportTypeMail,
      locale.reportBadUser.reportTypeChat,
      locale.reportBadUser.reportTypeEtc
    },
    key = {
      1,
      2,
      3,
      4
    }
  }
  userTrialLocale.useMailTrail = true
end
