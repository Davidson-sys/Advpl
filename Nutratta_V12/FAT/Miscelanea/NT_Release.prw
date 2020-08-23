#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
//--------------------------------------------------------------------------
/*{Protheus.doc} NT_Release
Função para realizar as validações e liberações 
do orçamento ate o  pedido de vendas.

Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 15/04/2019
@version P 12.1.17

19/09/2019-Davidson
Retirada a validação de R$2.500,00 para clientes isentos/Retirado a Pedido de Giovana Fiscal.

*/
//--------------------------------------------------------------------------
  
User Function NT_Release()
      
Local _aAreaAnt := GetArea()
Local _lRet		:= .T. 
Local _lEnd	   	:= .F.
Local _oProcess	:= NIL
      

_oProcess := MsNewProcess():New( { |_lEnd| _lRet:=fProcLib(_lEnd,_oProcess,1)} ,"Processamento...", "Processando Pedido...", .F. )
_oProcess:Activate()
        
RestArea(_aAreaAnt) 
Return(_lRet)
              

/*
========================================================================================================================
Rotina----: Rotina para iniciar o processo de validação
Autor-----: Davidson Carvalho 
Data------: 16/04/2019
========================================================================================================================
Descrição-: 
Uso-------: 
========================================================================================================================
*/
Static Function fProcLib(_lEnd,oProcess,_cFilial,_cNumped)
					
Local _aAreaAnt 		:= GetArea()
Local _nProc1 			:= 1
Local _nProc2 			:= 1
Local _nProc3 			:= 1  
Local _nProc4 			:= 1
Local _nProc5 			:= 1
Local x		 			:= 0
Local y		 			:= 0
Local z		 			:= 0
Local w		 			:= 0
Local u		 			:= 0 
Local _nQtEstAtu		:= 0 
Local _nPrcVend			:= 0
Local _nTotalPed		:= 0
Local _Isento			:= "2" 
Local CMSG      		:= "" // Mensagem de alerta
Local _cTES				:= ""
Local _cStatus			:= ""               
Local _cQuery			:= ""
Local _lVirtual			:= .F.

Private _Liberado		:= '1' 
Private _cMensagem 		:= ""           
Private _cMensag1 		:= ""
Private _cMensag2 		:= ""
Private _cMensag3 		:= ""
Private _cMensag4 		:= ""
Private _cMensag5 		:= ""
Private _cMensag6 		:= ""
Private _cMensag7 		:= ""
Private _cMensag8 		:= ""
Private _cLibNut		:= ""
Private _cEstado		:= ""   
Private _cNumPed		:= ""
Private _lRet			:= .T. 
Private _lBloq		   	:= .T.  
Private _lTrava	   		:= .T. 
Private _lLibera		:= .T. 
Private _lContinua		:= .T.
Private _nOpc			:= 0
Private _dData     		:= dDataBase 
Private oProcess              

_cMensagem 	:= "Pedido de venda esta com bloqueio de credito (Nutratta). Favor comunicar ao responsável pelo Setor Financeiro "+CHR(10)+CHR(13)
_cMensagem 	+= "para providenciar a solução do problema."

_cMensag1 	:= "Data de entrega menor que data atual."+CHR(10)+CHR(13)+"Favor alterar a data de entrega do pedido de vendas. "+CHR(10)+CHR(13)

_cMensag2 	:= "Para pedidos CIF o valor de frete deverá ser preenchido."+CHR(10)+CHR(13)+"Favor informar o valor de frete.. "+CHR(10)+CHR(13)

_cMensag3 	:= "Data de vencimento  menor que data atual."+CHR(10)+CHR(13)+"Favor alterar a data de vencimento do pedido de vendas. "+CHR(10)+CHR(13)

_cMensag4 	:= "Cliente Bloqueado."+CHR(10)+CHR(13)+"Favor verificar com o setor financeiro. "+CHR(10)+CHR(13)

_cMensag5 	:= "Pedido de venda esta com bloqueio de Estoque (Nutratta). Favor comunicar ao responsável pelo Setor Estoque/PCP,"
_cMensag5 	+= "para providenciar a solução do problema."

_cMensag6 	:= "Pedido de venda esta com bloqueio de Fretes (Nutratta)."+CHR(10)+CHR(13)+"Favor comunicar ao responsável pelo Setor Logistica "+CHR(10)+CHR(13)
_cMensag6	+= "para providenciar a solução do problema."

_cMensag7 	:= "Para clientes isentos o valor máximo de faturamento é de R$ 2.500,00 (Nutratta)."+CHR(10)+CHR(13)+""+CHR(10)+CHR(13)+"Favor comunicar ao responsável pelo Setor Financeiro "+CHR(10)+CHR(13)
_cMensag7 	+= "para providenciar a solução do problema."	

_cMensag8	:= "Dados não encontrados na tabela de frete."+CHR(10)+CHR(13)+""+CHR(10)+CHR(13)+"Favor comunicar ao departamento TI."+CHR(10)+CHR(13)

dbSelectArea("SC5")
SC5->(dbSetOrder(1))
If dbSeek(Padr(_cFilial,4)+Padr(_cNumped,6))

	_lVirtual 	:=.F.
Else 
	_lVirtual 	:=.T.
EndIf

CTPFRETE		:= IIF(_lVirtual,M->C5_TPFRETE,SC5->C5_TPFRETE)
CXLOCENT		:= IIF(_lVirtual,M->C5_XLOCENT,SC5->C5_XLOCENT)
CXNOMFAZ		:= IIF(_lVirtual,M->C5_XNOMFAZ,SC5->C5_XNOMFAZ)
CXENDERE		:= IIF(_lVirtual,M->C5_XENDERE,SC5->C5_XENDERE)
XBAIRRO			:= IIF(_lVirtual,M->C5_XBAIRRO,SC5->C5_XBAIRRO)
XUF				:= IIF(_lVirtual,M->C5_XUF,SC5->C5_XUF)
XMUNENT			:= IIF(_lVirtual,M->C5_XMUNENT,SC5->C5_XMUNENT)
XDDD			:= IIF(_lVirtual,M->C5_XDDD,SC5->C5_XDDD)
XTELEFO			:= IIF(_lVirtual,M->C5_XTELEFO,SC5->C5_XTELEFO)
XCTTLOC			:= IIF(_lVirtual,M->C5_XCTTLOC,SC5->C5_XCTTLOC)
XROTEIR			:= IIF(_lVirtual,M->C5_XROTEIR,SC5->C5_XROTEIR)
XCODGPS			:= IIF(_lVirtual,M->C5_XCODGPS,SC5->C5_XCODGPS)
XTPVEIC			:= IIF(_lVirtual,M->C5_XTPVEIC,SC5->C5_XTPVEIC)
XLOCCHA			:= IIF(_lVirtual,M->C5_XLOCCHA,SC5->C5_XLOCCHA)
	
//OS DADOS DO CHAPA SO DEVEM SER VALIDADOS SE C5_LOCCHA == 3
XUFCHAP			:= IIF(_lVirtual,M->C5_XUFCHAP,SC5->C5_XUFCHAP)
XMUNCHA			:= IIF(_lVirtual,M->C5_XMUNCHA,SC5->C5_XUFCHAP)
XDDDCHA			:= IIF(_lVirtual,M->C5_XDDDCHA,SC5->C5_XUFCHAP)
XTELCHA			:= IIF(_lVirtual,M->C5_XTELCHA,SC5->C5_XUFCHAP)
XNOMCHA			:= IIF(_lVirtual,M->C5_XNOMCHA,SC5->C5_XUFCHAP)

//TERMINARAM AS VARIAVEIS REFERENTES AOS DADOS DO CHAPA
XRECEBI			:= IIF(_lVirtual,M->C5_XRECEBI,SC5->C5_XRECEBI)
XHRECED			:= IIF(_lVirtual,M->C5_XHRECED,SC5->C5_XHRECED)
XHRECEA			:= IIF(_lVirtual,M->C5_XHRECEA,SC5->C5_XHRECEA)
XCDMUCH			:= IIF(_lVirtual,M->C5_XCDMUCH,SC5->C5_XCDMUCH)     
cCampo			:= IIF(_lVirtual,M->C5_TPFRETE,SC5->C5_TPFRETE)
_lTipo			:= IIF(cCampo =='C',.T.,.F.)
_dDataEntre 	:= IIF(_lVirtual,M->C5_FECENT,SC5->C5_FECENT)
_dDataVen1		:= IIF(_lVirtual,M->C5_DATA1,SC5->C5_DATA1)
_dDataVen2		:= IIF(_lVirtual,M->C5_DATA2,SC5->C5_DATA2)
_dDataVen3		:= IIF(_lVirtual,M->C5_DATA3,SC5->C5_DATA3)
_dDataVen4		:= IIF(_lVirtual,M->C5_DATA4,SC5->C5_DATA4)
_dDataVen5		:= IIF(_lVirtual,M->C5_DATA5,SC5->C5_DATA5)
_dDataVen6		:= IIF(_lVirtual,M->C5_DATA6,SC5->C5_DATA6)
_dDataVen7		:= IIF(_lVirtual,M->C5_DATA7,SC5->C5_DATA7)
_dDataVen8		:= IIF(_lVirtual,M->C5_DATA8,SC5->C5_DATA8)
_dDataVen9		:= IIF(_lVirtual,M->C5_DATA9,SC5->C5_DATA9)
_cTipFrete		:= IIF(_lVirtual,M->C5_TPFRETE,SC5->C5_TPFRETE)  
_cCliente		:= IIF(_lVirtual,M->C5_CLIENTE,SC5->C5_CLIENTE)
_cLojaCli		:= IIF(_lVirtual,M->C5_LOJACLI,SC5->C5_LOJACLI) 
_cNumPed		:= IIF(_lVirtual,M->C5_NUM,SC5->C5_NUM)
_cLocEntreg 	:= IIF(_lVirtual,M->C5_XLOCENT,SC5->C5_XLOCENT) 
_lBloqTMS		:= IIF(_lVirtual,M->C5_LIBTMS,SC5->C5_LIBTMS)
_cCampo1		:= IIF(_lVirtual,M->C5_TIPO,SC5->C5_TIPO) 
_lTiPedido		:= IIF(_cCampo1=='N',.T.,.F.) 

oProcess := MsNewProcess():New( { |_lEnd| _lRet:= fValiDate(_lEnd,oProcess,_nOpc,_cNumped)} ,"Validando Datas", "Validando data de Entrega...", .F. )
oProcess:Activate()

oProcess := MsNewProcess():New( { |_lEnd| _lRet:= fValidCli(_lEnd,oProcess,_nOpc,_cNumped)} ,"Validando Cliente", "Validando Cliente...", .F. )
oProcess:Activate()

RestArea(_aAreaAnt) 
Return(_lRet)	

     
/*
========================================================================================================================
Rotina----: fValiDate
Autor-----: Davidson Clayton 
Data------: 16/04/2019
========================================================================================================================
Descrição-: Validação da data de entrega
Uso-------: 
========================================================================================================================
*/
Static Function fValiDate(_lEnd,oProcess,_nOpc,_cNumPed)

Local _aAreaAnt 	:= GetArea()
Local _nProc1 		:= 1
Local _nProc2 		:= 1
Local w				:= 0
Local x				:= 0
Local _lRet  		:=.T. 
Local _lEnd	    	:=.F.
Local _oProcess  	:= NIL


//Alimenta barra de processamento
oProcess:SetRegua1(_nProc1)
For x:=1 To _nProc1
	
	//Processamento data de entrega
	oProcess:IncRegua1("Validando Data de entrega....")
	
	//----------------------------------------------------------------------------------------------------------------------
	// Verifica se a data de entrega é menor que a data base e solicita ao usuario que faça a alteração.Davidson-28/06/2017.
	//-----------------------------------------------------------------------------------------------------------------------
	If _dDataEntre < _dData
		
		Aviso("Nutratta - Faturamento",_cMensag1,{"Sair"},3,"Dta.entrega - Pedido No: "+_cNumPed)
		_lRet := .T.
		Exit
	EndIf
	
	If _lEnd
		Exit
	EndIf
	Sleep(1000)
Next x

//Alimenta barra de processamento
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
		Aviso("Nutratta - Faturamento",_cMensag3,{"Sair"},3,"Dta.Venc - Pedido No: "+_cNumPed)
		_lRet := .T.
		Exit
	EndIf
	
	If _lEnd
		Exit
	EndIf
	Sleep(2000)
Next w
RestArea(_aAreaAnt)
Return(_lRet)


/*
========================================================================================================================
Rotina----: fValiDate
Autor-----: Davidson Clayton 
Data------: 16/04/2019
========================================================================================================================
Descrição-: Validação da data de entrega
Uso-------: 
========================================================================================================================
*/                         
Static Function fValidCli(_lEnd,oProcess,_nOpc,_cNumped)
		
Local _aAreaAnt 	:= GetArea()
Local _nProc3 		:= 1
Local _nProc4 		:= 1
Local y				:= 0
Local z				:= 0
Local nTx			:= 0
Local nxy			:= 0
Local _nQtEstAtu	:= 0 
Local _nPrcVend		:= 0
Local _nTotalPed	:= 0 
Local _nValFrete	:= 0
Local _nPrcVend	    := 0
Local _nQtdPVAtu	:= 0
Local _nFrtSoma    	:= 0
Local _nFrTabela   	:= 0
Local  _nDifFrt    	:= 0
Local _Isento		:= "2" 
Local _cTES			:= ""
Local _cStatus		:= ""               
Local _cQuery		:= ""
Local _Liberado		:= '1' 
Local _cLibNut		:= ""
Local _cEstado		:= "" 
Local _cPais		:= .F. 
Local _lRet  		:= .T.
Local _lEnd	    	:= .F.  
Local _lBloq		:= .T.  
Local _lTrava	   	:= .T. 
Local _lLibera		:= .T.
Local _oProcess  	:= NIL
Local _dData     	:= dDataBase
Local _aVlrs		:= {}


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

	If _lBloq .And. _lTiPedido
		
		Aviso("Nutratta - Faturamento",_cMensag4,{"Sair"},3,"Bloqueio - Pedido No: "+_cNumped)
		_lRet := .T.
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
	For nxy :=1 To Len(aCols)
		
		_nValFrete	:=  aCols[nxy][8]
		_nPrcVend	:=	aCols[nxy][7]
		_nQtdPVAtu	:=  aCols[nxy][5]
		_nQtEstAtu 	:=  Posicione("SB2",1,xFilial("SC6")+aCols[nxy][2]+aCols[nxy][14],"B2_QATU")
		_cTES		:=  Posicione("SF4",1,aCols[nxy][12],"F4_ESTOQUE")
		_nTotalPed	+=	aCols[nxy][10]
		
		If	_lTipo .And. _nValFrete == 0
			
			Aviso("Nutratta - Faturamento",_cMensag2,{"Sair"},3,"Pedido CIF. - Pedido No: "+_cNumped)
			_lContinua:= .F. 
			_lRet := .F.
			Exit
		EndIf
				
		If  _nQtdPVAtu > _nQtEstAtu  .And. _cTES = "S"
			
			Aviso("Nutratta - Estoque",_cMensag5,{"Sair"},3,"Bloqueio - Pedido No: "+_cNumped+CHR(10)+CHR(13)+" Produto: "+aCols[nxy][2]+" Armazem:"+aCols[nxy][14])
			lRet := .T.
			Exit
		EndIf
		
		//Retirado a Pedido de Giovana Fiscal 19/09/2019.
		/*If _nTotalPed > 2500 .And. _Isento == "2" .And. _cPais
			
			Aviso("Nutratta - Faturamento",_cMensag7,{"Sair"},3,"Cliente Isento. - Pedido No: "+_cNumped)
			_lRet := .T.
			Exit
		EndIf*/
				
	Next nxy 
	
	If 	_lEnd
		Exit
	EndIf
	Sleep(2000)
Next y

//Somente CIF	
If _lTipo .And. _lContinua
		
	//Alimenta barra de processamento 04
	oProcess:SetRegua2(_nProc4)
	For z:=1 To _nProc4
		
		//Processamento data de entrega
		oProcess:IncRegua2("Validando Valor de frete....")
		 
		_aVlrs	:= U_VldFrt(_cNumPed,_cCliente,_cLojaCli,_cLocEntreg,2)
        If Len(_aVlrs) > 0
			For nTx :=1 To Len(_aVlrs) 
	
			    _nFrtSoma	:=	Val(_aVlrs[nTx][2]) //Soma do frete no pedido         
				_nFrTabela 	:=	Val(_aVlrs[nTx][3]) //Tabela Nutratta
				_nDifFrt	:=	Val(_aVlrs[nTx][4]) //Diferença de frete	   	     		     
			Next nTx 
			
			_lTrava	:= U_VldFrt(_cNumPed,_cCliente,_cLojaCli,_cLocEntreg,1) 
			Sleep(200)
		
			//-----------------------------------------------------------------------------------
			// Realiza o bloqueio do pedido por verba.
			// { "C5_BLQ == '2'",'BR_LARANJA'}}	//Pedido Bloquedo por verba
			//-----------------------------------------------------------------------------------
			_oProcess := MsNewProcess():New( { |_lEnd| StaticCall(N_VLDFRETE,fRefresPV,_cCliente,_cLojaCli,_cNumPed,_lTrava,_nFrTabela,_nFrtSoma,_nDifFrt)} ,"Status do Pedido...", "Validando Status do Pedido...", .F. )
	   		_oProcess:Activate()
			Exit
		Else
			Exit
		EndIf
		Sleep(200)
	Next z
EndIf 

RestArea(_aAreaAnt)
Return(_lRet)



			
		




