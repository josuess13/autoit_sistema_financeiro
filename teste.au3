#include <GUIConstants.au3>

;Const $WM_SYSCOMMAND = 0x0112
;Const $SC_MOVE = 0xF010

$gui = GUICreate("", 300, 200)
GUISetState(@SW_SHOW)
GUIRegisterMsg(0x0112, "On_WM_SYSCOMMAND")

While GUIGetMsg() <> $GUI_EVENT_CLOSE
WEnd

Func On_WM_SYSCOMMAND($hWnd, $Msg, $wParam, $lParam)
    If BitAND($wParam, 0xFFF0) = 0xF010 Then Return
EndFunc