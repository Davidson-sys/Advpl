#INCLUDE "rwmake.ch"
#INCLUDE "FWMVCDEF.CH" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACTB003   บ Autoraณ Antonio Vasconcelosบ Data ณ  15/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de Grupo de TES. Usado na contabiliza็ใo dos modu บฑฑ
ฑฑบ          ณ los compras e faturamento.                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NUTRATTA			                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
//TODO Observa็ใo auto-gerada.
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
				Help("" ,1,'ACTB003',, 'Preenchimento da conta d้bito ้ obrigat๓rio!', 1, 0 ,.F.)
				//Alert("Preenchimento da conta d้bito ้ obrigat๓rio!")
			EndIf

			If (M->ZZ5_ORICRE == "G" .AND. Empty(M->ZZ5_CTACRE) )
				lRet := .F.
				Help("" ,1,'ACTB003',, 'Preenchimento da conta cr้dito ้ obrigat๓rio!', 1, 0 )
				//Alert("Preenchimento da conta cr้dito ้ obrigat๓rio!")
			EndIf

		EndIf	
	EndIf

Return(lRet)
