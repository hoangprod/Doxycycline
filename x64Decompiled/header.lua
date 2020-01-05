RESIDENT_TAB_IDX = {
  INFORMATION = 1,
  MEMBERS = 2,
  BULLETIN = 3,
  TRADES = 4
}
RESIDENT_TAB_INFO = {
  [RESIDENT_TAB_IDX.INFORMATION] = {
    enable = true,
    show = true,
    text = GetUIText(COMMON_TEXT, "resident_townhall_tab_area")
  },
  [RESIDENT_TAB_IDX.MEMBERS] = {
    enable = true,
    show = true,
    text = GetUIText(COMMON_TEXT, "resident_townhall_tab_members")
  },
  [RESIDENT_TAB_IDX.BULLETIN] = {
    enable = true,
    show = X2Player:GetFeatureSet().residentweblink,
    text = GetUIText(COMMON_TEXT, "resident_townhall_tab_bulletin")
  },
  [RESIDENT_TAB_IDX.TRADES] = {
    enable = true,
    show = true,
    text = GetUIText(COMMON_TEXT, "resident_townhall_tab_trades")
  }
}
RESIDENT_MEMBER_IDX = {
  NAME = 1,
  LEVEL = 2,
  SERVICE = 3,
  FAMILY = 4,
  ONLINE = 5,
  PARTY = 6,
  CHK = 7,
  HEIR_LEVEL = 8
}
RESIDENT_MEMBER_INFO = {
  [RESIDENT_MEMBER_IDX.NAME] = {
    show = true,
    width = 220,
    text = GetUIText(COMMON_TEXT, "resident_townhall_members_name")
  },
  [RESIDENT_MEMBER_IDX.LEVEL] = {
    show = true,
    width = 90,
    text = GetUIText(COMMON_TEXT, "resident_townhall_members_level")
  },
  [RESIDENT_MEMBER_IDX.SERVICE] = {
    show = true,
    width = 120,
    text = GetUIText(COMMON_TEXT, "resident_townhall_members_service_point")
  },
  [RESIDENT_MEMBER_IDX.FAMILY] = {
    show = true,
    width = 302,
    text = GetUIText(COMMON_TEXT, "resident_townhall_members_family")
  },
  [RESIDENT_MEMBER_IDX.ONLINE] = {show = false},
  [RESIDENT_MEMBER_IDX.PARTY] = {show = false},
  [RESIDENT_MEMBER_IDX.CHK] = {show = false}
}
NUONS_ARROW_IDX = {
  NAME = 1,
  STEP = 2,
  CHARGE = 3,
  ZONE_GROUP = 4
}
NUONS_ARROW_INFO = {
  [NUONS_ARROW_IDX.NAME] = {
    show = true,
    width = 155,
    text = GetUIText(COMMON_TEXT, "resident_nuons_area")
  },
  [NUONS_ARROW_IDX.STEP] = {
    show = true,
    width = 140,
    text = GetUIText(COMMON_TEXT, "resident_nuons_step")
  },
  [NUONS_ARROW_IDX.CHARGE] = {
    show = true,
    width = 137,
    text = GetUIText(COMMON_TEXT, "resident_nuons_charge")
  },
  [NUONS_ARROW_IDX.ZONE_GROUP] = {show = false}
}
RESIDENT_TRADE_IDX = {
  NAME = 1,
  KIND = 2,
  DIVISION = 3,
  FAMILYNUM = 4,
  PRICE = 5,
  LOCATION = 6
}
RESIDENT_TRADE_INFO = {
  [RESIDENT_TRADE_IDX.NAME] = {
    show = true,
    width = 140,
    text = GetUIText(AUCTION_TEXT, "seller")
  },
  [RESIDENT_TRADE_IDX.KIND] = {
    show = true,
    width = 140,
    text = GetUIText(HOUSING_TEXT, "housingkind")
  },
  [RESIDENT_TRADE_IDX.DIVISION] = {
    show = true,
    width = 165,
    text = GetUIText(SLAVE_TEXT, "slave_class")
  },
  [RESIDENT_TRADE_IDX.FAMILYNUM] = {
    show = true,
    width = 90,
    text = GetUIText(HOUSING_TEXT, "deconum")
  },
  [RESIDENT_TRADE_IDX.PRICE] = {
    show = true,
    width = 160,
    text = GetUIText(HOUSING_TEXT, "sell_price")
  },
  [RESIDENT_TRADE_IDX.LOCATION] = {
    show = true,
    width = 65,
    text = GetUIText(COMMON_TEXT, "property_location")
  }
}
RESIDENT_TRADE_FIND_FILTER = {
  [HOUSING_LIST_FILTER_ALL] = {
    text = GetUIText(HOUSING_TEXT, "findfilter_all")
  },
  [HOUSING_LIST_FILTER_SELLER_NAME] = {
    text = GetUIText(HOUSING_TEXT, "findfilter_seller_name")
  },
  [HOUSING_LIST_FILTER_HOUSE_NAME] = {
    text = GetUIText(HOUSING_TEXT, "findfilter_house_name")
  },
  [HOUSING_LIST_FILTER_WORKTABLE] = {
    text = GetUIText(HOUSING_TEXT, "findfilter_worktable")
  },
  [HOUSING_LIST_FILTER_FARM] = {
    text = GetUIText(HOUSING_TEXT, "findfilter_farm")
  },
  [HOUSING_LIST_FILTER_UNDERWATER_STRUCTURE] = {
    text = GetUIText(MAP_TEXT, "M_HOUSING_FISHFARM")
  },
  [HOUSING_LIST_FILTER_SMALL] = {
    text = GetUIText(HOUSING_TEXT, "findfilter_small")
  },
  [HOUSING_LIST_FILTER_MEDIUM] = {
    text = GetUIText(HOUSING_TEXT, "findfilter_medium")
  },
  [HOUSING_LIST_FILTER_LARGE] = {
    text = GetUIText(HOUSING_TEXT, "findfilter_large")
  },
  [HOUSING_LIST_FILTER_FLOATING] = {
    text = GetUIText(HOUSING_TEXT, "findfilter_floating")
  },
  [HOUSING_LIST_FILTER_MANSION] = {
    text = GetUIText(HOUSING_TEXT, "findfilter_mansion")
  },
  [HOUSING_LIST_FILTER_PUBLIC] = {
    text = GetUIText(HOUSING_TEXT, "findfilter_public")
  }
}
