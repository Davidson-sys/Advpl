#INCLUDE "RWMAKE.CH"          
#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "topconn.ch"      
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#include 'parmtype.ch'   

/*
========================================================================================================================
Rotina----: NAFAT07
Autor-----: Davidson Clayton
Data------: 15/05/2018
========================================================================================================================
Descrição-: Rotina para encapsulada no relatorio de faturamento MATR550
Uso-------: Chamada antes do processamento do relatorio,com a finalidadade de 
atualizar dos campos D2_C_PERCO- Percentual de comissão e D2_C_VLCOM - Valor de comissão.
========================================================================================================================
*/

User Function NAFAT07()

Local _nOpc		:=	0
Private oProcess

_nOpc := Aviso("P R O V I S A O - C O M I S S A O ",;
+Chr(13)+Chr(10)+Chr(13)+Chr(10);
+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
"Deseja calcular a provisão de comissão para as Notas emitidas no periodo?",{"Voltar","Calcular"},2)

If _nOpc == 1	
	Return       
ElseIf _nOpc == 2  
    
    //Realiza o processamento dos dados.
	Processa( {|| fFAT07PSearch() }, "Localizando dados...", "Localizando dados...",.F.)  
	 
    oProcess := MsNewProcess():New( { || fFAT07Processa() } ,"Atualizando registros...", "Analisando registros..." , .F. )
	oProcess:Activate() 
   	MsgBox("Dados atualizados,Favor verificar!!","Mensagem","Info")	                  
EndIf

Return
   

/*
========================================================================================================================
Rotina----: fFAT07PSearch
Autor-----: Davidson Clayton
Data------: 15/05/2018
========================================================================================================================
Descrição-: Localiza os registros na base de dados de acordo com os parametros.
Uso-------:Especifico Nutratta 
========================================================================================================================
*/
Static Function	fFAT07PSearch()

Local _cEmiss	:= DTOS(DDATABASE)
Local _cEmiDe	:= DTOS( MV_PAR03)
Local _cEmiAte	:= DTOS( MV_PAR04)
Local _cMsgRet  := ""
Local _cQuery   := ""
Local _nReg		:=	0

_cQuery := "	SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_PEDIDO,D2_EMISSAO AS DTA," + CRLF
_cQuery += "	D2_CLIENTE,D2_LOJA,D2_C_PERCO,D2_C_VLCOM,D2_C_EMISS,D2_C_TABEL,D2_C_MOTIV,D2_CF,D2_QUANT,D2_PRCVEN" + CRLF
_cQuery += "	FROM "+ RetSqlName("SD2") + CRLF          
_cQuery += "	WHERE D2_EMISSAO 	 >= '"+ _cEmiDe +"' AND" +CRLF
_cQuery += "	D2_EMISSAO 	 <= '"+ _cEmiAte 	    +"' AND" +CRLF
_cQuery += "	D2_FILIAL 	 <> '0201' AND" +CRLF
_cQuery += "	D_E_L_E_T_ = ' '"			+CRLF
_cQuery += "	ORDER BY D2_EMISSAO	"		+CRLF  

//_cQuery += "	WHERE D2_EMISSAO BETWEEN  '"+ _cEmiDe +"'" AND "'"+ _cEmiAte +"' AND"+CRLF
//_cQuery += "	WHERE D2_DOC 	 = '"+ _cDoc +"' AND" +CRLF
//_cQuery += "	 D2_SERIE 	 = '"+ _cSerie 	 +"' AND" +CRLF
//_cQuery += "	 D2_CLIENTE = '"+ _cCliente +"' AND" +CRLF
//_cQuery += "	 D2_LOJA    = '"+ _cLoja    +"' AND" +CRLF 
                                                           
_cQuery := ChangeQuery(_cQuery) 

dbUseArea(.T., "TOPCONN", TCGenQry(, , _cQuery), "TSD2", .F., .T.)

Return(_nReg)   


/*
========================================================================================================================
Rotina----: fFAT07Processa
Autor-----: Davidson Clayton
Data------: 15/05/2018
========================================================================================================================
Descrição-: Executa o processamento para recalculo da provisão de comissão.
Uso-------:Especifico Nutratta 
========================================================================================================================
*/

Static Function	fFAT07Processa()

Local _cMsgRet  := ""
Local _cQuery   := ""
Local _cFiLOrc	:= ""
Local _cNFiscal	:= ""
Local _cSerie	:= ""
Local _cProduto	:= ""
Local _cItem	:= ""
Local _cFop		:= ""
Local _cCliente	:= ""
Local _cLoja	:= ""
Local _cNumPv	:= ""
Local _cTipVend	:= ""
Local _cNomeCli	:= ""
Local _cTabela	:= "" 
Local _dEmissao	:= ""	
Local _cMotivo 	:= ""
Local _cSitTrib	:= "" 
Local _cEstado	:= ""
Local _nReg		:=	0 
Local _nx1      :=  0 
Local _nOpc		:=  0 
Local _nPrcVen	:=  0  
Local _nPrecUnit:=  0  
Local _nQuant	:=  0
Local _aDados	:= {}
Local lEnd

				
dbSelectArea("TSD2") 
While !TSD2->(Eof()) 
     
     Aadd(_aDados,{TSD2->D2_FILIAL,TSD2->D2_DOC,TSD2->D2_SERIE,TSD2->D2_ITEM,;
     TSD2->D2_COD,TSD2->D2_PEDIDO,TSD2->D2_CLIENTE,TSD2->D2_LOJA,D2_CF,D2_QUANT,;
     D2_PRCVEN})
     _nReg ++ 
	
	oProcess:SetRegua1(_nReg) 
	oProcess:IncRegua1("Nota fiscal: "+TSD2->D2_DOC+" - Item: "+TSD2->D2_COD)
	
	oProcess:SetRegua2(_nReg) 
	oProcess:IncRegua2("Filial: "+TSD2->D2_FILIAL+" - Pedido: "+TSD2->D2_PEDIDO)
          	     
     TSD2->(dbSkip()) 
End 

//Fecha a tabela  
If _nReg > 0
	dbCloseArea("TSD2")	 
Else
	Return
EndIf 



//Localiza a tabela /	percentual e valor de comissão para a nota fiscal.                    
For nx1:=1 To Len (_aDados) 

	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

	_cFiLOrc	:= 	_aDados[nx1][1]
	_cNFiscal	:=	_aDados[nx1][2]
	_cSerie		:=	_aDados[nx1][3]
	_cProduto	:=	_aDados[nx1][5]
	_cItem		:=	_aDados[nx1][4]
	_cFop  		:=	_aDados[nx1][9]
	_cCliente	:=	_aDados[nx1][7]
	_cLoja		:=	_aDados[nx1][8]
	_cNumPv		:=	_aDados[nx1][6]
    _nQuant		:=	_aDados[nx1][10]
	_nPrcVen	:=	_aDados[nx1][11]
	
	
	//Posiciono no pedido de vendas 
	dbSelectArea("SC5")
	dbSetOrder(3) //C5_FILIAL+C5_CLIENTE+C5_LOJACLI+C5_NUM                                                                                                                          
	If dbSeek(_cFiLOrc+_cCliente+_cLoja+_cNumPv) 
	
		_cCodTab	:=	SC5->C5_TABELA 	 //Tabela de preço
		_cCond		:= 	SC5->C5_CONDPAG  //Condição de pagamento
		_cVendedor	:=	SC5->C5_VEND1    //Codigo do vendedor
		_dEmissao 	:=	SC5->C5_EMISSAO  //Data de emissão do pedido.

		//--------------------------------------------------------------------------------
		//Posiciona na SC6 - pegar o preço unitario sem frete.
		//--------------------------------------------------------------------------------
		dbSelectArea("SC6")
		dbSetOrder(1) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO                                                                                                                         
		If dbSeek(_cFiLOrc+_cNumPv+_cItem+_cProduto) 
		
			_nPrecUnit	:= SC6->C6_C_VLRDI
		EndIf
		
		//--------------------------------------------------------------------------------
		//Posiciona na SA1 para buscar a localização do cliente Dentro ou fora do estado
		//--------------------------------------------------------------------------------
		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbSeek(xFilial("SA1")+_cCliente+_cLoja)
		//dbSeek(xFilial("SA1")+Padr(cCliente,8)+Padr(cLoja,4))
		
			_cEstado	:=SA1->A1_EST 
			_cNomeCli	:=SA1->A1_NOME
						
			If  _cEstado $ "GO"
				_cSitTrib:="D"		      
			Else
				_cSitTrib:="F"
			EndIf	
		EndIf             

		//--------------------------------------------------------------------------------
		//Posiciona na SA3 para buscar as informações do Vendedor/Representante.
		//--------------------------------------------------------------------------------
		dbSelectArea("SA3")
		dbSetOrder(1)
		If dbSeek(xFilial("SA3")+_cVendedor)
			
			_cTipVend	:= SA3->A3_TIPVEND //1=Cooperativa;2=Funcionario;3=Corretora;4=Representante
			_cCodTab	:= SA3->A3_TABELA //
            _cTabela	:= fGetTablela(_dEmissao)
	   		
	   		//--------------------------------------------------------------------------------
			//Realiza o calculo da base da comissão.
			//--------------------------------------------------------------------------------	
			_nBaseComiss:= 	_nQuant  * 	_nPrecUnit
            
	         _cMotivo	:= fGetComiss(_cFiLOrc,_cCodTab,_cProduto,_cCond,_cVendedor,_cTipVend,_dEmissao,_cFop,_cSitTrib,_nBaseComiss,_cTabela,_nPrecUnit,4)        
			_nPercent	:= fGetComiss(_cFiLOrc,_cCodTab,_cProduto,_cCond,_cVendedor,_cTipVend,_dEmissao,_cFop,_cSitTrib,_nBaseComiss,_cTabela,_nPrecUnit,2)
	    	_nValComiss	:= fGetComiss(_cFiLOrc,_cCodTab,_cProduto,_cCond,_cVendedor,_cTipVend,_dEmissao,_cFop,_cSitTrib,_nBaseComiss,_cTabela,_nPrecUnit,3)
	         
			//Tratamento para vendedor padrão
			If _cVendedor == "000004"
	        	_cMotivo:= "VENDEDOR BALCAO"
	        ElseIf	_cVendedor == "000062" 
		        _cMotivo:= "BALCAO FORA DO ESTADO"
	        EndIf
	        
			//Grava os valores na SD2     
//	        If !Empty(_nPercent) .And. _nValComiss > 0   
				
				_nReg:=Len (_aDados)

				oProcess:SetRegua1(Len (_aDados)) 
				oProcess:IncRegua1("Nota fiscal: "+_cNFiscal+" - Item: "+_cProduto)
				
				oProcess:SetRegua2(Len (_aDados)) 
				oProcess:IncRegua2(Alltrim(Substr(_cNomeCli,1,20))+" - Estado: "+Alltrim(_cEstado))     

				fFAT07GrvRegs(_cFiLOrc,_cNFiscal,_cSerie,_cCliente,_cLoja,_cProduto,_cItem,_nPercent,_nValComiss,_cTabela,_cMotivo,_cTipVend,_nPrecUnit,_cSitTrib,_dEmissao)
				
//	        EndIf
        EndIf
    EndIf
Next _nx1

Return
     
     

/*
========================================================================================================================
Rotina----: fGetComiss
Autor-----: Davidson Clayton
Data------: 15/05/2018
========================================================================================================================
Descrição-: Processa o comissionamento de acordo com as tabelas.
Uso-------: 
========================================================================================================================
*/

Static Function fGetComiss(_cFiLOrc,_cCodTab,_cProduto,_cCond,_cVendedor,_cTipVend,_dEmissao,_cFop,_cSitTrib,_nBaseComiss,_cTabela,_nPrecUnit,_nOpc)

Local cFops			:= SuperGetMv("NT_CFCOMISS",.F.,"5101")
Local _aRegs		:= {}  
Local _nValComiss	:= 0
Local _nPercent		:= 0 
Local	_nVal0000	:= 0
Local	_nVal0025	:= 0
Local	_nVal0050	:= 0	
Local	_nVal0075	:= 0
Local 	_nVal0100 	:= 0
Local	_nVal0125	:= 0 
Local	_nVal0150	:= 0               
Local	_nVal0175	:= 0               
Local	_nVal0200	:= 0
Local	_nVal0225	:= 0
Local	_nVal0250	:= 0    
Local	_nVal0275	:= 0
Local	_nVal0300	:= 0
Local	_nVal0325	:= 0
Local	_nVal0350	:= 0
Local	_nVal0375	:= 0                    
Local	_nVal0400	:= 0
Local	_nVal0425	:= 0
Local	_nVal0450	:= 0
Local	_nVal0475	:= 0	
Local	_nVal0500 	:= 0
Local	_nVal0525 	:= 0
Local	_nVal0550 	:= 0
Local	_nVal0575 	:= 0	
Local	_nVal0600 	:= 0
Local	_nVal0625 	:= 0
Local	_nVal0650 	:= 0
Local	_nVal0675 	:= 0
Local	_nVal0700 	:= 0
Local	_nVal0725 	:= 0
Local	_nVal0750 	:= 0
Local	_nVal0775 	:= 0				       
Local	_nVal0800 	:= 0
Local	_nVal0900 	:= 0
Local	_nVal1000 	:= 0
Local	_nVal1100 	:= 0
Local	_nVal1200 	:= 0
Local	_nVal1300 	:= 0
Local	_nVal1400 	:= 0
Local	_nVal1500 	:= 0 
Local  i			:= 0	
Local _cMotivo		:= ""

    
//--Condição 004 comissiona na 006 para ZZ9/ZZB.	        
If _cCond $ '004'                                               
	_cCond	:='006' //Condição para a tabela ZZ9/ZZB	
EndIf

//--Condição 009 comissiona na 012 para ZZ9/ZZB
If _cCond $ '009'
 	_cCond:='012' //Condição para a tabela ZZ9/ZZB	
EndIf 

//--Tratamento para condição negociada-020.
If _cCond $ '020'
	_cCond	:='012' //Condição para a tabela ZZ9/ZZB	
EndIf


dbSelectArea("ZZB")
dbSelectArea("ZZC")
dbSelectArea("ZZD")
dbSelectArea("ZZE")
dbSelectArea("ZZF")
dbSelectArea("ZZG")
dbSelectArea("ZZH")
dbSelectArea("ZZI")
dbSelectArea("ZZL")
dbSelectArea("ZZM")
dbSelectArea("ZZN")
dbSelectArea("ZZO")
dbSelectArea("ZZP")
//dbSelectArea("ZZQ")

//Valida a Tabela 
If Empty(_cTabela)
	_cMotivo:="Tabela invalida!!!" 
	Return
EndIf 

//--------------------------------------------------------------------------------
// Valida as CFOPs contindas no parametro de vendas.
//--------------------------------------------------------------------------------
If	Alltrim(_cFop) $ cFops  
    
	//--------------------------------------------------------------------------------
	// Tratamento para tabelas antigas onde o tipo do vendedor foi alterado.
	//Exemplo: era 4F e agora é 7F RJ --> Jogar para 5F.
	//--------------------------------------------------------------------------------
	dbSelectArea(_cTabela)
	dbSetOrder(1) //ZZQ_FILIAL+ZZQ_TIPVEN+ZZQ_ESTADO+ZZQ_COND+ZZQ_CODIGO
	If !dbSeek('0101'+_cTipVend+_cSitTrib+_cCond+_cProduto)
		//--Representante	
		If _cTipVend $ "6/7/8"
			_cTipVend:='5' 
			_cMotivo:="Tabela direcionada 5F" 
	    EndIf
	EndIf
	
	//--------------------------------------------------------------------------------
	//Posiciona na ZZZ para buscar o percentual de comissão a ser aplicado.
	//--------------------------------------------------------------------------------
	dbSelectArea(_cTabela)
	dbSetOrder(1) //ZZQ_FILIAL+ZZQ_TIPVEN+ZZQ_ESTADO+ZZQ_COND+ZZQ_CODIGO
	If dbSeek('0101'+_cTipVend+_cSitTrib+_cCond+_cProduto)
	
		_nVal0000	:= &((_cTabela)->(_cTabela)+'_0000')
		_nVal0025	:= &((_cTabela)->(_cTabela)+'_0025')
		_nVal0050	:= &((_cTabela)->(_cTabela)+'_0050')	
		_nVal0075	:= &((_cTabela)->(_cTabela)+'_0075')
		_nVal0100	:= &((_cTabela)->(_cTabela)+'_0100')
		_nVal0125	:= &((_cTabela)->(_cTabela)+'_0125') 
		_nVal0150	:= &((_cTabela)->(_cTabela)+'_0150')               
		_nVal0175	:= &((_cTabela)->(_cTabela)+'_0175')               
		_nVal0200	:= &((_cTabela)->(_cTabela)+'_0200')
		_nVal0225	:= &((_cTabela)->(_cTabela)+'_0225')
		_nVal0250	:= &((_cTabela)->(_cTabela)+'_0250')    
		_nVal0275	:= &((_cTabela)->(_cTabela)+'_0275')
		_nVal0300	:= &((_cTabela)->(_cTabela)+'_0300')
		_nVal0325	:= &((_cTabela)->(_cTabela)+'_0325')
		_nVal0350	:= &((_cTabela)->(_cTabela)+'_0350')
		_nVal0375	:= &((_cTabela)->(_cTabela)+'_0375')                      
		_nVal0400	:= &((_cTabela)->(_cTabela)+'_0400')
		_nVal0425	:= &((_cTabela)->(_cTabela)+'_0425')
		_nVal0450	:= &((_cTabela)->(_cTabela)+'_0450')
		_nVal0475	:= &((_cTabela)->(_cTabela)+'_0475')	
		_nVal0500 	:= &((_cTabela)->(_cTabela)+'_0500') 
		_nVal0525 	:= &((_cTabela)->(_cTabela)+'_0525') 
		_nVal0550 	:= &((_cTabela)->(_cTabela)+'_0550') 
		_nVal0575 	:= &((_cTabela)->(_cTabela)+'_0575')	
		_nVal0600 	:= &((_cTabela)->(_cTabela)+'_0600')
		_nVal0625 	:= &((_cTabela)->(_cTabela)+'_0625')
		_nVal0650 	:= &((_cTabela)->(_cTabela)+'_0650')
		_nVal0675 	:= &((_cTabela)->(_cTabela)+'_0675')
		_nVal0700 	:= &((_cTabela)->(_cTabela)+'_0700')
		_nVal0725 	:= &((_cTabela)->(_cTabela)+'_0725')
		_nVal0750 	:= &((_cTabela)->(_cTabela)+'_0750')
		_nVal0775 	:= &((_cTabela)->(_cTabela)+'_0775')				       
		_nVal0800 	:= &((_cTabela)->(_cTabela)+'_0800')
		_nVal0900 	:= &((_cTabela)->(_cTabela)+'_0900')
		_nVal1000 	:= &((_cTabela)->(_cTabela)+'_1000')
		_nVal1100 	:= &((_cTabela)->(_cTabela)+'_1100')
		_nVal1200 	:= &((_cTabela)->(_cTabela)+'_1200') 
		_nVal1300 	:= &((_cTabela)->(_cTabela)+'_1300') 
		_nVal1400 	:= &((_cTabela)->(_cTabela)+'_1400')
		_nVal1500 	:= &((_cTabela)->(_cTabela)+'_1500')	  

		//--------------------------------------------------------------------------------
		// Busca o percentual de comissão a ser aplicado. ao vendedor ou representante.
		//--------------------------------------------------------------------------------

		//--Vendedor	
		If _cTipVend == "2" 
		
			///-----------------------------------------------------------------------------------------
			// Montagem e carregamento do array para posteriormente encontar o percentual de comissão
			//------------------------------------------------------------------------------------------
			AAdd(_aRegs,{'nVal0000',_nVal0000,0})
			AAdd(_aRegs,{'nVal0025',_nVal0025,0.25})		
			AAdd(_aRegs,{'nVal0050',_nVal0050,0.50})
			AAdd(_aRegs,{'nVal0075',_nVal0075,0.75})
			AAdd(_aRegs,{'nVal0100',_nVal0100,1})
			AAdd(_aRegs,{'nVal0125',_nVal0125,1.25})
			AAdd(_aRegs,{'nVal0150',_nVal0150,1.50})
			AAdd(_aRegs,{'nVal0175',_nVal0175,1.75})
			AAdd(_aRegs,{'nVal0200',_nVal0200,2})
			AAdd(_aRegs,{'nVal0225',_nVal0225,2.25})
			AAdd(_aRegs,{'nVal0250',_nVal0250,2.50})  
			AAdd(_aRegs,{'nVal0275',_nVal0275,2.75})
			AAdd(_aRegs,{'nVal0300',_nVal0300,3})
			AAdd(_aRegs,{'nVal0325',_nVal0325,3.25})
			AAdd(_aRegs,{'nVal0350',_nVal0350,3.50})   
			AAdd(_aRegs,{'nVal0375',_nVal0375,3.75}) 
			AAdd(_aRegs,{'nVal0400',_nVal0400,4})
			AAdd(_aRegs,{'nVal0425',_nVal0425,4.25})
			AAdd(_aRegs,{'nVal0450',_nVal0450,4.50})
			AAdd(_aRegs,{'nVal0475',_nVal0475,4.75})
			AAdd(_aRegs,{'nVal0500',_nVal0500,5}) 
			AAdd(_aRegs,{'nVal0525',_nVal0525,5.25})
			AAdd(_aRegs,{'nVal0550',_nVal0550,5.50})
			AAdd(_aRegs,{'nVal0575',_nVal0575,5.75})
			AAdd(_aRegs,{'nVal0600',_nVal0600,6})
			AAdd(_aRegs,{'nVal0625',_nVal0625,6.25})
			AAdd(_aRegs,{'nVal0650',_nVal0650,6.50})
			AAdd(_aRegs,{'nVal0675',_nVal0675,6.75})
			AAdd(_aRegs,{'nVal0700',_nVal0700,7})
			AAdd(_aRegs,{'nVal0725',_nVal0725,7.25})
			AAdd(_aRegs,{'nVal0750',_nVal0750,7.50})
			AAdd(_aRegs,{'nVal0775',_nVal0775,7.75})
			
			///-----------------------------------------------------------------------------------------
			// Monta o ascan para retornar o valor.
			//------------------------------------------------------------------------------------------
			For i:=1 To Len(_aRegs)
				
				If  _aRegs[i][2] > 0
					
					If _nPrecUnit >= _aRegs[i][2]
						_nPercent := _aRegs[i][3]
						_cMotivo:= "Comissionamento Normal"
					Else
						If _nPercent > 0
							_nPercent := _nPercent 
							_cMotivo:= "Comissionamento Normal"
						 Else
							_cMotivo:= "Preco abaixo tabela"						
						End
					EndIf
				EndIf
			Next i
		EndIf

		//--Representante	
		If _cTipVend $ "4/5/6/7" 
				
			///-----------------------------------------------------------------------------------------
			// Montagem e carregamento do array para posteriormente encontar o percentual de comissão
			//------------------------------------------------------------------------------------------
			AAdd(_aRegs,{'nVal0000',_nVal0000,0})
			AAdd(_aRegs,{'nVal0100',_nVal0100,1})		
			AAdd(_aRegs,{'nVal0200',_nVal0200,2})
			AAdd(_aRegs,{'nVal0300',_nVal0300,3})
			AAdd(_aRegs,{'nVal0400',_nVal0400,4})
			AAdd(_aRegs,{'nVal0500',_nVal0500,5})
			AAdd(_aRegs,{'nVal0600',_nVal0600,6})                                     
			AAdd(_aRegs,{'nVal0700',_nVal0700,7})
			AAdd(_aRegs,{'nVal0800',_nVal0800,8})
			AAdd(_aRegs,{'nVal0900',_nVal0900,9})
			AAdd(_aRegs,{'nVal1000',_nVal1000,10})  
			AAdd(_aRegs,{'nVal1100',_nVal1100,11})
			AAdd(_aRegs,{'nVal1200',_nVal1200,12})
			AAdd(_aRegs,{'nVal1300',_nVal1300,13})
			AAdd(_aRegs,{'nVal1400',_nVal1400,14})   
			AAdd(_aRegs,{'nVal1500',_nVal1500,15})
		
			///-----------------------------------------------------------------------------------------
			// Monta o ascan para retornar o valor.
			//------------------------------------------------------------------------------------------
			For i:=1 To Len(_aRegs)
				
				If  _aRegs[i][2] > 0
					
					If _nPrecUnit >= _aRegs[i][2]
						_nPercent := _aRegs[i][3]
						_cMotivo:= "Comissionamento Normal"
					Else
						If _nPercent > 0
							_nPercent := _nPercent		   
							_cMotivo:= "Comissionamento Normal"				
						Else
							_cMotivo:="Preco abaixo tabela"
						End
					EndIf
				EndIf
			Next i
		EndIf
	Else
		_cMotivo:="TipVend não encontrado"
	EndIf
Else
	_cMotivo:="Verificar CFOP"
EndIf
	
_nValComiss:= (_nBaseComiss * _nPercent)/100
  
    
//Retornos possveis.
If _nOpc == 1   //Retorna a base da comissao.
	_nRetorno:= _nBaseComiss
ElseIf _nOpc == 2 	//Retorna o % de comissao.
	_nRetorno:= _nPercent  
ElseIf _nOpc == 3	//Retorna o valor de comissao.
	_nRetorno:= _nValComiss 
ElseIf _nOpc == 4	//Retorna o motivo do comissionamento.
	_nRetorno:= _cMotivo
EndIf

Return(_nRetorno)
  

/*
========================================================================================================================
Rotina----: fGetComiss
Autor-----: Davidson Clayton
Data------: 15/05/2018
========================================================================================================================
Descrição-: Realiza a gravação dos dados na tabela SD2.
Uso-------: D2_C_PERCO- Percentual de comissão e D2_C_VLCOM - Valor de comissão.
========================================================================================================================
*/
Static Function fFAT07GrvRegs(_cFiLOrc,_cNFiscal,_cSerie,_cCliente,_cLoja,_cProduto,_cItem,_nPercent,_nValComiss,_cTabela,_cMotivo,_cTipVend,_nPrecUnit,_cSitTrib,_dEmissao)

dbSelectArea("SD2")
dbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM                                                                                                     
If dbSeek(_cFiLOrc+_cNFiscal+_cSerie+_cCliente+_cLoja+_cProduto+_cItem)
   
   	If RecLock("SD2",.F.)
   	              
	   	Replace SD2->D2_C_PERCO 	With _nPercent  
	   	Replace SD2->D2_C_VLCOM 	With _nValComiss  
	   	Replace SD2->D2_C_TABEL 	With _cTabela 
	   	Replace SD2->D2_C_MOTIV 	With _cMotivo
	   	Replace SD2->D2_C_TIPVEN 	With _cTipVend  
		Replace SD2->D2_C_ESTAD 	With _cSitTrib  
		Replace SD2->D2_C_VUNIT 	With _nPrecUnit           
		Replace SD2->D2_C_EMISS 	With _dEmissao
		 
	   	MsUnlock()
	EndIf
EndIf                                                                    

Return
  

/*
========================================================================================================================
Rotina----: fGetTablela
Autor-----: Davidson Clayton
Data------: 15/05/2018
========================================================================================================================
Descrição-: Realiza a definição da tabela.
Uso-------: Especifico Nutratta.
========================================================================================================================
*/
Static Function  fGetTablela(_dEmissao)

 
If Dtos(_dEmissao) > '20170201' .And. Dtos(_dEmissao) < '20170315'
	//---------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZB-Modelo Antigo 
	//---------------------------------------------------------------------------------------		
	_cTabela:="ZZB"
					
ElseIf Dtos(_dEmissao) >= '20170315'	 .And. Dtos(_dEmissao) < '20170403'		
	//---------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.  ZZ9-Modelo Novo
	//---------------------------------------------------------------------------------------
	_cTabela:="ZZ9"

//ZZC-03/04/2017	
ElseIf Dtos(_dEmissao) >= '20170403' .And. Dtos(_dEmissao) < '20170413'		   
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZC-Primeira tabela abril- 2017. 
	//------------------------------------------------------------------------------------------------------		
	_cTabela:="ZZC"
				
//ZZD-13/04/2017
ElseIf Dtos(_dEmissao) >= '20170413' .And. Dtos(_dEmissao) < '20170508'		
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZD-Segunda tabela abril- 2017. 
	//------------------------------------------------------------------------------------------------------		
	_cTabela:="ZZD"
			
//ZZE-08/05/2017
ElseIf Dtos(_dEmissao) >= '20170508' .And. Dtos(_dEmissao) < '20170603'	
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZE-Segunda tabela Maio- 2017. 
	//------------------------------------------------------------------------------------------------------		
	_cTabela:="ZZE"
							
//ZZF-03/06/2017  a 13/06/2017
ElseIf Dtos(_dEmissao) >= '20170603'	 .And. Dtos(_dEmissao) < '20170613'
	
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZF-Prmeira tabela de Junho 2017. 
	//------------------------------------------------------------------------------------------------------		
	_cTabela:="ZZF"
			
//ZZG-13/06/2017 a   21/07/2017
ElseIf Dtos(_dEmissao) >= '20170613'	.And. Dtos(_dEmissao) < '20170721'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZG-Segunda tabela de Junho 2017. 
	//------------------------------------------------------------------------------------------------------		
	_cTabela:="ZZG"
			
//ZZH-21/07/2017
ElseIf Dtos(_dEmissao) >= '20170721'	.And. Dtos(_dEmissao) <= '20170807'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZH- Unica tabela de julho 2017. 
	//------------------------------------------------------------------------------------------------------		
	_cTabela:="ZZH"
			
//ZZI-08/08/2017
ElseIf Dtos(_dEmissao) >= '20170808' .And. Dtos(_dEmissao) <= '20170911'	
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZH- Unica tabela de julho 2017. 
	//------------------------------------------------------------------------------------------------------		
	_cTabela:="ZZI"
			
//ZZL-11/09/2017 a 08/10/2017
ElseIf Dtos(_dEmissao) >= '20170912'	.And. Dtos(_dEmissao) <= '20171008'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZl- Unica tabela de julho 2017. 
	//------------------------------------------------------------------------------------------------------		
	_cTabela:="ZZL"

//ZZM-09/10/2017 a 10/12/2017
ElseIf Dtos(_dEmissao) >= '20171009'	.And. Dtos(_dEmissao) <= '20171210'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZH- Unica tabela de julho 2017. 
	//------------------------------------------------------------------------------------------------------		
	_cTabela:="ZZM"
			
//ZZN-11/12/2017 
ElseIf Dtos(_dEmissao) >= '20171211'.And. Dtos(_dEmissao) <= '20180114'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZH- Unica tabela de julho 2017. 
	//------------------------------------------------------------------------------------------------------		
	_cTabela:="ZZN"

//ZZO-24/01/2018 
ElseIf Dtos(_dEmissao) >= '20180115' .And. Dtos(_dEmissao) <= '20180304'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZH- Unica tabela de julho 2017. 
	//------------------------------------------------------------------------------------------------------		
	_cTabela:="ZZO"
			
//ZZP-05/03/2018 
ElseIf Dtos(_dEmissao) >= '20180305' .And. Dtos(_dEmissao) <= '20180404'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZP- Tabela de Março 2018. 
	//------------------------------------------------------------------------------------------------------		
	_cTabela:="ZZP"
	
//ZZQ-05/03/2018 
ElseIf Dtos(_dEmissao) >= '20180405' .And. Dtos(_dEmissao) <= '20180506'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZQ- Tabela de abril 2018. 
	//------------------------------------------------------------------------------------------------------		
	_cTabela:="ZZQ" //ZZQ

//ZZR-07/05/2018 
ElseIf Dtos(_dEmissao) >= '20180507' .And. Dtos(_dEmissao) <= '20180603'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZR- Tabela de Março 2018. 
	//------------------------------------------------------------------------------------------------------		
	cTAbZZs:="ZZR"
//ZZS-24/06/2018 
ElseIf Dtos(_dEmissao) >= '20180604' .And. Dtos(_dEmissao) <= '20180813'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZS- Tabela de Março 2018. 
	//------------------------------------------------------------------------------------------------------		
	cTAbZZs:="ZZS"

//ZZT-14/08/2018
ElseIf Dtos(_dEmissao) >= '20180814' .And. Dtos(_dEmissao) <= '20180910'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZS- Tabela de Março 2018. 
	//------------------------------------------------------------------------------------------------------		
	cTAbZZs:="ZZT"

//ZZU-11/09/2018
ElseIf Dtos(_dEmissao) >= '20180911' .And. Dtos(_dEmissao) <= '20180917'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZS- Tabela de Março 2018. 
	//------------------------------------------------------------------------------------------------------		
	cTAbZZs:="ZZU"

//ZZV-18/09/2018
ElseIf Dtos(_dEmissao) >= '20180918' .And. Dtos(_dEmissao) <= '20181007'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZZS- Tabela de Março 2018. 
	//------------------------------------------------------------------------------------------------------		
	cTAbZZs:="ZZV"

//ZZA4-29/10/2018
ElseIf Dtos(_dEmissao) >= '20181008' .And. Dtos(_dEmissao) <= '20181015'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZA4- Outubro 2018. 
	//------------------------------------------------------------------------------------------------------		
	cTAbZZs:="ZA4"

//ZZA5-29/10/2018
ElseIf Dtos(_dEmissao) >= '20181016' .And. Dtos(_dEmissao) <= '20181108'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZA4- Outubro 2018. 
	//------------------------------------------------------------------------------------------------------		
	cTAbZZs:="ZA5"

//ZZA6-29/11/2018
ElseIf Dtos(_dEmissao) >= '20181109' .And. Dtos(_dEmissao) <= '20181202'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZA4- Outubro 2018. 
	//------------------------------------------------------------------------------------------------------		
	cTAbZZs:="ZA6"
	  
//ZZA7-17/12/2018
ElseIf Dtos(_dEmissao) >= '20181203'
	//------------------------------------------------------------------------------------------------------
	//Rotina para calcular a comissão de cada produto do pedido de vendas.-ZA4- Outubro 2018. 
	//------------------------------------------------------------------------------------------------------		
	cTAbZZs:="ZA7"
																				
EndIf	

Return(_cTabela)



