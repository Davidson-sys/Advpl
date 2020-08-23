#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACTB005   º Autora³Antonio Vasconcelos º Data ³ 15/01/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para a inclusão de itens contabeis a partir do    º±±
±±º          ³ cadastro de Transportador                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVAGRO				                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ACTB005(_ccod)

	Local _cCodTransp	:= ''
	Local _aArea		:= GetArea()

	dbSelectArea("SA4")
	dbSetOrder(1)
	dbSeek(xFilial("SA4")+_ccod)

	If found()	
		_cCodTransp := '3' + ALLTRIM(_ccod)
		_cNome   := SA4->A4_NOME

		dbSelectArea("CTD")
		dbGoTop()
		dbSetorder(1)
		dbSeek(xFilial("CTD")+_cCodTransp)
		If !Found() .AND. _cCodTransp <> ''
			RecLock("CTD",.T.)
			CTD->CTD_FILIAL 	:= xFilial("CTD")
			CTD->CTD_ITEM  		:= _cCodTransp
			CTD->CTD_CLASSE 	:=	'2'
			CTD->CTD_DESC01 	:=	_cNome
			CTD->CTD_BLOQ		:= '2'
			CTD->CTD_DTEXIS		:= STOD('20030101')
			CTD->CTD_ITLP		:= _cCodTransp
			CTD->CTD_ITSUP		:= SUBSTR(ALLTRIM(_cCodTransp),1,1)
			MsUnLock()
		EndIf
	EndIf
Return ( _cCodTransp) 
