#INCLUDE "rwmake.ch"
#INCLUDE "FWMVCDEF.CH" 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACTB003   � Autora� Antonio Vasconcelos� Data �  15/04/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Grupo de TES. Usado na contabiliza��o dos modu ���
���          � los compras e faturamento.                                 ���
�������������������������������������������������������������������������͹��
���Uso       � NUTRATTA			                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

/*/{Protheus.doc} ACTB003
@since 22/01/2016
@version 1.0 

@type function
/*/
User Function ACTB003

	Local oBrowse

	NEW MODEL ;
	TYPE        	1;
	DESCRIPTION 	"Cadastro de Grupo de TES" ;
	BROWSE      	oBrowse ;
	SOURCE      	"ACTB003" ;
	MODELID     	"MACTB003" ;
	MASTER      	"ZZ5";  

Return Nil


/*/{Protheus.doc} MACTB003
//TODO Observa��o auto-gerada.
@author raphael.ferreira
@since 22/01/2016
@version 1.0

@type function
/*/
User Function MACTB003()

	Local aParam	:= PARAMIXB
	Local lRet		:= .T.
	Local oObj		:= ""
	Local cIdPonto	:= ""

	If aParam <> NIL

		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]

		If cIdPonto ==  "FORMPOS"

			If (M->ZZ5_ORIDEB == "G" .AND. Empty(M->ZZ5_CTADEB) )
				lRet := .F.
				Help("" ,1,'ACTB003',, 'Preenchimento da conta d�bito � obrigat�rio!', 1, 0 ,.F.)
				//Alert("Preenchimento da conta d�bito � obrigat�rio!")
			EndIf

			If (M->ZZ5_ORICRE == "G" .AND. Empty(M->ZZ5_CTACRE) )
				lRet := .F.
				Help("" ,1,'ACTB003',, 'Preenchimento da conta cr�dito � obrigat�rio!', 1, 0 )
				//Alert("Preenchimento da conta cr�dito � obrigat�rio!")
			EndIf

		EndIf	
	EndIf

Return(lRet)
