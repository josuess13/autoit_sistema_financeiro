
Func investimentos()
    Local $tela_investimentos = GUICreate("Investimentos", 800, 520)
    GUISetIcon("icones\invest.ico")
    GUISetState()

	Local $btn_editar_metas = GUICtrlCreateButton("Editar Metas", 20, 30, 120, 40)
	GUICtrlSetFont(-1, 13, 700)

	Local $btn_investimentos_ano = GUICtrlCreateButton("Inv. Ano", 20, 80, 120, 40)
	GUICtrlSetFont(-1, 13, 700)

	Local $btn_investimentos_total = GUICtrlCreateButton("Inv. Total", 20, 130, 120, 40)
	GUICtrlSetFont(-1, 13, 700)

	Local $btn_gravar = GUICtrlCreateButton("Gravar", 660, 470, 120, 40)
	GUICtrlSetFont(-1, 13, 700)

	$entrada_mes = consultar_entradas_mes()

	; grid
	Local $tabela = GUICtrlCreateListView(" META | % | VALOR DO MÊS ", 160, 30, 355, 432, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS));$LVS_EDITLABELS)
	_GUICtrlListView_SetColumnWidth($tabela, 0, 200)
	_GUICtrlListView_SetColumnWidth($tabela, 1, 50)
	_GUICtrlListView_SetColumnWidth($tabela, 2, 100)

	_GUICtrlListView_SetExtendedListViewStyle($tabela, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FLATSB, $LVS_EX_FULLROWSELECT))
	_GUICtrlListView_SetTextBkColor($tabela, 0xE0E0E0)
	_GUICtrlListView_SetBkColor($tabela, 0xFFFFFF)
	_GUICtrlListView_SetTextColor($tabela, 0x000000)

   
    While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($tela_investimentos)
				ExitLoop
		EndSwitch
	WEnd
EndFunc