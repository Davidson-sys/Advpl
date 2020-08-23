//#include "rwmake.ch"  
//#Include "SigaWin.ch"

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT100TOK  ¦ Autor CARLOS GOMES				 ¦ Data ¦ 20/05/14¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada na confirmação da nota de entrada         ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ NUT                                                        ¦¦¦    
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/


#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

USER FUNCTION MT100TOK()
	LOCAL LRET := .T.
	LOCAL NPOSCF := 0
	LOCAL CD1Cf  := " "
	LOCAL NPOSCC := 0
	LOCAL CD1CC  := " "
	LOCAL NPOTES := 0
	LOCAL CTES	 := ''
	LOCAL lMT100TOK := .F.

	IF ALLTRIM(FUNNAME()) == 'MATA920' .or. ALLTRIM(FUNNAME()) <> 'MATA103'
		RETURN(.T.)
	ENDIF

	FOR XN := 1 TO LEN(ACOLS)
		IF !GDDELETED(XN)
			NPOSCF := ASCAN(AHEADER,{|X| ALLTRIM(UPPER(X[2]))=="D1_CF"})
			CD1CF  := ACOLS[XN][NPOSCF]
			NPOSCC := ASCAN(AHEADER,{|X| ALLTRIM(UPPER(X[2]))=="D1_CC"})
			CD1CC  := ACOLS[XN][NPOSCC]								
			/*IF SUBSTR(CD1CF,2,3) <> "922" .AND. EMPTY(CD1CC) 
  
				lRet:=U_ValCCNF2(aCols,aBackColsSDE)
				if lRet .and. SuperGetMV("MV_XVALATF",.F.,.T.) //Valida falta da TES Imobilizado
					lRet:=U_ValImob(aCols)
				ENDIF
			ENDIF
			*/
		ENDIF
	NEXT XN

RETURN(LRET)












