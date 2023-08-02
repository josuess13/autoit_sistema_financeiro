
;entradas()
Func saidas()
    Global $tela_saidas = GUICreate("Despesas", 800, 500)
    GUISetIcon("icones\saidas.ico")
    GUISetState()
    ; Botão Adicionar
    Global $btn_adicionar = GUICtrlCreateButton("Adicionar +", 20, 30, 120, 40)
	GUICtrlSetFont($btn_adicionar, 13, 700)
    ; Data
    Global $datas_mes_ano = GUICtrlCreateLabel(_DateToMonth(@MON, $DMW_LOCALE_LONGNAME) & "/" & @YEAR, 20, 100, 120, 40, $SS_CENTER)
	GUICtrlSetFont($datas_mes_ano, 13, 700)
	GUICtrlSetColor($datas_mes_ano, 0x8B0000)

	; Botão Entradas mês
	Global $btn_saidas_mes = GUICtrlCreateButton("Gastos no mês", 20, 150, 120, 40)
	GUICtrlSetFont(-1, 9, 700)
	; Botão entradas no ano
	Global $btn_entradas_ano = GUICtrlCreateButton("Despesas no ano", 20, 200, 120, 40)
	GUICtrlSetFont(-1, 9, 700)
	; Filtrar datas
	Local $filtrar_datas_entre = GUICtrlCreateLabel("Mostrar gastos entre:", 20, 250, 120, 40, $SS_CENTER)
	GUICtrlSetFont($filtrar_datas_entre, 9, 700)
	Global $data_inicio = GUICtrlCreateDate("", 20, 290, 120, 20, $DTS_SHORTDATEFORMAT)
	GUICtrlCreateLabel("e:", 20, 310, 120, -1, $SS_CENTER)
	GUICtrlSetFont(-1, 9, 700)
	Global $data_fim = GUICtrlCreateDate("", 20, 330, 120, 20, $DTS_SHORTDATEFORMAT)
	Global $btn_filtrar = GUICtrlCreateButton("Filtrar", 20, 360, 120, 40)
	GUICtrlSetFont(-1, 9, 700)
	Global $limpar_filtros = GUICtrlCreateButton("Limpar Filtros", 20, 425, 120, 40)
	GUICtrlSetFont(-1, 9, 700)

	; Exibir entradas
	Global $tabela = GUICtrlCreateListView("Valor|Despesa|Data", 160, 30, 590, 432, $LVS_EDITLABELS)
	Global $tabela_valor = GUICtrlCreateListViewItem("R$ 1.200,00|Salário Agosto|01/08/2021", $tabela)
	_GUICtrlListView_SetColumnWidth($tabela, 0, 100)
	_GUICtrlListView_SetColumnWidth($tabela, 1, 385)
	_GUICtrlListView_SetColumnWidth($tabela, 2, 100)

    While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($tela_saidas)
				ExitLoop
		EndSwitch
	WEnd
EndFunc