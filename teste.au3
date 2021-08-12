#include <GUIConstants.au3>
$cGUI = GUICreate("  Child GUI Window", 340, 220, -1, -1, -1, $WS_EX_TOOLWINDOW)
$inputbox = GUICtrlCreateInput("Input Box", 10, 70, 120, 20)
$OKc = GUICtrlCreateButton("&OK", 20, 120, 100, 20, $BS_DEFPUSHBUTTON)
GUISetState()

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            Exit
        Case $msg = $OKc
            MsgBox(0, "", "Button fired")
    EndSelect
WEnd