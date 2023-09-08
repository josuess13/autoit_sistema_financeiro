Global $observacao_entrada = ""
Func entradas()
    Local $tela_entradas = GUICreate("Receitas", 800, 520)
    GUISetIcon("icones\entradas.ico")
    GUISetState()
    ; Botão Adicionar
    Local $btn_adicionar = GUICtrlCreateButton("Adicionar +", 20, 30, 120, 40)
	GUICtrlSetFont($btn_adicionar, 13, 700)
    ; Data
    Local $datas_mes_ano = GUICtrlCreateLabel(_DateToMonth(@MON, $DMW_LOCALE_LONGNAME) & "/" & @YEAR, 20, 100, 120, 40, $SS_CENTER)
	GUICtrlSetFont($datas_mes_ano, 13, 700)
	GUICtrlSetColor($datas_mes_ano, 0x228B22)

	; Botão Entradas mês
	Local $btn_entradas_mes = GUICtrlCreateButton("Entradas no mês", 20, 150, 120, 40)
	GUICtrlSetFont(-1, 9, 700)
	; Botão entradas no ano
	Local $btn_entradas_ano = GUICtrlCreateButton("Entradas no ano", 20, 200, 120, 40)
	GUICtrlSetFont(-1, 9, 700)
	; Filtrar datas
	Local $filtrar_datas_entre = GUICtrlCreateLabel("Mostrar entradas entre:", 20, 250, 120, 40, $SS_CENTER)
	GUICtrlSetFont($filtrar_datas_entre, 9, 700)
	Local $data_inicio = GUICtrlCreateDate("", 20, 290, 120, 20, $DTS_SHORTDATEFORMAT)
	GUICtrlCreateLabel("e:", 20, 310, 120, -1, $SS_CENTER)
	GUICtrlSetFont(-1, 9, 700)
	Local $data_fim = GUICtrlCreateDate("", 20, 330, 120, 20, $DTS_SHORTDATEFORMAT)
	Local $btn_filtrar = GUICtrlCreateButton("Filtrar", 20, 360, 120, 40)
	GUICtrlSetFont(-1, 9, 700)
	Local $limpar_filtros = GUICtrlCreateButton("Limpar Filtros", 20, 400, 120, 40)
	GUICtrlSetFont(-1, 9, 700)

	Local $btn_Atualizar_receitas = GUICtrlCreateButton("Atualizar", 20, 470, 120, 40)
	GUICtrlSetFont(-1, 9, 700)

	Local $label_valor_total_entradas = GUICtrlCreateLabel("Total:", 160, 470, 200, 20)
	GUICtrlSetFont(-1, 12, 700)

	exibir_entradas_grid()


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
			Case $btn_Atualizar_receitas
				exibir_entradas_grid()
		EndSwitch
	WEnd
EndFunc

Func adicionar_receitas()
	Global $tela_cadastro_receitas = GUICreate("Adicionar Receita", 400, 220)
	GUISetIcon("icones\add_round.ico")
    GUISetState()
	GUISetBkColor(0x778899)

	; Descrição
	GUICtrlCreateLabel("Descrição", 80, 10, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $descricao_entrada = GUICtrlCreateInput("", 30, 40, 200, 30)
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetTip(-1, "Descrição da entrada. Ex: Salário Mês")
	GUICtrlSetState(-1, $GUI_FOCUS)
	; Salário?
	GUICtrlCreateLabel("Salário", 240, 10, 70, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $salario = GUICtrlCreateCheckbox("", 270, 40, 15, 30)
	GUICtrlSetTip(-1, "Marque essa opção caso o valor seja referente ao salário do mês")
	; Obs
	GUICtrlCreateLabel("Obs.", 333, 10, 70, 25)
	GUICtrlSetTip(-1, "Adicionar Observação a essa entrada")
	GUICtrlSetFont(-1, 15, 700)
	local $btn_add_obs = GUICtrlCreateButton("add", 335, 40, 40, 40, $BS_ICON)
	GUICtrlSetImage(-1, "icones\add.ico", 22)
	GUICtrlSetTip(-1, "Adicionar Observação a essa entrada")
	; Valor
	GUICtrlCreateLabel("Valor R$", 90, 80, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $valor_entrada_reais = GUICtrlCreateInput("", 30, 105, 200, 30)
	GUICtrlSetTip(-1, "Reais")
	GUICtrlSetFont(-1, 15, 400)
	GUICtrlSetBkColor(-1, 0xDCDCDC)
	GUICtrlSetLimit(-1, 10)
	; Data
	GUICtrlCreateLabel("Data", 275, 80, 100, 25)
	GUICtrlSetFont(-1, 15, 700)
	Global $data_entrada = GUICtrlCreateDate("", 240, 105, 137, 30, $DTS_SHORTDATEFORMAT)
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

	GUIRegisterMsg($WM_COMMAND, "permite_inserir_numeros_e_virgula")
	While 1
		switch GUIGetMsg()
			case $GUI_EVENT_CLOSE, $btn_sair
				GUIDelete($tela_cadastro_receitas)
				ExitLoop
			case $btn_salvar
				Local $valida_dados = valida_dados_entrada()
				Local $ler_descricao = ControlGetText($tela_cadastro_receitas, "", $descricao_entrada)
				Local $ler_salario = ControlCommand($tela_cadastro_receitas, "", $salario, "IsChecked", "")
				Local $ler_valor = ControlGetText($tela_cadastro_receitas, "", $valor_entrada_reais)
				Local $ler_data = ControlGetText($tela_cadastro_receitas, "", $data_entrada)
				Local $ler_obs = $observacao_entrada
				If  $valida_dados = 0 Then
					adicionar_receita($ler_descricao,  $ler_valor,  $ler_data, $ler_salario, $ler_obs)
					limpar_dados_entrada()
				EndIf
			case $btn_cancelar
				limpar_dados_entrada()
			case $btn_add_obs
				adicionar_observacao_entrada()
		endswitch
	WEnd
EndFunc

Func adicionar_observacao_entrada()
    Local $hGUI = GUICreate("Adicionar Observação", 380, 200)
	GUISetBkColor(0x778899)
    GUISetState(@SW_SHOW, $hGUI)
	; Campo observação
	GUICtrlCreateLabel("Observação", 120, 10, 120, 25)
	GUICtrlSetFont(-1, 15, 700)
	Local $texto_da_observacao = GUICtrlCreateInput($observacao_entrada, 30, 40, 310, 100, $ES_MULTILINE)
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
				$observacao_entrada = ControlGetText($hGUI, "", $texto_da_observacao)
				ExitLoop
			Case $btn_voltar
				ExitLoop
        EndSwitch
    WEnd
    ; Delete the previous GUI and all controls.
    GUIDelete($hGUI)
EndFunc

Func permite_inserir_numeros_e_virgula($hWnd, $iMsg, $iwParam, $ilParam)
    Local $iCode = BitShift($iwParam, 16)
    Local $iIDFrom = BitAND($iwParam, 0xFFFF)

    If $iIDFrom = $valor_entrada_reais And $iCode = $EN_CHANGE Then
        Local $content = GUICtrlRead($valor_entrada_reais)

        If Not StringRegExp($content, '^[0-9]{0,7}(?:,[0-9]{0,2})?$') Then
            $content = StringRegExpReplace($content, '[^0-9,]*', "")
        EndIf

        GUICtrlSetData($valor_entrada_reais, $content)
    EndIf

    Return $GUI_RUNDEFMSG
EndFunc

Func valida_dados_entrada()
	Local $validacao_entrada = 0
	Local $leitura_descricao = ControlGetText($tela_cadastro_receitas, "", $descricao_entrada)
	Local $leitura_valor = ControlGetText($tela_cadastro_receitas, "", $valor_entrada_reais)

	If Not StringRegExp($leitura_valor, '^\d{1,7}(?:,\d{1,2})?$') And $leitura_valor <> "" Then
		MsgBox(0, "Aviso", "valor inválido. " & @CRLF & "Informe um valor no padrão 0,00 ou 00")
		ControlFocus($tela_cadastro_receitas, "", $valor_entrada_reais)
		$validacao_entrada = 1
	ElseIf $leitura_descricao == "" Then
		MsgBox(0, "Aviso", "Insira a descrição")
		ControlFocus($tela_cadastro_receitas, "", $descricao_entrada)
		$validacao_entrada = 1
	ElseIf $leitura_valor == "" Or $leitura_valor == 0 Then
		MsgBox(0, "Aviso", "Insira o valor")
		ControlFocus($tela_cadastro_receitas, "", $valor_entrada_reais)
		$validacao_entrada = 1
	EndIf

	Return($validacao_entrada)
EndFunc

Func limpar_dados_entrada()
	ControlSetText($tela_cadastro_receitas, "", $descricao_entrada, "")
	ControlCommand($tela_cadastro_receitas, "", $salario, "UnCheck")
	ControlSetText($tela_cadastro_receitas, "", $valor_entrada_reais, "")
	GUICtrlSetData($data_entrada, @YEAR & "/" & @MON & "/" & @MDAY)
	$observacao_entrada = ""
	ControlSetText("Adicionar Observação", "", $observacao_entrada, "")
EndFunc