# AutoIt3Wrapper_UseX64 = Y
#include <Array.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <ColorConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstants.au3>

Func tela_inicial()
    Global $tela_inicial = GUICreate("Program", 250, 300)
    GUISetStyle($WS_POPUP, -1, $tela_inicial)
    WinMove($tela_inicial, "", 0, 0, @DesktopWidth, @DesktopHeight)
    GUISetState(@SW_SHOW, $tela_inicial)
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
        EndSwitch
    WEnd
    GUIDelete($tela_inicial)

EndFunc