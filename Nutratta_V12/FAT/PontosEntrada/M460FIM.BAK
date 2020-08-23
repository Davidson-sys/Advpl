#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M460FIM  º Autor ³ Fabio Andrade         º Data da Criacao  ³ 18/02/2015                		   	       ,	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para atualizar a descrição da Natureza             							                º±±
±±º          ³                                                                                                              º±±
±±º          ³                                                                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ--ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍmÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro Nutrata                                                                                           º±±
±±º          ³                                                                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nenhum						   							                               						º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nenhum						  							                               						º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUsuario   ³ Microsiga                                                                                					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSetor     ³ Faturamento                                                                             						º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º            			          	ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL                   						º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAutor     ³ Data     ³ Motivo da Alteracao  				               ³Usuario(Filial+Matricula+Nome)    ³Setor        º±±
±±ºÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄº±±
±±º          ³00/00/0000³                               				   ³00-000000 -                       ³ TI	        º±±
±±º----------³----------³--------------------------------------------------³----------------------------------³-------------º±±
±±ºWANDER LIB³03/03/2015³GERACAO DE BORDERO AUTOMATICAMENTE				   ³                                  ³ LIBERDADE	º±±
±±º----------³----------³--------------------------------------------------³----------------------------------³-------------º±±
±±ºLucas Lima³24/07/2015³Gravar % e Base Comissao campo E1_C_PERCO/E1_C_BASCO 	                              ³ NELLTECH	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*/{Protheus.doc} M460FIM
//TODO Descrição auto-gerada.
@author Davidson
@since 25/09/2017
@version undefined

@type function
/*/
/*/{Protheus.doc} M460FIM
//TODO Descrição auto-gerada.
@author Davidson
@since 25/09/2017
@version undefined

@type function
/*/
/*/{Protheus.doc} M460FIM
//TODO Descrição auto-gerada.
@author Davidson
@since 25/09/2017
@version undefined

@type function
/*/
/*/{Protheus.doc} M460FIM
//TODO Descrição auto-gerada.
@author Davidson
@since 25/09/2017
@version undefined

@type function
/*/
USER FUNCTION M460FIM()

	Local _aArea    := GetArea()
	Local _aAreaSE1 := GetArea("SE1")
	Local _aAreaSA3
	Local _aAreaSE1
	Local _aAreaSC6
	Local _lRet   	:= .T.
	Local _cQuery 	:= ""

	//******************
	//Nelltech - Lucas *
	//******************
	Local _cPedido  	:= ""
	Local _cItemPV  	:= ""
	Local _cCod			:= ""
	Local _cVend		:= ""
	Local _cICMS		:= ""
	Local _cPisCof  	:= ""
	Local _nBasComis	:= 0
	Local _nICMS    	:= 0
	Local _nCofins  	:= 0
	Local _nPis     	:= 0
	Local nParc			:= 0
	Local nI			:= 0
	Local nMediaPerc	:= 0
	Local nBaseComis	:= 0
	Local nTotVenda		:= 0
	Local nTotBase		:= 0
	Local nValComIt		:= 0
	Local nValComTot	:= 0
	Local nTitulo		:= 0
	Local nPercItem 	:= 0
	Local aParcela		:= {}
	Local _nNpIcms  	:= GetNewPar("MV_NPICMS","")

	// -- Davis -- 24/02/2016

	Private cNumNota 	:= SF2->F2_DOC
	Private cSerieNf 	:= SF2->F2_SERIE
	Private cCliente 	:= SF2->F2_CLIENTE
	Private cLojaCli 	:= SF2->F2_LOJA
	Private dEmissao 	:= SF2->F2_EMISSAO
	Private cVend1   	:= SF2->F2_VEND1
	Private oHTML
	Private oProcess
	Private lHabWkf 	:= SuperGetMv("NT_HABWKF",.F.,.F.)
	
	/* Anteriores	
	Private cDadBco 	:= SuperGetMv("NT_DADBCO",.F.,"2373288 466000")
	Private cDadRAB		:= SuperGetMv("NT_BCORIAB",.F.,.F.)
	Private cDadRDEF	:= SuperGetMv("NT_BCORIDF",.F.,.F.)
	Private cDadFidAB	:= SuperGetMv("MV_XBCORIA",.F.,.F.)		//MV_XBCORIA -Paramettro alternativo homologação. NT_BCORIAB Base OFC.
	Private lAtivFidc	:= SuperGetMv("MV_XATVFID",.F.,.T.)
	*/	
	Private cBcoBrad		:= SuperGetMv("NT_BRADESC",.F.,.F.)
	Private cBcoFidc		:= SuperGetMv("NT_BCOFIDI",.F.,.F.)
	Private cBcoBMA			:= SuperGetMv("NT_BCOBMA",.F.,.F.)
	Private cSantader		:= SuperGetMv("NT_SANTAND",.F.,.F.)
	Private cBampar			:= SuperGetMv("NT_BANPAR",.F.,.F.)
		
	//Private cCFCTR	:= SuperGetMv("NT_CFCTR",.F.,.F.)//CFOPs utilizados em venda futura.
	Private cRisco		:=""

	IF NMODULO == 43
		RestArea(_aArea)
	EndIf

	//Davidson-08/05/2017 -Compilado.
	//¦+-------------------------------------------------------------+¦

	//¦¦Inserção de Dados para Canhoto  - Lucas Nogueira @ Nelltech  ¦¦

	//¦+-------------------------------------------------------------+¦
	DbSelectArea("ZZ1")

	ZZ1->(DbSetOrder(1))

	ZZ1->(DbSeek(xFilial("ZZ1") + cSerieNf + cNumNota))
	If !(Found())

		Reclock("ZZ1",.T.)
		ZZ1->ZZ1_FILIAL		:= xFilial("ZZ1")
		ZZ1->ZZ1_EMISSA 	:= dEmissao

		ZZ1->ZZ1_SERIE		:= cSerieNf
		ZZ1->ZZ1_NOTA		:= cNumNota

		MsUnlock()
	Endif

//	If SF2->F2_TIPO == 'N' .And. lHabWkf
//		LJMsgRun( "Aguarde. Enviando E-Mail...",, {|| EnvNFE()} )
//	EndIf
    
	//-----------------------------------------------------------------------------------
	// Vinculo do portador de acordo com a definição do financeiro.
	//-----------------------------------------------------------------------------------
	dbSelectArea("SA6")
	dbGotop()
	While !Eof()
		
		If SA6->A6_FATPORT == "1" .And. SA6->A6_BLOCKED  == "2"
	
			cDadBco:= SuperGetMv(&(SA6->A6_CXPOSTA),.F.,.F.)
			exit	
		EndIf
		dbSkip()
	End
	
	//-----------------------------------------------------------------------------------
	// Chama a execução do calculo da margem de contribuição. 22/11/2019
	//-----------------------------------------------------------------------------------
	U_MFAT0008(xFilial("SF2"),cNumNota,cSerieNf)	
	
	/*
	Risco do cliente 31/01/2017 -Regra retirada em 25/09/2017 - solicitado por Marcio Fischer.
	//******************
	//Davidson Clayton *
	//******************
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1")+cCliente+cLojaCli)

		If SA1->A1_RISCO == "A" .Or. SA1->A1_RISCO == "B"

			If lAtivFidc    //Ativa o uso do banco FIDIC.
				cDadBco:=cDadFidAB
			Else
				cDadBco:=cDadRAB
			EndIf
		Else
			cDadBco:=cDadRDEF
		EndIf
	EndIf
    */
    
	// -- Final Davis 24/02/2016

	//******************
	//Nelltech - Lucas *
	//******************
	DBSELECTAREA("SE1")
	DBSETORDER(2)
	_lRet := DBSEEK(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC)
	WHILE _lRet
		IF SE1->E1_NUM = SF2->F2_DOC .AND. SE1->E1_PREFIXO = SF2->F2_SERIE
			IF EMPTY(SE1->E1_C_NATUR)
				RECLOCK("SE1",.F.)
				SE1->E1_C_NATUR := POSICIONE("SED", 1, xFilial("SED")+SC5->C5_NATUREZ, "ED_DESCRIC" )
				MSUNLOCK()
			ENDIF
			dbSkip()
		ELSE
			_lRet	:= .F.
		ENDIF
	ENDDO

	RestArea(_aArea)
	RestArea(_aAreaSE1)

	/*
	Solicitada retirada da gravação do bordero por Sandro Cavalcante/Dieiny Controladoria.
	Motivo: Ao iniciarmos os trabalhos com o banco Athena vimos a necessidade de criarmos os
	titulos a receber sem vinculo com borderos
	Davidson Clayton - 30/01/2017.*/

	//INICIO DA RETIRADA DO BORDERO

	//LIBERDADE 03/03/2015
	IF SC5->C5_TIPO = 'N'
		aArea:=		GetArea()
		aAreaSE1:=	SE1->(GetArea())
		cNumbor:= 	substr(DToS(dDataBase),7,2)
		cNumbor+= 	substr(DToS(dDataBase),5,2)
		cNumbor+= 	substr(DToS(dDataBase),3,2)
		cKey:=		SF2->(F2_FILIAL+F2_PREFIXO+F2_DOC)

		IF !EMPTY(SF2->F2_DUPL)
			//		IF MSGYESNO("Deseja realizar a inclusao do titulo no bordero "+cNumbor+" automaticamente?","BORDERO")

			/*
			-- Davis 25/02/2016
			AjustSx1( "M460FIM" )
			999888887777777777
			Pergunte("M460FIM",.T.)
			*/
			cCodBco := Substr(cDadBco,1,3)
			cAgencia := Substr(cDadBco,4,5)
			cNumCta  := Substr(cDadBco,9,10)

			DBSELECTAREA("SE1")
			DBSETORDER(1)
			DBSEEK(cKey)
			WHILE !EOF() .AND. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) == ckey

				RECLOCK("SE1",.F.)
				//				SE1->E1_DATABOR	:=	DDATABASE
				//				SE1->E1_NUMBOR 	:=	cNumbor
				SE1->E1_SITUACA := 	"0"	// 0-Nao  montar bordero - "1"-Monta bordero.
				SE1->E1_PORTADO := cCodBco   //MV_PAR01  //GetNewPar("NT_BCOBOR","001")
				SE1->E1_AGEDEP  := cAgencia  //MV_PAR02  //GetNewPar("NT_AGEBOR","00001")
				SE1->E1_NUMCON  := cNumCta   //MV_PAR03  //GetNewPar("NT_CTABOR","000001")   
				SE1->E1_CONTA  	:= cNumCta
				MSUNLOCK()
				/*Davidson 02/02/17 -Não gerar bordero.
				RECLOCK("SEA",.T.)
				SEA->EA_NUMBOR	:= cNumbor
				SEA->EA_FILIAL  := xFilial("SEA")
				SEA->EA_DATABOR := dDataBase
				SEA->EA_PORTADO := cCodBco     //MV_PAR01  //GetNewPar("NT_BCOBOR","001")
				SEA->EA_AGEDEP  := cAgencia    // MV_PAR02 //GetNewPar("NT_AGEBOR","00001")
				SEA->EA_NUMCON  := cNumCta     //MV_PAR03  //GetNewPar("NT_CTABOR","000001")
				SEA->EA_PREFIXO := SE1->E1_PREFIXO
				SEA->EA_NUM  	  := SE1->E1_NUM
				SEA->EA_PARCELA := SE1->E1_PARCELA
				SEA->EA_TIPO 	:= SE1->E1_TIPO
				SEA->EA_CART 	:= "R"
				SEA->EA_SITUACA := "1"
				SEA->EA_SITUANT := "0"
				SEA->EA_FILORIG := xFilial("SE1")
				SEA->EA_PORTANT := ""
				SEA->EA_AGEANT  := ""
				SEA->EA_CONTANT := ""
				MSUNLOCK()
				*/
				DBSELECTAREA("SE1")
				DBSKIP()
			END
			//	ENDIF
		ENDIF

		RestArea(aArea)
		RestArea(aAreaSE1)

	ENDIF

	//FIM DO TRATAMENTO

	aArea:=		GetArea()
	aAreaSE1:=	SE1->(GetArea())
	//INICIO DO PROCESSO DE COMPENSAÇÃO DE RA /NCC
	DBSELECTAREA("SE1")
	DbSetOrder(1)
	DbSeek(SF2->(F2_FILIAL+F2_PREFIXO+F2_DOC))
	WHILE !EOF() .AND. SF2->(F2_FILIAL+F2_PREFIXO+F2_DOC) == SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM)

		cQuery:=	"SELECT R_E_C_N_O_ REC FROM "+RETSQLNAME("SE1")+" SE1 "
		cQuery+=	"WHERE D_E_L_E_T_ = ' ' AND "
		cQuery+=	"E1_CLIENTE='"+SF2->F2_CLIENTE+"' AND "
		cQuery+=	"E1_LOJA='"+SF2->F2_LOJA+"' And "
		cQuery+=	"E1_SALDO > 0 And "
		cQuery+=	"E1_TIPO IN "+FORMATIN(GETNEWPAR("NT_TPCRCLI","RA /NCC"),"/")+" "

		dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), "LIBTMP", .F., .T.)

		If !LIBTMP->(EOF())

			If Type("lCompLiber") == "U"
				If MsgYesNo("Este cliente contem titulo(s) do Tipo NCC e/ou RA em aberto, deseja compensa-lo(s) neste momento?")
					lCompLiber:=.T.

					SetKey (VK_F12,{|a,b| AcessaPerg("FIN330",.T.)})
					Pergunte("FIN330",.T.)

				Else
					lCompLiber:=.F.
				EndIf
			EndIf

			If !lCompLiber

				//Fecha tabela temporaria e restaura SE2
				DbSelectArea("LIBTMP")
				DbCloseArea()
				RestArea(aAreaSE1)

				lCompLiber:=Nil

				Return()

			EndIf

			DbSelectArea("SE1")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Define o cabe‡alho da tela de baixas		   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PRIVATE cCadastro := "Compensa‡„o de Titulos a Receber"  //"Compensa‡„o de Titulos a Receber"
			PRIVATE cLote			// Utilizado para Contabilizacao
			PRIVATE VALOR 	:= 0 	// Utilizada para Contabilizacao
			PRIVATE VALORMF 	:= 0 	// Utilizada para Contabilizacao
			PRIVATE VALOR7 	:= 0 	// Utilizada para Contabilizacao
			Private lOracle	:= "ORACLE"$Upper(TCGetDB())

			PRIVATE nTamTit := TamSX3("E1_PREFIXO")[1]+TamSX3("E1_NUM")[1]+TamSX3("E1_PARCELA")[1]
			PRIVATE nTamTip := TamSX3("E1_TIPO")[1]
			PRIVATE nTamLoj := TamSX3("E1_LOJA")[1]
			Private aTxMoedas	:=	{}
			Private cCodDiario	:= ""

			l330Auto := .F.

			Fa330Comp("SE1",,4)

		EndIf

		DbSelectArea("LIBTMP")
		DbCloseArea()

		DBSELECTAREA("SE1")
		DBSKIP()
	END
	RestArea(aArea)
	SE1->(RestArea(aAreaSE1))

	//******************
	//Nelltech - Lucas *
	//******************
	_aArea    := GetArea()
	_aAreaSA3 := SA3->(GetArea())
	_aAreaSE1 := SE1->(GetArea())
	_aAreaSC6 := SC6->(GetArea())

	//itens da NF
	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
	While SD2->(!Eof()) .And. SD2->D2_DOC==SF2->F2_DOC .And. SD2->D2_SERIE==SF2->F2_SERIE .And. SD2->D2_CLIENTE==SF2->F2_CLIENTE .And. SD2->D2_LOJA==SF2->F2_LOJA

		//busco base e percentual na SC6
		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		SC6->(DbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD))
		If SC6->(Found()) .And. SC6->C6_C_PERCO > 0		//calculo se percentual maior que 0

			_cPedido := SD2->D2_PEDIDO
			_cItemPV := SD2->D2_ITEMPV
			_cCod	 := SD2->D2_COD
			_nICMS   := SD2->D2_VALICM
			_nCofins := SD2->D2_VALIMP5
			_nPis    := SD2->D2_VALIMP6

			//codigo vendedor cabecalho NF
			_cVend   := SF2->F2_VEND1

			// Busca no cadastro do vendedor se deduz o valor do icms da base comissao
			_cICMS   := Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_ICM")

			// Deducao do valor do ICMS da base da comissao de acordo com o cadastro do vendedor
			If _cICMS  == "S"
				_nBasComis  := SC6->C6_C_BASCO - (( _nICMS * _nNpIcms)/100)
			Else
				_nBasComis  := SC6->C6_C_BASCO
			EndIf

			// Busca no cadastro do vendedor se deduz o valor do PIS/COFINS da base comissao
			_cPisCof  := Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_PISCOF")

			Do Case
				Case _cPisCof  == "2"
				_nBasComis  := _nBasComis  - _nPis
				Case _cPisCof  == "3"
				_nBasComis  := _nBasComis  - _nCofins
				Case _cPisCof  == "4"
				_nBasComis := _nBasComis - _nPis - _nCofins
			EndCase

			//salva nova base
			RecLock("SC6",.F.)
			SC6->C6_C_BASCO := _nBasComis
			SC6->C6_C_DESIM := "S"
			SC6->(MsUnlock())

			nTotVenda	:= nTotVenda + (SC6->C6_QTDVEN * SC6->C6_C_VLRDI)				//valor venda (sem deducao)
			nTotBase	:= nTotBase + SC6->C6_C_BASCO									//valor base comissao (sem deducao)
			nValComIt	:= ((SC6->C6_QTDVEN * SC6->C6_C_VLRDI)*SC6->C6_C_PERCO)/100	//valor comissao por item (sem deducao)
			nValComTot	:= nValComTot + nValComIt										//valor comissao todos itens

		EndIf

		SD2->(DbSkip())
	EndDo

	//quantidade de parcelas titulo financeiro
	DbSelectArea("SE1")
	SE1->(DbSetOrder(2))
	SE1->(DbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC))
	If SE1->(Found())
		While SE1->(!Eof()) .And. SE1->E1_CLIENTE==SF2->F2_CLIENTE .And. SE1->E1_LOJA==SF2->F2_LOJA .And. SE1->E1_PREFIXO==SF2->F2_SERIE .And. SE1->E1_NUM==SF2->F2_DOC
			nParc++
			aAdd(aParcela,{nParc,SE1->E1_VALOR,0})
			SE1->(DbSkip())
		EndDo
	EndIf

	//valor total do titulo somando todas parcelas
	nI:=0
	While nI < Len(aParcela)
		nI++
		nTitulo := nTitulo + aParcela[nI,2]
	EndDo

	//salvo percentual de cada titulo na terceira posicao do titulo
	nI := 0
	While nI < Len(aParcela)
		nI++
		nPercItem := (aParcela[nI,2]/nTitulo)*100
		aParcela[nI,3] := nPercItem
	EndDo

	//Encontra Percentual medio todos itens
	nMediaPerc := (nValComTot/nTotVenda)*100	//Percentual medio eh igual valor da Comissao dividido pelo valor da Venda
	//	nBaseComis := nTotBase/nParc			//Comissao eh igual base dividido por parcelas

	nI := 0
	DbSelectArea("SE1")
	SE1->(DbSetOrder(2))
	SE1->(DbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC))
	If SE1->(Found())
		While SE1->(!Eof()) .And. SE1->E1_CLIENTE==SF2->F2_CLIENTE .And. SE1->E1_LOJA==SF2->F2_LOJA .And. SE1->E1_PREFIXO==SF2->F2_SERIE .And. SE1->E1_NUM==SF2->F2_DOC
			nI++
			//comissao sera total da base vezes a porcentagem que representa a parcela
			nBaseComis := nTotBase * (aParcela[nI,3]/100)

			RecLock("SE1",.F.)
			SE1->E1_C_PERCO := nMediaPerc
			SE1->E1_C_BASCO := nBaseComis
			SE1->(MsUnlock())

			SE1->(DbSkip())
		EndDo
	EndIf

	RestArea(_aAreaSA3)
	RestArea(_aAreaSE1)
	RestArea(_aAreaSC6)
	RestArea(_aArea)
	//******************
	//Nelltech - Lucas *
	//******************

RETURN()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustSx1     ³ Autor³Wander Souza Silva    ³Data³ 12.03.15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria nova pergunta para o banco do bordero                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustSx1(cPerg)
	Local aArea 	:= GetArea()
	Local aHelpPor	:= {}
	Local aHelpEng	:= {}
	Local aHelpSpa	:= {}

	Aadd(aHelpPor,"Informe o banco do bordero              ")
	Aadd(aHelpSpa,"Informe o banco do bordero              ")
	Aadd(aHelpEng,"Informe o banco do bordero              ")
	PutSX1(cPerg,"01","Banco   ?","Banco   ?" ,"Banco ?","mv_ch1","C",TamSX3("A6_COD")[1],0,1,"G","EXISTCPO('SA6')","SA6"   ,"S","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")
	PutHelp( "P." + cPerg + "01.", aHelpPor, aHelpEng, aHelpSpa, .T. )

	aHelpPor	:= {}
	aHelpEng	:= {}
	aHelpSpa	:= {}

	Aadd(aHelpPor,"Informe a agencia do bordero              ")
	Aadd(aHelpSpa,"Informe a agencia do bordero              ")
	Aadd(aHelpEng,"Informe a agencia do bordero              ")
	PutSX1(cPerg,"02","Agencia ?","Agencia ?" ,"Agencia?","mv_ch2","C",TamSX3("A6_AGENCIA")[1],0,1,"G","",""   ,"S","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")
	PutHelp( "P." + cPerg + "02.", aHelpPor, aHelpEng, aHelpSpa, .T. )

	aHelpPor	:= {}
	aHelpEng	:= {}
	aHelpSpa	:= {}

	Aadd(aHelpPor,"Informe a conta do bordero              ")
	Aadd(aHelpSpa,"Informe a conta do bordero              ")
	Aadd(aHelpEng,"Informe a conta do bordero              ")
	PutSX1(cPerg,"03","Conta   ?","Conta   ?" ,"Conta  ?","mv_ch3","C",TamSX3("A6_NUMCON")[1],0,1,"G","",""   ,"S","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")
	PutHelp( "P." + cPerg + "03.", aHelpPor, aHelpEng, aHelpSpa, .T. )

	RestArea(aArea)

	Return()


	// -- Dados do E-Mail

//------------------------------------------------------------------+

	/*/{Protheus.doc} EnvNfe()
	Envia E-Mail da NF para o Vendedor e Supervisor
	@author 	Davis Magalhaes
	@since 		24/02/2016
	@version 	P11 R5
	@param   	n/t
	@return  	n/t
	@obs        Programa Especifico para Nutratta
	/*/
//------------------------------------------------------------------+

Static Function EnvNFE()

	Local cQuanti  := ""
	Local cDescricao := ""
	Local nQtdTotal := 0
	Local nPesBrut   := 0
	Local lImprMens := .F.
	Local lMenIPI := .F.
	Local cPedCli := ""
	Local cMensPed := " "
	Local cMensPad := " "
	Local cEndCli  := " "
	Local cEndes   := ""
	Local cMensagemNF := ""
	Local cNomCom	  := Alltrim(SM0->M0_NOMECOM)
	Local cEndCod     := SM0->M0_ENDCOB //Iif(xFilial() == "01","Rua José Maria de Lacerda, 1251 - A","Rua Dr. Alvaro Camargos, 470")
	Local cBaiCod     := SM0->M0_BAIRCOB //Iif(xFilial() == "01","Cidade Industrial","Santa Monica")
	Local cCidCod     := "CEP: "+SM0->M0_CEPCOB+" - "+SM0->M0_CIDCOB+" / "+SM0->M0_ESTCOB   //Iif(xFilial() == "01","CEP: 32210-120  -  Contagem / MG","CEP: 31515-200 - Belo Horizonte / MG")
	Local cTelCod     := "Fone: "+SM0->M0_TEL +" - Fax: "+SM0->M0_FAX  // Fone:Iif(xFilial() == "01","Fone: (31) 3307-3535  -  Fax: (31) 3307-3535", "Fone: (31) 3451-5285  /  3451-8863")
	Local cCNPJCod    := "CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+"  -  Inscrição Estadual: "+SM0->M0_INSC //Iif(xFilial() == "01","CNPJ: 71.292.924/0001-57  -  Inscrição Estadual: 186849379 00 98","CNPJ: 03.043.417/0001-20  -  Inscrição Estadual: 186038870 00 87")
	Local cEmailCod   := "E-Mail: nutratta@nutratta.com.br   -   Site: www.nutratta.com.br"
	Local cV1Email    := ""
	Local cV2Email    := ""
	Local cEnds       := ""
//x	Local cEmailBcc   := SuperGetMv("NT_EMAILNF",.F.,"nutratta@nutratta.com.br")
	Local cSupervi	  := ""
	Local cGerente	  := ""
	Local cEmailVen   := ""
	Local cEmailGer	  := ""
	Local cEmailSup   := ""

	oProcess := TWFProcess():New( "NFNUTR", "Nota Fiscal" )
	//If xFilial() == "01" .Or. xFilial() == "02"
	oProcess:NewTask( "NFNUTR", "\WORKFLOW\HTML\NFNUTR01.HTM" )
	//Else
	//   oProcess:NewTask( "Nota Fiscal", "\WORKFLOW\HTML\NFCORTB.HTM" )
	//EndIf
	oProcess:UserSiga := __cUserID
	oProcess:NewVersion(.T.)
	oHTML := oProcess:oHTML

	oHTML:ValByName("NOMECOME",cNomCom)
	oHTML:ValByName("ENDERECO",cEndCod)
	oHTML:ValByName("BAIRROCOD",cBaiCod)
	oHTML:ValByName("CIDADECOD",cCidCod)
	oHTML:ValByName("TELEFCOD",cTelCod)
	oHTML:ValByName("CNPJCOD",cCNPJCod)
	oHTML:ValByName("EMAILCOD",cEmailCod)

	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+cNumNota+cSerieNF+cCliente+cLojaCli)

	oHTML:ValByName('CFOP',SD2->D2_CF)

	dbSelectArea("SX5")
	If dbSeek(xFilial("SX5")+"13"+SD2->D2_CF)
		cDescNat := Alltrim(X5Descri())
	EndIf

	oHTML:ValByName('DESCCFOP',cDescNat)
	oHTML:ValByName('NUMNF',cNumNota)
	oHTML:ValByName('DTEMISSAO',dEmissao)
	oHTML:ValByName('CODCLIE',cCliente+"/"+cLojaCli)

	// Posiciona o Cliente da Nota Fiscal

	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+cCliente+cLojaCli)

	//cEndCli := SA1->A1_EMAILNF
	oHTML:ValByName('RAZAOSOC',SA1->A1_NOME)
	oHTML:ValByName('ENDCLI',SA1->A1_END)
	oHTML:ValByName('BAIRROCLI',SA1->A1_BAIRRO)
	oHTML:ValByName('MUNCLI',SA1->A1_MUN)
	oHTML:ValByName('UFCLI',SA1->A1_EST)
	oHTML:ValByName('CEPCLI',SA1->A1_CEP)
	oHTML:ValByName('CNPJCLI',Transform(Posicione("SA1",1,xFilial("SA1")+cCliente+cLojaCli,"A1_CGC"),IIf(SA1->A1_PESSOA == "J","@R ##.###.###/####-##","@R ###.###.###-##")))
	oHTML:ValByName('INSCRCLI',IIf(SA1->A1_PESSOA == "J",SA1->A1_INSCR,SA1->A1_PFISICA))
	oHTML:ValByName('DDDTEL',SA1->A1_DDD)
	oHTML:ValByName('DDDFAX',SA1->A1_DDD)
	oHTML:ValByName('TELCLI',SA1->A1_TEL)
	oHTML:ValByName('FAXCLI',SA1->A1_FAX)

	dbSelectArea("SF2")
	oHTML:ValByName('CONDPAG',Posicione("SE4",1,xFilial("SE4")+SF2->F2_COND,"E4_DESCRI"))

	dbSelectArea("SE1")
	dbSetOrder(1)
	If dbSeek(xFilial("SE1")+cSerieNF+cNumNota)

		While ! SE1->(Eof()) .And. SE1->E1_FILIAL == xFilial("SE1") .And. SE1->E1_PREFIXO == cSerieNF .And. SE1->E1_NUM == cNumNota

			aAdd((oHTML:ValByName('FT.PREFIXO')),SE1->E1_PREFIXO)
			aAdd((oHTML:ValByName('FT.NUM')),SE1->E1_NUM)
			aAdd((oHTML:ValByName('FT.PARC')),SE1->E1_PARCELA)
			aAdd((oHTML:ValByName('FT.VENC')),SE1->E1_VENCREA)
			aAdd((oHTML:ValByName('FT.VALOR')),Transform(SE1->E1_SALDO,"@E 999,999,999.99"))

			dbSelectArea("SE1")
			dbSkip()
		End
	Else
		aAdd((oHTML:ValByName('FT.PREFIXO')),".")
		aAdd((oHTML:ValByName('FT.NUM')),".")
		aAdd((oHTML:ValByName('FT.PARC')),".")
		aAdd((oHTML:ValByName('FT.VENC')),".")
		aAdd((oHTML:ValByName('FT.VALOR')),Transform(0,"@E 999,999,999.99"))
	EndIf

	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+cNumNota+cSerieNF+cCliente+cLojaCli)
	cNumPed := SD2->D2_PEDIDO

	While ! SD2->( Eof() ) .And. SD2->D2_FILIAL == xFilial("SD2") .And. SD2->D2_DOC == cNumNota .And. ;
	SD2->D2_SERIE == cSerieNF .And. SD2->D2_CLIENTE == cCliente .And. SD2->D2_LOJA == cLojaCli

		dbSelectArea("SD2")

		aAdd((oHTML:ValByName('IT.CODIGO')),AllTrim(SD2->D2_COD))

		dbSelectArea("SC6")
		SC6->( dbSetOrder(1) )
		SC6->( dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD) )

		dbSelectArea("SB1")
		SB1->( dbSetOrder(1) )
		SB1->( dbSeek(xFilial("SB1")+SD2->D2_COD) )

		aAdd((oHTML:ValByName('IT.DESCPROD')),AllTrim(SB1->B1_DESC))  // Descricao do Produto

		aAdd((oHTML:ValByName('IT.CF')),AllTrim(SB1->B1_POSIPI))
		aAdd((oHTML:ValByName('IT.CST')),SD2->D2_CLASFIS)

		aAdd((oHTML:ValByName('IT.UM')),SD2->D2_UM)
		aAdd((oHTML:ValByName('IT.QTDE')),Transform(SD2->D2_QUANT,"@E 99,999.999"))   // Quantidade

		nPesBrut += SD2->D2_QUANT

		aAdd((oHTML:ValByName('IT.VLUNIT')),Transform(SD2->D2_PRCVEN,"@E 99,999.99")) // Valor Unitario
		aAdd((oHTML:ValByName('IT.VLTOTAL')),Transform(SD2->D2_TOTAL,"@E 9,999,999.99")) // Valor Total

		aAdd((oHTML:ValByName('IT.ICMS')),Transform(SD2->D2_PICM,"@E 99"))
		aAdd((oHTML:ValByName('IT.IPI')),Transform(SD2->D2_IPI,"@E 99"))
		aAdd((oHTML:ValByName('IT.VLIPI')),Transform(SD2->D2_VALIPI,"@E 99999.99"))

		dbSelectArea("SD2")
		SD2->( dbSkip() )
	End

	dbSelectArea("SF2")

	If SF2->F2_ICMSRET > 0
		dbSelectArea("SF3")
		dbSetOrder(4)
		If dbSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
			nBaseICMRet := SF3->F3_VALOBSE
		Else
			nBaseICMRet := 0
		Endif
	Else
		nBaseICMRet:=0
	Endif

	oHTML:ValByName('BCICMS',Transform(SF2->F2_BASEICM,"@E 999,999.99"))  // Base Calculo ICMS
	oHTML:ValByName('VLICMS',Transform(SF2->F2_VALICM,"@E 999,999.99"))
	oHTML:ValByName('BCICMSST',Transform(nBaseICMRet,"@E 999,999.99"))
	oHTML:ValByName('VLICMSST',Transform(SF2->F2_ICMSRET,"@E 999,999.99"))
	oHTML:ValByName('VLPRODUTO',Transform(SF2->F2_VALMERC,"@E 999,999.99"))
	oHTML:ValByName('VLFRETE',Transform(SF2->F2_FRETE,"@E 999,999.99"))
	oHTML:ValByName('VLSEGURO',Transform(SF2->F2_SEGURO,"@E 999,999.99"))
	oHTML:ValByName('VLDESPESAS',Transform(SF2->F2_DESPESA,"@E 999,999.99"))
	oHTML:ValByName('VLIPI',Transform(SF2->F2_VALIPI,"@E 9,999,999.99"))
	oHTML:ValByName('VLTOTALNF',Transform(SF2->F2_VALBRUT,"@E 999,999,999.99"))

	// Transporte

	oHTML:ValByName('RZTRANSP',Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP,"A4_NOME"))

	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5")+cNumPed)

	cMensPed     := SC5->C5_MENNOTA
	cMensPad     := SC5->C5_MENPAD

	If Empty(cVend1)
		cVend1 := SC5->C5_VEND1
	EndIf
	If SC5->C5_TPFRETE == "C"
		oHTML:ValByName('FRTCONTA',"1-Emitente")
	Else
		oHTML:ValByName('FRTCONTA',"2-Destinatario")
	EndIf

	oHTML:ValByName('PLACA',SF2->F2_VEICUL1) //PLACA
	oHTML:ValByName('UFV',Posicione("DA3",1,xFilial("DA3")+SF2->F2_VEICUL1,"DA3_ESTPLA"))

	If Len(Alltrim(Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP,"A4_CGC"))) < 14
		oHTML:ValByName('CNPJTRANSP',Transform(Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP,"A4_CGC"),"@R 999.999.999-99"))
	Else
		oHTML:ValByName('CNPJTRANSP',Transform(Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP,"A4_CGC"),"@R 99.999.999/9999-99"))
	EndIf

	oHTML:ValByName('ENDTRANSP',Iif( ! Empty(Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP,"A4_END")),Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP,"A4_END"),"."))
	oHTML:ValByName('MUNTRANSP',Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP,"A4_MUN"))
	oHTML:ValByName('UFT',Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP,"A4_EST"))
	oHTML:ValByName('INSCTRANSP',Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP,"A4_INSEST"))

	oHTML:ValByName('QUANTIDADE',Transform(SF2->F2_VOLUME1,"@E 999,999"))
	oHTML:ValByName('ESPECIE',SF2->F2_ESPECI1)
	oHTML:ValByName('MARCA',"  ")
	oHTML:ValByName('PESOBRT',Transform(SF2->F2_PBRUTO,"@E 999,999.999"))
	oHTML:ValByName('PESOLIQ',Transform(SF2->F2_PLIQUI,"@E 999,999.999"))

	cMensagemNF += cMensPed+"<br>"

	If ! Empty(cMensPad)

		cMensagem:=Formula(cMensPad)

		If cMensagem # NIL
			cMensagemNF += Substr(cMensagem,1,90)+"<br>"
			cMensagemNF += Substr(cMensagem,91,90)+"<br>"
		EndIf
	EndIf

	oHTML:ValByName('MENSAGEM',cMensagemNF)

	dbSelectArea("SA3")
	dbSetOrder(1)
	If dbSeek(xFilial("SA3")+cVend1)
		cEmailVen := SA3->A3_EMAIL
		cSupervi := SA3->A3_SUPER
		cGerente := SA3->A3_GEREN
	EndIf

	dbSelectArea("SA3")
	dbSetOrder(1)
	If dbSeek(xFilial("SA3")+cGerente)
		cEmailGer := SA3->A3_EMAIL
	EndIf

	dbSelectArea("SA3")
	dbSetOrder(1)
	If dbSeek(xFilial("SA3")+cSupervi)
		cEmailSup := SA3->A3_EMAIL
	EndIf

	If ! Empty(cEmailVen) .And. ! empty(cEmailSup).And. ! empty(cEmailGer)
		cEnds := cEmailVen+";"+cEmailSup+";"+cEmailGer
	ElseIf ! Empty(cEmailVen) .And.  ! Empty(cEmailSup) .And. Empty(cEmailGer)
		cEnds := cEmailVen+";"+cEmailSup
	ElseIf ! Empty(cEmailVen) .And.  empty(cEmailSup) .And. ! empty(cEmailGer)
		cEnds := cEmailVen+";"+cEmailGer
	ElseIf ! Empty(cEmailVen) .And.  empty(cEmailSup) .And. empty(cEmailGer)
		cEnds := cEmailVen
	Else
		cEnds := "nutratta@nutratta.com.br"
	EndIf

	oProcess:cTo  		:= cEnds
	oProcess:cBcc 		:= cEmailBcc
	oProcess:cSubject 	:= "Nota Fiscal Saida No. "+cNumNota+" - Serie: "+cSerieNf

	oProcess:Start()
	oProcess:Finish()

Return
