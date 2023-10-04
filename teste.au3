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
; 
#include <SQLite.au3>

Local $hDB, $sDBFile = "seu_arquivo_de_banco_de_dados.sqlite"

; Abre a conexão com o banco de dados
_SQLite_Startup()
$hDB = _SQLite_Open($sDBFile)

If Not $hDB Then
    MsgBox(16, "Erro", "Não foi possível abrir o banco de dados.")
    Exit
EndIf

; Executa a consulta SQL e armazena o resultado em uma variável
Local $sSQL = "SELECT metas.id, metas.porcentagem FROM metas;"
Local $aResult, $iRows, $iCols
If _SQLite_GetTable2d($hDB, $sSQL, $aResult, $iRows, $iCols) = $SQLITE_OK Then
    If $iRows > 0 Then
        ; Itera pelos resultados e insere na tabela "investidos"
        For $i = 0 To $iRows - 1
            Local $id = $aResult[$i][0]
            Local $porcentagem = $aResult[$i][1] * 100

            ; Cria a consulta SQL para inserção de dados na tabela "investidos"
            Local $sInsertSQL = "INSERT INTO investidos (id, porcentagem) VALUES (" & $id & ", " & $porcentagem & ");"
            _SQLite_Exec($hDB, $sInsertSQL)
        Next
        MsgBox($MB_ICONINFORMATION, "Sucesso", "Dados gravados com sucesso na tabela 'investidos'!")
    Else
        ConsoleWrite("Nenhum resultado encontrado." & @CRLF)
    EndIf
Else
    MsgBox(16, "Erro", "Erro ao executar a consulta SQL.")
EndIf

; Fecha a conexão com o banco de dados
_SQLite_Close($hDB)
_SQLite_Shutdown()
