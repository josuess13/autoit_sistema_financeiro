#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>

Opt("GUIOnEventMode", 1)

Local $hGUI = GUICreate("Mover Foco ao Pressionar Enter", 300, 150)

Local $input1 = GUICtrlCreateInput("", 50, 30, 200, 24)
Local $input2 = GUICtrlCreateInput("", 50, 70, 200, 24)

GUISetState()

GUIRegisterMsg($WM_COMMAND, '_WM_COMMAND')
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

While 1
    Sleep(10)
WEnd

Func _WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
    Local $id = BitAND($wParam, 0x0000FFFF)
    Local $code = BitShift($wParam, 16)
    If $id = $input1 And $code = $EN_CHANGE Then
        ControlFocus($hGUI, "", $input2)
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc

Func _Exit()
    Exit
EndFunc
