# AutoIt3Wrapper_UseX64 = Y
#include-once

Global $msg_erro

Func login()
    ; Tela de Login
    Global $tela_login = GUICreate("Login", 300, 440)
	GUISetBkColor(0x808080)
	GUISetIcon("icones\money.ico")
	GUICtrlCreatePic("icones\login.bmp", 50, 10, 200, 200)
	; Usuário
	Local $lb_login = GUICtrlCreateLabel("Usuário", 122, 210, 75, 25)
	GUICtrlSetFont($lb_login, 15, 700)
	Global $in_login = GUICtrlCreateInput("", 50, 240, 200, 30)
	GUICtrlSetFont($in_login, 15, 700)
	GUICtrlSetColor($in_login, 0x4F4F4F)
	GUICtrlSetBkColor($in_login, 0xB0C4DE)
	GUICtrlSetStyle($in_login, BitOr($ES_CENTER, $ES_UPPERCASE))
	; Senha
	Local $lb_senha = GUICtrlCreateLabel("Senha", 122, 275, 60, 25)
	GUICtrlSetFont($lb_senha, 15, 700)
	Global $in_senha = GUICtrlCreateInput("", 50, 305, 200, 30, BitOr($ES_CENTER, $ES_PASSWORD, $ES_AUTOHSCROLL))
	GUICtrlSetFont($in_senha, 15, 700)
	GUICtrlSetBkColor($in_senha, 0xB0C4DE)
	; Botão Fechar
    Global $fechar = GUICtrlCreateButton("Sair", 50, 365, 60, 40, $BS_ICON)
	GUICtrlSetImage($fechar, "icones\Sair.ico", 22)
	; Botão Entrar
	Global $entrar = GUICtrlCreateButton("Entrar", 115, 365, 135, 40, $BS_DEFPUSHBUTTON)
	GUICtrlSetFont($entrar, 12, 700)
	GUICtrlSetBkColor($entrar, 0x5F9EA0)
    ; Display the GUI.
    GUISetState(@SW_SHOW, $tela_login)
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $fechar
                ExitLoop
			Case $entrar
				Global $login = GUICtrlRead($in_login)
				Global $senha = GUICtrlRead($in_senha)
				ler_dados_login()

        EndSwitch
    WEnd
    GUIDelete($tela_login)
EndFunc

Func msg_erro($mensagem)
	Global $msg_erro = GUICtrlCreateLabel($mensagem, 50, 340, 200, -1, $SS_CENTER)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont(-1, 11, 0)
EndFunc