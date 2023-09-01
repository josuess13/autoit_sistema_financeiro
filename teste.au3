#include <GUIConstantsEx.au3>
#include <GUIListView.au3>
#include <WindowsConstants.au3>

Local $hGUI = GUICreate("Personalizando o ListView", 600, 400)

Local $hListView = GUICtrlCreateListView("Nome|Idade", 10, 10, 580, 380)

; Definir estilo e cores personalizadas
_GUICtrlListView_SetExtendedListViewStyle($hListView, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES))

_GUICtrlListView_SetTextBkColor($hListView, 0xE0E0E0)
_GUICtrlListView_SetBkColor($hListView, 0xFFFFFF)
_GUICtrlListView_SetTextColor($hListView, 0x000000)

; Adicionar colunas e itens
_GUICtrlListView_AddColumn($hListView, "Nome", 250)
_GUICtrlListView_AddColumn($hListView, "Idade", 100)

_GUICtrlListView_AddItem($hListView, "João|25")
_GUICtrlListView_AddItem($hListView, "Maria|30")

GUISetState(@SW_SHOW)

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
WEnd
