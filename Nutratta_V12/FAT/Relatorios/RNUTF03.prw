#INCLUDE "TOTVS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TBICONN.CH"

/*
+-------------------------------------------------------------------------------------+
| Programa  | RNUTF03    | Desenvolvedor  | Davidson Nutratta    | Data  | 27/10/2017 |
+-----------+------------+----------------+-------------------+-------+---------------+
| Descricao | Relatório de Locais de entrega 										  |
|           | 														                  |
+-----------+-------------------------------------------------------------------------+
| Modulos   | Especifico Logistica Nutratta		     	                                                          |
+-----------+-------------------------------------------------------------------------+
| Processos |                                                                         |
+-----------+-------------------------------------------------------------------------+
|                  Modificacoes desde a construcao inicial                            |
+----------+-------------+------------------------------------------------------------+
| DATA     | PROGRAMADOR | MOTIVO                                                     |
+----------+-------------+------------------------------------------------------------+
|          |             |                                                            |
+----------+-------------+------------------------------------------------------------+
*/

User Function RNUTF03()

Set Century On

***************************************
** VARIAVEIS UTILIZADAS NO RELATORIO **
***************************************
Private lAdjustToLegacy := .T.
Private lDisableSetup   := .T.
Private cDirSpool	  	:= GetMv("MV_RELT")
Private cPerg			:= "RNUTF03"

*******************************************
** OBJETOS PARA TAMANHO E TIPO DE FONTES **
*******************************************
Private oFont02	 := TFont():New("Arial",02,02,,.F.,,,,.T.,.F.)
Private oFont06	 := TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
Private oFont06n := TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
Private oFont08C := TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
Private oFont08CN := TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)
Private oFont07	 := TFont():New("Courier New",07,07,,.F.,,,,.T.,.F.)
Private oFont07n := TFont():New("Courier New",07,07,,.T.,,,,.T.,.F.)
Private oFont07A  := TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)
Private oFont08	 := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
Private oFont08n := TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
Private oFont09	 := TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
Private oFont09n := TFont():New("Arial",09,09,,.T.,,,,.T.,.F.)
Private oFont10	 := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
Private oFont10n := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
Private oFont11	 := TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
Private oFont11n := TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)
Private oFont12	 := TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
Private oFont12n := TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
Private oFont13	 := TFont():New("Arial",13,13,,.F.,,,,.T.,.F.)
Private oFont13n := TFont():New("Arial",13,13,,.T.,,,,.T.,.F.)
Private oFont14	 := TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
Private oFont14n := TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
Private oFont16n := TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
Private oFont18n := TFont():New("Arial",18,18,,.T.,,,,.T.,.F.)
Private oFont22n := TFont():New("Arial",22,22,,.T.,,,,.T.,.F.)
Private oFont34n := TFont():New("Arial",34,34,,.T.,,,,.T.,.F.)

Private oBrush1 := TBrush():New( , CLR_GRAY)

*********************************************
** VARIÁVEIS INICIALIZADAS COMO CONTADORES **
*********************************************
Private nLin	 := 100
Private nMaxLin  := 3300
Private nPagina  := 0
Private nTLinhas := 2350
Private nCol	 := 50

****************************************
** VARIÁVEIS DO CONTEÚDO DO RELATÓRIO **
****************************************
Private cTitulo := "LOCAIS DE ENTREGA"
Private oRel

************************************
** MONTA A RÉGUA DE PROCESSAMENTO **
************************************
If ExistDir(cDirSpool) .Or. MakeDir(cDirSpool) <> 0
	
	//AjustaSX1()
	CreateSX1(cPerg)

	If !Pergunte(cPerg,.T.)
		Return()
	EndIf
	
//	DbSelectArea("SE2")
//	DbSeek(xFilial("SE2")+'SIN22072009    TX ')
	/*
	MV_PAR01 := '000022'
	MV_PAR02 := '000022'
	MV_PAR03 := '1'
	MV_PAR04 := '1'
	MV_PAR05 := '00000001'
	MV_PAR06 := '0001'
	MV_PAR07 := '00000001'
	MV_PAR08 := '0001'
	*/
	fBuscaDoc()
	DbSelectArea("TMP")
	TMP->(DbGoTop())
	If TMP->(!Eof())
	
		Processa({|| fImpRel(),'Gerando...'},'Processando Relatório...')
	
	Else
		Msginfo("Não foi encontrado documentos com os dados informados")
	EndIf
Else
	MsgAlert("O diretório " + Alltrim(cDirSpool) + " não foi encontrado, contacte o departamento de TI!")
EndIf

Return


Static Function fImpRel()
**************************************
** FUNÇÃO DE IMPRESSÃO DO RELATÓRIO **
**************************************
Local aAreaOrc := GetArea()

ProcRegua(8)
IncProc("Preparando a impressão...")
cDirSpool := ""
//dbSelectArea("SCJ")

oRel := FWMSPrinter():New("MC_0101",IMP_PDF,lAdjustToLegacy,cDirSpool,lDisableSetup) //TMSPrinter():New( "Boleto Laser" )//
oRel:SetPortrait()
oRel:SetPaperSize(9)
//oRel:cPathPDF := cDirSpool
	
IncProc("Imprimindo: Selecionando os dados")

fImpCabec()

fImpItem()
//
//fImpRodape()

oRel:Setup()
//oRel:Preview()
oRel:Print()
	
FreeObj(oRel)

RestArea(aAreaOrc)
	
Return

Static Function fImpCabec()
/*****************************************8
** Cabeçalho do Relatório 
**
****************************/
Local xLogoAcol	:= GetSrvProfString('Startpath','') + 'lgrl02' + '.BMP'

IncProc("Imprimindo: Cabeçalho")

oRel:EndPage()   // Finaliza Página
oRel:StartPage()   // Inicia uma nova página

nLin := 100

oRel:Box(nLin,nCol,nLin+200,nCol+500)
oRel:SayBitmap( nLin+10,nCol+10,xLogoAcol,450,180)

//oRel:Box(nLin,nCol+510,nLin+200,nTLinhas)
oRel:FillRect ( {nLin,nCol+510,nLin+200,nTLinhas}, oBrush1, "-2" )
oRel:Say(nLin+125,nCol+700,"LOCAIS DE ENTREGA" ,oFont34n,,CLR_WHITE)

nLin += 210

oRel:Box(nLin,nCol,nLin+090,nCol+1900)
oRel:Say(nLin+40,nCol+10,"Emissão:" ,oFont14n,,CLR_GRAY)
oRel:Say(nLin+80,nCol+10, AllTrim(SM0->M0_CIDENT)+', '+Day2Str(dDataBase)+' de '+ MesExtenso(dDataBase)+ ' de ' +Year2Str(dDataBase),oFont16n)

oRel:Box(nLin,nCol+1910,nLin+090,nTLinhas)
oRel:Say(nLin+40,nCol+1930,"Nota Fiscal:" ,oFont14n,,CLR_GRAY)
oRel:Say(nLin+80,nCol+1930, AllTrim(TMP->D2_DOC),oFont16n)

nLin += 100

oRel:FillRect ( {nLin,nCol,nLin+80,nTLinhas}, oBrush1, "-2" )
oRel:Say(nLin+60,nCol+850,"DADOS DO CLIENTE" ,oFont22n,,CLR_WHITE)

nLin += 90

DbSelectArea("SA1")
SA1->(DbSeek(xFilial("SA1")+TMP->D2_CLIENTE+TMP->D2_LOJA))

oRel:Box(nLin,nCol,nLin+090,nCol+1800)
oRel:Say(nLin+40,nCol+10,"Nome/Razão Social:" ,oFont14n,,CLR_GRAY)
oRel:Say(nLin+80,nCol+10, UPPER(AllTrim(SA1->A1_NOME)),oFont16n)

cMask := Iif(Len(AllTrim(SA1->A1_CGC)) == 11,"@R 999.999.999-99","99.999.999/9999-99")

oRel:Box(nLin,nCol+1800,nLin+090,nTLinhas)
oRel:Say(nLin+40,nCol+1810,"CPF/CNPJ:" ,oFont14n,,CLR_GRAY)
oRel:Say(nLin+80,nCol+1810, AllTrim(Transform(SA1->A1_CGC,cMask)),oFont16n)

oRel:Box(nLin+90,nCol,nLin+180,nCol+1600)
oRel:Say(nLin+130,nCol+10,"Endereço:" ,oFont14n,,CLR_GRAY)
oRel:Say(nLin+170,nCol+10, AllTrim(SA1->A1_END),oFont16n)

oRel:Box(nLin+90,nCol+1600,nLin+180,nTLinhas)
oRel:Say(nLin+130,nCol+1610,"Bairro:" ,oFont14n,,CLR_GRAY)
oRel:Say(nLin+170,nCol+1610, AllTrim(SA1->A1_BAIRRO),oFont16n)

oRel:Box(nLin+180,nCol,nLin+270,nCol+1600)
oRel:Say(nLin+220,nCol+10,"Cidade:" ,oFont14n,,CLR_GRAY)
oRel:Say(nLin+260,nCol+10, AllTrim(SA1->A1_MUN),oFont16n)

oRel:Box(nLin+180,nCol+1600,nLin+270,nCol+1800)
oRel:Say(nLin+220,nCol+1610,"UF:" ,oFont14n,,CLR_GRAY)
oRel:Say(nLin+260,nCol+1610, AllTrim(SA1->A1_EST),oFont16n)

oRel:Box(nLin+180,nCol+1800,nLin+270,nTLinhas)
oRel:Say(nLin+220,nCol+1810,"Cep:" ,oFont14n,,CLR_GRAY)
oRel:Say(nLin+260,nCol+1810, AllTrim(Transform(SA1->A1_CEP,"@R 99.999-999")),oFont16n)

nLin += 280

cTxt1 := "A "+Alltrim(SM0->M0_NOMECOM)+", em conformidade com as Portarias ANP n.o 309 (Gasolina), ANP n.o 310"
cTxt2 := "(Óleo Diesel Automotivo), ambas de 27/12/2001 e ANP n.o 2 (AEHC) de 16/01/2002, transcreve abaixo as informações contidas "
cTxt3 := "nos Boletins de Conformidade, cujos originais encontram-se em poder de nossa filial: "

oRel:Box(nLin,nCol,nLin+250,nTLinhas)
oRel:Say(nLin+40,nCol+10,cTxt1 ,oFont14n,,CLR_GRAY)
oRel:Say(nLin+80,nCol+10,cTxt2 ,oFont14n,,CLR_GRAY)
oRel:Say(nLin+120,nCol+10,cTxt3 ,oFont14n,,CLR_GRAY)
oRel:Say(nLin+170,nCol+10,Alltrim(SM0->M0_ENDENT)+' '+(Alltrim(SM0->M0_COMPENT)) ,oFont16n)
oRel:Say(nLin+220,nCol+10,Alltrim(SM0->M0_BAIRENT)+' - '+Alltrim(SM0->M0_CIDENT)+' - '+Alltrim(SM0->M0_ESTENT) ,oFont16n)

nLin += 260

Return Nil

Static Function fImpItem()
/*************************************************
** Itens do relatório
**
**************/

DbSelectArea("SZF")
SZF->(DbSetOrder(2))
If SZF->(DBSeek(xFilial("SZF")+TMP->D2_EMISSAO+TMP->D2_COD))
	
	oRel:FillRect ( {nLin,nCol,nLin+60,nCol+500}, oBrush1, "-2" )
	oRel:Say(nLin+40,nCol+20,"Produto" ,oFont16n,,CLR_WHITE)
	oRel:FillRect ( {nLin,nCol+510,nLin+60,nCol+800}, oBrush1, "-2" )
	oRel:Say(nLin+40,nCol+525,"N.o Boletim" ,oFont16n,,CLR_WHITE)
	oRel:FillRect ( {nLin,nCol+805,nLin+60,nCol+1100}, oBrush1, "-2" )
	oRel:Say(nLin+40,nCol+825,"Batelada" ,oFont16n,,CLR_WHITE)
	oRel:FillRect ( {nLin,nCol+1106,nLin+60,nCol+1990}, oBrush1, "-2" )
	oRel:Say(nLin+40,nCol+1125,"Técnico" ,oFont16n,,CLR_WHITE)
	oRel:FillRect ( {nLin,nCol+1995,nLin+60,nTLinhas}, oBrush1, "-2" )
	oRel:Say(nLin+40,nCol+2020,"N.o do CRQ" ,oFont16n,,CLR_WHITE)
	
	oRel:Box(nLin+60,nCol,nLin+110,nTLinhas)
	
	oRel:Say(nLin+100,nCol+20,SubStr(AllTrim(Posicione("SB1",1,xFilial("SB1")+TMP->D2_COD,"B1_DESC")),1,22) ,oFont14n)
	oRel:Line(nLin+60,nCol+505,nLin+110,nCol+505)
	oRel:Say(nLin+100,nCol+525,SZF->ZF_BOLETIM ,oFont14n)
	oRel:Line(nLin+60,nCol+805,nLin+110,nCol+805)
	oRel:Say(nLin+100,nCol+825,DtoC(SZF->ZF_DATABAT) ,oFont14n)
	oRel:Line(nLin+60,nCol+1105,nLin+110,nCol+1105)
	oRel:Say(nLin+100,nCol+1125,AllTrim(SZF->ZF_TECNICO) ,oFont14n)
	oRel:Line(nLin+60,nCol+1995,nLin+110,nCol+1995)
	oRel:Say(nLin+100,nCol+2020,AllTrim(SZF->ZF_CRQ) ,oFont14n)
	
	nLin += 150 
	
	oRel:FillRect ( {nLin,nCol,nLin+60,nCol+545}, oBrush1, "-2" )
	oRel:Say(nLin+40,nCol+10,"Ensaios" ,oFont16n,,CLR_WHITE)
	oRel:FillRect ( {nLin,nCol+555,nLin+60,nCol+850}, oBrush1, "-2" )
	oRel:Say(nLin+40,nCol+565,"Resultados" ,oFont16n,,CLR_WHITE)
	oRel:FillRect ( {nLin,nCol+855,nLin+60,nCol+1295}, oBrush1, "-2" )
	oRel:Say(nLin+40,nCol+865,"Especificação ANP" ,oFont16n,,CLR_WHITE)
	oRel:FillRect ( {nLin,nCol+1305,nLin+60,nCol+1795}, oBrush1, "-2" )
	oRel:Say(nLin+40,nCol+1315,"Métodos" ,oFont16n,,CLR_WHITE)
	oRel:FillRect ( {nLin,nCol+1805,nLin+60,nTLinhas}, oBrush1, "-2" )
	oRel:Say(nLin+40,nCol+1815,"Unidades" ,oFont16n,,CLR_WHITE)
	
	nLin += 60
	
	DbSelectArea("SZG")
	If SZG->(DBSeek(xFilial("SZG")+SZF->ZF_BOLETIM+DtoS(SZF->ZF_DATA)))
		
		While SZG->(!Eof()) .And. SZG->ZG_FILIAL+SZG->ZG_BOLETIM+DtoS(SZG->ZG_DATA) == xFilial("SZG")+SZF->ZF_BOLETIM+DtoS(SZF->ZF_DATA)
			
			oRel:Box(nLin,nCol,nLin+50,nTLinhas)
			
			oRel:Say(nLin+40,nCol+20,SubStr(AllTrim(SZG->ZG_ENSAIOS),1,25) ,oFont14n)
			oRel:Line(nLin,nCol+553,nLin+50,nCol+553)
			oRel:Say(nLin+40,nCol+565,SubStr(AllTrim(SZG->ZG_RESULTA),1,13) ,oFont14n)
			oRel:Line(nLin,nCol+858,nLin+50,nCol+858)
			oRel:Say(nLin+40,nCol+865,AllTrim(SZG->ZG_ESPECIF) ,oFont14n)
			oRel:Line(nLin,nCol+1307,nLin+50,nCol+1307)
			oRel:Say(nLin+40,nCol+1305,AllTrim(SZG->ZG_METODOS) ,oFont14n)
			oRel:Line(nLin,nCol+1803,nLin+50,nCol+1803)
			oRel:Say(nLin+40,nCol+1815,AllTrim(SZG->ZG_UNIDADE) ,oFont14n)
			
			nLin += 50
			
			SZG->(DbSkip())
		EndDo
		
	EndIf
	
EndIf

Return

Static Function fBuscaDoc()
/*************************************************
** Busca os documentos de acordo com parâmetros informados
**
**************/

Local cQuery := ""

cQuery := "SELECT * FROM "+RetSqlName("SD2")+" "
cQuery += "WHERE D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery += "AND D2_DOC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "AND D2_SERIE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "AND D2_CLIENTE+D2_LOJA BETWEEN '"+MV_PAR05+MV_PAR06+"' AND '"+MV_PAR07+MV_PAR08+"' "
cQuery += "AND D_E_L_E_T_ <> '*' "

fCloseArea("TMP")

cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMP", .T., .T.)

Return

Static Function CreateSX1(cPerg)            
/**************************************************
** Montagem da pergunta
**
*****************/

Local aHelp   
               
aHelp := {"Informe o Documento Inicial"}
PutSx1(cPerg,"01","Pedido De:"   ,"","","mv_ch1","C",9,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelp)
aHelp := {"Informe o Documento Final"}
PutSx1(cPerg,"02","Pedido Ate:"   ,"","","mv_ch2","C",9,0,0,"G","Eval({|| MV_PAR02 >= MV_PAR01})","","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelp)

aHelp := {"Informe o Cliente Inicial"}
PutSx1(cPerg,"05","Cliente De:"   ,"","","mv_ch5","C",8,0,0,"G","","SA1","","","MV_PAR05","","","","","","","","","","","","","","","","",aHelp)
aHelp := {"Informe a Loja Inicial"}
PutSx1(cPerg,"06","Loja De:"   ,"","","mv_ch6","C",4,0,0,"G","","","","","MV_PAR06","","","","","","","","","","","","","","","","",aHelp)

aHelp := {"Informe o Cliente Final"}
PutSx1(cPerg,"07","Cliente Até:"   ,"","","mv_ch7","C",8,0,0,"G","","SA1","","","MV_PAR07","","","","","","","","","","","","","","","","",aHelp)
aHelp := {"Informe a Loja Final"}
PutSx1(cPerg,"08","Loja Até:"   ,"","","mv_ch8","C",4,0,0,"G","","","","","MV_PAR08","","","","","","","","","","","","","","","","",aHelp)
	                          
Return(Nil)

Static Function fCloseArea(pParTabe)
/***********************************************
* Funcao para verificar se existe tabela e exclui-la
*
****/
	If (Select(pParTabe)!= 0)
		dbSelectArea(pParTabe)
		dbCloseArea()
		If File(pParTabe+GetDBExtension())
			FErase(pParTabe+GetDBExtension())
		EndIf
	EndIf
Return
