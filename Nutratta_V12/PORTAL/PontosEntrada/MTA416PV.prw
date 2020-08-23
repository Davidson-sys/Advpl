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
M->C5_XLOCENT	:= SCJ->CJ_XLOCENT
M->C5_MOEDA		:='1'  
M->C5_NOMCLI	:= Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_NOME") 


//===================================================================================================
// Atualiza o local de entrega na ZZ
//===================================================================================================
DBSelectArea('ZZJ')
ZZJ->(DBSetOrder(1))
If ZZJ->( DBSeek(xFilial("ZZJ") + SCJ->CJ_XLOCENT ))
	
	RecLock("ZZJ",.F.)
		REPLACE ZZJ_CLIENTE  With SCJ->CJ_CLIENTE
		REPLACE ZZJ_LOJA   	 With SCJ->CJ_LOJA
		REPLACE ZZJ_NCLI	 With ""  //Novo cliente 
		REPLACE ZZJ_NLJ   	 With ""  //Loja em novo cliente
	MsUnLock()
EndIf

//Executa o gatilho Locais de entrega
RunTrigger(1,nil,nil,,'C5_XLOCENT')


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
	// Verifica campo CK_C_FRETE - Frete Item (Solicitação Nutratta)
	//----------------------------------------------------------------------------------------------------
	If FieldPos( "CK_C_FRETE" ) > 0
		
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
	If FieldPos( "CK_PRCVEN" ) > 0
		
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
	If FieldPos( "CK_PRODUTO" ) > 0
		
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_DESCRI' } )
		
		If _nPos > 0
			_aCols[Len(_aCols)][_nPos] := Posicione("SB1",1,xFilial("SB1")+SCK->CK_PRODUTO,"B1_DESC")			 
		EndIf		
	EndIf
	
	
	//----------------------------------------------------------------------------------------------------
	// Verifica campo C6_ENTREG - Atualiza a data de entrega dos itens no orçamento em todas as linhas
	//----------------------------------------------------------------------------------------------------
	If FieldPos( "CK_PRODUTO" ) > 0
		
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_ENTREG' } )
		
		If _nPos > 0
			_aCols[Len(_aCols)][_nPos] := SCJ->CJ_FECENT			 
		EndIf		
	EndIf
	

	//----------------------------------------------------------------------------------------------------
	// Verifica campo CK_ZRESSUP - Grava data de resuprimento 
	//----------------------------------------------------------------------------------------------------
	If FieldPos( "CK_ZRESSUP" ) > 0
		
		_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_ZRESSUP' } )
		
		If _nPos > 0
			_aCols[Len(_aCols)][_nPos] := SCK->CK_ZRESSUP
		EndIf
		
	EndIf

	//----------------------------------------------------------------------------------------------------
	// Grava em todas as linhas da SC6 o numero do orcamento - C6_NUMORC  
	//----------------------------------------------------------------------------------------------------	
	_nPos := aScan( _aHeader , {|x| Alltrim(x[2]) == 'C6_NUMORC' } )
	If _nPos > 0
		_aCols[Len(_aCols)][_nPos] := SCJ->CJ_NUM
	EndIf
	
EndIf

Return()
