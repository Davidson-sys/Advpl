//#include "FIVEWIN.CH"
#Include "TopConn.Ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MCTB002 � Autor � ANTONIO VASCONCELOS  	 � Data �  26/08/09���
�������������������������������������������������������������������������͹��
���Descricao � Grava a conta contabil na contabiliza��o da folha         -���
���          � tratando o tipo do centro de custo 				          ���
�������������������������������������������������������������������������͹��
���Uso       � NUTRATTA                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MCTB002()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

CCta := ""

DbSelectArea("CTT")
dbSetOrder(1)
dbSeek(xFilial("CTT")+SRZ->RZ_CC)

If CTT->CTT_TIPOCT == "D"
	DbSelectArea("SRV")
	DbSetOrder(1)
	DbSeek(xFilial("SRV")+SRZ->RZ_PD)
	If found()
		CCta := SRV->RV_DESPESA
	endif
	
ElseIf CTT->CTT_TIPOCT == "C"
	DbSelectArea("SRV")
	DbSetOrder(1)
	DbSeek(xFilial("SRV")+SRZ->RZ_PD)
	If found()
		CCta := SRV->RV_DEBITO
	EndIf
EndIf

Return (CCta)
