; Não deixa digitar certos caracteres
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>

Opt("GUIOnEventMode", 1)

$hGUI = GUICreate("Test", 232, 90)
$Label = GUICtrlCreateLabel("Enter MAC address", 22, 8, 163, 17)
$input = GUICtrlCreateInput("", 22, 30, 165, 24)
GUICtrlSetFont(-1, 12)
GUISetState()

GUIRegisterMsg($WM_COMMAND, 'valida_caracteres_valor')
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

While 1
    Sleep(10)
WEnd

Func valida_caracteres_valor($hWnd, $Msg, $wParam, $lParam)
    Local $id = BitAND($wParam, 0x0000FFFF)
    Local $code = BitShift($wParam, 16)
    
    If $id = $input AND $code = $EN_UPDATE Then
        Local $content = GUICtrlRead($input)
        Local $len = StringLen($content)
        Local $char = StringRight($content, 1)
        Local $mod = Mod($len, 3)
        
        ; Verificar se o caractere atual é válido para o formato MAC
        If not (( ($mod = 1 or $mod = 2) and StringRegExp($char, '^[0-9,]*$') ) OR _ 
            ($mod = 0 and $char = "-")) Then
            GUICtrlSetData($input, StringTrimRight($content, 1))
        EndIf
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc

Func _Exit()
    Exit
EndFunc

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>

Global $hGUI, $inputNumerosVirgula

Example()

Func Example()
    $hGUI = GUICreate("Números e Vírgula", 300, 200)

    Local $inputNumerosVirgula = GUICtrlCreateInput("", 50, 50, 200, 24)
	local $botao = GUICtrlCreateButton("X", 10, 10, 30, 30)

    GUISetState(@SW_SHOW)

	GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND")

    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                Exit
            Case $inputNumerosVirgula
                Local $content = GUICtrlRead($inputNumerosVirgula)
                If Not StringRegExp($content, '^[0-9,]*$') Then
                    GUICtrlSetData($inputNumerosVirgula, StringRegExpReplace($content, '[^0-9,]*', ""))
                EndIf
        EndSwitch
    WEnd
EndFunc

Func _WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
    Local $iCode = BitShift($iwParam, 16)
    Local $iIDFrom = BitAND($iwParam, 0xFFFF)

    If $iIDFrom = $inputNumerosVirgula And $iCode = $EN_SETFOCUS Then
        ConsoleWrite("Input selecionado" & @CRLF)
    EndIf

    Return $GUI_RUNDEFMSG
EndFunc
