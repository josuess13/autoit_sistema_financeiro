#include <Array.au3>

Local $sData = "30/01/2023"
Local $aSplit = StringSplit($sData, "/")

If $aSplit[0] >= 2 Then
    Local $sDia = $aSplit[3]
    ConsoleWrite("Dia: " & $sDia & @CRLF)
Else
    ConsoleWrite("Data não está no formato esperado." & @CRLF)
EndIf