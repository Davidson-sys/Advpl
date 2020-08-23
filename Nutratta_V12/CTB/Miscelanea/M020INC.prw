#include "rwmake.ch"      
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ M020INC    ¦ Autor ¦ CARLOS GOMES   ¦ Data ¦ 14/02/2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada apos a inclusao do fornecedor preenche    ¦¦¦
¦¦¦          ¦ a tabela CTD - Item Contabil                               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ NUT						¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function M020INC()          

// Inclusao no Item Contabil. //Fornecedor
Dbselectarea("CTD")
Dbsetorder(1)
IF CTD->(Dbseek(xFilial("CTD")+"F"+SA2->(A2_COD+A2_LOJA)))
	_lGrv :=.f.
ELSE
	_lGrv :=.t.
ENDIF

If RecLock("CTD",_lGrv)
	CTD->CTD_FILIAL := xFilial("CTD")
	CTD->CTD_ITEM   := "F"+SA2->(A2_COD+A2_LOJA)
	CTD->CTD_DESC01 := SA2->A2_NOME
	CTD->CTD_CLASSE := "2"
	CTD->CTD_NORMAL := "1"
	CTD->CTD_BLOQ   := "2"
	CTD->CTD_DTEXIS := CtoD("01/01/2010")
	CTD->CTD_ITLP   := CTD->CTD_ITEM
	CTD->CTD_CLOBRG := "2"
	CTD->CTD_ACCLVL := "1"  
	CTD->CTD_BOOK   := "AUTO"
	MsUnlock("CTD")
EndIf

Return