; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ SAÍDAS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Func adicionar_despesa($descricao, $valor, $data, $fixo, $observacao = "")
	conecta_e_inicia_banco()
	$valor = StringReplace($valor, ",", ".")
	Local $aResult, $iRows, $aNames
	Local $consultar_usuario_logado = _SQLite_GetTableData2D($hDatabase, "SELECT configuracoes.usuario_logado FROM configuracoes;", $aResult, $iRows, $aNames)
	Local $usuario_logado = $aResult[0][0]
    ; Cria a consulta SQL para inserção de dados
    $sSQL = "INSERT INTO saidas (descricao, valor, data, fixo, observacao, adicionado_por) VALUES ('" & $descricao & "', '" & $valor & "', '" & $data & "', '" & $fixo & "', '" & $observacao & "', '" & $usuario_logado & "');"
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

Func exibir_saidas_grid()
	; Exibir saidas
	Global $tabela_saida = GUICtrlCreateListView("ID | VALOR | DESCRIÇÃO | DATA  | ADICIONADO POR | OBSERVAÇÃO ", 160, 30, 590, 432, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS));$LVS_EDITLABELS)
	_GUICtrlListView_SetColumnWidth($tabela_saida, 1, 100)
	_GUICtrlListView_SetColumn($tabela_saida, 1, "VALOR", -1, 1)
	_GUICtrlListView_SetColumnWidth($tabela_saida, 2, 200)
	_GUICtrlListView_SetColumnWidth($tabela_saida, 3, 100)
	_GUICtrlListView_SetColumnWidth($tabela_saida, 5, 300)

	_GUICtrlListView_SetExtendedListViewStyle($tabela_saida, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FLATSB, $LVS_EX_FULLROWSELECT))
	_GUICtrlListView_SetTextBkColor($tabela_saida, 0xE0E0E0)
	_GUICtrlListView_SetBkColor($tabela_saida, 0xFFFFFF)
	_GUICtrlListView_SetTextColor($tabela_saida, 0x000000)

	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	Local $ler_tabela_saidas = _SQLite_GetTableData2D($hDatabase, "SELECT id, valor, descricao, data, adicionado_por, observacao FROM saidas where substr(data, 4, 2) = '"& @MON &"' AND substr(data, 7, 4) = '"& @YEAR &"';", $aResult, $iRows, $aNames)

	For $i = 0 To $iRows -1
		GUICtrlCreateListViewItem($aResult[$i][0] & "|" & "R$ " & $aResult[$i][1] & "|" & $aResult[$i][2] & "|" & $aResult[$i][3] & "|" & $aResult[$i][4] & "|" & $aResult[$i][5] & "|", $tabela_saida)
	Next
	desconecta_e_fecha_banco()
EndFunc

Func excluir_saida($index)
	conecta_e_inicia_banco()
	$sSQL = "delete from saidas where id = " & $index
	_SQLite_Exec($hDatabase, $sSQL)
    If @error Then
        MsgBox($MB_ICONERROR, "Erro", "Erro ao excluir gasto.")
    Else
        MsgBox($MB_ICONINFORMATION, "Sucesso", "Gasto excluido com sucesso!")
    EndIf
	desconecta_e_fecha_banco()
EndFunc

Func exibir_saidas_grid_filtrando_datas($inicio, $fim)
	; Exibir saidas
	Global $tabela_saida = GUICtrlCreateListView("ID | VALOR | DESCRIÇÃO | DATA  | ADICIONADO POR | OBSERVAÇÃO ", 160, 30, 590, 432, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS));$LVS_EDITLABELS)
	_GUICtrlListView_SetColumnWidth($tabela_saida, 1, 100)
	_GUICtrlListView_SetColumn($tabela_saida, 1, "VALOR", -1, 1)
	_GUICtrlListView_SetColumnWidth($tabela_saida, 2, 200)
	_GUICtrlListView_SetColumnWidth($tabela_saida, 3, 100)
	_GUICtrlListView_SetColumnWidth($tabela_saida, 5, 300)

	_GUICtrlListView_SetExtendedListViewStyle($tabela_saida, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FLATSB, $LVS_EX_FULLROWSELECT))
	_GUICtrlListView_SetTextBkColor($tabela_saida, 0xE0E0E0)
	_GUICtrlListView_SetBkColor($tabela_saida, 0xFFFFFF)
	_GUICtrlListView_SetTextColor($tabela_saida, 0x000000)
	; Tratamento para as datas
	Local $data_inicio = StringSplit($inicio, "/")
	Local $dia_inicio = $data_inicio[1], $mes_inicio = $data_inicio[2], $ano_inicio = $data_inicio[3]
	Local $data_fim = StringSplit($fim, "/")
	Local $dia_fim = $data_fim[1], $mes_fim = $data_fim[2], $ano_fim = $data_fim[3]

	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	Local $consulta = "select id, valor, descricao, data, adicionado_por, observacao FROM saidas WHERE substr(data, 7, 4) || '-' || substr(data, 4, 2) || '-' || substr(data, 1, 2)"
	$consulta = $consulta & " BETWEEN '" & $ano_inicio &'-'& $mes_inicio &'-'& $dia_inicio &"' AND '"& $ano_fim &'-'& $mes_fim &'-'& $dia_fim &"';"

	Local $ler_tabela_saidas = _SQLite_GetTableData2D($hDatabase, $consulta, $aResult, $iRows, $aNames)

	For $i = 0 To $iRows -1
		GUICtrlCreateListViewItem($aResult[$i][0] & "|" & "R$ " & $aResult[$i][1] & "|" & $aResult[$i][2] & "|" & $aResult[$i][3] & "|" & $aResult[$i][4] & "|" & $aResult[$i][5] & "|", $tabela_saida)
	Next

	$consulta = "SELECT SUM(saidas.valor) FROM saidas WHERE substr(data, 7, 4) || '-' || substr(data, 4, 2) || '-' || substr(data, 1, 2)"
	$consulta = $consulta & " BETWEEN '" & $ano_inicio &'-'& $mes_inicio &'-'& $dia_inicio &"' AND '"& $ano_fim &'-'& $mes_fim &'-'& $dia_fim &"';"
	Local $somar_total_de_saidas = _SQLite_GetTableData2D($hDatabase, $consulta, $aResult, $iRows, $aNames)
	Local $label_valor_total_saidas = GUICtrlCreateLabel("Total: " & $aResult[0][0], 160, 470, 200, 20)
	GUICtrlSetFont(-1, 12, 700)

	desconecta_e_fecha_banco()
EndFunc

Func calcula_saldo_saidas()
	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames

	Local $somar_total_de_saidas = _SQLite_GetTableData2D($hDatabase, "SELECT SUM(saidas.valor) FROM saidas where substr(data, 4, 2) = '"& @MON &"' AND substr(data, 7, 4) = '"& @YEAR &"';", $aResult, $iRows, $aNames)
	Local $retorno[2]
	$retorno[0] = $aResult[0][0]
	
	Local $sql = "select (1 - ((select sum(porcentagem) from metas where desativada is NULL) / 100)) * "
	$sql = $sql & "(select sum(valor) from entradas where substr(data, 4, 2) = '" & @MON & "' AND substr(data, 7, 4) = '" & @YEAR & "') as para_gastar" 
	Local $para_gastar = _SQLite_GetTableData2D($hDatabase, $sql, $aResult, $iRows, $aNames)
	$retorno[1] = $aResult[0][0]
	desconecta_e_fecha_banco()
	Return($retorno)
EndFunc
