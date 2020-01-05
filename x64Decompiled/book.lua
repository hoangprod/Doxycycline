local EXTENT = {WEB_BROWSER_WIDTH = 300, WEB_BROWSER_HEIGHT = 270}
local noteWindow = {}
noteWindow.page = nil
noteWindow.book = nil
local function CreatePageWindow(id, parent)
  local WND_WIDTH = POPUP_WINDOW_WIDTH
  local WND_HEIGHT = 320
  local BROWSER_WIDTH = 300
  local BROWSER_HEIGHT = 270
  local window = CreateEmptyWindow(id, parent)
  window:SetExtent(WND_WIDTH, WND_HEIGHT)
  window:SetSounds("web_note")
  window:EnableHidingIsRemove(true)
  window:SetCloseOnEscape(true)
  window:AddAnchor("CENTER", parent, 0, 0)
  local bg = CreateContentBackground(window, "TYPE13")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local webBrowser = UIParent:CreateWidget(baselibLocale.webWidgetName, id .. ".webbrowser", window)
  webBrowser:AddAnchor("CENTER", window, 0, 0)
  webBrowser:SetExtent(EXTENT.WEB_BROWSER_WIDTH, EXTENT.WEB_BROWSER_HEIGHT)
  webBrowser:Show(false)
  window.webBrowser = webBrowser
  local titleBar = CreateTitleBar(window:GetId() .. ".titleBar", window)
  titleBar:SetHeight(20)
  window.titleBar = titleBar
  local function OnHideWindow()
    if webBrowser:IsVisible() then
      webBrowser:LoadBlankPage()
      webBrowser:Show(false)
    end
    noteWindow.page = nil
  end
  window:SetHandler("OnHide", OnHideWindow)
  local events = {
    INTERACTION_END = function()
      if window:IsVisible() then
        window:Show(false)
      end
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
local function ShowPageWindow(idx)
  if noteWindow.page == nil then
    noteWindow.page = CreatePageWindow("noteWindow.page", "UIParent")
  end
  noteWindow.page:Show(true)
  noteWindow.page.webBrowser:Show(true)
  noteWindow.page.webBrowser:RequestBookPage(idx)
end
local function CreateBookWindow(id, parent)
  local WND_WIDTH = 352
  local WND_HEIGHT = 375
  local window = CreateEmptyWindow(id, parent)
  window:SetExtent(WND_WIDTH, WND_HEIGHT)
  window:SetSounds("web_note")
  window:EnableHidingIsRemove(true)
  window:SetCloseOnEscape(true)
  window:AddAnchor("CENTER", parent, 0, 0)
  local bg = CreateContentBackground(window, "TYPE13")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local coverFrame = window:CreateChildWidget("emptywidget", "coverFrame", 0, true)
  coverFrame:Show(false)
  coverFrame:SetExtent(WND_WIDTH, WND_HEIGHT)
  coverFrame:AddAnchor("CENTER", window, 0, 0)
  local coverTitle = coverFrame:CreateChildWidget("textbox", "coverTitle", 0, true)
  coverTitle:SetExtent(window:GetWidth() - 40, FONT_SIZE.XLARGE)
  coverTitle:AddAnchor("CENTER", coverFrame, 0, 0)
  coverTitle.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
  ApplyTextColor(coverTitle, FONT_COLOR.DEFAULT)
  local upperDeco = coverFrame:CreateDrawable(TEXTURE_PATH.PAPER_DECO, "upper_deco", "artwork")
  upperDeco:AddAnchor("BOTTOM", coverTitle, "TOP", 0, 0)
  local lowerDeco = coverFrame:CreateDrawable(TEXTURE_PATH.PAPER_DECO, "lower_deco", "artwork")
  lowerDeco:AddAnchor("TOP", coverTitle, "BOTTOM", 0, 0)
  local function SetCoverTitle(titleStr)
    coverTitle:SetText(titleStr)
    coverTitle:SetHeight(coverTitle:GetTextHeight())
  end
  local openPageButton = window:CreateChildWidget("button", "openPageButton", 0, true)
  openPageButton:AddAnchor("BOTTOMRIGHT", window, -15, -15)
  openPageButton:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "reading"))
  ApplyButtonSkin(openPageButton, BUTTON_CONTENTS.BOOK_NEXT)
  openPageButton:SetAutoResize(true)
  local openCoverButton = window:CreateChildWidget("button", "openCoverButton", 0, true)
  openCoverButton:AddAnchor("BOTTOMLEFT", window, 15, -15)
  openCoverButton:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "prev"))
  ApplyButtonSkin(openCoverButton, BUTTON_CONTENTS.BOOK_PREV)
  openCoverButton:SetAutoResize(true)
  local webBrowser = UIParent:CreateWidget(baselibLocale.webWidgetName, id .. ".webbrowser", window)
  webBrowser:AddAnchor("CENTER", window, 0, 0)
  webBrowser:SetExtent(EXTENT.WEB_BROWSER_WIDTH, EXTENT.WEB_BROWSER_HEIGHT)
  webBrowser:Show(false)
  window.webBrowser = webBrowser
  local titleBar = CreateTitleBar(window:GetId() .. ".titleBar", window)
  window.titleBar = titleBar
  local title = titleBar:CreateChildWidget("textbox", "title", 0, true)
  title:AddAnchor("TOPLEFT", titleBar, 20, 5)
  title:AddAnchor("TOPRIGHT", titleBar, -30, 0)
  title:SetHeight(45)
  title:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  title.style:SetAlign(ALIGN_CENTER)
  title.style:SetSnap(true)
  ApplyTextColor(title, FONT_COLOR.TITLE)
  title.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
  local function SetTitleText(titleStr)
    title:SetText(titleStr)
  end
  local pageControl = W_CTRL.CreatePageControl(window:GetId() .. ".pageControl", window, "note")
  pageControl:AddAnchor("BOTTOM", window, 0, 0)
  window.pageControl = pageControl
  pageControl.prevPageButton:SetAutoResize(true)
  pageControl.nextPageButton:SetAutoResize(true)
  function window:SetBookInfos(bookPageInfo, bookName)
    self.totalPageCount = #bookPageInfo
    self.pageControl:SetPageByItemCount(#bookPageInfo, 1)
    self.bookPageInfo = bookPageInfo
    self.bookName = bookName
  end
  function window:SetPage(nowPage)
    self.coverFrame:Show(false)
    self.webBrowser:Show(true)
    self.openPageButton:Show(false)
    self.openCoverButton:Show(false)
    SetTitleText(self.bookName)
    self.pageControl.prevPageButton:Show(true)
    self.pageControl.nextPageButton:Show(true)
    self.webBrowser:RequestBookPage(self.bookPageInfo[nowPage])
    self.pageControl.prevPageButton:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "prev"))
    self.pageControl.nextPageButton:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "next"))
    if nowPage == 1 then
      self.pageControl.prevPageButton:Show(false)
      self.openCoverButton:Show(true)
    elseif nowPage == self.totalPageCount then
      self.pageControl.nextPageButton:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "end"))
    end
  end
  function window:SetCover()
    self.coverFrame:Show(true)
    self.webBrowser:Show(false)
    self.pageControl:Show(true)
    self.openPageButton:Show(true)
    self.openCoverButton:Show(false)
    self.pageControl.prevPageButton:Show(false)
    self.pageControl.nextPageButton:Show(false)
    SetCoverTitle(self.bookName)
    SetTitleText("")
  end
  local function OnClickOpenPageButton()
    webBrowser:Show(true)
    coverFrame:Show(false)
    window:SetPage(1)
  end
  openPageButton:SetHandler("OnClick", OnClickOpenPageButton)
  local function OnClickOpenCoverButton()
    webBrowser:Show(false)
    coverFrame:Show(true)
    window:SetCover()
  end
  openCoverButton:SetHandler("OnClick", OnClickOpenCoverButton)
  function pageControl:ProcOnPageChanged(pageIndex, countPerPage)
    if pageIndex == 1 then
      pageIndex = 1
    end
    window:SetPage(pageIndex)
  end
  local function OnHideWindow()
    if webBrowser:IsVisible() then
      webBrowser:LoadBlankPage()
      webBrowser:Show(false)
    end
    noteWindow.book = nil
  end
  window:SetHandler("OnHide", OnHideWindow)
  local events = {
    INTERACTION_END = function()
      if window:IsVisible() then
        window:Show(false)
      end
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
local function ShowBookWindow(bookPageInfo, bookName)
  if noteWindow.book == nil then
    noteWindow.book = CreateBookWindow("noteWindow.book", "UIParent")
  end
  noteWindow.book:Show(true)
  noteWindow.book:SetBookInfos(bookPageInfo, bookName)
  noteWindow.book:SetCover()
end
local function OpenPaper(type, idx)
  if type == nil or idx == nil then
    return
  end
  if type == "page" then
    ShowPageWindow(idx)
  elseif type == "book" then
    local bookInfo = X2Book:GetBookInfo(idx)
    if bookInfo == nil then
      return
    end
    ShowBookWindow(bookInfo.pages, bookInfo.name)
  else
    LuaAssert("error!!!")
  end
end
UIParent:SetEventHandler("OPEN_PAPER", OpenPaper)
local function ClosePaper()
  if noteWindow.book ~= nil then
    noteWindow.book:Show(false)
  end
  if noteWindow.page ~= nil then
    noteWindow.page:Show(false)
  end
end
UIParent:SetEventHandler("DESTROY_PAPER", ClosePaper)
UIParent:SetEventHandler("LEFT_LOADING", ClosePaper)
UIParent:SetEventHandler("ENTERED_WORLD", ClosePaper)
