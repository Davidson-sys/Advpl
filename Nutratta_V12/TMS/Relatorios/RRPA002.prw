#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"


//------------------------------------------------------------------+

/*/{Protheus.doc} RRPA002()
Relatorio de RPA Nutratta
@author 	Davis Magalhaes
@since 		31/08/2015
@version 	P11 R5
@param   	n/t
@return  	n/t
@obs        Programa Especifico para Nutratta  
Fonte ulizado para acertar o PIS Fornecedor -A2_N_PIS
/*/
//------------------------------------------------------------------+

User Function RRPA002()

Local nOpca

Private cFilOri    := DTY->DTY_FILORI
Private cNumContr  := DTY->DTY_NUMCTC
Private cNumViagem := DTY->DTY_VIAGEM


nOpca := Aviso("Nutratta","Deseja Emitir o Recibo de Pagamento de Autonomo - RPA. ?",{"Emitir","Sair"},2,"Contrato: "+DTY->DTY_NUMCTC)

           
If nOpca == 1

	If DTY->DTY_TIPCTC == "1"
		Processa({||FImpRel()},"Aguarde...","Processando Recibo / Contrato de transporte Rodoviario...")
	Else
		Aviso("RTMS04A","Esse contrato só pode ser emitido para pagamentos de viagens. Por Periodo deverá ir para rotina Especifica.",{"Voltar"},2,"Relatorio Contrato")
	EndIf

EndIf

Return()



Static Function FImpRel()
/****************************************************************************************
** Imprime Relatório
**
***************************/

Local oPrint
Local nLin 	   		:= 0
Local nNumLin  		:= 2000
Local nTamLin		:= 2370
Local nCol			:= 050
Local aBmp:= "logocte.bmp"


//OBJETOS PARA TAMANHO E TIPO DE FONTES.
/*
Local oFont11 		:= TFont():New("Arial",,11,,.T.,,,,,.F.)
Local oFont11n 		:= TFont():New("Arial",,11,,.F.,,,,,.F.)
Local oFont0 		:= TFont():New("Arial",,12,,.T.,,,,,.F.)
Local oFont1 		:= TFont():New("Arial",,12,,.F.,,,,,.F.)
Local oFont12n		:= TFont():New('Arial',12,12,,.T.,,,,.T.,.F.)
Local oFont2 		:= TFont():New("Arial",,13,,.T.,,,,,.F.)
Local oFont3 		:= TFont():New("Arial",,16,,.T.,,,,,.F.)
Local oFont4 		:= TFont():New("Arial",,09,,.F.,,,,,.F.)
Local oFont5 		:= TFont():New("Arial",,12,,.F.,,,,,.F.)
Local oFont07		:= TFont():New('Arial',07,07,,.F.,,,,.T.,.F.)
Local oFont07n		:= TFont():New('Arial',07,07,,.T.,,,,.T.,.F.)
Local oFont08		:= TFont():New('Arial',08,08,,.F.,,,,.T.,.F.)
Local oFont08n 		:= TFont():New('Arial',08,08,,.T.,,,,.T.,.F.)
Local oFont09		:= TFont():New('Arial',09,09,,.F.,,,,.T.,.F.)
Local oFont09n 		:= TFont():New('Arial',09,09,,.T.,,,,.T.,.F.)
Local oFont10		:= TFont():New('Arial',10,10,,.F.,,,,.T.,.F.)
Local oFont10n 		:= TFont():New('Arial',10,10,,.T.,,,,.T.,.F.)
Local oFont12		:= TFont():New('Arial',12,12,,.F.,,,,.T.,.F.)
*/
Local oFont11 		:= TFont():New("Arial",,08,,.T.,,,,,.F.)
Local oFont11n 		:= TFont():New("Arial",,08,,.F.,,,,,.F.)
Local oFont0 		:= TFont():New("Arial",,09,,.T.,,,,,.F.)
Local oFont1 		:= TFont():New("Arial",,09,,.F.,,,,,.F.)
Local oFont12n		:= TFont():New('Arial',09,09,,.T.,,,,.T.,.F.)
Local oFont2 		:= TFont():New("Arial",,10,,.T.,,,,,.F.)
Local oFont3 		:= TFont():New("Arial",,13,,.T.,,,,,.F.)
Local oFont4 		:= TFont():New("Arial",,06,,.F.,,,,,.F.)
Local oFont5 		:= TFont():New("Arial",,09,,.F.,,,,,.F.)
Local oFont07		:= TFont():New('Arial',04,04,,.F.,,,,.T.,.F.)
Local oFont07n		:= TFont():New('Arial',04,04,,.T.,,,,.T.,.F.)
Local oFont08		:= TFont():New('Arial',05,05,,.F.,,,,.T.,.F.)
Local oFont08n 		:= TFont():New('Arial',05,05,,.T.,,,,.T.,.F.)
Local oFont09		:= TFont():New('Arial',06,06,,.F.,,,,.T.,.F.)
Local oFont09n 		:= TFont():New('Arial',06,06,,.T.,,,,.T.,.F.)
Local oFont10		:= TFont():New('Arial',07,07,,.F.,,,,.T.,.F.)
Local oFont10n 		:= TFont():New('Arial',07,07,,.T.,,,,.T.,.F.)
Local oFont12		:= TFont():New('Arial',09,09,,.F.,,,,.T.,.F.)

Local aSaveArea:=GetArea()
Local cAliasDTA := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Objeto TMSPrinter							     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint	:= TMSPrinter():New(OemToAnsi("Contrato de Carreteiro"))
oPrint	:SetPortrait()  //SetLandscape(.T.)	//Paisagem... -- Retrato
oPrint:SetPaperSize(9)		//Papel A4
oPrint	:Setup()

nLin := nLin + 100

oPrint:Line(nLin,nCol,nLin,nTamLin) //Borda superior
oPrint:Line(nLin,nCol,nNumLin,nCol) //Borda esquerda
oPrint:Line(nLin,nTamLin,nNumLin,nTamLin) //Borda direita
oPrint:Line(nNumLin,nCol,nNumLin,nTamLin) //Borda inferior

//Inserir o logotipo
oPrint:SayBitmap(nLin+50,nCol+050,aBmp,500,200)//0175,0100

oPrint:Say(nLin+250,nCol+650,"nutratta@nutratta.com.br ",oFont11n )

//Recibo contratante de transporte rodoviario.
oPrint:Say(nLin+50,nCol+1350,"RECIBO / CONTRATO DE TANSPORTE",oFont12n )
oPrint:Say(nLin+100,nCol+1350,"RODOVIARIO DE BENS",oFont12n )

//Box com o Numero ex:004697
oPrint:Line(nLin,nCol+2100,nLin+200,nCol+2100) //Box para numeração da via
oPrint:Line(nLin+200,nCol+2100,nLin+200,nTamLin) //Fechamento do box da numeração da via
oPrint:Say(nLin+050,nCol+2200,"No.",oFont12n )
oPrint:Say(nLin+100,nCol+2125,cNumContr,oFont1 ) //Variavel

oPrint:Say(nLin+200,nCol+650,"Site:www.nutratta.com.br",oFont11n )
oPrint:Line(nLin,nCol+1100,nNumLin,nCol+1100) //Linha divisoria central.Vertical

oPrint:Say(nLin+50,nCol+600,Alltrim(SM0->M0_ENDCOB),oFont11n )
oPrint:Say(nLin+100,nCol+600,"Bairro: "+Alltrim(SM0->M0_BAIRCOB),oFont11n )
oPrint:Say(nLin+150,nCol+600,Alltrim(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB+"  CEP: "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont11n )

//Box com o numero da via
oPrint:Line(nLin+150,nCol+1200,nLin+150,nCol+1550)//Borda superior
oPrint:Line(nLin+150,nCol+1200,nLin+200,nCol+1200)//Borda esquerda
oPrint:Line(nLin+150,nCol+1550,nLin+200,nCol+1550) //Borda direita
oPrint:Line(nLin+200,nCol+1200,nLin+200,nCol+1550) //Borda inferior
oPrint:Say(nLin+155,nCol+1210,"1a Via-Contratante",oFont11n)

//Dados do recebedor
oPrint:Say(nLin+250,nCol+1150,"Resp:",oFont11n )                                            
oPrint:Say(nLin+250,nCol+1260,Substr(cUserName,1,25),oFont11n)//Variavel

oPrint:Say(nLin+250,nCol+1600,"Data:",oFont1 )
oPrint:Say(nLin+250,nCol+1750,Substr(dtos(DTY->DTY_DATCTC),7,2)+"/"+Substr(dtos(DTY->DTY_DATCTC),5,2)+"/"+Substr(dtos(DTY->DTY_DATCTC),1,4),oFont11n )//Variavel

//oPrint:Say(nLin+250,nCol+1700,"RCTRB",oFont11n )
//oPrint:Say(nLin+250,nCol+1850,"",oFont11n )//Variavel

oPrint:Line(nLin+300,nCol,nLin+300,nTamLin) //Linha divisoria horizontal

//Dados do contratante.
oPrint:Line(nLin+800,nCol,nLin+800,nTamLin) //Linha divisoria horizontal

oPrint:Say(nLin+350,nCol+50,"CONTRATANTE:",oFont12n )
oPrint:Say(nLin+350,nCol+350,Alltrim(Substr(SM0->M0_NOMECOM,1,24)),oFont12) //vairal SM0
oPrint:Say(nLin+380,nCol+350,Alltrim(Substr(SM0->M0_NOMECOM,25,41)),oFont12) //vairal SM0
nLin:=nLin+20
oPrint:Say(nLin+400,nCol+50,"MATRIZ:",oFont12n )
oPrint:Say(nLin+450,nCol+50,Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_BAIRCOB),oFont11n )  //SM0  RUA+NUMERO+BAIRRO+TELEFONE+CEP+CIDADE+MUNICIPIO+ESTADO+CNPJ+INCEST
oPrint:Say(nLin+500,nCol+50,"Tel: "+ALLTRIM(SM0->M0_TEL)+" - CEP: "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont11n ) 
oPrint:Say(nLin+550,nCol+50,Alltrim(SM0->M0_CIDCOB)+" / "+SM0->M0_ESTCOB+" - CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFont11n )
oPrint:Say(nLin+600,nCol+50,"Insc.Est.: "+Alltrim(SM0->M0_INSC),oFont11n)


//Discriminação dos serivços prestados

If DTY->DTY_TIPCTC == "1"
	
	nPesoCarg := DTY->DTY_PESO
	
	cAliasDTA := GetNextAlias()
	
	cQuery := "SELECT * FROM "+RetSqlName("DTA")
	cQuery += " WHERE D_E_L_E_T_ <> '*' AND DTA_FILIAL = '"+xFilial("DTA")+"' AND "
	cQuery += " DTA_VIAGEM = '"+cNumViagem+"' "
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasDTA, .T., .T.)
	
	dbSelectArea(cAliasDTA)
	dbGoTop()
	
	cNumCtr     := ""
	nValorMerc  := 0
	cMercadoria := ""
	cOrigem     := ""
	cDestino    := ""
	
	If ! (cAliasDTA)->( Eof() )
		
		While ! (cAliasDTA)->( Eof() )
			
			cNumCtr += (cAliasDTA)->DTA_DOC
			
			dbSelectArea("DT6")
			DT6->( dbSetOrder(1) )
			If DT6->( dbSeek(xFilial("DT6")+(cAliasDTA)->DTA_FILDOC+(cAliasDTA)->DTA_DOC+(cAliasDTA)->DTA_SERIE) )
				
				nValorMerc += DT6->DT6_VALMER
				cOrigem  := Alltrim(Posicione("DUY",1,xFilial("DUY")+DT6->DT6_CDRORI,"DUY_DESCRI"))+"/"+Posicione("DUY",1,xFilial("DUY")+DT6->DT6_CDRORI,"DUY_EST")
				cDestino := Alltrim(Posicione("DUY",1,xFilial("DUY")+DT6->DT6_CDRDES,"DUY_DESCRI"))+"/"+Posicione("DUY",1,xFilial("DUY")+DT6->DT6_CDRDES,"DUY_EST")
				
			EndIF
			
			(cAliasDTA)->( dbSkip() )
			
			If ! (cAliasDTA)->( Eof() )
				cNumCtr += "/"
			EndIF
			
		End
	EndIf
	
	dbSelectArea(cAliasDTA)
	dbCloseArea()
	
	
Else
	
	nPesoCarg   := 0
	cNumCtr     := ""
	nValorMerc  := 0
	cMercadoria := ""
	cOrigem     := ""
	cDestino    := ""
EndIf



oPrint:Say(nLin+350,nCol+1150,"DISCRIMINACAO DOS SERVICOS CONTRADOS:",oFont12n )
  

oPrint:Say(nLin+450,nCol+1150,"No. do(s) Conhecimento(s):",oFont11n )
oPrint:Say(nLin+450,nCol+1550,cNumCtr,oFont11n )

oPrint:Say(nLin+450,nCol+1900,"No. Viagem:",oFont11n )
oPrint:Say(nLin+450,nCol+2100,DTY->DTY_VIAGEM,oFont11n)

oPrint:Say(nLin+500,nCol+1150,"Valor da carga:",oFont11n )
oPrint:Say(nLin+500,nCol+1350,"R$ "+Transform(nValorMerc,"@E 999,999,999.99"),oFont11n )

oPrint:Say(nLin+500,nCol+1800,"Peso:",oFont11n )
oPrint:Say(nLin+500,nCol+1900,Transform(nPesoCarg,"@E 9,999,999.999"),oFont11n )

oPrint:Say(nLin+600,nCol+1150,"Local do carregamento::",oFont11n)
oPrint:Say(nLin+600,nCol+1600,cOrigem,oFont11n )

oPrint:Say(nLin+650,nCol+1150,"Local do Descarregamento::",oFont11n)
oPrint:Say(nLin+650,nCol+1600,cDestino,oFont11n)

//Contratado.
oPrint:Line(nLin+1200,nCol,nLin+1200,nCol+1100) //Linha central contratado.
nLin:=nLin-50
oPrint:Say(nLin+850,nCol+50,"CONTRATADO:",oFont12n)

oPrint:Say(nLin+900,nCol+50,"Nome:",oFont11n)
oPrint:Say(nLin+900,nCol+200,Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_NOME"),oFont11n)

oPrint:Say(nLin+950,nCol+50,"End:",oFont11n)
oPrint:Say(nLin+950,nCol+200,Alltrim(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_END"))+" - "+Alltrim(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_BAIRRO")),oFont11n)

oPrint:Say(nLin+1000,nCol+50,"Tel:",oFont11n)
oPrint:Say(nLin+1000,nCol+200,"("+Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_DDD")+") "+Alltrim(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_TEL")),oFont11n)

oPrint:Say(nLin+1000,nCol+600,"Mun:",oFont11n)
oPrint:Say(nLin+1000,nCol+700,Alltrim(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_MUN")),oFont11n)

oPrint:Say(nLin+1050,nCol+050,"Cep:",oFont11n)
oPrint:Say(nLin+1050,nCol+200,Transform(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_CEP"),"@R 99999-999"),oFont11n)

oPrint:Say(nLin+1050,nCol+400,"UF",oFont11n)
oPrint:Say(nLin+1050,nCol+450,Alltrim(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_EST")),oFont11n)

oPrint:Say(nLin+1050,nCol+600,"Insc. INSS:",oFont11n)
oPrint:Say(nLin+1050,nCol+800,Alltrim(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_N_PIS")),oFont11n)//A2_CODINSS

oPrint:Say(nLin+1100,nCol+50,"CNPJ/CPF:",oFont11n)

If Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_TIPO") == "J"
	oPrint:Say(nLin+1100,nCol+200,Transform(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_CGC"),"@R 99.999.999/9999-99"),oFont11n)
Else
	oPrint:Say(nLin+1100,nCol+200,Transform(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_CGC"),"@R 999.999.999-99"),oFont11n)
EndIf


//Observações:
oPrint:Say(nLin+850,nCol+1150,"Observacoes:",oFont12n )
//Disoria Observações
oPrint:Line(nLin+900,nCol+1100,nLin+900,nTamLin) //Linha divisoria observações.

oPrint:Line(nLin+1600,nCol,nLin+1600,nTamLin) //Linha central Motorista

oPrint:Say(nLin+1250,nCol+50,"MOTORISTA:",oFont12n)

oPrint:Say(nLin+1300,nCol+50,"Nome:",oFont11n)
oPrint:Say(nLin+1300,nCol+200,Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_NOME"),oFont11n)

oPrint:Say(nLin+1350,nCol+50,"End:",oFont11n)
oPrint:Say(nLin+1350,nCol+200,Alltrim(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_END"))+" - "+Alltrim(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_BAIRRO")),oFont11n)

oPrint:Say(nLin+1400,nCol+50,"Tel:",oFont11n)
oPrint:Say(nLin+1400,nCol+200,Alltrim(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_TEL")),oFont11n)

oPrint:Say(nLin+1400,nCol+500,"Mun:",oFont11n)
oPrint:Say(nLin+1400,nCol+600,Alltrim(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_MUN")),oFont11n)

oPrint:Say(nLin+1450,nCol+50,"Cep:",oFont11n)
oPrint:Say(nLin+1450,nCol+200,Transform(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_CEP"),"@R 99999-999"),oFont11n)

oPrint:Say(nLin+1450,nCol+500,"UF:",oFont11n)
oPrint:Say(nLin+1450,nCol+600,Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_EST"),oFont11n)

oPrint:Say(nLin+1450,nCol+800,"CNH:",oFont11n)
oPrint:Say(nLin+1450,nCol+900,Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_NUMCNH"),oFont11n)

oPrint:Say(nLin+1500,nCol+50,"Ident No:",oFont11n)
oPrint:Say(nLin+1500,nCol+200,Alltrim(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_RG")),oFont11n)

oPrint:Say(nLin+1500,nCol+500,"Orgao Exp:",oFont11n)
oPrint:Say(nLin+1500,nCol+700,Alltrim(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_RGORG")),oFont11n)

oPrint:Say(nLin+1550,nCol+50,"CPF:",oFont11n)
oPrint:Say(nLin+1550,nCol+200,Transform(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_CGC"),"@R 999.999.999-99"),oFont11n)

//Valores dos serviços contratados
oPrint:Say(nLin+910,nCol+1150,"Valor dos serviços contratados:",oFont12n)

//Clausulas do contrato
oPrint:Say(nLin+950,nCol+1950,"Clausulas do",oFont12n)
oPrint:Say(nLin+1000,nCol+1950,"Contrato abaixo.",oFont12n)

oPrint:Say(nLin+1150,nCol+1950," De acordo.",oFont12n)
oPrint:Say(nLin+1250,nCol+1930,"__________________",oFont1)
oPrint:Say(nLin+1300,nCol+1950,"Ass.do Contratado.",oFont12n)

oPrint:Say(nLin+1500,nCol+1930,"__________________",oFont1)
oPrint:Say(nLin+1550,nCol+1950,"Ass.do Contratante.",oFont12n)



oPrint:Say(nLin+950,nCol+1400,"Valor",oFont12n)
oPrint:Say(nLin+950,nCol+1700,"Data/Doct",oFont12n)

oPrint:Say(nLin+1000,nCol+1150,"Transportes",oFont1)
oPrint:Say(nLin+1000,nCol+1450,Transform(DTY->DTY_VALFRE,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1050,nCol+1150,"Pedagio",oFont1)
oPrint:Say(nLin+1050,nCol+1450,Transform(DTY->DTY_VALPDG,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1100,nCol+1150,"Diarias",oFont1)
oPrint:Say(nLin+1100,nCol+1450,Transform(0,"@E 999,999.99"),oFont1)

nTotalCr := DTY->DTY_VALFRE+DTY->DTY_VALPDG
oPrint:Say(nLin+1150,nCol+1150,"Total",oFont1)
oPrint:Say(nLin+1150,nCol+1450,Transform(nTotalCr,"@E 999,999.99"),oFont1)

//	oPrint:Say(nLin+1200,nCol+1150,"Adiantamento",oFont1)
//	oPrint:Say(nLin+1200,nCol+1400,"XXXXX:",oFont1)

oPrint:Say(nLin+1250,nCol+1150,"Adiantamento: ",oFont1)
oPrint:Say(nLin+1250,nCol+1450,Transform(DTY->DTY_ADIFRE,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1300,nCol+1150,"Sest/Senat:",oFont1)
oPrint:Say(nLin+1300,nCol+1450,Transform(DTY->DTY_SEST,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1350,nCol+1150,"INSS:",oFont1)
oPrint:Say(nLin+1350,nCol+1450,Transform(DTY->DTY_INSS,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1400,nCol+1150,"Imposto de Renda",oFont1)
oPrint:Say(nLin+1400,nCol+1450,Transform(DTY->DTY_IRRF,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1450,nCol+1150,"Outros",oFont1)
oPrint:Say(nLin+1450,nCol+1450,Transform(0,"@E 999,999.99"),oFont1)//oPrint:Say(nLin+1450,nCol+1450,Transform(DTY->DTY_OUTROS,"@E 999,999.99"),oFont1)

nSaldoFre := nTotalCr - (DTY->DTY_ADIFRE +DTY->DTY_SEST + DTY->DTY_INSS + DTY->DTY_IRRF)//nSaldoFre := nTotalCr - (DTY->DTY_ADIFRE +DTY->DTY_SEST + DTY->DTY_INSS + DTY->DTY_IRRF+DTY->DTY_OUTROS)
oPrint:Say(nLin+1500,nCol+1150,"Saldo de frete",oFont1)
oPrint:Say(nLin+1500,nCol+1450,Transform(nSaldoFre,"@E 999,999.99"),oFont1)

oPrint:Line(nLin+960,nCol+1650,nLin+1600,nCol+1650) //linha vertical apos o valor do serviço contratado.
oPrint:Line(nLin+900,nCol+1900,nLin+1600,nCol+1900) //Linha vertical apo da data do docto

oPrint:Say(nLin+1650,nCol+50,"VEICULO:",oFont12n)

dbSelectArea("DA3")
DA3->( dbSetORder(1) )
DA3->( dbSeek(xFilial("DA3")+DTY->DTY_CODVEI) )

oPrint:Say(nLin+1700,nCol+50,"Marca:",oFont11n)
oPrint:Say(nLin+1700,nCol+250,Posicione("SX5",1,xFilial("SX5")+"M6"+DA3->DA3_MARVEI,"X5_DESCRI"),oFont11n)

oPrint:Say(nLin+1700,nCol+600,"Modelo:",oFont11n)
oPrint:Say(nLin+1700,nCol+750,Alltrim(DA3->DA3_DESC),oFont11n)

oPrint:Say(nLin+1750,nCol+50,"Chassi:",oFont11n)
oPrint:Say(nLin+1750,nCol+250,DA3->DA3_CHASSI,oFont11n)

oPrint:Say(nLin+1750,nCol+600,"Cor:",oFont11n)
oPrint:Say(nLin+1750,nCol+750,Posicione("SX5",1,xFilial("SX5")+"M7"+DA3->DA3_CORVEI,"X5_DESCRI"),oFont11n)

oPrint:Say(nLin+1800,nCol+50,"Placa",oFont11n)
oPrint:Say(nLin+1800,nCol+250,DA3->DA3_PLACA,oFont11n)

oPrint:Say(nLin+1800,nCol+600,"Ano Fab:",oFont11n)
oPrint:Say(nLin+1800,nCol+750,DA3->DA3_ANOFAB,oFont11n)

oPrint:Say(nLin+1850,nCol+50,"Renavam:",oFont11n)
oPrint:Say(nLin+1850,nCol+250,DA3->DA3_RENAVA,oFont11n)

oPrint:Say(nLin+1850,nCol+600,"Placa Semi-Reboque",oFont11n)
oPrint:Say(nLin+1850,nCol+950,"",oFont11n)
                                                        
cTexto1 := Extenso(nSaldoFre)
oPrint:Say(nLin+1650,nCol+1150,"Recebi(emos) da "+Alltrim(SM0->M0_NOMECOM),oFont11n) 
oPrint:Say(nLin+1700,nCol+1150,+", a importancia supra de:",oFont11n)  
oPrint:Say(nLin+1750,nCol+1150,Substr(cTexto1,1,60),oFont11n)   
oPrint:Say(nLin+1800,nCol+1150,Substr(cTexto1,61,100),oFont11n)
oPrint:Say(nLin+1850,nCol+1150,"Ass.do recebedor:______________________________________",oFont10n)


//				CONTRATO DE TRANSPORTE RODOVIÁRIO DE BENS
nLin:=nLin-110
oPrint:Say(nLin+2050,nCol+750,"CONTRATO DE TRANSPORTE RODOVIARIO DE BENS",oFont12n)
oPrint:Say(nLin+2100,nCol+1000,"Condicoes Gerais",oFont12n)
nLin:=nLin-30
oPrint:Say(nLin+2200,nCol+50,"CONTRATO PARTICULAR DE TRANSPORTE RODOVIÁRIO DE BENS (CARGAS) QUE ENTRE SI FAZEM A CONTRATANTE, ",oFont11n)
oPrint:Say(nLin+2250,nCol+50,+Alltrim(SM0->M0_NOMECOM)+" E O CONTRATADO IDENTIFICADO ACIMA DESTE, SOB AS CLAUSULAS E CONDICOES:",oFont11n)
nLin:=nLin-60
oPrint:Line(nLin+2390,nCol+1200,nLin+4000,nCol+1200) //linha vertical para dividir as clausulas do contrato.

oPrint:Say(nLin+2400,nCol+50,"1° - O objetivo do presente contrato e a realização de prestacao dos",oFont10)
oPrint:Say(nLin+2450,nCol+50,"serviços de transporte rodoviario de bens (cargas) dos materiais ",oFont10)
oPrint:Say(nLin+2500,nCol+50,"entregues pela contratante ao contratado ambos identificados ",oFont10)
oPrint:Say(nLin+2550,nCol+50,"acima do presente contrato.",oFont10)

oPrint:Say(nLin+2650,nCol+50,"2° - DAS OBRIGACOES E RESPONSABILIDADES DO CONTRATANTE",oFont11n)
oPrint:Say(nLin+2750,nCol+50,"2.1 - Fornecer ao contratado toda a documentação da mercadoria a ",oFont10)
oPrint:Say(nLin+2800,nCol+50,"ser transportada, bem como a documentação relativa ao transporte, ",oFont10)
oPrint:Say(nLin+2850,nCol+50,"tudo de conformidade com a legislação pertinente em vigor. ",oFont10)
nLin:=nLin-50

oPrint:Say(nLin+3000,nCol+50,"2.2 - Assumir o onus e a responsabilidade do seguro obrigatorio das",oFont10)
oPrint:Say(nLin+3050,nCol+50,"cargas",oFont1)
oPrint:Say(nLin+3150,nCol+50,"2.3 - Efetuar o pagamento contra a apresentacao das vias exigidas,",oFont10)
oPrint:Say(nLin+3200,nCol+50,"do valor liquido constante acima deste, no recibo da quitacao ",oFont10)
oPrint:Say(nLin+3250,nCol+50,"referente a prestação dos serviços contratados.",oFont10)

oPrint:Say(nLin+3350,nCol+50,"3° - DAS OBRIGACOES E RESPONSABILIDADES DO CONTRATADO (A)",oFont10n)
oPrint:Say(nLin+3450,nCol+50,"3.1 - Conservar materiais que lhe sao confiados para o transporte nas ",oFont10)
oPrint:Say(nLin+3500,nCol+50,"mesmas condicoes que recebeu.",oFont10)
nLin:=nLin+50
oPrint:Say(nLin+2400,nCol+1250,"3.2 - Comunicar imediatamente à contratante quaisquer anormalidades  ",oFont10)
oPrint:Say(nLin+2450,nCol+1250,"ocorridas durante o transporte usando para isto os telefones constantes .",oFont10)
oPrint:Say(nLin+2500,nCol+1250,"acima deste.",oFont10)

oPrint:Say(nLin+2600,nCol+1250,"3.3 - Sujeitar-se a concordar com os descontos decorrentes de quebras   ",oFont10)
oPrint:Say(nLin+2650,nCol+1250,"ou avarias com as mercadorias transportadas, bem como com diferença    ",oFont10)
oPrint:Say(nLin+2700,nCol+1250,"de peso faltante na entrega, que exceder aos limites legais,cujos",oFont10)
oPrint:Say(nLin+2750,nCol+1250,"valores serão deduzidos a titulo de redução do frete a pagar.",oFont10)

oPrint:Say(nLin+2850,nCol+1250,"3.4 - Compromisso de receber o saldo constate neste contrato junto a   ",oFont10)
oPrint:Say(nLin+2900,nCol+1250,"matriz, filiais ou postos de abastecimento credenciados, apos a   ",oFont10)
oPrint:Say(nLin+2950,nCol+1250,"entrega da mercadoria ao destinatario, apresentando a via  ",oFont10)
oPrint:Say(nLin+3000,nCol+1250,"comprovante de entrega do conhecimento de transporte.",oFont10)

oPrint:Say(nLin+3100,nCol+1250,"3.5 - Todas as despesas decorrentes dos serviços ora contratos, serao   ",oFont10)
oPrint:Say(nLin+3150,nCol+1250,"por conta e responsabilidade do CONTRATADO, inclusive encargos     ",oFont10)
oPrint:Say(nLin+3200,nCol+1250,"sociais,previdenciarios, manutencao, reparos.",oFont10)

oPrint:Say(nLin+3300,nCol+1250,"4° - Seguir as instrucoes do plano de viagem, parar somente nos   ",oFont10)
oPrint:Say(nLin+3350,nCol+1250,"locais previstos. ",oFont10)
oPrint:Say(nLin+3450,nCol+1250,"5° - E assim, por estarem justos e contratados, firma o presente contrato,    ",oFont10)
oPrint:Say(nLin+3500,nCol+1250,"acima deste,elegendo o foro de Itumbiara, Estado de Goias, ",oFont10)
oPrint:Say(nLin+3550,nCol+1250,"para dirimir as duvidas do mesmo.",oFont10)

oPrint:EndPage()

// 2a Via do Documento
 

nLin := 0                     

nLin := nLin + 100

oPrint:Line(nLin,nCol,nLin,nTamLin) //Borda superior
oPrint:Line(nLin,nCol,nNumLin,nCol) //Borda esquerda
oPrint:Line(nLin,nTamLin,nNumLin,nTamLin) //Borda direita
oPrint:Line(nNumLin,nCol,nNumLin,nTamLin) //Borda inferior

//Inserir o logotipo
oPrint:SayBitmap(nLin+50,nCol+050,aBmp,500,200)//0175,0100

oPrint:Say(nLin+250,nCol+650,"nutratta@nutratta.com.br ",oFont11n )

//Recibo contratante de transporte rodoviario.
oPrint:Say(nLin+50,nCol+1350,"RECIBO / CONTRATO DE TANSPORTE",oFont12n )
oPrint:Say(nLin+100,nCol+1350,"RODOVIARIO DE BENS",oFont12n )

//Box com o Numero ex:004697
oPrint:Line(nLin,nCol+2100,nLin+200,nCol+2100) //Box para numeração da via
oPrint:Line(nLin+200,nCol+2100,nLin+200,nTamLin) //Fechamento do box da numeração da via
oPrint:Say(nLin+050,nCol+2200,"No.",oFont12n )
oPrint:Say(nLin+100,nCol+2125,cNumContr,oFont1 ) //Variavel

oPrint:Say(nLin+200,nCol+650,"Site:www.nutratta.com.br",oFont11n )
oPrint:Line(nLin,nCol+1100,nNumLin,nCol+1100) //Linha divisoria central.Vertical

oPrint:Say(nLin+50,nCol+650,Alltrim(SM0->M0_ENDCOB),oFont11n )
oPrint:Say(nLin+100,nCol+650,"Bairro: "+Alltrim(SM0->M0_BAIRCOB),oFont11n )
oPrint:Say(nLin+150,nCol+650,Alltrim(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB+"  CEP: "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont11n )

//Box com o numero da via
oPrint:Line(nLin+150,nCol+1200,nLin+150,nCol+1550)//Borda superior
oPrint:Line(nLin+150,nCol+1200,nLin+200,nCol+1200)//Borda esquerda
oPrint:Line(nLin+150,nCol+1550,nLin+200,nCol+1550) //Borda direita
oPrint:Line(nLin+200,nCol+1200,nLin+200,nCol+1550) //Borda inferior
oPrint:Say(nLin+155,nCol+1210,"2a Via-Contratado",oFont11n )

//Dados do recebedor
oPrint:Say(nLin+250,nCol+1150,"Resp:",oFont11n )                                            
oPrint:Say(nLin+250,nCol+1260,cUserName,oFont11n )//Variavel

oPrint:Say(nLin+250,nCol+1450,"Data:",oFont1 )
oPrint:Say(nLin+250,nCol+1550,Substr(dtos(DTY->DTY_DATCTC),7,2)+"/"+Substr(dtos(DTY->DTY_DATCTC),5,2)+"/"+Substr(dtos(DTY->DTY_DATCTC),1,4),oFont11n )//Variavel

oPrint:Say(nLin+250,nCol+1700,"RCTRB",oFont11n )
oPrint:Say(nLin+250,nCol+1850,"",oFont11n )//Variavel

oPrint:Line(nLin+300,nCol,nLin+300,nTamLin) //Linha divisoria horizontal

//Dados do contratante.
oPrint:Line(nLin+800,nCol,nLin+800,nTamLin) //Linha divisoria horizontal

oPrint:Say(nLin+350,nCol+50,"CONTRATANTE:",oFont12n )
oPrint:Say(nLin+350,nCol+350,Alltrim(SM0->M0_NOMECOM),oFont12) //vairal SM0
nLin:=nLin+50
oPrint:Say(nLin+400,nCol+50,"MATRIZ:",oFont12n )
oPrint:Say(nLin+450,nCol+50,Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_BAIRCOB)+" - Tel: "+ALLTRIM(SM0->M0_TEL)+" - CEP: "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont11n )  //SM0  RUA+NUMERO+BAIRRO+TELEFONE+CEP+CIDADE+MUNICIPIO+ESTADO+CNPJ+INCEST
oPrint:Say(nLin+500,nCol+50,Alltrim(SM0->M0_CIDCOB)+" / "+SM0->M0_ESTCOB+" - CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFont11n )
oPrint:Say(nLin+550,nCol+50,"Insc.Est.: "+Alltrim(SM0->M0_INSC),oFont11n)


//Discriminação dos serivços prestados

If DTY->DTY_TIPCTC == "1"
	
	nPesoCarg := DTY->DTY_PESO
	
	cAliasDTA := GetNextAlias()
	
	cQuery := "SELECT * FROM "+RetSqlName("DTA")
	cQuery += " WHERE D_E_L_E_T_ <> '*' AND DTA_FILIAL = '"+xFilial("DTA")+"' AND "
	cQuery += " DTA_VIAGEM = '"+cNumViagem+"' "
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasDTA, .T., .T.)
	
	dbSelectArea(cAliasDTA)
	dbGoTop()
	
	cNumCtr     := ""
	nValorMerc  := 0
	cMercadoria := ""
	cOrigem     := ""
	cDestino    := ""
	
	If ! (cAliasDTA)->( Eof() )
		
		While ! (cAliasDTA)->( Eof() )
			
			cNumCtr += (cAliasDTA)->DTA_DOC
			
			dbSelectArea("DT6")
			DT6->( dbSetOrder(1) )
			If DT6->( dbSeek(xFilial("DT6")+(cAliasDTA)->DTA_FILDOC+(cAliasDTA)->DTA_DOC+(cAliasDTA)->DTA_SERIE) )
				
				nValorMerc += DT6->DT6_VALMER
				cOrigem  := Alltrim(Posicione("DUY",1,xFilial("DUY")+DT6->DT6_CDRORI,"DUY_DESCRI"))+"/"+Posicione("DUY",1,xFilial("DUY")+DT6->DT6_CDRORI,"DUY_EST")
				cDestino := Alltrim(Posicione("DUY",1,xFilial("DUY")+DT6->DT6_CDRDES,"DUY_DESCRI"))+"/"+Posicione("DUY",1,xFilial("DUY")+DT6->DT6_CDRDES,"DUY_EST")
				
			EndIF
			
			(cAliasDTA)->( dbSkip() )
			
			If ! (cAliasDTA)->( Eof() )
				cNumCtr += "/"
			EndIF
			
		End
	EndIf
	
	dbSelectArea(cAliasDTA)
	dbCloseArea()
	
	
Else
	
	nPesoCarg   := 0
	cNumCtr     := ""
	nValorMerc  := 0
	cMercadoria := ""
	cOrigem     := ""
	cDestino    := ""
EndIf



oPrint:Say(nLin+350,nCol+1150,"DISCRIMINACAO DOS SERVICOS CONTRADOS:",oFont12n )

oPrint:Say(nLin+450,nCol+1150,"No. do(s) Conhecimento(s):",oFont11n )
oPrint:Say(nLin+450,nCol+1450,cNumCtr,oFont11n )

oPrint:Say(nLin+450,nCol+1800,"No. Viagem:",oFont11n )
oPrint:Say(nLin+450,nCol+2000,DTY->DTY_VIAGEM,oFont11n)

oPrint:Say(nLin+500,nCol+1150,"Valor da carga:",oFont11n )
oPrint:Say(nLin+500,nCol+1350,Transform(nValorMerc,"@E 999,999,999.99"),oFont11n )

oPrint:Say(nLin+500,nCol+1800,"Peso:",oFont11n )
oPrint:Say(nLin+500,nCol+1900,Transform(nPesoCarg,"@E 9,999,999.999"),oFont11n )

oPrint:Say(nLin+600,nCol+1150,"Local do carregamento::",oFont11n)
oPrint:Say(nLin+600,nCol+1600,cOrigem,oFont11n )

oPrint:Say(nLin+650,nCol+1150,"Local do Descarregamento::",oFont11n)
oPrint:Say(nLin+650,nCol+1600,cDestino,oFont11n)

//Contratado.
oPrint:Line(nLin+1200,nCol,nLin+1200,nCol+1100) //Linha central contratado.
nLin:=nLin-50
oPrint:Say(nLin+850,nCol+50,"CONTRATADO:",oFont12n)

oPrint:Say(nLin+900,nCol+50,"Nome:",oFont11n)
oPrint:Say(nLin+900,nCol+200,Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_NOME"),oFont11n)

oPrint:Say(nLin+950,nCol+50,"End:",oFont11n)
oPrint:Say(nLin+950,nCol+200,Alltrim(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_END"))+" - "+Alltrim(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_BAIRRO")),oFont11n)

oPrint:Say(nLin+1000,nCol+50,"Tel:",oFont11n)
oPrint:Say(nLin+1000,nCol+200,"("+Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_DDD")+") "+Alltrim(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_TEL")),oFont11n)

oPrint:Say(nLin+1000,nCol+600,"Mun:",oFont11n)
oPrint:Say(nLin+1000,nCol+700,Alltrim(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_MUN")),oFont11n)

oPrint:Say(nLin+1050,nCol+050,"Cep:",oFont11n)
oPrint:Say(nLin+1050,nCol+200,Transform(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_CEP"),"@R 99999-999"),oFont11n)

oPrint:Say(nLin+1050,nCol+400,"UF",oFont11n)
oPrint:Say(nLin+1050,nCol+450,Alltrim(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_EST")),oFont11n)

oPrint:Say(nLin+1050,nCol+600,"Insc. INSS:",oFont11n)
oPrint:Say(nLin+1050,nCol+800,"",oFont11n)

oPrint:Say(nLin+1100,nCol+50,"CNPJ/CPF:",oFont11n)

If Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_TIPO") == "J"
	oPrint:Say(nLin+1100,nCol+200,Transform(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_CGC"),"@R 99.999.999/9999-99"),oFont11n)
Else
	oPrint:Say(nLin+1100,nCol+200,Transform(Posicione("SA2",1,xFilial("SA2")+DTY->DTY_CODFOR+DTY->DTY_LOJFOR,"A2_CGC"),"@R 999.999.999-99"),oFont11n)
EndIf


//Observações:
oPrint:Say(nLin+850,nCol+1150,"Observacoes:",oFont12n )
//Disoria Observações
oPrint:Line(nLin+900,nCol+1100,nLin+900,nTamLin) //Linha divisoria observações.

oPrint:Line(nLin+1600,nCol,nLin+1600,nTamLin) //Linha central Motorista

oPrint:Say(nLin+1250,nCol+50,"MOTORISTA:",oFont12n)

oPrint:Say(nLin+1300,nCol+50,"Nome:",oFont11n)
oPrint:Say(nLin+1300,nCol+200,Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_NOME"),oFont11n)

oPrint:Say(nLin+1350,nCol+50,"End:",oFont11n)
oPrint:Say(nLin+1350,nCol+200,Alltrim(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_END"))+" - "+Alltrim(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_BAIRRO")),oFont11n)

oPrint:Say(nLin+1400,nCol+50,"Tel:",oFont11n)
oPrint:Say(nLin+1400,nCol+200,Alltrim(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_TEL")),oFont11n)

oPrint:Say(nLin+1400,nCol+500,"Mun:",oFont11n)
oPrint:Say(nLin+1400,nCol+600,Alltrim(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_MUN")),oFont11n)

oPrint:Say(nLin+1450,nCol+50,"Cep:",oFont11n)
oPrint:Say(nLin+1450,nCol+200,Transform(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_CEP"),"@R 99999-999"),oFont11n)

oPrint:Say(nLin+1450,nCol+500,"UF:",oFont11n)
oPrint:Say(nLin+1450,nCol+600,Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_EST"),oFont11n)

oPrint:Say(nLin+1450,nCol+800,"CNH:",oFont11n)
oPrint:Say(nLin+1450,nCol+900,Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_NUMCNH"),oFont11n)

oPrint:Say(nLin+1500,nCol+50,"Ident No:",oFont11n)
oPrint:Say(nLin+1500,nCol+200,Alltrim(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_RG")),oFont11n)

oPrint:Say(nLin+1500,nCol+500,"Orgao Exp:",oFont11n)
oPrint:Say(nLin+1500,nCol+700,Alltrim(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_RGORG")),oFont11n)

oPrint:Say(nLin+1550,nCol+50,"CPF:",oFont11n)
oPrint:Say(nLin+1550,nCol+200,Transform(Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_CGC"),"@R 999.999.999-99"),oFont11n)

//Valores dos serviços contratados
oPrint:Say(nLin+910,nCol+1150,"Valor dos serviços contratados:",oFont12n)

//Clausulas do contrato
oPrint:Say(nLin+950,nCol+1950,"Clausulas do",oFont12n)
oPrint:Say(nLin+1000,nCol+1950,"Contrato abaixo.",oFont12n)

oPrint:Say(nLin+1150,nCol+1950," De acordo.",oFont12n)
oPrint:Say(nLin+1250,nCol+1930,"__________________",oFont1)
oPrint:Say(nLin+1300,nCol+1950,"Ass.do Contratado.",oFont12n)

oPrint:Say(nLin+1500,nCol+1930,"__________________",oFont1)
oPrint:Say(nLin+1550,nCol+1950,"Ass.do Contratante.",oFont12n)



oPrint:Say(nLin+950,nCol+1400,"Valor",oFont12n)
oPrint:Say(nLin+950,nCol+1700,"Data/Doct",oFont12n)

oPrint:Say(nLin+1000,nCol+1150,"Transportes",oFont1)
oPrint:Say(nLin+1000,nCol+1450,Transform(DTY->DTY_VALFRE,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1050,nCol+1150,"Pedagio",oFont1)
oPrint:Say(nLin+1050,nCol+1450,Transform(DTY->DTY_VALPDG,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1100,nCol+1150,"Diarias",oFont1)
oPrint:Say(nLin+1100,nCol+1450,Transform(0,"@E 999,999.99"),oFont1)

nTotalCr := DTY->DTY_VALFRE+DTY->DTY_VALPDG
oPrint:Say(nLin+1150,nCol+1150,"Total",oFont1)
oPrint:Say(nLin+1150,nCol+1450,Transform(nTotalCr,"@E 999,999.99"),oFont1)

//	oPrint:Say(nLin+1200,nCol+1150,"Adiantamento",oFont1)
//	oPrint:Say(nLin+1200,nCol+1400,"XXXXX:",oFont1)

oPrint:Say(nLin+1250,nCol+1150,"Adiantamento: ",oFont1)
oPrint:Say(nLin+1250,nCol+1450,Transform(DTY->DTY_ADIFRE,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1300,nCol+1150,"Sest/Senat:",oFont1)
oPrint:Say(nLin+1300,nCol+1450,Transform(DTY->DTY_SEST,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1350,nCol+1150,"INSS:",oFont1)
oPrint:Say(nLin+1350,nCol+1450,Transform(DTY->DTY_INSS,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1400,nCol+1150,"Imposto de Renda",oFont1)
oPrint:Say(nLin+1400,nCol+1450,Transform(DTY->DTY_IRRF,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1450,nCol+1150,"Outros",oFont1)
oPrint:Say(nLin+1450,nCol+1450,Transform(0,"@E 999,999.99"),oFont1)//oPrint:Say(nLin+1450,nCol+1450,Transform(DTY->DTY_OUTROS,"@E 999,999.99"),oFont1)

nSaldoFre := nTotalCr - (DTY->DTY_ADIFRE +DTY->DTY_SEST + DTY->DTY_INSS + DTY->DTY_IRRF)//nSaldoFre := nTotalCr - (DTY->DTY_ADIFRE +DTY->DTY_SEST + DTY->DTY_INSS + DTY->DTY_IRRF+DTY->DTY_OUTROS)
oPrint:Say(nLin+1500,nCol+1150,"Saldo de frete",oFont1)
oPrint:Say(nLin+1500,nCol+1450,Transform(nSaldoFre,"@E 999,999.99"),oFont1)

oPrint:Line(nLin+960,nCol+1650,nLin+1600,nCol+1650) //linha vertical apos o valor do serviço contratado.
oPrint:Line(nLin+900,nCol+1900,nLin+1600,nCol+1900) //Linha vertical apo da data do docto

oPrint:Say(nLin+1650,nCol+50,"VEICULO:",oFont12n)

dbSelectArea("DA3")
DA3->( dbSetORder(1) )
DA3->( dbSeek(xFilial("DA3")+DTY->DTY_CODVEI) )

oPrint:Say(nLin+1700,nCol+50,"Marca:",oFont11n)
oPrint:Say(nLin+1700,nCol+250,Posicione("SX5",1,xFilial("SX5")+"M6"+DA3->DA3_MARVEI,"X5_DESCRI"),oFont11n)

oPrint:Say(nLin+1700,nCol+600,"Modelo:",oFont11n)
oPrint:Say(nLin+1700,nCol+750,Alltrim(DA3->DA3_DESC),oFont11n)

oPrint:Say(nLin+1750,nCol+50,"Chassi:",oFont11n)
oPrint:Say(nLin+1750,nCol+250,DA3->DA3_CHASSI,oFont11n)

oPrint:Say(nLin+1750,nCol+600,"Cor:",oFont11n)
oPrint:Say(nLin+1750,nCol+750,Posicione("SX5",1,xFilial("SX5")+"M7"+DA3->DA3_CORVEI,"X5_DESCRI"),oFont11n)

oPrint:Say(nLin+1800,nCol+50,"Placa",oFont11n)
oPrint:Say(nLin+1800,nCol+250,DA3->DA3_PLACA,oFont11n)

oPrint:Say(nLin+1800,nCol+600,"Ano Fab:",oFont11n)
oPrint:Say(nLin+1800,nCol+750,DA3->DA3_ANOFAB,oFont11n)

oPrint:Say(nLin+1850,nCol+50,"Renavam:",oFont11n)
oPrint:Say(nLin+1850,nCol+250,DA3->DA3_RENAVA,oFont11n)

oPrint:Say(nLin+1850,nCol+600,"Placa Semi-Reboque",oFont11n)
oPrint:Say(nLin+1850,nCol+950,"",oFont11n)
                                                        
cTexto1 := Extenso(nSaldoFre)
oPrint:Say(nLin+1650,nCol+1150,"Recebi(emos) da "+Alltrim(SM0->M0_NOMECOM)+", a importancia supra de:",oFont11n)   
oPrint:Say(nLin+1750,nCol+1150,cTexto1,oFont11n)   

oPrint:Say(nLin+1850,nCol+1150,"Ass.do recebedor:______________________________________",oFont10n)


//				CONTRATO DE TRANSPORTE RODOVIÁRIO DE BENS
nLin:=nLin-110
oPrint:Say(nLin+2050,nCol+750,"CONTRATO DE TRANSPORTE RODOVIARIO DE BENS",oFont12n)
oPrint:Say(nLin+2100,nCol+1000,"Condicoes Gerais",oFont12n)
nLin:=nLin-30
oPrint:Say(nLin+2200,nCol+50,"CONTRATO PARTICULAR DE TRANSPORTE RODOVIÁRIO DE BENS (CARGAS) QUE ENTRE SI FAZEM A CONTRATANTE, "+Alltrim(SM0->M0_NOMECOM),oFont11n)
oPrint:Say(nLin+2250,nCol+50,"E O CONTRATADO IDENTIFICADO ACIMA DESTE, SOB AS CLAUSULAS E CONDICOES:",oFont11n)
nLin:=nLin-60
oPrint:Line(nLin+2390,nCol+1200,nLin+4000,nCol+1200) //linha vertical para dividir as clausulas do contrato.

oPrint:Say(nLin+2400,nCol+50,"1° - O objetivo do presente contrato e a realização de prestacao dos",oFont10)
oPrint:Say(nLin+2450,nCol+50,"serviços de transporte rodoviario de bens (cargas) dos materiais ",oFont10)
oPrint:Say(nLin+2500,nCol+50,"entregues pela contratante ao contratado ambos identificados ",oFont10)
oPrint:Say(nLin+2550,nCol+50,"acima do presente contrato.",oFont10)

oPrint:Say(nLin+2650,nCol+50,"2° - DAS OBRIGACOES E RESPONSABILIDADES DO CONTRATANTE",oFont11n)
oPrint:Say(nLin+2750,nCol+50,"2.1 - Fornecer ao contratado toda a documentação da mercadoria a ",oFont10)
oPrint:Say(nLin+2800,nCol+50,"ser transportada, bem como a documentação relativa ao transporte, ",oFont10)
oPrint:Say(nLin+2850,nCol+50,"tudo de conformidade com a legislação pertinente em vigor. ",oFont10)
nLin:=nLin-50

oPrint:Say(nLin+3000,nCol+50,"2.2 - Assumir o onus e a responsabilidade do seguro obrigatorio das",oFont10)
oPrint:Say(nLin+3050,nCol+50,"cargas",oFont1)
oPrint:Say(nLin+3150,nCol+50,"2.3 - Efetuar o pagamento contra a apresentacao das vias exigidas,",oFont10)
oPrint:Say(nLin+3200,nCol+50,"do valor liquido constante acima deste, no recibo da quitacao ",oFont10)
oPrint:Say(nLin+3250,nCol+50,"referente a prestação dos serviços contratados.",oFont10)

oPrint:Say(nLin+3350,nCol+50,"3° - DAS OBRIGACOES E RESPONSABILIDADES DO CONTRATADO (A)",oFont10n)
oPrint:Say(nLin+3450,nCol+50,"3.1 - Conservar materiais que lhe sao confiados para o transporte nas ",oFont10)
oPrint:Say(nLin+3500,nCol+50,"mesmas condicoes que recebeu.",oFont10)
nLin:=nLin+50
oPrint:Say(nLin+2400,nCol+1250,"3.2 - Comunicar imediatamente à contratante quaisquer anormalidades  ",oFont10)
oPrint:Say(nLin+2450,nCol+1250,"ocorridas durante o transporte usando para isto os telefones constantes .",oFont10)
oPrint:Say(nLin+2500,nCol+1250,"acima deste.",oFont10)

oPrint:Say(nLin+2600,nCol+1250,"3.3 - Sujeitar-se a concordar com os descontos decorrentes de quebras   ",oFont10)
oPrint:Say(nLin+2650,nCol+1250,"ou avarias com as mercadorias transportadas, bem como com diferença    ",oFont10)
oPrint:Say(nLin+2700,nCol+1250,"de peso faltante na entrega, que exceder aos limites legais,cujos",oFont10)
oPrint:Say(nLin+2750,nCol+1250,"valores serão deduzidos a titulo de redução do frete a pagar.",oFont10)

oPrint:Say(nLin+2850,nCol+1250,"3.4 - Compromisso de receber o saldo constate neste contrato junto a   ",oFont10)
oPrint:Say(nLin+2900,nCol+1250,"matriz, filiais ou postos de abastecimento credenciados, apos a   ",oFont10)
oPrint:Say(nLin+2950,nCol+1250,"entrega da mercadoria ao destinatario, apresentando a via  ",oFont10)
oPrint:Say(nLin+3000,nCol+1250,"comprovante de entrega do conhecimento de transporte.",oFont10)

oPrint:Say(nLin+3100,nCol+1250,"3.5 - Todas as despesas decorrentes dos serviços ora contratos, serao   ",oFont10)
oPrint:Say(nLin+3150,nCol+1250,"por conta e responsabilidade do CONTRATADO, inclusive encargos     ",oFont10)
oPrint:Say(nLin+3200,nCol+1250,"sociais,previdenciarios, manutencao, reparos.",oFont10)

oPrint:Say(nLin+3300,nCol+1250,"4° - Seguir as instrucoes do plano de viagem, parar somente nos   ",oFont10)
oPrint:Say(nLin+3350,nCol+1250,"locais previstos. ",oFont10)
oPrint:Say(nLin+3450,nCol+1250,"5° - E assim, por estarem justos e contratados, firma o presente contrato,    ",oFont10)
oPrint:Say(nLin+3500,nCol+1250,"acima deste,elegendo o foro de Itumbiara, Estado de Goias, ",oFont10)
oPrint:Say(nLin+3550,nCol+1250,"para dirimir as duvidas do mesmo.",oFont10)

oPrint:EndPage()
oPrint:Preview()

Return()

  
