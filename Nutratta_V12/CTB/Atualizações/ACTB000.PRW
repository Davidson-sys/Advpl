#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACTB000   º Autora³Andressa Borges     º Data ³ 16/02/2009  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para a inclusão de itens contabeis a partir do    º±±
±±º          ³ cadastro do Fornecedor                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ U_ACTB000(ALLTRIM(SD1->D1_FORNECE))                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ACTB000(_ccod)

Local _cCodFor := ''
Local _aArea   := GetArea()

dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial("SA2")+_ccod)

If found()	    
    _cCodFor := '2' + ALLTRIM(_ccod)
	_cNome   := SA2->A2_NOME
	
	dbSelectArea("CTD")
	dbGoTop()
	dbSetorder(1)
	dbSeek(xFilial("CTD")+_cCodFor)
	If !Found() .AND. _cCodFor <> ''
		RecLock("CTD",.T.)
		CTD->CTD_FILIAL 	:= xFilial("CTD")
		CTD->CTD_ITEM  		:= _cCodFor
		CTD->CTD_CLASSE 	:=	'2'
		CTD->CTD_DESC01 	:=	_cNome
		CTD->CTD_BLOQ		  := '2'
		CTD->CTD_DTEXIS		:= STOD('20030101')
		CTD->CTD_ITLP		  := _cCodFor
		CTD->CTD_ITSUP    := SUBSTR(ALLTRIM(_cCodFor),1,1)
		MsUnLock()
	EndIf
EndIf
Return ( _cCodFor) //Segundo Rita não deverá retorna a loja pois a mesma não será gravada na CTD.


