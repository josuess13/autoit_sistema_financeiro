; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ INVESTIMENTOS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Func consultar_entradas_mes()
	Local $aResult, $iRows, $aNames
	conecta_e_inicia_banco()

	; Validação caso metas ultrapassem 100%
	Local $porcentagem_total = _SQLite_GetTableData2D($hDatabase, "select sum(porcentagem) from metas where desativada is NULL;", $aResult, $iRows, $aNames)
	Local $percentual = $aResult[0][0]
	Local $porcentagem_p_investir = $percentual / 100
	If $percentual > 100 Then
		Local $lb_porcentagem_metas = GUICtrlCreateLabel("Soma da porcentagem das metas acima de 100%, revise os valores!!", 170, 10, 390, 20)
		GUICtrlSetColor(-1, 0xFF0000)
		GUICtrlSetFont(-1, 9, 700)
	EndIf
	; Entradas no mês
	Local $entradas_mes = _SQLite_GetTableData2D($hDatabase, "SELECT sum(e.valor) from entradas e where substr(data, 4, 2) = '"& @MON &"' AND substr(data, 7, 4) = '"& @YEAR &"';", $aResult, $iRows, $aNames)
	$entradas_mes = $aResult[0][0]
	Local $lb_entradas_mes = GUICtrlCreateLabel("Entradas no Mês: R$ " & $entradas_mes, 560, 30, 220, 60)
	GUICtrlSetFont(-1, 12, 700)
	; Total para investir
	Local $lb_total_p_investir = GUICtrlCreateLabel("Total p/ Investir: R$ " & $entradas_mes * $porcentagem_p_investir, 560, 50, 220, 60)
	GUICtrlSetFont(-1, 12, 700)
	; Valor investido
	Local $investido = _SQLite_GetTableData2D($hDatabase, "select sum(valor) from investidos where data = " & @MON & @YEAR, $aResult, $iRows, $aNames)
	$investido = $aResult[0][0]
	Local $lb_percentual_investido = GUICtrlCreateLabel("Total investido: R$" & $investido, 560, 70, 220, 60)
	GUICtrlSetFont(-1, 12, 700)
	If $investido <> $entradas_mes * $porcentagem_p_investir Then
		GUICtrlSetColor(-1, 0xFF0000)
	EndIf
	; Percentual investido
	Local $lb_percentual_investido = GUICtrlCreateLabel("Percentual investido: " & $percentual & "%", 560, 90, 220, 60)
	GUICtrlSetFont(-1, 12, 700)
	; Botões XXX
	; Entradas Ano
	Local $entradas_ano = _SQLite_GetTableData2D($hDatabase, "select sum(valor) from entradas WHERE SUBSTR(data, -4) = '" & @YEAR & "'", $aResult, $iRows, $aNames)
	$entradas_ano = $aResult[0][0]
	GUICtrlCreateLabel("Entradas Ano: R$" & $entradas_ano, 560, 340, 220, 60)
	GUICtrlSetFont(-1, 12, 700)
	; Investido Ano
	Local $investido_ano = _SQLite_GetTableData2D($hDatabase, "select sum(valor) from investidos WHERE SUBSTR(data, -4) = '" & @YEAR & "'", $aResult, $iRows, $aNames)
	$investido_ano = $aResult[0][0]
	GUICtrlCreateLabel("Investido no Ano: R$" & $investido_ano, 560, 360, 220, 60)
	GUICtrlSetFont(-1, 12, 700)
	; Entradas Total
	Local $entradas_total = _SQLite_GetTableData2D($hDatabase, "select sum(valor) from entradas;", $aResult, $iRows, $aNames)
	$entradas_total = $aResult[0][0]
	GUICtrlCreateLabel("Entradas Total: R$" & $entradas_total, 560, 400, 220, 60)
	GUICtrlSetFont(-1, 12, 700)
	; Investido total
	Local $investidos_total = _SQLite_GetTableData2D($hDatabase, "select sum(valor) from investidos;", $aResult, $iRows, $aNames)
	$investidos_total = $aResult[0][0]
	GUICtrlCreateLabel("Investidos Total: R$" & $investidos_total, 560, 420, 220, 60)
	GUICtrlSetFont(-1, 12, 700)

	desconecta_e_fecha_banco()
	Return $entradas_mes
EndFunc

Func adicionar_meta($nome, $porcentagem)
	conecta_e_inicia_banco()
	$porcentagem = StringReplace($porcentagem, ",", ".")
	Local $aResult, $iRows, $aNames

    ; Cria a consulta SQL para inserção de dados
    $sSQL = "INSERT INTO metas (nome, porcentagem) VALUES ('" & $nome & "', '" & $porcentagem & "');"
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

Func exibir_metas_grid()
	Local $entradas_mes = consultar_entradas_mes()
	; Exibir metas
	Global $tabela_metas = GUICtrlCreateListView("ID | META | % | VALOR DO MÊS ", 170, 30, 380, 432, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS))
	_GUICtrlListView_SetColumnWidth($tabela_metas, 0, 40)
	_GUICtrlListView_SetColumnWidth($tabela_metas, 1, 180)
	_GUICtrlListView_SetColumnWidth($tabela_metas, 2, 50)
	_GUICtrlListView_SetColumnWidth($tabela_metas, 3, 100)

	_GUICtrlListView_SetExtendedListViewStyle($tabela_metas, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FLATSB, $LVS_EX_FULLROWSELECT))
	_GUICtrlListView_SetTextBkColor($tabela_metas, 0xE0E0E0)
	_GUICtrlListView_SetBkColor($tabela_metas, 0xFFFFFF)
	_GUICtrlListView_SetTextColor($tabela_metas, 0x000000)

	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	Local $ler_tabela_metas = _SQLite_GetTableData2D($hDatabase, "SELECT metas.id, metas.nome, metas.porcentagem FROM metas where metas.desativada is null;", $aResult, $iRows, $aNames)

	For $i = 0 To $iRows -1
		GUICtrlCreateListViewItem($aResult[$i][0] & "|" & $aResult[$i][1] & "|" & $aResult[$i][2] & "|" & "R$ " & $entradas_mes*($aResult[$i][2]/100) & "|", $tabela_metas)
	Next
	desconecta_e_fecha_banco()
EndFunc

Func gravar_investimentos()
	Local $entradas_mes = consultar_entradas_mes()
	conecta_e_inicia_banco()

	Local $sSQL = "SELECT metas.id, metas.porcentagem FROM metas where metas.desativada is null;"
	Local $aResult, $iRows, $iCols
	Local $aResult1, $iRows1, $iCols1
	If _SQLite_GetTable2d($hDatabase, $sSQL, $aResult, $iRows, $iCols) = $SQLITE_OK Then
		If $iRows > 0 Then
			; Itera pelos resultados
			For $i = 1 To $iRows
				Local $valor = $entradas_mes * ($aResult[$i][1]/100)
				Local $data = @MON & @YEAR
				Local $meta_id = $aResult[$i][0]
				Local $sSQLExists = "SELECT count(*)  FROM investidos WHERE data = "& $data &" AND meta_id = "& $meta_id &";"
				_SQLite_GetTable2d($hDatabase, $sSQLExists, $aResult1, $iRows1, $iCols1)
				Local $existe =  $aResult1[1][0]
				If $existe == 0 Then
					$sSQL = "INSERT INTO investidos (valor, data, meta_id) VALUES ('" & $valor & "', '" & $data & "', '" & $meta_id & "');"
				Else
					$sSQL = "UPDATE investidos SET valor = " & $valor & " WHERE data = " & $data & " AND meta_id = " & $meta_id & ";"
				EndIf
				_SQLite_Exec($hDatabase, $sSQL)
			Next
		EndIf
	EndIf
	If @error Then
        MsgBox($MB_ICONERROR, "Erro", "Erro ao inserir dados na tabela.")
    Else
        MsgBox($MB_ICONINFORMATION, "Sucesso", "Dados gravados com sucesso!")
    EndIf

    ; Fecha a conexão com o banco de dados
    desconecta_e_fecha_banco()
EndFunc

Func carregar_meta_para_edicao($meta_id)
	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	Local $ler_tabela_metas = _SQLite_GetTableData2D($hDatabase, "SELECT metas.id, metas.nome, metas.porcentagem FROM metas where metas.id = " & $meta_id & ";", $aResult, $iRows, $aNames)

	Local $resultado = [$aResult[0][0] , $aResult[0][1] , $aResult[0][2]]
	desconecta_e_fecha_banco()
	Return($resultado)
EndFunc

Func salvar_edicao_meta($id, $nome, $porcentagem)
	conecta_e_inicia_banco()
	$porcentagem = StringReplace($porcentagem, ",", ".")
	Local $aResult, $iRows, $aNames

    ; Cria a consulta SQL para inserção de dados
    $sSQL = "UPDATE metas SET nome = '" & $nome & "', porcentagem = '" & $porcentagem & "' WHERE id = " & $id & ";"
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

Func desativar_meta($id)
	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	$sSQL = "UPDATE metas SET desativada = -1 WHERE id = " & $id & ";"
	_SQLite_Exec($hDatabase, $sSQL)
	If @error Then
        MsgBox($MB_ICONERROR, "Erro", "Erro ao Excluir Meta.")
    Else
        MsgBox($MB_ICONINFORMATION, "Sucesso", "Meta Excluída com sucesso!")
    EndIf
	desconecta_e_fecha_banco()
EndFunc

Func excluir_investidos()
	conecta_e_inicia_banco()
	Local $escolha = MsgBox(36, "Aviso!", "Deseja excluir os investimentos feitos no mês?")
	If $escolha == $IDYES Then 
		$sSQL = 'DELETE FROM investidos WHERE data ="' & @MON & @YEAR & '";'
		;~ ConsoleWrite($sSQL)
		;~ MsgBox(0, "", $sSQL)
		_SQLite_Exec($hDatabase, $sSQL)
		If @error Then
			MsgBox($MB_ICONERROR, "Erro", "Erro ao Excluir investidos.")
		Else
			MsgBox($MB_ICONINFORMATION, "Sucesso", "Investidos Excluídos com sucesso!")
		EndIf
	EndIf
	desconecta_e_fecha_banco()
EndFunc