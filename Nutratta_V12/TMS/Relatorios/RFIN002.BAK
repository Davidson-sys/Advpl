#INCLUDE "TOTVS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TBIConn.CH"
#INCLUDE "topconn.ch"

/*
¦+-----------------------------------------------------------------------------+¦
¦¦Programa  ¦ RFIN002          ¦ Autor ¦ Lucas Nogueira     ¦ Data ¦ 27/06/2016¦¦
¦+----------+------------------------------------------------------------------¦¦
¦¦Descrição ¦Relatório Fretes Nutratta                         		       	   ¦¦
¦¦          ¦                                                                  ¦¦
¦+----------+------------------------------------------------------------------¦¦
¦¦			ATUALIZAÇÕES SOFRIDAS DESDE A CONSTRUÇÃO INICIAL     			   ¦¦
¦+-----------------------------------------------------------------------------¦¦
¦¦ Analista 	 ¦ Data    ¦  Motivo da Alteração				       		   ¦¦
¦+---------------+---------+---------------------------------------------------¦¦
¦¦Lucas Nogueira ¦17/08/16 ¦Inclusão Unidade de MEdida a pedido do Tiago	   ¦¦
¦+---------------+---------+---------------------------------------------------¦¦
¦¦	 		     ¦	       ¦											       ¦¦
¦+---------------+---------+---------------------------------------------------+¦
*/
User function RFIN002()

Local oReport
Private _cPerg 	:= "RFIN002"

	//¦+-------------------------------------------------------------¦¦
	//¦¦ Valida Pergunta                                             ¦¦
	//¦+-------------------------------------------------------------+¦
	ValidPerg(_cPerg)
	Pergunte(_cPerg,.T.)

	oReport := TReport():New("RFIN002 - Fretes Nutratta "+ dTos(MV_PAR01) +" - " + dTos(MV_PAR02) + "", "Controle Fretes Cobrados Nutratta", , {|oReport| PrintReport(oReport)},"")
	oReport:nFontBody := 8 //Define o tamanho da fonte  
	
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()
	
	oReport:SetLandScape() //Paisagem
	//oReport:SetPortrait() //Retrato
	
	oReport:SetTotalInLine(.F.)

	oSection1 := TRSection():New(oReport,"Fretes Nutratta", {"SC5","SC6","SD2","SB1","SA1","SB1"})
	oSection1:SetTotalInLine(.F.)
	
	TRCell():New(oSection1	,"C5_FILIAL"  	,"SC5"	,"Filial"				,PesqPict('SC5',"C5_FILIAL")	,TamSX3("C5_FILIAL")[1]+1	)
	TRCell():New(oSection1	,"C5_EMISSAO"  	,"SC5"	,"Emissao PV"			,PesqPict('SC5',"C5_EMISSAO")	,TamSX3("C5_EMISSAO")[1]+1	)
	TRCell():New(oSection1	,"C5_NUM" 		,"SC5"	,"Numero PV"			,PesqPict('SC5',"C5_NUM") 		,TamSX3("C5_NUM")[1]+1		)
	TRCell():New(oSection1	,"C5_CLIENTE"	,"SC5"	,"Cliente"				,PesqPict('SC5',"C5_CLIENTE") 	,TamSX3("C5_CLIENTE")[1]+1	)
	TRCell():New(oSection1	,"C5_LOJACLI"	,"SC5"	,"Loja"					,PesqPict('SC5',"C5_LOJACLI") 	,TamSX3("C5_LOJACLI")[1]+1	)
	TRCell():New(oSection1	,"C5_NOMCLI"	,"SC5"	,"Nome"					,PesqPict('SC5',"C5_NOMCLI") 	,TamSX3("C5_NOMCLI")[1]+1	)
	TRCell():New(oSection1	,"C5_VEND1"		,"SC5"	,"Vendedor"				,PesqPict('SC5',"C5_VEND1") 	,TamSX3("C5_VEND1")[1]+1	)
	TRCell():New(oSection1	,"D2_EMISSAO"	,"SD2"	,"Emissao NF"			,PesqPict('SD2',"D2_EMISSAO") 	,TamSX3("D2_EMISSAO")[1]+1	)
	TRCell():New(oSection1	,"D2_DOC"		,"SD2"	,"Nota Fiscal"			,PesqPict('SD2',"D2_DOC") 		,TamSX3("D2_DOC")[1]+1		)
	TRCell():New(oSection1	,"D2_EST"		,"SD2"	,"Estado"				,PesqPict('SD2',"D2_EST") 		,TamSX3("D2_EST")[1]+1		)
	TRCell():New(oSection1	,"A1_MUN"		,"SA1"	,"Municipio"			,PesqPict('SA1',"A1_MUN") 		,TamSX3("A1_MUN")[1]+1		)
	TRCell():New(oSection1	,"C5_TPFRETE"	,"SC5"	,"Tp Frete"				,PesqPict('SC5',"C5_TPFRETE") 	,TamSX3("C5_TPFRETE")[1]+1	)
	TRCell():New(oSection1	,"D2_COD"		,"SD2"	,"Produto"				,PesqPict('SD2',"D2_COD") 		,TamSX3("D2_COD")[1]+1		)
	TRCell():New(oSection1	,"B1_DESC"		,"SB1"	,"Descricao"			,PesqPict('SB1',"B1_DESC") 		,TamSX3("B1_DESC")[1]+1		)
	TRCell():New(oSection1	,"B1_UM"		,"SB1"	,"Un. Medida"			,PesqPict('SB1',"B1_UM") 		,TamSX3("B1_UM")[1]+1		)
	TRCell():New(oSection1	,"C6_QTDVEN"	,"SC6"	,"Quantidade"			,PesqPict('SC6',"C6_QTDVEN") 	,TamSX3("C6_QTDVEN")[1]+1	)
	TRCell():New(oSection1	,"C6_C_VLRDI"	,"SC6"	,"Vlr Unit Padrao"		,PesqPict('SC6',"C6_C_VLRDI") 	,TamSX3("C6_C_VLRDI")[1]+1	)
	TRCell():New(oSection1	,"C6_C_FRETE"	,"SC6"	,"Frete"				,PesqPict('SC6',"C6_C_FRETE") 	,TamSX3("C6_C_FRETE")[1]+1	)
	TRCell():New(oSection1	,"C6_PRCVEN"	,"SC6"	,"Preco Venda"			,PesqPict('SC6',"C6_PRCVEN") 	,TamSX3("C6_PRCVEN")[1]+1	)
	TRCell():New(oSection1	,"C6_VALOR"		,"SC6"	,"Vlr Total"			,PesqPict('SC6',"C6_VALOR") 	,TamSX3("C6_VALOR")[1]+1	)
	TRCell():New(oSection1	,"C5_C_VFRET"	,"SC5"	,"Frete Total"			,PesqPict('SC5',"C5_C_VFRET") 	,TamSX3("C5_C_VFRET")[1]+1	)
	TRCell():New(oSection1	,"C6_CF"		,"SC6"	,"CFOP"					,PesqPict('SC6',"C6_CF") 		,TamSX3("C6_CF")[1]+1		)
     
	oReport:PrintDialog()

return()

/*
¦+-----------------------------------------------------------------------------+¦
¦¦Programa  ¦               ¦ Autor ¦ Lucas Nogueira     ¦ Data ¦ 27/06/2016¦¦
¦+----------+------------------------------------------------------------------¦¦
¦¦Descrição ¦                                                 		       	   ¦¦
¦¦          ¦                                                                  ¦¦
¦+----------+------------------------------------------------------------------¦¦
¦¦Uso       ¦ <QuaL Rotina Utiliza o Fonte>                                    ¦¦
¦+----------+------------------------------------------------------------------¦¦
¦¦Parametros¦ <Parametros que esta rotina recebe>                              ¦¦
¦+----------+------------------------------------------------------------------¦¦
¦¦Retorno	¦ <Retorno da Rotina>                                          	   ¦¦
¦+-----------------------------------------------------------------------------¦¦
¦¦			ATUALIZAÇÕES SOFRIDAS DESDE A CONSTRUÇÃO INICIAL     			   ¦¦
¦+-----------------------------------------------------------------------------¦¦
¦¦ Analista 	 ¦ Data    ¦  Motivo da Alteração				       		   ¦¦
¦+---------------+---------+---------------------------------------------------¦¦
¦¦	   			 ¦	       ¦							       				   ¦¦
¦+---------------+---------+---------------------------------------------------¦¦
¦¦	 		     ¦	       ¦											       ¦¦
¦+---------------+---------+---------------------------------------------------+¦
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cSql		:= ""

	cSql := "	SELECT 					"
	cSql +=	"		SC5.C5_FILIAL,  	"
	cSql +=	"		SC5.C5_EMISSAO,		"
	cSql +=	"		SC5.C5_NUM,			"
	cSql +=	"		SC5.C5_CLIENTE,		"
	cSql +=	"		SC5.C5_LOJACLI,		"
	cSql +=	"		SC5.C5_NOMCLI,		"
	cSql +=	"		SC5.C5_VEND1,		"
	cSql +=	"		SD2.D2_EMISSAO,		"
	cSql +=	"		SD2.D2_DOC,			"
	cSql +=	"		SD2.D2_EST,			"
	cSql +=	"		SA1.A1_MUN,			"
	cSql +=	"		SC5.C5_TPFRETE,		"
	cSql +=	"		SD2.D2_COD,			"
	cSql +=	"		SB1.B1_DESC,		"
	cSql += "		SB1.B1_UM,			"
	cSql +=	"		SC6.C6_QTDVEN,		"
	cSql +=	"		SC6.C6_C_VLRDI ,	"
	cSql +=	"		SC6.C6_C_FRETE,		"
	cSql +=	"		SC6.C6_PRCVEN,		"
	cSql +=	"		SC6.C6_VALOR,		"
	cSql +=	"		SC5.C5_C_VFRET,		"
	cSql +=	"		SC6.C6_CF			"
	cSql +=	"	FROM " + RetSqlName("SD2") +" SD2	" 
	cSql +=	"		INNER JOIN " + RetSqlName("SB1") +" SB1 ON	"
	cSql +=	"			SB1.B1_COD = SD2.D2_COD AND SB1.D_E_L_E_T_ = '' "
	
	cSql +=	"		INNER JOIN " + RetSqlName("SC5") +"  SC5 ON  "
	cSql +=	"			SC5.C5_FILIAL = SD2.D2_FILIAL AND SC5.C5_NUM = SD2.D2_PEDIDO  AND  SC5.C5_CLIENTE = SD2.D2_CLIENTE  AND SC5.C5_LOJACLI = SD2.D2_LOJA AND SC5.D_E_L_E_T_ = '' "
	
	cSql +=	"		INNER JOIN " + RetSqlName("SC6") +" SC6 ON "
	cSql +=	"			 SC6.C6_FILIAL = SD2.D2_FILIAL AND SC6.C6_NUM = SD2.D2_PEDIDO AND SC6.C6_ITEM = SD2.D2_ITEM AND SC6.C6_PRODUTO = SD2.D2_COD AND SC6.C6_C_FRETE <> '' AND SC6.D_E_L_E_T_ = '' " 
	
	cSql +=	"		INNER JOIN " + RetSqlName("SA1") +" SA1 ON	"
	cSql +=	"			SA1.A1_COD = SD2.D2_CLIENTE  AND SA1.A1_LOJA = SD2.D2_LOJA "

	cSql +=	"	WHERE "
	cSql +=	"		SD2.D2_EMISSAO BETWEEN '" + Dtos(MV_PAR01)  + "'	 AND 	'" + Dtos(MV_PAR02)  + "' "
	cSql +=	"		AND  SD2.D_E_L_E_T_ = '' "
		
		If MsgYesNo("Deseja filtro complementar para SD2?  ")
			cFiltNF := BuildExpr('SD2',,,.T.,,,,"Regra")
			If !Empty(cFiltNF)
				cSql += " AND "+cFiltNF+" " 												
			Endif
		Endif

	cSql +=	"	ORDER BY SD2.D2_FILIAL, SD2.D2_EMISSAO, SD2.D2_DOC  "
	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cSql),"TRB", .F., .T.)
	
	TcSetField("TRB","TRB->C5_EMISSAO","D")
	TcSetField("TRB","TRB->D2_EMISSAO","D")
	

	TRB->(DbGoTop())
	oReport:SetMeter(TRB->(RecCount()))
	
	oSection1:Init()
	oSection1:SetHeaderSection(.T.)
	
	While TRB->(!Eof())
	
		If oSection1:Cancel()
			Exit
		EndIf
		
		oReport:IncMeter()

		oSection1:Cell("C5_FILIAL"):SetValue(Alltrim(TRB->C5_FILIAL))
		oSection1:Cell("C5_FILIAL"):SetAlign("LEFT")
		
		oSection1:Cell("C5_EMISSAO"):SetValue(TRB->C5_EMISSAO)
		oSection1:Cell("C5_EMISSAO"):SetAlign("LEFT")
		
		oSection1:Cell("C5_NUM"):SetValue(Alltrim(TRB->C5_NUM))
		oSection1:Cell("C5_NUM"):SetAlign("LEFT")
		
		oSection1:Cell("C5_CLIENTE"):SetValue(Alltrim(TRB->C5_CLIENTE))
		oSection1:Cell("C5_CLIENTE"):SetAlign("LEFT")
		
		oSection1:Cell("C5_LOJACLI"):SetValue(Alltrim(TRB->C5_LOJACLI))
		oSection1:Cell("C5_LOJACLI"):SetAlign("LEFT")
		
		oSection1:Cell("C5_NOMCLI"):SetValue(Alltrim(TRB->C5_NOMCLI))
		oSection1:Cell("C5_NOMCLI"):SetAlign("LEFT")
		
		oSection1:Cell("C5_VEND1"):SetValue(Alltrim(TRB->C5_VEND1))
		oSection1:Cell("C5_VEND1"):SetAlign("LEFT")
		
		oSection1:Cell("D2_EMISSAO"):SetValue(TRB->D2_EMISSAO)
		oSection1:Cell("D2_EMISSAO"):SetAlign("LEFT")
		
		oSection1:Cell("D2_DOC"):SetValue(Alltrim(TRB->D2_DOC))
		oSection1:Cell("D2_DOC"):SetAlign("LEFT")
		
		oSection1:Cell("D2_EST"):SetValue(Alltrim(TRB->D2_EST))
		oSection1:Cell("D2_EST"):SetAlign("CENTER")
		
		oSection1:Cell("A1_MUN"):SetValue(Alltrim(TRB->A1_MUN))
		oSection1:Cell("A1_MUN"):SetAlign("LEFT")
		
		oSection1:Cell("C5_TPFRETE"):SetValue(Alltrim(TRB->C5_TPFRETE))
		oSection1:Cell("C5_TPFRETE"):SetAlign("CENTER")
		
		oSection1:Cell("D2_COD"):SetValue(Alltrim(TRB->D2_COD))
		oSection1:Cell("D2_COD"):SetAlign("LEFT")
		
		oSection1:Cell("B1_DESC"):SetValue(Alltrim(TRB->B1_DESC))
		oSection1:Cell("B1_DESC"):SetAlign("LEFT")
		
		oSection1:Cell("B1_UM"):SetValue(Alltrim(TRB->B1_UM))
		oSection1:Cell("B1_UM"):SetAlign("CENTER")
		
		oSection1:Cell("C6_QTDVEN"):SetValue(TRB->C6_QTDVEN)
		oSection1:Cell("C6_QTDVEN"):SetAlign("CENTER")
		
		oSection1:Cell("C6_C_VLRDI"):SetValue(TRB->C6_C_VLRDI)
		oSection1:Cell("C6_C_VLRDI"):SetAlign("LEFT")
		
		oSection1:Cell("C6_C_FRETE"):SetValue(TRB->C6_C_FRETE)
		oSection1:Cell("C6_C_FRETE"):SetAlign("LEFT")
		
		oSection1:Cell("C6_PRCVEN"):SetValue(TRB->C6_PRCVEN)
		oSection1:Cell("C6_PRCVEN"):SetAlign("LEFT")
		
		oSection1:Cell("C6_VALOR"):SetValue(TRB->C6_VALOR)
		oSection1:Cell("C6_VALOR"):SetAlign("LEFT")
		
		oSection1:Cell("C5_C_VFRET"):SetValue(TRB->C5_C_VFRET)
		oSection1:Cell("C5_C_VFRET"):SetAlign("LEFT")
		
		oSection1:Cell("C6_CF"):SetValue(Alltrim(TRB->C6_CF))
		oSection1:Cell("C6_CF"):SetAlign("CENTER")
		
		oSection1:PrintLine()
		TRB->(DbSkip())
	EndDo
	
	oSection1:Finish()
	TRB->(DbCloseArea())
	
	oReport:FatLine()
Return()



/*
¦+-----------------------------------------------------------------------------+¦
¦¦Programa  ¦ ValidPerg        ¦ Autor ¦ Lucas Nogueira     ¦ Data ¦ 27/06/2016¦¦
¦+----------+------------------------------------------------------------------¦¦
¦¦Descrição ¦Parametros da Rotina                              		       	   ¦¦
¦¦          ¦                                                                  ¦¦
¦+----------+------------------------------------------------------------------¦¦
¦¦			ATUALIZAÇÕES SOFRIDAS DESDE A CONSTRUÇÃO INICIAL     			   ¦¦
¦+-----------------------------------------------------------------------------¦¦
¦¦ Analista 	 ¦ Data    ¦  Motivo da Alteração				       		   ¦¦
¦+---------------+---------+---------------------------------------------------¦¦
¦¦	   			 ¦	       ¦							       				   ¦¦
¦+---------------+---------+---------------------------------------------------¦¦
¦¦	 		     ¦	       ¦											       ¦¦
¦+---------------+---------+---------------------------------------------------+¦
*/
Static Function ValidPerg(_cPerg)
Local aHelpPor := {}

	aAdd(aHelpPor, "Selecione uma data que representa o")
	aAdd(aHelpPor, "período de emissao do Relatorio.")

	PutSx1(_cPerg,"01","Emissao De?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor,)
	PutSx1(_cPerg,"02","Emissao Ate?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor,)
	
Return()