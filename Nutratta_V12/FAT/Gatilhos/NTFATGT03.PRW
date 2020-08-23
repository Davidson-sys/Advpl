#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#Include 'Parmtype.ch'

//--------------------------------------------------------------------------
/*{Protheus.doc} NTFATGAT03
Gatilho para preencher o campo de custo direto do produto
realizando o calculo após o preenchimento do produto.
  
Campo 		  C6_PRODUTO
Campo.Domino  C6_N_CUSTD
Conteudo	  NTFATGAT03()  

O gatilho tem como objetivo preencher os campos 
campos abaixo:     

C6_N_CUSTD N 12.
C6_N_MARGE 12.   

Campo 		  C6_PRODUTO
Campo.Domino  C6_N_CUSTD
        

Empresa - Copyright - Nutratta Nutrição Animal.
@author Davidson Clayton
@since 10/01/2019.
@version P12 R8   
                   
DA1_N_CUST N 12.
@return Logico (o valor do custo direto)  

19/11/2019 - Acertado estoudro de campo C6_N_PERCM no 
Calcula o % da margem de contribuição.
*/
//--------------------------------------------------------------------------
User Function GFAT003()
 
Local _cCodPrd		:= 	GDFieldGet("C6_PRODUTO",n)
Local _cTEs			:=	GDFieldGet("C6_TES",n)
Local _nValFrete	:= 	GDFieldGet("C6_C_FRETE",n)   
Local _nPrcVen 		:= 	GDFieldGet("C6_PRCVEN",n)  
Local _nPrcUnit		:= 	GDFieldGet("C6_C_VLRDI",n)  
Local _nQtdVend		:=	GDFieldGet("C6_QTDVEN",n) 
Local _nValBrut		:=	GDFieldGet("C6_VALOR",n)

Local _cTipo		:=	M->C5_TIPO
Local _cTabela		:=	M->C5_TABELA
Local _cCondPg		:=	M->C5_CONDPAG
Local _cVendedor	:=	M->C5_VEND1
Local _cCliente		:=	M->C5_CLIENTE
Local _cLoja		:=	M->C5_LOJACLI

Local _dEmissao		:=	M->C5_EMISSAO
Local _dDtata1		:= 	M->C5_DATA1
Local _dDtata2		:= 	M->C5_DATA2	             
Local _dDtata3		:= 	M->C5_DATA3
Local _dDtata4		:= 	M->C5_DATA4 

Local _cMens		:=	""  
Local _cEstado		:=	"" 
Local _cSitTrib		:=	"" 
Local _cUn			:=	""
Local _nxi			:= 	0 
Local _nValCustD	:=	0	
Local _nValor		:=	0	  
Local _nMargConTri	:=  0
Local _nPos			:=  0
Local _nImposto		:=  0
Local _nPercTrib	:=	0  
Local _nBaseComiss	:=  0
Local _nPerComiss 	:=  0
Local _nVlComiss	:=  0 
Local _nFreteI		:=  0 
Local _nValMin		:=	0
Local _nValMax		:=  0
Local _nValDif		:=  0  
Local _nVlrMarg		:=  0 
Local _lRet			:= .T. 
Local _aHeader		:= aHeader 
Local _aCols		:= aCols
 

If xFilial("SC5") == "0101" //Espeficifico para matriz.

	//--------------------------------------------------------------------------------
	//Calculo Total do frete
	//--------------------------------------------------------------------------------
	_nFreteI:= _nValFrete * _nQtdVend
			
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_VFRET' } )
	If _nPos > 0 
	
		_aCols[n][_nPos] := _nFreteI
	EndIf
	
	//--------------------------------------------------------------------------------
	//Calcula o imposto de acordo com o solicitado.(_nValBrut -_nImposto)/100 
	//Posiciona na SA1 para buscar a localização do cliente Dentro ou fora do estado
	//--------------------------------------------------------------------------------
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1")+Padr(_cCliente,8)+Padr(_cLoja,4))
	
		_cEstado:=SA1->A1_EST 
		
		If  _cEstado $ "GO"
			_cSitTrib:="D"
			_nPercTrib	:= 9.25/100  //0.0925        
		Else
			_cSitTrib:="F"
			_nPercTrib	:= 14.05/100  //0.1405
		EndIf 
		
		_nImposto:=	(_nValBrut * _nPercTrib)
		
		//---------------------------------------------------------------------------------------
		// Grava o Percentual de Imposto no campo utilizado provisoriamente.
		//---------------------------------------------------------------------------------------
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_COMIS5' } )
		If _nPos > 0 
		
			_aCols[n][_nPos] := _nPercTrib * 100
		EndIf
		
		//---------------------------------------------------------------------------------------
		// Grava o valor total do imposto para memoria de calculo.
		//---------------------------------------------------------------------------------------
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_VLIMPOR' } )
		If _nPos > 0 
		
			_aCols[n][_nPos] := _nImposto
		EndIf
	EndIf
	
	//---------------------------------------------------------------------------------------
	// Posiciona na tabela de preço para pegar o valor do custo direto.
	//---------------------------------------------------------------------------------------
	dbSelectArea("SB1")
	dbSetOrder(1) //DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_COND  //Filial+Cod.Tabela+Codigo produto+condicao
	If dbSeek(xFilial("SB1")+Padr(_cCodPrd,15))
		
		_nValCustD	:=  SB1->B1_N_2019 
		_cUn		:=  SB1->B1_UM
		_nValCustD 	:= _nValCustD * _nQtdVend   				
	EndIf
     
  
  	//---------------------------------------------------------------------------------------------------
	// Verifica se existe o campo C6_VALOR
	//----------------------------------------------------------------------------------------------------
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_VALOR' } )
	If _nPos > 0 
	
		_aCols[n][_nPos] := _nValBrut
	EndIf
  
	//---------------------------------------------------------------------------------------------------
	// Verifica se existe o campo C6_N_CUSTD - Campo custo direto. 
	//----------------------------------------------------------------------------------------------------
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_N_CUSTD' } )
	If _nPos > 0 
	
		_aCols[n][_nPos] := _nValCustD
	EndIf
	
	//----------------------------------------------------------------------------------------------------
	// Busca a base da comissão na função especifica.
	//----------------------------------------------------------------------------------------------------
	_nPos := aScan(_aHeader , {|x| Alltrim(x[2]) == 'C6_C_BASCO' })  
	If _nPos > 0 
	 
		 _nBaseComiss:= U_NT_GETCOMSS('0101',_cTabela,_cCodPrd,_cCondPg,_cVendedor,_nQtdVend,_nPrcUnit,_nValFrete,_dEmissao,_dDtata1,_dDtata2,_dDtata3,_dDtata4,_cSitTrib,1)
		_aCols[n][_nPos] := _nBaseComiss  			
   		        
		//----------------------------------------------------------------------------------------------------
		// Busca o percentual de comissao na tabela especifica
		//----------------------------------------------------------------------------------------------------
	   	_nPos := aScan(_aHeader , {|x| Alltrim(x[2]) == 'C6_C_PERCO' })  
		If _nPos > 0 
		 
			_nPerComiss:= U_NT_GETCOMSS('0101',_cTabela,_cCodPrd,_cCondPg,_cVendedor,_nQtdVend,_nPrcUnit,_nValFrete,_dEmissao,_dDtata1,_dDtata2,_dDtata3,_dDtata4,_cSitTrib,2)
			_aCols[n][_nPos] := _nPerComiss  			
		EndIf
		
		//----------------------------------------------------------------------------------------------------
	   	// Busca o valor a ser comissionado e grava o percentual e valor nos campos do orçamento.
		//----------------------------------------------------------------------------------------------------
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_VLCOM'})  
		If _nPos > 0 
		 
			 _nVlComiss := U_NT_GETCOMSS('0101',_cTabela,_cCodPrd,_cCondPg,_cVendedor,_nQtdVend,_nPrcUnit,_nValFrete,_dEmissao,_dDtata1,_dDtata2,_dDtata3,_dDtata4,_cSitTrib,3)
			_aCols[n][_nPos] := _nVlComiss						
		EndIf
		
		//---------------------------------------------------------------------------------------------------
		// Calcula o preço minimo de venda
		//----------------------------------------------------------------------------------------------------
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_VMIN' } )
		If _nPos > 0 
			
			_nValMin:= U_NT_GETCOMSS('0101',_cTabela,_cCodPrd,_cCondPg,_cVendedor,_nQtdVend,_nPrcUnit,_nValFrete,_dEmissao,_dDtata1,_dDtata2,_dDtata3,_dDtata4,_cSitTrib,4)
			_aCols[n][_nPos] := _nValMin 
		EndIf
	
		//---------------------------------------------------------------------------------------------------
		// Calcula o preço maximo de venda
		//----------------------------------------------------------------------------------------------------
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_VMAX' } )
		If _nPos > 0 
		                                                          
			_nValMax := U_NT_GETCOMSS('0101',_cTabela,_cCodPrd,_cCondPg,_cVendedor,_nQtdVend,_nPrcUnit,_nValFrete,_dEmissao,_dDtata1,_dDtata2,_dDtata3,_dDtata4,_cSitTrib,5)
			_aCols[n][_nPos] := _nValMax 
		EndIf
	
		//---------------------------------------------------------------------------------------------------
		// Calcula Diferença entre preço minimo e preço maximo
		//----------------------------------------------------------------------------------------------------
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_VDIF' } )
		If _nPos > 0 
		                                                          
			_aCols[n][_nPos] := _nPrcUnit - _nValMin
		EndIf	
	EndIf	
	
	//---------------------------------------------------------------------------------------------------
	// Realiza a conversão do produto KG para TON
	//----------------------------------------------------------------------------------------------------
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_N_TONEL' } )
	If _nPos > 0 
	                                                              
		_aCols[n][_nPos] := IIF( _cUn =='UN',_nQtdVend *25/1000,_nQtdVend) 
	EndIf
	
	//---------------------------------------------------------------------------------------------------
	// Grava o historio co do pedido de vendas - C6_C_HISTP
	//----------------------------------------------------------------------------------------------------
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_HISTP' } )
	If _nPos > 0 
	     
		If  _nPrcUnit < _nValMin
			
			_cHistorico := 'PRECO ABAIXO TABELA'+'-'+'V: '+Alltrim(Str(_nPrcUnit))+'-'+'TB: '+Alltrim(Str(_nValMin))+' M: '+Alltrim(Str(_nValMax))
		ElseIf _nVlComiss > 0
			
			_cHistorico	:= 'COMISSIONAMENTO NORMAL'
			
		ElseIf _cVendedor == '000004'
			
			_cHistorico	:= 'VENDEDOR BALCAO'
		Else
			
			_cHistorico	:= 'TABELA NAO ENCONTRADA'
		EndIf                                                     
		_aCols[n][_nPos] := _cHistorico 
	EndIf
	
	//-------------------------------------------------------------------------------------------
	//Calculo da Margem Bruta.
	//Valor bruto do produto no pedido de venda -Imposto gerado pra nota -frete do produto
	//provisao de comissao -(custo de material direto inserido na tabela de preço pelo Leonardo).  
	//-------------------------------------------------------------------------------------------
   	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_N_MARGE'})  
	If _nPos > 0  

		 _nMargConTri := _nValBrut - (_nImposto + _nFreteI + _nVlComiss + _nValCustD)			 
		_aCols[n][_nPos] := _nMargConTri  			
	EndIf
	
	//---------------------------------------------------------------------------------------------------
	// Calcula o % da margem de contribuição. 
	//----------------------------------------------------------------------------------------------------
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_N_PERCM' } )
	If _nPos > 0 
	     
	     _nVlrMarg	:=	Round((_nMargConTri/_nValBrut) * 100,2)
	     
	     If _nVlrMarg <= 0

		     _nVlrMarg	:=  0	     
	     
	     ElseIf _nVlrMarg >= 100
	     
	     	_nVlrMarg	:=  99
		 EndIf
		                                                     
		_aCols[n][_nPos] :=  _nVlrMarg  //IIF((_nMargConTri/_nValBrut)*100 == 100,99,(_nMargConTri/_nValBrut)*100)
	EndIf	
EndIf
 	
Return(_nValCustD)		
   



