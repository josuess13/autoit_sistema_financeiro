# AutoIt3Wrapper_UseX64 = Y

Func tela_inicial()
    ; tela principal
    Global $tela_inicial = GUICreate("Nosso Financeiro", 900, 600)
	GUISetState(@SW_SHOW, $tela_inicial)
    GUISetIcon("icones\money.ico")

	local $btn_receitas_inicial = GUICtrlCreateButton("RECEITAS", 10, 10, 200, 100)
	GUICtrlSetFont(-1, 16, 800, 0, "Arial")
	GUICtrlSetBkColor(-1, 0x3CB371)

	local $btn_despesas_inicial = GUICtrlCreateButton("DESPESAS", 10, 120, 200, 100)
	GUICtrlSetFont($btn_despesas_inicial, 16, 800, 0, "Arial")
	GUICtrlSetBkColor($btn_despesas_inicial, 0xCD5C5C)

	local $btn_investimentos = GUICtrlCreateButton("INVESTIMENTOS", 10, 230, 200, 100)
	GUICtrlSetFont($btn_investimentos, 16, 800, 0, "Arial")
	GUICtrlSetBkColor($btn_investimentos, 0xFDF5E6)

    ; Menu movimentos
    Local $m_movimentos = GUICtrlCreateMenu("Movimentos")
    Local $m_movimentos_entradas = GUICtrlCreateMenuItem("Receitas", $m_movimentos)
    Local $m_movimentos_saidas = GUICtrlCreateMenuItem("Despesas", $m_movimentos)
	; Menu investimentos
	Local $m_investimentos = GUICtrlCreateMenu("Investimentos")
	Local $sm_investimentos = GUICtrlCreateMenuItem("Investimentos", $m_investimentos)

	$plano_fundo = GUICtrlCreatePic(@ScriptDir & "\icones\plano_fundo.jpg", 0, 0, 900, 600)

	;Mostra usuário logado
	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	Local $consultar_usuario_logado = _SQLite_GetTableData2D($hDatabase, "SELECT configuracoes.usuario_logado FROM configuracoes;", $aResult, $iRows, $aNames)
	Local $mostrar_usuario_logado = GUICtrlCreateLabel("   Usuário: " & $aResult[0][0], 745, 560, 150, 20)
	GUICtrlSetColor(-1, 0x228B22)
	GUICtrlSetFont(-1, 12, 700)
	desconecta_e_fecha_banco()

    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $m_movimentos_entradas
                GUISetState(@SW_DISABLE, $tela_inicial)
                entradas()
                GUISetState(@SW_ENABLE, $tela_inicial)
                WinActivate($tela_inicial)
            Case $m_movimentos_saidas
                GUISetState(@SW_DISABLE, $tela_inicial)
                saidas()
                GUISetState(@SW_ENABLE, $tela_inicial)
                WinActivate($tela_inicial)
			Case $btn_receitas_inicial
				GUISetState(@SW_DISABLE, $tela_inicial)
                entradas()
                GUISetState(@SW_ENABLE, $tela_inicial)
                WinActivate($tela_inicial)
			Case $btn_despesas_inicial
				GUISetState(@SW_DISABLE, $tela_inicial)
                saidas()
                GUISetState(@SW_ENABLE, $tela_inicial)
                WinActivate($tela_inicial)
			Case $btn_investimentos
				GUISetState(@SW_DISABLE, $tela_inicial)
				investimentos()
				GUISetState(@SW_ENABLE, $tela_inicial)
				WinActivate($tela_inicial)
			Case $sm_investimentos
				GUISetState(@SW_DISABLE, $tela_inicial)
				investimentos()
				GUISetState(@SW_ENABLE, $tela_inicial)
				WinActivate($tela_inicial)
        EndSwitch
    WEnd
    GUIDelete($tela_inicial)
    Exit
EndFunc