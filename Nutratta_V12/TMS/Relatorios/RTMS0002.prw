#INCLUDE "PROTHEUS.CH"
//#INCLUDE "FIVEWIN.CH"
Static __aUserLg := {}


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RTMS0002 ³ Autor ³ Davis Magalhaes       ³ Data ³ 19/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Faturmaneto por Filial no Protheus            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nutratta                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RTMS0002()


Local oReport

Private nRegTmp   := 0
Private cArqTrab  := ""
Private cFornce	  :="" 
Private cLjForn   :=""
Private cNomeFor  :=""
Private cIndTrb1  := Space(08) 	

PRIVATE aColunas  := {}

//If FindFunction("TRepInUse") .And. TRepInUse()
//-- Interface de impressao
oReport := ReportDef()
oReport:PrintDialog()
//Else
//	MATR550R3()
//EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Davis Magalhaes       ³ Data ³18/10/10  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()


Local oReport
Local oSection1
Local oSection2
Local oSection3
Local oSection4
Local oSection5
Local oCell
Local aOrdem := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oReport:= TReport():New("RDIE002","Custos por Obras","RDIE002PR4", {|oReport| ReportPrint(oReport,"RDIE02")},"Relacao de Custos por Obra") //"Relacao de Pedidos de Compras"##"Emissao da Relacao de  Pedidos de Compras."##"Sera solicitado em qual Ordem, qual o Intervalo para"##"a emissao dos pedidos de compras."
oReport:= TReport():New("RTMS0002","Faturamento","RTMS002PR4", {|oReport| ReportPrint(oReport)},"Relacao de Faturamento") //"Relacao de Pedidos de Compras"##"Emissao da Relacao de  Pedidos de Compras."##"Sera solicitado em qual Ordem, qual o Intervalo para"##"a emissao dos pedidos de compras."
oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

// -- Ajustas as Perguntas

AjustaSX1("RTMS002PR4")

//

Pergunte(oReport:uParam,.F.)

//oSection1 := TRSection():New(oReport,"Relacao de Faturamento por Filial",{"SF2","DTC","SE4","DA3","DA4" }) //"Relacao de Pedidos de Compras"
oSection1 := TRSection():New(oReport,"Relacao de Faturamento") //"Relacao de Pedidos de Compras"
oSection1 :SetTotalInLine(.F.)
oSection1 :SetHeaderPage()
oSection1 :SetTotalText("Total Geral") //"Total Geral "


TRCell():New(oSection1,"DEMISSAO"	,"","Data de Emissao"	,"@!"	,15	,/*lPixel*/,{|| dEmissao })
TRCell():New(oSection1,"DSAIDA"  	,"" ,"Data de Saida"	    ,"@!"	    ,15	,/*lPixel*/,{|| dSaida })
TRCell():New(oSection1,"CNUMERO"	,"","Numero CTR(-e)" ,"@!"   ,16	,/*lPixel*/,{|| cNumero })
TRCell():New(oSection1,"CSERIE"	    ,"","Serie CTR(-e)"   ,"@!"   ,15,/*lPixel*/,{|| cSerie })
TRCell():New(oSection1,"CCODPRD"	,"","Cod. Produto"   ,"@!"   ,15,/*lPixel*/,{|| cCodPrd })
TRCell():New(oSection1,"CDESPRD"	,"","Descricao Produto"   ,"@!"   ,45,/*lPixel*/,{|| cDesPrd })
TRCell():New(oSection1,"CCFOP"	    ,"","C.F.O.P"         ,"@!"   ,15,/*lPixel*/,{|| cCFOP  })
TRCell():New(oSection1,"CCIFFOB"	, "","CIF/FOB"  ,"@!"    , 8	,/*lPixel*/,{|| cCifFob })
TRCell():New(oSection1,"CPROTCTE"	,"","Protocolo Autoriz."   ,"@!"   ,25,/*lPixel*/,{|| cProtCTE })
TRCell():New(oSection1,"CCLIENTE"	,"","Cod Devedor"          ,"@!"   ,13,/*lPixel*/,{|| cCliente })
TRCell():New(oSection1,"CLOJACLI"	,"","Loja Dev."            ,"@!"   ,10	,/*lPixel*/,{|| cLojaCli })
TRCell():New(oSection1,"CNOMECLI"	,"","Nome Devedor"          ,"@!"   ,50	,/*lPixel*/,{|| cNomeCli })
TRCell():New(oSection1,"CCNPJCLI"	,"","CNPJ Devedor"         ,"@R 99.999.999/9999-99"   ,25	,/*lPixel*/,{|| cCNPJCli })
TRCell():New(oSection1,"CCLIREM"	,"","Cod Remetente"         ,"@!"   ,18,/*lPixel*/,{|| cCliRem  })
TRCell():New(oSection1,"CLOJREM"	,"","Loja Rem."                  ,"@!"   ,10	,/*lPixel*/,{|| cLojRem  })
TRCell():New(oSection1,"CNOMREM"	,"","Nome Remetente"        ,"@!"   ,50	,/*lPixel*/,{|| cNomRem  })
TRCell():New(oSection1,"CCNPJREM"	,"","CNPJ Remetente"       ,"@R 99.999.999/9999-99"   ,25	,/*lPixel*/,{|| cCNPJRem })
TRCell():New(oSection1,"CMUNREM"	,"","Cidade Remetente"     ,"@!"                      ,25	,/*lPixel*/,{|| cMunRem  })
TRCell():New(oSection1,"CESTREM"	,"","Estado Remetente"     ,"@!"                      ,25	,/*lPixel*/,{|| cEstRem  })
TRCell():New(oSection1,"CCLIDES"	,"","Cod Destinatario"         ,"@!"   ,18,/*lPixel*/,{|| cCliDes  })
TRCell():New(oSection1,"CLOJDES"	,"","Loja Des."                  ,"@!"   ,10	,/*lPixel*/,{|| cLojDes  })
TRCell():New(oSection1,"CNOMDES"	,"","Nome Destinatario"     ,"@!"   ,50	,/*lPixel*/,{|| cNomDes  })
TRCell():New(oSection1,"CCNPJDES"	,"","CNPJ Destinatario"    ,"@R 99.999.999/9999-99"   ,25	,/*lPixel*/,{|| cCNPJDes })
TRCell():New(oSection1,"CMUNDES"	,"","Cidade Destinatario"  ,"@!"                      ,25	,/*lPixel*/,{|| cMunDes  })
TRCell():New(oSection1,"CESTDES"	,"","Estado Destinatario"  ,"@!"                      ,25	,/*lPixel*/,{|| cEstDes  })
TRCell():New(oSection1,"CMOTORISTA"	,"","Motorista"             ,"@!"   ,40	,/*lPixel*/,{|| cMotorista })
TRCell():New(oSection1,"NPESO"	    , "","Peso Mercadoria"       ,"@E 999,999,999.9999"   ,20	,/*lPixel*/,{|| nPeso })
TRCell():New(oSection1,"NVOLUME"    , "","Qtde Volume   "       ,"@E 999,999,999"   ,20	,/*lPixel*/,{|| nVolume })
TRCell():New(oSection1,"CESPVOL"    , "","Espec Volume "       ,"@!"   ,20	,/*lPixel*/,{|| cEspVol })
TRCell():New(oSection1,"NVLRFRETE"	,"","Valor Frete"       ,"@E 999,999,999.99"   ,20	,/*lPixel*/,{|| nVlrFrete })
TRCell():New(oSection1,"NALQICMS"	,"","Aliq ICMS %"       ,"@E 999.99"   ,15	,/*lPixel*/,{|| nAlqICMS })
TRCell():New(oSection1,"NVALICMS"	,"","Valor ICMS "       ,"@E 999,999,999.99"   ,20	,/*lPixel*/,{|| nValICMS })
TRCell():New(oSection1,"CDOCORIG"	,"","Nota do Cliente"       ,"@!"   ,10	,/*lPixel*/,{|| nDocOrig })
TRCell():New(oSection1,"CSERORIG"	,"","Serie NF do Cliente"       ,"@!"   ,3	,/*lPixel*/,{|| nSerOrig })
TRCell():New(oSection1,"NVLNOTAC"	,"","Valor NF do Cliente"       ,"@E 999,999,999.99"  ,20	,/*lPixel*/,{|| nVlNotaC })
TRCell():New(oSection1,"CPLACA"	    ,"","Placa Veiculo"       		,"@!"                           ,8                      	,/*lPixel*/,{|| cPlaca   })
TRCell():New(oSection1,"CODFOR"	    ,"","Codigo"       				,"@!"                           ,8                      	,/*lPixel*/,{|| cCodFor   })
TRCell():New(oSection1,"CFORNE"	    ,"","Fornecedor"       			,"@!"                           ,30                      	,/*lPixel*/,{|| cNomFor   })
TRCell():New(oSection1,"CTPFROTA"	,"","Tipo de Frota"             ,"@!"                           ,30                      ,/*lPixel*/,{|| cTpFrota })
TRCell():New(oSection1,"CVIAGEM"	,"","No. Viagem"          		,"@!"                           ,15                      ,/*lPixel*/,{|| cViagem })
TRCell():New(oSection1,"NVLPAGO"	,"","Vl. Pago Terceiro"          	,"@E 999,999,999.99"     ,20                      ,/*lPixel*/,{|| nVlPago })
TRCell():New(oSection1,"NVLADIFRE"	,"","Adto. Terceiro" 		        ,"@E 999,999,999.99"     ,20                      ,/*lPixel*/,{|| nVlAdiFre })
TRCell():New(oSection1,"NVLSEST"	,"","Desc SEST/SENAT"       		,"@E 999,999,999.99"     ,20                      ,/*lPixel*/,{|| nVlSEST })
TRCell():New(oSection1,"NVLIRRF"	,"","Desc IRRF"     		     	,"@E 999,999,999.99"     ,20                      ,/*lPixel*/,{|| nVlIRRF })
TRCell():New(oSection1,"NVLISS"		,"","Desc ISS" 	    		     	,"@E 999,999,999.99"     ,20                      ,/*lPixel*/,{|| nVlISS })
TRCell():New(oSection1,"NVLINSS"	,"","Desc INSS"     		     	,"@E 999,999,999.99"     ,20                      ,/*lPixel*/,{|| nVlINSS })

//TRFunction():New(oSection1:Cell("NVLBRUTO"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1)
//TRFunction():New(oSection1:Cell("NVLLIQUI"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1)

//TRFunction():New(oSection1:Cell("NVLBRUTO")		,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
//TRFunction():New(oSection1:Cell("NVLLIQUI")		,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

Return(oReport)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Davis Vieira Magalhaes ³ Data ³16.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport) //Static Function ReportPrint(oReport,cAlias)

Local oSection1 := oReport:Section(1)
Local oBreak
Local oTotaliz
Local nTxMoeda	:= 1
Local lFirst    := .F.
Local nRegTemp  := 0


MsAguarde({ ||FGrvTmp() }, "Criando Arquivo de Trabalho...")  //-- Chamada da Funcao de Arquivo Temporarios


oReport:SetTitle( oReport:Title()) // " - POR NUMERO"
//oSection1 :SetTotalText("Total por Filial" ) //"Total dos Itens: "

//oBreak := TRBreak():New(oSection1,oSection1:Cell("CFILOBRA"),"Total por Filial",.f.)				//"Total do Produto"

//oTotaliz := TRFunction():New(oSection:Cell('NVLBRUTO'),Nil,"SUM",oBreak,"Total Item Contabil" /* + ' 2a.U.M.'Titulo*/,,,.F.,.F.,/*Obj*/) //"Qtde. "##"Disponivel   "
//TRFunction():New(oSection1:Cell("NVLRFRETE"), ,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1)
//TRFunction():New(oSection1:Cell("NPESO"), ,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1)
//TRFunction():New(oSection1:Cell("NVLNOTAC"), +,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1)

//TRPosition():New(oSection1,"RDIE02",1,{|| Substr(RDIE02->FILIAL,1,2)+RDIE02->ITEM,DTOS(RDIE02->DT_EMISSAO) })


//MsgStop("Arquivo Temporario: "+cAliasTP1)


dbSelectArea("RTMS02")
dbSetOrder(01)
dbGoTop()

oReport:SetMeter( nRegTMP )
oSection1:Init()



While ! oReport:Cancel() .And. ! RTMS02->( Eof() )
	
	
	If oReport:Cancel()
		
		Exit
		
	EndIf
	
	
	
	oReport:IncMeter()
	

	oSection1:Cell("DEMISSAO"):SetValue(RTMS02->DT_EMISSAO)
	oSection1:Cell("DSAIDA"):SetValue(RTMS02->DT_SAIDA)
	oSection1:Cell("CNUMERO"):SetValue(RTMS02->NUMERO)
	oSection1:Cell("CSERIE"):SetValue(RTMS02->SERIE)
	oSection1:Cell("CCODPRD"):SetValue(RTMS02->CODPRD)
	oSection1:Cell("CDESPRD"):SetValue(RTMS02->DESPRD)
	oSection1:Cell("CCFOP"):SetValue(RTMS02->CFOP)
	oSection1:Cell("CCIFFOB"):SetValue(RTMS02->CIF_FOB)
	oSection1:Cell("CPROTCTE"):SetValue(RTMS02->PROTCTE)
	oSection1:Cell("CCLIENTE"):SetValue(RTMS02->CLIENTE)
	oSection1:Cell("CLOJACLI"):SetValue(RTMS02->LOJA)
	oSection1:Cell("CNOMECLI"):SetValue(RTMS02->NOMECLI)
	oSection1:Cell("CCNPJCLI"):SetValue(RTMS02->CNPJ)
	oSection1:Cell("CCLIREM"):SetValue(RTMS02->CLIREM)
	oSection1:Cell("CLOJREM"):SetValue(RTMS02->LOJREM)
	oSection1:Cell("CNOMREM"):SetValue(RTMS02->NOMREM)
	oSection1:Cell("CCNPJREM"):SetValue(RTMS02->CNPJREM)
	oSection1:Cell("CMUNREM"):SetValue(RTMS02->MUNREM)
	oSection1:Cell("CESTREM"):SetValue(RTMS02->ESTREM)
	oSection1:Cell("CCLIDES"):SetValue(RTMS02->CLIDES)
	oSection1:Cell("CLOJDES"):SetValue(RTMS02->LOJDES)
	oSection1:Cell("CNOMDES"):SetValue(RTMS02->NOMDES)
	oSection1:Cell("CCNPJDES"):SetValue(RTMS02->CNPJDES)
	oSection1:Cell("CMUNDES"):SetValue(RTMS02->MUNDES)
	oSection1:Cell("CESTDES"):SetValue(RTMS02->ESTDES)
	oSection1:Cell("CMOTORISTA"):SetValue(RTMS02->MOTORISTA)
	oSection1:Cell("NPESO"):SetValue(RTMS02->PESO)
	oSection1:Cell("NVOLUME"):SetValue(RTMS02->VOLUME)
	oSection1:Cell("CESPVOL"):SetValue(RTMS02->ESPVOL)	
	oSection1:Cell("NVLRFRETE"):SetValue(RTMS02->VLR_FRETE)
	oSection1:Cell("NALQICMS"):SetValue(RTMS02->ALQICMS)
	oSection1:Cell("NVALICMS"):SetValue(RTMS02->VALICMS)
	oSection1:Cell("CDOCORIG"):SetValue(RTMS02->DOC_ORIG)
	oSection1:Cell("CSERORIG"):SetValue(RTMS02->SER_ORIG)
	oSection1:Cell("NVLNOTAC"):SetValue(RTMS02->VLR_ORIG)
	oSection1:Cell("CPLACA"):SetValue(RTMS02->PLACA)
	oSection1:Cell("CODFOR"):SetValue(RTMS02->CODFOR)
	oSection1:Cell("CFORNE"):SetValue(RTMS02->CFORNE)
	oSection1:Cell("CTPFROTA"):SetValue(RTMS02->TP_FROTA)
	oSection1:Cell("CVIAGEM"):SetValue(RTMS02->VIAGEM)
	oSection1:Cell("NVLPAGO"):SetValue(RTMS02->VLFRETE)
	oSection1:Cell("NVLADIFRE"):SetValue(RTMS02->VLADIFRE)
	oSection1:Cell("NVLSEST"):SetValue(RTMS02->VLSEST)
	oSection1:Cell("NVLIRRF"):SetValue(RTMS02->VLIRRF)
	oSection1:Cell("NVLISS"):SetValue(RTMS02->VLISS)
	oSection1:Cell("NVLINSS"):SetValue(RTMS02->VLINSS)
		
	oSection1:PrintLine()
	
	
	dbSelectArea("RTMS02")
	RTMS02->( dbSkip() )
	
	
	
	
End

//oSecTion1:Print()

oSection1:Finish()

dbSelectArea("RTMS02")
dbCloseArea()


Return NIL



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AjustaSX1 ³ Autor ³ Davis Magalhaes       ³ Data ³18.10.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Monta perguntas no SX1.                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSx1(cPerg)

PutSx1(cPerg,"01","Emissao de  ?"     ," "," ","mv_ch1","D",8,0,0,"G","",""   ,,,"mv_par01")  //"ID do processo"
PutSx1(cPerg,"02","Ate Emissao ?"     ," "," ","mv_ch2","D",8,0,0,"G","! Empty(Mv_Par02) .And. MV_PAR02 >= MV_PAR01",""   ,,,"mv_par02")  //"ID do processo"
PutSx1(cPerg,"03","Documento de ?" ," "," ","mv_ch3","C",9,0,0,"G","","SF2"   ,,,"mv_par03")  //"ID do processo"
PutSx1(cPerg,"04","Ate Documento ?" ," "," ","mv_ch4","C",9,0,0,"G","! Empty(Mv_Par04) .And. MV_PAR04 >= MV_PAR03","SF2"   ,,,"mv_par04")  //"ID do processo"
PutSx1(cPerg,"05","Serie de    ?"     ," "," ","mv_ch5","C",3,0,0,"G","","",,,"mv_par05")  //"Codigo do processo"
PutSx1(cPerg,"06","Ate Serie   ?"     ," "," ","mv_ch6","C",3,0,0,"G","! Empty(Mv_Par06) .And. Mv_Par06 >= Mv_Par05","",,,"mv_par06")  //"Versao do processo"



Return

Static Function FGrvTmp()
*******************************************************************************
*
**

Local cEol   := ""
Local cQuery := ""
Local aStru  := {}
Local cTipoRel := 2
Local aColunas := {}
Local cLisRDPD := "" //Tem todos as verbas deste programa

Local cAliasSF2 := GetNextAlias()
Local cQrySF2   := ""
Local aFrete    := {}
Local nKmRota   := 0
Local cTabela   := ""
Local cViagem   := ""  
Local cUsrName 	:= "" 
Local cNfOrigem  := ""
Local cSerOrig   := ""
Local nVlrOrig	:= 0
Local nPesoDoc	:= 0
Local nQtdVol		:=0			            
Local nValFre		:=0
Local nAdiFre		:=0
Local nSEST		:=0
Local nIRRF		:=0
Local nISS			:=0
Local nINSS		:=0

dbSelectArea("SM0")
nRecno := Recno()
dbGoTop()

cLisRDPD := ""
While ! SM0->(Eof())
	If SM0->M0_CODIGO = cEmpAnt
		AADD(aColunas, { SM0->M0_CODFIL , SM0->M0_FILIAL  } )
		cLisRDPD += If(Empty(cLisRDPD),"'","','")+Alltrim(SM0->M0_CODFIL)
	EndIf
	SM0->(dbSkip())
End
cLisRDPD += "' "

dbSelectArea("SM0")
dbGoto(nRecno)


cQrySF2 := " SELECT * FROM "+RetSqlName("SF2")
cQrySF2 += " WHERE D_E_L_E_T_ <> '*' AND F2_FILIAL = '"+xFilial("SF2")+"' "
cQrySF2 += " AND F2_EMISSAO BETWEEN '"+dToS(Mv_Par01) +"' AND '"+dToS(Mv_Par02)+"'"
cQrySF2 += " AND F2_DOC BETWEEN '"+Mv_Par03 +"' AND '"+Mv_Par04+"'"
cQrySF2 += " AND F2_SERIE BETWEEN '"+Mv_Par05+"' AND '"+Mv_Par06+"'"
cQrySF2 += " AND F2_TIPO IN('N','C') AND  F2_DUPL <> ''"
cQrySF2 += " ORDER BY F2_FILIAL, F2_EMISSAO,  F2_DOC, F2_SERIE"


cQrySF2 := ChangeQuery(cQrySF2)

MemoWrite("RTMS02F.SQL",cQrySF2)

MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySF2),cAliasSF2,.T.,.T.)},"Selecionando Registros..." ) //"Selecionando Registros..."


aStru := {}


aadd(aStru,{"DT_EMISSAO","D" ,08 ,0})
aadd(aStru,{"DT_SAIDA"	,"D" ,08 ,0})
aadd(aStru,{"NUMERO"	,"C" ,09 ,0})
aadd(aStru,{"SERIE"		,"C" ,03 ,0})
aadd(aStru,{"CODPRD"	,"C" ,15 ,0})
aadd(aStru,{"DESPRD"	,"C" ,60 ,0})
aadd(aStru,{"PROTCTE",	 "C" ,25 ,0})
aadd(aStru,{"CFOP",  	 "C" ,05 ,0})
aadd(aStru,{"CIF_FOB"	,"C" ,03 ,0})
aadd(aStru,{"CLIENTE"	,"C" ,06 ,0})
aadd(aStru,{"LOJA"		,"C" ,02 ,0})
aadd(aStru,{"NOMECLI"	,"C" ,40 ,0})
aadd(aStru,{"CNPJ"		,"C" ,20 ,0})
aadd(aStru,{"CLIREM"	,"C" ,06 ,0})
aadd(aStru,{"LOJREM"	,"C" ,02 ,0})
aadd(aStru,{"NOMREM"	,"C" ,40 ,0})
aadd(aStru,{"CNPJREM"	,"C" ,20 ,0})
aadd(aStru,{"CLIDES"	,"C" ,06 ,0})
aadd(aStru,{"LOJDES"	,"C" ,02 ,0})
aadd(aStru,{"NOMDES"	,"C" ,40 ,0})
aadd(aStru,{"CNPJDES"	,"C" ,20 ,0})
aadd(aStru,{"MUNREM"	,"C" ,15 ,0})
aadd(aStru,{"ESTREM"	,"C" ,02 ,0})
aadd(aStru,{"MUNDES"	,"C" ,15 ,0})
aadd(aStru,{"ESTDES"	,"C" ,02 ,0})
aadd(aStru,{"MOTORISTA"	,"C" ,40 ,0})
aadd(aStru,{"PESO"      ,"N" ,17 ,4})
aadd(aStru,{"VOLUME"    ,"N" ,12 ,0})
aadd(aStru,{"ESPVOL"    ,"C" ,10 ,0})
aadd(aStru,{"VLR_FRETE" ,"N" ,14 ,2})
aadd(aStru,{"ALQICMS"   ,"N" ,05 ,2})
aadd(aStru,{"VALICMS"   ,"N" ,14 ,2})
aadd(aStru,{"DOC_ORIG"  ,"C" ,55 ,0})
aadd(aStru,{"SER_ORIG"  ,"C" ,20 ,0})
aadd(aStru,{"VLR_ORIG"  ,"N" ,14 ,2})
aadd(aStru,{"PLACA"     ,"C" ,08 ,0})
aadd(aStru,{"CODFOR"    ,"C" ,15 ,0})
aadd(aStru,{"CFORNE"    ,"C" ,15 ,0})
aadd(aStru,{"TP_FROTA"  ,"C" ,15 ,0})
aadd(aStru,{"VIAGEM"    ,"C" ,06 ,0})
aadd(aStru,{"VLFRETE"   ,"N" ,14 ,2})
aadd(aStru,{"VLADIFRE"  ,"N" ,14 ,2})
aadd(aStru,{"VLSEST"    ,"N" ,14 ,2})                  
aadd(aStru,{"VLIRRF"    ,"N" ,14 ,2})                  
aadd(aStru,{"VLISS"     ,"N" ,14 ,2})                  
aadd(aStru,{"VLINSS"    ,"N" ,14 ,2})


cArqTrab  := CriaTrab(aStru)
//cIndTrb1 := Left(cArqTrab,7)+"A"

dbUseArea(.T.,, cArqTrab, "RTMS02", .F., .F. )

cTrb1	:=  CriaTrab(Nil,.F.)
IndRegua("RTMS02",cTrb1,"DTOS(DT_EMISSAO)+NUMERO+SERIE",,,"Selecionando Registros...")
dbClearIndex()

cTrb2	:=  CriaTrab(Nil,.F.)
IndRegua("RTMS02",cTrb2,"VIAGEM",,,"Selecionando Registros...")
dbClearIndex()

dbSelectArea("RTMS02")
dbSetIndex(cTrb1+OrdBagExt())
dbSetIndex(cTrb2+OrdBagExt())



dbSelectArea(cAliasSF2)
dbGoTop()

While !  (cAliasSF2)->( Eof() )
	
	dbSelectArea("DTC")
	DTC->( dbSetOrder(3) )
	If DTC->( dbSeek( (cAliasSF2)->F2_FILIAL+(cAliasSF2)->F2_FILIAL+(cAliasSF2)->F2_DOC+(cAliasSF2)->F2_SERIE) )
		
		nVlrOrig := 0
		
		cLoteNFC := DTC->DTC_LOTNFC
		cEspecie := DTC->DTC_CODEMB
		
		dbSelectArea("DTP")
		DTP->( dbSetORder(1) )
		DTP->( dbSeek(xFilial("DTP")+cLoteNFC) )
		
		cViagem := DTP->DTP_VIAGEM 
		
		dbSelectArea("DTR")          
		DTR->( dbSetOrder(1) )
		DTR->( dbSeek(xFilial("DTR")+DTC->DTC_FILORI+cViagem) )                   
		                     
		
		dbSelectArea("DUP")          
		DUP->( dbSetOrder(1) )
		DUP->( dbSeek(xFilial("DUP")+DTC->DTC_FILORI+cViagem) )                   
		
		
		dbSelectArea("RTMS02")
		RTMS02->( dbSetORder(2) )
		
		If ! dbSeek(cViagem)
		
			dbSelectArea("DTY")
			DTY->( dbSetOrder(2) )
			If DTY->( dbSeek(xFilial("DTY")+DTP->DTP_FILORI+cViagem) )
		
				nValFre := DTY->DTY_VALFRE
				nValPDG := DTY->DTY_VALPDG
				nAdiFre := DTY->DTY_ADIFRE
				nSEST	:= DTY->DTY_SEST
				nIRRF	:= DTY->DTY_IRRF
				nISS	:= DTY->DTY_ISS
				nINSS	:= DTY->DTY_INSS
				
				
			Else
				nValFre := 0
				nValPDG := 0
				nAdiFre := 0
				nSEST	:= 0
				nIRRF	:= 0
				nISS	:= 0
				nINSS	:= 0
				
			EndIF
		Else
			nValFre := 0
			nValPDG := 0
			nAdiFre := 0
			nSEST	:= 0
			nIRRF	:= 0
			nISS	:= 0
			nINSS	:= 0
		EndIf
		                      
		
		cMotorista := DUP->DUP_CODMOT
		cVeiculo   := DTR->DTR_CODVEI
		
		cCifFob    := Iif(DTC->DTC_TIPFRE = "1","CIF","FOB")
		cCliRem    := DTC->DTC_CLIREM
		cLojRem    := DTC->DTC_LOJREM
		cNomRem    := Posicione("SA1",1,xFilial("SA1")+cCliRem+cLojRem,"A1_NOME")
		cCNPJRem   := Posicione("SA1",1,xFilial("SA1")+cCliRem+cLojRem,"A1_CGC")
		cMunRem    := Posicione("SA1",1,xFilial("SA1")+cCliRem+cLojRem,"A1_MUN")
		cEstRem    := Posicione("SA1",1,xFilial("SA1")+cCliRem+cLojRem,"A1_EST")
		cCliDes    := DTC->DTC_CLIDES
		cLojDes    := DTC->DTC_LOJDES
		cNomDes    := Posicione("SA1",1,xFilial("SA1")+cCliDes+cLojDes,"A1_NOME")
		cCNPJDes   := Posicione("SA1",1,xFilial("SA1")+cCliDes+cLojDes,"A1_CGC")
		cMunDes    := Posicione("SA1",1,xFilial("SA1")+cCliDes+cLojDes,"A1_MUN")
		cEstDes    := Posicione("SA1",1,xFilial("SA1")+cCliDes+cLojDes,"A1_EST")
		cCodProd   := DTC->DTC_CODPRO
		cDescPrd   := Posicione("SB1",1,xFilial("SB1")+DTC->DTC_CODPRO,"B1_DESC")
		
		nPesoDoc   := 0
		nKmTota    := 0
		nQtdVol    := 0
		nPesoM3    := 0
		nMetro3    := 0
		nQtdEixos  := 0
		nNumNFS    := 1
		                                     
		nVlrOrig   := 0
		cNfOrigem  := ""
		cSerOrig   := ""
		
		While ! DTC->( Eof() ) .And. DTC->DTC_FILDOC == (cAliasSF2)->F2_FILIAL .And. DTC->DTC_DOC == (cAliasSF2)->F2_DOC .And. DTC->DTC_SERIE == (cAliasSF2)->F2_SERIE
			
			nVlrOrig   += DTC->DTC_VALOR
			cNfOrigem  += Alltrim(DTC->DTC_NUMNFC)+"/"
			cSerOrig   += Alltrim(DTC->DTC_SERNFC)+"/"
			
			dbSelectArea("DTC")
			DTC->( dbSkip() )
			
		End
	Else
		cMotorista := ""
		cVeiculo   := ""
		cEmbalag   := ""
		cNfOrigem  := ""
		cSerOrig   := ""
		nVlrOrig   := 0
		cCifFob    := ""
		cEspecie   := ""
		cCliRem    := ""
		cLojRem    := ""
		cNomRem    := ""
		cCNPJRem   := ""
		cMunRem    := ""
		cEstRem    := ""
		cNumACT    := ""
		cCliDes    := ""
		cLojDes    := ""
		cNomDes    := ""
		cCNPJDes   := ""
		cMunDes    := ""
		cEstDes    := ""
		cServico   := ""
		cDescSer   := ""
		cCodProd   := ""
		cDescPrd   := ""
		nKmRota    := 0
		
	EndIf
	
	dbSelectArea("DT6")
	DT6->( dbSetOrder(1) )
	If DT6->( dbSeek((cAliasSF2)->(F2_FILIAL+F2_FILIAL+F2_DOC+F2_SERIE)) )
	
		cProtCTe 	 := DT6->DT6_PROCTE	
		nPesoDoc     := DT6->DT6_PESO
		nKmTota      := 0
		nQtdVol      := DT6->DT6_QTDVOL
		nPesoM3      := DT6->DT6_PESOM3                                                                          
		nMetro3      := DT6->DT6_METRO3
		nQtdEixos    := 0
		
	Else
		cProtCte := ""
		cViagem  := ""        
		cUserDT6 := ""
		nPesoDoc := 0
	EndIF
	
	
	
	dbSelectArea("SD2")
	SD2->( dbSetOrder(3) )
	If SD2->( dbSeek((cAliasSF2)->F2_FILIAL+(cAliasSF2)->F2_DOC+(cAliasSF2)->F2_SERIE+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA) )
		cCFOP 	 := SD2->D2_CF
		nAlqICMS := SD2->D2_PICM
		nValICMS := SD2->D2_VALICM
	Else
		cCFOP    := ""
		nAlqICMS := 0
		nValICMS := 0
	EndIf
	
	dbSelectArea("DA3")
	DA3->( dbsetOrder(1) )
	If DA3->( dbSeek(xFilial("DA3")+cVeiculo) )
		
		//Fornecedor do Transporte.
		cFornce:=DA3->DA3_CODFOR 
		cLjForn:=DA3->DA3_LOJFOR
		
		If DA3->DA3_FROVEI == "1"
			cTipoFrota := "Propria"
		ElseIf DA3->DA3_FROVEI == "2"
			cTipoFrota := "Agregado"
		Else
			cTipoFrota := "Terceiro"
		EndIf
	Else
		cTipoFrota := ""
	EndIf   
	
	//Cadastro de Fornecedores
	dbSelectArea("SA2")
	SA2->( dbsetOrder(1) )
	If SA2->( dbSeek(xFilial("SA2")+Padr(cFornce,8)+Padr(cLjForn,4)))
   		
   		cNomeFor := Alltrim(SA2->A2_NOME)
	EndIf
	
	dbSelectArea("RTMS02")
	
	RecLock("RTMS02",.T.)
	
	nPosItem		:= aScan( aColunas, { |x| Alltrim(x[1])==Alltrim((cAliasSF2)->F2_FILIAL)  } )
	
	Replace DT_EMISSAO 	With sToD((cAliasSF2)->F2_EMISSAO) ,;
			DT_SAIDA    With sToD((cAliasSF2)->F2_EMISSAO) ,;
			NUMERO	    With (cAliasSF2)->F2_DOC ,;
			SERIE       With (cAliasSF2)->F2_SERIE ,;
			CIF_FOB     With cCifFob  ,;
			CLIENTE     With (cAliasSF2)->F2_CLIENTE ,;
			LOJA        With (cAliasSF2)->F2_LOJA ,;
			NOMECLI     With POSICIONE("SA1",1,xFilial("SA1")+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA,"A1_NOME"),;
			CNPJ        With POSICIONE("SA1",1,xFilial("SA1")+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA,"A1_CGC"),;
			CLIREM      With cCliRem ,;
			LOJREM      With cLojRem ,;
			CFOP        With cCFOP ,;
			CODPRD		With cCodProd ,;
			DESPRD      With cDescPrd ,;
			NOMREM      With cNomRem ,;
			CNPJREM     With cCNPJRem ,;
			MUNREM      With cMunRem ,;
			ESTREM      With cEstRem ,;
			CLIDES      With cCliDes ,;
			LOJDES      With cLojDes ,;
			NOMDES      With cNomDes ,;
			CNPJDES     With cCNPJDes ,;
			MUNDES      With cMunDes ,;
			ESTDES      With cEstDes ,;
			MOTORISTA   With Posicione("DA4",1,xFilial("DA4")+cMotorista,"DA4_NOME"), ;
			PESO        With nPesoDoc ,;
			VOLUME		 With nQtdVol,;
			ESPVOL		 With cEspecie ,;
			VLR_FRETE   With (cAliasSF2)->F2_VALBRUT ,;
			DOC_ORIG    With cNfOrigem ,;
			SER_ORIG    With cSerOrig ,;
			VLR_ORIG    With nVlrOrig ,;
			PROTCTE     With cProtCTe ,;
			ALQICMS     With nAlqICMS ,;
			VALICMS     With nValICMS ,;
			PLACA       With Posicione("DA3",1,xFilial("DA3")+cVeiculo,"DA3_PLACA")  ,;
			CODFOR		With cFornce ,;	
			CFORNE		With cNomeFor ,;	
			TP_FROTA    With cTipoFrota ,;
			VIAGEM      With cViagem ,;
			VLFRETE		With nValFre ,;
			VLADIFRE	With nAdiFre ,;
			VLSEST		With nSEST   ,;
			VLIRRF		With nIRRF ,;
			VLISS		With nISS  ,;
			VLINSS		With nINSS  
	
	
	
	RTMS02->( MsUnlock() )
	
	nRegTMP++
	
	
	dbSelectArea(cAliasSF2)
	(cAliasSF2)->(dbSkip())
	
Enddo


dbSelectArea(cAliasSF2)
dbCloseArea()



dbSelectArea("RTMS02")
dbSetOrder(1)
dbGoTop()



Return
