#include-once
Func exibir_gastos_fixos_grid()
	; Exibir entradas
	Global $tabela_gastos_fixos = GUICtrlCreateListView("ID | VALOR | DESCRIÇÃO ", 20, 20, 460, 400, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS));$LVS_EDITLABELS)

	_GUICtrlListView_SetColumnWidth($tabela_gastos_fixos, 1, 100)
	_GUICtrlListView_SetColumn($tabela_gastos_fixos, 1, "VALOR", -1, 1)
	_GUICtrlListView_SetColumnWidth($tabela_gastos_fixos, 2, 200)

	_GUICtrlListView_SetExtendedListViewStyle($tabela_gastos_fixos, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FLATSB, $LVS_EX_FULLROWSELECT))
	_GUICtrlListView_SetTextBkColor($tabela_gastos_fixos, 0xE0E0E0)
	_GUICtrlListView_SetBkColor($tabela_gastos_fixos, 0xFFFFFF)
	_GUICtrlListView_SetTextColor($tabela_gastos_fixos, 0x000000)

	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	Local $ler_tabela_entradas = _SQLite_GetTableData2D($hDatabase, "SELECT id, valor, descricao FROM gastos_fixos;", $aResult, $iRows, $aNames)

	For $i = 0 To $iRows -1
		GUICtrlCreateListViewItem($aResult[$i][0] & "|" & "R$ " & $aResult[$i][1] & "|" & $aResult[$i][2] & "|", $tabela_gastos_fixos)
	Next

	Local $somar_total_gf = _SQLite_GetTableData2D($hDatabase, "SELECT SUM(valor) FROM gastos_fixos;", $aResult, $iRows, $aNames)
	Local $label_valor_total_entradas = GUICtrlCreateLabel("Total Gastos Fixos: R$" & $aResult[0][0], 20, 440, 300, 20)
	GUICtrlSetFont(-1, 12, 700)

	desconecta_e_fecha_banco()
EndFunc

Func salvar_gasto_fixo($descricao, $valor)
	conecta_e_inicia_banco()

	$valor = StringReplace($valor, ",", ".")
	Local $aResult, $iRows, $aNames
    $sSQL = "INSERT INTO gastos_fixos (descricao, valor) VALUES ('" & $descricao & "', '" & $valor & "');"
    ; Executa a consulta
    _SQLite_Exec($hDatabase, $sSQL)
    If @error Then
        MsgBox($MB_ICONERROR, "Erro", "Erro ao inserir dados na tabela.")
    Else
        MsgBox($MB_ICONINFORMATION, "Sucesso", "Dados gravados com sucesso!")
    EndIf

	desconecta_e_fecha_banco()
EndFunc

Func carregar_gasto_fixo_para_edicao($id)
	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	Local $carregar_gf_id = _SQLite_GetTableData2D($hDatabase, "SELECT id, descricao, valor FROM gastos_fixos where id = " & $id, $aResult, $iRows, $aNames)
	Local $valor = StringReplace($aResult[0][2], ".", ",")
	Local $resultado = [$aResult[0][0] , $aResult[0][1] , $valor]
	desconecta_e_fecha_banco()
	Return($resultado)
EndFunc

Func salvar_edicao_gasto_fixo($id, $descricao, $valor)
	conecta_e_inicia_banco()
	$valor = StringReplace($valor, ",", ".")
	Local $aResult, $iRows, $aNames

    ; Cria a consulta SQL para inserção de dados
    $sSQL = "UPDATE gastos_fixos SET valor = '" & $valor & "', descricao = '" & $descricao & "' WHERE id = " & $id & ";"
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

Func deletar_gasto_fixo($id)
	conecta_e_inicia_banco()
	$sSQL = "delete from gastos_fixos where id = " & $id
	_SQLite_Exec($hDatabase, $sSQL)
    If @error Then
        MsgBox($MB_ICONERROR, "Erro", "Erro ao excluir Gasto Fixo.")
    Else
        MsgBox($MB_ICONINFORMATION, "Sucesso", "Gasto Fixo excluído com sucesso!")
    EndIf
	desconecta_e_fecha_banco()
EndFunc

Func gravar_gasto_fixo($id)
	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	Local $carregar_gf_id = _SQLite_GetTableData2D($hDatabase, "SELECT valor, descricao FROM gastos_fixos where id = " & $id, $aResult, $iRows, $aNames)
	Local $valor_gf = $aResult[0][0]
	Local $descricao_gf = $aResult[0][1]
	Local $consultar_usuario_logado = _SQLite_GetTableData2D($hDatabase, "SELECT configuracoes.usuario_logado FROM configuracoes;", $aResult, $iRows, $aNames)
	Local $usuario_logado = $aResult[0][0]
	Local $data = @MDAY & "/" & @MON & "/" & @YEAR

	$sSQL = "INSERT INTO saidas (descricao, valor, data, fixo, observacao, adicionado_por) VALUES ('" & $descricao_gf & "', '" & $valor_gf & "', '" & $data & "', '" & 1 & "', '" & "Gasto fixo" & "', '" & $usuario_logado & "');"
    _SQLite_Exec($hDatabase, $sSQL)
    If @error Then
        MsgBox($MB_ICONERROR, "Erro", "Erro ao inserir dados na tabela.")
    Else
        MsgBox($MB_ICONINFORMATION, "Sucesso", "Dados gravados com sucesso!")
    EndIf
	desconecta_e_fecha_banco()
EndFunc

Func soma_gastos_fixos()
	conecta_e_inicia_banco()
	Local $aResult, $iRows, $aNames
	Local $somar_total_gf = _SQLite_GetTableData2D($hDatabase, "SELECT SUM(valor) FROM gastos_fixos;", $aResult, $iRows, $aNames)
	Return($aResult[0][0])
	desconecta_e_fecha_banco()
EndFunc