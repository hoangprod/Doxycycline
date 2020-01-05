local DialogEnsembleSuggestHandler = function(wnd, infoTable)
  wnd:SetTitle(X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ensemblesuggest"))
  wnd:SetContent(X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "ensemblesuggest"))
  function wnd:OnUpdate()
  end
  wnd:SetHandler("OnUpdate", wnd.OnUpdate)
end
X2DialogManager:SetHandler(DLG_TASK_ENSEMBLE_SUGGEST, DialogEnsembleSuggestHandler)
