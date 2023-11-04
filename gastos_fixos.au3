#include-once

Func gastos_fixos()
    Local $tela_gastos_fixos = GUICreate("Gastos Fixos", 500, 520)
    GUISetIcon("icones\saidas.ico")
    GUISetState()

	; Botão Adicionar
    Local $btn_adicionar = GUICtrlCreateButton("Adicionar", 20, 470, 110, 40)
	GUICtrlSetFont(-1, 13, 700)
	; Botão editar
    Local $btn_editar = GUICtrlCreateButton("Editar", 140, 470, 110, 40)
	GUICtrlSetFont(-1, 13, 700)
	; Botão excluir
    Local $btn_excluir = GUICtrlCreateButton("Excluir", 260, 470, 110, 40)
	GUICtrlSetFont(-1, 13, 700)
	; Botão gravar
    Local $btn_gravar = GUICtrlCreateButton("Gravar", 380, 470, 110, 40)
	GUICtrlSetFont(-1, 13, 700)
	GUICtrlSetBkColor(-1, 0x228B22)
	exibir_gastos_fixos_grid()
    While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($tela_gastos_fixos)
				ExitLoop
			Case $btn_adicionar
				GUISetState(@SW_DISABLE, $tela_gastos_fixos)
                adicionar_editar_gastos_fixos("Adicionar")
                GUIDelete($tela_gastos_fixos)
				gastos_fixos()
				ExitLoop
			Case $btn_editar
				GUISetState(@SW_DISABLE, $tela_gastos_fixos)
                adicionar_editar_gastos_fixos("Editar")
                GUIDelete($tela_gastos_fixos)
				gastos_fixos()
				ExitLoop
			Case $btn_excluir
				excluir_gasto_fixo()
				GUIDelete($tela_gastos_fixos)
				gastos_fixos()
				ExitLoop
			Case $btn_gravar
				gravar_gasto_fixo_nas_saidas()
		EndSwitch
	WEnd
EndFunc

Func capturar_id_gasto_fixo()
	Local $Index = _GUICtrlListView_GetSelectedIndices($tabela_gastos_fixos)
		$Index = $Index * 1

		If $Index == "" Then
			MsgBox(16, "Nenhum item selecionado", "Por favor, selecione um item na lista.")
			Return
		EndIf

		Local $ItemText = _GUICtrlListView_GetItemText($tabela_gastos_fixos, $Index)
		Return($ItemText)
EndFunc

Func adicionar_editar_gastos_fixos($opcao)
	If $opcao == "Editar" Then $ItemText = capturar_id_gasto_fixo()
	Global $tela_adicionar_editar_gastos_fixos = GUICreate("Gastos Fixos", 400, 170)
	GUISetIcon("icones\add_round.ico")
    GUISetState()
	GUISetBkColor(0x778899)

	; Id
	GUICtrlCreateLabel("ID", 30, 10, 50, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $id_gasto_fixo = GUICtrlCreateInput("", 20, 40, 50, 30)
	If $opcao == "Editar" Then ControlSetText($tela_adicionar_editar_gastos_fixos, "", $id_gasto_fixo, carregar_gasto_fixo_para_edicao($ItemText)[0])
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetState(-1, $GUI_DISABLE)
	; Descrição
	GUICtrlCreateLabel("Descrição", 130, 10, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $descricao_gasto_fixo = GUICtrlCreateInput("", 80, 40, 200, 30)
	If $opcao == "Editar" Then ControlSetText($tela_adicionar_editar_gastos_fixos, "", $descricao_gasto_fixo, carregar_gasto_fixo_para_edicao($ItemText)[1])
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetState(-1, $GUI_FOCUS)
	; Valor
	GUICtrlCreateLabel("Valor", 306, 10, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $valor_gasto_fixo = GUICtrlCreateInput("", 286, 40, 100, 30)
	If $opcao == "Editar" Then ControlSetText($tela_adicionar_editar_gastos_fixos, "", $valor_gasto_fixo, carregar_gasto_fixo_para_edicao($ItemText)[2])
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

	GUIRegisterMsg($WM_COMMAND, "permite_inserir_numeros_e_virgula_gf")

	While 1
		switch GUIGetMsg()
			case $GUI_EVENT_CLOSE, $btn_sair
				GUIDelete($tela_adicionar_editar_gastos_fixos)
				ExitLoop
			Case $btn_salvar
				Local $valida_gf = valida_dados_gastos_fixos()
				Local $valor_id_gf = ControlGetText($tela_adicionar_editar_gastos_fixos, "", $id_gasto_fixo)
				Local $valor_descricao_gf = ControlGetText($tela_adicionar_editar_gastos_fixos, "", $descricao_gasto_fixo)
				Local $valor_valor_gf = ControlGetText($tela_adicionar_editar_gastos_fixos, "", $valor_gasto_fixo)
				If $valida_gf == 0 Then
					If $opcao <> "Editar" Then salvar_gasto_fixo($valor_descricao_gf, $valor_valor_gf)
					If $opcao == "Editar" Then salvar_edicao_gasto_fixo($ItemText, $valor_descricao_gf, $valor_valor_gf)
					limpar_tela_gravar_gastos_fixos()
					If $opcao == "Editar" Then
						GUIDelete($tela_adicionar_editar_gastos_fixos)
						ExitLoop
					EndIf
				EndIf
			Case $btn_cancelar
				If $opcao <> "Editar" Then limpar_tela_gravar_gastos_fixos()
				If $opcao == "Editar" Then
					limpar_tela_gravar_gastos_fixos()	
					GUIDelete($tela_adicionar_editar_gastos_fixos)
					ExitLoop			
				EndIf
		endswitch
	WEnd
EndFunc

Func limpar_tela_gravar_gastos_fixos()
	ControlSetText($tela_adicionar_editar_gastos_fixos, "", $descricao_gasto_fixo, "")
	ControlSetText($tela_adicionar_editar_gastos_fixos, "", $valor_gasto_fixo, "")
EndFunc

Func valida_dados_gastos_fixos()
	$validacao_gf = 0
	Local $leitura_descricao = ControlGetText($tela_adicionar_editar_gastos_fixos, "", $descricao_gasto_fixo)
	Local $leitura_valor = ControlGetText($tela_adicionar_editar_gastos_fixos, "", $valor_gasto_fixo)

	If Not StringRegExp($leitura_valor, '^\d{1,7}(?:,\d{1,2})?$') And $leitura_valor <> "" Then
		MsgBox(0, "Aviso", "valor inválido. " & @CRLF & "Informe um valor no padrão 0,00 ou 00")
		ControlFocus($tela_adicionar_editar_gastos_fixos, "", $valor_gasto_fixo)
		$validacao_gf = 1
	ElseIf $leitura_descricao == "" Then
		MsgBox(0, "Aviso", "Insira a descrição")
		ControlFocus($tela_adicionar_editar_gastos_fixos, "", $descricao_gasto_fixo)
		$validacao_gf = 1
	ElseIf $leitura_valor == "" Or $leitura_valor == 0 Then
		MsgBox(0, "Aviso", "Insira o valor")
		ControlFocus($tela_adicionar_editar_gastos_fixos, "", $valor_gasto_fixo)
		$validacao_gf = 1
	EndIf

	Return($validacao_gf)
EndFunc

Func permite_inserir_numeros_e_virgula_gf($hWnd, $iMsg, $iwParam, $ilParam)
    Local $iCode = BitShift($iwParam, 16)
    Local $iIDFrom = BitAND($iwParam, 0xFFFF)

    If $iIDFrom = $valor_gasto_fixo And $iCode = $EN_CHANGE Then
        Local $content = GUICtrlRead($valor_gasto_fixo)

        If Not StringRegExp($content, '^[0-9]{0,7}(?:,[0-9]{0,2})?$') Then
            $content = StringRegExpReplace($content, '[^0-9,]*', "")
        EndIf

        GUICtrlSetData($valor_gasto_fixo, $content)
    EndIf

    Return $GUI_RUNDEFMSG
EndFunc

Func excluir_gasto_fixo()
	Local $ItemText = capturar_id_gasto_fixo()
	Local $escolha = MsgBox(36, "Aviso!", "Deseja excluir gasto fixo " & $ItemText & "?")
	If $escolha == $IDYES Then deletar_gasto_fixo($ItemText)
EndFunc

Func gravar_gasto_fixo_nas_saidas()
	Local $ItemText = capturar_id_gasto_fixo()
	Local $escolha = MsgBox(36, "Aviso!", "Deseja gravar gasto fixo " & $ItemText & "?")
	If $escolha == $IDYES Then gravar_gasto_fixo($ItemText)
EndFunc