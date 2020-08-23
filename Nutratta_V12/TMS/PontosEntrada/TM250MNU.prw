#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"


//------------------------------------------------------------------+

/*/{Protheus.doc} TM250MNU()
Ponto de Entrada para Adicionar Itens no Menu da Rotina TMSA250
@author 	Davis Magalhaes
@since 		31/08/2015
@version 	P11 R5
@param   	n/t
@return  	n/t
@obs        Programa Especifico para Nutratta
/*/
//------------------------------------------------------------------+

User Function TM250MNU()


//aadd(aRotina,{'Impressao RPA Mod 1',"U_RRPA001"  ,0,6,0,NIL})
aadd(aRotina,{'Impressao RPA',"U_RRPA002"  ,0,6,0,NIL})


Return()