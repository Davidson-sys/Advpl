#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "topconn.ch"      
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"      
#include "apwebsrv.ch"
#include "apwebex.ch"
#include "ap5mail.ch"
 
/*
========================================================================================================================
Rotina----: MFAT006
Autor-----: Davidson Clayton
Data------: 11/06/2018
========================================================================================================================
Descrição-: Rotina realizar a mudança de carteira entre clientes.
Uso-------:  
			                                                                                                                                                                                                                                                               
========================================================================================================================
*/

User Function MFAT006()
                 
Local oDlg1	   		:= Nil							// Objeto da Dialog
Local nTamA3_COD	:= TamSX3("A3_COD")[1]   		// Tamanho do campo A3_COD
Local cVendDe  		:= Space(nTamA3_COD)   			// Codigo do vendedor inicial
Local cVendAte 		:= Space(nTamA3_COD)			// Codigo do vendedor final
Local lContinua		:= .T.							// Define se deve prosseguir com o reprocessamento
Local cHoraIn		:= ""							// Hora inicial do processamento
Local dDataFi		:= Nil							// Data final do processamento
Local lEnd			:= .F. 
Local cTexto		:="Realiza a transferência entre carteiras de vendedores." 
Local cTexto1		:="By Nutratta."


Private nCont		:=0
Private dDataIn		:= Nil							// Data inicial do processamento
Private cHoraFi		:= Time()						// Hora final do processamento

Static lProcRegua	:= .T.							// Indica se inicializa o procregua

DEFINE MSDIALOG oDlg1 TITLE "Transferência" FROM 0,0 TO 140,450 PIXEL //Transferência.
	                       
	@ 023,004 TO 065,170 LABEL "Selecao do vendedor:" PIXEL OF oDlg1 //"Selecao do vendedor:"

	@ 002,050 Say cTexto Size 226,008 COLOR CLR_BLACK PIXEL OF oDlg1 //"Recria vínculos do vendedor com suspects, prospects e clientes, a partir das oportunidades"
	@ 010,003 Say cTexto1 Size 125,008 COLOR CLR_BLACK PIXEL OF oDlg1 //"orçamentos ou propostas"
	@ 042,011 Say "Código do vendedor:" Size 055,008 COLOR CLR_BLACK PIXEL OF oDlg1 //"Código do vendedor:"
	@ 035,080 Say "De :" Size 055,008 COLOR CLR_BLACK PIXEL OF oDlg1 //"De :"
	@ 050,080 Say "Para:" Size 055,008 COLOR CLR_BLACK PIXEL OF oDlg1 //"Para:"
	@ 035,095 MsGet cVendDe	 Valid ExistCpo("SA3",cVendDe)	F3 "SA3" Size 065,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg1
	@ 050,095 MsGet cVendAte Valid ExistCpo("SA3",cVendAte)	F3 "SA3" Size 065,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg1	

	DEFINE SBUTTON FROM 035,190 TYPE 1 ENABLE OF oDlg1 Action(oDlg1:End())
	DEFINE SBUTTON FROM 050,190 TYPE 2 ENABLE OF oDlg1 Action(lContinua:=.F.,oDlg1:End())

ACTIVATE MSDIALOG oDlg1 CENTERED 

	
//-----------------------------------------------------------------------------------
// Realiza a validação dos campos vazios.
//-----------------------------------------------------------------------------------
If lContinua .And. !Empty(cVendDe) .And. !Empty(cVendAte)
    
	lContinua :=.T.
Else

	lContinua :=.F.
EndIf


//-----------------------------------------------------------------------------------
// Realiza o processamento para alteração de carteira.
//-----------------------------------------------------------------------------------
If lContinua    

	If Empty(cVendDe) .AND. ("ZZZZZZ" $ AllTrim(Upper(cVendAte)))
		lTodos	:= .T.
	Else
		lTodos	:= .F.
	EndIf  

	aVndProc	:= {}
	cHoraIn		:= Time()
	dDataIn		:= dDatabase	//Date()
	lProcRegua	:= .T.
	

	Processa({|lEnd| FtA1Proc(@lEnd,cVendDe,cVendAte)},"Aguarde","Alterando registros...",.T.) 
	
	aVndProc	:= {}
	cHoraFi := Time()
	dDataFi := dDatabase	//Date()
	
	cMensagem :="Processamento finalizado: "+ cHoraIn +"  -  "+ cHoraFi + CRLF+" - "+"Registros:"+Alltrim(Str(nCont)) //Processamento finalizado. Inicio: "###" Final: "
 			
 	MsgInfo(cMensagem)  
 	lTodos := .F.
Else
	Return .F.
EndIf

Return .T.



/*
========================================================================================================================
Rotina----: FtA1Proc
Autor-----: Davidson Carvalho	
Data------: 27/09/2018
========================================================================================================================
Descrição-: Executa a gravação do codigo do vendedor no cadastro de clientes.
Uso-------: 
========================================================================================================================
*/
Static Function FtA1Proc(lEnd,cVendDe,cVendAte)
    
Local 	aClientes	:={}
Local 	nXt			:=0
Local	cCodVendAnt	:=""
Local 	cNomeVendAnt:=""
Local 	dDtTransf	:=""
Local 	cHrTransf	:=""
           

dbSelectArea("SA1")
SA1->(dbGotop())
While ! SA1->(Eof())
	
	If SA1->A1_VEND == cVendDe  
		
		Aadd(aClientes,{SA1->A1_COD,SA1->A1_LOJA,cVendAte})
		nCont++
	EndIf	
	dbSelectArea("SA1")
	SA1->(dbSkip())

End 


//-----------------------------------------------------------------------------------
// Realiza a gravação no cadastro de clientes.
//-----------------------------------------------------------------------------------
For nXt:=1 To Len (aClientes)

	//-----------------------------------------------------------------------------------
	// Informações referentes ao vendedor antigo.
	//-----------------------------------------------------------------------------------
	dbSelectArea("SA3")
	SA3->(dbSetOrder(1))
	If dbSeek(xFilial("SA3")+cVendDe)
    
    	cNomeVendAnt:=	A3_NOME         
	EndIf

	//-----------------------------------------------------------------------------------
	// Realiza a gravação no cadastro de clientes.
	//-----------------------------------------------------------------------------------	
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If dbSeek(xFilial("SA1")+aClientes[nXt][1]+aClientes[nXt][2])
		
		If RecLock("SA1",.F.)
			
			Replace A1_VEND 	With aClientes[nXt][3]
			Replace A1_ZVEND1 	With cVendDe	 	//Vendedor anterior 
			Replace A1_ZDESVE 	With cNomeVendAnt 	//Nome do vendedor anterior 
			Replace A1_DTTRANS 	With dDataIn 		//Data da transferência.
			Replace A1_HRTRAN 	With cHoraFi 		//Hora da transferência.
			MsUnlock()
		EndIf
	EndIf
Next nXt

Return        



