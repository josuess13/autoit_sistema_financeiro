#include-once

Func conecta_e_inicia_banco()
	_SQLite_Startup() ; chama DLL
	If @error Then Exit MsgBox(0, "Erro", "Erro ao iniciar SQLite, por favor, verifique sua DLL")
	; Conecta e abre o banco
	Local $sDatabase = @ScriptDir & '\banco\banco.db'
	$hDatabase = _SQLite_Open($sDatabase)
    If @error Then Exit MsgBox($MB_ICONERROR, "Erro", "Erro ao abrir o banco de dados.")
EndFunc

Func desconecta_e_fecha_banco()
	; Fecha conexão
	_SQLite_Shutdown()
	_SQLite_Close($hDatabase)
EndFunc
; ++++++++++++++++++++++++++++++++++++++++++++++++++ LOGIN +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Func valida_login()
	conecta_e_inicia_banco()

	; Variáveis
	Local $iRows, $hQuery

	; Consultas
	local $consulta_login = "SELECT usuarios.login FROM usuarios where usuarios.login = '" & $login & "';"
	local $consulta_senha = "SELECT usuarios.senha FROM usuarios where usuarios.login = '" & $login & "';"

	; Retorna o nome do usuário caso ele exista no banco
	_SQLite_Query(-1, $consulta_login, $hQuery)
	_SQLite_FetchData($hQuery, $iRows)
	local $usuario_no_db = $iRows[0]
	_SQLite_QueryFinalize($hQuery)

	; Retorna a senha do usuário caso ela exista no banco
	_SQLite_Query(-1, $consulta_senha, $hQuery)
	_SQLite_FetchData($hQuery, $iRows)
	local $senha_no_db = $iRows[0]
	_SQLite_QueryFinalize($hQuery)

	If $login == "" Then
		msg_erro("Preencha o Usuário")
		ControlClick("Login", "", $in_login, "left", 1, 199, 10)
	ElseIf $senha == "" Then
		msg_erro("Preencha a Senha")
		ControlClick("Login", "", $in_senha, "left", 1, 199, 10)
	ElseIf $usuario_no_db <> $login Or $senha_no_db <> $senha Then
		msg_erro("Usuário ou Senha incorretos")
		ControlClick("Login", "", $in_senha, "left", 1, 199, 10)
	Else
		GUIDelete($tela_login)
		usuario_logado($usuario_no_db)
		tela_inicial()
	EndIf
	desconecta_e_fecha_banco()
EndFunc

Func usuario_logado($usuario_logado)
	conecta_e_inicia_banco()
	; Cria a consulta SQL para inserção de dados
    $sSQL = "INSERT OR REPLACE INTO configuracoes (configuracao_id, usuario_logado) VALUES ('1', '" & $usuario_logado & "');"
    ; Executa a consulta
    _SQLite_Exec($hDatabase, $sSQL)
    If @error Then MsgBox($MB_ICONERROR, "Erro", "Erro ao inserir dados na tabela.")
	desconecta_e_fecha_banco()
EndFunc
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
	Local $ler_tabela_saidas = _SQLite_GetTableData2D($hDatabase, "SELECT saidas.valor, saidas.descricao, saidas.data, saidas.adicionado_por, saidas.observacao FROM saidas;", $aResult, $iRows, $aNames)

	For $i = 0 To $iRows -1
		GUICtrlCreateListViewItem("R$ " & $aResult[$i][0] & "|" & $aResult[$i][1] & "|" & $aResult[$i][2] & "|" & $aResult[$i][3] & "|" & $aResult[$i][4] & "|", $tabela)
	Next

	Local $somar_total_de_saidas = _SQLite_GetTableData2D($hDatabase, "SELECT SUM(saidas.valor) FROM saidas;", $aResult, $iRows, $aNames)
	Local $label_valor_total_saidas = GUICtrlCreateLabel("Total: " & $aResult[0][0], 160, 470, 200, 20)
	GUICtrlSetFont(-1, 12, 700)

	desconecta_e_fecha_banco()
EndFunc
 ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ INVESTIMENTOS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Func consultar_entradas_mes()
	Local $aResult, $iRows, $aNames
	conecta_e_inicia_banco()

	Local $entradas_mes = _SQLite_GetTableData2D($hDatabase, "SELECT sum(e.valor) from entradas e where substr(data, 4, 2) = '"& @MON &"' AND substr(data, 7, 4) = '"& @YEAR &"';", $aResult, $iRows, $aNames)
	Local $btn_entradas_mes = GUICtrlCreateLabel("Total: " & $aResult[0][0], 660, 20, 120, 20)
	GUICtrlSetFont(-1, 12, 700)

	desconecta_e_fecha_banco()
	Return $aResult[0][0]
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

	;~ Local $somar_total_de_saidas = _SQLite_GetTableData2D($hDatabase, "SELECT SUM(saidas.valor) FROM saidas;", $aResult, $iRows, $aNames)
	;~ Local $label_valor_total_saidas = GUICtrlCreateLabel("Total: " & $aResult[0][0], 160, 470, 200, 20)
	;~ GUICtrlSetFont(-1, 12, 700)

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