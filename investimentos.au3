
Func investimentos()
    Local $tela_investimentos = GUICreate("Investimentos", 800, 520)
    GUISetIcon("icones\invest.ico")
    GUISetState()

	Local $adicionar_metas = GUICtrlCreateButton("Adicionar Metas", 20, 30, 130, 40)
	GUICtrlSetFont(-1, 13, 700)

	Local $editar_metas = GUICtrlCreateButton("Editar Metas", 20, 80, 130, 40)
	GUICtrlSetFont(-1, 13, 700)

	Local $btn_investimentos_total = GUICtrlCreateButton("Inv. Total", 20, 130, 130, 40)
	GUICtrlSetFont(-1, 13, 700)

	Local $btn_atualizar_investimentos = GUICtrlCreateButton("Atualizar", 20, 470, 130, 40)
	GUICtrlSetFont(-1, 13, 700)

	Local $btn_gravar_metas = GUICtrlCreateButton("Gravar", 660, 470, 120, 40)
	GUICtrlSetFont(-1, 13, 700)

	$entrada_mes = consultar_entradas_mes()

	; grid
	exibir_metas_grid()

    While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($tela_investimentos)
				ExitLoop
			Case $adicionar_metas
				GUISetState(@SW_DISABLE, $tela_investimentos)
                adicionar_metas()
                GUISetState(@SW_ENABLE, $tela_investimentos)
                WinActivate($tela_investimentos)
			Case $btn_atualizar_investimentos
				exibir_metas_grid()
			Case $btn_gravar_metas
				gravar_investimentos()
		EndSwitch
	WEnd
EndFunc

Func adicionar_metas()
	Global $tela_cadastro_metas = GUICreate("Adicionar Meta", 400, 170)
	GUISetIcon("icones\add_round.ico")
    GUISetState()
	GUISetBkColor(0x778899)

	; Descrição
	GUICtrlCreateLabel("Descrição", 80, 10, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $descricao_meta = GUICtrlCreateInput("", 30, 40, 200, 30)
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetTip(-1, "Descrição da entrada. Ex: Salário Mês")
	GUICtrlSetState(-1, $GUI_FOCUS)
	; Porcentagem
	GUICtrlCreateLabel("%", 275, 10, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $porcentagem_meta = GUICtrlCreateInput("", 260, 40, 50, 30)
	GUICtrlSetTip(-1, "Reais")
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetLimit(-1, 10)
	; Botões
	local $btn_salvar = GUICtrlCreateButton("Salvar", 30, 110, 109, 40)
	GUICtrlSetFont(-1, 14, 700)
	GUICtrlSetBkColor(-1, 0x2E8B57)
	local $btn_cancelar = GUICtrlCreateButton("Cancelar", 148, 110, 109, 40)
	GUICtrlSetFont(-1, 14, 700)
	GUICtrlSetBkColor(-1, 0xFA8072)
	local $btn_sair = GUICtrlCreateButton("Sair", 267, 110, 109, 40)
	GUICtrlSetFont(-1, 14, 700)
	GUICtrlSetBkColor(-1, 0xF9FAFF)

	While 1
		switch GUIGetMsg()
			case $GUI_EVENT_CLOSE, $btn_sair
				GUIDelete($tela_cadastro_metas)
				ExitLoop
			Case $btn_salvar
				Local $valor_nome_meta = ControlGetText($tela_cadastro_metas, "", $descricao_meta)
				Local $valor_porcentagem_meta = ControlGetText($tela_cadastro_metas, "", $porcentagem_meta)
				adicionar_meta($valor_nome_meta, $valor_porcentagem_meta)
		endswitch
	WEnd

EndFunc