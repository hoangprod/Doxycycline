STATUSBAR_STYLE = {
  S_HP_PARTY = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "hp_blue_short").coords,
    afterImage_color_up = {
      ConvertColor(86),
      ConvertColor(198),
      ConvertColor(239),
      1
    },
    afterImage_color_down = {
      ConvertColor(86),
      ConvertColor(198),
      ConvertColor(239),
      1
    }
  },
  S_HP_FRIENDLY = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "hp_green_short").coords,
    afterImage_color_up = {
      ConvertColor(134),
      ConvertColor(207),
      ConvertColor(82),
      1
    },
    afterImage_color_down = {
      ConvertColor(134),
      ConvertColor(207),
      ConvertColor(82),
      1
    }
  },
  S_HP_NEUTRAL = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "hp_orange_short").coords,
    afterImage_color_up = {
      ConvertColor(230),
      ConvertColor(141),
      ConvertColor(36),
      1
    },
    afterImage_color_down = {
      ConvertColor(230),
      ConvertColor(141),
      ConvertColor(36),
      1
    }
  },
  S_HP_HOSTILE = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "hp_red_short").coords,
    afterImage_color_up = {
      ConvertColor(223),
      ConvertColor(69),
      ConvertColor(69),
      1
    },
    afterImage_color_down = {
      ConvertColor(223),
      ConvertColor(69),
      ConvertColor(69),
      1
    }
  },
  S_HP_PREEMTIVE_STRIKE = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "hp_dark_red_short").coords,
    afterImage_color_up = {
      ConvertColor(202),
      ConvertColor(110),
      ConvertColor(105),
      1
    },
    afterImage_color_down = {
      ConvertColor(202),
      ConvertColor(110),
      ConvertColor(105),
      1
    }
  },
  S_HP_OFFLINE = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "hp_gray_short").coords,
    afterImage_color_up = {
      ConvertColor(46),
      ConvertColor(46),
      ConvertColor(46),
      1
    },
    afterImage_color_down = {
      ConvertColor(46),
      ConvertColor(46),
      ConvertColor(46),
      1
    }
  },
  S_MP = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "mp_blue_short").coords
  },
  S_MP_OFFLINE = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "mp_gray_short").coords
  },
  S_MP_PARTY = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "mp_blue_party").coords
  },
  L_HP_FRIENDLY = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "hp_green").coords,
    afterImage_color_up = {
      ConvertColor(134),
      ConvertColor(207),
      ConvertColor(82),
      1
    },
    afterImage_color_down = {
      ConvertColor(134),
      ConvertColor(207),
      ConvertColor(82),
      1
    }
  },
  L_HP_NEUTRAL = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "hp_orange").coords,
    afterImage_color_up = {
      ConvertColor(230),
      ConvertColor(141),
      ConvertColor(36),
      1
    },
    afterImage_color_down = {
      ConvertColor(230),
      ConvertColor(141),
      ConvertColor(36),
      1
    }
  },
  L_HP_HOSTILE = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "hp_red").coords,
    afterImage_color_up = {
      ConvertColor(223),
      ConvertColor(69),
      ConvertColor(69),
      1
    },
    afterImage_color_down = {
      ConvertColor(223),
      ConvertColor(69),
      ConvertColor(69),
      1
    }
  },
  L_HP_PARTY = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "hp_blue").coords,
    afterImage_color_up = {
      ConvertColor(86),
      ConvertColor(198),
      ConvertColor(239),
      1
    },
    afterImage_color_down = {
      ConvertColor(202),
      ConvertColor(110),
      ConvertColor(105),
      1
    }
  },
  L_HP_PREEMTIVE_STRIKE = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "hp_dark_red").coords,
    afterImage_color_up = {
      ConvertColor(202),
      ConvertColor(110),
      ConvertColor(105),
      1
    },
    afterImage_color_down = {
      ConvertColor(202),
      ConvertColor(110),
      ConvertColor(105),
      1
    }
  },
  L_HP_OFFLINE = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "hp_gray").coords,
    afterImage_color_up = {
      ConvertColor(46),
      ConvertColor(46),
      ConvertColor(46),
      1
    },
    afterImage_color_down = {
      ConvertColor(46),
      ConvertColor(46),
      ConvertColor(46),
      1
    }
  },
  L_MP = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "mp_blue").coords
  },
  L_MP_OFFLINE = {
    coords = UIParent:GetTextureData(TEXTURE_PATH.HUD, "mp_gray").coords
  },
  HP_RAID = {
    coords = {
      0,
      0,
      62,
      27
    }
  },
  HP_RAID_TANKER = {
    coords = {
      63,
      0,
      62,
      27
    }
  },
  HP_RAID_DEALER = {
    coords = {
      63,
      28,
      62,
      27
    }
  },
  HP_RAID_HEALER = {
    coords = {
      0,
      28,
      62,
      27
    }
  },
  HP_RAID_OFFLINE = {
    coords = {
      0,
      56,
      62,
      27
    }
  },
  MP_RAID = {
    coords = {
      63,
      72,
      62,
      5
    }
  },
  MP_RAID_OFFLINE = {
    coords = {
      63,
      78,
      62,
      5
    }
  },
  S_HP_RAID = {
    coords = {
      63,
      84,
      62,
      16
    }
  },
  S_HP_RAID_TANKER = {
    coords = {
      0,
      84,
      62,
      16
    }
  },
  S_HP_RAID_DEALER = {
    coords = {
      63,
      56,
      62,
      16
    }
  },
  S_HP_RAID_HEALER = {
    coords = {
      0,
      101,
      62,
      16
    }
  },
  S_HP_RAID_OFFLINE = {
    coords = {
      63,
      101,
      62,
      16
    }
  },
  S_MP_RAID = {
    coords = {
      0,
      118,
      62,
      4
    }
  },
  S_MP_RAID_OFFLINE = {
    coords = {
      63,
      118,
      62,
      4
    }
  }
}
