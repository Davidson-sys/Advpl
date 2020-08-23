#INCLUDE "RWMAKE.CH"          
#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "topconn.ch"      
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'parmtype.ch'

Static __aUserLg := {}

//-----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} MSE3440
O ponto de entrada MSE3440 será utilizado no tratamento complementar para gravação da comissão(SE3).
Ponto de entrada chamado somente quando selecionado o recalculo pela baixa.
MSE3440 - Utilizado no tratamento complementar para gravação
( < nDescont> , < nJuros> , < cOrigem> ) --> URET            

Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 28/03/2017
@version P11 R8
/*/
//-------------------------------------------------------------------------------------------------------  
User Function MSE3440()   

Local _cFFilial		:= SE3->E3_FILIAL    
Local _cCliente		:= SE3->E3_CODCLI
Local _cLoja		:= SE3->E3_LOJA 
Local _cNumTit 		:= SE3->E3_NUM
Local _cPrefix 		:= SE3->E3_PREFIXO
Local _cTipo		:= SE3->E3_TIPO
Local _cPedido 		:= SE3->E3_PEDIDO
Local _nParcela		:= SE3->E3_PARCELA
Local _nValSld		:= SE1->E1_SALDO
Local _nValOrig		:= SE1->E1_VALOR
Local _dVencOrig	:= SE3->E3_VENCTO 
Local _dtbaixa		:= SE1->E1_BAIXA   
Local _cNatureza	:= SE1->E1_NATUREZ
Local _nSeq			:= SE3->E3_SEQ    
Local _nValBx 		:= SE3->E3_BASE	  //IIF(_nValSld > 0 ,SE3->E3_BASE,SE1->E1_VALOR -_nValSld)
Local _cFops		:= SuperGetMv("NT_CFCOMISS",.F.,"5101")  
Local _cTAbZZs		:= "Nao encontrado"   
Local _cNum			:= ""
Local _cCondRel		:= ""
Local _cTAbZZs		:= ""  
Local _cSitTrib		:= ""
Local _cEstado		:= "" 
Local _cTabela		:= "" 
Local _cCodPrd		:= ""
Local _cCondPg		:= ""
Local _cVendedor	:= ""
Local _cNomeVend	:= ""
Local _cNomSuper	:= ""   
Local _cDescTab		:= ""
Local _dEmissao		:= ""
Local _dDtata1		:= ""
Local _dDtata2		:= ""
Local _dDtata3		:= ""
Local _dDtata4		:= "" 
Local _cPedido		:= ""
Local _cDescric		:= ""
Local _cCodSup		:= ""
Local _dDtaVigen	:= ""
Local _cDescCond	:= "" 
Local _cMotvBaixa	:= ""
Local _cBanco		:= ""
Local _nValComiss	:= 0
Local _nPercent		:= 0 
Local _Nyx			:= 0 
Local _nEncarg		:= 0         
Local _nQTdParc		:= 0          
Local _nBaseComiss	:= 0
Local _nPerComiss	:= 0
Local _nVlComiss	:= 0
Local _nVlTbPreco 	:= 0
Local _nMaxVlrTb	:= 0
Local _nPercTrib	:= 0 
Local _nQtdVend		:= 0
Local _nPrcUnit		:= 0
Local _nFreteUnit	:= 0
Local _nFrTotal		:= 0
Local _nVlTotal		:= 0
Local _nImposto		:= 0	
Local _aProds		:= {} 
Local _aGrava		:= {}
Local _lRet			:= .T.
Local _aAreaTbl		:= GetArea()
		
//------------------------------------------------------------
//Tratamento para buscar titulos LIQ - Renegociações Nutratta.
//------------------------------------------------------------
//If Padr(_cNumTit,9) $ '000024427' .Or.  Padr(_cNumTit,9) $ '000024427'

	//------------------------------------------------------------
	//Tratamento para buscar titulos LIQ - Renegociações Nutratta.
	//------------------------------------------------------------
	If _cTipo $ 'LIQ'
	
		dbSelectArea("FI7")
		dbGotop()
		While !Eof()
		
			dbSelectArea("FI7")//(1)FI7_FILIAL+FI7_PRFORI+FI7_NUMORI+FI7_PARORI+FI7_TIPORI+FI7_CLIORI+FI7_LOJORI                                                                                    
			dbSetOrder(2) //(2)FI7_FILIAL+FI7_PRFDES+FI7_NUMDES+FI7_PARDES+FI7_TIPDES+FI7_CLIDES+FI7_LOJDES
			If dbSeek(_cFFilial+_cPrefix+_cNumTit+Padr(_nParcela,2)+'NF')
				
				_cNumTit	:=	FI7->FI7_NUMORI
				Exit //Encontrou a NF sai do lopp
			EndIf
		dbSelectArea("FI7")	
		dbSkip()
		End
	EndIf
	
	//--------------------------------------------------------------------------------
	// Pega os dados do cabeçalho do pedido de vendas
	//--------------------------------------------------------------------------------
	dbSelectArea("SC5")                                                                                                                          
	dbSetOrder(11) //C5_FILIAL+C5_CLIENTE+C5_LOJACLI+C5_NUM
	If dbSeek(Padr(_cFFilial,4)+Padr(_cNumTit,9))
		
		_cTipo			:=	SC5->C5_TIPO
		_cTabela		:=	SC5->C5_TABELA
		_cCondPg		:=	SC5->C5_CONDPAG
		_cVendedor		:=	SC5->C5_VEND1
		_cCliente		:=	SC5->C5_CLIENTE
		_cLoja			:=	SC5->C5_LOJACLI
		_cPedido		:=	SC5->C5_NUM		
		_dEmissao		:=	SC5->C5_EMISSAO
		_dDtata1		:= 	SC5->C5_DATA1
		_dDtata2		:= 	SC5->C5_DATA2
		_dDtata3		:= 	SC5->C5_DATA3
		_dDtata4		:= 	SC5->C5_DATA4
				
		//-------------------------------------------------------------
		//Posiciona na SC6 para buscar as informações do produto.
		//-------------------------------------------------------------
		dbSelectArea("SC6")
		dbSetOrder(4)                                                              
		If dbSeek(Padr(_cFFilial,4)+Padr(_cNumTit,9))
	
			//-Verifica se o pedido é venda atraves da CFOP.
			If	Alltrim(SC6->C6_CF) $ _cFops      	
				
				While !Eof() .And. SC6->C6_NOTA == Padr(_cNumTit,9)
		   		
		   			_cItem		:= SC6->C6_ITEM
					_cCodPrd	:= SC6->C6_PRODUTO
					_cDescric	:= SC6->C6_DESCRI
					_nQtdVend	:= SC6->C6_QTDVEN
					_nValFrete	:= SC6->C6_C_FRETE
					_nPrcUnit	:= SC6->C6_C_VLRDI //SC6->C6_PRCVEN com C6_VLRDI é o correto- 04/09/2019.
					_nFreteUnit	:= SC6->C6_C_FRETE
					_nFrTotal	:= SC6->C6_C_FRETE * SC6->C6_QTDVEN
					_nVlTotal	:= SC6->C6_VALOR
			   	     
				   	//--------------------------------------------------------------------------------
					//Calculo Total do frete
					//--------------------------------------------------------------------------------
					_nFreteUnit	:=	SC6->C6_C_FRETE
					_nTotFrete	:= _nFreteUnit * _nQtdVend
				
					//--------------------------------------------------------------------------------
					//Calculo Imposto
					//--------------------------------------------------------------------------------
					_nImposto	:=	0	//(_nValBrut * _nPercTrib)
					_nPercTrib	:=	_nPercTrib * 0.1
			   		
			   		//--------------------------------------------------------------------------------
					//Montagem do Array para realizar o calculo de comissão.
					// As 14 primeiras posições são referentes à busca de dados de comissionamento.
					// As 16 ultimas posições são referente ao processo de gravação.
					//--------------------------------------------------------------------------------
					AAdd(_aProds,{_cFFilial,_cTabela,_cCodPrd,_cCondPg,_cVendedor,_nQtdVend,_nPrcUnit,_nFreteUnit,;
								  _dEmissao,_dDtata1,_dDtata2,_dDtata3,_dDtata4,_cSitTrib,;		          
				     			  _cItem,_cPedido,_cNumTit,_cDescric,_nFrTotal,_nVlTotal,;
								  _cCliente,_cLoja,_cEstado,_nImposto,;
								  _nValOrig,_dVencOrig,_nValSld,_nValBx,_dtbaixa,_cPrefix,_nSeq})					  
					  	             			
				SC6->(dbSkip())	
				End             
			EndIf
		EndIf		
	EndIf
	
	
	For _Nyx:= 1 To Len(_aProds)
	                        
	
		//----------------------------------------------------------------------------------------------------
		// Busca a base da comissão na função especifica. DA1
		//----------------------------------------------------------------------------------------------------
		_nBaseComiss:= U_NT_GETCOMSS(Padr(_aProds[_Nyx][1],4),_aProds[_Nyx][2],_aProds[_Nyx][3],_aProds[_Nyx][4],_aProds[_Nyx][5],_aProds[_Nyx][6],_aProds[_Nyx][7],_aProds[_Nyx][8],_aProds[_Nyx][9],_aProds[_Nyx][10],_aProds[_Nyx][11],_aProds[_Nyx][12],_aProds[_Nyx][13],_aProds[_Nyx][14],1)

		//----------------------------------------------------------------------------------------------------
		// Busca o percentual de comissao na tabela especifica
		//----------------------------------------------------------------------------------------------------
		_nPerComiss:= U_NT_GETCOMSS(Padr(_aProds[_Nyx][1],4),_aProds[_Nyx][2],_aProds[_Nyx][3],_aProds[_Nyx][4],_aProds[_Nyx][5],_aProds[_Nyx][6],_aProds[_Nyx][7],_aProds[_Nyx][8],_aProds[_Nyx][9],_aProds[_Nyx][10],_aProds[_Nyx][11],_aProds[_Nyx][12],_aProds[_Nyx][13],_aProds[_Nyx][14],2)

		//----------------------------------------------------------------------------------------------------
		// Busca o valor a ser comissionado e grava o percentual e valor nos campos do orçamento.
		//----------------------------------------------------------------------------------------------------
		_nVlComiss  := U_NT_GETCOMSS(Padr(_aProds[_Nyx][1],4),_aProds[_Nyx][2],_aProds[_Nyx][3],_aProds[_Nyx][4],_aProds[_Nyx][5],_aProds[_Nyx][6],_aProds[_Nyx][7],_aProds[_Nyx][8],_aProds[_Nyx][9],_aProds[_Nyx][10],_aProds[_Nyx][11],_aProds[_Nyx][12],_aProds[_Nyx][13],_aProds[_Nyx][14],3)
		
		//----------------------------------------------------------------------------------------------------
		// Busca preço encontrado na tabela de preço.
		//----------------------------------------------------------------------------------------------------
		_nVlTbPreco := U_NT_GETCOMSS(Padr(_aProds[_Nyx][1],4),_aProds[_Nyx][2],_aProds[_Nyx][3],_aProds[_Nyx][4],_aProds[_Nyx][5],_aProds[_Nyx][6],_aProds[_Nyx][7],_aProds[_Nyx][8],_aProds[_Nyx][9],_aProds[_Nyx][10],_aProds[_Nyx][11],_aProds[_Nyx][12],_aProds[_Nyx][13],_aProds[_Nyx][14],4)
		
		//----------------------------------------------------------------------------------------------------
		// Busca preço encontrado na tabela de preço.
		//----------------------------------------------------------------------------------------------------
		_nMaxVlrTb  := U_NT_GETCOMSS(Padr(_aProds[_Nyx][1],4),_aProds[_Nyx][2],_aProds[_Nyx][3],_aProds[_Nyx][4],_aProds[_Nyx][5],_aProds[_Nyx][6],_aProds[_Nyx][7],_aProds[_Nyx][8],_aProds[_Nyx][9],_aProds[_Nyx][10],_aProds[_Nyx][11],_aProds[_Nyx][12],_aProds[_Nyx][13],_aProds[_Nyx][14],5)
		
		//----------------------------------------------------------------------------------------------------
		//Retorna a tabela de comissionamento encontrada
		//----------------------------------------------------------------------------------------------------
	    _cTAbZZs    := U_NT_GETCOMSS(Padr(_aProds[_Nyx][1],4),_aProds[_Nyx][2],_aProds[_Nyx][3],_aProds[_Nyx][4],_aProds[_Nyx][5],_aProds[_Nyx][6],_aProds[_Nyx][7],_aProds[_Nyx][8],_aProds[_Nyx][9],_aProds[_Nyx][10],_aProds[_Nyx][11],_aProds[_Nyx][12],_aProds[_Nyx][13],_aProds[_Nyx][14],6)
		 
		//----------------------------------------------------------------------------------------------------
		// Retorna a condição de pagamento que deverá ser impressa no relatorio.
		//----------------------------------------------------------------------------------------------------
		_cCondRel	:= U_NT_GETCOMSS(Padr(_aProds[_Nyx][1],4),_aProds[_Nyx][2],_aProds[_Nyx][3],_aProds[_Nyx][4],_aProds[_Nyx][5],_aProds[_Nyx][6],_aProds[_Nyx][7],_aProds[_Nyx][8],_aProds[_Nyx][9],_aProds[_Nyx][10],_aProds[_Nyx][11],_aProds[_Nyx][12],_aProds[_Nyx][13],_aProds[_Nyx][14],7)
		 
		//----------------------------------------------------------------------------------------------------
		//Quantidade de parcelas
		//----------------------------------------------------------------------------------------------------		
		_nQTdParc   := U_NT_GETCOMSS(Padr(_aProds[_Nyx][1],4),_aProds[_Nyx][2],_aProds[_Nyx][3],_aProds[_Nyx][4],_aProds[_Nyx][5],_aProds[_Nyx][6],_aProds[_Nyx][7],_aProds[_Nyx][8],_aProds[_Nyx][9],_aProds[_Nyx][10],_aProds[_Nyx][11],_aProds[_Nyx][12],_aProds[_Nyx][13],_aProds[_Nyx][14],8)
		
		//----------------------------------------------------------------------------------------------------
		// Historico do comissionamento preço de tabela,preço maximo e preço praticado.
		//----------------------------------------------------------------------------------------------------
		_Historico	:= U_NT_GETCOMSS(Padr(_aProds[_Nyx][1],4),_aProds[_Nyx][2],_aProds[_Nyx][3],_aProds[_Nyx][4],_aProds[_Nyx][5],_aProds[_Nyx][6],_aProds[_Nyx][7],_aProds[_Nyx][8],_aProds[_Nyx][9],_aProds[_Nyx][10],_aProds[_Nyx][11],_aProds[_Nyx][12],_aProds[_Nyx][13],_aProds[_Nyx][14],9)

		//----------------------------------------------------------------------------------------------------
		// Retorna infomações do cliente
		//----------------------------------------------------------------------------------------------------
		_cNomeCli	:= FACADVEND(_aProds[_Nyx][21],_aProds[_Nyx][22],_aProds[_Nyx][5],_aProds[_Nyx][3],_aProds[_Nyx][2],_cCondRel,Padr(_aProds[_Nyx][1],4),_cPrefix,_cNumTit,_nParcela,1) 
		_cEstado  	:= FACADVEND(_aProds[_Nyx][21],_aProds[_Nyx][22],_aProds[_Nyx][5],_aProds[_Nyx][3],_aProds[_Nyx][2],_cCondRel,Padr(_aProds[_Nyx][1],4),_cPrefix,_cNumTit,_nParcela,2) 
	    
	   	//----------------------------------------------------------------------------------------------------
		// Retorna infomações do vendedor e supervisor
		//----------------------------------------------------------------------------------------------------
		_cNomeVend 	:= FACADVEND(_aProds[_Nyx][21],_aProds[_Nyx][22],_aProds[_Nyx][5],_aProds[_Nyx][3],_aProds[_Nyx][2],_cCondRel,Padr(_aProds[_Nyx][1],4),_cPrefix,_cNumTit,_nParcela,3) 
		_cCodSup	:= FACADVEND(_aProds[_Nyx][21],_aProds[_Nyx][22],_aProds[_Nyx][5],_aProds[_Nyx][3],_aProds[_Nyx][2],_cCondRel,Padr(_aProds[_Nyx][1],4),_cPrefix,_cNumTit,_nParcela,4) 
		_cNomSuper	:= FACADVEND(_aProds[_Nyx][21],_aProds[_Nyx][22],_aProds[_Nyx][5],_aProds[_Nyx][3],_aProds[_Nyx][2],_cCondRel,Padr(_aProds[_Nyx][1],4),_cPrefix,_cNumTit,_nParcela,5) 
		_cDescTab   := FACADVEND(_aProds[_Nyx][21],_aProds[_Nyx][22],_aProds[_Nyx][5],_aProds[_Nyx][3],_aProds[_Nyx][2],_cCondRel,Padr(_aProds[_Nyx][1],4),_cPrefix,_cNumTit,_nParcela,6)
	
		//----------------------------------------------------------------------------------------------------
		// Retorna informações referente a tabela de preço.
		//----------------------------------------------------------------------------------------------------	   
		_dDtaVigen	:= FACADVEND(_aProds[_Nyx][21],_aProds[_Nyx][22],_aProds[_Nyx][5],_aProds[_Nyx][3],_aProds[_Nyx][2],_cCondRel,Padr(_aProds[_Nyx][1],4),_cPrefix,_cNumTit,_nParcela,7)
		_cDescCond 	:= FACADVEND(_aProds[_Nyx][21],_aProds[_Nyx][22],_aProds[_Nyx][5],_aProds[_Nyx][3],_aProds[_Nyx][2],_cCondRel,Padr(_aProds[_Nyx][1],4),_cPrefix,_cNumTit,_nParcela,8)  
		
		//----------------------------------------------------------------------------------------------------
		// Retorna o motivo da baixa e o banco da baixa.
		//----------------------------------------------------------------------------------------------------	   
		_cMotvBaixa	:= FACADVEND(_aProds[_Nyx][21],_aProds[_Nyx][22],_aProds[_Nyx][5],_aProds[_Nyx][3],_aProds[_Nyx][2],_cCondRel,Padr(_aProds[_Nyx][1],4),_cPrefix,_cNumTit,_nParcela,9)
		_cBanco 	:= FACADVEND(_aProds[_Nyx][21],_aProds[_Nyx][22],_aProds[_Nyx][5],_aProds[_Nyx][3],_aProds[_Nyx][2],_cCondRel,Padr(_aProds[_Nyx][1],4),_cPrefix,_cNumTit,_nParcela,10)
		_cTipDoc 	:= FACADVEND(_aProds[_Nyx][21],_aProds[_Nyx][22],_aProds[_Nyx][5],_aProds[_Nyx][3],_aProds[_Nyx][2],_cCondRel,Padr(_aProds[_Nyx][1],4),_cPrefix,_cNumTit,_nParcela,11)		 		 		 
		_cSituac 	:= FACADVEND(_aProds[_Nyx][21],_aProds[_Nyx][22],_aProds[_Nyx][5],_aProds[_Nyx][3],_aProds[_Nyx][2],_cCondRel,Padr(_aProds[_Nyx][1],4),_cPrefix,_cNumTit,_nParcela,12)		 		 		 		
		//--------------------------------------------------------------------------------
		//Montagem do Array para realizar a gravação 
		//--------------------------------------------------------------------------------
		AAdd(_aGrava,{Padr(_aProds[_Nyx][1],4),;  //_cFFilial
					Padr(_aProds[_Nyx][2],3),;  // _cTabela
					Padr(_aProds[_Nyx][3],15),; // _cCodPrd
					Padr(_aProds[_Nyx][4],3),;  // _cCondPg
					Padr(_aProds[_Nyx][5],6),;  // _cVendedor
						 _aProds[_Nyx][6],;     // _nQtdVend
						 _aProds[_Nyx][7],;     // _nPrcUnit
						 _aProds[_Nyx][8],;     // _nFreteUnit
					     _aProds[_Nyx][9],;     // _dEmissao
					     _aProds[_Nyx][10],;    // _dDtata1
					     _aProds[_Nyx][11],;    // _dDtata2			
		   				 _aProds[_Nyx][12],;    // _dDtata3
		   				 _aProds[_Nyx][13],;    // _dDtata4
		   				 _aProds[_Nyx][14],;    // _cSitTrib
		   				 _aProds[_Nyx][15],;    // _cItem
		   				 _aProds[_Nyx][16],;    // _cPedido
		   				 _aProds[_Nyx][17],;    // _cNumTit
		   				 _aProds[_Nyx][18],;    // _cDescric
		   				 _aProds[_Nyx][19],;    // _nFrTotal
		   				 _aProds[_Nyx][20],;    // _nVlTotal
		   				 _aProds[_Nyx][21],;    // _cCliente
		   				 _aProds[_Nyx][22],;    // _cLoja
		   				 _cEstado,;			    // _cEstado
		   				 _aProds[_Nyx][24],;    // _nImposto
		   				 _aProds[_Nyx][25],;    // _nValOrig
		   				 _aProds[_Nyx][26],;    // _dVencOrig
		   				 _aProds[_Nyx][27],;    // _nValSld
		   				 _aProds[_Nyx][28],;    // _nValBx
		   				 _aProds[_Nyx][29],;    // _dtbaixa
		   				 _aProds[_Nyx][30],;    // _cPrefix
						 _nBaseComiss,;         //31
						 _nPerComiss,;          //32
						 _nVlComiss,;           //33
						 _nEncarg,;             //34
						 _cCondRel,;            //35
						 _nQTdParc,;            //36
						 _nParcela,;            //37
						 _cTAbZZs,;             //38
						 _aProds[_Nyx][31],;    //39 // _Seq -
						 _cDescTab ,;           //40
						 _cCodSup ,;            //41
						 _cNomSuper,;			//42
						 _cNomeVend ,;			//43                         
						 _cDescCond ,;          //44					 
						 _Historico,;			//45
						 _cBanco ,;				//46
						 _cMotvBaixa,;          //47 
						 _cTipDoc,;         	//48
						 _cSituac})          	//49 
						 						      
	Next _Nyx
//EndIf
    
//--------------------------------------------------------------------------------
//Chamada da função para gravação dos dados de comissão.
//--------------------------------------------------------------------------------
If Len(_aGrava) > 0

	FA440GRVDADOS(_aGrava)	
EndIf
RestArea(_aAreaTbl)
Return

  

//--------------------------------------------------------------------------
/*/ {Protheus.doc} FA440GRVDADOS
Função para gravação na tabela de extrado de comissões.

Tabela: ZZA -Tabela de comissionamento.

Retorno
Valor de comissão calculado.

Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 10/03/2017
@version P11 R8
*/
//--------------------------------------------------------------------------
Static Function FA440GRVDADOS(_aGrava)

Local _aAreaAnt  	:= GetArea()
Local _xYz			:=  0
Local _lExist		:= .T.
Local _nOpc			:=  2
Local _cChave		:= ""

dbSelectArea("ZZA")
dbSetOrder(1)

For _xYz := 1 To Len(_aGrava)
   
	_nBxPorc		:= (_aGrava[_xYz][28]*100)/_aGrava[_xYz][25]
    
	//--------------------------------------------------------------------------------
	// Realiza a gravação na tabela ZZA. 
	//--------------------------------------------------------------------------------               
	If _nOpc == 1 //Comissao padrao pelo vendedor
		_cChave:= Padr(_aGrava[_xYz][1],4)+_aGrava[_xYz][17]+_aGrava[_xYz][37]+_nSeq+_aGrava[_xYz][3]
	ElseIf _nOpc == 2 //Comissao calculada
		_cChave:= Alltrim(Padr(_aGrava[_xYz][1],4)+Padr(_aGrava[_xYz][17],9)+Padr(_aGrava[_xYz][37],2)+Padr(_aGrava[_xYz][39],2)+_aGrava[_xYz][15]+_aGrava[_xYz][3])
	EndIf
	
	dbSelectArea("ZZA")
	dbSetOrder(1)
	If dbSeek(_cChave) //ZZA_FILIAL+ZZA_NOTA+ZZA_NUMPAR+ZZA_SEQ+ZZA_ITEM+ZZA_CODIGO      
		_lExist	:=.F. 
	Else
		_lExist	:=.T.
	EndIf 
	
	dbSelectArea("ZZA")
	RecLock("ZZA",_lExist)
		Replace	ZZA->ZZA_FILIAL  With  Padr(_aGrava[_xYz][1],4)
		Replace	ZZA->ZZA_NOTA	 With  _aGrava[_xYz][17]
		Replace	ZZA->ZZA_NUM	 With  _aGrava[_xYz][16] 
		Replace	ZZA->ZZA_EMISSA  With  _aGrava[_xYz][9]
		Replace	ZZA->ZZA_TABELA  With  Padr(_aGrava[_xYz][2],3)  
		Replace	ZZA->ZZA_DESTAB  With  _aGrava[_xYz][40]
		Replace	ZZA->ZZA_VIGENC  With  _aGrava[_xYz][9]
		Replace	ZZA->ZZA_CLIENT  With  _aGrava[_xYz][21]
		Replace	ZZA->ZZA_LOJA 	 With  _aGrava[_xYz][22]
		Replace	ZZA->ZZA_EST	 With  Alltrim(_aGrava[_xYz][23])
		Replace	ZZA->ZZA_CODSUP	 With  _aGrava[_xYz][41]//_cCodSup
		Replace	ZZA->ZZA_SUPER	 With  _aGrava[_xYz][42]//_cNomSuper
		Replace	ZZA->ZZA_VEND	 With  Padr(_aGrava[_xYz][5],6)
		Replace	ZZA->ZZA_NOME	 With  _aGrava[_xYz][43]//_cNomeVend
		Replace	ZZA->ZZA_ITEM	 With  _aGrava[_xYz][15]
		Replace	ZZA->ZZA_CODIGO	 With  Padr(_aGrava[_xYz][3],15)//_cProduto
		Replace	ZZA->ZZA_DESCRI	 With  _aGrava[_xYz][18]//_cDescric
		Replace	ZZA->ZZA_COND	 With  _aGrava[_xYz][35]//_cCondRel
		Replace	ZZA->ZZA_DESC	 With  _aGrava[_xYz][44]//_cDescCond
		Replace	ZZA->ZZA_PARC  	 With  StrZero(_aGrava[_xYz][36],2) //StrZero(_nQTdParc,2)	
		Replace	ZZA->ZZA_QUANT	 With  _aGrava[_xYz][6] //_nQuant
		Replace	ZZA->ZZA_PRCVEN	 With   _aGrava[_xYz][7]//IIF(_cCondRel=="001",_nPrcVen+(_nPrcVen*2.1)/100,_nPrcVen)
		Replace	ZZA->ZZA_VFRETE	 With  _aGrava[_xYz][8]
		Replace	ZZA->ZZA_TOTFRT	 With  _aGrava[_xYz][8]*_aGrava[_xYz][6] //_nTotFrt
		Replace	ZZA->ZZA_VALOR	 With  _aGrava[_xYz][6] *_aGrava[_xYz][7] //_nPrcTot
		Replace	ZZA->ZZA_TRIB	 With   _aGrava[_xYz][24]//_nImposto 
		Replace	ZZA->ZZA_NUMPAR	 With   Padr(_aGrava[_xYz][37],2) //_cNumParc 	                   
		Replace	ZZA->ZZA_VALORG	 With  _aGrava[_xYz][25]//_nValOrig	
		Replace	ZZA->ZZA_VENORI	 With  _aGrava[_xYz][26]//_dVencOrig	 	
		Replace	ZZA->ZZA_VLSALD	 With  _aGrava[_xYz][25] - _aGrava[_xYz][28]//_nValOrig-_nValBx	 	
		Replace	ZZA->ZZA_VLBAIXA With  _aGrava[_xYz][28]//_nValBx	 	
		Replace	ZZA->ZZA_DTBAIX	 With  _aGrava[_xYz][29]//_dtbaixa	    
		Replace	ZZA->ZZA_BXPROP	 With  _nBxPorc
		Replace	ZZA->ZZA_BASE	 With  _aGrava[_xYz][31]//_nBaseComiss
		Replace	ZZA->ZZA_PERCO	 With  _aGrava[_xYz][32]//_nPercent
		Replace	ZZA->ZZA_COMISS  With  _aGrava[_xYz][33]//_nValComiss
		Replace	ZZA->ZZA_PERENC  With  _aGrava[_xYz][34]//_nEncarg
		Replace	ZZA->ZZA_VALENC  With  _aGrava[_xYz][28] * (_aGrava[_xYz][34]/100)//_nValBx * (_nEncarg/100)
		Replace	ZZA->ZZA_SEQ	 With  _aGrava[_xYz][39]//_nSeq   
		Replace	ZZA->ZZA_PREFIX  With  _aGrava[_xYz][30]//_cPrefix   
		Replace	ZZA->ZZA_TBLZZ   With  _aGrava[_xYz][45]+" - "+_aGrava[_xYz][38]//_cTAbZZs  //C 3  
		Replace	ZZA->ZZA_MOTBX   With  _aGrava[_xYz][46]//Motivo Baixa
		Replace	ZZA->ZZA_BXANT   With  _aGrava[_xYz][47]//Banco da baixa
		Replace	ZZA->ZZA_TPDOC   With  _aGrava[_xYz][48]//Tipo Documento
		Replace	ZZA->ZZA_SITUA   With  _aGrava[_xYz][49]//Situacao Titulo

	MsUnlock() 
	
Next _xYz

RestArea(_aAreaAnt)
Return


//--------------------------------------------------------------------------
/*/ {Protheus.doc} FACADVEND
Função para retornar dados cadastrais 
Produtos
Clientes
Vendedores 
Tabelas de preço 
TES 
Informações complementares

Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 27/06/2019
@version P 12
*/
//--------------------------------------------------------------------------
Static Function FACADVEND(_cCliente,_cLoja,_cVendedor,_cProduto,_cCodTab,_cCondRel,_cFFilial,_cPrefix,_cNumTit,_nParcela,_nOpc) 
                          
Local _cNomeCli	:= ""
Local _cEstado	:= ""
Local _cSitTrib	:= ""
Local _cNomeVend:= "" 
Local _cCodSup	:= ""
Local _cNomSuper:= ""
Local _dDtaVigen:= "" 
Local _cDescCond:= "" 
Local _cDescTab	:= "" 
Local _cTipDoc  := ""   
Local  _cSituac := ""  
Local _nRetorno	:= ""
Local _nPercTrib:= 0
Local _aAreaAnt := GetArea()

//-----------------------------------------------
// Dados do cliente.
//----------------------------------------------
dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek(xFilial("SA1")+Padr(_cCliente,8)+Padr(_cLoja,4))
	
	_cEstado := SA1->A1_EST
	
	If  _cEstado $ "GO"
		_cSitTrib	:="D"
		_nPercTrib	:= 9.25/100  //0.0925
	Else
		_cSitTrib	:="F"
		_nPercTrib	:= 14.05/100  //0.1405
	EndIf
EndIf		

//--------------------------------------------------------------------------------
//Posiciona na SA3 para buscar as informações do Vendedor
//--------------------------------------------------------------------------------
dbSelectArea("SA3")
dbSetOrder(1)
If dbSeek(xFilial("SA3")+Padr(_cVendedor,6))

   _cNomeVend	:= SA3->A3_NOME   
   _cCodSup		:= SA3->A3_SUPER 
EndIf 

//--------------------------------------------------------------------------------
//Posiciona na SA3 para buscar as informações do supervisor.
//--------------------------------------------------------------------------------
dbSelectArea("SA3")
dbSetOrder(1)
If dbSeek(xFilial("SA3")+_cCodSup)

	_cNomSuper	:= SA3->A3_NOME 
EndIf  

//--------------------------------------------------------------------------------
//Busca as informações da tabela de preço. Cabeçalho.
//--------------------------------------------------------------------------------
dbSelectArea("DA0")
dbSetOrder(1)
If dbSeek(xFilial("DA0")+_cCodTab) //DA1_FILIAL+DA1_CODTAB+DA1_CODPRO

	_cDescTab	:= DA0->DA0_DESCRI
EndIf 
//--------------------------------------------------------------------------------
//Busca as informações da tabela de preço. Itens
//--------------------------------------------------------------------------------
dbSelectArea("DA1")
dbSetOrder(1)
If dbSeek(xFilial("DA1")+_cCodTab+_cProduto) //DA1_FILIAL+DA1_CODTAB+DA1_CODPRO

	_dDtaVigen	:= DA1->DA1_DATVIG
EndIf 
    
//--------------------------------------------------------------------------------
//Busca as informações da tabela de preço.
//--------------------------------------------------------------------------------
dbSelectArea("SE4")
dbSetOrder(1)
If dbSeek(xFilial("SE4")+_cCondRel) //E4_FILIAL+E4_CODIGO

	_cDescCond:=SE4->E4_DESCRI
EndIf

//--------------------------------------------------------------------------------
//Busca informações referente a Titulo Baixado.SE5
//--------------------------------------------------------------------------------
dbSelectArea("SE5")
dbSetOrder(7) //Posicione("SE5",7,(cAliasZZA)->(ZZA_FILIAL)+(cAliasZZA)->(ZZA_PREFIXO)+(cAliasZZA)->(ZZA_NOTA)+(cAliasZZA)->(ZZA_NUMPAR),"E5_MOTBX") 
If dbSeek(xFilial("SE5")+_cPrefix+_cNumTit+_nParcela) //Filial+Prefixo+Nota+Parcela 
	
	_cMotvBaixa :=SE5->E5_MOTBX
	_cBanco		:=SE5->E5_BANCO
	_cTipDoc    :=SE5->E5_TIPODOC
	_cSituac    :=SE5->E5_SITUACA	
EndIf


///-----------------------------------------------------------------------------------------
// Retornos possveis. // Clientes,Vendedores e tabelas de preço.   
//------------------------------------------------------------------------------------------
If _nOpc == 1  //Nome do Cliente 
	_nRetorno:= _cNomeCli 

ElseIf _nOpc == 2 	//Estado do Cliente
	_nRetorno:= _cEstado  

ElseIf _nOpc == 3	//Nome do vendedor
	_nRetorno:= _cNomeVend 

ElseIf _nOpc == 4	//Retorna o codigo do supervisor
	_nRetorno:= _cCodSup	

ElseIf _nOpc == 5 	//Retorna o nome do supervisor
	_nRetorno:= _cNomSuper		

ElseIf _nOpc == 6 	//Retorna a descrição da tabela
	_nRetorno:= _cDescTab			

ElseIf _nOpc == 7 	//Retorna a data da vigencia
	_nRetorno:= _dDtaVigen

ElseIf _nOpc == 8 	//Retorna a descrição da cond pagamento.
	_nRetorno:= _cDescCond
	
ElseIf _nOpc == 9 	//Retorna o motivo da baixa
	_nRetorno:= _cMotvBaixa
	
ElseIf _nOpc == 10 	//Retorna o banco da baixa
	_nRetorno:= _cBanco
ElseIf _nOpc == 11 	//Retorna tipo do documento TR=Transferência
	_nRetorno:= _cTipDoc    

ElseIf _nOpc == 12 	//Retorna a situação da baixa C =Cancelado
	_nRetorno:= _cSituac    
EndIf

RestArea(_aAreaAnt)
Return(_nRetorno) 
 

