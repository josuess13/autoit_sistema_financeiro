# AutoIt3Wrapper_UseX64 = Y

#include<SQLite.dll.au3>

_SQLite_Startup() ; Load the DLL
If @error Then Exit MsgBox(0, "Error", "Unable to start SQLite, Please verify your DLL")

Local $sDatabase = @ScriptDir & '\SQLiteTestDatabase.db'
Local $hDatabase = _SQLite_Open($sDatabase) ; Create the database file and get the handle for the database

;_SQLite_Exec($hDatabase, 'CREATE TABLE People (first_name, last_name);') ; CREATE a TABLE with the name "People"
;_SQLite_Exec($hDatabase, 'INSERT INTO People VALUES ("Timothy", "Lee");') ; INSERT "Timothy Lee" into the "People" TABLE
;_SQLite_Exec($hDatabase, 'INSERT INTO People VALUES ("John", "Doe");') ; INSERT "John Doe" into the "People" TABLE

Local $aResult, $iRows, $iColumns ; $iRows and $iColuums are useless but they cannot be omitted from the function call so we declare them

_SQLite_GetTable2d($hDatabase, 'SELECT * FROM People;', $aResult, $iRows, $iColumns) ; SELECT everything FROM "People" TABLE and get the $aResult
_ArrayDisplay($aResult, "Results from the query")

_SQLite_Close($hDatabase)
_SQLite_Shutdown()