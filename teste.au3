#include <GUIConstantsEx.au3>
#include <GuiListView.au3>

Global $hGUI, $hListView, $hButton

$hGUI = GUICreate("Exemplo de Grid com Botão", 400, 300)

global $hListView = GUICtrlCreateListView("Itens", 10, 10, 380, 200)
_GUICtrlListView_AddItem($hListView, "Item 1")
_GUICtrlListView_AddItem($hListView, "Item 2")
_GUICtrlListView_AddItem($hListView, "Item 3")

$hButton = GUICtrlCreateButton("Mostrar Mensagem", 150, 230, 120, 30)
GUICtrlSetOnEvent($hButton, "MostrarMensagem")

GUISetState(@SW_SHOW)

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit
		Case $hButton
			MostrarMensagem()
    EndSwitch
WEnd

Func MostrarMensagem()
    Local $Index = _GUICtrlListView_GetSelectedIndices($hListView)
	$Index = $Index * 1

    If $Index == "" Then
        MsgBox(16, "Nenhum item selecionado", "Por favor, selecione um item na lista.")
        Return
    EndIf

    Local $ItemText = _GUICtrlListView_GetItemText($hListView, $Index)
    MsgBox(64, "Item Selecionado", $ItemText & " selecionado.")
EndFunc