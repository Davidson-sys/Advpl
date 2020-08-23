#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"                 
#INCLUDE "TOPCONN.CH" 
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} AWEB003
// Rotina de Prospect x Orçamnto
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

User Function AWEB003()

	Local cCliPad		:= "" 
	Local nLin1			:= 0
	Local nCol1			:= 0
	Local nLin2			:= 0
	Local nCol2			:= 0
	Local nLenX			:= 0
	Local nLenY			:= 0
	Local aCoors		:= {}
	Local aFld00		:= {}
	
	Local oDlgMain		:= Nil
	Local oSize			:= Nil
	Local oFWLayer1		:= Nil	
	Local oFWL1UpL		:= Nil
	Local oFWL1UpR		:= Nil
	Local oFWL1DownL	:= Nil
	Local oFWL1DownR	:= Nil
	Local oBwsSCJ		:= Nil
	Local oBwsSCK		:= Nil
	Local oBwsSUS		:= Nil
	Local oBwsSA1		:= Nil
	Local oRelSCK		:= Nil
	Local oRelSUS		:= Nil
	Local oRelSA1		:= Nil
	Local oFWLayer2		:= Nil	
	Local oFWL2UpA		:= Nil
	Local oFWL2DownL	:= Nil
	Local oFWL2DownR	:= Nil	
	Local oBwsSA3		:= Nil
	Local oBwsSC5		:= Nil
	Local oBwsSC6		:= Nil
	Local oRelSC5		:= Nil
	Local oRelSC6		:= Nil
	Local oTree			:= Nil
	
	Private	aCutSA3		:= {}
	
	oSize	:= FwDefSize():New(.F.) 
	oSize:AddObject("TFolder",100, 100, .T., .T. )
	oSize:lProp		:= .T.
	oSize:lLateral	:= .F.
	oSize:Process()
	
	aCoors	:= oSize:aWindSize
	
	aAdd(aFld00, "Pré Pedidos"			)
	aAdd(aFld00, "Vendedores"			)
	aAdd(aFld00, "Hierarquia Comercial"	)

	Define MsDialog oDlgMain Title ' Portal de Vendedores' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel
		
		nLin1	:= oSize:GetDimension("TFolder","LININI")
		nCol1	:= oSize:GetDimension("TFolder","COLINI")
		nLin2	:= oSize:GetDimension("TFolder","LINEND")
		nCol2	:= oSize:GetDimension("TFolder","COLEND")
		nLenX	:= oSize:GetDimension("TFolder","XSIZE")
		nLenY	:= oSize:GetDimension("TFolder","YSIZE")
		
		// Cria Folder principal
		oTFld00	:= TFolder():New(nLin1, nCol1, aFld00,,oDlgMain,,,,.T.,,nLenX, nLenY)

		// Cria o conteiner onde serão colocados os browses
		oFWLayer1	:= FWLayer():New()
		oFWLayer1:Init( oTFld00:aDialogs[1], .F., .T. )
	
		// Define Painel Superior - Cria uma "linha" com 50% da tela
		oFWLayer1:AddLine( 'UP', 60, .F. )
	
		// Na "linha" criada eu crio uma coluna com 50% da tamanho dela
		oFWLayer1:AddCollumn( 'UP-LEFT', 50, .T., 'UP' )
		oFWLayer1:AddCollumn( 'UP-RIGHT', 50, .T., 'UP' )
	
		// Pego o objeto desse pedaço do container 
		oFWL1UpL	:= oFWLayer1:GetColPanel( 'UP-LEFT', 'UP' ) 
		oFWL1UpR	:= oFWLayer1:GetColPanel( 'UP-RIGHT', 'UP' )
	
		// Define Painel Inferior - Cria uma "linha" com 50% da tela
		oFWLayer1:AddLine( 'DOWN', 40, .F. ) 
	
		// Na "linha" criada eu crio uma coluna com 50% da tamanho dela
		oFWLayer1:AddCollumn( 'DOWN-LEFT' , 50, .T., 'DOWN' ) 
		oFWLayer1:AddCollumn( 'DOWN-RIGHT', 50, .T., 'DOWN' )
	
		// Pego o objeto do pedaço esquerdo e direito
		oFWL1DownL	:= oFWLayer1:GetColPanel( 'DOWN-LEFT' , 'DOWN' ) 
		oFWL1DownR	:= oFWLayer1:GetColPanel( 'DOWN-RIGHT', 'DOWN' )
		
		// Browser de orçamento
		oBwsSCJ	:= FWMBrowse():New()
		oBwsSCJ:SetOwner( oFWL1UpL )
		oBwsSCJ:SetDescription( 'Pre Pedidos' )
		oBwsSCJ:SetAlias( 'SCJ' )
		oBwsSCJ:SetMenuDef( 'AWEB001' )
		oBwsSCJ:DisableDetails()
		oBwsSCJ:SetProfileID( 'SCJ' )
		oBwsSCJ:ForceQuitButton()
		oBwsSCJ:AddLegend( 'SCJ->CJ_STATUS=="A"' , 'BR_VERMELHO', "Pedido em Aberto" 		)
		oBwsSCJ:AddLegend( 'SCJ->CJ_STATUS=="B"' , 'BR_VERDE'	, "Pedido Baixado" 			)
		oBwsSCJ:AddLegend( 'SCJ->CJ_STATUS=="F"' , 'BR_MARROM'	, "Pedido Bloqueado" 		)
		oBwsSCJ:AddLegend( 'SCJ->CJ_STATUS=="R"' , 'BR_PRETO'	, "Pedido Reprovado" 		)
		oBwsSCJ:Activate()
		
		// Browser de produtos do orçamento
		oBwsSCK	:= FWMBrowse():New()
		oBwsSCK:SetOwner( oFWL1UpR )
		oBwsSCK:SetDescription( 'Produtos' )
		oBwsSCK:SetAlias( 'SCK' )
		oBwsSCK:SetMenuDef( '' )
		oBwsSCK:DisableDetails()
		oBwsSCK:SetProfileID( '2' )
		oBwsSCK:Activate()
		
		// Browser de prospect
		oBwsSUS	:= FWmBrowse():New()
		oBwsSUS:SetOwner( oFWL1DownL ) 
		oBwsSUS:SetDescription( "Novo Cliente" )
		oBwsSUS:SetAlias( 'SUS' )
		oBwsSUS:SetMenuDef( 'AWEB002' ) 
		oBwsSUS:DisableDetails()
		oBwsSUS:SetProfileID( 'SUS' )
		oBwsSUS:AddLegend( "SUS->US_STATUS == '1'", "BR_VERMELHO"	,'Aguardando'			)
		oBwsSUS:AddLegend( "SUS->US_STATUS == '5'", "BR_PRETO"		,'Cancelado' 			)	
		oBwsSUS:AddLegend( "SUS->US_STATUS == '6'", "BR_VERDE"		,'Cliente'  			)
		oBwsSUS:Activate()
		
		// Browser de clientes
		cCliPad	:= GetMv("MV_ORCLIPD",,"000000000001")
		oBwsSA1	:= FWMBrowse():New()
		oBwsSA1:SetOwner( oFWL1DownR )
		oBwsSA1:SetDescription( 'Clientes' )
		oBwsSA1:SetAlias( 'SA1' )
		oBwsSA1:SetMenuDef( 'AWEB005' )
		oBwsSA1:DisableDetails()
		oBwsSA1:SetProfileID( 'SA1' )
		oBwsSA1:AddLegend( "SA1->A1_COD + SA1->A1_LOJA == '"+cCliPad+"'", "BR_VERMELHO"	,'Pre-Cliente' 		)	
		oBwsSA1:AddLegend( "SA1->A1_COD + SA1->A1_LOJA <> '"+cCliPad+"'", "BR_VERDE"		,'Cliente'  	)			
		oBwsSA1:Activate()
		
		// Relacionando Browsers	
		oRelSCK	:= FWBrwRelation():New()
		oRelSCK:AddRelation( oBwsSCJ, oBwsSCK, { { 'CK_FILIAL', 'xFilial("SCK")' }, { 'CK_NUM', 'CJ_NUM' } } )
		oRelSCK:Activate()		
		
		oRelSUS	:= FWBrwRelation():New()
		oRelSUS:AddRelation( oBwsSCJ , oBwsSUS , { { 'CJ_FILIAL', 'xFilial("SCJ")' }, { 'US_COD', 'CJ_PROSPE' }, { 'US_LOJA', 'CJ_LOJPRO' } } )
		oRelSUS:Activate()
 	
		oRelSA1	:= FWBrwRelation():New()
		oRelSA1:AddRelation( oBwsSCJ , oBwsSA1 , { { 'A1_FILIAL', 'xFilial("SA1")' }, { 'A1_COD', 'CJ_CLIENTE' }, { 'A1_LOJA', 'CJ_LOJA' } } )
		oRelSA1:Activate()
		
		// Cria o conteiner onde serão colocados os browses
		oFWLayer2	:= FWLayer():New()
		oFWLayer2:Init( oTFld00:aDialogs[2], .F., .T. )
	
		// Define Painel Superior - Cria uma "linha" com 50% da tela
		oFWLayer2:AddLine( 'UP', 50, .F. )
	
		// Na "linha" criada eu crio uma coluna com 100% da tamanho dela
		oFWLayer2:AddCollumn( 'UP-ALL', 100, .T., 'UP' )
	
		// Pego o objeto desse pedaço do container 
		oFWL2UpA	:= oFWLayer2:GetColPanel( 'UP-ALL', 'UP' ) 
	
		// Define Painel Inferior - Cria uma "linha" com 50% da tela
		oFWLayer2:AddLine( 'DOWN', 50, .F. ) 
	
		// Na "linha" criada eu crio uma coluna com 50% da tamanho dela
		oFWLayer2:AddCollumn( 'DOWN-LEFT' , 50, .T., 'DOWN' ) 
		oFWLayer2:AddCollumn( 'DOWN-RIGHT', 50, .T., 'DOWN' )
	
		// Pego o objeto do pedaço esquerdo e direito
		oFWL2DownL	:= oFWLayer2:GetColPanel( 'DOWN-LEFT' , 'DOWN' ) 
		oFWL2DownR	:= oFWLayer2:GetColPanel( 'DOWN-RIGHT', 'DOWN' )
		
		// Browser de vendedores
		oBwsSA3	:= FWMBrowse():New()
		oBwsSA3:SetOwner( oFWL2UpA )
		oBwsSA3:SetDescription( 'Vendedores' )
		oBwsSA3:SetAlias( 'SA3' )
		oBwsSA3:SetMenuDef( 'AWEB004' )
		oBwsSA3:DisableDetails()
		oBwsSA3:ForceQuitButton()
		oBwsSA3:SetProfileID( 'SA3' )
		oBwsSA3:Activate()
		
		// Browser de pedidos
		oBwsSC5	:= FWMBrowse():New()
		oBwsSC5:SetOwner( oFWL2DownL )
		oBwsSC5:SetDescription( 'Pedidos' )
		oBwsSC5:SetAlias( 'SC5' )
		oBwsSC5:SetMenuDef( '' )
		oBwsSC5:DisableDetails()
		oBwsSC5:SetProfileID( 'SC5' )
		oBwsSC5:ForceQuitButton()
		oBwsSC5:AddLegend( "Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)"	, 'BR_VERDE' 		, "Pedido em Aberto"			)
		oBwsSC5:AddLegend( "!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)"		, 'BR_VERMELHO'		, "Pedido Encerrado"			)
		oBwsSC5:AddLegend( "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)"	, 'BR_AMARELO'		, "Pedido Liberado"				)
		oBwsSC5:AddLegend( "C5_BLQ == '1'"												, 'BR_AZUL'			, "Pedido Bloquedo por regra"	)
		oBwsSC5:AddLegend( "C5_BLQ == '2'"												, 'BR_LARANJA'		, "Pedido Bloquedo por verba"	)
		oBwsSC5:Activate()
		
		// Browser de produtos do pedido
		oBwsSC6	:= FWmBrowse():New()
		oBwsSC6:SetOwner( oFWL2DownR ) 
		oBwsSC6:SetDescription( "Produtos" )
		oBwsSC6:SetAlias( 'SC6' )
		oBwsSC6:SetMenuDef( '' ) 
		oBwsSC6:DisableDetails()
		oBwsSC6:SetProfileID( 'SC6' )
		oBwsSC6:Activate()
		
		// Relacionando Browsers	
		oRelSC5	:= FWBrwRelation():New()
		oRelSC5:AddRelation( oBwsSA3, oBwsSC5, { { 'C5_FILIAL', 'xFilial( "SC5" )' }, { 'C5_VEND1', 'A3_COD' } } )
		oRelSC5:Activate()		
		
		oRelSC6	:= FWBrwRelation():New()
		oRelSC6:AddRelation( oBwsSC5 , oBwsSC6 , { { 'C6_FILIAL', 'xFilial("SC6" )' }, { 'C6_NUM', 'C5_NUM' } } )
		oRelSC6:Activate()

		// Arvore de hierarquia do comercial
		oTree	:= DbTree():New(nLin1,nCol1,nLin2-20,nCol2-10,oTFld00:aDialogs[3],,,.T.)
		oTree:bRClicked  := {|o,x,y| fGetItem(oTree) }
				
		Processa({|| fSetTree(oTree) },"Processando árvore de hierarquia...","Aguarde", .F.)
 
	Activate MsDialog oDlgMain Center

Return()

/*/{Protheus.doc} fGetTree
// Carrega arvore de hierarquia do comercial
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function fSetTree(oTree)

	Local nTree			:= 0
	Local aTree			:= {}

	fGetTree(.F.,"", @aTree)
	
	ProcRegua(Len(aTree))
	
	oTree:lProcess		:= .T.
	oTree:lRefreshing	:= .T.
	
	oTree:BeginUpdate()
	oTree:Reset()	
	oTree:AddTree(PadR(SM0->M0_NOME,40," "), .T., "PRODUTO", "PRODUTO", , , StrZero(0,20))
	
	For nTree := 1 To Len(aTree)		
		If aTree[nTree,4] == "BEGIN"
			oTree:AddTree(aTree[nTree,1], .T., aTree[nTree,2], aTree[nTree,3], , , StrZero(aTree[nTree,5],20))
		ElseIf aTree[nTree,4] == "END"
			oTree:EndTree()
		Endif		
		IncProc(aTree[nTree,1]) 		
	Next nTree
	
	oTree:EndTree()	
	oTree:EndUpdate()
	oTree:Refresh()
	
	oTree:lProcess		:= .F.
	oTree:lRefreshing	:= .F.
	oTree:lValidLost	:= .F.
	oTree:lActivated	:= .T.

Return()

/*/{Protheus.doc} fGetTree
// Carrega arvore de hierarquia do comercial
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function fGetTree(lLoop, cCodigo, aTree)

	Local cAlias	:= GetNextAlias()
	Local cWhere	:= ""
	Local cLeg1		:= ""
	Local cLeg2		:= ""
	
	Default lLoop	:= .F.
	
	If lLoop
		cWhere	:= "% AND SA3.A3_SUPER = '"+cCodigo+"' %"
	Else
		cWhere	:= "%  %"
	Endif
	
	BeginSql alias cAlias
		SELECT	SA3.A3_COD, SA3.A3_NOME, SA3.A3_MSBLQL, SA3.R_E_C_N_O_ AS RECSA3
		FROM	%Table:SA3% SA3
		WHERE	SA3.%NOTDEL%
				AND SA3.A3_FILIAL	= %xFilial:SA3%
				%exp:cWhere%
		ORDER BY SA3.A3_SUPER, SA3.A3_NOME
	EndSql
	
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	If (cAlias)->(!Eof())
		While (cAlias)->(!Eof())		
			If !lLoop .AND. aScan(aTree, {|x| x[5] == (cAlias)->RECSA3}) > 0
				(cAlias)->(DbSkip())
				Loop
			Endif			
			
			cLeg1 := IIF((cAlias)->A3_MSBLQL == "1", "FOLDER14", "FOLDER5")
			cLeg2 := IIF((cAlias)->A3_MSBLQL == "1", "FOLDER15", "FOLDER6") 
			
			aAdd(aTree, {(cAlias)->A3_NOME, cLeg1, cLeg2, "BEGIN", (cAlias)->RECSA3	})
			fGetTree(.T., (cAlias)->A3_COD, @aTree)
			aAdd(aTree, {(cAlias)->A3_NOME, cLeg1, cLeg2, "END", (cAlias)->RECSA3	})	
			(cAlias)->(DbSkip())
		Enddo
	Endif
	
	(cAlias)->(DbCloseArea())

Return()

/*/{Protheus.doc} fGetTree
// Edita item da Arvore
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function fGetItem(oTree)

	Local aArea		:= GetArea()
	Local aASA3		:= SA3->(GetArea())
	Local nRecno	:= 0
	Local nOpcao	:= 0
	Local nInd		:= 0
	Local cCargo	:= ""
	Local cAviso	:= ""
	Local nCodSA3	:= ""
	Local lRefresh	:= .F.
	
	// Alimenta dados
	cAviso := "Selecione a opção desejada!" + chr(13) + chr(10)
	cAviso += Space(3) + "Memória: " + chr(13) + chr(10)
	
	For nInd := 1 To Len(aCutSA3)
		cAviso += Space(6) + " - " + aCutSA3[nInd,3] + chr(13) + chr(10)
	Next nInd
	
	nOpcao := Aviso( "Aviso", cAviso, { "Recortar", "Colar", "Limpar", "Sair" }, 3 )
	cCargo := oTree:GetCargo()
	nRecno := Val(cCargo)
	
	// Posiciona no registro
	If nRecno > 0 .AND. (nOpcao == 1 .OR. nOpcao == 2)
		DbSelectArea("SA3")
		SA3->(DbGoTo(nRecno))
		If SA3->(Recno()) <> nRecno
			MsgStop("Registro não encontrado!")
			SA3->(RestArea(aASA3))
			RestArea(aArea)
			Return()
		Endif
	Endif	
	
	// Efetua operações
	If nOpcao == 1 .AND. nRecno > 0	
		If aScan(aCutSA3, {|x| x[1] == nRecno}) == 0 
			aAdd(aCutSA3, {nRecno, cCargo, oTree:GetPrompt()})
		Endif		
	ElseIf nOpcao == 2 .AND. Len(aCutSA3) > 0		
		nCodSA3 := IIF(nRecno > 0, SA3->A3_COD, "")
		DbSelectArea("SA3")		 
		For nInd := 1 To Len(aCutSA3)		
			SA3->(DbGoTo(aCutSA3[nInd,1]))
			If SA3->(Recno()) == aCutSA3[nInd,1] .AND. SA3->A3_COD <> nCodSA3 .AND. SA3->A3_SUPER <> nCodSA3
				SA3->(RecLock("SA3",.F.))
				SA3->A3_SUPER	:= nCodSA3
				SA3->(MsUnLock())
				lRefresh := .T.
			Endif		
		Next nInd		
		aCutSA3		:= {}
	ElseIf nOpcao == 3
		aCutSA3		:= {}
	Endif
	
	// Atualiza a arvore
	If lRefresh
		Processa({|| fSetTree(oTree) },"Atualizando árvore de hierarquia...","Aguarde", .F.)
		oTree:TreeSeek(cCargo)
	Endif 
	
	SA3->(RestArea(aASA3))
	RestArea(aArea)
	
Return()