BUTTON_FONT_COLOR = {
  DEFAULT = {
    normal = {
      ConvertColor(159),
      ConvertColor(182),
      ConvertColor(189),
      1
    },
    highlight = FONT_COLOR.WHITE,
    pushed = {
      ConvertColor(153),
      ConvertColor(217),
      ConvertColor(234),
      1
    },
    disabled = {
      ConvertColor(152),
      ConvertColor(152),
      ConvertColor(152),
      1
    }
  }
}
BUTTON_STYLE = {
  PLAIN = {
    drawableType = "ninePart",
    path = TEXTURE_PATH.DEFAULT_NEW,
    coordsKey = "plain_pattern_btn",
    autoResize = true,
    fontColor = BUTTON_FONT_COLOR.DEFAULT,
    fontPath = FONT_PATH.DEFAULT,
    fontInset = {
      left = 15,
      right = 15,
      top = 0,
      bottom = 0
    }
  },
  STAGE = {
    drawableType = "threePart",
    path = TEXTURE_PATH.CUSTOMIZING_BUTTON,
    coordsKey = "btn",
    autoResize = true,
    fontColorKey = "text_btn",
    fontSize = FONT_SIZE.XLARGE,
    fontPath = FONT_PATH.DEFAULT,
    fontInset = {
      left = 30,
      right = 30,
      top = 0,
      bottom = 0
    }
  },
  POS_PICKER = {
    drawableType = "drawable",
    path = TEXTURE_PATH.CUSTOMIZING,
    coordsKey = "tattoo_position"
  },
  CUSTOMIZING_SELECTION = {
    drawableType = "ninePart",
    path = TEXTURE_PATH.CUSTOMIZING,
    layer = "overlay",
    coords = {
      normal = {
        0,
        0,
        0,
        0
      },
      over = {
        GetTextureInfo(TEXTURE_PATH.CUSTOMIZING, "selected"):GetCoords()
      },
      click = {
        GetTextureInfo(TEXTURE_PATH.CUSTOMIZING, "selected"):GetCoords()
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
        1
      },
      click = {
        1,
        1,
        1,
        1
      },
      disable = {
        0,
        0,
        0,
        0
      }
    },
    inset = UIParent:GetTextureData(TEXTURE_PATH.CUSTOMIZING, "selected").inset
  },
  CHAR_LIST_BLUE_SLOT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.CHARACTER_SELECT,
    coordsKey = "blue_slot",
    fontColorKey = "character_slot",
    fontSize = FONT_SIZE.XXLARGE,
    fontPath = FONT_PATH.LEEYAGI,
    fontInset = {
      left = 15,
      top = 17,
      right = 0,
      bottom = 0
    },
    fontAlign = ALIGN_LEFT
  },
  CHAR_LIST_SELECT_BLUE_SLOT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.CHARACTER_SELECT,
    coordsKey = "blue_slot_selected",
    fontColorKey = "white",
    useSameColor = true,
    fontSize = FONT_SIZE.XXLARGE,
    fontPath = FONT_PATH.LEEYAGI,
    fontInset = {
      left = 15,
      top = 17,
      right = 0,
      bottom = 0
    },
    fontAlign = ALIGN_LEFT
  },
  LOGIN_STAGE_EXIT = {
    drawableType = "drawable",
    path = TEXTURE_PATH.LOGIN_STAGE_MENU,
    coordsKey = "exit"
  },
  LOGIN_STAGE_OPTION = {
    drawableType = "drawable",
    path = TEXTURE_PATH.LOGIN_STAGE_MENU,
    coordsKey = "set"
  },
  PREMIUM_BUY_IN_CHAR_SEL_PAGE = {
    drawableType = "drawable",
    path = TEXTURE_PATH.PREMIUM_BUY_IN_CHAR_SEL_PAGE,
    coordsKey = "btn_premiumbuy"
  },
  CHAR_SELECT_PAGE_REPRESENT_CHAR = {
    drawableType = "drawable",
    path = TEXTURE_PATH.CHARACTER_SELECT,
    coordsKey = "representative"
  },
  RESET_BIG = {
    drawableType = "drawable",
    path = "ui/button/common/reset_big.dds",
    coordsKey = "reset"
  },
  REQUEST_CRAFT_ORDER = {
    drawableType = "drawable",
    path = "ui/button/request.dds",
    coordsKey = "btn_request"
  },
  CANCEL = {
    drawableType = "drawable",
    path = "ui/button/common/cancel.dds",
    coordsKey = "btn_cancel"
  },
  BACK = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.COMMON_BACK,
    coordsKey = "back_btn"
  }
}
