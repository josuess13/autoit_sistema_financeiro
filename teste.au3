#include <GUIConstants.au3>

Global $hMain = GUICreate("Example", 600, 400, -1, -1, BitOR($WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_SIZEBOX))
Global $btnFullScreen = GUICtrlCreateButton("Fullscreen", 10, 10, 100, 20)
Global $aGuiStyle = GUIGetStyle($hMain) ; Save the default styles

GUISetState(@SW_SHOW, $hMain)

While (True)
    Switch (GUIGetMsg())
        Case $GUI_EVENT_CLOSE
            Exit 0
        Case $btnFullScreen
            Fullscreen()
    EndSwitch
WEnd

Func Fullscreen()
    Local Static $bFullScreen = False

    $bFullScreen = Not $bFullScreen

    Switch ($bFullScreen)
        Case True
            GUISetStyle($WS_POPUP, -1, $hMain)
            WinMove($hMain, "", 0, 0, @DesktopWidth, @DesktopHeight)
        Case False
            GUISetStyle($aGuiStyle[0], -1, $hMain)
            WinMove($hMain, "", 0, 0, 600, 400)
    EndSwitch
EndFunc
