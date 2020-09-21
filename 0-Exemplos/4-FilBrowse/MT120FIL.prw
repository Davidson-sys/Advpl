#Include "Rwmake.ch"
#Include "Colors.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"  
#include "Totvs.ch"	

//-------------------------------------------------------------------
/*/{Protheus.doc} MT120FIL
Ponto de entrada para adicionar filtros na tela Pedido de compras.
@author 	Nome Sobrenome
@since 		99/99/9999.
@version 	P11 R5
@param   	n/t
@return  	n/t
@obs
xxx......
/*/
//-------------------------------------------------------------------   
User Function MT120FIL()
	
	Local aSaveArea	:=	GetArea()
	Local cFiltro 	:=	""
	Local oDlg		          
	Local cItens
	Local aItens :={"Pendentes","Parciais","Atendidos","Bloqueados","Residuo","Todos"}   	
	Local oFtTxt := TFont():New("Tahoma",,018,,.T.,,,,,.F.,.F.)

	If Upper( FUNNAME() ) == "MATA121"	
		
		//Tela de opções de filtro-Requisições Abertas-Fechadas-Parciais-Todas.
		DEFINE MSDIALOG oDlg TITLE "Filtrar Pedido de compras" FROM 0,0 TO 050,350 PIXEL Style DS_MODALFRAME
			
		@ 010,005 SAY "Pedidos :" FONT oFtTxt PIXEL OF oDlg
		@ 010,050 COMBOBOX cItens ITEMS aItens SIZE 047,008 PIXEL OF oDlg
		@ 008,105 BUTTON "Filtrar" SIZE 060,012 ACTION oDlg:End() OF oDlg PIXEL
			
		ACTIVATE MSDIALOG oDlg CENTERED
			
  	   	If cItens $ "Pendentes"
 	   		cFiltro 	:= "SC7->C7_QUJE == 0 .AND. SC7->C7_CONAPRO=='L' .AND. SC7->C7_RESIDUO<>'S'  "				 	       
		
		ElseIf cItens $ "Atendidos"
			cFiltro 	:= "SC7->C7_QUJE == SC7->C7_QUANT "	
			
		ElseIf cItens $ "Parciais"
			cFiltro 	:= "SC7->C7_QUJE > 0 .AND. SC7->C7_QUJE < SC7->C7_QUANT "	
			
   		ElseIf cItens $ "Bloqueados"
			cFiltro 	:= "SC7->C7_CONAPRO=='B' .AND. SC7->C7_RESIDUO<>'S'"	

		ElseIf cItens $ "Residuo"
			cFiltro 	:= "SC7->C7_RESIDUO=='S'"									
				
		EndIf	
	EndIf

	RestArea(aSaveArea)  
	
Return (cFiltro) 


//Resultado: em 25/08/2020 Davidson --> Teste com a rotina - 100% Funcionando.
