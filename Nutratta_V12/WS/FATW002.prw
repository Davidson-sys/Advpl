#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.Ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "totvswebsrv.ch"



/*/
�������������������������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � FATW002  � Autor � Fabr�cio Antunes      � Data da Criacao  � 07/04/2016               					    ���
���������������������������������������������������������������������������������������������������������������������������͹��
���Descricao � Realiza a grava��o no cadastro de clientes.			                                                 		���
���          � 																					                            ���
���������������������������������������������������������������������������������������������������������������������������͹��
���Uso       � 														             						                    ���
���������������������������������������������������������������������������������������������������������������������������͹��
���Parametros� Nenhum						   							                               						���
���������������������������������������������������������������������������������������������������������������������������͹��
���Retorno   � Nenhum						  							                               						���
���������������������������������������������������������������������������������������������������������������������������͹��
���Usuario   � Microsiga                                                                                					���
���������������������������������������������������������������������������������������������������������������������������͹��
���Setor     � Politriz				                                                                   						���
���������������������������������������������������������������������������������������������������������������������������͹��
���            			          	ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL                   						���
���������������������������������������������������������������������������������������������������������������������������͹��
���Autor     � Data     � Motivo da Alteracao  				               �Usuario(Filial+Matricula+Nome)    �Setor        ���
���������������������������������������������������������������������������������������������������������������������������ĺ��
���          �          �                               				   �                                  �   	        ���
���----------�----------�--------------------------------------------------�----------------------------------�-------------���
���          �          �                    							   �                                  � 			���
���----------�----------�--------------------------------------------------�----------------------------------�-------------���
���������������������������������������������������������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������������������������
/*/    

WsStruct PEDITENS
 	WsData C6_PRODUTO 	As String	OPTIONAL
	WsData C6_QTDVEN 	As STRING	OPTIONAL
	WsData C6_PRCVEN 	As STRING	OPTIONAL
EndWsStruct                       


WsStruct PEDIDOS
    //Cabec do Pedido
    WsData C5_CLIENTE	As String	OPTIONAL
    WsData C5_LOJACLI	As String	OPTIONAL
    WsData C5_CONDPAG	As String	OPTIONAL  
    Wsdata C5_VEND1     As String	OPTIONAL 
    WsData C5_OBS		As String	OPTIONAL
	WsData oItens	   as ARRAY OF  PEDITENS 		
		
EndWsStruct


WsService IMPPEDIDOS DESCRIPTION "WebService de integra��o Fluig para importa��o do pedido de venda"

	// Vari�veis criadas para atender receber o c�digo da opera��o e a chave de autentica��o
	WSData cWSPWD 	   As String 	   //CHAVE PARA INTEGRA��O PARAMETRO MV_PWINTOP
	WSData cWSOPERA    As String   	   //C�DIGO DA OPERA��O conforme abaixo:
    
    WsData oPedidos     As PEDIDOS

    // Vari�veis criadas para atender o m�todo de libera��o de pedido
	WSData cWSRETURN   As String

    WsMethod GERAPEDIDO DESCRIPTION "Metodo para faturamento do pedido de compra  via MSExecAuto() da MATA410"

EndWsService

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATW001P � Autor � Fabricio Antunes   � Data � 07/04/2016  ���
�������������������������������������������������������������������������͹��
���Descri��o � Gera o Pedido de venda                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������͹��
���Arquivos  �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

WsMethod GERAPEDIDO WsReceive cWSPWD,cWSOPERA,oPedidos WsSend cWSRETURN WsService IMPPEDIDOS

Local cChave 	:= ::cWSPWD  //CHAVE DE VALIDAO ORIGEM
Local cOera 	:= ::cWSOPERA
Local oDados 	:= ::oPedidos 
Local cPARPWD	:= "123456"   
Local aCabec	:={}
Local aItens	:={}
Local _cLog     :=""

IF AllTrim(cChave) == AllTrim(cPARPWD)
         aCabec:={oDados:C5_CLIENTE,oDados:C5_LOJACLI,oDados:C5_CONDPAG,oDados:C5_VEND1,oDados:C5_OBS}
         For nX:=1 to Len(oDados:oItens)
        	aadd(aItens,{oDados:oItens[nX]:C6_PRODUTO,oDados:oItens[nX]:C6_PRCVEN,oDados:oItens[nX]:C6_QTDVEN})
         Next 
         cRet	:= U_FATW001P(aCabec,aItens)
         ::cWSRETURN:= cRet
Else
	conOut("[ERRO] FATW001 " + dtoc(date()) + " " + Time() +"==>Chave de seguran�a inv�lida!")
	::cWSRETURN := "00000 -CHAVE DE SEGURAN�A INV�LIDA" //RETORNO DE OPERAO NO CONCLUIDA
EndIf

Return(.T.)     
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATW001P � Autor � Fabricio Antunes   � Data � 07/04/2016  ���
�������������������������������������������������������������������������͹��
���Descri��o � Gera o Pedido de venda                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������͹��
���Arquivos  �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/  
User Function FATW001P(aCabec,aItens)

Local aSC5:={}
Local aLinha:={}
Local aSC6:={}
Local aRet:={}
Local cNum:=""
Local cTES:=""
Local cEst:=""
Local cRet:=""
Local _cVend:=""
Local _cLog:=""
Local lPronta:=.F. 
Local lFatiado:=.F.
Private lMsErroAuto :=.F.
Private lAutoErrNoFile:=.T.  

//RpcSetType(3)
	
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"
//BEGIN TRANSACTION

cNum:=GETSXENUM("SC5","C5_NUM")



//Regra de preenchimento de TES / Cliente Pronta Entrega
/*dbSelectArea("SA1")
SA1->(dbSetOrder(1))
IF SA1->(dbSeek(xFilial("SA1")+aCabec[1]+aCabec[2])) 
	cEst:=Alltrim(SA1->A1_EST)
	IF SA1->A1_XGC = '2' 
		lPronta:=.T.
    Else
    	lPronta:=.F.
    EndIF
EndIF   */


dbSelectArea("SA3")
SA3->(dbSetOrder(1))
IF SA3->(dbSeek(xFilial("SA3")+Alltrim(aCabec[4]))) .OR.  Alltrim(aCabec[4]) == 'admin' //Retirar administrador ap�s testes


	_nKG:=0
	_ctabela:=""
	
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
		
		For nX:= 1 to Len(aItens) 
			IF Alltrim(aItens[nX][1]) <> '' .AND. Alltrim(aItens[nX][2]) <> '' .AND. Alltrim(aItens[nX][3]) <> '' 
				
				_cContrib:= POSICIONE("SA1",1,Xfilial("SA1")+aCabec[1]+aCabec[2],"A1_CONTRIB")
				
				if _cContrib=="1" //� contribuinte
					cTES:="503"
				Else
					cTES:="504"	 //n�o � contribuinte
				EndIf	
				 
				
				AADD(aLinha, {"C6_NUM"		,cNum	   				,Nil}  )
				AADD(aLinha, {"C6_ITEM"		,StrZero(nX,2)	   		,Nil}  )
				AADD(aLinha, {"C6_PRODUTO"	,aItens[nX][1]	   		,Nil}  )
				AADD(aLinha, {"C6_QTDVEN"	,Val(aItens[nX][3])		,Nil}  )
				AADD(aLinha, {"C6_PRCVEN"	,Val(StrTran(aItens[nX][2],',','.'))		,Nil}  )
				AADD(aLinha, {"C6_TES"		,cTes					,Nil}  )
				AAdd(aSC6,aLinha)
				aLinha:={}  
				_nKG+=Val(aItens[nX][3])
			EndIF
		Next nX
	    
	   /* if xFilial("SC5")=="01"
	    	_ctabela:="004" 
	    ElseIf _nKG >=6 .And. _nKG <=10
	    	_ctabela:="001"
	    ElseIf _nKG >=11 .And. _nKG <=19
	    	_ctabela:="002"
	    Else
	     	_ctabela:="003"
	    EndIf */
	    _cTabela:=POSICIONE("SA1",1,xFilial("SA1")+aCabec[1]+aCabec[2],"A1_TABELA")
	    _cVend:=AllTrim(aCabec[4])
		_cVend:= IIF(AllTrim(_cVend)=='admin',"000001",_cVend)
		
		AAdd(aSC5,{"C5_NUM"		,cNum		,Nil})
		AAdd(aSC5,{"C5_TIPO"	,"N"   		,Nil})
		AAdd(aSC5,{"C5_CLIENTE"	,aCabec[1]	,Nil})
		AAdd(aSC5,{"C5_LOJA"	,aCabec[2]	,Nil})
		AAdd(aSC5,{"C5_CONDPAG"	,aCabec[3]	,Nil})   
		AAdd(aSC5,{"C5_VEND1"	,_cVend	,Nil})
		AAdd(aSC5,{"C5_OBS"	,cNum+" - "+aCabec[5]		,Nil})
		AAdd(aSC5,{"C5_TABELA"	,_cTabela  	,Nil}) 
//		AAdd(aSC5,{"C5_TPFLUIG"	,"1"   		,Nil}) 
		//AAdd(aSC5,{"C5_ESPECI1"	,"CX"		,Nil})
		//AAdd(aSC5,{"C5_TABELA"	,"004"		,Nil})    
		//AAdd(aSC5,{"C5_REDESP"	," "	,Nil})
		//AAdd(aSC5,{"C5_XOBSPOR" ,aCabec[5] ,Nil})
		
	   //	AAdd(aSC5,{"C5_VEND1"	,aCabec[4]	,Nil})
		//aSC5 := FWVetByDic(aSC5, 'SC5')
	
	
	
		//cTES:="501"
		
		lMsErroAuto := .F.
	    
	//	BEGIN TRANSACTION
	
	   		MSExecAuto({|x,y,z|Mata410(x,y,z)},aSC5,aSC6,3)
	
			If lMsErroAuto
				RollbackSx8()
				aAutoErro := GetAutoGRLog()
				_cLog:=""
			
				For nX := 1 To Len(aAutoErro)				

					_cLog+= aAutoErro[nX]+CHR(13)+CHR(10)		
					cRet+= aAutoErro[nX]+CHR(13)+CHR(10)	
				Next nX	
				
				
				_cLog+=CHR(13)+CHR(10)	
				For nY := 1 To Len(aSC5)				

					_cLog+= aSC5[nY][1]+" := "+aSC5[nY][2]+CHR(13)+CHR(10)		
					
				Next nY	
				
				
				DisarmTransaction()
				cRet:="Erro na inclus�o do pedido, favor contactar suporte t�cnico "+_cLog
			Else 
				ConfirmSx8()
				cRet+="Pedido de numero "+cNum+" incluido com sucesso!" 
							
				//Chama funcao de faturamento
				//StartJob( "U_FATW008", getenvserver()/*"ws_teste"*/, .F., cNum )
				U_FATW008(cNum) //
				
			EndIf
	
		
Else
	cRet+="Usu�rio n�o � vendedor no Protheus, pedido n�o importado! "+aCabec[4]
EndIF

//END TRANSACTION

Return cRet                

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �picVal    �Autor  �Fabricio Antunes    � Data �  03/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para retornar a picture correta de valores em       ���
���          � moeda (tratado como texto)                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function picVal (cValor)
	Local nTamanho:=Len(cValor) //13
	Local nPosP:=At(".",cValor) //12
	Local aPart:={}
	Local cRet:=''
	
	If nTamanho - nPosP = 1
	     cValor:=cValor+"0"
	EndIF 
	
	IF nTamanho - nPosP = 0
	     cValor:=cValor+"00"
	EndIF 
	
	IF nPosP = 0
		cValor:=cValor+".00"
	EndIF
	
	cValor:=Strtran(cValor,'.',",")  
	cInt:=SubStr(cValor,1,Len(cValor)-3)
    cDec:=SubStr(cValor,Len(cValor)-2,3)
    nQuant:=Int(Len(cInt)/3)
    
    For nx:=1 to nQuant
    	AADD(aPart,SubStr(cInt,Len(cInt)-2,3))
    	cInt:=SubStr(cInt,1,Len(cInt)-3)
    Next
	
	AADD(aPart,cInt)
	
	For nx:=Len(aPart) to 1 step -1
		IF Alltrim(aPart[nx]) <> ''
			cRet+=aPart[nx]+'.'		
		EndIF
	Next
	cRet:="R$"+SubStr(cRet,1,Len(cRet)-1)+cDec	
 
Return (cRet) 