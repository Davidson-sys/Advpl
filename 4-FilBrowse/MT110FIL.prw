#Include "Rwmake.ch"
#Include "Colors.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"
#include "Totvs.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MT110FIL
Ponto de entrada para adicionar filtros na tela Solicitação de compras.
@author 	Davidson-P2P
@since 		25/08/2020.
@version 	12.1.25
@param   	n/t
@return  	n/t
@obs
xxx......
/*/
//-------------------------------------------------------------------   
User Function MT110FIL()

	Local aSaveArea	:= GetArea()
	Local cFiltro 	:= ""
	Local aItens 	:= {"Pendentes","Atendidas","Parciais","Cotacao","Bloqueadas","Rejeitadas","Todas"}
	Local oFtTxt 	:= TFont():New("Tahoma",,018,,.T.,,,,,.F.,.F.)
	Local oDlg
	Local cItens

	If Upper( FUNNAME() ) == "MATA110"

		//Tela de opções de filtro-Requisições Abertas-Fechadas-Parciais-Todas.
		DEFINE MSDIALOG oDlg TITLE "Filtrar Solicitações de compras" FROM 0,0 TO 050,350 PIXEL Style DS_MODALFRAME

		@ 010,005 SAY "Solicitações:" FONT oFtTxt PIXEL OF oDlg
		@ 010,050 COMBOBOX cItens ITEMS aItens SIZE 045,008 PIXEL OF oDlg
		@ 008,105 BUTTON "Filtrar" SIZE 060,012 ACTION oDlg:End() OF oDlg PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED

		If cItens $ "Pendentes"
			cFiltro	:= "SC1->C1_QUJE == 0 .AND.	Empty(SC1->C1_PEDIDO) .AND. EMPTY(SC1->C1_COTACAO) .AND. EMPTY(SC1->C1_RESIDUO) .AND. SC1->C1_APROV == 'L' "

		ElseIf cItens $ "Atendidas"
			cFiltro	:= "SC1->C1_QUJE == SC1->C1_QUANT .AND. SC1->C1_QUJE > 0 "

		ElseIf cItens $ "Parciais"
			cFiltro	:= "SC1->C1_QUJE > 0 .AND. SC1->C1_QUJE < SC1->C1_QUANT "

		ElseIf cItens $ "Cotacao"
			cFiltro	:= "!EMPTY(SC1->C1_COTACAO).AND. Empty(SC1->C1_PEDIDO) .AND. SC1->C1_QUJE == 0"

		ElseIf cItens $ "Bloqueada"
			cFiltro	:= "SC1->C1_APROV == 'B' .AND. Empty(SC1->C1_PEDIDO)"

		ElseIf cItens $ "Rejeitada"
			cFiltro	:= "SC1->C1_APROV == 'R' "

		EndIf
	EndIf

	RestArea(aSaveArea)

Return (cFiltro)


//Resultado: em 25/08/2020 Davidson --> Teste com a rotina - 100% Funcionando.
