#include <MsgBoxConstants.au3>

; Defina a tecla de atalho
HotKeySet("{F1}", "MinhaFuncao")

While 1
    ; Aguarde eventos
    Sleep(100)
WEnd

Func MinhaFuncao()
    MsgBox(0, "", 'a')
    $hotkey
    ; Desative a tecla de atalho após ser chamada
    HotKeySet("{F1}")
EndFunc