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
#include <MsgBoxConstants.au3>
#include <entradas.au3>
#include <saidas.au3>
;tela_inicial()

Func tela_inicial()
    ; tela principal 
    Global $tela_inicial = GUICreate("Seu Financeiro", 900, 600)
    GUISetIcon("icones\money.ico")
    GUISetState()
    ; Menu movimentos
    Global $m_movimentos = GUICtrlCreateMenu("Movimentos")
    GUICtrlSetState($m_movimentos, $GUI_DEFBUTTON)
    Global $m_movimentos_entradas = GUICtrlCreateMenuItem("Receitas", $m_movimentos)
    Global $m_movimentos_saidas = GUICtrlCreateMenuItem("Despesas", $m_movimentos)
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $m_movimentos_entradas
                GUISetState(@SW_DISABLE, $tela_inicial)
                entradas()
                GUISetState(@SW_ENABLE, $tela_inicial)
                WinActivate($tela_inicial)
            Case $m_movimentos_saidas
                GUISetState(@SW_DISABLE, $tela_inicial)
                saidas()
                GUISetState(@SW_ENABLE, $tela_inicial)
                WinActivate($tela_inicial)
        EndSwitch
    WEnd
    GUIDelete($tela_inicial)
    Exit

EndFunc