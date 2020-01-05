local PAGE_BUTTON_COLOR = {
  NORMAL = {
    ConvertColor(73),
    ConvertColor(45),
    ConvertColor(11),
    1
  },
  OVER = {
    ConvertColor(131),
    ConvertColor(91),
    ConvertColor(42),
    1
  },
  CLICK = {
    ConvertColor(82),
    ConvertColor(55),
    ConvertColor(20),
    1
  },
  DISABLE = {
    ConvertColor(111),
    ConvertColor(111),
    ConvertColor(111),
    1
  }
}
BUTTON_BASIC = {
  DEFAULT = {
    drawableType = "ninePart",
    path = TEXTURE_PATH.DEFAULT,
    coordsKey = "btn",
    autoResize = true,
    fontColor = GetButtonDefaultFontColor(),
    fontInset = {
      left = 11,
      right = 11,
      top = 0,
      bottom = 0
    }
  },
  DEFAULT_DRAWABLE = {
    drawableType = "drawable",
    path = nil,
    coordsKey = nil
  },
  DEFAULT_SMALL = {
    drawableType = "ninePart",
    path = TEXTURE_PATH.DEFAULT,
    coordsKey = "btn_small",
    autoResize = true,
    fontColor = GetButtonDefaultFontColor(),
    fontInset = {
      left = 11,
      right = 11,
      top = 0,
      bottom = 0
    }
  },
  TAB_SELECT = {
    drawableType = "threePart",
    path = TEXTURE_PATH.TAB_LIST,
    coordsKey = "tab_selected",
    fontColor = GetTitleButtonFontColor(),
    fontSize = FONT_SIZE.LARGE,
    fontInset = {
      left = 15,
      right = 15,
      top = 1,
      bottom = 0
    },
    autoResize = true
  },
  TAB_UNSELECT = {
    drawableType = "threePart",
    path = TEXTURE_PATH.TAB_LIST,
    coordsKey = "tab_unselected",
    fontColor = GetTitleButtonFontColor(),
    fontSize = FONT_SIZE.LARGE,
    fontInset = {
      left = 15,
      right = 15,
      top = 1,
      bottom = 0
    },
    autoResize = true
  },
  TAB_SELECT_FONT_MIDDLE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.TAB_LIST,
    coordsKey = "tab_selected",
    fontColor = GetTitleButtonFontColor(),
    fontSize = FONT_SIZE.MIDDLE,
    fontInset = {
      left = 15,
      right = 15,
      top = 1,
      bottom = 0
    },
    autoResize = true
  },
  TAB_UNSELECT_FONT_MIDDLE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.TAB_LIST,
    coordsKey = "tab_unselected",
    fontColor = GetTitleButtonFontColor(),
    fontSize = FONT_SIZE.MIDDLE,
    fontInset = {
      left = 15,
      right = 15,
      top = 1,
      bottom = 0
    },
    width = 80,
    height = 25,
    autoResize = true
  },
  TAB_SELECT_BATTLEFIELD_RESULT = {
    drawableType = "threePart",
    path = TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION,
    coordsKey = "tab_selected",
    fontColor = GetWhiteButtonFontColor(),
    fontSize = FONT_SIZE.MIDDLE,
    width = 170,
    height = 40,
    autoResize = true
  },
  TAB_UNSELECT_BATTLEFIELD_RESULT = {
    drawableType = "threePart",
    path = TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION,
    coordsKey = "tab_unselected",
    fontColor = GetWhiteButtonFontColor(),
    fontSize = FONT_SIZE.MIDDLE,
    width = 170,
    height = 40,
    autoResize = true
  },
  FOLDER_CLOSE = {
    drawableType = "drawable",
    path = "ui/button/grid.dds",
    coordsKey = "opened",
    width = 21,
    height = 21,
    drawableAnchor = {
      anchor = "LEFT",
      x = -1,
      y = 0
    },
    drawableExtent = {width = 21, height = 14}
  },
  FOLDER_OPEN = {
    drawableType = "drawable",
    path = "ui/button/grid.dds",
    coordsKey = "closed",
    width = 21,
    height = 21,
    drawableAnchor = {
      anchor = "CENTER",
      x = 0,
      y = 1
    },
    drawableExtent = {width = 13, height = 21}
  },
  SPINNER_UP = {
    drawableType = "drawable",
    path = "ui/button/grid.dds",
    coords = {
      normal = {
        0,
        14,
        21,
        -14
      },
      over = {
        0,
        29,
        21,
        -14
      },
      click = {
        22,
        16,
        21,
        -14
      },
      disable = {
        22,
        28,
        21,
        -14
      }
    },
    width = 21,
    height = 14
  },
  SERVER_SLIDER_VERTICAL_THUMB = {
    drawableType = "ninePart",
    path = "ui/button/scroll_button.dds",
    coords = {
      normal = {
        0,
        10,
        17,
        41
      },
      over = {
        18,
        10,
        17,
        41
      },
      click = {
        36,
        10,
        17,
        41
      },
      disable = {
        54,
        10,
        17,
        41
      }
    },
    inset = {
      0,
      22,
      0,
      18
    },
    width = 17,
    height = 41
  },
  SLIDER_VERTICAL_THUMB = {
    drawableType = "ninePart",
    path = "ui/button/scroll_button.dds",
    coords = {
      normal = {
        0,
        10,
        17,
        41
      },
      over = {
        18,
        10,
        17,
        41
      },
      click = {
        36,
        10,
        17,
        41
      },
      disable = {
        54,
        10,
        17,
        41
      }
    },
    inset = {
      0,
      22,
      0,
      18
    },
    width = 17,
    height = 41
  },
  SLIDER_VERTICAL_MINI_THUMB = {
    drawableType = "drawable",
    path = "ui/button/scroll_button.dds",
    coords = {
      normal = {
        101,
        17,
        17,
        27
      },
      over = {
        127,
        17,
        17,
        27
      },
      click = {
        153,
        17,
        17,
        27
      },
      disable = {
        179,
        17,
        17,
        27
      }
    },
    width = 17,
    height = 27
  },
  SLIDER_HORIZONTAL_THUMB = {
    drawableType = "drawable",
    path = "ui/button/scroll_button.dds",
    coords = {
      normal = {
        101,
        17,
        17,
        26
      },
      over = {
        127,
        17,
        17,
        26
      },
      click = {
        153,
        17,
        17,
        26
      },
      disable = {
        179,
        17,
        17,
        26
      }
    },
    width = 17,
    height = 26
  },
  SLIDER_UP = {
    drawableType = "drawable",
    path = "ui/button/scroll_button.dds",
    coords = {
      normal = {
        0,
        52,
        19,
        12
      },
      over = {
        20,
        52,
        19,
        12
      },
      click = {
        40,
        52,
        19,
        12
      },
      disable = {
        60,
        52,
        19,
        12
      }
    },
    width = 19,
    height = 12
  },
  SLIDER_DOWN = {
    drawableType = "drawable",
    path = "ui/button/scroll_button.dds",
    coords = {
      normal = {
        0,
        64,
        19,
        -12
      },
      over = {
        20,
        64,
        19,
        -12
      },
      click = {
        40,
        64,
        19,
        -12
      },
      disable = {
        60,
        64,
        19,
        -12
      }
    },
    width = 19,
    height = 11
  },
  WINDOW_CLOSE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.DEFAULT,
    coords = {
      normal = {
        949,
        0,
        44,
        38
      },
      over = {
        949,
        39,
        44,
        38
      },
      click = {
        949,
        79,
        44,
        38
      },
      disable = {
        949,
        117,
        44,
        38
      }
    },
    width = 44,
    height = 38
  },
  WINDOW_SMALL_CLOSE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "close_mini"
  },
  PAGE_FIRST = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.PAGE,
    coords = {
      normal = {
        28,
        0,
        -12,
        24
      },
      over = {
        28,
        0,
        -12,
        24
      },
      click = {
        28,
        0,
        -12,
        24
      },
      disable = {
        28,
        0,
        -12,
        24
      }
    },
    drawableColor = {
      normal = PAGE_BUTTON_COLOR.NORMAL,
      over = PAGE_BUTTON_COLOR.OVER,
      click = PAGE_BUTTON_COLOR.CLICK,
      disable = PAGE_BUTTON_COLOR.DISABLE
    },
    width = 12,
    height = 24
  },
  PAGE_PREV = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.PAGE,
    coords = {
      normal = {
        16,
        0,
        -16,
        32
      },
      over = {
        16,
        0,
        -16,
        32
      },
      click = {
        16,
        0,
        -16,
        32
      },
      disable = {
        16,
        0,
        -16,
        32
      }
    },
    drawableColor = {
      normal = PAGE_BUTTON_COLOR.NORMAL,
      over = PAGE_BUTTON_COLOR.OVER,
      click = PAGE_BUTTON_COLOR.CLICK,
      disable = PAGE_BUTTON_COLOR.DISABLE
    },
    width = 16,
    height = 32
  },
  PAGE_NEXT = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.PAGE,
    coords = {
      normal = {
        0,
        0,
        16,
        32
      },
      over = {
        0,
        0,
        16,
        32
      },
      click = {
        0,
        0,
        16,
        32
      },
      disable = {
        0,
        0,
        16,
        32
      }
    },
    drawableColor = {
      normal = PAGE_BUTTON_COLOR.NORMAL,
      over = PAGE_BUTTON_COLOR.OVER,
      click = PAGE_BUTTON_COLOR.CLICK,
      disable = PAGE_BUTTON_COLOR.DISABLE
    },
    width = 16,
    height = 32
  },
  PAGE_LAST = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.PAGE,
    coords = {
      normal = {
        16,
        0,
        12,
        24
      },
      over = {
        16,
        0,
        12,
        24
      },
      click = {
        16,
        0,
        12,
        24
      },
      disable = {
        16,
        0,
        12,
        24
      }
    },
    drawableColor = {
      normal = PAGE_BUTTON_COLOR.NORMAL,
      over = PAGE_BUTTON_COLOR.OVER,
      click = PAGE_BUTTON_COLOR.CLICK,
      disable = PAGE_BUTTON_COLOR.DISABLE
    },
    width = 12,
    height = 24
  },
  RESET = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.COMMON_RESET,
    coords = {
      normal = {
        0,
        0,
        28,
        28
      },
      over = {
        28,
        0,
        28,
        28
      },
      click = {
        56,
        0,
        28,
        28
      },
      disable = {
        84,
        0,
        28,
        28
      }
    },
    width = 28,
    height = 28
  },
  REMOVE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.COMMON_REMOVE,
    coords = {
      normal = {
        0,
        0,
        29,
        31
      },
      over = {
        28,
        0,
        29,
        31
      },
      click = {
        57,
        0,
        29,
        31
      },
      disable = {
        87,
        0,
        29,
        31
      }
    },
    width = 29,
    height = 31
  },
  QUESTION_MARK = {
    drawableType = "drawable",
    path = TEXTURE_PATH.QUESTION_BUTTON,
    coordsKey = "btn_reinforcement"
  },
  LISTCTRL_COLUMN = {
    drawableType = "threePart",
    path = TEXTURE_PATH.TAB_LIST,
    coords = {
      normal = {
        0,
        0,
        0,
        0
      },
      over = {
        135,
        65,
        17,
        20
      },
      click = {
        135,
        65,
        17,
        20
      },
      disable = {
        0,
        0,
        0,
        0
      }
    },
    inset = {
      3,
      0,
      3,
      0
    },
    drawableColor = {
      normal = {
        1,
        1,
        1,
        0
      },
      over = {
        1,
        1,
        1,
        0.7
      },
      click = {
        1,
        1,
        1,
        1
      },
      disable = {
        1,
        1,
        1,
        0
      }
    },
    drawableAnchor = {
      anchor = "CENTER",
      x = 0,
      y = 2
    },
    fontColor = GetTitleButtonFontColor(),
    fontSize = FONT_SIZE.LARGE
  },
  ROTATE_RIGHT = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.COMMON_ROTATE,
    coords = {
      normal = {
        0,
        0,
        38,
        46
      },
      over = {
        0,
        45,
        38,
        46
      },
      click = {
        38,
        -1,
        38,
        46
      },
      disable = {
        38,
        45,
        38,
        46
      }
    },
    width = 38,
    height = 46
  },
  ROTATE_LEFT = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.COMMON_ROTATE,
    coords = {
      normal = {
        38,
        0,
        -38,
        46
      },
      over = {
        38,
        45,
        -38,
        46
      },
      click = {
        76,
        -1,
        -38,
        46
      },
      disable = {
        76,
        45,
        -38,
        46
      }
    },
    width = 38,
    height = 46
  },
  TOGGLE_BEAUTYSHOP = {
    drawableType = "threePart",
    path = TEXTURE_PATH.INGAME_SHOP,
    coordsKey = "beautyshop",
    fontInset = {
      left = 40,
      top = 0,
      right = 13,
      bottom = 0
    },
    autoResize = true,
    fontAlign = ALIGN_LEFT,
    fontColor = GetWhiteCheckButtonFontColor()
  },
  TOGGLE_GENDER_TRANSFER = {
    drawableType = "threePart",
    path = TEXTURE_PATH.INGAME_SHOP,
    coordsKey = "gender_transfer",
    fontInset = {
      left = 40,
      top = 0,
      right = 13,
      bottom = 0
    },
    autoResize = true,
    fontAlign = ALIGN_LEFT,
    fontColor = GetWhiteCheckButtonFontColor()
  },
  SLOT_SHAPE = {
    drawableType = "ninePart",
    path = TEXTURE_PATH.HUD,
    layer = "overlay",
    coords = {
      normal = {
        0,
        0,
        0,
        0
      },
      over = {
        743,
        35,
        13,
        16
      },
      click = {
        0,
        0,
        0,
        0
      },
      disable = {
        0,
        0,
        0,
        0
      }
    },
    drawableColor = {
      normal = {
        0,
        0,
        0,
        0
      },
      over = {
        1,
        1,
        1,
        0.6
      },
      click = {
        0,
        0,
        0,
        0
      },
      disable = {
        0,
        0,
        0,
        0
      }
    },
    drawableAnchor = {
      offset = {
        topleftX = 1,
        topleftY = 1,
        bottomrightX = -1,
        bottomrightY = -1
      }
    },
    inset = {
      6,
      7,
      6,
      8
    },
    width = ICON_SIZE.DEFAULT,
    height = ICON_SIZE.DEFAULT
  },
  QUEST_NOTIFIER = {
    {
      drawableType = "threePart",
      path = TEXTURE_PATH.HUD,
      coords = {
        normal = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_df"):GetCoords()
        },
        over = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_ov"):GetCoords()
        },
        click = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_on"):GetCoords()
        },
        disable = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_dis"):GetCoords()
        }
      },
      inset = GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_df"):GetInset(),
      drawableColor = {
        normal = GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_df"):GetColors().default,
        over = GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_ov"):GetColors().default,
        click = GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_on"):GetColors().default,
        disable = GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_dis"):GetColors().default
      },
      drawableAnchor = {
        anchor = "BOTTOMLEFT",
        x = 0,
        y = 0
      },
      drawableExtent = {width = 60, height = 38},
      width = 60,
      height = 30
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.HUD,
      coords = {
        disable = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_df"):GetCoords()
        },
        over = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_ov"):GetCoords()
        },
        click = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_on"):GetCoords()
        },
        normal = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_dis"):GetCoords()
        }
      },
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = 0
      },
      drawableExtent = {width = 26, height = 29}
    }
  },
  ASSIGNMENT_NOTIFIER = {
    {
      drawableType = "threePart",
      path = TEXTURE_PATH.HUD,
      coords = {
        normal = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_df"):GetCoords()
        },
        over = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_ov"):GetCoords()
        },
        click = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_on"):GetCoords()
        },
        disable = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_dis"):GetCoords()
        }
      },
      inset = GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_df"):GetInset(),
      drawableColor = {
        normal = GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_df"):GetColors().default,
        over = GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_ov"):GetColors().default,
        click = GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_on"):GetColors().default,
        disable = GetTextureInfo(TEXTURE_PATH.HUD, "tab_quest_bg_dis"):GetColors().default
      },
      drawableAnchor = {
        anchor = "BOTTOMLEFT",
        x = 0,
        y = 0
      },
      drawableExtent = {width = 60, height = 38},
      width = 60,
      height = 30
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.HUD,
      coords = {
        disable = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_result_df"):GetCoords()
        },
        over = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_result_ov"):GetCoords()
        },
        click = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_result_on"):GetCoords()
        },
        normal = {
          GetTextureInfo(TEXTURE_PATH.HUD, "tab_result_dis"):GetCoords()
        }
      },
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = 0
      },
      drawableExtent = {width = 31, height = 27}
    }
  },
  PLUS = {
    drawableType = "drawable",
    path = TEXTURE_PATH.PLUS_MINUS,
    coordsKey = "plus"
  },
  MINUS = {
    drawableType = "drawable",
    path = TEXTURE_PATH.PLUS_MINUS,
    coordsKey = "minus"
  },
  HOUSING_SALE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.HOUSING,
    coordsKey = "btn_sale"
  },
  HOUSING_ROTATE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.HOUSING,
    coordsKey = "btn_rotation"
  },
  HOUSING_DEMOLISH = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.HOUSING,
    coordsKey = "btn_remove"
  },
  HOUSING_DEMOLISH_PACKAGE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.HOUSING,
    coordsKey = "btn_demolish"
  },
  HOUSING_UCC = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.HOUSING,
    coordsKey = "btn_ucc"
  },
  EQUIP_ITEM_GUIDE_MOVE_LEFT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.ITEM_GUIDE,
    coordsKey = "btn_left"
  },
  EQUIP_ITEM_GUIDE_MOVE_RIGHT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.ITEM_GUIDE,
    coordsKey = "btn_right"
  },
  EQUIP_ITEM_GUIDE_MAP = {
    drawableType = "drawable",
    path = TEXTURE_PATH.ITEM_GUIDE,
    coordsKey = "btn_map"
  },
  EQUIP_ITEM_GUIDE_CRAFT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.DICTIONARY,
    coordsKey = "btn_book"
  },
  SPECIALTY_BUY = {
    drawableType = "drawable",
    path = TEXTURE_PATH.SPECIALTY_BUY,
    coordsKey = "buy"
  },
  AUCTION_POST_BID = {
    drawableType = "ninePart",
    path = TEXTURE_PATH.REPLACE,
    coordsKey = "btn_replace",
    autoResize = true
  },
  AUCTION_POST_MIN_STACK = {
    drawableType = "ninePart",
    path = TEXTURE_PATH.DEFAULT,
    coordsKey = "btn_num",
    autoResize = true
  },
  AUCTION_BID_STACK = {
    drawableType = "ninePart",
    path = TEXTURE_PATH.DEFAULT,
    coordsKey = "btn_buy_num",
    autoResize = true
  },
  AUCTION_SEARCH_HEIR_ON = {
    drawableType = "drawable",
    path = TEXTURE_PATH.AUCTION,
    coordsKey = "successor",
    autoResize = true
  },
  AUCTION_SEARCH_HEIR_OFF = {
    drawableType = "drawable",
    path = TEXTURE_PATH.AUCTION,
    coordsKey = "successor_grey",
    autoResize = true
  },
  BANNER_EXIT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.BANNER_CLOSE,
    coordsKey = "btn_close",
    autoResize = true
  }
}
local EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS = {
  NORMAL = {
    0,
    86,
    128,
    84
  },
  OVER = {
    128,
    86,
    128,
    84
  },
  CLICK = {
    0,
    171,
    128,
    84
  },
  DISABLE = {
    128,
    171,
    128,
    84
  }
}
local EXPEDITION_ROLE_BACKGROUND_TEXTURE_EXTENT = {WIDTH = 128, HEIGHT = 84}
local EXPEDITION_ROLE_BUTTON_EXTENT = {WIDTH = 82, HEIGHT = 53}
local EXPEDITION_ROLE_BUTTON_OFFSET = {X = 12, Y = 2}
BUTTON_CONTENTS = {
  FAVORITE_PORTAL = {
    drawableType = "drawable",
    path = TEXTURE_PATH.PORTAL,
    coordsKey = "bookmark"
  },
  PAGE_FIRST = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.PAGE,
    coordsKey = "page_btn_small_150_reverse",
    colorKey = "default"
  },
  PAGE_PREV = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.PAGE,
    coordsKey = "page_btn_big_150_reverse",
    colorKey = "default"
  },
  PAGE_NEXT = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.PAGE,
    coordsKey = "page_btn_big_150",
    colorKey = "default"
  },
  PAGE_LAST = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.PAGE,
    coordsKey = "page_btn_small_150",
    colorKey = "default"
  },
  MAP_SCALE = {
    {
      drawableType = "drawable",
      path = BUTTON_TEXTURE_PATH.MAP,
      coords = {
        normal = {
          80,
          573,
          15,
          15
        },
        over = {
          80,
          573,
          15,
          15
        },
        click = {
          80,
          589,
          15,
          15
        },
        disable = {
          80,
          573,
          15,
          15
        }
      },
      fontPath = "actionBar",
      width = 15,
      height = 15
    },
    {
      drawableType = "drawable",
      path = BUTTON_TEXTURE_PATH.MAP,
      coords = {
        normal = {
          96,
          573,
          15,
          15
        },
        over = {
          96,
          573,
          15,
          15
        },
        click = {
          96,
          589,
          15,
          15
        },
        disable = {
          96,
          573,
          15,
          15
        }
      },
      fontPath = "actionBar",
      width = 15,
      height = 15
    },
    {
      drawableType = "drawable",
      path = BUTTON_TEXTURE_PATH.MAP,
      coords = {
        normal = {
          112,
          573,
          15,
          15
        },
        over = {
          112,
          573,
          15,
          15
        },
        click = {
          112,
          589,
          15,
          15
        },
        disable = {
          112,
          573,
          15,
          15
        }
      },
      fontPath = "actionBar",
      width = 15,
      height = 15
    }
  },
  MAP_SCALE_SELECTED = {
    {
      drawableType = "drawable",
      path = BUTTON_TEXTURE_PATH.MAP,
      coords = {
        normal = {
          80,
          589,
          15,
          15
        },
        over = {
          80,
          589,
          15,
          15
        },
        click = {
          80,
          589,
          15,
          15
        },
        disable = {
          80,
          573,
          15,
          15
        }
      },
      fontPath = "actionBar",
      width = 15,
      height = 15
    },
    {
      drawableType = "drawable",
      path = BUTTON_TEXTURE_PATH.MAP,
      coords = {
        normal = {
          96,
          589,
          15,
          15
        },
        over = {
          96,
          589,
          15,
          15
        },
        click = {
          96,
          589,
          15,
          15
        },
        disable = {
          96,
          573,
          15,
          15
        }
      },
      fontPath = "actionBar",
      width = 15,
      height = 15
    },
    {
      drawableType = "drawable",
      path = BUTTON_TEXTURE_PATH.MAP,
      coords = {
        normal = {
          112,
          589,
          15,
          15
        },
        over = {
          112,
          589,
          15,
          15
        },
        click = {
          112,
          589,
          15,
          15
        },
        disable = {
          112,
          573,
          15,
          15
        }
      },
      fontPath = "actionBar",
      width = 15,
      height = 15
    }
  },
  MAP_FILTER_OPEN = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.MAP,
    coords = {
      normal = {
        0,
        593,
        19,
        19
      },
      over = {
        20,
        593,
        19,
        19
      },
      click = {
        40,
        593,
        19,
        19
      },
      disable = {
        60,
        593,
        19,
        19
      }
    },
    width = 19,
    height = 19
  },
  MAP_FILTER_CLOSE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.MAP,
    coords = {
      normal = {
        0,
        573,
        19,
        19
      },
      over = {
        20,
        573,
        19,
        19
      },
      click = {
        40,
        573,
        19,
        19
      },
      disable = {
        60,
        573,
        19,
        19
      }
    },
    width = 19,
    height = 19
  },
  MAP_MY_POS_BTN = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.MAP,
    coordsKey = "position"
  },
  MAP_PING_BTN = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.MAP,
    coordsKey = "mark"
  },
  MAP_ROUTE_BTN = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.MAP,
    coordsKey = "line"
  },
  MAP_ENEMY_BTN = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.MAP,
    coordsKey = "enemy"
  },
  MAP_ATTACK_BTN = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.MAP,
    coordsKey = "attack"
  },
  MAP_LINE_BTN = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.MAP,
    coordsKey = "drawing"
  },
  MAP_ERASER_BTN = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.MAP,
    coordsKey = "eraser"
  },
  CINEMA_NEXT = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.CINEMA,
    coordsKey = "next",
    drawableAnchor = {
      anchor = "TOP",
      x = -1,
      y = 0
    },
    drawableExtent = {width = 48, height = 43},
    fontSize = FONT_SIZE.LARGE,
    fontAlign = ALIGN_BOTTOM,
    width = 80,
    height = 65,
    fontColor = GetQuestDirectingButtonFontColor()
  },
  CINEMA_PREV = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.CINEMA,
    coordsKey = "prev",
    drawableAnchor = {
      anchor = "TOP",
      x = -1,
      y = 0
    },
    fontSize = FONT_SIZE.LARGE,
    fontAlign = ALIGN_BOTTOM,
    width = 80,
    height = 65,
    fontColor = GetQuestDirectingButtonFontColor()
  },
  CINEMA_ACCEPT = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.CINEMA,
    coordsKey = "accept",
    drawableAnchor = {
      anchor = "TOP",
      x = 0,
      y = 0
    },
    drawableExtent = {width = 48, height = 48},
    fontSize = FONT_SIZE.LARGE,
    fontAlign = ALIGN_BOTTOM,
    width = 80,
    height = 65,
    fontColor = GetQuestDirectingButtonFontColor()
  },
  CINEMA_CLOSE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.CINEMA,
    coordsKey = "close"
  },
  STORE_PAGE_NEXT = {
    drawableType = "drawable",
    path = "ui/button/grid.dds",
    coords = {
      normal = {
        44,
        0,
        13,
        21
      },
      over = {
        58,
        0,
        13,
        21
      },
      click = {
        72,
        0,
        13,
        21
      },
      disable = {
        86,
        0,
        13,
        21
      }
    },
    width = 80,
    height = 25,
    fontAlign = ALIGN_RIGHT,
    fontInset = {
      left = 0,
      top = 0,
      right = 17,
      bottom = 0
    },
    drawableAnchor = {
      anchor = "RIGHT",
      x = 0,
      y = 0
    },
    drawableExtent = {width = 13, height = 21}
  },
  PREV_PAGE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.COMMON_BACK,
    coordsKey = "back_btn",
    fontInset = {
      left = 30,
      top = 5,
      right = 0,
      bottom = 0
    },
    drawableExtent = {width = 28, height = 28},
    drawableAnchor = {
      anchor = "LEFT",
      x = 0,
      y = 0
    },
    width = 28,
    height = 28,
    fontAlign = ALIGN_LEFT,
    autoResize = true
  },
  MAP_OPEN = {
    drawableType = "drawable",
    path = TEXTURE_PATH.PORTAL,
    coords = {
      normal = {
        0,
        0,
        31,
        18
      },
      over = {
        32,
        0,
        31,
        18
      },
      click = {
        0,
        19,
        31,
        18
      },
      disable = {
        31,
        19,
        31,
        18
      }
    },
    width = 31,
    height = 18
  },
  QUEST_REWARD_ITEM = {
    drawableType = "drawable",
    path = "ui/button/reward.dds",
    coords = {
      normal = {
        0,
        0,
        198,
        64
      },
      over = {
        0,
        64,
        198,
        64
      },
      click = {
        0,
        128,
        198,
        64
      },
      disable = {
        0,
        193,
        198,
        64
      }
    },
    drawableColor = {
      normal = {
        1,
        1,
        1,
        1
      },
      over = {
        1,
        1,
        1,
        1
      },
      click = {
        1,
        1,
        1,
        1
      },
      disable = {
        1,
        1,
        1,
        0.15
      }
    },
    width = 240,
    height = ICON_SIZE.DEFAULT,
    drawableAnchor = {
      anchor = "LEFT",
      x = 25,
      y = 0
    },
    drawableExtent = {width = 230, height = 64},
    fontInset = {
      left = 50,
      top = 0,
      right = 10,
      bottom = 0
    },
    fontAlign = ALIGN_LEFT,
    ellipsis = true,
    fontColor = GetButtonDefaultFontColor()
  },
  CUTSCENE_REPLAY = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.CUTSCENE_REPLAY,
    coords = {
      normal = {
        0,
        0,
        223,
        167
      },
      over = {
        223,
        0,
        223,
        167
      },
      click = {
        0,
        167,
        223,
        167
      },
      disable = {
        223,
        167,
        223,
        167
      }
    },
    width = 223,
    height = 167,
    fontColor = GetButtonDefaultFontColor(),
    fontAlign = ALIGN_BOTTOM,
    fontInset = {
      left = 25,
      top = 0,
      right = 0,
      bottom = 20
    }
  },
  LOOT_ITEM_LIST = {
    drawableType = "drawable",
    path = "ui/button/reward.dds",
    coords = {
      normal = {
        0,
        0,
        198,
        64
      },
      over = {
        0,
        64,
        198,
        64
      },
      click = {
        0,
        128,
        198,
        64
      },
      disable = {
        0,
        193,
        198,
        64
      }
    },
    drawableExtent = {width = 200, height = 64},
    drawableAnchor = {
      anchor = "LEFT",
      x = 0,
      y = 0
    },
    width = 200,
    height = 54,
    fontColor = GetButtonDefaultFontColor()
  },
  APPELLATION_LIST = {
    drawableType = "ninePart",
    path = TEXTURE_PATH.TAB_LIST,
    coords = {
      normal = {
        0,
        0,
        0,
        0
      },
      over = {
        0,
        65,
        134,
        11
      },
      click = {
        0,
        65,
        134,
        11
      },
      disable = {
        0,
        0,
        0,
        0
      }
    },
    drawableColor = {
      normal = {
        0,
        0,
        0,
        0
      },
      over = {
        ConvertColor(150),
        ConvertColor(197),
        ConvertColor(220),
        0.4
      },
      click = {
        ConvertColor(150),
        ConvertColor(197),
        ConvertColor(220),
        0.6
      },
      disable = {
        0,
        0,
        0,
        0
      }
    },
    inset = {
      66,
      5,
      67,
      5
    },
    drawableAnchor = {
      anchor = "CENTER",
      x = 0,
      y = 0
    },
    drawableExtent = {width = 330, height = 37},
    width = DEFAULT_SIZE.DIALOG_CONTENT_WIDTH,
    height = 37,
    fontAlign = ALIGN_LEFT,
    fontColor = GetButtonDefaultFontColor()
  },
  APPELLATION_SLOT = {
    drawableType = "drawable",
    path = "ui/icon_button.dds",
    coordsKey = "btn_stamp"
  },
  ARCHE_PASS_SLOT = {
    drawableType = "drawable",
    path = "ui/icon_button.dds",
    coordsKey = "btn_arche_pass"
  },
  APPELLATION_OPTION = {
    drawableType = "drawable",
    path = TEXTURE_PATH.APPELLATION_OPTION,
    coordsKey = "option"
  },
  OPEN_SIEGE_MEMBER_WINDOW = {
    drawableType = "drawable",
    path = TEXTURE_PATH.SIEGE_TAB,
    coords = {
      normal = {
        0,
        0,
        84,
        89
      },
      over = {
        84,
        0,
        84,
        89
      },
      click = {
        0,
        89,
        84,
        89
      },
      disable = {
        84,
        89,
        84,
        89
      }
    },
    width = 84,
    height = 89
  },
  SIEGE_PERIOD_DECLARE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.SIEGE_DECLARE_ICON,
    layer = "overlay",
    coordsKey = "prepare"
  },
  DEFENSE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.SIEGE_DEFENSE_ICON,
    layer = "overlay",
    coordsKey = "defense"
  },
  OFFENSE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.SIEGE_ATTACK_ICON,
    layer = "overlay",
    coordsKey = "attack"
  },
  OPTION_LIST = {
    drawableType = "drawable",
    path = TEXTURE_PATH.DEFAULT,
    coords = {
      normal = {
        687,
        332,
        312,
        58
      },
      over = {
        687,
        332,
        312,
        58
      },
      click = {
        687,
        332,
        312,
        58
      },
      disable = {
        687,
        332,
        312,
        58
      }
    },
    drawableColor = {
      normal = {
        0,
        0,
        0,
        0
      },
      over = {
        ConvertColor(217),
        ConvertColor(165),
        ConvertColor(104),
        0.7
      },
      click = {
        ConvertColor(79),
        ConvertColor(155),
        ConvertColor(235),
        0.7
      },
      disable = {
        0,
        0,
        0,
        0
      }
    },
    width = 170,
    height = 20,
    drawableAnchor = {
      anchor = "TOPLEFT",
      x = -15,
      y = -3
    },
    drawableExtent = {width = 170, height = 25},
    fontColor = GetOptionListButtonFontColor()
  },
  OPTION_KEY = {
    drawableType = "drawable",
    path = TEXTURE_PATH.OPTION,
    coords = {
      normal = {
        0,
        0,
        124,
        24
      },
      over = {
        0,
        0,
        124,
        24
      },
      click = {
        0,
        0,
        124,
        24
      },
      disable = {
        0,
        0,
        124,
        24
      }
    },
    drawableColor = {
      normal = {
        ConvertColor(177),
        ConvertColor(155),
        ConvertColor(124),
        1
      },
      over = {
        ConvertColor(192),
        ConvertColor(161),
        ConvertColor(110),
        1
      },
      click = {
        ConvertColor(156),
        ConvertColor(131),
        ConvertColor(89),
        1
      },
      disable = {
        ConvertColor(79),
        ConvertColor(79),
        ConvertColor(79),
        0.5
      }
    },
    width = 110,
    height = 24,
    fontSize = FONT_SIZE.SMALL,
    fontColor = GetOptionListKeyButtonFontColor()
  },
  OPTION_KEY_OVERRIDABLE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.OPTION,
    coords = {
      normal = {
        0,
        0,
        124,
        24
      },
      over = {
        0,
        0,
        124,
        24
      },
      click = {
        0,
        0,
        124,
        24
      },
      disable = {
        0,
        0,
        124,
        24
      }
    },
    drawableColor = {
      normal = {
        ConvertColor(139),
        ConvertColor(168),
        ConvertColor(189),
        1
      },
      over = {
        ConvertColor(142),
        ConvertColor(182),
        ConvertColor(218),
        1
      },
      click = {
        ConvertColor(101),
        ConvertColor(127),
        ConvertColor(149),
        1
      },
      disable = {
        ConvertColor(79),
        ConvertColor(79),
        ConvertColor(79),
        0.5
      }
    },
    width = 110,
    height = 24,
    fontSize = FONT_SIZE.SMALL,
    fontColor = GetOptionListOverrideKeyButtonFontColor()
  },
  MY_ABILITY = {
    drawableType = "drawable",
    path = TEXTURE_PATH.ABILITY_CHANGE,
    coords = {
      normal = {
        0,
        0,
        127,
        122
      },
      over = {
        128,
        0,
        127,
        122
      },
      click = {
        0,
        123,
        127,
        122
      },
      disable = {
        128,
        123,
        127,
        122
      }
    },
    width = localeView.abilityButton.extent[1],
    height = localeView.abilityButton.extent[2],
    fontInset = {
      left = localeView.abilityButton.fontInset[1],
      top = localeView.abilityButton.fontInset[2],
      right = localeView.abilityButton.fontInset[3],
      bottom = localeView.abilityButton.fontInset[4]
    },
    fontColor = GetMyAbilityButtonFontColor(),
    fontPath = FONT_PATH.LEEYAGI,
    fontSize = localeView.abilityButton.fontSize
  },
  ALL_ABILITY = {
    drawableType = "drawable",
    path = TEXTURE_PATH.DEFAULT,
    coordsKey = "brush",
    colorKey = "default",
    fontColor = GetAbilityButtonFontColor(),
    fontSize = FONT_SIZE.LARGE,
    fontInset = {
      left = 15,
      top = 0,
      right = 15,
      bottom = 0
    },
    autoResize = true
  },
  SEARCH = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.COMMON_READING_GLASSES,
    coordsKey = "btn_view",
    colorKey = "default"
  },
  SEARCH_GREEN = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.COMMON_READING_GLASSES,
    coordsKey = "btn_view",
    colorKey = "green"
  },
  INFOBAR_LEFT = {
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.DEFAULT,
      coords = {
        normal = {
          360,
          844,
          28,
          28
        },
        over = {
          360,
          872,
          28,
          28
        },
        click = {
          360,
          900,
          28,
          28
        },
        disable = {
          360,
          928,
          28,
          28
        }
      },
      width = 28,
      height = 28
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.DEFAULT,
      coords = {
        normal = {
          388,
          844,
          28,
          28
        },
        over = {
          388,
          872,
          28,
          28
        },
        click = {
          388,
          900,
          28,
          28
        },
        disable = {
          388,
          928,
          28,
          28
        }
      },
      width = 28,
      height = 28
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.DEFAULT,
      coords = {
        normal = {
          416,
          844,
          28,
          28
        },
        over = {
          416,
          872,
          28,
          28
        },
        click = {
          416,
          900,
          28,
          28
        },
        disable = {
          416,
          928,
          28,
          28
        }
      },
      width = 28,
      height = 28
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.DEFAULT,
      coords = {
        normal = {
          442,
          844,
          28,
          28
        },
        over = {
          442,
          872,
          28,
          28
        },
        click = {
          442,
          900,
          28,
          28
        },
        disable = {
          442,
          928,
          28,
          28
        }
      },
      width = 28,
      height = 28
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.DEFAULT,
      coords = {
        normal = {
          472,
          844,
          28,
          28
        },
        over = {
          472,
          872,
          28,
          28
        },
        click = {
          472,
          900,
          28,
          28
        },
        disable = {
          472,
          928,
          28,
          28
        }
      },
      width = 28,
      height = 28
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.DEFAULT,
      coords = {
        normal = {
          500,
          844,
          28,
          28
        },
        over = {
          500,
          872,
          28,
          28
        },
        click = {
          500,
          900,
          28,
          28
        },
        disable = {
          500,
          928,
          28,
          28
        }
      },
      width = 28,
      height = 28
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.DEFAULT,
      coords = {
        normal = {
          526,
          844,
          28,
          28
        },
        over = {
          526,
          872,
          28,
          28
        },
        click = {
          526,
          900,
          28,
          28
        },
        disable = {
          526,
          928,
          28,
          28
        }
      },
      width = 28,
      height = 28
    }
  },
  INFOBAR_RIGHT = {
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.DEFAULT,
      coords = {
        normal = {
          556,
          844,
          28,
          28
        },
        over = {
          556,
          872,
          28,
          28
        },
        click = {
          556,
          900,
          28,
          28
        },
        disable = {
          556,
          928,
          28,
          28
        }
      },
      width = 28,
      height = 28
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.DEFAULT,
      coords = {
        normal = {
          584,
          844,
          28,
          28
        },
        over = {
          584,
          872,
          28,
          28
        },
        click = {
          584,
          900,
          28,
          28
        },
        disable = {
          584,
          928,
          28,
          28
        }
      },
      width = 28,
      height = 28
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.DEFAULT,
      coords = {
        normal = {
          612,
          844,
          28,
          28
        },
        over = {
          612,
          872,
          28,
          28
        },
        click = {
          612,
          900,
          28,
          28
        },
        disable = {
          612,
          928,
          28,
          28
        }
      },
      width = 28,
      height = 28
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.DEFAULT,
      coords = {
        normal = {
          640,
          844,
          28,
          28
        },
        over = {
          640,
          872,
          28,
          28
        },
        click = {
          640,
          900,
          28,
          28
        },
        disable = {
          640,
          928,
          28,
          28
        }
      },
      width = 28,
      height = 28
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.DEFAULT,
      coords = {
        normal = {
          668,
          844,
          28,
          28
        },
        over = {
          668,
          872,
          28,
          28
        },
        click = {
          668,
          900,
          28,
          28
        },
        disable = {
          668,
          928,
          28,
          28
        }
      },
      width = 28,
      height = 28
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.DEFAULT,
      coords = {
        normal = {
          696,
          844,
          28,
          28
        },
        over = {
          696,
          872,
          28,
          28
        },
        click = {
          696,
          900,
          28,
          28
        },
        disable = {
          696,
          928,
          28,
          28
        }
      },
      width = 28,
      height = 28
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.DEFAULT,
      coords = {
        normal = {
          724,
          844,
          28,
          28
        },
        over = {
          724,
          872,
          28,
          28
        },
        click = {
          724,
          900,
          28,
          28
        },
        disable = {
          724,
          928,
          28,
          28
        }
      },
      width = 28,
      height = 28
    }
  },
  SKILL_ABILITY = {
    drawableType = "drawable",
    path = TEXTURE_PATH.SKILL,
    coords = {
      normal = {
        0,
        0,
        170,
        38
      },
      over = {
        0,
        38,
        170,
        38
      },
      click = {
        0,
        76,
        170,
        38
      },
      disable = {
        0,
        114,
        170,
        38
      }
    },
    width = 170,
    height = 38,
    fontSize = FONT_SIZE.LARGE,
    fontColor = GetAbilityButtonFontColor(),
    fontInset = {
      left = 0,
      top = 4,
      right = 0,
      bottom = 0
    }
  },
  SKILL_ABILITY_SAVE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.SKILL_BUTTON,
    coordsKey = "save"
  },
  SKILL_ABILITY_APPLY = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.SKILL_BUTTON,
    coordsKey = "apply"
  },
  SKILL_ABILITY_DELETE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.SKILL_BUTTON,
    coordsKey = "delete"
  },
  ACTABILITY_UP = {
    drawableType = "drawable",
    path = TEXTURE_PATH.SKILL,
    coords = {
      normal = {
        170,
        0,
        21,
        23
      },
      over = {
        191,
        0,
        21,
        23
      },
      click = {
        212,
        0,
        21,
        23
      },
      disable = {
        233,
        0,
        21,
        23
      }
    },
    width = 21,
    height = 23
  },
  HEIR_LEVEL_UP = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HEIR_SKILL,
    coordsKey = "lvl_up"
  },
  ACTABILITY_DOWN = {
    drawableType = "drawable",
    path = TEXTURE_PATH.SKILL,
    coords = {
      normal = {
        170,
        23,
        21,
        23
      },
      over = {
        191,
        23,
        21,
        23
      },
      click = {
        212,
        23,
        21,
        23
      },
      disable = {
        233,
        23,
        21,
        23
      }
    },
    width = 21,
    height = 23
  },
  EXPEDITION_ROLE_1 = {
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.EXPEDITION,
      coords = {
        normal = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.NORMAL,
        over = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.OVER,
        click = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.CLICK,
        disable = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.DISABLE
      },
      drawableAnchor = {
        anchor = "CENTER",
        x = EXPEDITION_ROLE_BUTTON_OFFSET.X,
        y = EXPEDITION_ROLE_BUTTON_OFFSET.Y
      },
      drawableExtent = {
        width = EXPEDITION_ROLE_BACKGROUND_TEXTURE_EXTENT.WIDTH,
        height = EXPEDITION_ROLE_BACKGROUND_TEXTURE_EXTENT.HEIGHT
      },
      width = EXPEDITION_ROLE_BUTTON_EXTENT.WIDTH,
      height = EXPEDITION_ROLE_BUTTON_EXTENT.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.EXPEDITION,
      coords = {
        normal = {
          0,
          0,
          40,
          26
        },
        over = {
          41,
          0,
          40,
          26
        },
        click = {
          82,
          0,
          40,
          26
        },
        disable = {
          123,
          0,
          40,
          26
        }
      },
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = 0
      },
      drawableExtent = {width = 40, height = 26}
    }
  },
  EXPEDITION_ROLE_2 = {
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.EXPEDITION,
      coords = {
        normal = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.NORMAL,
        over = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.OVER,
        click = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.CLICK,
        disable = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.DISABLE
      },
      drawableAnchor = {
        anchor = "CENTER",
        x = EXPEDITION_ROLE_BUTTON_OFFSET.X,
        y = EXPEDITION_ROLE_BUTTON_OFFSET.Y
      },
      drawableExtent = {
        width = EXPEDITION_ROLE_BACKGROUND_TEXTURE_EXTENT.WIDTH,
        height = EXPEDITION_ROLE_BACKGROUND_TEXTURE_EXTENT.HEIGHT
      },
      width = EXPEDITION_ROLE_BUTTON_EXTENT.WIDTH,
      height = EXPEDITION_ROLE_BUTTON_EXTENT.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.EXPEDITION,
      coords = {
        normal = {
          0,
          27,
          40,
          26
        },
        over = {
          41,
          27,
          40,
          26
        },
        click = {
          82,
          27,
          40,
          26
        },
        disable = {
          123,
          27,
          40,
          26
        }
      },
      drawableExtent = {width = 40, height = 26},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = 0
      }
    }
  },
  EXPEDITION_ROLE_3 = {
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.EXPEDITION,
      coords = {
        normal = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.NORMAL,
        over = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.OVER,
        click = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.CLICK,
        disable = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.DISABLE
      },
      drawableAnchor = {
        anchor = "CENTER",
        x = EXPEDITION_ROLE_BUTTON_OFFSET.X,
        y = EXPEDITION_ROLE_BUTTON_OFFSET.Y
      },
      drawableExtent = {
        width = EXPEDITION_ROLE_BACKGROUND_TEXTURE_EXTENT.WIDTH,
        height = EXPEDITION_ROLE_BACKGROUND_TEXTURE_EXTENT.HEIGHT
      },
      width = EXPEDITION_ROLE_BUTTON_EXTENT.WIDTH,
      height = EXPEDITION_ROLE_BUTTON_EXTENT.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.EXPEDITION,
      coords = {
        normal = {
          0,
          54,
          31,
          31
        },
        over = {
          32,
          54,
          31,
          31
        },
        click = {
          64,
          54,
          31,
          31
        },
        disable = {
          96,
          54,
          31,
          31
        }
      },
      drawableExtent = {width = 31, height = 31},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = 0
      }
    }
  },
  EXPEDITION_ROLE_4 = {
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.EXPEDITION,
      coords = {
        normal = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.NORMAL,
        over = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.OVER,
        click = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.CLICK,
        disable = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.DISABLE
      },
      drawableAnchor = {
        anchor = "CENTER",
        x = EXPEDITION_ROLE_BUTTON_OFFSET.X,
        y = EXPEDITION_ROLE_BUTTON_OFFSET.Y
      },
      drawableExtent = {
        width = EXPEDITION_ROLE_BACKGROUND_TEXTURE_EXTENT.WIDTH,
        height = EXPEDITION_ROLE_BACKGROUND_TEXTURE_EXTENT.HEIGHT
      },
      width = EXPEDITION_ROLE_BUTTON_EXTENT.WIDTH,
      height = EXPEDITION_ROLE_BUTTON_EXTENT.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.EXPEDITION,
      coords = {
        normal = {
          128,
          54,
          30,
          29
        },
        over = {
          159,
          54,
          30,
          29
        },
        click = {
          190,
          54,
          30,
          29
        },
        disable = {
          221,
          54,
          30,
          29
        }
      },
      drawableExtent = {width = 30, height = 29},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = 0
      }
    }
  },
  EXPEDITION_ROLE_5 = {
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.EXPEDITION,
      coords = {
        normal = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.NORMAL,
        over = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.OVER,
        click = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.CLICK,
        disable = EXPEDITION_ROLE_BACKGROUND_TEXTURE_COORDS.DISABLE
      },
      drawableAnchor = {
        anchor = "CENTER",
        x = EXPEDITION_ROLE_BUTTON_OFFSET.X,
        y = EXPEDITION_ROLE_BUTTON_OFFSET.Y
      },
      drawableExtent = {
        width = EXPEDITION_ROLE_BACKGROUND_TEXTURE_EXTENT.WIDTH,
        height = EXPEDITION_ROLE_BACKGROUND_TEXTURE_EXTENT.HEIGHT
      },
      width = EXPEDITION_ROLE_BUTTON_EXTENT.WIDTH,
      height = EXPEDITION_ROLE_BUTTON_EXTENT.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.EXPEDITION,
      coords = {
        normal = {
          164,
          0,
          15,
          29
        },
        over = {
          180,
          0,
          15,
          29
        },
        click = {
          196,
          0,
          15,
          29
        },
        disable = {
          212,
          0,
          15,
          29
        }
      },
      drawableExtent = {width = 15, height = 29},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = 0
      }
    }
  },
  EXPEDITION_INFO_WRITE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.EXPEDITION_WRITE,
    coordsKey = "btn_write"
  },
  FAMILY_INFO_WRITE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.FAMILY_WRITE,
    coordsKey = "btn_write"
  },
  FAMILY_LOCK = {
    drawableType = "drawable",
    path = TEXTURE_PATH.FAMILY_LOCK,
    coordsKey = "lock"
  },
  BAG_ICON = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INVENTORY_DEFAULT,
    coordsKey = "bg"
  },
  BAG_TAB_ICON = {
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          0,
          0,
          32,
          32
        },
        over = {
          32,
          0,
          32,
          32
        },
        click = {
          64,
          0,
          32,
          32
        },
        disable = {
          96,
          0,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 2,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          0,
          32,
          32,
          32
        },
        over = {
          32,
          32,
          32,
          32
        },
        click = {
          64,
          32,
          32,
          32
        },
        disable = {
          96,
          32,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 1,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          0,
          64,
          32,
          32
        },
        over = {
          32,
          64,
          32,
          32
        },
        click = {
          64,
          64,
          32,
          32
        },
        disable = {
          96,
          64,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          0,
          96,
          32,
          32
        },
        over = {
          32,
          96,
          32,
          32
        },
        click = {
          64,
          96,
          32,
          32
        },
        disable = {
          96,
          96,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          0,
          128,
          32,
          32
        },
        over = {
          32,
          128,
          32,
          32
        },
        click = {
          64,
          128,
          32,
          32
        },
        disable = {
          96,
          128,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          0,
          160,
          32,
          32
        },
        over = {
          32,
          160,
          32,
          32
        },
        click = {
          64,
          160,
          32,
          32
        },
        disable = {
          96,
          160,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          0,
          192,
          32,
          32
        },
        over = {
          32,
          192,
          32,
          32
        },
        click = {
          64,
          192,
          32,
          32
        },
        disable = {
          96,
          192,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          0,
          224,
          32,
          32
        },
        over = {
          32,
          224,
          32,
          32
        },
        click = {
          64,
          224,
          32,
          32
        },
        disable = {
          96,
          224,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          128,
          0,
          32,
          32
        },
        over = {
          160,
          0,
          32,
          32
        },
        click = {
          192,
          0,
          32,
          32
        },
        disable = {
          224,
          0,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          128,
          32,
          32,
          32
        },
        over = {
          160,
          32,
          32,
          32
        },
        click = {
          192,
          32,
          32,
          32
        },
        disable = {
          224,
          32,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          128,
          64,
          32,
          32
        },
        over = {
          160,
          64,
          32,
          32
        },
        click = {
          192,
          64,
          32,
          32
        },
        disable = {
          224,
          64,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          128,
          96,
          32,
          32
        },
        over = {
          160,
          96,
          32,
          32
        },
        click = {
          192,
          96,
          32,
          32
        },
        disable = {
          224,
          96,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          128,
          128,
          32,
          32
        },
        over = {
          160,
          128,
          32,
          32
        },
        click = {
          192,
          128,
          32,
          32
        },
        disable = {
          224,
          128,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          128,
          160,
          32,
          32
        },
        over = {
          160,
          160,
          32,
          32
        },
        click = {
          192,
          160,
          32,
          32
        },
        disable = {
          224,
          160,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          128,
          192,
          32,
          32
        },
        over = {
          160,
          192,
          32,
          32
        },
        click = {
          192,
          192,
          32,
          32
        },
        disable = {
          224,
          192,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          128,
          224,
          32,
          32
        },
        over = {
          160,
          224,
          32,
          32
        },
        click = {
          192,
          224,
          32,
          32
        },
        disable = {
          224,
          224,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          256,
          0,
          32,
          32
        },
        over = {
          288,
          0,
          32,
          32
        },
        click = {
          320,
          0,
          32,
          32
        },
        disable = {
          352,
          0,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.INVENTORY_DEFAULT,
      coords = {
        normal = {
          256,
          32,
          32,
          32
        },
        over = {
          288,
          32,
          32,
          32
        },
        click = {
          320,
          32,
          32,
          32
        },
        disable = {
          352,
          32,
          32,
          32
        }
      },
      drawableExtent = {width = 32, height = 32},
      drawableAnchor = {
        anchor = "CENTER",
        x = 0,
        y = -1
      },
      width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
      height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
    }
  },
  INVENTORY_TAB_ADD = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INVENTORY_DEFAULT,
    coords = {
      normal = {
        256,
        64,
        32,
        32
      },
      over = {
        288,
        64,
        32,
        32
      },
      click = {
        320,
        64,
        32,
        32
      },
      disable = {
        352,
        64,
        32,
        32
      }
    },
    drawableExtent = {width = 32, height = 32},
    drawableAnchor = {
      anchor = "CENTER",
      x = 0,
      y = 2
    },
    width = BUTTON_SIZE.IMAGE_TAB.WIDTH,
    height = BUTTON_SIZE.IMAGE_TAB.HEIGHT
  },
  INVENTORY_EXPAND = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INVENTORY_DEFAULT,
    coordsKey = "expansion"
  },
  INVENTORY_SORT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INVENTORY_DEFAULT,
    coordsKey = "reload"
  },
  INVENTORY_ENCHANT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INVENTORY_DEFAULT,
    coordsKey = "strengthen"
  },
  INVENTORY_REPAIR = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INVENTORY_DEFAULT,
    coordsKey = "repair"
  },
  INVENTORY_CONVERT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INVENTORY_DEFAULT,
    coordsKey = "convert"
  },
  INVENTORY_LOCK = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INVENTORY_DEFAULT,
    coordsKey = "lock"
  },
  INVENTORY_STORE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INVENTORY_DEFAULT,
    coordsKey = "bank"
  },
  INVENTORY_LOOT_GACHA = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INVENTORY_DEFAULT,
    coordsKey = "gacha"
  },
  INVENTORY_ITEM_GUIDE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INVENTORY_DEFAULT,
    coordsKey = "item_book"
  },
  CHAT_OPTION = {
    drawableType = "drawable",
    path = TEXTURE_PATH.DEFAULT,
    coordsKey = "brush",
    colorKey = "default",
    width = 90,
    height = 31,
    fontColor = GetAbilityButtonFontColor(),
    fontSize = FONT_SIZE.LARGE
  },
  VERDICT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.USER_TRIAL_RECORD,
    coordsKey = "paper",
    fontSize = FONT_SIZE.LARGE,
    fontPath = FONT_PATH.LEEYAGI
  },
  PET_STATE = {
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.PET,
      coordsKey = "btn_knife"
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.PET,
      coordsKey = "btn_shield"
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.PET,
      coordsKey = "btn_arrow"
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.PET,
      coordsKey = "btn_hand"
    }
  },
  CHARACTER_INFO_DETAIL = {
    drawableType = "drawable",
    path = TEXTURE_PATH.CHARACTER_INFO,
    coords = {
      normal = {
        477,
        0,
        34,
        29
      },
      over = {
        477,
        30,
        34,
        29
      },
      click = {
        477,
        59,
        34,
        29
      },
      disable = {
        477,
        89,
        34,
        29
      }
    },
    width = 34,
    height = 29
  },
  CHARACTER_INFO_SHOP = {
    drawableType = "drawable",
    path = TEXTURE_PATH.CHARACTER_INFO,
    coordsKey = "btn_shop"
  },
  EQUIP_OPEN = {
    drawableType = "drawable",
    path = TEXTURE_PATH.CHARACTER_INFO,
    coords = {
      normal = {
        483,
        119,
        14,
        44
      },
      over = {
        498,
        119,
        14,
        44
      },
      click = {
        483,
        164,
        14,
        44
      },
      disable = {
        483,
        164,
        14,
        44
      }
    },
    width = 14,
    height = 44
  },
  EQUIP_CLOSE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.CHARACTER_INFO,
    coords = {
      normal = {
        497,
        119,
        -14,
        44
      },
      over = {
        512,
        119,
        -14,
        44
      },
      click = {
        497,
        164,
        -14,
        44
      },
      disable = {
        512,
        164,
        -14,
        44
      }
    },
    width = 14,
    height = 44
  },
  EQUIP_UP = {
    drawableType = "drawable",
    path = "ui/button/scroll_button.dds",
    coords = {
      normal = {
        80,
        52,
        19,
        12
      },
      over = {
        80,
        52,
        19,
        12
      },
      click = {
        80,
        52,
        19,
        12
      },
      disable = {
        80,
        52,
        19,
        12
      }
    },
    drawableColor = {
      normal = {
        1,
        1,
        1,
        0.5
      },
      over = {
        1,
        1,
        1,
        0.7
      },
      click = {
        1,
        1,
        1,
        1
      },
      disable = {
        1,
        1,
        1,
        0.2
      }
    },
    width = 19,
    height = 12
  },
  EQUIP_DOWN = {
    drawableType = "drawable",
    path = "ui/button/scroll_button.dds",
    coords = {
      normal = {
        80,
        64,
        19,
        -12
      },
      over = {
        80,
        64,
        19,
        -12
      },
      click = {
        80,
        64,
        19,
        -12
      },
      disable = {
        80,
        64,
        19,
        -12
      }
    },
    drawableColor = {
      normal = {
        1,
        1,
        1,
        0.5
      },
      over = {
        1,
        1,
        1,
        0.7
      },
      click = {
        1,
        1,
        1,
        1
      },
      disable = {
        1,
        1,
        1,
        0.2
      }
    },
    width = 19,
    height = 12
  },
  PRELIM_SWAP = {
    drawableType = "drawable",
    path = TEXTURE_PATH.CHARACTER_INFO,
    coordsKey = "swap"
  },
  PRELIM_SWAP_ON = {
    drawableType = "drawable",
    path = TEXTURE_PATH.CHARACTER_INFO,
    coordsKey = "swap_on"
  },
  PRELIM_EQUIP_LOCK_OFF = {
    drawableType = "drawable",
    path = TEXTURE_PATH.CHARACTER_INFO,
    coordsKey = "lock_off"
  },
  PRELIM_EQUIP_LOCK_ON = {
    drawableType = "drawable",
    path = TEXTURE_PATH.CHARACTER_INFO,
    coordsKey = "lock_on"
  },
  TRADE_CHECK_GREEN = {
    drawableType = "drawable",
    path = TEXTURE_PATH.TRADE_GREEN_BTN,
    coordsKey = "btn_trade_green"
  },
  TRADE_CHECK_YELLOW = {
    drawableType = "drawable",
    path = TEXTURE_PATH.TRADE_YELLOW_BTN,
    coordsKey = "btn_trade_yellow"
  },
  UCC_ITEM = {
    drawableType = "ninePart",
    path = TEXTURE_PATH.UCC,
    layer = "overlay",
    inset = {
      7,
      7,
      7,
      7
    },
    coords = {
      normal = {
        1,
        35,
        9,
        9
      },
      over = {
        27,
        0,
        16,
        16
      },
      click = {
        44,
        0,
        16,
        16
      },
      disable = {
        1,
        35,
        9,
        9
      }
    },
    width = 48,
    height = 48
  },
  BATTLEFIELD_ALARM = {
    drawableType = "drawable",
    path = TEXTURE_PATH.BATTLEFIELD_ENTRANCE_BUTTON,
    coordsKey = "btn_shield"
  },
  RAID_RECRUIT_ALARM = {
    drawableType = "drawable",
    path = TEXTURE_PATH.RAID_RECRUIT_ALARM,
    coordsKey = "raid_btn"
  },
  READY_TO_SIEGE_ALARM = {
    drawableType = "drawable",
    path = TEXTURE_PATH.READY_TO_SIEGE_ALARM,
    coordsKey = "btn_prepare"
  },
  SIEGE_WAR_ALARM = {
    drawableType = "drawable",
    path = TEXTURE_PATH.SIEGE_WAR_ALARM,
    coordsKey = "btn_siege"
  },
  EXPEDITION_WAR_ALARM = {
    drawableType = "drawable",
    path = TEXTURE_PATH.EXPEDITION_WAR_ALARM,
    coordsKey = "btn_expedition"
  },
  ZONE_PERMISSION_WAIT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.ZONE_PERMISSION_WAIT,
    coordsKey = "btn_standby"
  },
  ZONE_PERMISSION_OUT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.ZONE_PERMISSION_OUT,
    coordsKey = "btn_exit"
  },
  BOOK_NEXT = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.PAGE,
    coords = {
      normal = {
        0,
        0,
        16,
        32
      },
      over = {
        0,
        0,
        16,
        32
      },
      click = {
        0,
        0,
        16,
        32
      },
      disable = {
        0,
        0,
        16,
        32
      }
    },
    drawableColor = {
      normal = PAGE_BUTTON_COLOR.NORMAL,
      over = PAGE_BUTTON_COLOR.OVER,
      click = PAGE_BUTTON_COLOR.CLICK,
      disable = PAGE_BUTTON_COLOR.DISABLE
    },
    drawableAnchor = {
      anchor = "RIGHT",
      x = 0,
      y = 0
    },
    fontInset = {
      top = 0,
      left = 0,
      bottom = 0,
      right = 18
    },
    fontAlign = ALIGN_LEFT,
    drawableExtent = {width = 16, height = 32},
    width = 40,
    height = 32
  },
  BOOK_PREV = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.PAGE,
    coords = {
      normal = {
        16,
        0,
        -16,
        32
      },
      over = {
        16,
        0,
        -16,
        32
      },
      click = {
        16,
        0,
        -16,
        32
      },
      disable = {
        16,
        0,
        -16,
        32
      }
    },
    drawableColor = {
      normal = PAGE_BUTTON_COLOR.NORMAL,
      over = PAGE_BUTTON_COLOR.OVER,
      click = PAGE_BUTTON_COLOR.CLICK,
      disable = PAGE_BUTTON_COLOR.DISABLE
    },
    drawableAnchor = {
      anchor = "LEFT",
      x = 0,
      y = 0
    },
    fontInset = {
      top = 0,
      left = 18,
      bottom = 0,
      right = 0
    },
    fontAlign = ALIGN_LEFT,
    drawableExtent = {width = 16, height = 32},
    width = 40,
    height = 32
  },
  LOCK_ITEM = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.LOCK,
    coords = {
      normal = {
        0,
        0,
        77,
        69
      },
      over = {
        77,
        0,
        77,
        69
      },
      click = {
        154,
        0,
        77,
        69
      },
      disable = {
        231,
        0,
        77,
        69
      }
    },
    width = 77,
    height = 69,
    drawableAnchor = {
      anchor = "CENTER",
      x = 0,
      y = 0
    }
  },
  LOCK_EQUIP = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.LOCK,
    coords = {
      normal = {
        0,
        69,
        77,
        69
      },
      over = {
        77,
        69,
        77,
        69
      },
      click = {
        154,
        69,
        77,
        69
      },
      disable = {
        231,
        69,
        77,
        69
      }
    },
    width = 77,
    height = 69,
    drawableAnchor = {
      anchor = "CENTER",
      x = 0,
      y = 0
    }
  },
  UNLOCK_ITEM = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.LOCK,
    coords = {
      normal = {
        0,
        138,
        77,
        69
      },
      over = {
        77,
        138,
        77,
        69
      },
      click = {
        154,
        138,
        77,
        69
      },
      disable = {
        231,
        138,
        77,
        69
      }
    },
    width = 77,
    height = 69,
    drawableAnchor = {
      anchor = "CENTER",
      x = 0,
      y = 0
    }
  },
  UNLOCK_EQUIP = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.LOCK,
    coords = {
      normal = {
        308,
        0,
        77,
        69
      },
      over = {
        385,
        0,
        77,
        69
      },
      click = {
        308,
        69,
        77,
        69
      },
      disable = {
        385,
        69,
        77,
        69
      }
    },
    width = 77,
    height = 69,
    drawableAnchor = {
      anchor = "CENTER",
      x = 0,
      y = 0
    }
  },
  SCREENSHOT_MODE_CLOSE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.SCREENSHOT_MODE_CLOSE,
    coords = {
      normal = {
        0,
        0,
        21,
        21
      },
      over = {
        21,
        0,
        21,
        21
      },
      click = {
        0,
        21,
        21,
        21
      },
      disable = {
        21,
        21,
        21,
        21
      }
    },
    width = 21,
    height = 21,
    drawableAnchor = {
      anchor = "CENTER",
      x = 0,
      y = 0
    }
  },
  MAIL_RECEIVE_MONEY = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.READ_MAIL,
    coordsKey = "btn_money"
  },
  MAIL_RECEIVE_ALL_ITEM = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.READ_MAIL,
    coordsKey = "btn_all"
  },
  MAIL_SELECTED_DELETE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.MAILBOX,
    coordsKey = "btn_select_delete"
  },
  MAIL_READ_MAIL_DELETE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.MAILBOX,
    coordsKey = "btn_read_delete"
  },
  MAIL_ALL_MAIL_DELETE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.MAILBOX,
    coordsKey = "btn_all_delete"
  },
  MAIL_TAKE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.MAILBOX,
    coordsKey = "btn_select_take"
  },
  MAIL_WRITE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.WRITE_MAIL,
    coordsKey = "btn_write"
  },
  INGAMESHOP_COMMERCIAL_MAIL = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INGAME_SHOP,
    coords = {
      normal = {
        787,
        196,
        46,
        36
      },
      over = {
        833,
        196,
        46,
        36
      },
      click = {
        879,
        196,
        46,
        36
      },
      disable = {
        925,
        196,
        46,
        36
      }
    },
    width = 46,
    height = 36
  },
  INGAMESHOP_SUB_MENU_SELECTED = {
    drawableType = "colorDrawable",
    drawableColor = {
      normal = {
        1,
        1,
        1,
        0
      },
      over = {
        1,
        1,
        1,
        0
      },
      click = {
        1,
        1,
        1,
        0
      },
      disable = {
        1,
        1,
        1,
        0
      }
    },
    fontColor = GetIngameShopSelectedSubMenuButtonFontColor(),
    width = 20,
    height = 20
  },
  INGAMESHOP_SUB_MENU_UNSELECTED = {
    drawableType = "colorDrawable",
    drawableColor = {
      normal = {
        1,
        1,
        1,
        0
      },
      over = {
        1,
        1,
        1,
        0
      },
      click = {
        1,
        1,
        1,
        0
      },
      disable = {
        1,
        1,
        1,
        0
      }
    },
    fontColor = GetIngameShopUnselectedSubMenuButtonFontColor(),
    width = 20,
    height = 20
  },
  INGAMESHOP_BUY = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INGAME_SHOP,
    coords = {
      normal = {
        675,
        0,
        27,
        23
      },
      over = {
        702,
        0,
        27,
        23
      },
      click = {
        729,
        0,
        27,
        23
      },
      disable = {
        756,
        0,
        27,
        23
      }
    },
    width = 27,
    height = 23
  },
  INGAMESHOP_PRESENT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INGAME_SHOP,
    coords = {
      normal = {
        783,
        0,
        27,
        23
      },
      over = {
        810,
        0,
        27,
        23
      },
      click = {
        837,
        0,
        27,
        23
      },
      disable = {
        864,
        0,
        27,
        23
      }
    },
    width = 27,
    height = 23
  },
  INGAMESHOP_CART = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INGAME_SHOP,
    coords = {
      normal = {
        891,
        0,
        27,
        23
      },
      over = {
        918,
        0,
        27,
        23
      },
      click = {
        945,
        0,
        27,
        23
      },
      disable = {
        972,
        0,
        27,
        23
      }
    },
    width = 27,
    height = 23
  },
  INGAMESHOP_DELETE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.INGAME_SHOP,
    coords = {
      normal = {
        839,
        23,
        40,
        20
      },
      over = {
        880,
        23,
        40,
        20
      },
      click = {
        921,
        23,
        40,
        20
      },
      disable = {
        962,
        23,
        40,
        20
      }
    },
    width = 42,
    height = 22,
    fontColor = GetButtonDefaultFontColor()
  },
  HOUSING_PREVIEW = {
    drawableType = "threePart",
    path = TEXTURE_PATH.HOUSING_REBUILDING,
    coordsKey = "btn_preview",
    autoResize = true,
    fontColor = GetButtonDefaultFontColor()
  },
  HOUSING_PREVIEW_MINI = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HOUSING_UCC_PREVIEW,
    coordsKey = "preview_btn",
    autoResize = true,
    drawableAnchor = {
      anchor = "LEFT",
      x = -1,
      y = 0
    },
    drawableExtent = {width = 70, height = 46},
    fontColor = GetButtonDefaultFontColor()
  },
  REPUTATION_GOOD = {
    drawableType = "drawable",
    path = TEXTURE_PATH.REPUTATION,
    coordsKey = "btn_good",
    fontAlign = ALIGN_BOTTOM,
    drawableAnchor = {
      anchor = "TOP",
      x = 0,
      y = 0
    },
    drawableExtent = {
      width = GetTextureInfo(TEXTURE_PATH.REPUTATION, "btn_good_df"):GetWidth(),
      height = GetTextureInfo(TEXTURE_PATH.REPUTATION, "btn_good_df"):GetHeight()
    },
    width = GetTextureInfo(TEXTURE_PATH.REPUTATION, "btn_good_df"):GetWidth(),
    height = GetTextureInfo(TEXTURE_PATH.REPUTATION, "btn_good_df"):GetHeight() + 10,
    fontColor = {
      normal = FONT_COLOR.GENDER_MALE,
      highlight = FONT_COLOR.BLUE,
      pushed = FONT_COLOR.BLUE,
      disabled = FONT_COLOR.DEFAULT
    },
    fontSize = FONT_SIZE.XLARGE,
    fontPath = FONT_PATH.LEEYAGI
  },
  REPUTATION_NOGOOD = {
    drawableType = "drawable",
    path = TEXTURE_PATH.REPUTATION,
    coordsKey = "btn_nogood",
    fontAlign = ALIGN_BOTTOM,
    drawableAnchor = {
      anchor = "TOP",
      x = 0,
      y = 0
    },
    drawableExtent = {
      width = GetTextureInfo(TEXTURE_PATH.REPUTATION, "btn_nogood_df"):GetWidth(),
      height = GetTextureInfo(TEXTURE_PATH.REPUTATION, "btn_nogood_df"):GetHeight()
    },
    width = GetTextureInfo(TEXTURE_PATH.REPUTATION, "btn_nogood_df"):GetWidth(),
    height = GetTextureInfo(TEXTURE_PATH.REPUTATION, "btn_nogood_df"):GetHeight() + 10,
    fontColor = {
      normal = FONT_COLOR.GENDER_FEMALE,
      highlight = FONT_COLOR.ROSE_PINK,
      pushed = FONT_COLOR.ROSE_PINK,
      disabled = FONT_COLOR.DEFAULT
    },
    fontSize = FONT_SIZE.XLARGE,
    fontPath = FONT_PATH.LEEYAGI
  },
  MARKET_PRICE = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.MARKET_PRICE,
    coordsKey = "price"
  },
  REPORT = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.READ_MAIL,
    coordsKey = "btn_report"
  },
  ENCHANT_TAB_EVOLVING = {
    drawableType = "drawable",
    path = TEXTURE_PATH.ENCHANT_TAB,
    coordsKey = "compose"
  },
  ENCHANT_TAB_GRADE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.ENCHANT_TAB,
    coordsKey = "grade"
  },
  ENCHANT_TAB_SOCKET = {
    drawableType = "drawable",
    path = TEXTURE_PATH.ENCHANT_TAB,
    coordsKey = "crescent_moon"
  },
  ENCHANT_TAB_GEM = {
    drawableType = "drawable",
    path = TEXTURE_PATH.ENCHANT_TAB,
    coordsKey = "full_moon"
  },
  ENCHANT_TAB_SCALE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.ENCHANT_TAB,
    coordsKey = "refurbishment"
  },
  ENCHANT_TAB_SMELTING = {
    drawableType = "drawable",
    path = TEXTURE_PATH.ENCHANT_TAB,
    coordsKey = "smelt"
  },
  ENCHANT_TAB_AWAKEN = {
    drawableType = "drawable",
    path = TEXTURE_PATH.ENCHANT_TAB,
    coordsKey = "awaken"
  },
  COMMUNITY_TAB_RELATION = {
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.COMMUNITY_BUTTON,
      coordsKey = "btn_bg",
      colorKey = "default",
      fontSize = 15,
      fontAlign = ALIGN_LEFT,
      fontInset = {
        left = 54,
        top = 0,
        bottom = 0,
        right = 0
      }
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.COMMUNITY_BUTTON,
      coordsKey = "relation",
      drawableAnchor = {
        anchor = "LEFT",
        x = 0,
        y = 0
      }
    }
  },
  COMMUNITY_TAB_FAMILY = {
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.COMMUNITY_BUTTON,
      coordsKey = "btn_bg",
      colorKey = "default",
      fontSize = 15,
      fontAlign = ALIGN_LEFT,
      fontInset = {
        left = 58,
        top = 0,
        bottom = 0,
        right = 0
      }
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.COMMUNITY_BUTTON,
      coordsKey = "family",
      drawableAnchor = {
        anchor = "LEFT",
        x = 0,
        y = 0
      }
    }
  },
  COMMUNITY_TAB_EXPEDITION = {
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.COMMUNITY_BUTTON,
      coordsKey = "btn_bg",
      colorKey = "default",
      fontSize = 15,
      fontAlign = ALIGN_LEFT,
      fontInset = {
        left = 54,
        top = 0,
        bottom = 0,
        right = 0
      }
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.COMMUNITY_BUTTON,
      coordsKey = "expedition",
      drawableAnchor = {
        anchor = "LEFT",
        x = 0,
        y = 0
      }
    }
  },
  COMMUNITY_TAB_NATION = {
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.COMMUNITY_BUTTON,
      coordsKey = "btn_bg",
      colorKey = "default",
      fontSize = 15,
      fontAlign = ALIGN_LEFT,
      fontInset = {
        left = 58,
        top = 0,
        bottom = 0,
        right = 0
      }
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.COMMUNITY_BUTTON,
      coordsKey = "nation",
      drawableAnchor = {
        anchor = "LEFT",
        x = 0,
        y = 0
      }
    }
  },
  UTHSTIN_STAT_MAX_EXPAND = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.UTHSTIN_STAT_MAX_EXPAND,
    coordsKey = "btn_up"
  },
  UTHSTIN_OPEN = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.UTHSTIN_OPEN,
    coordsKey = "bless_uthstin"
  },
  ARROW = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.ARROW,
    coordsKey = "arrow"
  },
  SQUAD_ROLE_SELECT = {
    drawableType = "drawable",
    path = "ui/button/common/select_btn.dds",
    coordsKey = "select_btn",
    colorKey = "default"
  },
  HEIR_SKILL_RIGHT = {
    drawableType = "drawable",
    path = "ui/button/common/select_btn.dds",
    coordsKey = "select_btn",
    colorKey = "alpha_80"
  },
  HEIR_SKILL_LEFT = {
    drawableType = "drawable",
    path = "ui/button/common/select_btn.dds",
    coordsKey = "select_btn_rv",
    colorKey = "alpha_80"
  }
}
BUTTON_ICON = {
  PORTAL_DELETE = {
    drawableType = "icon",
    path = "ui/button/icon_shape/wastebasket.dds"
  },
  PORTAL_RENAME = {
    drawableType = "icon",
    path = "ui/button/icon_shape/pencil.dds"
  },
  PORTAL_SPAWN = {
    drawableType = "icon",
    path = "ui/button/icon_shape/portal.dds"
  },
  ESC_SKIP = {
    drawableType = "icon",
    path = "ui/button/icon_shape/skip.dds",
    fontInset = {
      left = 0,
      top = 55,
      right = 0,
      bottom = 0
    },
    drawableAnchor = {
      anchor = "TOP",
      x = 0,
      y = 0
    },
    drawableExtent = {
      width = BUTTON_SIZE.ICON.WIDTH,
      height = BUTTON_SIZE.ICON.HEIGHT
    },
    width = BUTTON_SIZE.ICON.WIDTH,
    height = 75
  },
  ESC_WEB_WIKI = {
    drawableType = "icon",
    path = "ui/button/icon_shape/wiki.dds",
    fontInset = {
      left = 0,
      top = 55,
      right = 0,
      bottom = 0
    },
    drawableAnchor = {
      anchor = "TOP",
      x = 0,
      y = 0
    },
    drawableExtent = {
      width = BUTTON_SIZE.ICON.WIDTH,
      height = BUTTON_SIZE.ICON.HEIGHT
    },
    width = BUTTON_SIZE.ICON.WIDTH,
    height = 75
  },
  ESC_OPTION = {
    drawableType = "icon",
    path = "ui/button/icon_shape/option.dds",
    fontInset = {
      left = 0,
      top = 55,
      right = 0,
      bottom = 0
    },
    drawableAnchor = {
      anchor = "TOP",
      x = 0,
      y = 0
    },
    drawableExtent = {
      width = BUTTON_SIZE.ICON.WIDTH,
      height = BUTTON_SIZE.ICON.HEIGHT
    },
    width = BUTTON_SIZE.ICON.WIDTH,
    height = 75
  },
  ESC_CHARACTER_SELECT = {
    drawableType = "icon",
    path = "ui/button/icon_shape/characterselect.dds",
    fontInset = {
      left = 0,
      top = 55,
      right = 0,
      bottom = 0
    },
    drawableAnchor = {
      anchor = "TOP",
      x = 0,
      y = 0
    },
    drawableExtent = {
      width = BUTTON_SIZE.ICON.WIDTH,
      height = BUTTON_SIZE.ICON.HEIGHT
    },
    width = 54,
    height = 75
  },
  ESC_EXIT = {
    drawableType = "icon",
    path = "ui/button/icon_shape/exit.dds",
    fontInset = {
      left = 0,
      top = 55,
      right = 0,
      bottom = 0
    },
    drawableAnchor = {
      anchor = "TOP",
      x = 0,
      y = 0
    },
    drawableExtent = {
      width = BUTTON_SIZE.ICON.WIDTH,
      height = BUTTON_SIZE.ICON.HEIGHT
    },
    width = BUTTON_SIZE.ICON.WIDTH,
    height = 75
  },
  SKILL_RESET = {
    drawableType = "icon",
    path = "ui/button/icon_shape/skill_reset.dds"
  },
  SEARCH = {
    drawableType = "drawable",
    path = "ui/button/search.dds",
    coordsKey = "btn_search"
  },
  COMPLETE = {
    drawableType = "drawable",
    path = "ui/button/request.dds",
    coordsKey = "btn_complete"
  }
}
local GetExtentByKey = function(path, key, valueStr)
  local coords = UIParent:GetTextureData(path, key).coords
  if coords == nil then
    UIParent:Warning(string.format("can't find img info..(%s / %s)", path, key))
    return 0
  end
  if valueStr == "width" then
    return coords[3]
  elseif valueStr == "height" then
    return coords[4]
  elseif valueStr == nil then
    return coords[3], coords[4]
  end
end
BUTTON_HUD = {
  IME_KOREA = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        870,
        0,
        22,
        25
      },
      over = {
        870,
        26,
        22,
        25
      },
      click = {
        870,
        52,
        22,
        25
      },
      disable = {
        870,
        78,
        22,
        25
      }
    },
    width = 22,
    height = 25
  },
  IME_ENGLISH = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        870,
        104,
        22,
        25
      },
      over = {
        870,
        130,
        22,
        25
      },
      click = {
        870,
        156,
        22,
        25
      },
      disable = {
        870,
        182,
        22,
        25
      }
    },
    width = 22,
    height = 25
  },
  ACTIONBAR_ROTATE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "action_rotate"
  },
  ACTIONBAR_LOCK = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "action_lock"
  },
  ACTIONBAR_UNLOCK = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "action_unlock"
  },
  ACTIONBAR_PAGE_UP = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "action_page_up"
  },
  ACTIONBAR_PAGE_DOWN = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "action_page_down"
  },
  CHAT_SCROLL_DOWN_BOTTOM = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        754,
        175,
        28,
        26
      },
      over = {
        783,
        175,
        28,
        26
      },
      click = {
        812,
        175,
        28,
        26
      },
      disable = {
        841,
        175,
        28,
        26
      }
    },
    width = 22.4,
    height = 20.800001
  },
  CHAT_ADD_TAB = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        870,
        208,
        22,
        23
      },
      over = {
        870,
        234,
        22,
        23
      },
      click = {
        870,
        260,
        22,
        23
      },
      disable = {
        870,
        286,
        22,
        23
      }
    },
    width = 22,
    height = 23
  },
  ROAD_MAP_OPTION = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        624,
        215,
        22,
        22
      },
      over = {
        646,
        215,
        22,
        22
      },
      click = {
        624,
        237,
        22,
        22
      },
      disable = {
        646,
        237,
        22,
        22
      }
    },
    width = 22,
    height = 22
  },
  ROAD_SIZE_OPTION = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        480,
        432,
        30,
        22
      },
      over = {
        480,
        454,
        30,
        22
      },
      click = {
        480,
        476,
        30,
        22
      },
      disable = {
        510,
        432,
        30,
        22
      }
    },
    width = 30,
    height = 22,
    fontColor = GetRoadMapSizeButtonFontColor()
  },
  TUTORIAL = {
    drawableType = "drawable",
    path = TEXTURE_PATH.DEFAULT,
    coords = {
      normal = {
        361,
        581,
        39,
        41
      },
      over = {
        361,
        624,
        39,
        41
      },
      click = {
        401,
        581,
        39,
        41
      },
      disable = {
        401,
        623,
        39,
        41
      }
    },
    width = 39,
    height = 41
  },
  QUEST_TASK_MARKER = {
    drawableType = "drawable",
    path = TEXTURE_PATH.QUEST_LIST,
    coords = {
      normal = {
        0,
        474,
        37,
        27
      },
      over = {
        38,
        474,
        37,
        27
      },
      click = {
        76,
        473,
        37,
        27
      },
      disable = {
        114,
        474,
        37,
        27
      }
    },
    width = 31,
    height = 21
  },
  CHAT_TAB_SELECTED = {
    drawableType = "threePart",
    path = TEXTURE_PATH.HUD,
    coordsKey = "tab_chat_select",
    fontInset = {
      left = 0,
      top = 3,
      right = 0,
      bottom = 0
    },
    fontColor = {
      normal = FONT_COLOR.WHITE,
      highlight = FONT_COLOR.WHITE,
      pushed = FONT_COLOR.WHITE,
      disabled = {
        0.6,
        0.6,
        0.6,
        1
      }
    },
    disuseExtent = true
  },
  CHAT_TAB_UNSELECTED = {
    drawableType = "threePart",
    path = TEXTURE_PATH.HUD,
    coordsKey = "tab_chat",
    fontInset = {
      left = 0,
      top = 10,
      right = 0,
      bottom = 0
    },
    fontColor = {
      normal = {
        ConvertColor(120),
        ConvertColor(120),
        ConvertColor(120),
        1
      },
      highlight = {
        ConvertColor(200),
        ConvertColor(200),
        ConvertColor(200),
        1
      },
      pushed = FONT_COLOR.WHITE,
      disabled = {
        ConvertColor(63),
        ConvertColor(63),
        ConvertColor(63),
        1
      }
    },
    disuseExtent = true
  },
  MAIN_MENU_BAR_SUB_MENU = {
    drawableType = "ninePart",
    path = TEXTURE_PATH.HUD,
    width = 115,
    height = 16,
    inset = {
      3,
      2,
      3,
      1
    },
    coords = {
      normal = {
        0,
        0,
        0,
        0
      },
      over = {
        0,
        215,
        3,
        3
      },
      click = {
        0,
        215,
        3,
        3
      },
      disable = {
        0,
        0,
        0,
        0
      }
    },
    drawableColor = {
      normal = {
        0,
        0,
        0,
        0
      },
      over = {
        ConvertColor(184),
        ConvertColor(217),
        ConvertColor(226),
        0.5
      },
      click = {
        ConvertColor(184),
        ConvertColor(217),
        ConvertColor(236),
        0.3
      },
      disable = {
        0,
        0,
        0,
        0
      }
    },
    fontAlign = ALIGN_LEFT,
    fontInset = {
      left = 5,
      top = 0,
      right = 5,
      bottom = 1
    },
    fontColor = {
      normal = {
        1,
        0.98,
        0.62,
        1
      },
      highlight = {
        ConvertColor(232),
        ConvertColor(206),
        ConvertColor(116),
        1
      },
      pushed = {
        0.72,
        0.72,
        0.48,
        1
      },
      disabled = {
        0.3,
        0.3,
        0.3,
        1
      }
    }
  },
  MAIN_MENU_CHARACTER_INFO = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        893,
        0,
        32,
        32
      },
      over = {
        926,
        0,
        32,
        32
      },
      click = {
        959,
        0,
        32,
        32
      },
      disable = {
        992,
        0,
        32,
        32
      }
    },
    width = 32,
    height = 32
  },
  MAIN_MENU_BAG = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        893,
        99,
        32,
        32
      },
      over = {
        926,
        99,
        32,
        32
      },
      click = {
        959,
        99,
        32,
        32
      },
      disable = {
        992,
        99,
        32,
        32
      }
    },
    width = 32,
    height = 32
  },
  MAIN_MENU_QUEST_LIST = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        893,
        66,
        32,
        32
      },
      over = {
        926,
        66,
        32,
        32
      },
      click = {
        959,
        66,
        32,
        32
      },
      disable = {
        992,
        66,
        32,
        32
      }
    },
    width = 32,
    height = 32
  },
  MAIN_MENU_ACHIEVEMENT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "result"
  },
  MAIN_MENU_SKILL = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        893,
        33,
        32,
        32
      },
      over = {
        926,
        33,
        32,
        32
      },
      click = {
        959,
        33,
        32,
        32
      },
      disable = {
        992,
        33,
        32,
        32
      }
    },
    width = 32,
    height = 32
  },
  MAIN_MENU_MAP = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        893,
        231,
        32,
        32
      },
      over = {
        926,
        231,
        32,
        32
      },
      click = {
        959,
        231,
        32,
        32
      },
      disable = {
        992,
        231,
        32,
        32
      }
    },
    width = 32,
    height = 32
  },
  MAIN_MENU_PRODUCTION = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        892,
        297,
        32,
        32
      },
      over = {
        925,
        297,
        32,
        32
      },
      click = {
        958,
        297,
        32,
        32
      },
      disable = {
        991,
        297,
        32,
        32
      }
    },
    width = 28,
    height = 28
  },
  MAIN_MENU_COMMUNITY = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        893,
        198,
        32,
        32
      },
      over = {
        926,
        198,
        32,
        32
      },
      click = {
        959,
        198,
        32,
        32
      },
      disable = {
        992,
        198,
        32,
        32
      }
    },
    width = 32,
    height = 32
  },
  MAIN_MENU_RANKING = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        893,
        264,
        32,
        32
      },
      over = {
        926,
        264,
        32,
        32
      },
      click = {
        959,
        264,
        32,
        32
      },
      disable = {
        992,
        264,
        32,
        32
      }
    },
    width = 32,
    height = 32
  },
  MAIN_MENU_ADDITONAL = {
    drawableType = "drawable",
    path = TEXTURE_PATH.ADDITIONAL_MAIN_MENU,
    coordsKey = "house"
  },
  MAIN_MENU_SYSTEM = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        893,
        165,
        32,
        32
      },
      over = {
        926,
        165,
        32,
        32
      },
      click = {
        959,
        165,
        32,
        32
      },
      disable = {
        992,
        165,
        32,
        32
      }
    },
    width = 32,
    height = 32
  },
  SQUAD_MINI_VIEW_CLOSE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_close_df"):GetCoords()
      },
      over = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_close_ov"):GetCoords()
      },
      click = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_close_on"):GetCoords()
      },
      disable = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_close_dis"):GetCoords()
      }
    },
    width = 28,
    height = 26
  },
  SQUAD_MINI_VIEW_OPEN = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_open_df"):GetCoords()
      },
      over = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_open_ov"):GetCoords()
      },
      click = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_open_on"):GetCoords()
      },
      disable = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_open_dis"):GetCoords()
      }
    },
    width = 28,
    height = 26
  },
  QUEST_CLOSE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_close_df"):GetCoords()
      },
      over = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_close_ov"):GetCoords()
      },
      click = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_close_on"):GetCoords()
      },
      disable = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_close_dis"):GetCoords()
      }
    },
    width = 28,
    height = 26
  },
  QUEST_OPEN = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_open_df"):GetCoords()
      },
      over = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_open_ov"):GetCoords()
      },
      click = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_open_on"):GetCoords()
      },
      disable = {
        GetTextureInfo(TEXTURE_PATH.HUD, "quest_open_dis"):GetCoords()
      }
    },
    width = 28,
    height = 26
  },
  TUTORIAL_CLOSE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.TUTORIAL,
    coordsKey = "close"
  },
  SECONDPASSWORD_LOCK = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coords = {
      normal = {
        668,
        215,
        17,
        23
      },
      over = {
        668,
        238,
        17,
        23
      },
      click = {
        658,
        261,
        17,
        23
      },
      disable = {
        675,
        261,
        17,
        23
      }
    },
    width = 17,
    height = 23
  },
  SECONDPASSWORD_UNLOCK = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "2nd_pw_pink"
  },
  DAY_EVENT = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.DAY_EVENT,
    coords = {
      normal = {
        0,
        0,
        68,
        37
      },
      over = {
        0,
        37,
        68,
        37
      },
      click = {
        0,
        74,
        68,
        37
      },
      disable = {
        0,
        0,
        68,
        37
      }
    },
    width = 68,
    height = 37
  },
  TIMER = {
    drawableType = "drawable",
    layer = "overlay",
    path = TEXTURE_PATH.TIMER,
    coords = {
      normal = {
        0,
        248,
        8,
        9
      },
      over = {
        0,
        122,
        61,
        61
      },
      click = {
        61,
        122,
        61,
        61
      },
      disable = {
        0,
        248,
        8,
        9
      }
    },
    width = 61,
    height = 61
  },
  ARCHE_MALL_OUT = {
    drawableType = "drawable",
    layer = "overlay",
    path = BUTTON_TEXTURE_PATH.ARCHE_MALL_OUT,
    coords = {
      normal = {
        0,
        0,
        36,
        32
      },
      over = {
        36,
        0,
        36,
        32
      },
      click = {
        0,
        32,
        36,
        32
      },
      disable = {
        36,
        32,
        36,
        32
      }
    },
    width = 36,
    height = 32
  },
  INSTANT_REENTRY = {
    drawableType = "drawable",
    layer = "overlay",
    path = BUTTON_TEXTURE_PATH.INSTANT_REENTRY,
    coords = {
      normal = {
        0,
        0,
        36,
        32
      },
      over = {
        36,
        0,
        36,
        32
      },
      click = {
        0,
        32,
        36,
        32
      },
      disable = {
        36,
        32,
        36,
        32
      }
    },
    width = 36,
    height = 32
  },
  CLIENT_DRIVEN_OUT = {
    drawableType = "drawable",
    layer = "overlay",
    path = BUTTON_TEXTURE_PATH.ARCHE_MALL_OUT,
    coords = {
      normal = {
        0,
        0,
        36,
        32
      },
      over = {
        36,
        0,
        36,
        32
      },
      click = {
        0,
        32,
        36,
        32
      },
      disable = {
        36,
        32,
        36,
        32
      }
    },
    width = 36,
    height = 32
  },
  TOGGLE_NO_PREMIUM_SERVICE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "btn_arche_off"
  },
  TOGGLE_PREMIUM_SERVICE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "btn_arche_on"
  },
  TOGGLE_INGAMESHOP = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "btn_shop"
  },
  TOGGLE_EVENT_CENTER = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "btn_eventcenter"
  },
  TOGGLE_CONVENIENCE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "btn_main"
  },
  TOGGLE_COMMERCIAL_MAIL = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "btn_sendbox"
  },
  TOGGLE_AUCTION = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "btn_auction"
  },
  TOGGLE_MAIL = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "btn_mailbox"
  },
  TOGGLE_CONVENIENCE_REQUEST_BATTLE_FIELD = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "btn_battlefield"
  },
  TOGGLE_MAIN_HUD_REQUEST_BATTLE_FIELD = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "btn_pvp"
  },
  TOGGLE_RAID = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "btn_party"
  },
  RISK_ALARM_CLOSE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.RISK_ALARM,
    coords = {
      normal = UIParent:GetTextureData(TEXTURE_PATH.RISK_ALARM, "close_df").coords,
      over = UIParent:GetTextureData(TEXTURE_PATH.RISK_ALARM, "close_ov").coords,
      click = UIParent:GetTextureData(TEXTURE_PATH.RISK_ALARM, "close_on").coords,
      disable = UIParent:GetTextureData(TEXTURE_PATH.RISK_ALARM, "close_dis").coords
    },
    width = GetExtentByKey(TEXTURE_PATH.RISK_ALARM, "close_df", "width"),
    height = GetExtentByKey(TEXTURE_PATH.RISK_ALARM, "close_df", "height")
  },
  REPUTATION = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "btn_hero"
  },
  ROAD_MAP_DRAWING = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "btn_drawing"
  },
  RAID_TAB = {
    drawableType = "drawable",
    path = "ui/hud/raid_tab.dds",
    coordsKey = "raid_tab"
  },
  TOGGLE_OPTIMIZATION_ON = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "lod_mode_on"
  },
  TOGGLE_OPTIMIZATION_OFF = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "lod_mode_off"
  },
  URL_BUTTON = {
    drawableType = "drawable",
    path = TEXTURE_PATH.HUD,
    coordsKey = "icon_voice"
  }
}
BUTTON_LOGINSTAGE = {
  CUSTOM_SAVE_LOAD = {
    drawableType = "drawable",
    path = LOGIN_STAGE_TEXTURE_PATH.SAVE_LOAD,
    coords = {
      click = {
        0,
        0,
        287,
        53
      },
      over = {
        0,
        53,
        287,
        53
      },
      normal = {
        0,
        106,
        287,
        53
      },
      disable = {
        0,
        159,
        287,
        53
      }
    },
    width = 287,
    height = 53,
    fontInset = {
      left = 70,
      top = 0,
      right = 0,
      bottom = 0
    },
    fontAlign = ALIGN_LEFT,
    fontColor = GetButtonDefaultFontColor()
  }
}
