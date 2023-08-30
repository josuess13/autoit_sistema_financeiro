#include-once

Func ler_dados_login()
	_SQLite_Startup() ; chama DLL
	If @error Then Exit MsgBox(0, "Erro", "Erro ao iniciar SQLite, por favor, verifique sua DLL")
	; Conecta e abre o banco
	Local $sDatabase = @ScriptDir & '\banco\banco.db'
	Local $hDatabase = _SQLite_Open($sDatabase)
	; Variáveis
	Local $iRows, $iColumns, $hQuery, $sMsg
	; Busca pelo Login
	local $consulta_nome = "SELECT usuarios.login FROM usuarios where usuarios.login = '" & $login & "';"
	_SQLite_Query(-1, $consulta_nome, $hQuery)
	_SQLite_FetchData($hQuery, $iRows)
	local $db_login = $iRows[0]
	_SQLite_QueryFinalize($hQuery)
	If $db_login == "" Then
		msg_erro("Usuário ou Senha incorretos")
		ControlClick("Login", "", $in_login, "left", 1, 199, 10)
	Else
		GUICtrlDelete($msg_erro)
		; Busca pela senha
		local $consulta_senha = "SELECT usuarios.senha FROM usuarios where usuarios.login = '" & $login & "';"
		_SQLite_Query(-1, $consulta_senha, $hQuery)
		_SQLite_FetchData($hQuery, $iRows)
		local $db_senha = $iRows[0]
		_SQLite_QueryFinalize($hQuery)
		If $db_senha <> $senha Then
			If $senha <> "" Then msg_erro("Usuário ou Senha incorretos")
			ControlClick("Login", "", $in_senha, "left", 1, 199, 10)
		Else
			GUIDelete($tela_login)
			tela_inicial()
		EndIf
	EndIf

	; Fecha conexão
	_SQLite_Close($hDatabase)
	_SQLite_Shutdown()
EndFunc

Func adicionar_receita($descricao, $valor, $data, $salario, $observacao = "")
	If @error Then Exit MsgBox(0, "Adicionar Receita", "Erro ao iniciar SQLite, por favor, verifique sua DLL")
    Local $sDatabase = @ScriptDir & '\banco\banco.db'
    Local $sTableName = "entradas"
	$valor = StringReplace($valor, ",", ".")
    Local $aNewData = [$descricao, $valor, $data, $salario, $observacao]
    ; Cria a conexão com o banco de dados
    Local $hDatabase = _SQLite_Open($sDatabase)
    If $hDatabase = 0 Then
        MsgBox($MB_ICONERROR, "Erro", "Erro ao abrir o banco de dados.")
        Exit
    EndIf
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
    _SQLite_Close($hDatabase)
EndFunc