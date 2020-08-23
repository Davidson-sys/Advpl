#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCTB001   บAutor  ณMicrosiga           บ Data ณ  10/01/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para formar c๓digo do grupo de TES de acordo com  บฑฑ
ฑฑบ          ณo tipo.		                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  RENOVAGRO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GCTB001()            

Local _cCodGrupo := ""
Local _cQuery		:= ""   
Local _cArea := GetArea()

_cQuery := " SELECT"
_cQuery += "  RIGHT(MAX(ZZ5_GRPTES),5) as CODIGO "
_cQuery += " FROM "
_cQuery += RetSqlName("ZZ5")
_cQuery += " WHERE"
_cQuery += "  D_E_L_E_T_ <> '*'"
_cQuery += " AND RIGHT(ZZ5_GRPTES,5) <> '99999' "
_cQuery += "  AND ZZ5_FILIAL = '" + XFILIAL("ZZ5") + "'"
_cQuery += " AND LEFT(ZZ5_GRPTES,1) =  '" + M->ZZ5_TIPO + "'"

dbUseArea(.T.,"TOPCONN",TCGenQry(,,ALLTRIM(Upper(_cQuery))),'TRB',.F.,.T.)

If TRB->(!Eof())
	_cCodGrupo := M->ZZ5_TIPO + STRZERO(VAL(TRB->CODIGO)+1,5)	
EndIf

DbCloseArea("TRB")

RestArea(_cArea)

Return _cCodGrupo