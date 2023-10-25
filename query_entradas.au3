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
	Local $tabela = GUICtrlCreateListView(" VALOR | DESCRIÇÃO | DATA  | ADICIONADO POR | OBSERVAÇÃO ", 160, 30, 590, 432, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS));$LVS_EDITLABELS)
	_GUICtrlListView_SetColumnWidth($tabela, 0, 100)
	_GUICtrlListView_SetColumn($tabela, 0, "VALOR", -1, 1)
	_GUICtrlListView_SetColumnWidth($tabela, 1, 200)
	_GUICtrlListView_SetColumnWidth($tabela, 2, 100)
	_GUICtrlListView_SetColumnWidth($tabela, 4, 300)

	_GUICtrlListView_SetExtendedListViewStyle($tabela, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FLATSB, $LVS_EX_FULLROWSELECT))
	_GUICtrlListView_SetTextBkColor($tabela, 0xE0E0E0)
	_GUICtrlListView_SetBkColor($tabela, 0xFFFFFF)
	_GUICtrlListView_SetTextColor($tabela, 0x000000)

	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	Local $ler_tabela_entradas = _SQLite_GetTableData2D($hDatabase, "SELECT entradas.valor, entradas.descricao, entradas.data, entradas.adicionado_por, entradas.observacao FROM entradas;", $aResult, $iRows, $aNames)

	For $i = 0 To $iRows -1
		GUICtrlCreateListViewItem("R$ " & $aResult[$i][0] & "|" & $aResult[$i][1] & "|" & $aResult[$i][2] & "|" & $aResult[$i][3] & "|" & $aResult[$i][4] & "|", $tabela)
	Next

	Local $somar_total_de_entradas = _SQLite_GetTableData2D($hDatabase, "SELECT SUM(entradas.valor) FROM entradas;", $aResult, $iRows, $aNames)
	Local $label_valor_total_entradas = GUICtrlCreateLabel("Total: " & $aResult[0][0], 160, 470, 200, 20)
	GUICtrlSetFont(-1, 12, 700)

	desconecta_e_fecha_banco()
EndFunc