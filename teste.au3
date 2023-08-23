; Não deixa digitar certos caracteres
;~ #include <GUIConstantsEx.au3>
;~ #include <WindowsConstants.au3>
;~ #include <EditConstants.au3>

;~ Opt("GUIOnEventMode", 1)

;~ $hGUI = GUICreate("Test", 232, 90)
;~ $Label = GUICtrlCreateLabel("Enter MAC address", 22, 8, 163, 17)
;~ $input = GUICtrlCreateInput("", 22, 30, 165, 24)
;~ GUICtrlSetLimit(-1, 17)
;~ GUICtrlSetFont(-1, 12)
;~ GUISetState()

;~ GUIRegisterMsg($WM_COMMAND, '_WM_COMMAND')
;~ GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

;~ While 1
;~   Sleep(10)
;~ WEnd

;~ Func _WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
;~  Local $id = BitAND($wParam, 0x0000FFFF)
;~  Local $code = BitShift($wParam, 16)
;~    If $id = $input AND $code = $EN_UPDATE Then
;~        Local $content = GUICtrlRead($input)
;~        Local $len = StringLen($content)
;~        Local $char = StringRight($content, 1)
;~        Local $mod = Mod($len, 3)
;~        If not (( ($mod = 1 or $mod = 2) and StringRegExp($char, '[[:xdigit:]]') ) OR _ 
;~            ($mod = 0 and $char = "-")) Then GUICtrlSetData($input, StringTrimRight($content, 1)) 
;~     EndIf
;~     Return $GUI_RUNDEFMSG
;~ EndFunc

;~ Func _Exit()
;~     Exit
;~ EndFunc