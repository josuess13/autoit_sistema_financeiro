; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ENTRADAS +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Func adicionar_receita($descricao, $valor, $data, $salario, $observacao = "")
	conecta_e_inicia_banco()
	$valor = StringReplace($valor, ",", ".")
	Local $aResult, $iRows, $aNames
	Local $consultar_usuario_logado = _SQLite_GetTableData2D($hDatabase, "SELECT configuracoes.usuario_logado FROM configuracoes;", $aResult, $iRows, $aNames)
	Local $usuario_logado = $aResult[0][0]
    ; Cria a consulta SQL para inserção de dados
    $sSQL = "INSERT INTO entradas (descricao, valor, data, salario, observacao, adicionado_por) VALUES ('" & $descricao & "', '" & $valor & "', '" & $data & "', '" & $salario & "', '" & $observacao & "', '" & $usuario_logado & "');"
    ; Executa a consulta
    _SQLite_Exec($hDatabase, $sSQL)
    If @error Then
        MsgBox($MB_ICONERROR, "Erro", "Erro ao inserir dados na tabela.")
    Else
        MsgBox($MB_ICONINFORMATION, "Sucesso", "Dados gravados com sucesso!")
    EndIf
    ; Fecha a conexão com o banco de dados
    desconecta_e_fecha_banco()
EndFunc

Func exibir_entradas_grid()
	; Exibir entradas
	Global $tabela_entradas = GUICtrlCreateListView("ID | VALOR | DESCRIÇÃO | DATA  | ADICIONADO POR | OBSERVAÇÃO ", 160, 30, 590, 432, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS));$LVS_EDITLABELS)
	_GUICtrlListView_SetColumnWidth($tabela_entradas, 1, 100)
	_GUICtrlListView_SetColumn($tabela_entradas, 1, "VALOR", -1, 1)
	_GUICtrlListView_SetColumnWidth($tabela_entradas, 2, 200)
	_GUICtrlListView_SetColumnWidth($tabela_entradas, 3, 100)
	_GUICtrlListView_SetColumnWidth($tabela_entradas, 5, 300)

	_GUICtrlListView_SetExtendedListViewStyle($tabela_entradas, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FLATSB, $LVS_EX_FULLROWSELECT))
	_GUICtrlListView_SetTextBkColor($tabela_entradas, 0xE0E0E0)
	_GUICtrlListView_SetBkColor($tabela_entradas, 0xFFFFFF)
	_GUICtrlListView_SetTextColor($tabela_entradas, 0x000000)

	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	Local $ler_tabela_entradas = _SQLite_GetTableData2D($hDatabase, "SELECT id, valor, descricao, data, adicionado_por, observacao FROM entradas where substr(data, 4, 2) = '"& @MON &"' AND substr(data, 7, 4) = '"& @YEAR &"';", $aResult, $iRows, $aNames)

	For $i = 0 To $iRows -1
		GUICtrlCreateListViewItem($aResult[$i][0] & "|" & "R$ " & $aResult[$i][1] & "|" & $aResult[$i][2] & "|" & $aResult[$i][3] & "|" & $aResult[$i][4] & "|" & $aResult[$i][5] & "|", $tabela_entradas)
	Next

	Local $somar_total_de_entradas = _SQLite_GetTableData2D($hDatabase, "SELECT SUM(entradas.valor) FROM entradas where substr(data, 4, 2) = '"& @MON &"' AND substr(data, 7, 4) = '"& @YEAR &"';", $aResult, $iRows, $aNames)
	Local $label_valor_total_entradas = GUICtrlCreateLabel("Total Entradas: " & $aResult[0][0], 160, 470, 200, 20)
	GUICtrlSetFont(-1, 12, 700)

	desconecta_e_fecha_banco()
EndFunc

Func excluir_entrada($index)
	conecta_e_inicia_banco()
	$sSQL = "delete from entradas where id = " & $index
	_SQLite_Exec($hDatabase, $sSQL)
    If @error Then
        MsgBox($MB_ICONERROR, "Erro", "Erro ao excluir entrada.")
    Else
        MsgBox($MB_ICONINFORMATION, "Sucesso", "Entrada excluída com sucesso!")
    EndIf
	desconecta_e_fecha_banco()
EndFunc

Func exibir_entradas_grid_filtrando_datas($inicio, $fim)
	; Exibir entradas
	Global $tabela_entradas = GUICtrlCreateListView("ID | VALOR | DESCRIÇÃO | DATA  | ADICIONADO POR | OBSERVAÇÃO ", 160, 30, 590, 432, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS));$LVS_EDITLABELS)
	_GUICtrlListView_SetColumnWidth($tabela_entradas, 1, 100)
	_GUICtrlListView_SetColumn($tabela_entradas, 1, "VALOR", -1, 1)
	_GUICtrlListView_SetColumnWidth($tabela_entradas, 2, 200)
	_GUICtrlListView_SetColumnWidth($tabela_entradas, 3, 100)
	_GUICtrlListView_SetColumnWidth($tabela_entradas, 5, 300)

	_GUICtrlListView_SetExtendedListViewStyle($tabela_entradas, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FLATSB, $LVS_EX_FULLROWSELECT))
	_GUICtrlListView_SetTextBkColor($tabela_entradas, 0xE0E0E0)
	_GUICtrlListView_SetBkColor($tabela_entradas, 0xFFFFFF)
	_GUICtrlListView_SetTextColor($tabela_entradas, 0x000000)

	; Tratamento para as datas
	Local $data_inicio = StringSplit($inicio, "/")
	Local $dia_inicio = $data_inicio[1], $mes_inicio = $data_inicio[2], $ano_inicio = $data_inicio[3]
	Local $data_fim = StringSplit($fim, "/")
	Local $dia_fim = $data_fim[1], $mes_fim = $data_fim[2], $ano_fim = $data_fim[3]

	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	Local $sql_entrada = "SELECT id, valor, descricao, data, adicionado_por, observacao FROM entradas WHERE substr(data, 7, 4) || '-' || substr(data, 4, 2) || '-' || substr(data, 1, 2)"
	$sql_entrada = $sql_entrada & " BETWEEN '" & $ano_inicio &'-'& $mes_inicio &'-'& $dia_inicio &"' AND '"& $ano_fim &'-'& $mes_fim &'-'& $dia_fim &"';"
	Local $ler_tabela_entradas = _SQLite_GetTableData2D($hDatabase, $sql_entrada, $aResult, $iRows, $aNames)

	For $i = 0 To $iRows -1
		GUICtrlCreateListViewItem($aResult[$i][0] & "|" & "R$ " & $aResult[$i][1] & "|" & $aResult[$i][2] & "|" & $aResult[$i][3] & "|" & $aResult[$i][4] & "|" & $aResult[$i][5] & "|", $tabela_entradas)
	Next

	Local $sql_total = "SELECT SUM(valor) FROM entradas WHERE substr(data, 7, 4) || '-' || substr(data, 4, 2) || '-' || substr(data, 1, 2)"
	$sql_total = $sql_total & " BETWEEN '" & $ano_inicio &'-'& $mes_inicio &'-'& $dia_inicio &"' AND '"& $ano_fim &'-'& $mes_fim &'-'& $dia_fim &"';"
	Local $somar_total_de_entradas = _SQLite_GetTableData2D($hDatabase, $sql_total, $aResult, $iRows, $aNames)
	Local $label_valor_total_entradas = GUICtrlCreateLabel("Total Entradas: " & $aResult[0][0], 160, 470, 200, 20)
	GUICtrlSetFont(-1, 12, 700)

	desconecta_e_fecha_banco()
EndFunc

Func calcula_saldo_entradas()
	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames

	Local $sql_porcentagem = "select (select sum(porcentagem) from metas where desativada is NULL) as p"
	Local $sql_valor_entrada = "select (select sum(valor) from entradas where substr(data, 4, 2) = '" & @MON & "' AND substr(data, 7, 4) = '" & @YEAR & "') as para_gastar"

	$sql_porcentagem = _SQLite_GetTableData2D($hDatabase, $sql_porcentagem, $aResult, $iRows, $aNames)
	$sql_porcentagem = $aResult[0][0] / 100

	$sql_valor_entrada = _SQLite_GetTableData2D($hDatabase, $sql_valor_entrada, $aResult, $iRows, $aNames)
	$sql_valor_entrada = $aResult[0][0] * $sql_porcentagem

	desconecta_e_fecha_banco()
	Return($sql_valor_entrada)
EndFunc