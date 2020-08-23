#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VTMS001 � Autor � Davis NellTech        � Data � 13/01/16  ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para Validar e Gatilhar a Regiao do Cliente         ���
���          � Baseado no Cod de Municipio                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � TMS    - Nutratta                                          ���
�������������������������������������������������������������������������͹��
���Nelltech Gestao de TI �               	                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function VTMS001(cEst,cCodMun)

Local cCodReg 		:= M->A1_CDRDES
Local __cEstReg 	:= ""
Local __cCodIbge 	:= ""
Local lRet			:= .T.


CC2->(dbSetOrder(1))
If CC2->(dbSeek(xFilial('CC2')+cEst+cCodMun))
	__cEstReg  := cEst
	__cCodIbge := cCodMun
	cCodReg    := Iif(Empty(cCodReg),"",&(cCodReg))
	If !Empty(cCodReg)
		M->A1_CDRDES := cCodReg
	EndIf
	M->A1_REGDES  := PADR(CC2->CC2_MUN,TamSx3("A1_REGDES")[1])
Else
	Help('',1,'REGNOIS')
	lRet := .F.
EndIf


Return(lRet)
