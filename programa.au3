# AutoIt3Wrapper_UseX64 = Y

tela_inicial()

Func tela_inicial()
    ; tela principal
    Local $tela_inicial = GUICreate("Seu Financeiro", 900, 600)
	GUISetState(@SW_SHOW, $tela_inicial)
    GUISetIcon("icones\money.ico")

	;GUISetState()

	local $btn_receitas_inicial = GUICtrlCreateButton("RECEITAS", 10, 10, 200, 100)
	GUICtrlSetFont(-1, 16, 800, 0, "Arial")
	GUICtrlSetBkColor(-1, $COLOR_MEDIUMSEAGREEN)

	local $btn_despesas_inicial = GUICtrlCreateButton("DESPESAS", 10, 120, 200, 100)
	GUICtrlSetFont($btn_despesas_inicial, 16, 800, 0, "Arial")
	GUICtrlSetBkColor($btn_despesas_inicial, $COLOR_INDIANRED)


    ; Menu movimentos
    Local $m_movimentos = GUICtrlCreateMenu("Movimentos")
    ;GUICtrlSetState($m_movimentos, $GUI_DEFBUTTON)
    Local $m_movimentos_entradas = GUICtrlCreateMenuItem("Receitas", $m_movimentos)
    Local $m_movimentos_saidas = GUICtrlCreateMenuItem("Despesas", $m_movimentos)
	$plano_fundo = GUICtrlCreatePic("C:\autoit\interfaces\autoit_sistema_financeiro\icones\plano_fundo.jpg", 0, 0, 900, 600)
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
        EndSwitch
    WEnd
    GUIDelete($tela_inicial)
    Exit
EndFunc