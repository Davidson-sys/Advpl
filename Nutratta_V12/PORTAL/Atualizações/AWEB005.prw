#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"                 
#INCLUDE "TOPCONN.CH" 
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} AWEB005
// Rotina de Clientes em MVC - MATA030
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

User Function AWEB005()

Return()

/*/{Protheus.doc} MenuDef
// Menu Default
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function MenuDef()

	Local aRotina := {}
	
	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'U_AWEB005A("VIS")'	OPERATION 2	ACCESS 0
//	ADD OPTION aRotina TITLE "Incluir"		ACTION 'U_AWEB005A("INC")'	OPERATION 3	ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"		ACTION 'U_AWEB005A("EDT")'	OPERATION 4	ACCESS 0
//	ADD OPTION aRotina TITLE "Excluir"		ACTION 'U_AWEB005A("EXC")'	OPERATION 5	ACCESS 0
	ADD OPTION aRotina Title 'Legenda'		Action 'U_AWEB005A("LEG")'	OPERATION 8 ACCESS 0

Return(aRotina)

/*/{Protheus.doc} BrowseDef
// Integração Web
@author Marco Aurelio Braga
@since 04/02/2016
@version 1.0
@type function
/*/

Static Function BrowseDef()

	Local aRet		:= {}
	Local cCliPad	:= SuperGetMv("MV_ORCLIPD",,"000000000001")
	
	// Array principal
	
	aAdd(aRet, {"Legend"	, {} })
	aAdd(aRet, {"Alias"		, {} })
	aAdd(aRet, {"Filter"	, {} })
	
	// Array Legenda
	
	aAdd(aRet[1,2], {"SA1->A1_COD + SA1->A1_LOJA == '"+cCliPad+"'", "BR_VERMELHO"	,'Pre-Cliente'		})
	aAdd(aRet[1,2], {"SA1->A1_COD + SA1->A1_LOJA <> '"+cCliPad+"'", "BR_VERDE"		,'Cliente' 			})
	
	// Array Alias
	
	aAdd(aRet[2,2], {"SA1"})
	
	// Array Filter
	
	aAdd(aRet[3,2], {""})	

Return(aRet)

/*/{Protheus.doc} AWEB005A
// Opações do Menu - MATA030
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

User Function AWEB005A(cOpcao)

	Local lRet	:= .T.

	// Compatibilidade com MATA040
	
	Private cCadastro	:= "Clientes"
	Private aMemos		:= {{"A1_CODMARC","A1_VM_MARC"},{"A1_OBS","A1_VM_OBS"}}
	Private aRotina		:= StaticCall(MATA030,MenuDef)
	Private nOpc		:= 0
	Private aRotAuto	:= Nil
	Private xAuto		:= {}
	Private bFiltraBrw	:= {|| Nil}
	Private aCpoAltSA1	:= {}		// Vetor usado na gravacao do historico de alteracoes
	Private aCpoSA1		:= {}		// Vetor usado na gravacao do historico de alteracoes
	Private lCGCValido	:= .F.		// Variavel usada na validacao do CNPJ/CPF (utilizando o Mashup) 
	Private l030Auto	:= .F.		// Variavel usada para saber se é rotina automática
	Private cFilAux		:= cFilAnt	// Variavel utilizada no FINC010	

	Do Case

		Case (cOpcao == "VIS")
			nOpc := 2
			A030Visual("SA1",SA1->(Recno()),2)
		Case (cOpcao == "INC")
			nOpc := 3
			lRet := A030Inclui("SA1",SA1->(Recno()),3)
		Case (cOpcao == "EDT")
			nOpc := 4
			lRet := A030Altera("SA1",SA1->(Recno()),4)
		Case (cOpcao == "EXC")
			nOpc := 5
			lRet := A030Deleta("SA1",SA1->(Recno()),5)
		Case (cOpcao == "LEG")
			nOpc := 8
			fGetLeg()
	EndCase

Return(lRet)

/*/{Protheus.doc} fGetLeg
// Legenda do Cliente
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function fGetLeg()

	Local aLeg := {}
	
	aAdd(aLeg, {"BR_VERDE"		,"Cliente"			} )
	aAdd(aLeg, {"BR_VERMELHO"	,"Pre-Cliente"		} )
	
	BrwLegenda("Legenda","Legenda",aLeg)

Return()