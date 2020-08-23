/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ PE01NFESEFAZ ºAutor ³Fabio Andrade º Data ³ 12/02/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³ PONTO DE ENTRADA PARA MANIPULAR OS DADOS DA NF QUE º±±
±±º ³ ANTES DE GERAR O XML º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso ³ AP º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

ESTE PONTO DE ENTRADA ELIMINA A NECESSIDADE DE SE ALTERAR O FONTE PADRÃO NFESEFAZ.PRW
*/
#include "protheus.ch"

#define aPROD 1 //-> aProd
#define cMENSCLI 2 //-> cMensCli
#define cMENSFIS 3 //-> cMensFis
#define aDEST 4 //-> aDest
#define aNOTA 5 //-> aNota
#define aINFOITEM 6 //-> aInfoItem
#define aDUPL 7 //-> aDupl
#define aTRANSP 8 //-> aTransp
#define aENTREGA 9 //-> aEntrega
#define aRETIRADA 10 //-> aRetirada
#define aVEICULO 11 //-> aVeiculo
#define aREBOQUE 11 //-> aReboque

// aRetorno[1] -> aProd
// aRetorno[2] -> cMensCli
// aRetorno[3] -> cMensFis
// aRetorno[4] -> aDest
// aRetorno[5] -> aNota
// aRetorno[6] -> aInfoItem
// aRetorno[7] -> aDupl
// aRetorno[8] -> aTransp
// aRetorno[9] -> aEntrega
// aRetorno[10] -> aRetirada
// aRetorno[11] -> aVeiculo
// aRetorno[11] -> aReboque



USER FUNCTION PE01NFESEFAZ()

LOCAL aNfe := PARAMIXB
Local cMsg := ""
LOCAL cMensCli:=""
Local nI := 0
LOCAL aAreaSe4 :={}
LOCAL aAreaSa2 :={}
LOCAL bAux
LOCAL lNfEntrada:=.F.
LOCAL lNfSaida:=.F.
LOCAL cCtrlPed:=.T.
LOCAL _cQuery := ""

If AllTrim(cFilAnt) == "0201"
	Return(aNfe)
Endif

lNfEntrada:=(aNfe[aNOTA,4]=="0")
lNfSaida:=(aNfe[aNOTA,4]=="1")

cMensCli:=aNfe[cMENSCLI]

cMensCli += "Lote(s): "

IF lNfSaida       

	_cQuery += "SELECT SD2.D2_LOTECTL " + CRLF
	_cQuery += "FROM SD2010 SD2" 							    	+ CRLF
	_cQuery += "WHERE SD2.D2_DOC 	 = '"+ SF2->F2_DOC 	   +"' AND"	+ CRLF
	_cQuery += "	  SD2.D2_SERIE 	 = '"+ SF2->F2_SERIE   +"' AND"	+ CRLF
	_cQuery += "	  SD2.D2_CLIENTE = '"+ SF2->F2_CLIENTE +"' AND"	+ CRLF
	_cQuery += "	  SD2.D2_LOJA    = '"+ SF2->F2_LOJA	   +"' AND"	+ CRLF
	_cQuery += "	  SD2.D_E_L_E_T_ = ' '" 						+ CRLF
	_cQuery += "ORDER BY SD2.D2_ITEMPV" 							+ CRLF
	
	_cQuery := ChangeQuery(_cQuery) 
	
	dbUseArea(.T., "TOPCONN", TCGenQry(, , _cQuery), "TSD2", .F., .T.)
	
	While !TSD2->(Eof())
		If !Empty(TSD2->D2_LOTECTL) 
			cMensCli += ALLTRIM(TSD2->D2_LOTECTL) +", "
		EndIf
	    TSD2->(dbSkip()) 
	End 	 
	
	cMensCli := SUBSTR(cMensCli, 1, LEN(cMensCli)-2)+"."
	dbCloseArea("TSD2")
	
	
ENDIF

aNfe[cMENSCLI]:= cMensCli

RETURN aNfe
     


