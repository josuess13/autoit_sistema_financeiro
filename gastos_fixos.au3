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
		EndSwitch
	WEnd
EndFunc

Func adicionar_editar_gastos_fixos($opcao)
	If $opcao == "Editar" Then
		Local $Index = _GUICtrlListView_GetSelectedIndices($tabela_gastos_fixos)
		$Index = $Index * 1

		If $Index == "" Then
			MsgBox(16, "Nenhum item selecionado", "Por favor, selecione um item na lista.")
			Return
		EndIf

		Local $ItemText = _GUICtrlListView_GetItemText($tabela_gastos_fixos, $Index)
	EndIf

	Global $tela_adicionar_editar_gastos_fixos = GUICreate("Gastos Fixos", 400, 170)
	GUISetIcon("icones\add_round.ico")
    GUISetState()
	GUISetBkColor(0x778899)

	; Id
	GUICtrlCreateLabel("ID", 50, 10, 50, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $id_gasto_fixo = GUICtrlCreateInput("", 40, 40, 50, 30)
	If $opcao == "Editar" Then ControlSetText($tela_adicionar_editar_gastos_fixos, "", $id_gasto_fixo, carregar_gasto_fixo_para_edicao($ItemText)[0])
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetState(-1, $GUI_DISABLE)
	; Descrição
	GUICtrlCreateLabel("Descrição", 160, 10, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $descricao_gasto_fixo = GUICtrlCreateInput("", 110, 40, 200, 30)
	If $opcao == "Editar" Then ControlSetText($tela_adicionar_editar_gastos_fixos, "", $descricao_gasto_fixo, carregar_gasto_fixo_para_edicao($ItemText)[1])
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetState(-1, $GUI_FOCUS)
	; Valor
	GUICtrlCreateLabel("Valor", 336, 10, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $valor_gasto_fixo = GUICtrlCreateInput("", 326, 40, 100, 30)
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

	While 1
		switch GUIGetMsg()
			case $GUI_EVENT_CLOSE, $btn_sair
				GUIDelete($tela_adicionar_editar_gastos_fixos)
				ExitLoop
			Case $btn_salvar
				Local $valor_id_gf = ControlGetText($tela_adicionar_editar_gastos_fixos, "", $id_gasto_fixo)
				Local $valor_descricao_gf = ControlGetText($tela_adicionar_editar_gastos_fixos, "", $descricao_gasto_fixo)
				Local $valor_valor_gf = ControlGetText($tela_adicionar_editar_gastos_fixos, "", $valor_gasto_fixo)
				salvar_edicao_gasto_fixo($valor_id_gf, $valor_descricao_gf, $valor_valor_gf)
				GUIDelete($tela_adicionar_editar_gastos_fixos)
				ExitLoop
		endswitch
	WEnd
EndFunc