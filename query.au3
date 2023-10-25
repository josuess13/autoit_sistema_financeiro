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