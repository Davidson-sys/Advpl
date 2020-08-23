#Include 'Protheus.ch'
#Include 'Parmtype.ch'

/*
========================================================================================================================
Rotina----: MTA416PV
Autor-----: Marco Aurelio Braga
Data------: 26/05/2016
========================================================================================================================
Descrição-: Executado apos o preenchimento do aCols na Baixa do Orcamento de Vendas
Uso-------: Usuado pelo cliente para tratar campos customizados do orçamnto para o pedido
========================================================================================================================
*/

User Function MTA416PV()

Local _nPos			:= 0

//====================================================================================================
// Grava campos adicionais na SC5
//====================================================================================================
M->C5_VEND1		:= SCJ->CJ_VEND1
M->C5_TPFRETE	:= SCJ->CJ_TPFRETE
M->C5_PESOL		:= SCJ->CJ_PESOL
M->C5_PBRUTO	:= SCJ->CJ_PBRUTO
M->C5_VOLUME1	:= SCJ->CJ_VOLUME1
M->C5_ESPECI1	:= SCJ->CJ_ESPECI1
M->C5_FECENT	:= SCJ->CJ_FECENT
M->C5_C_TCARR	:= SCJ->CJ_C_TCARR
M->C5_C_RDCAR	:= SCJ->CJ_C_RDCAR
M->C5_C_LSAID	:= SCJ->CJ_C_LSAID
M->C5_C_OBSLIB	:= SCJ->CJ_C_OBS   
M->C5_MOEDA		:= 1 
M->C5_NOMCLI	:= Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_NOME")

//====================================================================================================
// Grava os campos locais de entrega
//====================================================================================================
M->C5_XLOCENT		:= SCJ->CJ_XLOCENT
M->C5_XNOMFAZ		:= SCJ->CJ_XNOMFAZ
M->C5_XENDERE		:= SCJ->CJ_XENDERE
M->C5_XBAIRRO		:= SCJ->CJ_XBAIRRO
M->C5_XUF    		:= SCJ->CJ_XUF    
M->C5_XMUNENT    	:= SCJ->CJ_XMUNENT    
M->C5_XDDD		   	:= SCJ->CJ_XDDD       
M->C5_XTELEFO		:= SCJ->CJ_XTELEFO       
M->C5_XCTTLOC		:= SCJ->CJ_XCTTLOC       
M->C5_XROTEIR		:= SCJ->CJ_XROTEIR 
M->C5_XCODGPS		:= SCJ->CJ_XCODGPS 
M->C5_XTPVEIC		:= SCJ->CJ_XTPVEIC
M->C5_XLOCCHA		:= SCJ->CJ_XLOCCHA
M->C5_XUFCHAP		:= SCJ->CJ_XUFCHAP
M->C5_XCDMUCH		:= SCJ->CJ_XCDMUCH
M->C5_XMUNCHA		:= SCJ->CJ_XMUNCHA
M->C5_XDDDCHA		:= SCJ->CJ_XDDDCHA
M->C5_XTELCHA		:= SCJ->CJ_XTELCHA
M->C5_XNOMCHA		:= SCJ->CJ_XNOMCHA
M->C5_XRECEBI		:= SCJ->CJ_XRECEBI
M->C5_XHRECED		:= SCJ->CJ_XHRECED
M->C5_XHRECEA		:= SCJ->CJ_XHRECEA
M->C5_XHRECEA		:= SCJ->CJ_XHRECEA

cFilCJ		:= xFilial("SCJ")
cCodTab		:= SCJ->CJ_TABELA 
cCondPg		:= SCJ->CJ_CONDPAG
cVendedor   	:= SCJ->CJ_VEND1  
cCliente    	:= SCJ->CJ_CLIENTE
cLoja		:= SCJ->CJ_LOJA 


//--Tratamento para condição 020-Data valor.  
dEmissao    := SCJ->CJ_EMISSAO    
dDtata1		:= SCJ->CJ_DATA1
dDtata2		:= SCJ->CJ_DATA2	             
dDtata3		:= SCJ->CJ_DATA3
dDtata4		:= SCJ->CJ_DATA4           

//===================================================================================================
// Grava campos adicionais na SC6
//===================================================================================================
DBSelectArea('SCK')
SCK->( DBSetOrder(1) )

//----------------------------------------------------------------------------------------------------
// Posiciona na SC6 com base no item do orçamento
//----------------------------------------------------------------------------------------------------
If SCK->( DBSeek( SCJ->( CJ_FILIAL + CJ_NUM ) + _aCols[Len(_aCols)][1] ) )

	//----------------------------------------------------------------------------------------------------
	// Grava o campo CK_ZBIGBAG no campo C6_ZBIGBAG- Tipo granel com ou sem bag 
	//----------------------------------------------------------------------------------------------------
	If FieldPos("CK_ZBIGBAG" ) > 0
			
		M->C5_ZBIGBAG := Alltrim(SCK->CK_ZBIGBAG)			
	EndIf	
	
	//----------------------------------------------------------------------------------------------------
	// Grava o campo CK->CK_C_OBS Observação por produtos 
	//----------------------------------------------------------------------------------------------------
	If FieldPos("CK_OBS") > 0

		M->C5_C_INFAD := Alltrim(SCK->CK_OBS)			
	EndIf	
	
	//----------------------------------------------------------------------------------------------------
	// Verifica campo CK_C_FRETE - Frete Item (Solicitação Nutratta)
	//----------------------------------------------------------------------------------------------------
	If FieldPos("CK_C_FRETE" ) > 0
		
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_FRETE' } )
		
		If _nPos > 0
			_aCols[Len(_aCols)][_nPos] := SCK->CK_C_FRETE
			If _aCols[Len(_aCols)][1] == "01"
				M->C5_C_VFRET := SCK->CK_C_FRETE * SCK->CK_QTDVEN
			Else
				M->C5_C_VFRET += SCK->CK_C_FRETE * SCK->CK_QTDVEN
			EndIf
		EndIf
		
	EndIf
	
	//----------------------------------------------------------------------------------------------------
	// Verifica campo CK_C_FRETE - Frete Item (Solicitação Nutratta)
	//----------------------------------------------------------------------------------------------------
	If FieldPos("CK_PRCVEN" ) > 0
		
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_VLRDI' } )

		If _nPos > 0
			_aCols[Len(_aCols)][_nPos] := SCK->CK_PRCVEN
		EndIf
		
		//Daniel 25/08 - ajusta o preco de venda com o valor + frete
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == "C6_PRCVEN" } )
		If _nPos > 0
			_aCols[Len(_aCols)][_nPos] := SCK->CK_PRCVEN + SCK->CK_C_FRETE
		EndIf
		
	EndIf
	
	//----------------------------------------------------------------------------------------------------
	// Verifica campo CK_PRODUTO - Pega descricao para o C6_DESCRI
	//----------------------------------------------------------------------------------------------------
	If FieldPos("CK_PRODUTO" ) > 0
		
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_DESCRI' } )
		
		If _nPos > 0
			_aCols[Len(_aCols)][_nPos] := Posicione("SB1",1,xFilial("SB1")+SCK->CK_PRODUTO,"B1_DESC") 
		EndIf
		
	EndIf

	//----------------------------------------------------------------------------------------------------
	// Verifica campo CK_ZRESSUP - Grava data de resuprimento 
	//----------------------------------------------------------------------------------------------------
	If FieldPos("CJ_ZRESSUP" ) > 0
		
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_ZRESSUP' } )
		
		If _nPos > 0
			_aCols[Len(_aCols)][_nPos] := SCJ->CJ_ZRESSUP
		EndIf
	EndIf

	//----------------------------------------------------------------------------------------------------
	// Grava em todas as linhas da SC6 o numero do orcamento - C6_NUMORC  
	//----------------------------------------------------------------------------------------------------	
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_NUMORC' } )
	If _nPos > 0
		_aCols[Len(_aCols)][_nPos] := SCJ->CJ_NUM
	EndIf

	//----------------------------------------------------------------------------------------------------
	// Busca a base da comissão na função especifica. DA1
	//----------------------------------------------------------------------------------------------------
	If FieldPos("CK_C_PERCO" )> 0
		
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_BASCO' })  
		If _nPos > 0                         //Filial,tabela,produto,cond,cVendedor,cCliente+cLoja
			 nValor:= U_NT_GETCOMSS(xFilial("SCK"),cCodTab,SCK->CK_PRODUTO,cCondPg,cVendedor,SCK->CK_QTDVEN,SCK->CK_PRCVEN,SCK->CK_C_FRETE,dDtata1,dDtata2,dDtata3,dDtata4,dEmissao,1)
			_aCols[Len(_aCols)][_nPos] := nValor  			
		EndIf

		//----------------------------------------------------------------------------------------------------
		// Busca o percentual de comissao na tabela especifica
		//----------------------------------------------------------------------------------------------------
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_PERCO' })
		If _nPos > 0                         //Filial,tabela,produto,cond,cVendedor,cCliente+cLoja
			 nValor:= U_NT_GETCOMSS(xFilial("SCK"),cCodTab,SCK->CK_PRODUTO,cCondPg,cVendedor,SCK->CK_QTDVEN,SCK->CK_PRCVEN,SCK->CK_C_FRETE,dDtata1,dDtata2,dDtata3,dDtata4,dEmissao,2)
			_aCols[Len(_aCols)][_nPos] := nValor  			
		EndIf
		
		//----------------------------------------------------------------------------------------------------
   		// Busca o valor a ser comissionado e grava o percentual e valor nos campos do orçamento.
		//----------------------------------------------------------------------------------------------------
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_C_VLCOM' })  //C6_C_VLCOM
		If _nPos > 0                         //Filial,tabela,produto,cond,cVendedor,cCliente+cLoja
			 nValor:= U_NT_GETCOMSS(xFilial("SCK"),cCodTab,SCK->CK_PRODUTO,cCondPg,cVendedor,SCK->CK_QTDVEN,SCK->CK_PRCVEN,SCK->CK_C_FRETE,dDtata1,dDtata2,dDtata3,dDtata4,dEmissao,3)
			_aCols[Len(_aCols)][_nPos] := nValor  			
		EndIf
	EndIf
EndIf		
	
Return()
              

