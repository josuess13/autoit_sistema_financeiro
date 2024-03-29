
Func investimentos()
    Global $tela_investimentos = GUICreate("Investimentos", 800, 520)
    GUISetIcon("icones\invest.ico")
    GUISetState()

	Local $adicionar_metas = GUICtrlCreateButton("Adicionar Meta", 20, 30, 130, 40)
	GUICtrlSetFont(-1, 13, 700)

	Local $editar_metas = GUICtrlCreateButton("Editar Meta", 20, 80, 130, 40)
	GUICtrlSetFont(-1, 13, 700)

	Local $btn_excluir_meta = GUICtrlCreateButton("Excluir Meta", 20, 130, 130, 40)
	GUICtrlSetFont(-1, 13, 700)

	Local $btn_excluir_investidos = GUICtrlCreateButton("Excluir Invest.", 20, 180, 130, 40)
	GUICtrlSetFont(-1, 13, 700)

	Local $btn_atualizar_investimentos = GUICtrlCreateButton("Atualizar", 20, 470, 130, 40)
	GUICtrlSetFont(-1, 13, 700)

	Local $btn_gravar_metas = GUICtrlCreateButton("Gravar", 20, 420, 130, 40)
	GUICtrlSetFont(-1, 13, 700)
	GUICtrlSetBkColor(-1, 0x2E8B57)

	Local $btn_abrir_receitas = GUICtrlCreateButton("Receitas", 590, 150, 130, 40)
	GUICtrlSetFont(-1, 13, 700)

	Local $btn_abrir_despesas = GUICtrlCreateButton("Despesas", 590, 200, 130, 40)
	GUICtrlSetFont(-1, 13, 700)

	$entrada_mes = consultar_entradas_mes()

	; grid
	exibir_metas_grid()

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($tela_investimentos)
				GUISetState(@SW_ENABLE, $tela_inicial)
				ExitLoop
			Case $adicionar_metas
				GUISetState(@SW_DISABLE, $tela_investimentos)
                adicionar_metas()
                GUISetState(@SW_ENABLE, $tela_investimentos)
                WinActivate($tela_investimentos)
				GUIDelete($tela_investimentos)
				investimentos()
				ExitLoop
			Case $btn_atualizar_investimentos
				GUIDelete($tela_investimentos)
				investimentos()
				ExitLoop
			Case $btn_gravar_metas
				gravar_investimentos()
				GUIDelete($tela_investimentos)
				investimentos()
				ExitLoop
			Case $editar_metas
				GUISetState(@SW_DISABLE, $tela_investimentos)
				editar_metas()
				GUISetState(@SW_ENABLE, $tela_investimentos)
                WinActivate($tela_investimentos)
				GUIDelete($tela_investimentos)
				investimentos()
				ExitLoop
			Case $btn_excluir_meta
				excluir_meta()
				GUIDelete($tela_investimentos)
				investimentos()
				ExitLoop
			Case $btn_abrir_receitas
				GUISetState(@SW_DISABLE, $tela_investimentos)
                entradas()
                GUISetState(@SW_ENABLE, $tela_investimentos)
                WinActivate($tela_investimentos)
			Case $btn_abrir_despesas
				GUISetState(@SW_DISABLE, $tela_investimentos)
                saidas()
                GUISetState(@SW_ENABLE, $tela_investimentos)
                WinActivate($tela_investimentos)
			Case $btn_excluir_investidos
				excluir_investidos()
				GUIDelete($tela_investimentos)
				investimentos()
				ExitLoop
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

	GUIRegisterMsg($WM_COMMAND, "permite_inserir_numeros_e_virgula_metas")

	While 1
		switch GUIGetMsg()
			case $GUI_EVENT_CLOSE, $btn_sair
				GUIDelete($tela_cadastro_metas)
				ExitLoop
			Case $btn_salvar
				Local $valor_nome_meta = ControlGetText($tela_cadastro_metas, "", $descricao_meta)
				Local $valor_porcentagem_meta = ControlGetText($tela_cadastro_metas, "", $porcentagem_meta)
				If valida_campos_vazios_metas() == 0 Then
					adicionar_meta($valor_nome_meta, $valor_porcentagem_meta)
					GUIDelete($tela_cadastro_metas)
					ExitLoop
				EndIf
		endswitch
	WEnd
EndFunc

Func permite_inserir_numeros_e_virgula_metas($hWnd, $iMsg, $iwParam, $ilParam)
    Local $iCode = BitShift($iwParam, 16)
    Local $iIDFrom = BitAND($iwParam, 0xFFFF)

    If $iIDFrom = $porcentagem_meta And $iCode = $EN_CHANGE Then
        Local $content = GUICtrlRead($porcentagem_meta)

        If Not StringRegExp($content, '^[0-9]{0,7}(?:,[0-9]{0,2})?$') Then
            $content = StringRegExpReplace($content, '[^0-9,]*', "")
        EndIf

        GUICtrlSetData($porcentagem_meta, $content)
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc

Func valida_campos_vazios_metas()
	Local $validacao_entrada = 0
	Local $leitura_descricao = ControlGetText($tela_cadastro_metas, "", $descricao_meta)
	Local $leitura_valor = ControlGetText($tela_cadastro_metas, "", $porcentagem_meta)

	If $leitura_descricao == "" Then
		MsgBox(0, "Aviso", "Insira a descrição")
		ControlFocus($tela_cadastro_metas, "", $descricao_meta)
		$validacao_entrada = 1
	ElseIf $leitura_valor == "" Or $leitura_valor == 0 Then
		MsgBox(0, "Aviso", "Insira o valor")
		ControlFocus($tela_cadastro_metas, "", $porcentagem_meta)
		$validacao_entrada = 1
	EndIf

	Return($validacao_entrada)
EndFunc

Func editar_metas()
	Local $Index = _GUICtrlListView_GetSelectedIndices($tabela_metas)
	$Index = $Index * 1

    If $Index == "" Then
        MsgBox(16, "Nenhum item selecionado", "Por favor, selecione um item na lista.")
		Return
    EndIf

    Local $ItemText = _GUICtrlListView_GetItemText($tabela_metas, $Index)
    
	Global $tela_editar_meta = GUICreate("Editar Meta", 400, 170)
	GUISetIcon("icones\add_round.ico")
    GUISetState()
	GUISetBkColor(0x778899)

	; Id
	GUICtrlCreateLabel("ID", 50, 10, 50, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $id_meta = GUICtrlCreateInput(carregar_meta_para_edicao($ItemText)[0], 40, 40, 50, 30)
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetState(-1, $GUI_DISABLE)
	; Descrição
	GUICtrlCreateLabel("Descrição", 160, 10, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $descricao_meta = GUICtrlCreateInput(carregar_meta_para_edicao($ItemText)[1], 110, 40, 200, 30)
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetState(-1, $GUI_FOCUS)
	; Porcentagem
	GUICtrlCreateLabel("%", 336, 10, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $porcentagem_meta = GUICtrlCreateInput(carregar_meta_para_edicao($ItemText)[2], 326, 40, 50, 30)
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
				GUIDelete($tela_editar_meta)
				ExitLoop
			Case $btn_salvar
				Local $valor_id_meta = ControlGetText($tela_editar_meta, "", $id_meta)
				Local $valor_nome_meta = ControlGetText($tela_editar_meta, "", $descricao_meta)
				Local $valor_porcentagem_meta = ControlGetText($tela_editar_meta, "", $porcentagem_meta)
				salvar_edicao_meta($valor_id_meta, $valor_nome_meta, $valor_porcentagem_meta)
				GUIDelete($tela_editar_meta)
				ExitLoop
		endswitch
	WEnd
EndFunc

Func excluir_meta()
	Local $Index = _GUICtrlListView_GetSelectedIndices($tabela_metas)
	$Index = $Index * 1

    If $Index == "" Then
        MsgBox(16, "Nenhum item selecionado", "Por favor, selecione um item na lista.")
		Return
    EndIf

    Local $ItemText = _GUICtrlListView_GetItemText($tabela_metas, $Index)
	Local $escolha = MsgBox(36, "Aviso!", "Deseja excluir a Meta " & $ItemText & "?")
	If $escolha == $IDYES Then desativar_meta($ItemText)
EndFunc