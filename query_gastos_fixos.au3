#include-once
Func exibir_gastos_fixos_grid()
	; Exibir entradas
	Global $tabela_gastos_fixos = GUICtrlCreateListView("ID | VALOR | DESCRIÇÃO ", 20, 20, 460, 400, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS));$LVS_EDITLABELS)

	_GUICtrlListView_SetColumnWidth($tabela_gastos_fixos, 1, 100)
	_GUICtrlListView_SetColumn($tabela_gastos_fixos, 1, "VALOR", -1, 1)
	_GUICtrlListView_SetColumnWidth($tabela_gastos_fixos, 2, 200)

	_GUICtrlListView_SetExtendedListViewStyle($tabela_gastos_fixos, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FLATSB, $LVS_EX_FULLROWSELECT))
	_GUICtrlListView_SetTextBkColor($tabela_gastos_fixos, 0xE0E0E0)
	_GUICtrlListView_SetBkColor($tabela_gastos_fixos, 0xFFFFFF)
	_GUICtrlListView_SetTextColor($tabela_gastos_fixos, 0x000000)

	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	Local $ler_tabela_entradas = _SQLite_GetTableData2D($hDatabase, "SELECT id, valor, descricao FROM gastos_fixos;", $aResult, $iRows, $aNames)

	For $i = 0 To $iRows -1
		GUICtrlCreateListViewItem($aResult[$i][0] & "|" & "R$ " & $aResult[$i][1] & "|" & $aResult[$i][2] & "|", $tabela_gastos_fixos)
	Next

	;Local $somar_total_de_entradas = _SQLite_GetTableData2D($hDatabase, "SELECT SUM(entradas.valor) FROM entradas where substr(data, 4, 2) = '"& @MON &"' AND substr(data, 7, 4) = '"& @YEAR &"';", $aResult, $iRows, $aNames)
	;Local $label_valor_total_entradas = GUICtrlCreateLabel("Total Entradas: " & $aResult[0][0], 160, 470, 200, 20)
	;GUICtrlSetFont(-1, 12, 700)

	desconecta_e_fecha_banco()
EndFunc

Func salvar_edicao_gasto_fixo($valor_id_gf, $valor_descricao_gf, $valor_valor_gf)
EndFunc

Func carregar_gasto_fixo_para_edicao($a)
EndFunc