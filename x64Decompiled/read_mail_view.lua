function SetViewOfReadMailWindow(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:SetExtent(430, 545)
  window:SetTitle(locale.mail.readMail)
  CreateMailUpperFrame(window)
  CreateContentFrame(window)
  local buttonSetWindow = window:CreateChildWidget("window", "buttonSetWindow", 0, true)
  buttonSetWindow:Show(true)
  buttonSetWindow:SetExtent(293, BUTTON_SIZE.DEFAULT_SMALL.HEIGHT)
  buttonSetWindow:AddAnchor("BOTTOM", window, 0, -sideMargin)
  local reportButton = window:CreateChildWidget("button", "reportButton", 0, true)
  reportButton:AddAnchor("BOTTOMLEFT", window, sideMargin, bottomMargin / 3)
  ApplyButtonSkin(reportButton, BUTTON_CONTENTS.REPORT)
  local deleteButton = window:CreateChildWidget("button", "deleteButton", 0, true)
  deleteButton:AddAnchor("CENTER", buttonSetWindow, 0, 0)
  deleteButton:SetText(locale.mail.deleteMail)
  ApplyButtonSkin(deleteButton, BUTTON_BASIC.DEFAULT)
  local returnButton = window:CreateChildWidget("button", "returnButton", 0, true)
  returnButton:AddAnchor("RIGHT", deleteButton, "LEFT", 0, 0)
  returnButton:SetText(locale.mail.returnMail)
  ApplyButtonSkin(returnButton, BUTTON_BASIC.DEFAULT)
  local replyButton = window:CreateChildWidget("button", "replyButton", 0, true)
  replyButton:AddAnchor("LEFT", deleteButton, "RIGHT", 0, 0)
  replyButton:SetText(locale.mail.replyMail)
  ApplyButtonSkin(replyButton, BUTTON_BASIC.DEFAULT)
  local buttonTable = {
    returnButton,
    deleteButton,
    replyButton
  }
  local maxWidth = AdjustBtnLongestTextWidth(buttonTable)
  local payTaxButton = window:CreateChildWidget("button", "payTaxButton", 0, true)
  payTaxButton:AddAnchor("CENTER", buttonSetWindow, 0, 0)
  payTaxButton:SetText(locale.mail.payTax)
  ApplyButtonSkin(payTaxButton, BUTTON_BASIC.DEFAULT)
  local receiptTaxButton = window:CreateChildWidget("button", "receiptTaxButton", 0, true)
  receiptTaxButton:AddAnchor("CENTER", buttonSetWindow, 0, 0)
  receiptTaxButton:SetText(locale.mail.receiptTax)
  ApplyButtonSkin(receiptTaxButton, BUTTON_BASIC.DEFAULT)
  local CreateBodyDrawable = function(widget, type)
    if type == nil or type == "" then
      return
    end
    local drawableTable = {
      TITLE = function(widget)
        local drawable = CreateContentBackground(widget, "TYPE6", "brown")
        drawable:SetExtent(160, 28)
        drawable:AddAnchor("TOP", widget, 7, -7)
        return drawable
      end,
      BODY = function(widget)
        local drawable = CreateContentBackground(widget, "TYPE2", "blue")
        drawable:SetWidth(widget:GetWidth() + 20)
        return drawable
      end,
      LINE = function(widget)
        local drawable = CreateLine(widget, "TYPE1")
        drawable:SetWidth(widget:GetWidth())
        return drawable
      end,
      ARROW = function(widget)
        local drawable = W_ICON.CreateArrowIcon(widget)
        drawable:SetTextureColor("blue")
        return drawable
      end
    }
    return drawableTable[type](widget)
  end
  local function CreateBodyInnerItem(widget, type)
    local itemTable = {
      CONTENT = function(widget)
        local item = widget:CreateChildWidget("gametooltip", "billContent", 0, false)
        item:SetExtent(mailBoxLocale.mail.bodyMaxWidth, 360)
        item:SetAutoWordwrap(true)
        item.style:SetSnap(true)
        ApplyTextColor(item, FONT_COLOR.BLACK)
        return item
      end,
      SCROLL_CONTENT = function(widget)
        local scrollWindow = CreateScrollWindow(widget, "scrollWindow", 0)
        scrollWindow:AddAnchor("TOPLEFT", widget, 15, 20)
        scrollWindow:AddAnchor("BOTTOMRIGHT", widget, -sideMargin / 2, -15)
        local statement = scrollWindow.content:CreateChildWidget("gametooltip", "statement", 0, true)
        statement:AddAnchor("TOPLEFT", scrollWindow.content, 10, 0)
        statement:SetExtent(scrollWindow.content:GetWidth() - 20, 20)
        statement:SetAutoWordwrap(true)
        statement.style:SetSnap(true)
        ApplyTextColor(statement, FONT_COLOR.BLACK)
        return scrollWindow
      end
    }
    return itemTable[type](widget)
  end
  function window:CreateBodyFrame(type, anchorTarget)
    local contentTable = {
      TYPE1 = function(window)
        local body = CreateBodyInnerItem(window, "CONTENT")
        body:AddAnchor("TOP", anchorTarget, 0, sideMargin / 1.5)
        return body
      end,
      TYPE2 = function(window)
        local body = CreateBodyInnerItem(anchorTarget, "SCROLL_CONTENT")
        local bodyBg = CreateBodyDrawable(body.content.statement, "BODY")
        body.bg = bodyBg
        local itemIcon = CreateItemIconButton(body:GetId() .. ".itemIcon", body.content)
        itemIcon:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
        body.itemIcon = itemIcon
        function itemIcon:FillTaxInfo(count)
          local info = X2House:GetTaxItem()
          local curCnt = X2House:CountTaxItemInBag()
          local needCnt = X2House:CountTaxItemForTax(count)
          self:SetItemInfo(info)
          self:SetStack(curCnt, needCnt)
        end
        return body
      end,
      TYPE3 = function(window)
        local body = CreateBodyInnerItem(anchorTarget, "SCROLL_CONTENT")
        local bodyBg = CreateBodyDrawable(body.content.statement, "BODY")
        body.bg = bodyBg
        local line = CreateBodyDrawable(body.content.statement, "LINE")
        body.line = line
        return body
      end,
      TYPE4 = function(window)
        local body = CreateBodyInnerItem(anchorTarget, "SCROLL_CONTENT")
        local bodyBg = CreateBodyDrawable(body.content.statement, "BODY")
        body.bg = bodyBg
        local arrow = CreateBodyDrawable(body.content.statement, "ARROW")
        body.arrow = arrow
        local guideIcon = W_ICON.CreateGuideIconWidget(body.content)
        body.guideIcon = guideIcon
        return body
      end,
      TYPE5 = function(window)
        local body = CreateBodyInnerItem(anchorTarget, "SCROLL_CONTENT")
        local bodyBg = CreateBodyDrawable(body.content.statement, "BODY")
        body.bg = bodyBg
        local line = CreateBodyDrawable(body.content.statement, "LINE")
        body.line = line
        local guideIcon = W_ICON.CreateGuideIconWidget(body)
        body.guideIcon = guideIcon
        return body
      end,
      TYPE6 = function(window)
        local body = CreateBodyInnerItem(anchorTarget, "SCROLL_CONTENT")
        local bodyBg = CreateBodyDrawable(body.content.statement, "BODY")
        body.bg = bodyBg
        return body
      end,
      TYPE7 = function(window)
        local body = CreateBodyInnerItem(anchorTarget, "SCROLL_CONTENT")
        return body
      end,
      TYPE8 = function(window)
        local body = CreateBodyInnerItem(anchorTarget, "SCROLL_CONTENT")
        local arrow = CreateBodyDrawable(body, "ARROW")
        body.arrow = arrow
        return body
      end,
      TYPE9 = function(window)
        local body = CreateBodyInnerItem(anchorTarget, "SCROLL_CONTENT")
        local decoBg = body:CreateDrawable(TEXTURE_PATH.HERO_ELECTION_MAIL, "trophy", "background")
        decoBg:AddAnchor("CENTER", body, -5, 0)
        return body
      end
    }
    return contentTable[type](self)
  end
  return window
end
