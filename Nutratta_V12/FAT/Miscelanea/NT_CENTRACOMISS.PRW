#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#Include 'Parmtype.ch'

//--------------------------------------------------------------------------
/* {Protheus.doc} NT_CENTRACOMISS
Rotina centralizadora de comissões.
Realiza o calculo de comissão 
Realiza o calculo de custo direto dos produtos.
 
*/
//--------------------------------------------------------------------------
User Function NT_CENTRACOMISS(cFiLOrc,cCodTab,cProduto,cCond,cVendedor,nQuant,nPrcVen,nFreteI,dDtata1,dDtata2 ,dDtata3,dDtata4,dEmissao,nOpc)

Local 	xFilialN	:= ""         
local 	dEmissao	:= ""
Local 	cPedido		:= ""
Local 	cCond		:= ""  
Local 	cCondRel	:= ""
Local 	cCodTab   	:= ""
Local 	cCliente	:= ""
Local 	cLoja		:= ""
Local 	cSitTrib	:= "" //Dentro ou fora de GO
Local 	cVendedor	:= "" 
Local 	cTipVend	:= "" //Vendedor ou representante comercial.
Local 	cItem		:= ""
Local 	cProduto	:= ""   
Local 	cDescric	:= ""   
Local   nFretPrd	:= 0
Local 	nPrcVen		:= 0
Local 	nPrcTot		:= 0
Local 	nQuant		:= 0
Local 	nVal05		:= 0
Local	nVal1		:= 0
Local	nVal15		:= 0
Local	nVal2		:= 0
Local	nVal25		:= 0
Local	nVal3		:= 0
Local	nVal35		:= 0
Local	nVal4		:= 0
Local	nVal5		:= 0
Local	nVal6		:= 0
Local	nVal7		:= 0
Local 	nSoma		:= 0
Local  nEncarg		:= 0  
Local 	nDias		:= 0
Local 	nQTdParc	:= 0
Local   nTotVenda	:= 0
Local lContinua		:= .T. 
Local _lVirtual		:= .T.
Local  aAreaAnt 	:= GetArea()


//----------------------------------------------------------------------------
// Chamada gatilho pedido de vendas C6_PRODUTO C6_N_CUSTD U_NT_CENTRACOMISS(1) 
//-----------------------------------------------------------------------------
If nOpc == 1 

	

//----------------------------------------------------------
// Chamada ponto de entrada MT410TOK.
//----------------------------------------------------------
ElseIf nOpc == 2
	

//----------------------------------------------------------
// Chamada rotina de recalculo de comissão
//----------------------------------------------------------
ElseIf nOpc == 3

	
//----------------------------------------------------------
// Chamada rotina Preenchimento Provisão 2017 2018 2019
//----------------------------------------------------------
ElseIf nOpc == 4


EndIf

//Carrega as variaveis 



//Realiza a consulta 

//Realiza o calculo de comissão

//Realiza o retorno 

//Realiza a gravação




































//--------------------------------------------------------------------------------
// Inicio dos retornos 
//--------------------------------------------------------------------------------

If _lVirtual
	
	//--------------------------------------------------------------------------------
	// Retorna o valor do frete - Calculo Total do frete
	//--------------------------------------------------------------------------------
	_nFreteI := _nValFrete * _nQtdVend
	
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_VFRET' } )
	If _nPos > 0
		
		_aCols[Len(_aCols)][_nPos] := _nFreteI
	EndIf
	
	//---------------------------------------------------------------------------------------
	// Grava o Percentual de Imposto no campo utilizado provisoriamente.
	//---------------------------------------------------------------------------------------
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_COMIS5' } )
	If _nPos > 0
		
		_aCols[Len(_aCols)][_nPos] := _nPercTrib * 100
	EndIf
	
	//---------------------------------------------------------------------------------------
	// Grava o valor total do imposto para memoria de calculo.
	//---------------------------------------------------------------------------------------
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_VLIMPOR' } )
	If _nPos > 0
		
		_aCols[Len(_aCols)][_nPos] := _nImposto
	EndIf
		
	//---------------------------------------------------------------------------------------------------
	// Verifica se existe o campo C6_VALOR
	//----------------------------------------------------------------------------------------------------
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_VALOR' } )
	If _nPos > 0
		
		_aCols[Len(_aCols)][_nPos] := _nValBrut
	EndIf
	
	//---------------------------------------------------------------------------------------------------
	// Verifica se existe o campo C6_N_CUSTD - Campo custo direto.
	//----------------------------------------------------------------------------------------------------
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_N_CUSTD' } )
	If _nPos > 0
		
		_aCols[Len(_aCols)][_nPos] := _nValCustD
	EndIf
	
	//----------------------------------------------------------------------------------------------------
	// Busca a base da comissão na função especifica. DA1
	//----------------------------------------------------------------------------------------------------
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_BASCO' })
	If _nPos > 0
		
		_nBaseComiss:= U_NT_GETCOMSS(xFilial("SC6"),_cTabela,_cCodPrd,_cCondPg,_cVendedor,_nQtdVend,_nPrcUnit,_nValFrete,_dDtata1,_dDtata2,_dDtata3,_dDtata4,_dEmissao,1)
		_aCols[Len(_aCols)][_nPos] := _nBaseComiss
		
		
		//----------------------------------------------------------------------------------------------------
		// Busca o percentual de comissao na tabela especifica
		//----------------------------------------------------------------------------------------------------
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_PERCO' })
		If _nPos > 0
			
			_nPerComiss:= U_NT_GETCOMSS(xFilial("SC6"),_cTabela,_cCodPrd,_cCondPg,_cVendedor,_nQtdVend,_nPrcUnit,_nValFrete,_dDtata1,_dDtata2,_dDtata3,_dDtata4,_dEmissao,2)
			_aCols[Len(_aCols)][_nPos] := _nPerComiss
		EndIf
		
		//----------------------------------------------------------------------------------------------------
		// Busca o valor a ser comissionado e grava o percentual e valor nos campos do orçamento.
		//----------------------------------------------------------------------------------------------------
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_VLCOM'})
		If _nPos > 0
			
			_nVlComiss := U_NT_GETCOMSS(xFilial("SC6"),_cTabela,_cCodPrd,_cCondPg,_cVendedor,_nQtdVend,_nPrcUnit,_nValFrete,_dDtata1,_dDtata2,_dDtata3,_dDtata4,_dEmissao,3)
			_aCols[Len(_aCols)][_nPos] := _nVlComiss
		EndIf
	EndIf
	
	//-------------------------------------------------------------------------------------------
	//Calculo da Margem Bruta.
	//Valor bruto do produto no pedido de venda -Imposto gerado pra nota - frete do produto
	//provisao de comissao -(custo de material direto inserido na tabela de preço pelo Leonardo).
	//-------------------------------------------------------------------------------------------
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_N_MARGE'})
	If _nPos > 0
		
		_nMargConTri := _nValBrut - (_nImposto + _nFreteI + _nVlComiss + _nValCustD)
		_aCols[Len(_aCols)][_nPos] := _nMargConTri
	EndIf	
EndIf


