#include-once

Func adicionar_receita($descricao, $valor, $data, $salario, $observacao = "")
	If @error Then Exit MsgBox(0, "Adicionar Receita", "Erro ao iniciar SQLite, por favor, verifique sua DLL")
    Local $sDatabase = @ScriptDir & '\banco\banco.db'
    Local $sTableName = "entradas"
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