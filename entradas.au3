# AutoIt3Wrapper_UseX64 = Y

;entradas()
Func entradas()
    Global $tela_entradas = GUICreate("Receitas", 800, 500)
    GUISetIcon("icones\entradas.ico")
    GUISetState()
    ; Botão Adicionar
    Global $btn_adicionar = GUICtrlCreateButton("Adicionar +", 20, 30, 120, 40)
	GUICtrlSetFont($btn_adicionar, 13, 700)
    ; Data
    Global $datas_mes_ano = GUICtrlCreateLabel(_DateToMonth(@MON, $DMW_LOCALE_LONGNAME) & "/" & @YEAR, 20, 100, 120, 40, $SS_CENTER)
	GUICtrlSetFont($datas_mes_ano, 13, 700)
	GUICtrlSetColor($datas_mes_ano, 0x228B22)

	; Botão Entradas mês
	Global $btn_entradas_mes = GUICtrlCreateButton("Entradas no mês", 20, 150, 120, 40)
	GUICtrlSetFont(-1, 9, 700)
	; Botão entradas no ano
	Global $btn_entradas_ano = GUICtrlCreateButton("Entradas no ano", 20, 200, 120, 40)
	GUICtrlSetFont(-1, 9, 700)
	; Filtrar datas
	Local $filtrar_datas_entre = GUICtrlCreateLabel("Mostrar entradas entre:", 20, 250, 120, 40, $SS_CENTER)
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
	Global $tabela = GUICtrlCreateListView("Valor|Entrada|Data", 160, 30, 590, 432, $LVS_EDITLABELS)
	Global $tabela_valor = GUICtrlCreateListViewItem("R$ 1.200,00|Salário Agosto|01/08/2021", $tabela)
	_GUICtrlListView_SetColumnWidth($tabela, 0, 100)
	_GUICtrlListView_SetColumnWidth($tabela, 1, 385)
	_GUICtrlListView_SetColumnWidth($tabela, 2, 100)

    While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($tela_entradas)
				ExitLoop
			Case $btn_adicionar
				GUISetState(@SW_DISABLE, $tela_entradas)
                adicionar_receitas()
                GUISetState(@SW_ENABLE, $tela_entradas)
                WinActivate($tela_entradas)

		EndSwitch
	WEnd
EndFunc

Func adicionar_receitas()
	Global $tela_cadastro_receitas = GUICreate("Adicionar Receita", 400, 220)
	GUISetIcon("icones\add_round.ico")
    GUISetState()
	GUISetBkColor(0xB0E0E6)
	; Descrição
	GUICtrlCreateLabel("Descrição", 80, 10, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	GUICtrlCreateInput("", 30, 40, 200, 30)
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetTip(-1, "Descrição da entrada. Ex: Salário Mês")
	GUICtrlSetState(-1, $GUI_FOCUS)
	; Salário?
	GUICtrlCreateLabel("Salário", 240, 10, 70, 25)
	GUICtrlSetFont(-1, 15, 700)
	GUICtrlCreateCheckbox("", 270, 40, 15, 30)
	GUICtrlSetTip(-1, "Marque essa opção caso o valor seja referente ao salário do mês")
	; Obs
	GUICtrlCreateLabel("Obs.", 333, 10, 70, 25)
	GUICtrlSetTip(-1, "Adicionar Observação a essa entrada")
	GUICtrlSetFont(-1, 15, 700)
	local $btn_add_obs = GUICtrlCreateButton("add", 335, 40, 40, 40, $BS_ICON)
	GUICtrlSetImage(-1, "icones\add.ico", 22)
	GUICtrlSetTip(-1, "Adicionar Observação a essa entrada")
	; Valor
	GUICtrlCreateLabel("Valor", 110, 80, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	GUICtrlCreateInput("", 30, 105, 200, 30, $ES_NUMBER)
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetTip(-1, "Valor em Reais")
	; Data
	GUICtrlCreateLabel("Data", 275, 80, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	GUICtrlCreateDate("", 240, 105, 137, 30, $DTS_SHORTDATEFORMAT)
	GUICtrlSetFont(-1, 15, 400)
	; Botões
	local $btn_salvar = GUICtrlCreateButton("Salvar", 30, 170, 109, 40)
	GUICtrlSetFont(-1, 14, 700)
	GUICtrlSetBkColor(-1, 0x2E8B57)
	local $btn_cancelar = GUICtrlCreateButton("Cancelar", 148, 170, 109, 40)
	GUICtrlSetFont(-1, 14, 700)
	GUICtrlSetBkColor(-1, 0xFA8072)
	local $btn_sair = GUICtrlCreateButton("Sair", 267, 170, 109, 40)
	GUICtrlSetFont(-1, 14, 700)
	GUICtrlSetBkColor(-1, 0xF9FAFF)

	While 1
		switch GUIGetMsg()
			case $GUI_EVENT_CLOSE, $btn_sair
				GUIDelete($tela_cadastro_receitas)
				ExitLoop
			case $btn_salvar
				MsgBox(0, "", "Salvar")
			case $btn_cancelar
				MsgBox(0, "", "Cancelar")
			case $btn_add_obs
				adicionar_observacao_entrada()
		endswitch

	WEnd

EndFunc

Func adicionar_observacao_entrada()
    Local $hGUI = GUICreate("Adicionar Observação", 380, 200)
	GUISetBkColor(0xB0E0E6)
    GUISetState(@SW_SHOW, $hGUI)
	; Campo observação
	GUICtrlCreateLabel("Observação", 120, 10, 120, 25)
	GUICtrlSetFont(-1, 15, 700)
	GUICtrlCreateInput("", 30, 40, 310, 100, $ES_MULTILINE)
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetTip(-1, "Descrição da entrada. Ex: Salário Mês")
	GUICtrlSetState(-1, $GUI_FOCUS)
	; Botão Salvar
	local $btn_salvar = GUICtrlCreateButton("Salvar", 30, 155, 145, 40)
	GUICtrlSetFont(-1, 14, 700)
	GUICtrlSetBkColor(-1, 0x2E8B57)
	; Botão Voltar
	local $btn_voltar = GUICtrlCreateButton("Voltar", 197, 155, 145, 40)
	GUICtrlSetFont(-1, 14, 700)
	GUICtrlSetBkColor(-1, 0xFA8072)
    ; Loop until the user exits.
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
			Case $btn_salvar
				MsgBox(0, "", "Você clicou em salvar")
			Case $btn_voltar
				MsgBox(0, "", "Você clicou em voltar")
				ExitLoop

        EndSwitch
    WEnd

    ; Delete the previous GUI and all controls.
    GUIDelete($hGUI)
EndFunc

;adicionar_observacao_entrada()
;adicionar_receitas()