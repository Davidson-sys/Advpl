#include "rwmake.ch"  
#include "topconn.ch"  
 
/*
========================================================================================================================
Rotina----: COMA002
Autor-----: Davidson Carvalho
Data------: 24/01/2018
========================================================================================================================
Descrição-:  Gera cod. sequencial automaticamente para o produto
Uso-------:  Chamado no gatilho do campo B1_C_CDFAM SX7
========================================================================================================================
*/
User Function COMA002()

Local _cCodPro 	:= "00000000"
Local _cArea 	:= GetArea()
Local _cQuery 	:= ""

_cQuery := " SELECT MAX(B1_COD) AS CODIGO "
_cQuery += " FROM " + RetSqlName("SB1")
_cQuery += " WHERE LEFT(B1_COD,2) = '" + SX5->X5_CHAVE + "'" 
_cQuery += " AND  D_E_L_E_T_ = ' '"

TcQuery _cQuery New Alias "TRB"
dbSelectArea("TRB")
dbGoTop()

_cCodPro := Soma1(Alltrim(TRB->CODIGO))

dbSelectArea("TRB")
 DBCloseArea("TRB")

While !MayIUseCode("B1_COD"+xFilial("SB1")+_cCodPro)
	_cCodPro := Soma1(_cCodPro)
EndDo             

RestArea(_cArea)

Return(_cCodPro)



