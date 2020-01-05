local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function SetViewOfMailFrame(id, parent)
  local window = CreateWindow(id, parent, "mail")
  window:SetExtent(mailBoxLocale.wnd.width, 545)
  window:AddAnchor("LEFT", "UIParent", 25, 0)
  window:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "mail"))
  window:SetSounds("mail")
  window.useImageBtn = mailBoxLocale.wnd.useImageBtn
  local tab = window:CreateChildWidget("tab", "tab", 0, true)
  tab:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  tab:AddAnchor("BOTTOMRIGHT", window, -sideMargin, -sideMargin)
  tab:SetCorner("TOPLEFT")
  tab:AddSimpleTab(locale.mail.receivedMail)
  tab:AddSimpleTab(locale.mail.sentMail)
  local buttonTable = {}
  for i = 1, #tab.window do
    ApplyButtonSkin(tab.selectedButton[i], BUTTON_BASIC.TAB_SELECT)
    ApplyButtonSkin(tab.unselectedButton[i], BUTTON_BASIC.TAB_UNSELECT)
    table.insert(buttonTable, tab.selectedButton[i])
    table.insert(buttonTable, tab.unselectedButton[i])
  end
  AdjustBtnLongestTextWidth(buttonTable)
  tab:SetGap(1)
  DrawTabSkin(tab, tab.window[1], tab.selectedButton[1])
  local writeButton = window:CreateChildWidget("button", "writeButton", 0, true)
  local deleteButton = window:CreateChildWidget("button", "deleteButton", 0, true)
  deleteButton:Enable(false)
  local allDeleteButton = window:CreateChildWidget("button", "allDeleteButton", 0, true)
  allDeleteButton:Enable(true)
  allDeleteButton.enableTime = 0
  local takeAllAttachmentsButton = window:CreateChildWidget("button", "takeAllAttachmentsButton", 0, true)
  takeAllAttachmentsButton:Enable(false)
  mailBoxLocale:SetLayoutBottomBtns(window, deleteButton, allDeleteButton, takeAllAttachmentsButton, writeButton)
  local guide = W_ICON.CreateGuideIconWidget(window)
  guide:AddAnchor("TOPRIGHT", tab, 0, 7)
  window.guide = guide
  local readWindow = CreateReadMailWindow(window:GetId() .. ".readWindow", window)
  readWindow:Show(false)
  readWindow:SetSounds("mail_read")
  readWindow:AddAnchor("TOPLEFT", window, "TOPRIGHT", 0, 0)
  window.readWindow = readWindow
  local writeWindow = CreateWriteMailWindow(window:GetId() .. ".writeWindow", window)
  writeWindow:Show(false)
  writeWindow:SetSounds("mail_write")
  writeWindow:AddAnchor("TOPLEFT", window, "TOPRIGHT", 0, 0)
  window.writeWindow = writeWindow
  CreateMailReceivedFrame(tab.window[1])
  CreateMailSentFrame(tab.window[2])
  window.pageCtrl = {}
  window.pageCtrl[1] = tab.window[1].pageCtrl
  window.pageCtrl[2] = tab.window[2].pageCtrl
  window.writeButton = writeButton
  local modalLoadingWindow = CreateLoadingTextureSet(window)
  modalLoadingWindow:AddAnchor("LEFT", window, 1, 0)
  modalLoadingWindow:AddAnchor("TOP", tab, 0, tab.selectedButton[1]:GetHeight())
  modalLoadingWindow:AddAnchor("BOTTOMRIGHT", window, -4, -(sideMargin + writeButton:GetHeight() + 5))
  function window:EnableButton(index, isShow)
    if index ~= nil then
      self.pageCtrl[index]:Enable(isShow)
    end
    self.writeButton:Enable(isShow)
    self.allDeleteButton:Enable(GetVisibleTab():GetMailCount() > 0)
  end
  return window
end
