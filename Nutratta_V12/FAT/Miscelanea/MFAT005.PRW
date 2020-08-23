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
Rotina----: MFAT005
Autor-----: Davidson Clayton
Data------: 11/06/2018
========================================================================================================================
Descrição-: Rotina para processar o bloqueios dos clientes inadimplentes e seus respectivos pedidos.
Uso-------:  
			                                                                                                                                                                                                                                                               
========================================================================================================================
*/

User Function MFAT005(_Rotina)
Local	lSchedulle	:=	.F.
Local	_nOpc		:=	0

If !Empty(_Rotina)

	_nOpc := Aviso("C L I E N T E - B L O Q U E A D O " ,"Deseja bloquear pedidos ?",{"Sim","Nao"},2)

	If _nOpc == 1
	 
		//--Processsamento manual
		Processa( {|| fProcManu() }, "Aguarde...", "Preparando resgistros....",.F.)
	Else
		Return
	EndIf
Else

	_nOpc := Aviso("C L I E N T E S - B L O Q U E A D O S - A U T O " ,"Deseja bloquear pedidos ?",{"Sim","Nao"},2)

	If _nOpc == 1
	 
		//--Processsamento manual
		Processa( {|| fProcAuto() }, "Aguarde...", "Preparando resgistros....",.F.)
	Else
		Return
	EndIf
	lSchedulle :=	.T.
EndIf 
Return


//--------------------------------------------------------------------------
/* {Protheus.doc} fProcManu
Processamento manual para bloqueio dos pedidos dos clientes bloqueados.
Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 11/06/2018
@version P11 R8
*/
//--------------------------------------------------------------------------
Static Function fProcManu()
	
Local _Cliente	:=	M->A1_COD
Local _cLoja	:=	M->A1_LOJA
Local _nCntCli	:=	0
Local _nProc	:=  0
Local _nCont	:=	0	   

dbSelectArea("SA1")
dbSetOrder(1)
If SA1->(DbSeek(xFilial("SA1")+_Cliente+_cLoja))
    
	fGrvBlq(_Cliente,_cLoja)  
EndIf

Return  



//--------------------------------------------------------------------------
/* {Protheus.doc} fProcAuto
Processamento automatico da função de atualização de bloqueios de pedidos
Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 11/06/2018
@version P11 R8
*/
//--------------------------------------------------------------------------
Static Function fProcAuto()
	
Local _aAreaSA1	:=	GetArea("SA1")  
Local _Cliente	:=	""
Local _cLoja	:=	""
Local _nCntCli	:=	0
Local _nProc	:=  0
Local _nCont	:=	0	   

SA1->(dbEval({||_nProc++}))
ProcRegua(_nProc)

//Percorre o cadastro de clientes....
dbSelectArea("SA1")
dbGotop()
While SA1->((!Eof()))	

	If 	SA1->A1_MSBLQL == '1' 
 		
 		_Cliente	:= 	SA1->A1_COD
 		_cLoja      :=	SA1->A1_LOJA
 		
		IncProc("Verificando clientes "+Alltrim(Str(_nCont))+"  de  "+Alltrim(Str(30)+Chr(13)+Chr(10);
		+Alltrim(SA1->A1_NOME)))
    
		fGrvBlq(_Cliente,_cLoja)  
		_nCont++ 
	EndIf		

	SA1->(dbSkip())
End
RestArea(_aAreaSA1)
Return  

//--------------------------------------------------------------------------
/* {Protheus.doc} fGrvBlq
Rotina que efetiva o bloqueio dos pedidos
Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 11/06/2018
@version P11 R8
*/
//--------------------------------------------------------------------------
Static Function fGrvBlq(_Cliente,_cLoja)

Local _aAreaSC5	:=	GetArea("SC5")    
Local _nContC5 	:=	0       
                    
    
dbSelectArea("SC5")
dbSetOrder(3) 
SC5->(DbSeek(xFilial("SC5")+PadR(_Cliente,8,'0')+PadR(_cLoja,4,'0')))
While SC5->(!Eof()) .And. SC5->C5_CLIENT == _Cliente .And. SC5->C5_LOJACLI	==	_cLoja

 	If Empty(SC5->C5_NOTA)	
		
		IncProc("Verificando Pedidos "+Alltrim(Str(_nContC5))+"  de  "+Alltrim(Str(30)+Chr(13)+Chr(10);
		+Alltrim(SC5->C5_NOMCLI)))
		    
		If RecLock("SC5",.F.)
			Replace C5_BLQ With '2' 
			MsUnlock()
		EndIf    
	
		_nContC5++  
	EndIf
	SC5->(dbSkip())
End
RestArea(_aAreaSC5)  
Return