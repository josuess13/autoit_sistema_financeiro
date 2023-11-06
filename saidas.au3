Global $observacao_saida = ""
Func saidas()
    Local $tela_saidas = GUICreate("Despesas", 800, 520)
    GUISetIcon("icones\saidas.ico")
    GUISetState()
    ; Label Data
    Local $datas_mes_ano = GUICtrlCreateLabel(_DateToMonth(@MON, $DMW_LOCALE_LONGNAME) & "/" & @YEAR, 10, 30, 140, 30, $SS_CENTER)
	GUICtrlSetFont($datas_mes_ano, 13, 700)
	GUICtrlSetColor($datas_mes_ano, 0x8B0000)
	; Botão Adicionar
    Local $btn_adicionar = GUICtrlCreateButton("Adicionar +", 20, 60, 120, 40)
	GUICtrlSetFont($btn_adicionar, 13, 700)
	; Excluir Saída
	Local $btn_excluir_saida = GUICtrlCreateButton("Excluir", 20, 110, 120, 40)
	GUICtrlSetFont(-1, 9, 700)
	; Filtrar datas
	Local $filtrar_datas_entre = GUICtrlCreateLabel("Mostrar gastos entre:", 20, 160, 120, 40, $SS_CENTER)
	GUICtrlSetFont($filtrar_datas_entre, 9, 700)
	Local $data_inicio = GUICtrlCreateDate("", 20, 200, 120, 20, $DTS_SHORTDATEFORMAT)
	GUICtrlCreateLabel("e:", 20, 220, 120, -1, $SS_CENTER)
	GUICtrlSetFont(-1, 9, 700)
	Local $data_fim = GUICtrlCreateDate("", 20, 240, 120, 20, $DTS_SHORTDATEFORMAT)
	Local $btn_filtrar = GUICtrlCreateButton("Filtrar", 20, 270, 120, 40)
	GUICtrlSetFont(-1, 9, 700)
	; Para gastar
	GUICtrlCreateLabel("Para gastar:", 20, 320, 120, -1, $SS_CENTER)
	GUICtrlSetFont(-1, 9, 700)
	Local $para_gastar = calcula_saldo_saidas()[1]
	GUICtrlCreateLabel("R$ " & Round($para_gastar, 2), 20, 345, 120, -1, $SS_CENTER)
	GUICtrlSetFont(-1, 12, 700)
	; Total de despesas
	Local $t_despesas = calcula_saldo_saidas()[0]
	Local $label_valor_total_saidas = GUICtrlCreateLabel("Total Despesas: R$ " & $t_despesas, 160, 470, 250, 20)
	GUICtrlSetFont(-1, 12, 700)
	; Saldo para gastar
	GUICtrlCreateLabel("Saldo:", 20, 370, 120, -1, $SS_CENTER)
	GUICtrlSetFont(-1, 9, 700)
	Local $saldo_s = calcula_saldo_saidas()[1] - calcula_saldo_saidas()[0]
	GUICtrlCreateLabel("R$ " & Round($saldo_s, 2), 20, 395, 120, -1, $SS_CENTER)
	GUICtrlSetFont(-1, 12, 700)
	; Gasto Fixo
	Local $gastos_fixos = soma_gastos_fixos()
	GUICtrlCreateLabel("Gastos Fixos: R$ " & $gastos_fixos, 411, 470, 250, 20)
	GUICtrlSetFont(-1, 12, 700)

	Local $btn_Atualizar_despesas = GUICtrlCreateButton("Atualizar", 20, 470, 120, 40)
	GUICtrlSetFont(-1, 9, 700)

	Local $btn_gastos_fixos = GUICtrlCreateButton("Gastos Fixos", 660, 470, 120, 40)
	GUICtrlSetFont(-1, 9, 700)

	exibir_saidas_grid()

    While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($tela_saidas)
				ExitLoop
			Case $btn_adicionar
				GUISetState(@SW_DISABLE, $tela_saidas)
                adicionar_despesas()
                GUIDelete($tela_saidas)
				saidas()
				ExitLoop
			Case $btn_Atualizar_despesas
				GUIDelete($tela_saidas)
				saidas()
				ExitLoop
			Case $btn_excluir_saida
				excluir_saida_selecionada()
				GUIDelete($tela_saidas)
				saidas()
				ExitLoop
			Case $btn_filtrar
				GUISetState(@SW_DISABLE, $tela_saidas)
				exibir_saidas_grid_filtrando_datas(ControlGetText($tela_saidas, "", $data_inicio), ControlGetText($tela_saidas, "", $data_fim))
				GUISetState(@SW_ENABLE, $tela_saidas)
				WinActivate($tela_saidas)
			Case $btn_gastos_fixos
				GUISetState(@SW_DISABLE, $tela_saidas)
				gastos_fixos()
				GUIDelete($tela_saidas)
				saidas()
				ExitLoop
		EndSwitch
	WEnd
EndFunc

Func adicionar_despesas()
	Global $tela_cadastro_despesas = GUICreate("Adicionar Despesas", 400, 220)
	GUISetIcon("icones\add_round.ico")
    GUISetState()
	GUISetBkColor(0x778899)

	; Descrição
	GUICtrlCreateLabel("Descrição", 80, 10, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $descricao_saida = GUICtrlCreateInput("", 30, 40, 200, 30)
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetTip(-1, "Descrição da Saída. Ex: Mercado")
	GUICtrlSetState(-1, $GUI_FOCUS)
	; Salário?
	GUICtrlCreateLabel("Fixo", 240, 10, 70, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $gasto_fixo = GUICtrlCreateCheckbox("", 270, 40, 15, 30)
	GUICtrlSetTip(-1, "Ex: Internet")
	; Obs
	GUICtrlCreateLabel("Obs.", 333, 10, 70, 25)
	GUICtrlSetTip(-1, "Adicionar Observação a essa Saída")
	GUICtrlSetFont(-1, 15, 700)
	local $btn_add_obs = GUICtrlCreateButton("add", 335, 40, 40, 40, $BS_ICON)
	GUICtrlSetImage(-1, "icones\add.ico", 22)
	GUICtrlSetTip(-1, "Adicionar Observação a essa Saída")
	; Valor
	GUICtrlCreateLabel("Valor R$", 90, 80, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $valor_saida_reais = GUICtrlCreateInput("", 30, 105, 200, 30)
	GUICtrlSetTip(-1, "Reais")
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetLimit(-1, 10)
	; Data
	GUICtrlCreateLabel("Data", 275, 80, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $data_saida = GUICtrlCreateDate("", 240, 105, 137, 30, $DTS_SHORTDATEFORMAT)
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

	GUIRegisterMsg($WM_COMMAND, "permite_inserir_numeros_e_virgula_saida")
	While 1
		switch GUIGetMsg()
			case $GUI_EVENT_CLOSE, $btn_sair
				GUIDelete($tela_cadastro_despesas)
				ExitLoop
			case $btn_salvar
				Local $valida_dados = valida_dados_saida()
				Local $ler_descricao = ControlGetText($tela_cadastro_despesas, "", $descricao_saida)
				Local $ler_fixo = ControlCommand($tela_cadastro_despesas, "", $gasto_fixo, "IsChecked", "")
				Local $ler_valor = ControlGetText($tela_cadastro_despesas, "", $valor_saida_reais)
				Local $ler_data = ControlGetText($tela_cadastro_despesas, "", $data_saida)
				Local $ler_obs = $observacao_saida
				If  $valida_dados = 0 Then
					adicionar_despesa($ler_descricao,  $ler_valor, $ler_data, $ler_fixo, $ler_obs)
					limpar_dados_saida()
				EndIf
			case $btn_cancelar
				limpar_dados_saida()
			case $btn_add_obs
				adicionar_observacao_saida()
		endswitch
	WEnd
EndFunc

Func adicionar_observacao_saida()
    Local $hGUI = GUICreate("Adicionar Observação", 380, 200)
	GUISetBkColor(0x778899)
    GUISetState(@SW_SHOW, $hGUI)
	; Campo observação
	GUICtrlCreateLabel("Observação", 120, 10, 120, 25)
	GUICtrlSetFont(-1, 15, 700)
	Local $texto_da_observacao = GUICtrlCreateInput($observacao_saida, 30, 40, 310, 100, $ES_MULTILINE)
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetTip(-1, "Descrição da Saída. Ex: Mercado")
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
				$observacao_saida = ControlGetText($hGUI, "", $texto_da_observacao)
				ExitLoop
			Case $btn_voltar
				ExitLoop
        EndSwitch
    WEnd
    ; Delete the previous GUI and all controls.
    GUIDelete($hGUI)
EndFunc

Func valida_dados_saida()
	Local $validacao_entrada = 0
	Local $leitura_descricao = ControlGetText($tela_cadastro_despesas, "", $descricao_saida)
	Local $leitura_valor = ControlGetText($tela_cadastro_despesas, "", $valor_saida_reais)

	If Not StringRegExp($leitura_valor, '^\d{1,7}(?:,\d{1,2})?$') And $leitura_valor <> "" Then
		MsgBox(0, "Aviso", "valor inválido. " & @CRLF & "Informe um valor no padrão 0,00 ou 00")
		ControlFocus($tela_cadastro_despesas, "", $valor_saida_reais)
		$validacao_entrada = 1
	ElseIf $leitura_descricao == "" Then
		MsgBox(0, "Aviso", "Insira a descrição")
		ControlFocus($tela_cadastro_despesas, "", $descricao_saida)
		$validacao_entrada = 1
	ElseIf $leitura_valor == "" Or $leitura_valor == 0 Then
		MsgBox(0, "Aviso", "Insira o valor")
		ControlFocus($tela_cadastro_despesas, "", $valor_saida_reais)
		$validacao_entrada = 1
	EndIf

	Return($validacao_entrada)
EndFunc

Func permite_inserir_numeros_e_virgula_saida($hWnd, $iMsg, $iwParam, $ilParam)
    Local $iCode = BitShift($iwParam, 16)
    Local $iIDFrom = BitAND($iwParam, 0xFFFF)

    If $iIDFrom = $valor_saida_reais And $iCode = $EN_CHANGE Then
        Local $content = GUICtrlRead($valor_saida_reais)

        If Not StringRegExp($content, '^[0-9]{0,7}(?:,[0-9]{0,2})?$') Then
            $content = StringRegExpReplace($content, '[^0-9,]*', "")
        EndIf

        GUICtrlSetData($valor_saida_reais, $content)
    EndIf

    Return $GUI_RUNDEFMSG
EndFunc

Func limpar_dados_saida()
	ControlSetText($tela_cadastro_despesas, "", $descricao_saida, "")
	ControlCommand($tela_cadastro_despesas, "", $gasto_fixo, "UnCheck")
	ControlSetText($tela_cadastro_despesas, "", $valor_saida_reais, "")
	GUICtrlSetData($data_saida, @YEAR & "/" & @MON & "/" & @MDAY)
	$observacao_saida = ""
	ControlSetText("Adicionar Observação", "", $observacao_saida, "")
EndFunc

Func selecionar_item_grid_saidas()
	Local $Index = _GUICtrlListView_GetSelectedIndices($tabela_saida)
	$Index = $Index * 1

	If $Index == "" Then
		MsgBox(16, "Nenhum item selecionado", "Por favor, selecione um item na lista.")
		Return
	EndIf

	Local $ItemText = _GUICtrlListView_GetItemText($tabela_saida, $Index)
	Return $ItemText
EndFunc

Func excluir_saida_selecionada()
	$ItemText = selecionar_item_grid_saidas()
	Local $escolha = MsgBox(36, "Aviso!", "Deseja excluir gasto " & $ItemText & "?")
	If $escolha == $IDYES Then excluir_saida($ItemText)
EndFunc