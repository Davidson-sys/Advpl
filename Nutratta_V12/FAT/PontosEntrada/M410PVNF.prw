#include 'protheus.ch'
#include 'parmtype.ch'

//===========================================================================================================
/*Ponto de Entrada para Validar se o pedido esta bloqueado/desbloqueado.
@author  Davidson Carvalho	
@version 	P12.1.17
@build		XXXXXXXX
@since 	    08/04/2019
@return
Adicionado validação para não permitir data de vencimento menor que data base. 

19/09/2019-Davidson
Retirada a validação de R$2.500,00 para clientes isentos/Retirado a Pedido de Giovana Fiscal.
//===========================================================================================================
*/

User Function M410PVNF()

Private _cMensagem 		:= ""           
Private _cMensag1 		:= ""
Private _cMensag2 		:= ""
Private _cMensag3 		:= ""
Private _cMensag4 		:= ""
Private _cMensag5 		:= ""
Private _cMensag6 		:= "" 
Private _cMensag7 		:= ""
Private _cMensag8 		:= ""
Private _lRet			:= .T. 
Private oProcess       


_cMensagem := "Pedido de venda esta com bloqueio de credito (Nutratta). Favor comunicar ao responsável pelo Setor Financeiro "+CHR(10)+CHR(13)
_cMensagem += "para providenciar a solução do problema."

_cMensag1 := "Data de entrega menor que data atual."+CHR(10)+CHR(13)+"Favor alterar a data de entrega do pedido de vendas. "+CHR(10)+CHR(13)

_cMensag2 := "Para pedidos CIF o valor de frete deverá ser preenchido."+CHR(10)+CHR(13)+"Favor informar o valor de frete.. "+CHR(10)+CHR(13)

_cMensag3 := "Data de vencimento  menor que data atual."+CHR(10)+CHR(13)+"Favor alterar a data de vencimento do pedido de vendas. "+CHR(10)+CHR(13)

_cMensag4 := "Cliente Bloqueado."+CHR(10)+CHR(13)+"Favor verificar com o setor financeiro. "+CHR(10)+CHR(13)

_cMensag5 := "Pedido de venda esta com bloqueio de Estoque (Nutratta). Favor comunicar ao responsável pelo Setor Estoque/PCP,"
_cMensag5 += "para providenciar a solução do problema."

_cMensag6 := "Pedido de venda esta com bloqueio de Fretes (Nutratta)."+CHR(10)+CHR(13)+"Favor comunicar ao responsável pelo Setor Logistica "+CHR(10)+CHR(13)
_cMensag6 += "para providenciar a solução do problema."

_cMensag7 := "Para clientes isentos o valor máximo de faturamento é de R$ 2.500,00 (Nutratta)."+CHR(10)+CHR(13)+""+CHR(10)+CHR(13)+"Favor comunicar ao responsável pelo Setor Financeiro "+CHR(10)+CHR(13)
_cMensag7 += "para providenciar a solução do problema."	

_cMensag8 := "Dados não encontrados na tabela de frete."+CHR(10)+CHR(13)+""+CHR(10)+CHR(13)+"Favor comunicar ao departamento TI."+CHR(10)+CHR(13)

oProcess := MsNewProcess():New( { || fProcessa() } ,"Verificando Pedido de vendas...","Aguarde...." , .F. )
oProcess:Activate() 
  
Return(_lRet)

/*
========================================================================================================================
Rotina----: Função para realizar a validação dos registros
Autor-----: Davidson Carvalho 
Data------: 05/04/2019.
========================================================================================================================
Descrição-: 
Uso-------: 
========================================================================================================================
*/

Static Function fProcessa()

Private _dDataEntre 	:=	SC5->C5_FECENT
Private _dDataVen1		:=	SC5->C5_DATA1
Private _dDataVen2		:=	SC5->C5_DATA2
Private _dDataVen3		:=	SC5->C5_DATA3
Private _dDataVen4		:=	SC5->C5_DATA4
Private _dDataVen5		:=	SC5->C5_DATA5
Private _dDataVen6		:=	SC5->C5_DATA6
Private _dDataVen7		:=	SC5->C5_DATA7
Private _dDataVen8		:=	SC5->C5_DATA8
Private _dDataVen9		:=	SC5->C5_DATA9
Private _cTipFrete		:=	SC5->C5_TPFRETE  
Private _cCliente		:=	SC5->C5_CLIENTE
Private _cLojaCli		:=	SC5->C5_LOJACLI 
Private _cNumPed		:=	SC5->C5_NUM
Private _cLocEntreg 	:=  SC5->C5_XLOCENT 
Private _lBloqTMS		:=  SC5->C5_LIBTMS
Private _lTipo			:=  IIF(SC5->C5_TIPO=='N',.T.,.F.)
Private _dData     		:=  dDataBase
Private _cEstado		:= ""
Private _lBloq		   	:= .T.  
Private _lTrava	   		:= .T.
Private _lEnd	   		:= .F.
Private _oProcess   	:= NIL

oProcess := MsNewProcess():New( { |_lEnd| fProcPed(_lEnd,oProcess)} ,"Processamento...", "Processando Pedido...", .F. )
oProcess:Activate()
 
Return


/*
========================================================================================================================
Rotina----: Validando data de entrega/ Validando data de vencimento.
Autor-----: Davidson Carvalho 
Data------: 05/04/2019
========================================================================================================================
Descrição-: 
Uso-------: 
========================================================================================================================
*/

Static Function fProcPed(_lEnd,oProcess)

Local lTipo		:= IIF(SC5->C5_TPFRETE=='C',.T.,.F.)
Local _nProc1 	:= 1
Local _nProc2 	:= 1
Local _nProc3 	:= 1  
Local _nProc4 	:= 1
Local _nProc5 	:= 1
Local x		 	:= 0
Local y		 	:= 0
Local z		 	:= 0
Local w		 	:= 0
Local u		 	:= 0 
Local _nQtEstAtu:= 0 
Local _nPrcVend	:= 0
Local _nTotalPed:= 0 
Local _nFrtSoma	:= 0
Local _nFrTabela:= 0
Local _nDifFrt	:= 0
Local _Isento	:="2" 
Local _cTES		:=""
Local _cStatus	:=""
Local _cQuery	:="" 
Local _aVlrs	:={}
Local _cPais	:= .F.
Local _lBlqEst	:= .F.                       
              
//Alimenta barra de processamento 01
oProcess:SetRegua1(_nProc1)
For x:=1 To _nProc1
	
	//Processamento data de entrega
	oProcess:IncRegua1("Validando Data de entrega....")
	
	//----------------------------------------------------------------------------------------------------------------------
	// Verifica se a data de entrega é menor que a data base e solicita ao usuario que faça a alteração.Davidson-28/06/2017.
	//-----------------------------------------------------------------------------------------------------------------------
	If _dDataEntre < _dData
		
		Aviso("Nutratta - Faturamento",_cMensag1,{"Sair"},3,"Dta.entrega - Pedido No: "+SC5->C5_NUM)
		_lRet := .F.
		Exit
	EndIf
	
	If 	_lEnd
		Exit
	EndIf
	Sleep(1000)
	
	//Alimenta barra de processamento 02
	oProcess:SetRegua2(_nProc2)
	For w:=1 To _nProc2
		//Processamento data de entrega //oProcess:IncRegua1("Verificando Data de entrega-"+StrZero(x,6)+"de "+StrZero(nProc1,6))
		oProcess:IncRegua2("Validando Data de vencimento....")
		
		//-----------------------------------------------------------------------------------
		// Validação das datas de vencimento em relação a data atual.
		//-----------------------------------------------------------------------------------
		If  ! Empty(_dDataVen1).And. _dDataVen1 < _dData .Or. ;
			! Empty(_dDataVen2).And. _dDataVen2 < _dData .Or. ;
			! Empty(_dDataVen3).And. _dDataVen3 < _dData .Or. ;
			! Empty(_dDataVen4).And. _dDataVen4 < _dData .Or. ;
			! Empty(_dDataVen5).And. _dDataVen5 < _dData .Or. ;
			! Empty(_dDataVen6).And. _dDataVen6 < _dData .Or. ;
			! Empty(_dDataVen7).And. _dDataVen7 < _dData .Or. ;
			! Empty(_dDataVen8).And. _dDataVen8 < _dData .Or. ;
			! Empty(_dDataVen9).And. _dDataVen9 < _dData
			Aviso("Nutratta - Faturamento",_cMensag3,{"Sair"},3,"Dta.Venc - Pedido No: "+SC5->C5_NUM)
			_lRet := .F.
			Exit
		EndIf
		
		If 	_lEnd
			Exit
		EndIf
		Sleep(2000)
		
		//Alimenta barra de processamento 03
		oProcess:SetRegua1(_nProc3)
		For y:=1 To _nProc3
			
			//Processamento data de entrega
			oProcess:IncRegua1("Validando Status do Cliente....")
			
			//-----------------------------------------------------------------------------------
			// Validação de clientes bloqueados.
			//-----------------------------------------------------------------------------------
			dbSelectArea("SA1")
			dbSetOrder(1)
			If dbSeek(xFilial("SA1")+Padr(_cCliente,8)+Padr(_cLojaCli,4))
				
				_lBloq:=IIF(SA1->A1_MSBLQL =='1',.T.,.F.)
				
				//Pego o estado do cliente.
				_cEstado	:= SA1->A1_EST 
				_Isento		:= SA1->A1_CONTRIB //1=Sim 2-Não
				_cPais		:= IIF(SA1->A1_CODPAIS $ '01058',.T.,.F.)//Brasil
			EndIf
			
			If _lBloq .And. _lTipo 
				
				Aviso("Nutratta - Faturamento",_cMensag4,{"Sair"},3,"Bloqueio - Pedido No: "+SC5->C5_NUM)
				_lRet := .F.
				Exit
			EndIf
			
			If _lEnd
				Exit
			EndIf
			Sleep(2000)
			
			//Processamento data de entrega //oProcess:IncRegua1("Verificando Data de entrega-"+StrZero(x,6)+"de "+StrZero(nProc1,6))
			//oProcess:IncRegua2("Validando Tipo de Frete...")
			
			//-----------------------------------------------------------------------------------
			// Para pedidos CIF o valor de frete deverá ser preenchido.
			//-----------------------------------------------------------------------------------
			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+Padr(_cNumPed,6))
				
				While ! SC6->(Eof())
					
					If SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == _cNumPed
						
						_nValFrete	:=  SC6->C6_C_FRETE
						_nPrcVend	:=	SC6->C6_PRCVEN
						_nQtdPVAtu	:=  SC6->C6_QTDVEN						    
						_nQtEstAtu 	:=  Posicione("SB2",1,SC6->C6_FILIAL+SC6->C6_PRODUTO+SC6->C6_LOCAL,"B2_QATU") 
						_cTES		:=  Posicione("SF4",1,SC6->C6_FILIAL+SC6->C6_TES,"F4_ESTOQUE")
						_nTotalPed	+=	SC6->C6_VALOR				                 
						
						If  _nQtdPVAtu > _nQtEstAtu  .And. _cTES = "S"
						
							Aviso("Nutratta - Estoque",_cMensag5,{"Sair"},3,"Bloqueio - Pedido No: "+SC5->C5_NUM+CHR(10)+CHR(13)+" Produto: "+SC6->C6_PRODUTO+" Armazem:"+SC6->C6_LOCAL)
							_lRet		:= .F. 
							_lBlqEst	:= .T.
							Exit
						EndIf 
					    
						//Retirado a Pedido de Giovana Fiscal 19/09/2019.
						/*If _nTotalPed > 2500 .And. _Isento == "2" .And. _cPais
							
							Aviso("Nutratta - Faturamento",_cMensag7,{"Sair"},3,"Cliente Isento. - Pedido No: "+SC5->C5_NUM)
							_lRet := .F.
							Exit
						EndIf */ 
					EndIf
					dbSelectArea("SC6")
					SC6->(dbSkip())
				End
			EndIf
			
			If 	_lEnd
				Exit
			EndIf
			Sleep(2000)
			
			If lTipo //Somente CIF
			
				//Alimenta barra de processamento 04
				oProcess:SetRegua2(_nProc4)
				For z:=1 To _nProc4
					
					//Processamento data de entrega
					oProcess:IncRegua2("Validando Valor de frete....")
				   
					_aVlrs	:= U_VldFrt(_cNumPed,_cCliente,_cLojaCli,_cLocEntreg,2)
					If Len(_aVlrs)
						For nTx :=1 To Len(_aVlrs) 
				
						     _nFrtSoma	:=	Val(_aVlrs[nTx][2]) //Soma do frete no pedido     
						     _nFrTabela :=	Val(_aVlrs[nTx][3]) //Tabela Nutratta
						     _nDifFrt	:=	Val(_aVlrs[nTx][4]) //Diferença de frete	     		     
						Next nTx  
					
						_lTrava:= U_VldFrt(_cNumPed,_cCliente,_cLojaCli,_cLocEntreg,1)
						Sleep(200)
						
						//-----------------------------------------------------------------------------------
						// Realiza o bloqueio do pedido por verba.
						// { "C5_BLQ == '2'",'BR_LARANJA'}}	//Pedido Bloquedo por verba
						//-----------------------------------------------------------------------------------
						_oProcess := MsNewProcess():New( { |_lEnd| StaticCall(N_VLDFRETE,fRefresPV,_cCliente,_cLojaCli,_cNumPed,_lTrava,_nFrTabela,_nFrtSoma,_nDifFrt)} ,"Status do Pedido...", "Validando Status do Pedido...", .F. )
	   	   				_oProcess:Activate()
						Exit
					Else
					
						Aviso("Nutratta - Logistica",_cMensag8,{"Sair"},3,"Bloqueio - Pedido No: "+SC5->C5_NUM)
        				
        				If _lBlqEst
        					_lRet := .F.
        				Else
        					_lRet := .T.
        				EndIf
        				
					EndIf
					
					If 	_lEnd
						Exit
					EndIf
					Sleep(200)			
				Next z
			EndIf
		Next y
	Next w
Next x

Return(_lRet)   













  




