#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//--------------------------------------------------------------------------
/* {Protheus.doc} NT_PON001
Rotina encapsulada antes da execução do rotina PONM010-Leitura e apontamento.
Esta rotina possibilita a alteração do parametro MV_APHEDTM

MV_APHEDTM = Aponta hora extra considerando a data da marcacao.
Aponta hora extra considerando a data da marcacao.

Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 31/10/2016
@version P11 R8
*/
//--------------------------------------------------------------------------
User Function NT_PON01()

Local oSay
Local oDlg		          
Local cItens
//Local cFiltro	:=""
Local aItens 	:={"N=Normal","S=Exceções"}   	
Local oFtTxt	:= TFont():New("Tahoma",,018,,.T.,,,,,.F.,.F.)
Local cMens1	:="Esta rotina ira alterar o contéudo do parametro:"+Chr(13)+Chr(10)+;
"MV_APHEDTM-Aponta hora extra considerando a data da marcação."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
"Como será tratada a exceção de horas extras?"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
"Utilizar com N para situações de apontamento normal,sem exceções de horas extras."+Chr(13)+Chr(10)+;
"Utilizar com S para situações de apontamento com exceções de horas extras."

	
DEFINE MSDIALOG oDlg TITLE "Selecione o Tipo de Leitura/apontamento " FROM 0,0 TO 250,650 PIXEL Style DS_MODALFRAME

//@ 010,025 SAY cMens1 FONT oFtTxt SIZE 1000,200 PIXEL OF oDlg
oSay := TSay():New(010,025,{||cMens1},oDlg,,oFtTxt,,,,.T.,CLR_RED,CLR_WHITE,1000,200)
			
@ 100,050 SAY "Tipo :" FONT oFtTxt PIXEL OF oDlg
@ 100,050 COMBOBOX cItens ITEMS aItens SIZE 050,008 PIXEL OF oDlg
@ 100,130 BUTTON "Alterar" SIZE 060,012 ACTION oDlg:End() OF oDlg PIXEL
			
ACTIVATE MSDIALOG oDlg CENTERED

//-----------------------------------------------------------------------------------
//Posiciona e Grava o Parametro.
//-----------------------------------------------------------------------------------
PUTMV("MV_APHEDTM",cItens)

Aviso("Nutratta","Parametro alterado com sucesso "+Chr(13)+Chr(10)+"Conteúdo: "+cItens,{"OK"},2)

//-----------------------------------------------------------------------------------
// Chama a rotina de leitura e apontamento.Padrão Totvs.
//-----------------------------------------------------------------------------------
PONM010()

Return




