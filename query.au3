#include-once

Func conecta_e_inicia_banco()
	_SQLite_Startup() ; chama DLL
	If @error Then Exit MsgBox(0, "Erro", "Erro ao iniciar SQLite, por favor, verifique sua DLL")
	; Conecta e abre o banco
	Local $sDatabase = @ScriptDir & '\banco\banco.db'
	Global $hDatabase = _SQLite_Open($sDatabase)
    If @error Then Exit MsgBox($MB_ICONERROR, "Erro", "Erro ao abrir o banco de dados.")
EndFunc

Func desconecta_e_fecha_banco()
	; Fecha conexão
	_SQLite_Close($hDatabase)
	_SQLite_Shutdown()
EndFunc

Func ler_dados_login()
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

	If $usuario_no_db <> $login Or $senha_no_db <> $senha Then
		msg_erro("Usuário ou Senha incorretos")
		ControlClick("Login", "", $in_login, "left", 1, 199, 10)
	Else
		GUIDelete($tela_login)
		tela_inicial()
	EndIf

	;~ $sSQL = "INSERT INTO " & $sTableName & " (descricao, valor, data, salario, observacao) VALUES ('" & $aNewData[0] & "', '" & $aNewData[1] & "', '" & $aNewData[2] & "', '" & $aNewData[3] & "', '" & $aNewData[4] & "');"
    ;~ ; Executa a consulta
    ;~ _SQLite_Exec($hDatabase, $sSQL)

	desconecta_e_fecha_banco()
EndFunc

Func adicionar_receita($descricao, $valor, $data, $salario, $observacao = "")
	conecta_e_inicia_banco()
    Local $sTableName = "entradas"
	$valor = StringReplace($valor, ",", ".")
    Local $aNewData = [$descricao, $valor, $data, $salario, $observacao]

    ; Cria a consulta SQL para inserção de dados
    $sSQL = "INSERT INTO " & $sTableName & " (descricao, valor, data, salario, observacao) VALUES ('" & $aNewData[0] & "', '" & $aNewData[1] & "', '" & $aNewData[2] & "', '" & $aNewData[3] & "', '" & $aNewData[4] & "');"
    ; Executa a consulta
    _SQLite_Exec($hDatabase, $sSQL)
    If @error Then
        MsgBox($MB_ICONERROR, "Erro", "Erro ao inserir dados na tabela.")
    Else
        MsgBox($MB_ICONINFORMATION, "Sucesso", "Dados inseridos na tabela com sucesso!")
    EndIf
    ; Fecha a conexão com o banco de dados
    desconecta_e_fecha_banco()
EndFunc

Func exibir_entradas_grid()
	; Exibir entradas
	Local $tabela = GUICtrlCreateListView(" VALOR | DESCRIÇÃO | DATA ", 160, 30, 590, 432, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS));$LVS_EDITLABELS)
	_GUICtrlListView_SetColumnWidth($tabela, 0, 100)
	_GUICtrlListView_SetColumn($tabela, 0, "VALOR", -1, 1)
	_GUICtrlListView_SetColumnWidth($tabela, 1, 385)
	_GUICtrlListView_SetColumnWidth($tabela, 2, 100)

	_GUICtrlListView_SetExtendedListViewStyle($tabela, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FLATSB, $LVS_EX_HEADERDRAGDROP ))
	_GUICtrlListView_SetTextBkColor($tabela, 0xE0E0E0)
	_GUICtrlListView_SetBkColor($tabela, 0xFFFFFF)
	_GUICtrlListView_SetTextColor($tabela, 0x000000)

	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	Local $ler_tabela_entradas = _SQLite_GetTableData2D($hDatabase, "SELECT entradas.valor, entradas.descricao, entradas.data FROM entradas;", $aResult, $iRows, $aNames)

	For $i = 0 To $iRows -1
		GUICtrlCreateListViewItem($aResult[$i][0] & "|" & $aResult[$i][1] & "|" & $aResult[$i][2] & "|", $tabela)
	Next

	Local $somar_total_de_entradas = _SQLite_GetTableData2D($hDatabase, "SELECT SUM(entradas.valor) FROM entradas;", $aResult, $iRows, $aNames)
	Local $label_valor_total_entradas = GUICtrlCreateLabel("Total: " & $aResult[0][0], 160, 470, 200, 20)
	GUICtrlSetFont(-1, 12, 700)

	desconecta_e_fecha_banco()
EndFunc