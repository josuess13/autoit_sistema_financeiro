# AutoIt3Wrapper_UseX64 = Y
#include <Array.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <ColorConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <programa.au3>
#include <GUIConstants.au3>
#include <MsgBoxConstants.au3>
Global $msg_erro

login()

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
				ler_dados()

        EndSwitch
    WEnd
    GUIDelete($tela_login)
EndFunc

Func ler_dados()
	_SQLite_Startup() ; chama DLL
	If @error Then Exit MsgBox(0, "Erro", "Erro ao iniciar SQLite, por favor, verifique sua DLL")
	; Conecta e abre o banco
	Local $sDatabase = @ScriptDir & '\banco\banco.db'
	Local $hDatabase = _SQLite_Open($sDatabase)
	; Variáveis
	Local $iRows, $iColumns, $hQuery, $sMsg
	; Busca pelo Login
	local $consulta_nome = "SELECT usuarios.login FROM usuarios where usuarios.login = '" & $login & "';"
	_SQLite_Query(-1, $consulta_nome, $hQuery)
	_SQLite_FetchData($hQuery, $iRows)
	local $db_login = $iRows[0]
	_SQLite_QueryFinalize($hQuery)
	If $db_login == "" Then
		msg_erro("Usuário ou Senha incorretos")
		ControlClick("Login", "", $in_login, "left", 1, 199, 10)
	Else
		GUICtrlDelete($msg_erro)
		; Busca pela senha
		local $consulta_senha = "SELECT usuarios.senha FROM usuarios where usuarios.login = '" & $login & "';"
		_SQLite_Query(-1, $consulta_senha, $hQuery)
		_SQLite_FetchData($hQuery, $iRows)
		local $db_senha = $iRows[0]
		_SQLite_QueryFinalize($hQuery)
		If $db_senha <> $senha Then
			If $senha <> "" Then msg_erro("Usuário ou Senha incorretos")
			ControlClick("Login", "", $in_senha, "left", 1, 199, 10)
		Else
			GUIDelete($tela_login)
			tela_inicial()
		EndIf
	EndIf

	; Fecha conexão
	_SQLite_Close($hDatabase)
	_SQLite_Shutdown()

EndFunc

Func msg_erro($mensagem)
	Global $msg_erro = GUICtrlCreateLabel($mensagem, 50, 340, 200, -1, $SS_CENTER)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont(-1, 11, 0)
EndFunc


