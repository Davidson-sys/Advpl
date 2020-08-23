#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TOPCONN.CH"   
#INCLUDE "Ap5Mail.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"


/****************************************************************************************************/


/*/{Protheus.doc} CRA00001
Retorna Dados do Clientes - CRA
@type function
/*/

User Function CRA00001()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVar01	:= ""
	Local cVar02	:= ""

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVar01	:= PadR(HttpGet->CDCLI,TamSX3("A1_COD")[1]," ")
	cVar02	:= PadR(HttpGet->CDLOJ,TamSX3("A1_LOJA")[1]," ")
	
	cSql := " SELECT "
	cSql += " SA1.A1_NOME, SA1.A1_END, SA1.A1_BAIRRO, SA1.A1_MUN, SA1.A1_CEP, SA1.A1_EST, SA1.A1_ENDCOB, SA1.A1_BAIRROC, SA1.A1_MUNC, SA1.A1_CEPC, "
	cSql += " SA1.A1_ESTC, SA1.A1_CGC, SA1.A1_INSCR, SA1.A1_TIPO, SA1.A1_CONTATO, SA1.A1_TEL, SA1.A1_FAX, SA1.A1_DDD, SA1.A1_MSBLQL "
	cSql += " FROM " + RetSqlName("SA1") + " SA1 "
	cSql += " WHERE SA1.D_E_L_E_T_ = ' ' AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
	cSql += " AND SA1.A1_COD = '" + cVar01 + "'"
	cSql += " AND SA1.A1_LOJA = '" + cVar02 + "'"
	cSql += " ORDER BY SA1.A1_NOME "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())
	
		cRet += '{"cliente" :"'				+ IIF(EMPTY(TMP->A1_NOME),		'', ALLTRIM(TMP->A1_NOME))
		cRet += '","entregaEndereco" :"'	+ IIF(EMPTY(TMP->A1_END),		'', ALLTRIM(TMP->A1_END) + ' - ' + ALLTRIM(TMP->A1_BAIRRO))
		cRet += '","entregaBairro" :"'		+ IIF(EMPTY(TMP->A1_BAIRRO),	'', ALLTRIM(TMP->A1_BAIRRO))
		cRet += '","entregaMunicipio" :"'	+ IIF(EMPTY(TMP->A1_MUN),		'', ALLTRIM(TMP->A1_MUN) + '/' + ALLTRIM(TMP->A1_EST))
		cRet += '","entregaCep" :"'			+ IIF(EMPTY(TMP->A1_CEP),		'', ALLTRIM(TMP->A1_CEP))
		cRet += '","entregaEstado" :"'		+ IIF(EMPTY(TMP->A1_EST),		'', ALLTRIM(TMP->A1_EST))
		cRet += '","cobrancaEndereco" :"'	+ IIF(EMPTY(TMP->A1_ENDCOB),	'', ALLTRIM(TMP->A1_ENDCOB) + ' - ' + ALLTRIM(TMP->A1_BAIRROC))
		cRet += '","cobrancaBairro" :"'		+ IIF(EMPTY(TMP->A1_BAIRROC),	'', ALLTRIM(TMP->A1_BAIRROC))
		cRet += '","cobrancaMunicipio" :"'	+ IIF(EMPTY(TMP->A1_MUNC),		'', ALLTRIM(TMP->A1_MUNC) + '/' + ALLTRIM(TMP->A1_ESTC))
		cRet += '","cobrancaCep" :"'		+ IIF(EMPTY(TMP->A1_CEPC),		'', ALLTRIM(TMP->A1_CEPC))
		cRet += '","cobrancaEstado" :"'		+ IIF(EMPTY(TMP->A1_ESTC),		'', ALLTRIM(TMP->A1_ESTC))
		cRet += '","cpfcnpj" :"'			+ IIF(EMPTY(TMP->A1_CGC),		'', ALLTRIM(TMP->A1_CGC))
		cRet += '","inscricao" :"'			+ IIF(EMPTY(TMP->A1_INSCR),		'', ALLTRIM(TMP->A1_INSCR))
		cRet += '","tipo" :"'				+ IIF(EMPTY(TMP->A1_TIPO),		'', ALLTRIM(TMP->A1_TIPO))
		cRet += '","contato" :"'			+ IIF(EMPTY(TMP->A1_CONTATO),	'', ALLTRIM(TMP->A1_CONTATO))
		cRet += '","telefone" :"'			+ IIF(EMPTY(TMP->A1_TEL),		'', '(' + ALLTRIM(TMP->A1_DDD) + ') ' + ALLTRIM(TMP->A1_TEL))
		cRet += '","Fax" :"'				+ IIF(EMPTY(TMP->A1_FAX),		'', '(' + ALLTRIM(TMP->A1_DDD) + ') ' + ALLTRIM(TMP->A1_FAX))
		cRet += '","ddd" :"'				+ IIF(EMPTY(TMP->A1_DDD),		'', ALLTRIM(TMP->A1_DDD))
		cRet += '","msblq" :"'				+ IIF(EMPTY(TMP->A1_MSBLQL),	'', ALLTRIM(TMP->A1_MSBLQL))
		cRet +=  '"},'

		TMP->(DbSkip())
	ENDDO

	cRet += CHR(13) + cHR(10)+ ']'

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00002
Retorna Financeiro do Cliente - CRA
@type function
@author Rafael Silva Santiago
@since 10/09/2015
@return caracteres, JSON string
/*/

User Function CRA00002()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cImage	:= ""
	Local cVar01	:= ""
	Local cVar02	:= ""
	Local cVar03	:= ""
	Local nSaldo	:= 0
	Local nDiaAtr	:= 0

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	nDiaAtr := GetMv("NT_DIASATR",,10)
	cVar01	:= PadR(HttpGet->FNCLI,TamSX3("A1_COD")[1]," ")
	cVar02	:= PadR(HttpGet->FNLOJ,TamSX3("A1_LOJA")[1]," ")
	cVar03	:= HttpGet->LTALL

	cSql := " SELECT SE1.E1_FILIAL, "
	cSql += " SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_EMISSAO, SE1.E1_VENCREA, SE1.E1_VALOR, SE1.E1_SALDO, "
	cSql += " SE1.E1_SDACRES, SE1.E1_SDDECRE, SE1.E1_STATUS, SE1.E1_MSFIL, SE1.E1_FATURA, SE1.E1_BAIXA, SE1.E1_NUMLIQ, SE1.E1_PORTADO, SE1.E1_PEDIDO"
	cSql += " FROM " + RetSqlName("SE1")+ " SE1," + RetSqlName("SA1") + " SA1"
	// cSql += ", " + RetSqlName("SC5") + " SC5" //removido dia 22092015 - daniel
	cSql += " WHERE SE1.D_E_L_E_T_ = ' ' " // AND SE1.E1_FILIAL = '" + xFilial("SE1") + "'"
	cSql += " AND SA1.D_E_L_E_T_ = ' ' "
	cSql += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
	//cSql += " AND SC5.D_E_L_E_T_ = ' ' " // AND SC5.C5_FILIAL = '" + xFilial("SC5") + "'" //removido dia 22092015 - daniel
	cSql += " AND SE1.E1_CLIENTE = '" + cVar01 + "'"
	cSql += " AND SE1.E1_LOJA  = '" + cVar02 + "'"
	cSql += " AND SE1.E1_TIPO NOT IN ('NCC','RA ') "
	//cSql += " AND SC5.C5_FILIAL = SE1.E1_FILIAL " //removido dia 22092015 - daniel
	//cSql += " AND SC5.C5_NUM = SE1.E1_PEDIDO " //removido dia 22092015 - daniel
	cSql += " AND SE1.E1_CLIENTE = SA1.A1_COD "
	cSql += " AND SE1.E1_LOJA = SA1.A1_LOJA "
	If cVar03 == "0"
		cSql += " AND SE1.E1_VENCREA <= '" + DTOS(Date() - nDiaAtr) + "' "
		cSql += " AND SE1.E1_SALDO > 0 "
		//cSql += " AND SE1.E1_TIPO NOT IN ('RA ','NCC') "
	Endif
	cSql += " ORDER BY SE1.E1_VENCREA "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())

		nSaldo := TMP->E1_SALDO + TMP->E1_SDACRES + TMP->E1_SDDECRE
		cImage := ''

		// IMAGEM DE STATUS DA GRID
		If TMP->E1_VENCREA <= DTOS(Date()) .AND. nSaldo > 0
			cImage := '<img alt=\"AMARELO\" src=\"/images/agronelli/icon-tabela-amarelo.png\">'
		ElseIf nSaldo <= 0
			cImage := '<img alt=\"VERMELHO\" src=\"/images/agronelli/icon-tabela-vermelho.png\">'
		Else
			cImage := '<img alt=\"VERDE\" src=\"/images/agronelli/icon-tabela-verde.png\">'
		Endif

		cRet += '[ "' + IIF(EMPTY(cImage),			'',		cImage)
		cRet += '","' + IIF(EMPTY(TMP->E1_FILIAL),	'',		TMP->E1_FILIAL)
		cRet += '","' + IIF(EMPTY(TMP->E1_PREFIXO),	'',		ALLTRIM(TMP->E1_PREFIXO))
		cRet += '","' + IIF(EMPTY(TMP->E1_NUM),		'',		ALLTRIM(TMP->E1_NUM))		
		cRet += '","' + IIF(EMPTY(TMP->E1_PARCELA),	'',		ALLTRIM(TMP->E1_PARCELA))
		cRet += '","' + IIF(EMPTY(TMP->E1_TIPO),	'',		ALLTRIM(TMP->E1_TIPO))		
		cRet += '","' + IIF(EMPTY(TMP->E1_PEDIDO),	'',		ALLTRIM(TMP->E1_PEDIDO))
		cRet += '","' + IIF(EMPTY(TMP->E1_EMISSAO),	'',		SUBSTR(TMP->E1_EMISSAO, 7, 2) + '/' + SUBSTR(TMP->E1_EMISSAO, 5, 2) + '/' + SUBSTR(TMP->E1_EMISSAO, 0, 4))
		cRet += '","' + IIF(EMPTY(TMP->E1_VENCREA),	'',		SUBSTR(TMP->E1_VENCREA, 7, 2) + '/' + SUBSTR(TMP->E1_VENCREA, 5, 2) + '/' + SUBSTR(TMP->E1_VENCREA, 0, 4))
		cRet += '","' + IIF(EMPTY(TMP->E1_VALOR),	'0.00',	TRANSFORM(TMP->E1_VALOR, "@E 999,999,999.99"))
		cRet += '","' + IIF(EMPTY(TMP->E1_SALDO),	'0.00',	TRANSFORM(TMP->E1_SALDO, "@E 999,999,999.99"))
		cRet += '"],'

		cRet += CHR(13) + cHR(10)

		TMP->(DbSkip())
	ENDDO
	cRet += "]"

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)

/*/{Protheus.doc} CRA00002
Retorna Financeiro do Cliente - CRA
@type function
@author Rafael Silva Santiago
@since 10/09/2015
@return caracteres, JSON string
/*/

User Function CRA0002A()

	Local cSql		:= ""
	Local cRet		:= ""
	Local nSaldo	:= 0
	Local nJuros	:= 0
	Local nMulta	:= 0
	Local nDiaAtr	:= 0
	Local nPerJur 	:= 0
	Local nQtdAtr	:= 0
	Local cTipJur	:= ""
	Local cVar00	:= ""
	Local cVar01	:= ""
	Local cVar02	:= ""
	Local cVar03	:= ""
	Local cVar04	:= ""
	Local cVar05	:= ""
	Local cVar06	:= ""

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	nDiaAtr := GetMv("NT_DIASATR",,10)
	cTipJur := GetMv("MV_JURTIPO",,"S")
	cVar00	:= PadR(HttpGet->FNFIL,TamSX3("E1_FILIAL")[1]," ")
	cVar01	:= PadR(HttpGet->FNCLI,TamSX3("A1_COD")[1]," ")
	cVar02	:= PadR(HttpGet->FNLOJ,TamSX3("A1_LOJA")[1]," ")
	cVar03	:= PadR(HttpGet->E1PRE,TamSX3("E1_PREFIXO")[1]," ")
	cVar04	:= PadR(HttpGet->E1NUM,TamSX3("E1_NUM")[1]," ")
	cVar05	:= PadR(HttpGet->E1PAR,TamSX3("E1_PARCELA")[1]," ")
	cVar06	:= PadR(HttpGet->E1TIP,TamSX3("E1_TIPO")[1]," ")

	cSql := " SELECT "
	cSql += " SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_EMISSAO, SE1.E1_VENCREA, SE1.E1_VALOR, SE1.E1_SALDO, SE1.E1_PORCJUR, SE1.E1_NUMBOR, "
	cSql += " SE1.E1_SDACRES, SE1.E1_SDDECRE, SE1.E1_STATUS, SE1.E1_MSFIL, SE1.E1_FATURA, SE1.E1_BAIXA, SE1.E1_NUMLIQ, SE1.E1_PORTADO, SE1.E1_PEDIDO, E1_C_LINDI"
	cSql += " FROM " + RetSqlName("SE1")+ " SE1," + RetSqlName("SA1") + " SA1" // + ", " + RetSqlName("SC5") + " SC5"
	cSql += " WHERE SE1.D_E_L_E_T_ = ' ' AND SE1.E1_FILIAL = '" + cVar00 + "'"
	cSql += " AND SA1.D_E_L_E_T_ = ' ' AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
	//cSql += " AND SC5.D_E_L_E_T_ = ' ' AND SC5.C5_FILIAL = SE1.E1_FILIAL "
	cSql += " AND SE1.E1_CLIENTE = '" + cVar01 + "'"
	cSql += " AND SE1.E1_LOJA  = '" + cVar02 + "'"	
	cSql += " AND SE1.E1_PREFIXO  = '" + cVar03 + "'"
	cSql += " AND SE1.E1_NUM  = '" + cVar04 + "'"
	cSql += " AND SE1.E1_PARCELA  = '" + cVar05 + "'"
	cSql += " AND SE1.E1_TIPO  = '" + cVar06 + "'"	
	//cSql += " AND SC5.C5_FILIAL = SE1.E1_MSFIL"
	//cSql += " AND SC5.C5_NUM = SE1.E1_PEDIDO"
	cSql += " AND SE1.E1_CLIENTE = SA1.A1_COD"
	cSql += " AND SE1.E1_LOJA = SA1.A1_LOJA"

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())

		nSaldo	:= TMP->E1_SALDO + TMP->E1_SDACRES + TMP->E1_SDDECRE
		nQtdAtr	:= Date() - STOD(TMP->E1_VENCREA)
//		nPerJur := TMP->E1_PORCJUR
//		
//		If cTipJur == "S"
//			nJuros	:= nSaldo * (1+(nQtdAtr *(nPerJur/100)))
//		ElseIf cTipJur == "C"
//			nJuros	:= nSaldo * ((1+(nPerJur/100)) ** nQtdAtr )
//		ElseIf cTipJur == "M"
//			If nQtdAtr <= 30
//				nJuros	:= nSaldo * (1+(nQtdAtr *(nPerJur/100)))
//			Else
//				nJuros	:= nSaldo * (1+(30*(nPerJur/100)))
//				nJuros	:= nJuros * ((1+(nPerJur/100))**nQtdAtr-30) 
//			Endif		
//		Endif		
//		
//		nVlrAtu	:= nSaldo + nJuros + nMulta

		cRet += '{ "pedido" : "' + IIF(EMPTY(TMP->E1_PEDIDO),	'',		TMP->E1_PEDIDO)
		cRet += '","prefixo" : "' + IIF(EMPTY(TMP->E1_PREFIXO),	'',		TMP->E1_PREFIXO)
		cRet += '","titulo" : "' + IIF(EMPTY(TMP->E1_NUM),		'',		ALLTRIM(TMP->E1_NUM))
		cRet += '","parcela" : "' + IIF(EMPTY(TMP->E1_PARCELA),	'',		ALLTRIM(TMP->E1_PARCELA))
		cRet += '","tipo" : "' + IIF(EMPTY(TMP->E1_TIPO),		'',		ALLTRIM(TMP->E1_TIPO))
		cRet += '","valor" : "' + IIF(EMPTY(TMP->E1_VALOR),	'0.00',		TRANSFORM(TMP->E1_VALOR, "@E 999,999,999.99"))
		cRet += '","saldo" : "' + IIF(EMPTY(nSaldo),		'0.00',		TRANSFORM(nSaldo, "@E 999,999,999.99"))
		cRet += '","emissao" : "' + IIF(EMPTY(TMP->E1_EMISSAO),	'',		SUBSTR(TMP->E1_EMISSAO, 7, 2) + '/' + SUBSTR(TMP->E1_EMISSAO, 5, 2) + '/' + SUBSTR(TMP->E1_EMISSAO, 0, 4))
		cRet += '","vencimento" : "' + IIF(EMPTY(TMP->E1_VENCREA),	'',	SUBSTR(TMP->E1_VENCREA, 7, 2) + '/' + SUBSTR(TMP->E1_VENCREA, 5, 2) + '/' + SUBSTR(TMP->E1_VENCREA, 0, 4))
		cRet += '","vencido" : "' + IIF(EMPTY(nQtdAtr),		'000',		TRANSFORM(nQtdAtr, "@E 99999999999"))		
		cRet += '","boleto" : "' + IIF(EMPTY(E1_NUMBOR) .OR. EMPTY(TMP->E1_C_LINDI) .OR. nSaldo == 0, 'N', 'S')
		cRet += '","baixa" : "' + IIF(EMPTY(TMP->E1_BAIXA),	'Em Aberto',SUBSTR(TMP->E1_BAIXA, 7, 2) + '/' + SUBSTR(TMP->E1_BAIXA, 5, 2) + '/' + SUBSTR(TMP->E1_BAIXA, 0, 4))
		cRet += '"},'

		cRet += CHR(13) + cHR(10)

		TMP->(DbSkip())
	ENDDO
	cRet += "]"

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)

/*/{Protheus.doc} CRA00002
Retorna Financeiro do Cliente - CRA
@type function
@author Rafael Silva Santiago
@since 10/09/2015
@return caracteres, JSON string
/*/

User Function CRA0002B()

	Local cSql		:= ""
	Local cRet		:= ""
	Local nSaldo	:= 0
	Local nJuros	:= 0
	Local nMulta	:= 0
	Local nDiaAtr	:= 0
	Local nPerJur 	:= 0
	Local nQtdAtr	:= 0
	Local cTipJur	:= ""
	Local cVar00	:= ""
	Local cVar01	:= ""
	Local cVar02	:= ""
	Local cVar03	:= ""
	Local cVar04	:= ""
	Local cVar05	:= ""
	Local cVar06	:= ""
	Local cEnd		:= ""

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	nDiaAtr := GetMv("NT_DIASATR",,10)
	cTipJur := GetMv("MV_JURTIPO",,"S")
	cVar00	:= PadR(HttpGet->FNFIL,TamSX3("E1_FILIAL")[1]," ")
	cVar01	:= PadR(HttpGet->FNCLI,TamSX3("A1_COD")[1]," ")
	cVar02	:= PadR(HttpGet->FNLOJ,TamSX3("A1_LOJA")[1]," ")
	cVar03	:= PadR(HttpGet->E1PRE,TamSX3("E1_PREFIXO")[1]," ")
	cVar04	:= PadR(HttpGet->E1NUM,TamSX3("E1_NUM")[1]," ")
	cVar05	:= PadR(HttpGet->E1PAR,TamSX3("E1_PARCELA")[1]," ")
	cVar06	:= PadR(HttpGet->E1TIP,TamSX3("E1_TIPO")[1]," ")
	
	cQuery := " SELECT SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_NUMBOR, SE1.E1_TIPO, SE1.E1_EMISSAO, SE1.E1_VENCREA, SE1.E1_VALOR, SE1.E1_SALDO, SE1.E1_PORCJUR, "
	cQuery += " SE1.E1_SDACRES, SE1.E1_SDDECRE, SE1.E1_STATUS, SE1.E1_MSFIL, SE1.E1_FATURA, SE1.E1_BAIXA, SE1.E1_NUMLIQ, SE1.E1_PORTADO, SE1.E1_PEDIDO, E1_C_LINDI, SE1.E1_NUMBCO, SE1.E1_C_CODBA, SEA.* "
	cQuery += " FROM " + RetSQLName("SEA") + " SEA, " + RetSQLName("SE1") + " SE1 "
	cQuery += " WHERE SEA.D_E_L_E_T_ = ' 'AND SE1.D_E_L_E_T_ = ' ' "
	cQuery += " AND SE1.E1_FILIAL  = '" + cVar00 + "'"	
	cQuery += " AND SE1.E1_CLIENTE = '" + cVar01 + "'"
	cQuery += " AND SE1.E1_LOJA    = '" + cVar02 + "'"	
	cQuery += " AND SE1.E1_PREFIXO = '" + cVar03 + "'"
	cQuery += " AND SE1.E1_NUM     = '" + cVar04 + "'"
	cQuery += " AND SE1.E1_PARCELA = '" + cVar05 + "'"
	cQuery += " AND SE1.E1_TIPO    = '" + cVar06 + "'"
	cQuery += " AND SE1.E1_FILIAL  = EA_FILORIG "
	cQuery += " AND SE1.E1_PREFIXO = EA_PREFIXO "
	cQuery += " AND SE1.E1_NUM     = EA_NUM "
	cQuery += " AND SE1.E1_PARCELA = EA_PARCELA "
	cQuery += " AND SE1.E1_TIPO    = EA_TIPO "
	cQuery += " AND SE1.E1_SALDO   > 0"

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())

//		nSaldo	:= TMP->E1_SALDO + TMP->E1_SDACRES + TMP->E1_SDDECRE
//		nQtdAtr	:= Date() - STOD(TMP->E1_VENCREA)
//		nPerJur := TMP->E1_PORCJUR
//		
//		If cTipJur == "S"
//			nJuros	:= nSaldo * (1+(nQtdAtr *(nPerJur/100)))
//		ElseIf cTipJur == "C"
//			nJuros	:= nSaldo * ((1+(nPerJur/100)) ** nQtdAtr )
//		ElseIf cTipJur == "M"
//			If nQtdAtr <= 30
//				nJuros	:= nSaldo * (1+(nQtdAtr *(nPerJur/100)))
//			Else
//				nJuros	:= nSaldo * (1+(30*(nPerJur/100)))
//				nJuros	:= nJuros * ((1+(nPerJur/100))**nQtdAtr-30) 
//			Endif		
//		Endif		

		DbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial("SA1")+TMP->E1_CLIENTE+TMP->E1_LOJA ))
		
			DbSelectArea("SEE")
			SEE->(dbSetOrder(1))
			If SEE->(dbSeek(xFilial("SEE")+TMP->EA_PORTADO+TMP->EA_AGEDEP+TMP->EA_NUMCON ))

				cRet += '{ "valor_boleto" : "' 		+ IIF(EMPTY(TMP->E1_VALOR),		'0.00',	TRANSFORM(TMP->E1_VALOR, "@E 999,999,999.99"))		
				cRet += '","nosso_numero" : "' 		+ IIF(EMPTY(TMP->E1_NUMBCO),		'',		TMP->E1_NUMBCO)
				cRet += '","banco" : "' 			+ SEE->EE_CODIGO
				cRet += '","linhadig" : "'	 		+ TMP->E1_C_LINDI
				cRet += '","codbarras" : "' 		+ TMP->E1_C_CODBA
				cRet += '","numero_documento" : "' 	+ AllTrim(TMP->E1_PREFIXO)+"/"+ALLTRIM(TMP->E1_NUM)+" Parc.:"+ALLTRIM(TMP->E1_PARCELA)
				cRet += '","data_vencimento" : "' 	+ IIF(EMPTY(TMP->E1_VENCREA),		'',		SUBSTR(TMP->E1_VENCREA, 7, 2) + '/' + SUBSTR(TMP->E1_VENCREA, 5, 2) + '/' + SUBSTR(TMP->E1_VENCREA, 0, 4))
				cRet += '","data_documento" : "' 	+ IIF(EMPTY(TMP->E1_EMISSAO),		'',		SUBSTR(TMP->E1_EMISSAO, 7, 2) + '/' + SUBSTR(TMP->E1_EMISSAO, 5, 2) + '/' + SUBSTR(TMP->E1_EMISSAO, 0, 4))		
				cRet += '","data_processamento" : "'+ IIF(EMPTY(TMP->E1_EMISSAO),		'',		SUBSTR(TMP->E1_EMISSAO, 7, 2) + '/' + SUBSTR(TMP->E1_EMISSAO, 5, 2) + '/' + SUBSTR(TMP->E1_EMISSAO, 0, 4))
				cRet += '","sacado" : "' 			+ UpPer(AllTrim(SA1->A1_NOME)) + ' - ' + SA1->A1_COD
				cRet += '","cedente" : "' 			+ "NUTRATTA NUTRICAO ANIMAL LTDA"
				cRet += '","cnpj" : "' 				+ "17.316.559/0001-28"
				cRet += '","locpagto" : "' 			+ "ATE O VENCIMENTO PAGAVEL EM QUALQUER AGENCIA BANCARIA."
				cRet += '","endereco" : "' 			+ IIF(EMPTY(SA1->A1_ENDCOB),		'',		SA1->A1_ENDCOB)
				cRet += '","demonstrativo1" : "' 	+ ''
				cRet += '","demonstrativo2" : "' 	+ ''
				cRet += '","demonstrativo3" : "' 	+ ''		
				cRet += '","instrucoes1" : "' 		+ "APOS O VENCIMENTO INCLUIR MULTA DE 2%."
				cRet += '","instrucoes2" : "' 		+ "APOS O VENCIMENTO INCLUIR JUROS DE 3% AO MES."
				cRet += '","instrucoes3" : "' 		+ "PROTESTO 10 DIAS APOS O VENCIMENTO."
				cRet += '","instrucoes4" : "' 		+ "Texto de responsabilidade do cedente " + "          BORDERO: " + AllTrim(TMP->E1_NUMBOR)
				cRet += '","quantidade" : "' 		+ '10'
				cRet += '","valor_unitario" : "' 	+ ''
				cRet += '","aceite" : "' 			+ 'N'
				cRet += '","especie" : "' 			+ 'R$'
				cRet += '","especie_doc" : "' 		+ 'DM'		
				cRet += '","agencia" : "' 			+ SubStr(TMP->EA_AGEDEP,1,4)+ "-" +SubStr(TMP->EA_AGEDEP,5,1)+"/"+StrZero(Val(SubStr(AllTrim(TMP->EA_NUMCON),1,LEN(AllTrim(TMP->EA_NUMCON))-1)),7)+ "-" +SubStr(TMP->EA_NUMCON,LEN(AllTrim(TMP->EA_NUMCON)),1)
				cRet += '","carteira" : "' 			+ AllTrim(SEE->EE_C_CARBO)
				cRet += '","variacao_carteira" : "' + IIF(EMPTY(SEE->EE_TIPCART),		'',		SEE->EE_TIPCART)
				cRet += '"},'
				
			Endif
	
		Endif

		cRet += CHR(13) + cHR(10)

		TMP->(DbSkip())
	ENDDO
	cRet += "]"

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)

/*/{Protheus.doc} CRA00002
Retorna Financeiro do Cliente - CRA
@type function
@author Rafael Silva Santiago
@since 10/09/2015
@return caracteres, JSON string
/*/

User Function CRA0002C()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cImage	:= ""
	Local cVar01	:= ""
	Local cVar02	:= ""
	Local nSaldo	:= 0
	Local nDiaAtr	:= 0

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	nDiaAtr := GetMv("NT_DIASATR",,10)
	cVar01	:= PadR(HttpGet->FNCLI,TamSX3("A1_COD")[1]," ")
//	cVar02	:= PadR(HttpGet->FNLOJ,TamSX3("A1_LOJA")[1]," ")

	cSql := " SELECT COUNT(*) AS QUANT "
	cSql += " FROM " + RetSqlName("SE1")+ " SE1 "
	cSql += " WHERE SE1.D_E_L_E_T_ = ' ' "
	cSql += " AND SE1.E1_CLIENTE = '" + cVar01 + "'"
//	cSql += " AND SE1.E1_LOJA  = '" + cVar02 + "'"
	cSql += " AND SE1.E1_VENCREA <= '" + DTOS(Date() - nDiaAtr) + "' "
	cSql += " AND SE1.E1_SALDO > 0 "
	cSql += " AND SE1.E1_TIPO NOT IN ('NCC','RA ') "
	cSql += " AND SE1.E1_SALDO > 0 "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + CHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	If !TMP->(Eof())
		cRet += '{ "Titulos" : "' + cValToChar(TMP->QUANT) + '"}'
	Endif
	cRet += "]"

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)

/****************************************************************************************************/

/*/{Protheus.doc} CRA00003
Retorna Busca de Pedidos - CRA
@type function
@author Rafael Silva Santiago
@since 10/09/2015
@return caracteres, JSON string
/*/

User Function CRA00003()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cImage	:= ""
	Local cVar01	:= ""
	Local cVar02	:= ""
	Local cVar03	:= ""

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVar01	:= PadR(HttpGet->PVCLI,TamSX3("A1_COD")[1]," ")
	cVar02	:= PadR(HttpGet->PVLOJ,TamSX3("A1_LOJA")[1]," ")
	cVar03	:= HttpGet->PVREP
	cVend	:= fVend(cVar03)

	cSql :=" SELECT "
	cSql +=" C5.C5_NUM, C5.C5_FILIAL, C5.C5_EMISSAO, "
	cSql +=" C5.C5_EMISSAO, C6.C6_ENTREG, C6.C6_COMIS1, "
	cSql +=" SUBSTRING(C5.C5_NOMCLI,1,35) AS C5_NOMCLI, "
	cSql +=" SUBSTRING(C6.C6_DESCRI,1,15) AS C6_DESCRI,"
	cSql +=" ROUND(C6.C6_QTDVEN - C6.C6_QTDENT,2) AS SALDO,"
	cSql +=" ROUND(C6.C6_QTDVEN,2) AS C6_QTDVEN,"
	cSql +=" ROUND(C6.C6_QTDENT,2) AS C6_QTDENT,"
	cSql +=" C6.C6_ITEM, A1.A1_COD, A1.A1_LOJA, "
	cSql +=" C5.R_E_C_N_O_ AS NUMRECNO "
	cSql +=" FROM " + RetSqlName("SC6") + " C6," + RetSqlName("SC5") + " C5," + RetSqlName("SA1") + " A1," + RetSqlName("SB1") + " B1 "
	cSql +=" WHERE C6.D_E_L_E_T_ = ' ' " // AND C6.C6_FILIAL = '" + xFilial("SC6") + "'"
	cSql +=" AND C5.D_E_L_E_T_ = ' ' " // AND C5.C5_FILIAL = '" + xFilial("SC5") + "'"
	cSql +=" AND A1.D_E_L_E_T_ = ' ' AND A1.A1_FILIAL = '" + xFilial("SA1") + "'"
	cSql +=" AND B1.D_E_L_E_T_ = ' ' AND B1.B1_FILIAL = '" + xFilial("SB1") + "'"
	cSql +=" AND C5.C5_FILIAL = C6.C6_FILIAL "
	cSql +=" AND C5.C5_NUM = C6.C6_NUM"
	cSql +=" AND C6.C6_CLI = A1.A1_COD"
	cSql +=" AND C6.C6_LOJA = A1.A1_LOJA"
	cSql +=" AND C6.C6_PRODUTO = B1.B1_COD"
	cSql +=" AND A1.A1_COD = '"+cVar01+"'"
	cSql +=" AND A1.A1_LOJA = '"+cVar02+"'"
	cSql +=" AND C5.C5_VEND1 IN (" + cVend + ") "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())
	
		// IMAGEM DE STATUS DA GRID
		If TMP->SALDO > 0
			cImage := '<img alt=\"VERMELHO\" src=\"/images/agronelli/icon-tabela-verde.png\">'
		Else
			cImage := '<img alt=\"VERMELHO\" src=\"/images/agronelli/icon-tabela-vermelho.png\">'
		Endif

		cRet += '[ "' + IIF(EMPTY(cImage),			'',			cImage)
		cRet += '","' + IIF(EMPTY(TMP->C5_FILIAL),	'',			ALLTRIM(TMP->C5_FILIAL))
		cRet += '","' + IIF(EMPTY(TMP->C5_NUM),		'',			ALLTRIM(TMP->C5_NUM))
		cRet += '","' + IIF(EMPTY(TMP->C5_EMISSAO),	'',			SUBSTR(TMP->C5_EMISSAO, 7, 2) + '/' + SUBSTR(TMP->C5_EMISSAO, 5, 2) + '/' + SUBSTR(TMP->C5_EMISSAO, 0, 4))
		cRet += '","' + IIF(EMPTY(TMP->C6_ENTREG),	'',			SUBSTR(TMP->C6_ENTREG, 7, 2) + '/' + SUBSTR(TMP->C6_ENTREG, 5, 2) + '/' + SUBSTR(TMP->C6_ENTREG, 0, 4))
		cRet += '","' + IIF(EMPTY(TMP->C5_NOMCLI),	'',			ALLTRIM(TMP->C5_NOMCLI))
		cRet += '","' + IIF(EMPTY(TMP->C6_DESCRI),	'',			ALLTRIM(TMP->C6_DESCRI))
		cRet += '","' + IIF(EMPTY(TMP->C6_QTDVEN),	'0.000',	STR(TMP->C6_QTDVEN, 12, 3))
		cRet += '","' + IIF(EMPTY(TMP->SALDO),		'0.000',	STR(TMP->SALDO, 12, 3))
		//cRet += '","' + IIF(EMPTY(TMP->C6_COMIS1),	'0',		STR(TMP->C6_COMIS1, 10, 0) + '%')
		cRet += '"],'

		cRet += CHR(13) + cHR(10)

		TMP->(DbSkip())
	ENDDO

	cRet += "]"

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)

/****************************************************************************************************/

/*/{Protheus.doc} CRA00004
Retorna Notas Clientes - CRA
@type function
@author Rafael Silva Santiago
@since 10/09/2015
@return caracteres, JSON string
/*/

User Function CRA00004()

	Local aFil		:= {}
	Local nScan		:= 0
	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cVar01	:= ""
	Local cVar02	:= ""
	Local cVar03	:= ""
	Local cVar04	:= ""
	Local cVar05	:= ""

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	aAdd(aFil, {"0101","17316559000128"})
	aAdd(aFil, {"0102","17316559000390"})
	aAdd(aFil, {"0103","17316559000209"})
	aAdd(aFil, {"0104","17316559000470"})
	aAdd(aFil, {"0201","21604565000158"})
	aAdd(aFil, {"0105","17316559000551"})
	aAdd(aFil, {"0106","17316559000632"})
	aAdd(aFil, {"0107","17316559000713"})
	
	cVar01	:= PadR(HttpGet->NFCLI,TamSX3("A1_COD")[1]," ")
	cVar02	:= PadR(HttpGet->NFLOJ,TamSX3("A1_LOJA")[1]," ")
	cVar03	:= HttpGet->NFREP	
	cVar04	:= HttpGet->NFPED
	cVar05	:= HttpGet->NFFIL
	cVend	:= fVend(cVar03)

	cSql := " SELECT "
	cSql += " F2.F2_FILIAL, F2.F2_DOC, F2.F2_SERIE, F2.F2_EMISSAO, F2.F2_HORA, "
	cSql += " SUM(D2.D2_QUANT) AS D2_QUANT,"
	cSql += " SUM(D2.D2_TOTAL) AS D2_TOTAL "
	cSql += " FROM " + RetSqlName("SD2") + " D2, " + RetSqlName("SF2") + " F2 "
	cSql += " WHERE D2.D_E_L_E_T_ <> '*'"
	cSql += " AND F2.D_E_L_E_T_ <> '*'"
	cSql += " AND D2.D2_FILIAL = F2.F2_FILIAL"
	cSql += " AND D2.D2_DOC = F2.F2_DOC"
	cSql += " AND D2.D2_SERIE = F2.F2_SERIE"
	cSql += " AND F2.F2_CHVNFE <> ' ' "
	cSql += " AND F2.F2_VEND1 IN (" + cVend + ") "
	cSql += " AND D2.D2_CLIENTE = '"+cVar01+"'"
	cSql += " AND D2.D2_LOJA = '"+cVar02+"'"
	
	If cVar04 <> "Z"
		cSql += " AND D2.D2_PEDIDO = '"+cVar04+"'"
	Endif
	
	If cVar05 <> "Z"	
		cSql += " AND D2.D2_FILIAL = '"+cVar05+"'"
	Endif
	
	cSql += " GROUP BY F2.F2_FILIAL, F2.F2_DOC, F2.F2_SERIE, F2.F2_EMISSAO, F2.F2_HORA "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())
	
		nScan := aScan(aFil, {|x| x[1] == AllTrim(TMP->F2_FILIAL) } )
		cTime := DTOC(STOD(TMP->F2_EMISSAO)) + " AS " + TMP->F2_HORA

		//cRet += '[ "<i class=\"fa fa-download\"></i>'
		cRet += '[ "' + IIF(EMPTY(TMP->F2_DOC),			'',		 ALLTRIM(TMP->F2_DOC))
		cRet += '","' + IIF(EMPTY(TMP->F2_SERIE),		'',		 ALLTRIM(TMP->F2_SERIE))
		cRet += '","' + IIF(EMPTY(cTime),				'',		 ALLTRIM(cTime))
		cRet += '","' + IIF(EMPTY(TMP->D2_QUANT),	'0.000', STR(TMP->D2_QUANT, 12, 3))
		cRet += '","' + IIF(EMPTY(TMP->D2_TOTAL),	'0.00',	 TRANSFORM(TMP->D2_TOTAL, "@E 999,999,999.99"))
		
		If nScan > 0 
			cRet += '","' + IIF(EMPTY(aFil[nScan,2]),	'',	aFil[nScan,2])
		Else
			cRet += '","'
		Endif
		
		cRet +=  '"], '
		cRet += CHR(13) + cHR(10)

		TMP->(DbSkip())
	ENDDO
	
	cRet += "]"
	
	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)

/****************************************************************************************************/


/*/{Protheus.doc} CRA00005
Retorna preco de acordo com a tabela de preco do vendero
@type function
@author Cassiano Melo
@since 14/09/2015
@return caracteres, json faturas
/*/

User Function CRA00005()

	Local cRet		:= ""
	Local cVar01	:= ""
	Local cVar02	:= ""
	Local nPreco	:= 0
	Local nLimDes	:= 0
	Local nLimAcr	:= 0
	Local cTabela	:= ""

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVar01	:= PadR(HttpGet->VEND,TamSX3("A3_COD")[1]," ")
	cVar02	:= PadR(HttpGet->PROD,TamSX3("B1_COD")[1]," ")
	cVar03	:= Val(HttpGet->QUANT)
	cVar04	:= PadR(HttpGet->CDCLI,TamSX3("A1_COD")[1]," ")
	cVar05	:= PadR(HttpGet->CDLOJ,TamSX3("A1_LOJA")[1]," ")
	nLimDes	:= GetMv("NT_LIMDESC",,0)
	
	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))
	If SA3->(DbSeek("01  "+cVar01))
		If !Empty(SA3->A3_TABELA)
			nPreco := MaTabPrVen(SA3->A3_TABELA, cVar02, cVar03, cVar04, cVar05, 1, STOD("20501231"), 1, .T.)
			cTabela := SA3->A3_TABELA
			
			If !Empty(SA3->A3_PERMAX)
				nLimAcr	:= nPreco * ( ( SA3->A3_PERMAX / 100 ) + 1 ) 
			Else
				nLimAcr	:= nPreco * ( ( Val(GetMv("NT_LIMACRE",,5)) / 100 ) + 1 )
			EndIf
			
			nLimAcr := Round(nLimAcr,2)
			
		Endif
	Endif

	cRet := "[" + CHR(13) + cHR(10)	
	cRet += '{"Preco" :"'		+ cValToChar(nPreco)
	cRet += '","LimDescont" :"'	+ cValToChar(nLimDes)
	cRet += '","PrecoMax" :"'	+ cValToChar(nLimAcr)
	cRet += '","TabelaPrc" :"'	+ cTabela
	cRet +=  '"}' + CHR(13) + cHR(10)		
	cRet += "]"
	
	If Select("SA3") > 0
		DbSelectArea("SA3")
		SA3->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00006
Retorna preco de acordo com a tabela de preco do vendedor
@type function
@author Cassiano Melo
@since 14/09/2015
@return caracteres, json faturas
/*/

User Function CRA00006()

	Local cRet		:= ""
	Local cFiltro	:= ""
	Local cVar01	:= ""

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVar01	:= PadR(HttpGet->VEND,TamSX3("A3_COD")[1]," ")
	
	cRet	:= fVend( cVar01 )
	cRet    := StrTran( cRet , "','" , "," )
	
	cFiltro	:= "SCJ->CJ_STATUS == 'F' .AND. SCJ->CJ_VEND1 $ "+ cRet

Return( cFiltro )



/****************************************************************************************************/


/*/{Protheus.doc} CRA00007
Retorna e-mails do CRM
@type function
@author Cassiano Melo
@since 14/09/2015
@return caracteres, json faturas
/*/

User Function CRA00007()

	Local cRet		:= ""

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf

	cRet	:= GetMv("NT_MAILCRM",,0)

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00008
Retorna as faturas - CRA
@type function
@author Cassiano Melo
@since 14/09/2015
@return caracteres, json faturas
/*/

User Function CRA00008()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cRepre	:= HttpGet->PAR01
	Local nSaldo	:= 01
	Local cImage	:= ''
	Local cFilia	:= ''

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVend := fVend(cRepre)

	cSql := " SELECT SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_EMISSAO, SE1.E1_VENCREA, SE1.E1_VALOR AS E1_VALOR, SE1.E1_SALDO, SE1.E1_SDACRES, SE1.E1_SDDECRE, SE1.E1_MSFIL"
	cSql +=" FROM  " + RetSqlName("SE1") + "  SE1,  " + RetSqlName("SC5") + "  SC5"
	cSql +=" WHERE SE1.E1_FATURA in ('','NOTFAT')"
	cSql +=" AND SE1.D_E_L_E_T_ <> '*'"
	cSql +=" AND SE1.E1_PREFIXO = 'FAT'"
	cSql +=" AND SC5.D_E_L_E_T_ <> '*'"
	cSql +=" AND SC5.C5_VEND1 IN (" + cVend + ") "
	cSql +=" AND SC5.C5_FILIAL = SE1.E1_MSFIL"
	cSql +=" AND SC5.C5_NUM = SE1.E1_PEDIDO"
	cSql +=" AND LEN(SE1.E1_NUM) > 6"
	cSql +=" ORDER BY E1_STATUS ASC, E1_VENCREA ASC, E1_NUM ASC"

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())
		nSaldo := TMP->E1_SALDO + TMP->E1_SDACRES + TMP->E1_SDDECRE
		cImage := ''
		cFilia := ''

		// IMAGEM DE STATUS DA GRID
		IF nSaldo <= 0
			cImage := '<img alt=\"VERMELHO\" src=\"/images/agronelli/icon-tabela-vermelho.png\">'
		ELSE
			cImage := '<img alt=\"VERDE\" src=\"/images/agronelli/icon-tabela-verde.png\">'
		ENDIF

		cRet += '[ "' + IIF(EMPTY(cImage),			'',		cImage)
		cRet += '","' + IIF(EMPTY(TMP->E1_MSFIL),	'',		TMP->E1_MSFIL)
		cRet += '","' + IIF(EMPTY(TMP->E1_PREFIXO),	'',		ALLTRIM(TMP->E1_PREFIXO))
		cRet += '","' + IIF(EMPTY(TMP->E1_NUM),		'',		ALLTRIM(TMP->E1_NUM))
		cRet += '","' + IIF(EMPTY(TMP->E1_EMISSAO),	'',		SUBSTR(TMP->E1_EMISSAO,3,2) + '/' + SUBSTR(TMP->E1_EMISSAO,5,2) + '/' + SUBSTR(TMP->E1_EMISSAO,0,4))
		cRet += '","' + IIF(EMPTY(TMP->E1_VENCREA),	'',		SUBSTR(TMP->E1_VENCREA,3,2) + '/' + SUBSTR(TMP->E1_VENCREA,5,2) + '/' + SUBSTR(TMP->E1_VENCREA,0,4))
		cRet += '","' + IIF(EMPTY(TMP->E1_VALOR),	'0.00',	TRANSFORM(TMP->E1_VALOR, "@E 999,999,999.99"))
		cRet += '","' + IIF(EMPTY(nSaldo),	'0.00',	TRANSFORM(nSaldo, "@E 999,999,999.99"))
		cRet += '"],'

		TMP->(DbSkip())
	ENDDO

	cRet += CHR(13) + cHR(10)+ ']'

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00009
Retorna as notas da faturas - CRA
@type function
@author Cassiano Melo
@since 14/09/2015
@return caracteres, json notas
/*/

User Function CRA00009()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cRepre	:= HttpGet->PAR01
	Local cFatur	:= HttpGet->PAR02
	Local cFilia	:= ''

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVend := fVend(cRepre)

	cSql := " SELECT"
	cSql +=" SE1.E1_NUM,"
	cSql +=" SE1.E1_PEDIDO,"
	cSql +=" E1_EMISSAO = CONVERT(VARCHAR(10),CONVERT(DATETIME,E1_EMISSAO), 103),"
	cSql +=" SD2.D2_QUANT,"
	cSql +=" SD2.D2_PRCVEN,"
	cSql +=" SD2.D2_TOTAL,"
	cSql +=" SD2.D2_FILIAL,"
	cSql +=" SD2.D2_DOC,"
	cSql +=" SD2.D2_SERIE,"
	cSql +=" SD2.D2_EMISSAO ,"
	cSql +=" SB1.B1_DESC,"
	cSql +=" NUMREG = @@ROWCOUNT"
	cSql +=" FROM  " + RetSqlName("SE1")+"  SE1,  " + RetSqlName("SD2") + "  SD2,  " + RetSqlName("SB1") + "  SB1"
	cSql +=" WHERE SE1.E1_VEND1 IN (" + cVend + ") "
	cSql +=" AND SE1.E1_FATURA = '"+cFatur+"'"
	cSql +=" AND SE1.E1_FATPREF = 'FAT'"
	cSql +=" AND SD2.D2_DOC = SE1.E1_NUM"
	cSql +=" AND SD2.D2_CLIENTE = SE1.E1_CLIENTE"
	cSql +=" AND SD2.D2_LOJA = SE1.E1_LOJA"
	cSql +=" AND SB1.B1_COD = D2_COD"
	cSql +=" AND SE1.D_E_L_E_T_ <> '*'"
	cSql +=" AND SD2.D_E_L_E_T_ <> '*'"
	cSql +=" AND SB1.D_E_L_E_T_ <> '*'"
	cSql +=" AND SE1.E1_TIPO NOT IN ('RA ','NCC')"

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())

		cRet += '[ "<i class=\"fa fa-download\"></i>'
		cRet += '","' + IIF(EMPTY(TMP->D2_DOC),		'',		 ALLTRIM(TMP->D2_DOC))
		cRet += '","' + IIF(EMPTY(TMP->D2_EMISSAO),	'',		 SUBSTR(TMP->D2_EMISSAO, 7, 2) + '/' + SUBSTR(TMP->D2_EMISSAO, 5, 2) + '/' + SUBSTR(TMP->D2_EMISSAO, 0, 4))
		cRet += '","' + IIF(EMPTY(TMP->D2_QUANT),	'0.000', STR(TMP->D2_QUANT, 12, 3))
		cRet += '","' + IIF(EMPTY(TMP->D2_TOTAL),	'0.00',	 TRANSFORM(TMP->D2_TOTAL, "@E 999,999,999.99"))
		cRet += '","' + IIF(EMPTY(TMP->E1_PEDIDO),	'',		 ALLTRIM(TMP->E1_PEDIDO))
		cRet += '"],'

		TMP->(DbSkip())
	ENDDO

	cRet += CHR(13) + cHR(10)+ ']'

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00010
Retorna as notas fiscais - CRA
@type function
@author Cassiano Melo
@since 14/09/2015
@return caracteres, json notas
/*/

User Function CRA00010()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cRepre	:= HttpGet->PAR01

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVend := fVend(cRepre)

	cSql := " SELECT"
	cSql += " 	D2.D2_FILIAL,"
	cSql += " 	D2.D2_DOC,"
	cSql += " 	D2.D2_SERIE,"
	cSql += " 	CONVERT(VARCHAR(10),CONVERT(DATETIME,D2.D2_EMISSAO),103)+' as '+F2.F2_HORA as D2_EMISSAO,"
	cSql += " 	D2.D2_QUANT AS D2_QUANT,"
	cSql += " 	D2.D2_TOTAL AS D2_TOTAL"
	cSql += " FROM  " + RetSqlName("SD2") + "  D2,  " + RetSqlName("SF2") + "  F2"
	cSql += " 	WHERE D2.D_E_L_E_T_ <> '*'"
	cSql += " 	AND F2.D_E_L_E_T_ <> '*'"
	cSql += " 	AND D2.D2_FILIAL = F2.F2_FILIAL"
	cSql += " 	AND D2.D2_DOC = F2.F2_DOC"
	cSql += " 	AND D2.D2_SERIE = F2.F2_SERIE"
	cSql += " 	AND F2.F2_VEND1 IN (" + cVend + ") "
	cSql += " 	AND LEN(F2.F2_DOC) > 6"
	cSql += " 	AND D2.D2_EMISSAO >= '" + DTOS(DATE() - 90) + "'"

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())

		cRet += '[ "<i class=\"fa fa-download\"></i>'
		cRet += '","' + IIF(EMPTY(TMP->D2_FILIAL),	'',		 ALLTRIM(TMP->D2_FILIAL))
		cRet += '","' + IIF(EMPTY(TMP->D2_DOC),		'',		 ALLTRIM(TMP->D2_DOC))
		cRet += '","' + IIF(EMPTY(TMP->D2_EMISSAO),	'',		 ALLTRIM(TMP->D2_EMISSAO))
		cRet += '","' + IIF(EMPTY(TMP->D2_QUANT),	'0.000', STR(TMP->D2_QUANT, 12, 3))
		cRet += '","' + IIF(EMPTY(TMP->D2_TOTAL),	'0.00',	 TRANSFORM(TMP->D2_TOTAL, "@E 999,999,999.99"))
		cRet += '","' + ''
		cRet += '"],'

		TMP->(DbSkip())
	ENDDO

	cRet += CHR(13) + cHR(10)+ ']'

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00011
Retorna os pedidos - CRA
@type function
@author Cassiano Melo
@since 11/09/2015
@return caracteres, json pedidos
/*/

User Function CRA00011()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cImage	:= ""
	Local cVar01	:= HttpGet->PAR01

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVend := fVend(cVar01)

	cSql :=" SELECT C5.C5_NUM, C5.C5_FILIAL,"
	//cSql +=" CONVERT(VARCHAR(10),CONVERT(DATETIME,C5.C5_EMISSAO), 103) AS C5_EMISSAO,"
	cSql +=" C5.C5_EMISSAO AS C5_EMISSAO,"
	cSql +=" C6.C6_ENTREG AS C6_ENTREG, C6.C6_COMIS1 AS C6_COMIS1,"
	cSql +=" SUBSTRING(C5.C5_NOMCLI,1,35) AS C5_NOMCLI, SUBSTRING(C6.C6_DESCRI,1,15) AS C6_DESCRI,"
	cSql +=" ROUND(C6.C6_QTDVEN - C6.C6_QTDENT,2) AS SALDO,"
	cSql +=" ROUND(C6.C6_QTDVEN,2) AS C6_QTDVEN,"
	cSql +=" ROUND(C6.C6_QTDENT,2) AS C6_QTDENT,"
	cSql +=" C6.C6_ITEM, C6.C6_BLQ,"
	cSql +=" A1.A1_COD, A1.A1_LOJA,"
	cSql +=" A3.A3_COD, A3.A3_NOME,"
	cSql +=" C5.R_E_C_N_O_ AS C5RECNO, C6.C6_CLI, C6.C6_LOJA"
	cSql +=" FROM " + RetSqlName("SC6") + " C6, " + RetSqlName("SC5") + " C5, " + RetSqlName("SA1") + " A1, "+RetSqlName("SB1") + " B1, "+RetSqlName("SA3") + " A3 "
	cSql +=" WHERE C5.C5_FILIAL = C6.C6_FILIAL"
	cSql +=" AND C5.C5_NUM = C6.C6_NUM"
	cSql +=" AND C6.C6_CLI = A1.A1_COD"
	cSql +=" AND C6.C6_LOJA = A1.A1_LOJA"
	cSql +=" AND C6.C6_PRODUTO = B1.B1_COD"
	cSql +=" AND C5.C5_VEND1 = A3.A3_COD"
	cSql +=" AND C6.D_E_L_E_T_ <> '*'"
	cSql +=" AND C5.D_E_L_E_T_ <> '*'"
	cSql +=" AND A1.D_E_L_E_T_ <> '*'"
	cSql +=" AND B1.D_E_L_E_T_ <> '*'"
	cSql +=" AND A3.D_E_L_E_T_ <> '*'"
	cSql +=" AND C5.C5_VEND1 IN (" + cVend + ") "
	cSql +=" ORDER BY C5.C5_EMISSAO DESC, A1.A1_NOME, C5.C5_NUM"

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())
	
		IF TMP->SALDO <= 0 .OR. STOD(TMP->C6_ENTREG) < date() .OR. RTRIM(TMP->C6_BLQ) == "R"
			cImage := '<img alt=\"VERMELHO\" src=\"/images/icones/icon-tabela-vermelho.png\">'
		ELSE
			cImage := '<img alt=\"VERDE\" src=\"/images/icones/icon-tabela-verde.png\">'
		ENDIF

		cRet += '[ "' + IIF(EMPTY(cImage),		'',			cImage)
		cRet += '","' + IIF(EMPTY(TMP->C5_FILIAL),	'',			ALLTRIM(TMP->C5_FILIAL))
		cRet += '","' + IIF(EMPTY(TMP->C5_NUM),		'',			ALLTRIM(TMP->C5_NUM))
		cRet += '","' + IIF(EMPTY(TMP->C5_EMISSAO),	'',			ALLTRIM(DTOC(STOD(TMP->C5_EMISSAO))))
		cRet += '","' + IIF(EMPTY(TMP->C6_ENTREG),	'',			ALLTRIM(DTOC(STOD(TMP->C6_ENTREG))))
		cRet += '","' + IIF(EMPTY(TMP->A3_NOME),	'',			ALLTRIM(TMP->A3_NOME))
		cRet += '","' + IIF(EMPTY(TMP->C6_LOJA),	'',			ALLTRIM(TMP->C6_LOJA))
		cRet += '","' + IIF(EMPTY(TMP->C6_CLI),		'',			ALLTRIM(TMP->C6_CLI))
		cRet += '","' + IIF(EMPTY(TMP->C5_NOMCLI),	'',			ALLTRIM(TMP->C5_NOMCLI))
		cRet += '","' + IIF(EMPTY(TMP->C6_DESCRI),	'',			ALLTRIM(TMP->C6_DESCRI))
		cRet += '","' + IIF(EMPTY(TMP->C6_QTDVEN),	'0.000',	STR(TMP->C6_QTDVEN, 12, 3))
		cRet += '","' + IIF(EMPTY(TMP->SALDO),		'0.000',	STR(TMP->SALDO, 12, 3))
		cRet += '"],'

		TMP->(DbSkip())
	ENDDO

	cRet += CHR(13) + cHR(10)+ ']'

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA0011A
Retorna os dados do pedidos - CRA
@type function
@author Cassiano Melo
@since 11/09/2015
@return caracteres, json pedidos
/*/

User Function CRA0011A()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cImage	:= ""
	Local cVar01	:= HttpGet->PAR01

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVend := fVend(cVar01)

	cSql :=" SELECT C5.C5_NUM, C5.C5_FILIAL, C5.C5_EMISSAO, C5.C5_NOMCLI, C5.C5_CONDPAG, C5.C5_NOTA, C5.C5_LIBEROK, C5.C5_BLQ, "
	cSql +=" A1.A1_COD, A1.A1_LOJA,"
	cSql +=" A3.A3_COD, A3.A3_NOME,"
	cSql +=" C5.R_E_C_N_O_ AS C5RECNO, "
	cSql +=" (SELECT E4.E4_DESCRI FROM " + RetSqlName("SE4") + " E4 WHERE E4.D_E_L_E_T_ <> '*' AND C5.C5_CONDPAG = E4.E4_CODIGO) AS DESCPAG, "	
	cSql +=" (SELECT SUM(C6.C6_QTDVEN - C6.C6_QTDENT) FROM " + RetSqlName("SC6") + " C6 WHERE C6.D_E_L_E_T_ <> '*' AND C5.C5_FILIAL = C6.C6_FILIAL AND C5.C5_NUM = C6.C6_NUM) AS SALDO, "
	cSql +=" (SELECT SUM(C6.C6_QTDVEN) FROM " + RetSqlName("SC6") + " C6 WHERE C6.D_E_L_E_T_ <> '*' AND C5.C5_FILIAL = C6.C6_FILIAL AND C5.C5_NUM = C6.C6_NUM) AS QUANT, "
	cSql +=" (SELECT SUM(C6.C6_VALOR) FROM " + RetSqlName("SC6") + " C6 WHERE C6.D_E_L_E_T_ <> '*' AND C5.C5_FILIAL = C6.C6_FILIAL AND C5.C5_NUM = C6.C6_NUM) AS VALOR "	
	cSql +=" FROM " + RetSqlName("SC5") + " C5, " + RetSqlName("SA1") + " A1, " + RetSqlName("SA3") + " A3 "
	cSql +=" WHERE C5.C5_CLIENTE = A1.A1_COD"
	cSql +=" AND C5.C5_LOJACLI = A1.A1_LOJA"
	cSql +=" AND C5.C5_VEND1 = A3.A3_COD"
	cSql +=" AND C5.D_E_L_E_T_ <> '*'"
	cSql +=" AND A1.D_E_L_E_T_ <> '*'"
	cSql +=" AND A3.D_E_L_E_T_ <> '*'"
	cSql +=" AND C5.C5_VEND1 IN (" + cVend + ") "
	cSql +=" ORDER BY C5.C5_EMISSAO DESC, C5.C5_NOMCLI, C5.C5_NUM "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())
	
//		IF TMP->SALDO <= 0 
//			cImage := '<img alt=\"VERMELHO\" src=\"/images/icones/icon-tabela-vermelho.png\">'
//		ELSE
//			cImage := '<img alt=\"VERDE\" src=\"/images/icones/icon-tabela-verde.png\">'
//		ENDIF
		
		If Empty(TMP->C5_LIBEROK) .And. Empty(TMP->C5_NOTA) .And. Empty(TMP->C5_BLQ)		// "Pedido em Aberto"
			cImage := '<img alt=\"VERDE\" src=\"/images/icones/icon-tabela-verde.png\">'		
		Elseif !Empty(TMP->C5_NOTA) .Or. TMP->C5_LIBEROK=='E' .And. Empty(TMP->C5_BLQ)		// "Pedido Encerrado"	 
			cImage := '<img alt=\"VERMELHO\" src=\"/images/icones/icon-tabela-vermelho.png\">'
		Elseif !Empty(TMP->C5_LIBEROK) .And. Empty(TMP->C5_NOTA) .And. Empty(TMP->C5_BLQ)	// "Pedido Liberado"
			cImage := '<img alt=\"VERDE\" src=\"/images/icones/icon-tabela-verde.png\">'
		ElseIf !Empty(TMP->C5_BLQ)															// "Pedido Bloquedo"
			cImage := '<img alt=\"VERDE\" src=\"/images/icones/icon-tabela-verde.png\">'
		Endif

		cRet += '[ "' + IIF(EMPTY(cImage),			'',			cImage)
		cRet += '","' + IIF(EMPTY(TMP->C5_FILIAL),	'',			ALLTRIM(TMP->C5_FILIAL))
		cRet += '","' + IIF(EMPTY(TMP->C5_NUM),		'',			ALLTRIM(TMP->C5_NUM))
		cRet += '","' + IIF(EMPTY(TMP->C5_EMISSAO),	'',			ALLTRIM(DTOC(STOD(TMP->C5_EMISSAO))))
		cRet += '","' + IIF(EMPTY(TMP->A3_NOME),	'',			ALLTRIM(TMP->A3_NOME))
		cRet += '","' + IIF(EMPTY(TMP->A1_LOJA),	'',			ALLTRIM(TMP->A1_LOJA))
		cRet += '","' + IIF(EMPTY(TMP->A1_COD),		'',			ALLTRIM(TMP->A1_COD))
		cRet += '","' + IIF(EMPTY(TMP->C5_NOMCLI),	'',			ALLTRIM(TMP->C5_NOMCLI))
		cRet += '","' + IIF(EMPTY(TMP->DESCPAG),	'',			ALLTRIM(TMP->C5_CONDPAG + " - " + TMP->DESCPAG))
		cRet += '","' + AllTrim(Transform(TMP->QUANT,PesqPict('SC6','C6_QTDVEN')))
		cRet += '","' + AllTrim(Transform(TMP->SALDO,PesqPict('SC6','C6_QTDVEN')))
		cRet += '","' + AllTrim(Transform(TMP->VALOR,PesqPict('SC6','C6_VALOR')))
		cRet += '"],'

		TMP->(DbSkip())
	ENDDO

	cRet += CHR(13) + cHR(10)+ ']'

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA0011B
Retorna os itens do pedidos - CRA
@type function
@author Cassiano Melo
@since 11/09/2015
@return caracteres, json pedidos
/*/

User Function CRA0011B()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cImage	:= ""
	Local cVar01	:= HttpGet->PAR01
	Local cVar02	:= HttpGet->PAR02

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cKeyC5 := cVar01 + cVar02

	cSql :=" SELECT C5.C5_NUM, C5.C5_FILIAL, C5.C5_EMISSAO, C6.C6_ITEM, C6.C6_ENTREG, C6.C6_COMIS1, C6.C6_PRCVEN, C6.C6_VALDESC, "
	cSql +=" C6.C6_PRODUTO, C6.C6_DESCRI, (C6.C6_QTDVEN - C6.C6_QTDENT) AS SALDO, C6.C6_QTDVEN, C6.C6_QTDENT, C6.C6_VALOR, C6_C_VFRET "
	cSql +=" FROM " + RetSqlName("SC6") + " C6, " + RetSqlName("SC5") + " C5 "
	cSql +=" WHERE C5.C5_FILIAL = C6.C6_FILIAL "
	cSql +=" AND C5.C5_NUM = C6.C6_NUM "
	cSql +=" AND C6.D_E_L_E_T_ <> '*' "
	cSql +=" AND C5.D_E_L_E_T_ <> '*' "
	cSql +=" AND C5.C5_FILIAL + C5.C5_NUM = '" + cKeyC5 + "' "
	cSql +=" ORDER BY C5.C5_FILIAL, C5.C5_NUM, C6.C6_ITEM "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())
	
		IF TMP->SALDO <= 0 
			cImage := '<img alt=\"VERMELHO\" src=\"/images/icones/icon-tabela-vermelho.png\">'
		ELSE
			cImage := '<img alt=\"VERDE\" src=\"/images/icones/icon-tabela-verde.png\">'
		ENDIF

		cRet += '[ "' + IIF(EMPTY(cImage),			'',			cImage)
		cRet += '","' + IIF(EMPTY(TMP->C6_ITEM),	'',			ALLTRIM(TMP->C6_ITEM))
		cRet += '","' + IIF(EMPTY(TMP->C6_PRODUTO),	'',			ALLTRIM(TMP->C6_PRODUTO))
		cRet += '","' + IIF(EMPTY(TMP->C6_DESCRI),	'',			ALLTRIM(TMP->C6_DESCRI))
		cRet += '","' + IIF(EMPTY(TMP->C5_EMISSAO),	'',			ALLTRIM(DTOC(STOD(TMP->C5_EMISSAO))))
		cRet += '","' + IIF(EMPTY(TMP->C6_ENTREG),	'',			ALLTRIM(DTOC(STOD(TMP->C6_ENTREG))))
		cRet += '","' + AllTrim(Transform(TMP->C6_QTDVEN,PesqPict('SC6','C6_QTDVEN')))
		cRet += '","' + AllTrim(Transform(TMP->C6_QTDVEN,PesqPict('SC6','C6_QTDVEN')))
		cRet += '","' + AllTrim(Transform(TMP->SALDO,PesqPict('SC6','C6_QTDVEN')))
		cRet += '","' + AllTrim(Transform(TMP->C6_PRCVEN,PesqPict('SC6','C6_PRCVEN')))
		cRet += '","' + AllTrim(Transform(TMP->C6_VALOR,PesqPict('SC6','C6_VALOR')))
		cRet += '","' + AllTrim(Transform(TMP->C6_VALDESC,PesqPict('SC6','C6_VALDESC')))
		cRet += '","' + AllTrim(Transform(TMP->C6_C_VFRET,PesqPict('SC6','C6_C_VFRET')))
		cRet += '"],'
		
		TMP->(DbSkip())
	ENDDO

	cRet += CHR(13) + cHR(10)+ ']'

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00014
Retorna Notas do pedido - CRA
@type function
@author Cassiano Melo
@since 14/09/2015
@return caracteres, json notas
/*/

User Function CRA00014()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= """
	Local cPedid	:= HttpGet->PAR01
	Local cFilia	:= HttpGet->PAR02
	Local cRepre	:= HttpGet->PAR03

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVend := fVend(cRepre)

	cSql := " SELECT"
	cSql +=" D2.D2_FILIAL,"
	cSql +=" D2.D2_DOC,"
	cSql +=" D2.D2_SERIE,"
	cSql +=" CONVERT(VARCHAR(10),CONVERT(DATETIME,D2.D2_EMISSAO),103)+' as '+F2.F2_HORA as D2_EMISSAO,"
	cSql +=" D2.D2_QUANT,"
	cSql +=" D2.D2_TOTAL "
	cSql +=" FROM " + RetSqlName("SD2") + " D2, " + RetSqlName("SF2") + " F2 "
	cSql +=" WHERE D2.D_E_L_E_T_ <> '*'"
	cSql +=" AND F2.D_E_L_E_T_ <> '*'"
	cSql +=" AND D2.D2_FILIAL = F2.F2_FILIAL"
	cSql +=" AND D2.D2_DOC = F2.F2_DOC"
	cSql +=" AND D2.D2_SERIE = F2.F2_SERIE"
	cSql +=" AND F2.F2_VEND1 IN (" + cVend + ") "
	cSql +=" AND D2.D2_PEDIDO = '"+cPedid+"'"
	cSql +=" AND D2.D2_FILIAL = '"+cFilia+"'"
	cSql +=" ORDER BY D2.D2_DOC"

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())

		cRet += '[ "<i class=\"fa fa-download\"></i>'
		cRet += '","' + IIF(EMPTY(TMP->D2_DOC),		'',		 TMP->D2_DOC)
		cRet += '","' + IIF(EMPTY(TMP->D2_EMISSAO),	'',		 TMP->D2_EMISSAO)
		cRet += '","' + IIF(EMPTY(TMP->D2_QUANT),	'0.000', STR(TMP->D2_QUANT, 12, 3))
		cRet += '","' + IIF(EMPTY(TMP->D2_TOTAL),	'0.00',	 TRANSFORM(TMP->D2_TOTAL, "@E 999,999,999.99"))
		cRet += '"],'

		TMP->(DbSkip())
	ENDDO

	cRet += CHR(13) + cHR(10)+ ']'

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00018
Retorna browser de clientes
@type function
@author Cassiano Melo
@since 22/09/2015
@return caracteres, JSON string
/*/

User Function CRA00018()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cImage	:= ""
	Local cVend		:= ""
	Local nDiaAtr	:= 0
	Local lCliVend	:= .F.
	Local cVar01	:= ""
	Local cVar02	:= ""

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	nDiaAtr		:= 3
	lCliVend	:= GetMv("NT_CLIVEND",,.T.)
	cVar01		:= HttpGet->CDREP
	cVar02		:= HttpGet->LTALL
	cVend		:= fVend(cVar01)

	cSql := " SELECT DISTINCT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_CGC, SA1.A1_RISCO, SA1.A1_VEND, "
	cSql += " 	(SELECT COUNT(*) FROM " + RetSqlName("SE1") + " SE1 WHERE SE1.D_E_L_E_T_ = '' AND SE1.E1_CLIENTE = SA1.A1_COD AND SE1.E1_LOJA = SA1.A1_LOJA "
	cSql += " 	AND SE1.E1_TIPO NOT IN ('RA ','NCC') AND SE1.E1_SALDO > 0 AND SE1.E1_VENCREA <= '" + DTOS(Date() - nDiaAtr) + "') AS TITVENC "
	cSql += " FROM " + RetSqlName("SA1") + " SA1 "
	cSql += " WHERE SA1.D_E_L_E_T_ = '' AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
	If lCliVend
		cSql += " AND SA1.A1_VEND IN (" + cVend + ") "
	Endif

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())
	
		If cVar02 == "0" .AND. TMP->TITVENC == 0
			TMP->(DbSkip())
			Loop
		Endif
		
		// Imagem de Status da Grid
		If TMP->TITVENC > 0
			cImage := '<img alt=\"VERMELHO\" src=\"/images/agronelli/icon-tabela-vermelho.png\">'
		Else
			cImage := '<img alt=\"VERDE\" src=\"/images/agronelli/icon-tabela-verde.png\">'
		Endif
		
		cVendedor := Posicione("SA3",1,xFilial("SA3") + TMP->A1_VEND, "A3_NOME")

		cRet += '[ "' + IIF(EMPTY(cImage)		, ''	, cImage			)
		cRet += '","' + IIF(EMPTY(TMP->A1_COD)	, ''	, TMP->A1_COD		)
		cRet += '","' + IIF(EMPTY(TMP->A1_LOJA)	, ''	, TMP->A1_LOJA		)
		cRet += '","' + IIF(EMPTY(TMP->A1_NOME)	, ''	, TMP->A1_NOME		)
		cRet += '","' + IIF(EMPTY(TMP->A1_CGC)	, ''	, TMP->A1_CGC		)
		cRet += '","' + IIF(EMPTY(TMP->A1_RISCO), ''	, TMP->A1_RISCO		)
		cRet += '","' + IIF(EMPTY(cVendedor)	, ''	, cVendedor			)
		
		cRet +=  '"], '

		TMP->(DbSkip())
	ENDDO
	cRet += "]"
	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00019
Retorna os Relação Clientes - CRA
@type function
@author Rafael Silva Santiago
@since 22/09/2015
@return caracteres, JSON string
/*/

User Function CRA00019()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cVar01	:= HttpGet->USUAR
	Local cVar02	:= Val(HttpGet->SITUA)

	// Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVend := fVend(cVar01)

	cSql := " SELECT DISTINCT"
	cSql += " 	SA1.A1_COD,"
	cSql += " 	SA1.A1_LOJA,"
	cSql += " 	SA1.A1_NOME,"
	cSql += " 	SA1.A1_MUN,"
	cSql += " 	SA1.A1_EST,"
	cSql += " 	SA1.A1_TEL,"
	cSql += " 	SA1.A1_DDD,"
	cSql += " 	SA1.A1_CONTATO"
	cSql += " FROM "
	cSql += " 	" + RetSqlName("SA1") + " SA1 "
	cSql += " WHERE SA1.D_E_L_E_T_ <> '*' "
	cSql += " 	AND SA1.A1_VEND IN (" + cVend + ") "

	If(cVar02 == 1)
		cSql +=" AND SA1.A1_MSBLQL = '1' "
	Elseif(cVar02 == 2)
		cSql +=" AND SA1.A1_MSBLQL <> '1' "
	Endif

	cSql += " ORDER BY"
	cSql += " 	SA1.A1_NOME,"
	cSql += " 	SA1.A1_LOJA"

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())

		cRet += '[ "' + IIF(EMPTY(TMP->A1_COD), '', TMP->A1_COD)
		cRet += '","' + IIF(EMPTY(TMP->A1_LOJA), '', TMP->A1_LOJA)
		cRet += '","' + IIF(EMPTY(TMP->A1_NOME), '', TMP->A1_NOME)
		cRet += '","' + IIF(EMPTY(TMP->A1_MUN), '', TMP->A1_MUN)
		cRet += '","' + IIF(EMPTY(TMP->A1_EST), '', TMP->A1_EST)
		cRet += '","' + IIF(EMPTY(TMP->A1_DDD), '', TMP->A1_DDD)
		cRet += '","' + IIF(EMPTY(TMP->A1_TEL), '', TMP->A1_TEL)
		cRet += '","' + IIF(EMPTY(TMP->A1_CONTATO), '', TMP->A1_CONTATO)
		cRet +=  '"], '

		TMP->(DbSkip())
	ENDDO

	cRet += CHR(13) + cHR(10)+ ']'

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00021
Retorna Relação de Faturas - CRA
@type function
@author Rafael Silva Santiago
@since 30/09/2015
/*/

User Function CRA00021()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cVar01	:= HttpGet->NOT01
	Local cVar02	:= HttpGet->NOT02
	Local cVar03	:= HttpGet->CLI01
	Local cVar04	:= HttpGet->CLI02
	Local cVar05 	:= DToS(CToD(HttpGet->DAT01))
	Local cVar06 	:= DToS(CToD(HttpGet->DAT02))
	Local cVar07	:= Val(HttpGet->SITUA)
	Local cVar08	:= HttpGet->USUAR

	//Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVend := fVend(cVar08)

	cSql := " SELECT"
	cSql +=" 	SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_NOMCLI, SE1.E1_NUM, "
	cSql +=" 	SE1.E1_EMISSAO, SE1.E1_VENCTO, SE1.E1_VALOR, SE1.E1_TIPO "
	cSql +=" FROM " + RetSqlName("SE1") + " SE1, " + RetSqlName("SC5") + " SC5 "
	cSql +=" WHERE SE1.D_E_L_E_T_ <> '*' "
	cSql +=" 	AND SC5.D_E_L_E_T_ <> '*' "

	IF !EMPTY(cVar01)
		cSql +=" 	AND SE1.E1_NUM >= '" + cVar01 + "' "
	ENDIF

	IF !EMPTY(cVar02)
		cSql +=" 	AND SE1.E1_NUM <= '" + cVar02 + "' "
	ENDIF

	IF !EMPTY(cVar03)
		cSql +=" 	AND SE1.E1_CLIENTE >= '" + cVar03 + "' "
	ENDIF

	IF !EMPTY(cVar04)
		cSql +=" 	AND SE1.E1_CLIENTE <= '" + cVar04 + "' "
	ENDIF

	IF !EMPTY(cVar05)
		cSql +=" 	AND SE1.E1_EMISSAO >= '" + cVar05 + "' "
	ENDIF

	IF !EMPTY(cVar06)
		cSql +=" 	AND SE1.E1_EMISSAO <= '" + cVar06 + "' "
	ENDIF

	cSql +=" 	AND SE1.E1_SITUACA IN ('0', '1') "
	cSql +=" 	AND SE1.E1_TIPO IN ('NF', 'DP', 'CH') "
	cSql +=" 	AND SE1.E1_FATURA IN ('', 'NOTFAT') "

	IF( cVar07 == 1 )
		cSql +=" 	AND SE1.E1_SALDO > 0 "
	ELSEIF( cVar07 == 2 )
		cSql +=" 	AND SE1.E1_SALDO = 0 "
	ENDIF
	cSql +=" 	AND SC5.C5_VEND1 IN (" + cVend + ") "
	cSql +=" 	AND SC5.C5_FILIAL = SE1.E1_MSFIL "
	cSql +=" 	AND SC5.C5_NUM = SE1.E1_PEDIDO "
	cSql +=" GROUP BY "
	cSql +=" 	SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_NOMCLI, SE1.E1_NUM, SE1.E1_EMISSAO, SE1.E1_VENCTO, "
	cSql +=" 	SE1.E1_VALOR, SE1.E1_TIPO "
	cSql +=" ORDER BY "
	cSql +=" 	SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_NOMCLI, SE1.E1_NUM, SE1.E1_EMISSAO, SE1.E1_VENCTO, "
	cSql +=" 	SE1.E1_VALOR, SE1.E1_TIPO "


	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())

		cRet += '[ "' + IIF(EMPTY(TMP->E1_NUM), '', TMP->E1_NUM)
		cRet += '","' + IIF(EMPTY(TMP->E1_TIPO), '', TMP->E1_TIPO)
		cRet += '","' + IIF(EMPTY(TMP->E1_LOJA), '', TMP->E1_LOJA)
		cRet += '","' + IIF(EMPTY(TMP->E1_NOMCLI), '', TMP->E1_NOMCLI)
		cRet += '","' + IIF(EMPTY(TMP->E1_EMISSAO), '', TMP->E1_EMISSAO)
		cRet += '","' + IIF(EMPTY(TMP->E1_VENCTO), '', TMP->E1_VENCTO)
		cRet += '","' + IIF(EMPTY(TMP->E1_VALOR), '', Str(TMP->E1_VALOR,10,3))
		cRet += '","' + IIF(EMPTY(TMP->E1_EMISSAO), '', TMP->E1_EMISSAO)
		cRet +=  '"], '

		cRet += CHR(13) + cHR(10)

		TMP->(DbSkip())
	ENDDO
	cRet += "]"
	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00034
Gráfico Carregamento por Filial - CRA
@type function
@author Cassiano Melo
@since 15/10/2015
/*/

User Function CRA00034()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cVar01	:= HttpGet->usuario
	Local cVar02 	:= DToS(CToD(HttpGet->data))
	
	//Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVend := fVend(cVar01)

	cSql :=" SELECT "
	cSql +=" 	SD2.D2_FILIAL AS RESULTADO, "
	cSql +=" 	ROUND(SUM(SD2.D2_QUANT),2) AS TOTAL "
	cSql +=" FROM "
	cSql +=" 	" + RetSqlName("SD2") + " SD2, "
	cSql +=" 	" + RetSqlName("SC5") + " SC5 "
	cSql +=" WHERE SC5.D_E_L_E_T_ <> '*' "
	cSql +=" 	AND SD2.D_E_L_E_T_ <> '*' "
	cSql +=" 	AND SC5.C5_VEND1 IN (" + cVend + ") "
	cSql +=" 	AND SD2.D2_EMISSAO >= '" + cVar02 + "' "
	cSql +=" 	AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' "
	cSql +=" 	AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cSql +=" 	AND SD2.D2_TIPO = 'N' "
	cSql +=" 	AND SD2.D2_PEDIDO = SC5.C5_NUM "
	cSql +=" GROUP "
	cSql +=" 	BY SD2.D2_FILIAL "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())

		cRet += '[ "' + IIF(EMPTY(TMP->RESULTADO),	'',	TMP->RESULTADO)
		cRet += '","' + IIF(EMPTY(TMP->TOTAL),		'',	STR(TMP->TOTAL))
		cRet +=  '"], '

		cRet += CHR(13) + cHR(10)

		TMP->(DbSkip())
	ENDDO
	cRet += "]"
	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00035
Gráfico Carregamentos por Produto - CRA
@type function
@author Cassiano Melo
@since 15/10/2015
/*/

User Function CRA00035()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cVar01	:= HttpGet->usuario
	Local cVar02 	:= DToS(CToD(HttpGet->data))
	//Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVend := fVend(cVar01)

	cSql :=" SELECT "
	cSql +=" 	SB1.B1_DESC AS RESULTADO, "
	cSql +=" 	ROUND(SUM(SD2.D2_QUANT),2) AS TOTAL "
	cSql +=" FROM "
	cSql +=" 	" + RetSqlName("SD2") + " SD2, "
	cSql +=" 	" + RetSqlName("SB1") + " SB1, "
	cSql +=" 	" + RetSqlName("SC5") + " SC5 "
	cSql +=" WHERE "
	cSql +=" 	SD2.D_E_L_E_T_ <> '*' "
	cSql +=" 	AND SB1.D_E_L_E_T_ <> '*' "
	cSql +=" 	AND SC5.D_E_L_E_T_ <> '*' "
	cSql +=" 	AND SC5.C5_VEND1 IN (" + cVend + ") "
	cSql +=" 	AND SD2.D2_EMISSAO >= '" + cVar02 + "' "
	cSql +=" 	AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' "
	cSql +=" 	AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cSql +=" 	AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
	cSql +=" 	AND SD2.D2_TIPO = 'N' "
	cSql +=" 	AND SD2.D2_PEDIDO = SC5.C5_NUM "
	cSql +=" 	AND SD2.D2_COD = SB1.B1_COD "
	cSql +=" GROUP "
	cSql +=" 	BY SB1.B1_DESC "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())

		cRet += '[ "' + IIF(EMPTY(TMP->RESULTADO),	'',	TMP->RESULTADO)
		cRet += '","' + IIF(EMPTY(TMP->TOTAL),		'',	STR(TMP->TOTAL))
		cRet +=  '"], '

		cRet += CHR(13) + cHR(10)

		TMP->(DbSkip())
	ENDDO
	cRet += "]"
	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00036
Gráfico Carregamento por Estado - CRA
@type function
@author Cassiano Melo
@since 15/10/2015
/*/

User Function CRA00036()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cVar01	:= HttpGet->usuario
	Local cVar02 	:= DToS(CToD(HttpGet->data))
	//Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVend := fVend(cVar01)

	cSql :=" SELECT "
	cSql +=" 	SF2.F2_EST AS RESULTADO, "
	cSql +=" 	ROUND(SUM(SD2.D2_QUANT),2) AS TOTAL "
	cSql +=" FROM "
	cSql +=" 	" + RetSqlName("SD2") + " SD2, "
	cSql +=" 	" + RetSqlName("SF2") + " SF2 "
	cSql +=" WHERE "
	cSql +=" 	SD2.D_E_L_E_T_ <> '*' "
	cSql +=" 	AND SF2.D_E_L_E_T_ <> '*' "
	cSql +=" 	AND SF2.F2_VEND1 IN (" + cVend + ") "
	cSql +=" 	AND SD2.D2_EMISSAO >= '" + cVar02 + "' "
	cSql +=" 	AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
	cSql +=" 	AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cSql +=" 	AND SD2.D2_TIPO = 'N' "
	cSql +=" 	AND SD2.D2_DOC = SF2.F2_DOC "
	cSql +=" 	AND SD2.D2_SERIE = SF2.F2_SERIE "
	cSql +=" GROUP "
	cSql +=" 	BY SF2.F2_EST "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())

		cRet += '[ "' + IIF(EMPTY(TMP->RESULTADO),	'',	TMP->RESULTADO)
		cRet += '","' + IIF(EMPTY(TMP->TOTAL),		'',	STR(TMP->TOTAL))
		cRet +=  '"], '

		cRet += CHR(13) + cHR(10)

		TMP->(DbSkip())
	ENDDO
	cRet += "]"
	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00037
Gráfico Carregamentos por Município - CRA
@type function
@author Cassiano Melo
@since 15/10/2015
/*/

User Function CRA00037()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cVar01	:= HttpGet->usuario
	Local cVar02 	:= DToS(CToD(HttpGet->data))
	//Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVend := fVend(cVar01)

	cSql :=" SELECT "
	cSql +=" 	SA1.A1_MUN AS RESULTADO, "
	cSql +=" 	ROUND(SUM(SD2.D2_QUANT),2) AS TOTAL "
	cSql +=" FROM "
	cSql +=" 	" + RetSqlName("SD2") + " SD2, "
	cSql +=" 	" + RetSqlName("SF2") + " SF2, "
	cSql +=" 	" + RetSqlName("SA1") + " SA1 "
	cSql +=" WHERE "
	cSql +=" 	SD2.D_E_L_E_T_ <> '*' "
	cSql +=" 	AND SF2.D_E_L_E_T_ <> '*' "
	cSql +=" 	AND SA1.D_E_L_E_T_ <> '*' "
	cSql +=" 	AND SF2.F2_VEND1 IN (" + cVend + ") "
	cSql +=" 	AND SD2.D2_EMISSAO >= '" + cVar02 + "' "
	cSql +=" 	AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
	cSql +=" 	AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cSql +=" 	AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
	cSql +=" 	AND SD2.D2_TIPO = 'N' "
	cSql +=" 	AND SD2.D2_DOC = SF2.F2_DOC "
	cSql +=" 	AND SD2.D2_SERIE = SF2.F2_SERIE "
	cSql +=" 	AND SF2.F2_CLIENTE = SA1.A1_COD "
	cSql +=" 	AND SF2.F2_LOJA = SA1.A1_LOJA "
	cSql +=" GROUP BY "
	cSql +=" 	SA1.A1_MUN "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())

		cRet += '[ "' + IIF(EMPTY(TMP->RESULTADO),	'',	TMP->RESULTADO)
		cRet += '","' + IIF(EMPTY(TMP->TOTAL),		'',	STR(TMP->TOTAL))
		cRet +=  '"], '

		cRet += CHR(13) + cHR(10)

		TMP->(DbSkip())
	ENDDO
	cRet += "]"
	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRA00038
Gráfico Carregamento por Cliente - CRA
@type function
@author Cassiano Melo
@since 15/10/2015
/*/

User Function CRA00038()

	Local cSql		:= ""
	Local cRet		:= ""
	Local cVend		:= ""
	Local cVar01	:= HttpGet->usuario
	Local cVar02 	:= DToS(CToD(HttpGet->data))
	//Prepara Ambiente

	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	cVend := fVend(cVar01)

	cSql :=" SELECT "
	cSql +=" 	SA1.A1_NOME AS RESULTADO, "
	cSql +=" 	ROUND(SUM(SD2.D2_QUANT),2) AS TOTAL "
	cSql +=" FROM "
	cSql +=" 	" + RetSqlName("SD2") + " SD2, "
	cSql +=" 	" + RetSqlName("SF2") + " SF2, "
	cSql +=" 	" + RetSqlName("SA1") + " SA1 "
	cSql +=" WHERE "
	cSql +=" 	SD2.D_E_L_E_T_ <> '*' "
	cSql +=" 	AND SF2.D_E_L_E_T_ <> '*' "
	cSql +=" 	AND SA1.D_E_L_E_T_ <> '*' "
	cSql +=" 	AND SF2.F2_VEND1 IN (" + cVend + ") "
	cSql +=" 	AND SD2.D2_EMISSAO >= '" + cVar02 + "' "
	cSql +=" 	AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
	cSql +=" 	AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cSql +=" 	AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
	cSql +=" 	AND SD2.D2_TIPO = 'N' "
	cSql +=" 	AND SD2.D2_DOC = SF2.F2_DOC "
	cSql +=" 	AND SD2.D2_SERIE = SF2.F2_SERIE "
	cSql +=" 	AND SF2.F2_CLIENTE = SA1.A1_COD "
	cSql +=" 	AND SF2.F2_LOJA = SA1.A1_LOJA "
	cSql +=" GROUP BY "
	cSql +=" 	SA1.A1_NOME "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	DBUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)

	cRet := "[" + CHR(13) + cHR(10)

	DbSelectArea("TMP")
	TMP->(DbgoTop())
	WHILE !TMP->(Eof())

		cRet += '[ "' + IIF(EMPTY(TMP->RESULTADO),	'',	TMP->RESULTADO)
		cRet += '","' + IIF(EMPTY(TMP->TOTAL),		'',	STR(TMP->TOTAL))
		cRet +=  '"], '

		cRet += CHR(13) + cHR(10)

		TMP->(DbSkip())
	ENDDO
	cRet += "]"
	If Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
	Endif

	RESET ENVIRONMENT

Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRALOGIN
Valida senha do portal
@type   function
@author Marco Aurelio Braga
@since  01/02/2016
/*/

User Function CRALOGIN()

	Local cRet   := ""
	Local cMsg   := ""
	Local cAdm   := ""
	Local cApv   := ""
	Local lVld   := .F.
	Local cVar01 := Decode64(HttpGet->USR)
	Local cVar02 := HttpGet->PSW
	
	//Prepara Ambiente
	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))
	If SA3->(DbSeek("01  "+cVar01))
		If SA3->(FieldPos("A3_N_PSW")) > 0
			If SA3->A3_MSBLQL <> "1"
				If AllTrim(SA3->A3_N_PSW) == AllTrim(cVar02)			
					cMsg := "Autenticado com sucesso!"
					cAdm := SubStr(SA3->A3_TIPSUP,1,1)
					cApv := SubStr(SA3->A3_TIPSUP,2,1)
					lVld := .T.
				Else  
					cMsg := "Senha invalida!"
				Endif
			Else
				cMsg := "Usuário bloqueado!"
			Endif
		Else
			cMsg := "Erro na base de dados!"
		Endif
	Else
		cMsg := "Login invalido!"
	Endif
	
	cRet := "[" + CHR(13) + cHR(10)
	
	If lVld
		cRet += '[ "' + "1"
		cRet += '","' + cMsg
		cRet += '","' + CAPITAL(AllTrim(SA3->A3_NOME))
		cRet += '","' + Lower(AllTrim(SA3->A3_EMAIL))
		cRet += '","' + IIF(Empty(cAdm),"U",cAdm) + IIF(Empty(cApv),"V",cApv)
		cRet += '"],'
	Else
		cRet += '[ "' + "0"
		cRet += '","' + cMsg
		cRet += '","' 
		cRet += '","'
		cRet += '","'
		cRet += '"],'
	Endif
	
	cRet += "]"
	
	SA3->(DbCloseArea())
		
Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} CRAEDTPSW
Edita senha do vendedor
@type   function
@author Marco Aurelio Braga
@since  01/02/2016
/*/

User Function CRAEDTPSW()

	Local cRet   := ""
	Local cMsg   := ""
	Local lVld   := .F.
	Local cVar01 := Decode64(HttpGet->USR)
	Local cVar02 := HttpGet->PSW
	
	//Prepara Ambiente
	RESET ENVIRONMENT

	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0101" ) MODULO ( "SIGACOM" )
	EndIf
	
	If Empty(cVar01) .OR. Len(cVar01) <> 6 .OR. Empty(cVar02)
		cMsg := "Parêmetros invalidos!"
	Else
		DbSelectArea("SA3")
		SA3->(DbSetOrder(1))
		If SA3->(DbSeek("01  "+cVar01))
			If SA3->(FieldPos("A3_N_PSW")) > 0
				SA3->(RecLock("SA3",.F.))
				SA3->A3_N_PSW := cVar02
				SA3->(MsUnLock())
				lVld := .T.
				cMsg := "Senha alterada com sucesso!"
			Else
				cMsg := "Erro na base de dados!"
			Endif
		Else
			cMsg := "Login invalido!"
		Endif
	Endif
	
	cRet := "[" + CHR(13) + cHR(10)
	
	If lVld
		cRet += '[ "' + "1"
		cRet += '","' + cMsg
		cRet += '"],'
	Else
		cRet += '[ "' + "0"
		cRet += '","' + cMsg
		cRet += '"],'
	Endif
	
	cRet += "]"
	
	SA3->(DbCloseArea())
		
Return(cRet)


/****************************************************************************************************/


/*/{Protheus.doc} fVend
 Retorna Vendedores subordinados
@type   function
@author Marco Aurelio Braga
@since  01/02/2016
/*/

Static Function fVend(cVend,cMailSup)
	
	Local aArea		:= GetArea()
	Local cAlias	:= GetNextAlias()
	Local cVends	:= "'"+cVend+"',"
	Local lLoop		:= Upper(ProcName(1)) == Upper("fVend")
	
	Default cMailSup := ""
	
	BeginSql alias cAlias
		SELECT	SA3.A3_COD, SA3.A3_EMAIL
		FROM	%Table:SA3% SA3
		WHERE	SA3.%NOTDEL% 
				AND SA3.A3_FILIAL	= %Exp:xFilial("SA3")%
				AND SA3.A3_SUPER	= %Exp:cVend%
	EndSql
	
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	If (cAlias)->(!Eof())
		While (cAlias)->(!Eof())
			cVends += fVend((cAlias)->A3_COD)
			cMailSup += Alltrim((cAlias)->A3_EMAIL) + ";"
			(cAlias)->(DbSkip())
		Enddo
		cMailSup := IIf(Right(cMailSup,1)==";",Substr(cMailSup,1,Len(cMailSup)-1),cMailSup)
	Endif
	
	If !lLoop
		cVends := SubStr(cVends,1,Len(cVends)-1)
	Endif
	
	(cAlias)->(DbCloseArea())
	
	RestArea(aArea)

Return(cVends)


/****************************************************************************************************/


/*/{Protheus.doc} xFilial
 Temporario para tratar filial Nutratta
@type   function
@author Marco Aurelio Braga
@since  01/02/2016
/*/

Static Function fFilial(cAlias)

	Local cFil	:= xFilial(cAlias)
	Local cRet	:= ""
	
	DbSelectArea("SX2")
	SX2->(DbSetOrder(1))
	If SX2->(DbSeek(cAlias))
	
		If SX2->X2_MODOUN == "E"
			cRet += cEmpAnt
		Else
			cRet += Space(2)
		Endif
		
		If SX2->X2_MODO == "E"
			cRet += cFil
		Else
			cRet += Space(2)
		Endif

	Endif

Return(cRet)
