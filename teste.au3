#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StringConstants.au3>

Example()

Func Example()
    Local $hGUI = GUICreate("Valor Formatado", 300, 200)

    Local $inputValor = GUICtrlCreateInput("", 50, 50, 200, 24)
    Local $buttonFormatar = GUICtrlCreateButton("Formatar", 100, 100, 100, 30)

    GUISetState(@SW_SHOW)

    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                Exit
            Case $buttonFormatar
                Local $valor = GUICtrlRead($inputValor)
                ;Local $formattedValor = StringFormat("R$ %.2f", $valor)
				Local $formattedValor = StringFormat("$%'d.%02d", $valor / 100, Mod($valor, 100))
				MsgBox(0, 0, $formattedValor)
            EndSwitch
    WEnd
EndFunc