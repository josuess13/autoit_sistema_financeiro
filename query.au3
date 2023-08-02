Func adicionar_receita($descricao, $valor, $salario, $data, $observacao)
    Local $sDatabase = "C:\Caminho\para\o\banco_de_dados.db"
    Local $sTableName = "NomeDaTabela"
    Local $aNewData = ["Nome", "Sobrenome", 30]

    ; Cria a conexão com o banco de dados
    Local $hDB = _SQLite_Open($sDatabase)

    If $hDB = 0 Then
        MsgBox($MB_ICONERROR, "Erro", "Erro ao abrir o banco de dados.")
        Exit
    EndIf

    ; Cria a tabela se ela não existir
    Local $sSQL = "CREATE TABLE IF NOT EXISTS " & $sTableName & " (Nome TEXT, Sobrenome TEXT, Idade INTEGER);"
    _SQLite_Exec($hDB, $sSQL)

    ; Cria a consulta SQL para inserção de dados
    $sSQL = "INSERT INTO " & $sTableName & " (Nome, Sobrenome, Idade) VALUES ('" & $aNewData[0] & "', '" & $aNewData[1] & "', " & $aNewData[2] & ");"

    ; Executa a consulta
    _SQLite_Exec($hDB, $sSQL)

    If @error Then
        MsgBox($MB_ICONERROR, "Erro", "Erro ao inserir dados na tabela.")
    Else
        MsgBox($MB_ICONINFORMATION, "Sucesso", "Dados inseridos na tabela com sucesso!")
    EndIf

    ; Fecha a conexão com o banco de dados
    _SQLite_Close($hDB)
EndFunc