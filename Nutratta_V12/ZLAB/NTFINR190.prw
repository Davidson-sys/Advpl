#INCLUDE "FINR190.CH"
#Include "PROTHEUS.Ch"

Static lFWCodFil := .T.
STATIC lUnidNeg	:= Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
Static _oFINR190
Static __lTemFKD := .F.
Static oTemBXCanc := FWPreparedStatement():New('')	//	Objeto para consultas escalares

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR190  ³ Autor ³ Adrianne Furtado      ³ Data ³ 02.09.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡„o das baixas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³Sintaxe   ³ FINR190(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß                                        
/*/
User Function NTFINR190()

Local oReport			:= Nil   
Private cChaveInterFun	:= ""
__lTemFKD := TableInDic('FKD')

/* GESTAO - inicio */
Private aSelFil	:= {}
/* GESTAO - fim */

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDef()
oReport:PrintDialog()

If !EMPTY(oTemBXCanc)
	oTemBXCanc:Destroy()
	oTemBXCanc := NIL
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Nereu Humberto Junior  ³ Data ³16.05.2006³±±
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

Local oReport	:= Nil
Local oSection	:= Nil
Local oCell		:= Nil        
Local nPlus		:= 0  
Local oBaixas	:= Nil
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
oReport := TReport():New("NTFINR190",STR0009,"NT190", {|oReport| ReportPrint(oReport)},STR0006+" "+STR0007+" "+STR0008) //"Relacao de Amarracao Grupo x Fornecedor"##"Este programa tem como objetivo , relacionar os Grupos e seus"##"respectivos Fornecedores."

Pergunte("NT190",.F.)
oReport:SetLandScape()

/* GESTAO - inicio */
oReport:SetUseGC(.F.) 
oReport:SetGCVPerg( .F. )
/* GESTAO - fim */ 

oBaixas := TRSection():New(oReport,STR0072,{"SE5","SED"},{STR0001,STR0002,STR0003,STR0004,STR0032,STR0005,STR0036,STR0048}) //"Baixas"
// ORDEM:
/*"Por Data" "Por Banco" "Por Natureza" "Alfabetica"
"Nro. Titulo" "Dt.Digitacao" " Por Lote" "Por Data de Credito"*/

oBaixas:SetTotalInLine(.F.)

TRCell():New(oBaixas,"E5_PREFIXO"	,, STR0049,,TamSx3("E5_PREFIXO")[1], .F.)	//"Prf"

If "PTG/MEX" $ cPaisLoc
	TRCell():New(oBaixas,"E5_NUMERO" 	,, STR0050,,TamSx3("E5_NUMERO")[1]+18,.F.)	//"Numero"
Else
	TRCell():New(oBaixas,"E5_NUMERO" 	,, STR0050,,TamSx3("E5_NUMERO")[1]+2,.F.)	//"Numero"
Endif

If cPaisLoc == "BRA"
	nPlus := 5
Else
	nPlus := 3
Endif
TRCell():New(oBaixas,"E5_PARCELA"	,, STR0051,,TamSx3("E5_PARCELA")[1]		, .F.							) //"Prc"
TRCell():New(oBaixas,"E5_TIPODOC"	,, STR0052,,TamSx3("E5_TIPODOC")[1]		, .F.							) //"TP"
TRCell():New(oBaixas,"E5_CLIFOR"	,, STR0053,,TamSx3("E5_CLIFOR")[1]		, .F.							) //"Cli/For"
TRCell():New(oBaixas,"NOME CLI/FOR"	,, STR0054,,15							, .F.							) //"Nome Cli/For"
TRCell():New(oBaixas,"E5_NATUREZ"	,, STR0055,,11							, .F.							) //"Natureza"
TRCell():New(oBaixas,"E5_VENCTO"	,, STR0056,,TamSx3("E5_VENCTO")[1]		, .F.							) //"Vencto"
TRCell():New(oBaixas,"E5_HISTOR"	,, STR0057,,TamSx3("E5_HISTOR")[1]/2+1	, .F.,,,.T.						) //"Historico"
TRCell():New(oBaixas,"E5_DATA"		,, STR0058,,TamSx3("E5_DATA")[1] + 1	, .F.							) //"Dt Baixa"
TRCell():New(oBaixas,"E5_VALOR"		,, STR0059,,TamSX3("E5_VALOR")[1]+nPlus	,/*[lPixel]*/,,"RIGHT",,"RIGHT"	) //"Valor Original"
TRCell():New(oBaixas,"JUROS/MULTA"	,, STR0060,,TamSX3("E5_VLJUROS")[1]		,/*[lPixel]*/,,"RIGHT",,"RIGHT"	) //"Jur/Multa"
TRCell():New(oBaixas,"CORRECAO"		,, STR0061,,TamSX3("E5_VLCORRE")[1]		,/*[lPixel]*/,,"RIGHT",,"RIGHT"	) //"Correcao"
TRCell():New(oBaixas,"DESCONTO"		,, STR0062,,TamSX3("E5_VLDESCO")[1]		,/*[lPixel]*/,,"RIGHT",,"RIGHT"	) //"Descontos"
TRCell():New(oBaixas,"ABATIMENTO"	,, STR0063,,TamSX3("E5_VLDESCO")[1]		,/*[lPixel]*/,,"RIGHT",,"RIGHT"	) //"Abatim."
TRCell():New(oBaixas,"IMPOSTOS"		,, STR0064,,TamSX3("E5_VALOR")[1]		,/*[lPixel]*/,,"RIGHT",,"RIGHT"	) //"Impostos"
If __lTemFKD 
	TRCell():New(oBaixas,"VALACESS"	,, STR0079,,TamSX3("FKD_VLCALC")[1]		,/*[lPixel]*/,,"RIGHT",,"RIGHT"	) //"Valor Acessório"
EndIf
TRCell():New(oBaixas,"E5_VALORPG"	,, STR0065,,TamSX3("E5_VALOR")[1]+nPlus	,/*[lPixel]*/,,"RIGHT",,"RIGHT"	) //"Total Baixado"
TRCell():New(oBaixas,"E5_BANCO"		,, STR0066,,TamSX3("E5_BANCO")[1]+1		,.F.							) //"Bco"
TRCell():New(oBaixas,"E5_DTDIGIT"	,, STR0067,,10							,.F.							) //"Dt Dig."
TRCell():New(oBaixas,"E5_MOTBX"		,, STR0068,,3							,.F.							) //"Mot"
TRCell():New(oBaixas,"E5_ORIG"		,, STR0069,,FWSizeFilial()+2			,.F.							) //"Orig"

oBaixas:SetNoFilter({"SED"})

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Nereu Humberto Junior  ³ Data ³16.05.2006³±±
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
Static Function ReportPrint(oReport)
Local oBaixas		:= oReport:Section(1)
Local nOrdem		:= oReport:Section(1):GetOrder() 
Local cAliasSE5		:= "SE5"
Local cTitulo		:= "" 
Local cSuf			:= LTrim(Str(mv_par12))
Local cMoeda		:= GetMv("MV_MOEDA"+cSuf)     
Local cCondicao		:= "" 
Local cCond1		:= ""
Local cChave		:= ""
Local bFirst
Local oBreak1		:= Nil 
Local oBreak2		:= Nil
Local nDecs			:= GetMv("MV_CENT"+(IIF(mv_par12 > 1 , STR(mv_par12,1),""))) 
Local cAnterior		:= ""	
Local cAnt			:= ""
Local aRelat		:= {}	   
Local nI			:= 1           
Local lVarFil		:= (mv_par17 == 1 .and. SM0->(Reccount()) >= 1	) // Cons filiais abaixo //Alterado para quando houver 1 filial ou mais
Local nTotBaixado	:= 0                 
Local aTotais		:= {}
Local cTotText		:= ""    
Local nGerOrig		:= 0
Local nRegSM0		:= SM0->(Recno())
Local nRegSE5		:= SE5->(Recno())
Local nJ			:= 1
Private cNomeArq

cFilterUser := oBaixas:GetAdvplExp("SE5")

/* GESTAO - inicio */
If MV_PAR40 == 1
	If Empty(aSelFil)
	aSelFil := AdmGetFil(.F.,.F.,"SE5")
		If Empty(aSelFil)
		   Aadd(aSelFil,cFilAnt)
		Endif
	Endif
Else
	Aadd(aSelFil,cFilAnt)
Endif

lVarFil := Len(aSelFil) >= 1 //Alterado para quando houver 1 filial ou mais

/* GESTAO - fim */

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par11 == 1
	cTitulo := STR0011 + cMoeda  //"Relacao dos Titulos Recebidos em "
Else
	cTitulo := STR0013 + cMoeda  //"Relacao dos Titulos Pagos em "
EndIf

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³aRelat[x][01]: Prefixo			³
//³         [02]: Numero 			³
//³         [03]: Parcela			³
//³         [04]: Tipo do Documento	³
//³         [05]: Cod Cliente/Fornec³
//³         [06]: Nome Cli/Fornec	³
//³         [07]: Natureza         	³
//³         [08]: Vencimento       	³
//³         [09]: Historico       	³
//³         [10]: Data de Baixa    	³
//³         [11]: Valor Original   	³
//³         [12]: Jur/Multa        	³
//³         [13]: Correcao         	³
//³         [14]: Descontos        	³
//³         [15]: Abatimento       	³
//³         [16]: Impostos         	³
//³         [17]: Total Pago       	³
//³         [18]: Banco            	³
//³         [19]: Data Digitacao   	³
//³         [20]: Motivo           	³
//³         [21]: Filial de Origem 	³
//³         [22]: Filial            ³      
//³         [23]: E5_BENEF - cCliFor³
//³         [24]: E5_LOTE          	³ 
//³         [25]: E5_DTDISPO        ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

aRelat := FA190ImpR4(nOrdem,@aTotais,oReport,@nGerOrig)

If Len(aRelat) = 0
	Return Nil
EndIf

Do Case
Case nOrdem == 1
	nCond1  := 10
	cTitulo += STR0015  //" por data de pagamento"
Case nOrdem == 2
	nCond1  := 18
	cTitulo += STR0016 // " por Banco"
Case nOrdem == 3
	nCond1  := 7
	cTitulo += STR0017  //" por Natureza"
Case nOrdem == 4
	nCond1  := 23 //E5_BENEF   
	cTitulo += STR0020  //" Alfabetica"
Case nOrdem == 5
	nCond1  := 2
	cTitulo += STR0035 //" Nro. dos Titulos"
Case nOrdem == 6	//Ordem 6 (Digitacao)
	nCond1  := 19
	cTitulo += STR0019  //" Por Data de Digitacao"
Case nOrdem == 7 // por Lote
	nCond1  := 24	//"E5_LOTE"
	cTitulo += STR0036  //" por Lote"
OtherWise						// Data de Crédito (dtdispo)
	nCond1  := 25	//"E5_DTDISPO"
	cTitulo += STR0015  //" por data de pagamento"
EndCase

If !Empty(mv_par28) .And. ! ";" $ mv_par28 .And. Len(AllTrim(mv_par28)) > 3
	ApMsgAlert(STR0073)//"Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres"
	Return(Nil)
Endif	
If !Empty(mv_par29) .And. ! ";" $ mv_par29 .And. Len(AllTrim(mv_par29)) > 3
	ApMsgAlert(STR0074)//"Separe os tipos que não deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres"
	Return(Nil)
Endif	

//Validacao no array para que seus tipos nao gerem error log
//no exec block em TrPosition()
aEval(aRelat, {|e| Iif( e[5] == Nil, e[5] := "", .T. )} )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo TrPosition()                                                     ³
//³                                                                        ³
//³Posiciona em um registro de uma outra tabela. O posicionamento será     ³
//³realizado antes da impressao de cada linha do relatório.                ³
//³                                                                        ³
//³                                                                        ³
//³ExpO1 : Objeto Report da Secao                                          ³
//³ExpC2 : Alias da Tabela                                                 ³
//³ExpX3 : Ordem ou NickName de pesquisa                                   ³
//³ExpX4 : String ou Bloco de código para pesquisa. A string será macroexe-³
//³        cutada.                                                         ³
//³                                                                        ³				
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oBaixas,"SED",1,{|| xFilial("SED")+SE5->E5_NATUREZ })
//**************************************************
// Bloco comentado pela chave do SE5 utilizada não *
// esta completa. Este sendo utilizado o nRecSe5.  *
//**************************************************
//If !((MV_MULNATR .and. mv_par11 = 1 .and. mv_par38 = 2 .and. !mv_par39 == 2) .or. (MV_MULNATP .and. mv_par11 = 2 .and. mv_par38 = 2 .and. !mv_par39 == 2) )
//	TRPosition():New(oBaixas,"SE5",7,{|| xFilial("SE5") + aRelat[nI,01]+ aRelat[nI,02]+ aRelat[nI,03]+ aRelat[nI,04]+ aRelat[nI,05]})
//EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oBaixas:Cell("E5_PREFIXO")	:SetBlock( { || aRelat[nI,01] } )
oBaixas:Cell("E5_NUMERO")	:SetBlock( { || aRelat[nI,02] } )
oBaixas:Cell("E5_PARCELA")	:SetBlock( { || aRelat[nI,03] } )
oBaixas:Cell("E5_TIPODOC")	:SetBlock( { || aRelat[nI,04] } )
oBaixas:Cell("E5_CLIFOR")	:SetBlock( { || aRelat[nI,05] } )
oBaixas:Cell("NOME CLI/FOR"):SetBlock( { || aRelat[nI,06] } )
oBaixas:Cell("E5_NATUREZ")	:SetBlock( { || aRelat[nI,07] } )
oBaixas:Cell("E5_VENCTO")	:SetBlock( { || aRelat[nI,08] } )
oBaixas:Cell("E5_HISTOR")	:SetBlock( { || aRelat[nI,09] } )
oBaixas:Cell("E5_DATA")		:SetBlock( { || aRelat[nI,10] } )
oBaixas:Cell("E5_VALOR")	:SetBlock( { || aRelat[nI,11] } )
oBaixas:Cell("JUROS/MULTA")	:SetBlock( { || aRelat[nI,12] } )
oBaixas:Cell("CORRECAO")	:SetBlock( { || aRelat[nI,13] } )
oBaixas:Cell("DESCONTO")	:SetBlock( { || aRelat[nI,14] } )
oBaixas:Cell("ABATIMENTO")	:SetBlock( { || aRelat[nI,15] } )
oBaixas:Cell("IMPOSTOS")	:SetBlock( { || aRelat[nI,16] } )
If __lTemFKD 
	oBaixas:Cell("VALACESS"):SetBlock( { ||IIf(ExistFunc('FxLoadFK6'),FxLoadFK6("FK1",SE5->E5_IDORIG, "VA")[1][2],0)})
EndIf
oBaixas:Cell("E5_VALORPG")	:SetBlock( { || aRelat[nI,17] } )
oBaixas:Cell("E5_BANCO")	:SetBlock( { || aRelat[nI,18] } )
oBaixas:Cell("E5_DTDIGIT")	:SetBlock( { || aRelat[nI,19] } )
oBaixas:Cell("E5_MOTBX")	:SetBlock( { || aRelat[nI,20] } )
oBaixas:Cell("E5_ORIG")		:SetBlock( { || aRelat[nI,21] } )

oBaixas:SetHeaderPage()    

	If (nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8)
		oBreak1 := TRBreak():New( oBaixas, { || aRelat[nI][22]+DToS(aRelat[nI][nCond1]) }, STR0071) //"Sub Total"
		oBreak1:SetTotalText({ || cTotText })	 //"Sub Total"             
	Else //nOrdem == 2 .or. nOrdem == 3 .or. nOrdem == 4 .or. nOrdem == 5 .or. nOrdem == 7
		oBreak1 := TRBreak():New( oBaixas, { || aRelat[nI][22]+aRelat[nI][nCond1] }, STR0071) //"Sub Total"
		oBreak1:SetTotalText({ || cTotText })	 //"Sub Total"
	EndIf	
	
//             New(<oParent>					, [cID]	, <cFunction>, [oBreak], [cTitle], [cPicture], [uFormula], [lEndSection], [lEndReport]) --> NIL
TRFunction():New(oBaixas:Cell("E5_VALOR")		,/*cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("E5_VALOR"):nSize,nDecs)		, {|| If(aRelat[nI,26],aRelat[nI,11],0)}	, .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("JUROS/MULTA")	,/*cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("JUROS/MULTA"):nSize,nDecs)	, /*[ uFormula ]*/		, .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("CORRECAO")		,/*cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("CORRECAO"):nSize,nDecs)		, /*[ uFormula ]*/		, .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("DESCONTO")		,/*cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("DESCONTO"):nSize,nDecs)		, /*[ uFormula ]*/		, .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("ABATIMENTO")		,/*cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("ABATIMENTO"):nSize,nDecs)	, /*[ uFormula ]*/		, .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("IMPOSTOS")		,/*cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("IMPOSTOS"):nSize,nDecs)		, /*[ uFormula ]*/		, .F., .F.,.F.) //"Sub Total"
If __lTemFKD 
	TRFunction():New(oBaixas:Cell("VALACESS")	,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("VALACESS"):nSize,nDecs)		, /*[ uFormula ]*/		, .F., .F.,.F.) //"Sub Total"
EndIf
TRFunction():New(oBaixas:Cell("E5_VALORPG")		,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("E5_VALORPG"):nSize,nDecs)	, {|| aRelat[nI][27]}	, .F., .F.,.F.) //"Sub Total"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprimir TOTAL por filial somente quan-³
//³ do houver 1 filial ou mais.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lVarFil .And. !Empty(FWxFilial("SE5"))
	oBreak2 := TRBreak():New( oBaixas, { || aRelat[nI][22] }, STR0070) //"FILIAL"
	TRFunction():New(oBaixas:Cell("E5_VALOR")		,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("E5_VALOR"):nSize,nDecs)		, {|| If(aRelat[nI,26],aRelat[nI,11],0)}	, .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("JUROS/MULTA")	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("JUROS/MULTA"):nSize,nDecs)	, /*[ uFormula ]*/		, .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("CORRECAO")		,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("CORRECAO"):nSize,nDecs)		, /*[ uFormula ]*/		, .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("DESCONTO")		,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("DESCONTO"):nSize,nDecs)		, /*[ uFormula ]*/		, .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("ABATIMENTO")		,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("ABATIMENTO"):nSize,nDecs)	, /*[ uFormula ]*/		, .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("IMPOSTOS")		,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("IMPOSTOS"):nSize,nDecs)		, /*[ uFormula ]*/		, .F., .F.) //"FILIAL"
	If __lTemFKD 
		TRFunction():New(oBaixas:Cell("VALACESS")	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("VALACESS"):nSize,nDecs)		, /*[ uFormula ]*/		, .F., .F.) //"FILIAL"
	EndIf
	TRFunction():New(oBaixas:Cell("E5_VALORPG")		,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("E5_VALORPG"):nSize,nDecs)	, {|| aRelat[nI][27]}	, .F., .F.) //"FILIAL"
	oBreak2:SetTotalText({ || STR0070 + " : " + cTxtFil })	 //"FILIAL"
EndIf

oBaixas:Cell("E5_VALOR"):SetPicture(tm(E5_VALOR,oBaixas:Cell("E5_VALOR"):nSize,nDecs))
oBaixas:Cell("JUROS/MULTA"):SetPicture(tm(E5_VALOR,oBaixas:Cell("JUROS/MULTA"):nSize,nDecs))
oBaixas:Cell("CORRECAO"):SetPicture(tm(E5_VALOR,oBaixas:Cell("CORRECAO"):nSize,nDecs))
oBaixas:Cell("DESCONTO"):SetPicture(tm(E5_VALOR,oBaixas:Cell("DESCONTO"):nSize,nDecs))
oBaixas:Cell("ABATIMENTO"):SetPicture(tm(E5_VALOR,oBaixas:Cell("ABATIMENTO"):nSize,nDecs))
oBaixas:Cell("IMPOSTOS"):SetPicture(tm(E5_VALOR,oBaixas:Cell("IMPOSTOS"):nSize,nDecs))
If __lTemFKD 
	oBaixas:Cell("VALACESS"):SetPicture(tm(E5_VALOR,oBaixas:Cell("VALACESS"):nSize,nDecs))
EndIf
oBaixas:Cell("E5_VALORPG"):SetPicture(tm(E5_VALOR,oBaixas:Cell("E5_VALORPG"):nSize,nDecs))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//Total Geral
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
oBreak3 := TRBreak():New( oBaixas, { || }, STR0029) //"Total Geral"
TRFunction():New(oBaixas:Cell("E5_VALOR")		,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("E5_VALOR"):nSize,nDecs)		, {|| If(aRelat[nI,26],aRelat[nI,11],0)}						, .F., .F.,.F.)
TRFunction():New(oBaixas:Cell("JUROS/MULTA")	,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("JUROS/MULTA"):nSize,nDecs)	, {|| aRelat[nI,12]}											, .F., .F.,.F.)
TRFunction():New(oBaixas:Cell("CORRECAO")		,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("CORRECAO"):nSize,nDecs)		, {|| If(aRelat[nI,26],aRelat[nI,13],0)}						, .F., .F.,.F.) 
TRFunction():New(oBaixas:Cell("DESCONTO")		,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("DESCONTO"):nSize,nDecs)		, {|| If(aRelat[nI,26] .Or. aRelat[nI,14] > 0,aRelat[nI,14],0)}	, .F., .F.,.F.) 
TRFunction():New(oBaixas:Cell("ABATIMENTO")		,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("ABATIMENTO"):nSize,nDecs)	, {|| aRelat[nI,15]}					    , .F., .F.,.F.) 
TRFunction():New(oBaixas:Cell("IMPOSTOS")		,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("IMPOSTOS"):nSize,nDecs)		, {|| If(aRelat[nI,26],aRelat[nI,16],0)}						, .F., .F.,.F.) 
If __lTemFKD 
	TRFunction():New(oBaixas:Cell("VALACESS")	,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("VALACESS"):nSize,nDecs)		, /*[ uFormula ]*/												, .F., .F.,.F.)
EndIf
TRFunction():New(oBaixas:Cell("E5_VALORPG")		,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("E5_VALORPG"):nSize,nDecs)	, {|| aRelat[nI,27]}											, .F., .F.,.F.)
              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//Total sem movimentação.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
oBreak4 := TRBreak():New( oBaixas, { || }, "Total Geral S/Movimentação") //"Total Geral S/Movimentação"
TRFunction():New(oBaixas:Cell("E5_VALOR")		,/*[cID*/, "SUM", oBreak4  , "", tm(E5_VALOR,oBaixas:Cell("E5_VALOR"):nSize,nDecs)		, {|| If(aRelat[nI][29],aRelat[nI,11],0)}						, .F., .F.,.F.)
TRFunction():New(oBaixas:Cell("JUROS/MULTA")	,/*[cID*/, "SUM", oBreak4  , "", tm(E5_VALOR,oBaixas:Cell("JUROS/MULTA"):nSize,nDecs)	, {|| If(aRelat[nI][29],aRelat[nI,12],0)}											, .F., .F.,.F.)
TRFunction():New(oBaixas:Cell("CORRECAO")		,/*[cID*/, "SUM", oBreak4  , "", tm(E5_VALOR,oBaixas:Cell("CORRECAO"):nSize,nDecs)		, {|| If(aRelat[nI][29],aRelat[nI,13],0)}											, .F., .F.,.F.)
TRFunction():New(oBaixas:Cell("DESCONTO")		,/*[cID*/, "SUM", oBreak4  , "", tm(E5_VALOR,oBaixas:Cell("DESCONTO"):nSize,nDecs)		, {|| If(aRelat[nI][29],aRelat[nI,14],0)}											, .F., .F.,.F.)
TRFunction():New(oBaixas:Cell("ABATIMENTO")		,/*[cID*/, "SUM", oBreak4  , "", tm(E5_VALOR,oBaixas:Cell("ABATIMENTO"):nSize,nDecs)	, {|| If(aRelat[nI][29],aRelat[nI,15],0)}											, .F., .F.,.F.)
TRFunction():New(oBaixas:Cell("IMPOSTOS")		,/*[cID*/, "SUM", oBreak4  , "", tm(E5_VALOR,oBaixas:Cell("IMPOSTOS"):nSize,nDecs)		, {|| If(aRelat[nI][29],aRelat[nI,16],0)}											, .F., .F.,.F.)
If __lTemFKD 
	TRFunction():New(oBaixas:Cell("VALACESS")	,/*[cID*/, "SUM", oBreak4  , "", tm(E5_VALOR,oBaixas:Cell("VALACESS"):nSize,nDecs)		, /*[ uFormula ]*/												, .F., .F.,.F.)
EndIf
TRFunction():New(oBaixas:Cell("E5_VALORPG")		,/*[cID*/, "SUM", oBreak4  , "", tm(E5_VALOR,oBaixas:Cell("E5_VALORPG"):nSize,nDecs)	, {|| If(aRelat[nI][29],aRelat[nI,17],0)}											, .F., .F.,.F.)	             
                         
oReport:SetTitle(cTitulo)
oReport:SetMeter(Len(aRelat))  

oBaixas:Init()                  	
nI := 1
While nI <= Len(aRelat)

	If oReport:Cancel()
		nI++
		Exit
	EndIf

	If !Empty(aRelat[nI,28])
	  	SE5->(dbGoto(aRelat[nI,28]))
	EndIf
        
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona na Filial do Movimento a ser impresso³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  	//cFilAnt := SE5->E5_FILIAL
  	oReport:IncMeter()
  	oBaixas:PrintLine()

	If (nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8)
		cTotText := STR0071 + " : " + DToC(aRelat[nI][nCond1]) //"Sub Total"
	Else //nOrdem == 2 .or. nOrdem == 3 .or. nOrdem == 4 .or. nOrdem == 5 .or. nOrdem == 7
		cTotText := STR0071 + " : " + aRelat[nI][nCond1]       //"Sub Total"
		If nOrdem == 2 //Banco
			SA6->(DbSetOrder(1))
			SA6->(MsSeek(xFilial("SA6")+aRelat[nI][nCond1] + aRelat[nI][30]+aRelat[nI][31] ))
			cTotText += " " + TRIM(SA6->A6_NOME)
		ElseIf nOrdem == 3 //Natureza
			SED->(DbSetOrder(1))
			SED->(MsSeek(xFilial("SED")+ StrTran (aRelat[nI][nCond1],".","")))
			cTotText += SED->ED_DESCRIC
		EndIf
	EndIf
	
	If lVarFil
		cTxtFil := aRelat[nI][22]
	EndIf               

	nI++

EndDo
SE5->(dbGoto(nRegSE5))
SM0->(dbGoTo(nRegSM0))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

//nao retirar "nI--" pois eh utilizado na impressao do ultimo TRFunction
nI--

oBaixas:Finish()
PRINTTOT(aTotais,oReport,.F.,3,@nJ)

Return NIL


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PRINTTOT ³ Autor ³ Daniel Tadashi Batori ³ Data ³ 10.10.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime os totais "Baixados", "Mov Fin.", "Compens."       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PRINTTOT(aTotal,oReport,lFil)                              ³±±
±±³          ³ aTotais -> array a ser utilizado para impressao            ³±±
±±³          ³ oReport -> objeto TReport                                  ³±±
±±³          ³ lFil -> .F. se for total da secao ou .T. se for da filial  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PRINTTOT(aTotais,oReport,lFil,nBreak,nJ)
Local nDecs := GetMv("MV_CENT"+(If(mv_par12 > 1 , STR(mv_par12,1),""))) 
Local cAnt := ""
Local nAscan := 0 
Local cGeral := OemToAnsi(STR0075)
Local nTamAnt:= 0
Default nJ 	 := 1

If lFil == .T.
	oReport:SkipLine(2)
EndIf

nAscan := Ascan(aTotais , {|e| Alltrim(e[1]) ==  cGeral } )

If nBreak <> 3
	If Len(aTotais)>0
		If (MV_MULNATP .Or. MV_MULNATR) .And. !(aTotais[nJ][1] $ "/") .And. Len(aTotais[nJ]) > 3
			cAnt := aTotais[nJ][4]      
		Else
			cAnt := aTotais[nJ][1]
		EndIf
	EndIf

	While (( Iif(( ValType(cAnt) <> ValType(aTotais[nJ][1]) .And. Len(aTotais[nJ] ) == 3 ), "" , cAnt ) ) == ( Iif((( MV_MULNATP .Or. MV_MULNATR) .And. !(aTotais[nJ][1] $ "/") .And. Len(aTotais[nJ]) > 3 ), aTotais[nJ][4], aTotais[nJ][1] ) ) .and. (nJ < nAscan) )
        nTamAnt := Len(aTotais[nJ] )
		oReport:PrintText( PadR(aTotais[nJ][2],12," ") + Transform(aTotais[nJ][3], tm(aTotais[nJ][3],20,nDecs) ) )
		nJ++
		If nTamAnt < Len(aTotais[nJ]) 
		// significa quebra de filial. Antes, com print de total de filial, o tamanho é 3, com este proximo total de outra filial, tamanho será 4
			Exit
		Endif
	EndDo
Else    
	oReport:PrintText( '' )	
	While nAscan > 0 
		oReport:PrintText( PadR(aTotais[nAscan][2],12," ") + Transform(aTotais[nAscan][3], tm(aTotais[nAscan][3],20,nDecs) ) )
		nAscan := If( (nAscan+1)<=Len(aTotais) .and. aTotais[nAscan+1][1] == cGeral,nAscan+1,0)
	EndDo
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fr190TstCo³ Autor ³ Claudio D. de Souza   ³ Data ³ 22.08.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Testa as condicoes do registro do SE5 para permitir a impr.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Fr190TstCon(cFilSe5)													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cFilSe5 - Filtro em CodBase										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINR190																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr190TstCond  (cFilSe5)
Local lRet := .T.
Local nMoedaBco
Local lManual := .F.

If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1) .Or.;
	(Empty(NEWSE5->E5_NUMERO)  .And. mv_par16 == 1)
	lManual := .t.
EndIf

Do Case
Case !&(cFilSe5)           		// Verifico filtro CODEBASE tambem para TOP
	lRet := .F.
Case NEWSE5->E5_TIPODOC $ "DC/D2/JR/J2/TL/MT/M2/CM/C2" 
	lRet := .F.
Case NEWSE5->E5_SITUACA $ "C/E/X" .or.; 
	(NEWSE5->E5_TIPODOC == "CD" .and. NEWSE5->E5_VENCTO > NEWSE5->E5_DATA)
	lRet := .F.
Case NEWSE5->E5_TIPODOC == "E2" .and. mv_par11 == 2
	lRet := .F.
Case Empty(NEWSE5->E5_TIPODOC) .and. mv_par16 == 2
	lRet := .F.
Case Empty(NEWSE5->E5_NUMERO) .and. mv_par16 == 2
	lRet := .F. 
Case mv_par16 == 2 .and. NEWSE5->E5_TIPODOC $ "CH"   
	lRet := .F. 
Case NEWSE5->E5_MOTBX == "DSD"
	lRet := .F.
Case mv_par11 = 1 .And. E5_TIPODOC $ "E2#CB"
	lRet := .F.
Case IIf(mv_par03 == mv_par04,NEWSE5->E5_BANCO != mv_par03 .And. !Empty(NEWSE5->E5_BANCO),NEWSE5->E5_BANCO < mv_par03 .Or. NEWSE5->E5_BANCO > MV_PAR04)
	lRet := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se escolhido o parƒmetro "baixas normais", apenas imprime as baixas  ³
	//³que gerarem movimenta‡„o banc ria e as movimenta‡”es financeiras     ³
	//³manuais, se consideradas.                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case mv_par14 == 1 .and. !MovBcoBx(NEWSE5->E5_MOTBX) .and. !lManual	
	lRet := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case !Empty(cFilterUser).and.!(&cFilterUser)
	lRet := .F.	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe estorno para esta baixa, somente no nivel de quebra ³
	//³ mais interno, para melhorar a performance 										³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EndCase

If lRet .And. NEWSE5->E5_RECPAG == "R"
	If ( NEWSE5->E5_TIPODOC = "RA" .And. mv_par35 = 2 ) .Or.;
		(NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG.and. mv_par24 == 2 .and.;
		NEWSE5->E5_MOTBX == "CMP")
		lRet := .F.
	EndIf
Endif
If lRet .And. NEWSE5->E5_RECPAG == "P"
	If ( NEWSE5->E5_TIPODOC = "PA" .And. mv_par35 = 2 ) .Or.;
		(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par24 == 2 .and.;
		 NEWSE5->E5_MOTBX == "CMP")
		lRet := .F.
	EndIf
Endif	

If lRet .And. mv_par25 == 2
	If ( cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA) ) .OR. FXMultSld()
	   SA6->(DbSetOrder(1))
	   SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
	   nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
	ElseIf !Empty(NEWSE5->E5_ORDREC)
		nMoedaBco:= Val(NEWSE5->E5_MOEDA)
	Else
	   nMoedaBco	:=	1
	Endif
	If nMoedaBco <> mv_par12
		lRet := .F.
	EndIf
EndIf 

If lRet
	// Testar se considerar mov bancario e se o cancelamento da baixa tiver sido realizado, não imprimir o mov.						
	If MV_PAR16 == 1			   
		If Fr190MovCan(17,"NEWSE5")
		   lRet := .F.
		Endif   
	Endif
Endif

If lRet
	// Se for um recebimento de Titulo pago em dinheiro originado pelo SIGALOJA, nao imprime o mov.
	If NEWSE5->E5_TIPODOC == "BA" .and. NEWSE5->E5_MOTBX == "LOJ" .And. IsMoney(NEWSE5->E5_MOEDA)
		lRet := .F.	
	EndIf
EndIf

//Tratamento p/ ñ imp tít aglutinador quando o mesmo não estiver sofrido baixa.
If Empty(NEWSE5->(E5_TIPO+E5_DOCUMEN+E5_IDMOVI+E5_FILORIG+E5_MOEDA))
	lRet := .F.	
EndIf

Return lRet     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FA190ImpR4 ³ Autor ³ Adrianne Furtado      ³ Data ³ 05.09.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rela‡„o das baixas                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA190ImpR4(nOrdem,aTotais)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nOrdem    - Ordem que sera utilizada na emissao do relatorio ³±±
±±³          ³ aTotais   - Array que retorna o totalizador especifico de    ³±±
±±³          ³ 			   cada quebra de secao                             ³±±
±±³          ³ oReport   - objeto da classe TReport                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA190ImpR4(nOrdem,aTotais,oReport,nGerOrig)
Local oBaixas		:= oReport:Section(1)
Local cExp 			:= ""
Local CbTxt			:= ""
Local CbCont		:= ""
Local nValor		:= 0
Local nDesc			:= 0
Local nJuros		:= 0
Local nMulta		:= 0
Local nJurMul		:= 0
Local nCM			:= 0
Local dData		
Local nVlMovFin		:= 0
Local nTotValor		:= 0
Local nTotDesc		:= 0
Local nTotJurMul	:= 0
Local nTotCm		:= 0
Local nTotOrig		:= 0
Local nTotBaixado	:= 0
Local nTotMovFin	:= 0
Local nTotComp		:= 0
Local nTotFat		:= 0
Local nGerValor		:= 0
Local nGerDesc		:= 0
Local nGerJurMul	:= 0
Local nGerCm		:= 0
Local nGerBaixado	:= 0
Local nGerMovFin	:= 0
Local nGerComp		:= 0
Local nGerFat		:= 0
Local nFilOrig		:= 0
Local nFilJurMul	:= 0
Local nFilCM		:= 0
Local nFilDesc		:= 0
Local nFilAbLiq		:= 0
Local nFilAbImp		:= 0
Local nFilValor		:= 0
Local nFilBaixado	:= 0
Local nFilMovFin	:= 0
Local nFilComp		:= 0
Local nFilFat		:= 0
Local nAbatLiq		:= 0 
Local nTotAbImp		:= 0
Local nTotImp		:= 0
Local nTotAbLiq		:= 0
Local nGerAbLiq		:= 0
Local nGerAbImp		:= 0
Local cBanco		:= ''
Local cNatureza		:= ''
Local cAnterior		:= ''
Local cCliFor		:= ''
Local nCT			:= 0
Local dDigit
Local cLoja			:= ''
Local lContinua		:= .T.
Local lBxTit		:= .F.
Local tamanho		:= "G"
Local aCampos		:= {}
Local cNomArq1		:= ""
Local nVlr
Local cLinha		:= ''
Local lOriginal		:= .T.
Local nAbat			:= 0
Local cHistorico
Local lManual		:= .F.
Local cTipodoc
Local nRecSe5		:= 0
Local dDtMovFin
Local cRecPag
Local nRecEmp		:= SM0->(Recno())
Local cMotBaixa		:= CRIAVAR("E5_MOTBX")
Local cFilNome		:= Space(15)
Local cCliFor190	:= ""
Local aTam			:= IIF(mv_par11 == 1,TamSX3("E1_CLIENTE"),TamSX3("E2_FORNECE"))
Local aColu			:= {}
Local nDecs			:= GetMv("MV_CENT"+(IIF(mv_par12 > 1 , STR(mv_par12,1),""))) 
Local nMoedaBco		:= 1
Local cCarteira
Local aStru			:= SE5->(DbStruct()), nI
Local cQuery
Local cFilTrb
Local cFilSe5		:= ".T."
Local cChave		:= ''
Local bFirst
Local cFilOrig
Local lAchou		:= .F.
Local lF190Qry		:= ExistBlock("F190QRY")
Local cQueryAdd		:= ""
Local lAjuPar15		:= Len(AllTrim(mv_par15))==Len(mv_par15)
Local lAchouEmp		:= .T.                                
Local lAchouEst		:= .F.                                
Local nTamEH		:= TamSx3("EH_NUMERO")[1]
Local nTamEI		:= TamSx3("EI_NUMERO")[1]+TamSx3("EI_REVISAO")[1]+TamSx3("EI_SEQ")[1]
Local cCodUlt		:= SM0->M0_CODIGO
Local cFilUlt		:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Local nRecno
Local nSavOrd
Local aAreaSE5
Local cChaveNSE5	:= ""           
Local nRecSE2		:= 0
Local aAreaSE2
Local aAreabk
Local aRet			:= {}
Local cAuxFilNome
Local cAuxCliFor
Local cAuxLote
Local dAuxDtDispo
Local cFilUser	 	:= ""
Local lPCCBaixa 	:= SuperGetMv("MV_BX10925",.T.,"2") == "1"
Local nTaxa			:= 0   
Local lUltBaixa 	:= .F.
Local cChaveSE1 	:= ""
Local cChaveSE5 	:= ""
Local cSeqSE5 		:= ""
Local lMVLjTroco	:= SuperGetMV("MV_LJTROCO", ,.F.)				
Local nRecnoSE5		:= 0
Local nValTroco 	:= 0
Local lTroco 		:= .F. 
Local cEstor        := "Estorno de tranferencia" // "Estorno de tranferencia"
//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default))
Local lPccBxCr		:= FPccBxCr()
Local nPccBxCr		:= 0
//Controla o Pis Cofins e Csll na RA (1 = Controla retenção de impostos no RA; ou 2 = Não controla retenção de impostos no RA(default))
Local lRaRtImp		:= FRaRtImp()
Local cEmpresa		:= IIf(lUnidNeg,FWCodEmp(),"")
Local cAge			:= ''
Local cContaBco		:= ''
Local cMascNat		:= ""
Local lConsImp		:= .T.
Local lMVGlosa		:= SuperGetMv("MV_GLOSA",.F.,.F.)
Local nVlrGlosa		:= 0

/* GESTAO - inicio */
Local cTmpSE5Fil	:= ""
Local lNovaGestao	:= .F.
Local nSelFil		:= 0
Local nLenSelFil	:= 0
Local lGestao		:= Iif( lFWCodFil, ( "E" $ FWSM0Layout() .And. "U" $ FWSM0Layout() ), .F. )	// Indica se usa Gestao Corporativa
Local lExclusivo	:= .F.
Local aModoComp		:= {}
Local lMultiNat		:= .F. 
Local nRecChkd		:= 0


/* GESTAO - fim */


/* GESTAO - inicio */ 
lNovaGestao := .T.

/* GESTAO - fim */ 

If lFWCodFil .And. lGestao
	aAdd(aModoComp, FWModeAccess("SE5",1) )
	aAdd(aModoComp, FWModeAccess("SE5",2) )
	aAdd(aModoComp, FWModeAccess("SE5",3) )
	lExclusivo := Ascan(aModoComp, 'E') > 0
Else
	dbSelectArea("SE5")
	lExclusivo := !Empty(xFilial("SE5"))
EndIf

If MV_PAR41 == 2   
	lConsImp := .F.
EndIf

nGerOrig :=0

li := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/* GESTAO - inicio */
If lNovaGestao
	nLenSelFil := Len(aSelFil)
	If mv_Par40 == 1
		If nLenSelFil > 0
			cFilDe 	:= aSelFil[1]
			cFilAte := aSelFil[nLenSelFil]
		Endif
	Else
		If mv_par17 == 2 // Cons filiais abaixo
			cFilDe := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
			cFilAte:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		Else
			cFilDe := mv_par18	// Todas as filiais
			cFilAte:= mv_par19
		EndIf
	EndIf
Else
	If mv_par17 == 2 // Cons filiais abaixo
		cFilDe := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		cFilAte:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	Else
		cFilDe := mv_par18	// Todas as filiais
		cFilAte:= mv_par19
	EndIf
Endif
/* GESTAO - fim */

// Definicao das condicoes e ordem de impressao, de acordo com a ordem escolhida pelo
// usuario.
DbSelectArea("SE5")
Do Case
Case nOrdem == 1
	cCondicao := "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
	cCond2 := "E5_DATA"
	cChave := IndexKey(1)
	cChaveInterFun := cChave
	bFirst := {|| MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
Case nOrdem == 2
	cCondicao := "E5_BANCO >= mv_par03 .and. E5_BANCO <= mv_par04"
	cCond2 := "E5_BANCO"
	cChave := IndexKey(3)
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+mv_par03,.T.)}
Case nOrdem == 3
	cCondicao := "E5_MULTNAT = '1' .Or. (E5_NATUREZ >= mv_par05 .and. E5_NATUREZ <= mv_par06)"
	cCond2 := "E5_NATUREZ"
	cChave := IndexKey(4)
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+mv_par05,.T.)}
Case nOrdem == 4
	cCondicao := ".T."
	cCond2 := "E5_BENEF"
	cChave := "E5_FILIAL+E5_BENEF+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 5
	cCondicao := ".T."
	cCond2 := "E5_NUMERO"
	cChave := "E5_FILIAL+E5_NUMERO+E5_PARCELA+E5_PREFIXO+DTOS(E5_DATA)"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 6	//Ordem 6 (Digitacao)
	cCondicao := ".T."
	cCond2 := "E5_DTDIGIT"
	cChave := "E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+DTOS(E5_DATA)"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 7 // por Lote
	cCondicao := "E5_LOTE >= '"+mv_par20+"' .and. E5_LOTE <= '"+mv_par21+"'"
	cCond2 := "E5_LOTE"
	cChave := IndexKey(5)
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+mv_par20,.T.)}
OtherWise						// Data de Crédito (dtdispo)
	cCondicao := "E5_DTDISPO >= mv_par01 .and. E5_DTDISPO <= mv_par02"
	cCond2 := "E5_DTDISPO"
	cChave := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
EndCase

If !Empty(mv_par28) .And. ! ";" $ mv_par28 .And. Len(AllTrim(mv_par28)) > 3
	ApMsgAlert(STR0073)//"Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	
If !Empty(mv_par29) .And. ! ";" $ mv_par29 .And. Len(AllTrim(mv_par29)) > 3
	ApMsgAlert(STR0074)//"Separe os tipos que não deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	

cCondicao := ".T."
DbSelectArea("SE5")
cQuery := ""
aEval(DbStruct(),{|e| cQuery += ","+AllTrim(e[1])})
// Obtem os registros a serem processados
cQuery := "SELECT " +SubStr(cQuery,2)
cQuery +=         ",SE5.R_E_C_N_O_ SE5RECNO "
cQuery += "FROM " + RetSqlName("SE5")+" SE5 "

If !Empty(MV_PAR42) .and. MV_PAR42 == 2
	cQuery += "WHERE E5_RECPAG = '" + IIF( mv_par11 == 1, "R","P") + "' AND "
Else
	If mv_par11 == 1
		cQuery +=    	"WHERE E5_RECPAG = (CASE WHEN E5_TIPODOC =  'TR' AND  E5_HISTOR LIKE '%"+cEstor+"%' THEN 'P' ELSE 'R' END ) AND"
	Else
		cQuery +=    	"WHERE E5_RECPAG = (CASE WHEN E5_TIPODOC =  'TR' AND  E5_HISTOR LIKE '%"+cEstor+"%' THEN 'R' ELSE 'P' END ) AND"
	EndIf
EndIf

cQuery += "      E5_DATA    between '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "' AND "
cQuery += "      E5_DATA    <= '" + DTOS(dDataBase) + "' AND "

If cPaisLoc == "ARG" .and. mv_par03 == mv_par04
	cQuery += "      (E5_BANCO = '" + mv_par03 + "' OR E5_BANCO = '" + Space(TamSX3("A6_COD")[1]) + "') AND "
Else
	cQuery += "      E5_BANCO   between '" + mv_par03       + "' AND '" + mv_par04       + "' AND "		
EndIf
If cPaisLoc == "ARG" .and. mv_par11 == 2 // pagar
	cQuery += " (E5_DOCUMEN != ' ' AND E5_TIPO != 'CH') AND "
Endif
//-- Realiza filtragem pela natureza principal
If mv_par39 == 2
	cQuery +=  " E5_NATUREZ between '" + mv_par05       + "' AND '" + mv_par06     	+ "' AND "
Else
	cQuery +=       " (E5_NATUREZ between '" + mv_par05       + "' AND '" + mv_par06       + "' OR "
	cQuery +=       " EXISTS (SELECT EV_FILIAL, EV_PREFIXO, EV_NUM, EV_PARCELA, EV_CLIFOR, EV_LOJA "
	cQuery +=                 " FROM "+RetSqlName("SEV")+" SEV "
	cQuery +=                " WHERE E5_FILIAL  = EV_FILIAL AND "
	cQuery +=                       "E5_PREFIXO = EV_PREFIXO AND "
	cQuery +=                       "E5_NUMERO  = EV_NUM AND "
	cQuery +=                       "E5_PARCELA = EV_PARCELA AND "
	cQuery +=                       "E5_TIPO    = EV_TIPO AND "		
	cQuery +=                       "E5_CLIFOR  = EV_CLIFOR AND "
	cQuery +=                       "E5_LOJA    = EV_LOJA AND " 
	cQuery +=                       "EV_NATUREZ between '" + mv_par05 + "' AND '" + mv_par06 + "' AND "
	cQuery +=                       "SEV.D_E_L_E_T_ = ' ')) AND "
EndIf
cQuery += "      E5_CLIFOR  between '" + mv_par07       + "' AND '" + mv_par08       + "' AND "
cQuery += "      E5_DTDIGIT between '" + DTOS(mv_par09) + "' AND '" + DTOS(mv_par10) + "' AND "
cQuery += "      E5_LOTE    between '" + mv_par20       + "' AND '" + mv_par21       + "' AND "
cQuery += "      E5_LOJA    between '" + mv_par22       + "' AND '" + mv_par23 	    + "' AND "
cQuery += "      E5_PREFIXO between '" + mv_par26       + "' AND '" + mv_par27 	    + "' AND "
cQuery += "      SE5.D_E_L_E_T_ = ' '  AND "
cQuery += " 	  E5_SITUACA NOT IN ('C','E','X') AND NOT EXISTS ( "
cQuery += "         													SELECT SE5ES.E5_NUMERO " 
cQuery += "           														FROM "+ RetSqlName("SE5") + " SE5ES " 
cQuery += "          													WHERE SE5ES.E5_FILIAL  = SE5.E5_FILIAL "  
cQuery += "            													AND SE5ES.E5_PREFIXO = SE5.E5_PREFIXO "
cQuery += "            													AND SE5ES.E5_NUMERO  = SE5.E5_NUMERO " 
cQuery += "            													AND SE5ES.E5_PARCELA = SE5.E5_PARCELA " 
cQuery += "            													AND SE5ES.E5_TIPO    = SE5.E5_TIPO " 
cQuery += "            													AND SE5ES.E5_CLIFOR  = SE5.E5_CLIFOR " 
cQuery += "            													AND SE5ES.E5_LOJA    = SE5.E5_LOJA " 
cQuery += "            													AND SE5ES.E5_SEQ     = SE5.E5_SEQ " 
cQuery += "            													AND SE5ES.E5_TIPODOC = 'ES' "
cQuery += "            													AND SE5ES.E5_ORIGEM <> 'FINA100 ' "
cQuery += "														) AND "
cQuery += "      ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR "
cQuery += "      (E5_TIPODOC != 'CD')) "
cQuery += "		  AND E5_HISTOR NOT LIKE '%"+STR0077+"%'"
cQuery += "		  AND E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','ES'"

If !Empty(MV_PAR42) .and. MV_PAR42 == 2 // Cons. Baixa por Mov. Bancário //dms
	cQuery += "		  ,'TR'"
EndIf
If mv_par11 == 2
	cQuery += " ,'E2'"
EndIf
If mv_par16 == 2
	cQuery += " ,' '"
	cQuery += " ,'CH'" 
	cQuery += " ,'TE'"
	cQuery += " ,'TR'"
Endif
cQuery += " )"
If !Empty(MV_PAR42) .and. MV_PAR42 == 2//dms
	cQuery += " AND E5_ORIGEM != 'FINA100' "
EndIf
If mv_par16 == 2
	cQuery += " AND E5_NUMERO  != '" + SPACE(LEN(E5_NUMERO)) + "'"
Endif
If !Empty(mv_par28) // Deseja imprimir apenas os tipos do parametro 28
	cQuery += " AND E5_TIPO IN "+FormatIn(mv_par28,";")
ElseIf !Empty(Mv_par29) // Deseja excluir os tipos do parametro 29
	cQuery += " AND E5_TIPO NOT IN "+FormatIn(mv_par29,";")
EndIf

cCondFil := "NEWSE5->E5_FILIAL==xFilial('SE5')"		
		
/* GESTAO - inicio */
If mv_par40 == 1 .and. !Empty(aSelFil)
	If lExclusivo
		cQuery += " AND E5_FILIAL " + GetRngFil( aSelFil, "SE5", .T., @cTmpSE5Fil)
	Else
		cQuery += " AND E5_FILORIG " + FR190InFilial()
	Endif
Else
	If mv_par17 == 2
		cQuery += " AND E5_FILIAL = '" + FwxFilial("SE5") + "'"
	Else
		If !lExclusivo
			cQuery += " AND E5_FILORIG between '" + cFilDe + "' AND '" + cFilAte + "'"
		Else
			cQuery += " AND E5_FILIAL between '" + cFilDe + "' AND '" + cFilAte + "'"
		EndIf
	Endif
EndIf
/* GESTAO - fim */

cFilUser := oBaixas:GetSqlExp('SE5')

If lF190Qry
	cQueryAdd := ExecBlock("F190QRY", .F., .F., {cFilUser})
	If ValType(cQueryAdd) == "C"
		cQuery += " AND (" + cQueryAdd + ")"
	EndIf
EndIf

If !Empty(cFilUser)
	cQuery += " AND (" + cFilUser + ") "
EndIf

cQuery += Iif(FindFunction("JurQWRelBx"), JurQWRelBx() , "" )

// seta a ordem de acordo com a opcao do usuario
cQuery += " ORDER BY " + SqlOrder(cChave) 
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "NEWSE5", .F., .T.)
For nI := 1 TO LEN(aStru)
	If aStru[nI][2] != "C"
		TCSetField("NEWSE5", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
	EndIf
Next
DbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"LINHA","C",80,0 } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If(_oFINR190 <> NIL)

	_oFINR190:Delete()
	_oFINR190 := NIL

EndIf

_oFINR190 := FwTemporaryTable():New("TRB")
_oFINR190:SetFields(aCampos)
_oFINR190:AddIndex("1",{"LINHA"})
_oFINR190:Create()

aColu := Iif(aTam[1] > 6,{023,027,TamParcela("E1_PARCELA",40,39,38),042,000,022},{000,004,TamParcela("E1_PARCELA",17,16,15),019,023,030})


If MV_PAR16 == 1

	dbSelectArea("SE5")
	dbSetOrder(17) //"E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+E5_TIPODOC+E5_SEQ"
	dbGoTop()

Endif


DbSelectArea("SM0")
/* GESTAO - inicio */
If mv_par40 == 1 .and. lNovaGestao
	nSelFil := 0
Else
	DbSeek(cEmpAnt+If(Empty(cFilDe),"",cFilDe),.T.)
Endif

While SM0->(!Eof()) .and. SM0->M0_CODIGO == cEmpAnt .and.  If(mv_par40 ==1 .And. lNovaGestao,(nSelFil < nLenSelFil) .and. cFilDe <= cFilAte , SM0->M0_CODFIL <= cFilAte)
	If mv_par40 ==1 .and. lNovaGEstao
		nSelFil++
		DbSeek(cEmpAnt+aSelFil[nSelFil],.T.)
	Endif
/* GESTAO - fim */
	
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilNome:= SM0->M0_FILIAL
	DbSelectArea("NEWSE5")

	/* GESTAO - inicio */
	IF !lNovaGestao
		If lUnidNeg .and. (cEmpresa	<> FWCodEmp())
			SM0->(DbSkip())
			Loop
		Endif
	Endif
	/* GESTAO - fim */

	If mv_par11 = 2  //Pagar
		If mv_par39 != 3  //diferente de multinatureza verifica no SE2 se o campo esta preenchido
			SE2->(dbSetOrder(1))
			If SE2->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))) //Alimentar a variável lMultiNat apenas se for encontrado o título na filial corrente
				lMultiNat := .F.//Inicializa variável apenas se encontrar o título na filial corrente
				lMultiNat := ( SE2->E2_MULTNAT == '1' ) //pq se o campo nao estiver preenchido nao desvia para FINR199
				lMultiNat := ( lMultiNat .And. MV_MULNATP .and. mv_par38 = 2 .and. mv_par39 != 2)
			EndIf
		Else
			lMultiNat := ( MV_MULNATP .and. mv_par38 = 2 .and. mv_par39 != 2)
		EndIf
	ElseIf mv_par11 = 1  //Receber
		lMultiNat := ( MV_MULNATR .and. mv_par38 = 2 .and. mv_par39 != 2 )
	EndIf
	
	If lMultiNat
	
		Finr199(	@nGerOrig,@nGerValor,@nGerDesc,@nGerJurMul,@nGerCM,@nGerAbLiq,@nGerAbImp,@nGerBaixado,@nGerMovFin,@nGerComp,;
					@nFilOrig,@nFilValor,@nFilDesc,@nFilJurMul,@nFilCM,@nFilAbLiq,@nFilAbImp,@nFilBaixado,@nFilMovFin,@nFilComp,;
					.F.,cCondicao,cCond2,aColu,lContinua,cFilSe5,.T.,Tamanho, @aRet, @aTotais, nOrdem, @nGerFat, @nFilFat,lNovaGestao)

 		Li++	// Deve sempre referenciar a proxima linha - A funcao acima atualiza apenas pelo que adicionou em aRet. 
		
		dbSelectArea("SE5")
		dbCloseArea()
		ChKFile("SE5")
		dbSelectArea("SE5")
		dbSetOrder(1)
	
		If Empty(xFilial("SE5"))
			Exit
		Endif
	
		dbSelectArea("SM0")
		cCodUlt := SM0->M0_CODIGO
 		cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		dbSkip()
		Loop

	Else

		While NEWSE5->(!Eof()) .And. &cCondFil .And. &cCondicao .and. lContinua
			
			DbSelectArea("NEWSE5")
			// Testa condicoes de filtro	
			If (nRecChkd <> NEWSE5->SE5RECNO) .AND. !Fr190TstCond(cFilSe5)
				NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
				Loop
			Else
				nRecChkd := NEWSE5->SE5RECNO
			Endif							
						
			If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
				(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
				cCarteira := "R"
			Else
				cCarteira := "P"
			Endif
	
			dbSelectArea("NEWSE5")
			cAnterior 	:= &cCond2
			nTotValor	:= 0
			nTotDesc	   := 0
			nTotJurMul  := 0
			nTotCM		:= 0
			nCT			:= 0
			nTotOrig	   := 0
			nTotBaixado	:= 0
			nTotAbLiq  	:= 0
			nTotImp		:= 0
			nTotMovFin	:= 0
			nTotComp		:= 0
			nTotFat		:= 0
	
			While NEWSE5->(!EOF()) .and. &cCond2=cAnterior .and. &cCondFil .and. lContinua
	
				lManual := .f.
				dbSelectArea("NEWSE5")
				
				If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1) .Or.;
					(Empty(NEWSE5->E5_NUMERO)  .And. mv_par16 == 1)
					lManual := .t.
				EndIf
				
				// Testa condicoes de filtro	
				If (nRecChkd <> NEWSE5->SE5RECNO) .AND. !Fr190TstCond(cFilSe5)
					NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
					Loop
				Else
					nRecChkd := NEWSE5->SE5RECNO
				Endif	 						
					
				// Imprime somente cheques
				cChaveNSE5	:= NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
				If !EMPTY(cChaveNSE5) .AND. mv_par37 == 1 .And. NEWSE5->E5_TIPODOC == "BA"
				
					aAreaSE5 := SE5->(GetArea())
					SE5->(dbSetOrder(11))
					SE5->(MsSeek(xFilial("SE5")+cChaveNSE5))					
               
					// Procura o cheque aglutinado, se encontrar, marca lAchou := .T. e despreza 
					lAchou := .F.
					WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChaveNSE5
						If SE5->E5_TIPODOC == "CH"
							lAchou := .T.
							Exit
						Endif
						SE5->(dbSkip())
					Enddo
					RestArea(aAreaSE5)
					// Achou cheque aglutinado para a baixa, despreza o registro
					If lAchou
						NEWSE5->(dbSkip())
						Loop
					Endif  	

				ElseIf !EMPTY(cChaveNSE5) .AND. mv_par37 == 2 .And. NEWSE5->E5_TIPODOC == "CH" //somente baixas

					aAreaSE5 := SE5->(GetArea())
					SE5->(dbSetOrder(11))
					SE5->(MsSeek(xFilial("SE5")+cChaveNSE5))					
               
					// Procura a baixa aglutinada, se encontrar despreza o movimento bancario
					lAchou := .F.
					WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChaveNSE5
						If SE5->E5_TIPODOC $ "BA"
							lAchou := .T.
							Exit
						Endif	
						SE5->(dbSkip())
					Enddo
					RestArea(aAreaSE5)
					// Achou cheque aglutinado para a baixa, despreza o registro
					If lAchou
						NEWSE5->(dbSkip())
						Loop
					Endif
				Endif	

				cNumero    	:= NEWSE5->E5_NUMERO
				cPrefixo   	:= NEWSE5->E5_PREFIXO
				cParcela   	:= NEWSE5->E5_PARCELA
				dBaixa     	:= NEWSE5->E5_DATA
				cBanco     	:= NEWSE5->E5_BANCO
				cAge		:= NEWSE5->E5_AGENCIA
				cContaBco	:= NEWSE5->E5_CONTA
				cNatureza  	:= NEWSE5->E5_NATUREZ
				cCliFor    	:= NEWSE5->E5_BENEF
				cLoja      	:= NEWSE5->E5_LOJA
				cSeq       	:= NEWSE5->E5_SEQ
				cNumCheq   	:= NEWSE5->E5_NUMCHEQ
				cRecPag     := NEWSE5->E5_RECPAG
				cTipodoc   	:= NEWSE5->E5_TIPODOC
				cMotBaixa	:= NEWSE5->E5_MOTBX
				cCheque    	:= NEWSE5->E5_NUMCHEQ
				cSeq       	:= NEWSE5->E5_SEQ
				cTipo      	:= NEWSE5->E5_TIPO
				cFornece   	:= NEWSE5->E5_CLIFOR
				cLoja      	:= NEWSE5->E5_LOJA
				dDigit     	:= NEWSE5->E5_DTDIGIT
				lBxTit	  	:= .F.
				cFilorig    := NEWSE5->E5_FILORIG
				//Obtem a ultima sequencia da baixa. Retirado da query para performance
				If AllTrim(NEWSE5->E5_ORIGEM) $ "FINA100"
					cMaxSeq := ""
				Else
					cMaxSeq := FR190MaxSeq(NEWSE5->E5_FILIAL, NEWSE5->E5_PREFIXO, NEWSE5->E5_NUMERO, NEWSE5->E5_PARCELA, NEWSE5->E5_TIPO,;
											NEWSE5->E5_CLIFOR, NEWSE5->E5_LOJA, NEWSE5->E5_RECPAG, NEWSE5->E5_SITUACA, NEWSE5->E5_NATUREZ)
				EndIf
				
				If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
					(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
					dbSelectArea("SE1")
					dbSetOrder(1)
					// Procuro SE1 pela filial origem
					lBxTit := MsSeek(xFilial("SE1",cFilorig)+cPrefixo+cNumero+cParcela+cTipo)
					If !lBxTit
						lBxTit := MSSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo)
					Endif				
					cCarteira := "R"
					dDtMovFin := IIF (lManual,CTOD("//"), SE1->E1_VENCREA)
					While SE1->(!Eof()) .and. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==cPrefixo+cNumero+cParcela+cTipo
						If SE1->E1_CLIENTE == cFornece .And. SE1->E1_LOJA == cLoja	// Cliente igual, Ok
							Exit
						Endif                                
						SE1->( dbSkip() )
					EndDo
					If !SE1->(EOF()) .And. mv_par11 == 1 .and. !lManual .and.  ;
						(NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
						cExp := "NEWSE5->E5_SITCOB"
						
						If mv_par36 == 2 // Nao imprime titulos em carteira 
							// Retira da comparacao as situacoes branco, 0, F e G
							mv_par15 := AllTrim(mv_par15)       
							mv_par15 := StrTran(mv_par15,"0","")
							mv_par15 := StrTran(mv_par15,"F","")
							mv_par15 := StrTran(mv_par15,"G","")
						Else
							If (NEWSE5->E5_RECPAG == "R") .And. lAjuPar15
								mv_par15  += " "
							Endif
						EndIf	
				
						cExp += " $ mv_par15" 
						If !(&cExp)
							dbSelectArea("NEWSE5")
							NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
							Loop
						Endif
					Endif
					cCond3:="NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ)==cPrefixo+cNumero+cParcela+cTipo+DtoS(dBaixa)+cSeq+cNumCheq"
					nDesc := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
				Else
					dbSelectArea("SE2")
					DbSetOrder(1)
					cCarteira := "P"
					// Procuro SE2 pela filial origem
				    lBxTit 	:= MsSeek(xFilial("SE2",cFilOrig)+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
				    
				    Iif(lBxTit, nRecSE2	:= SE2->(Recno()), nRecSE2 := 0 )
				    
					If !lBxTit
						lBxTit := MSSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
					Endif				
					dDtMovFin := IIF(lManual,CTOD("//"),SE2->E2_VENCREA)
					cCond3:="NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ)==cPrefixo+cNumero+cParcela+cTipo+cFornece+DtoS(dBaixa)+cSeq+cNumCheq"
					nDesc := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
					cCheque    := Iif(Empty(NEWSE5->E5_NUMCHEQ),SE2->E2_NUMBCO,NEWSE5->E5_NUMCHEQ)
				Endif
				dbSelectArea("NEWSE5")
				cHistorico := Space(40)
				While NEWSE5->( !Eof()) .and. &cCond3 .and. lContinua .And. &cCondFil
					
					dbSelectArea("NEWSE5")
					cTipodoc   := NEWSE5->E5_TIPODOC
					cCheque    := NEWSE5->E5_NUMCHEQ
	
					lAchouEmp := .T.
					lAchouEst := .F.
					nVlrGlosa := 0
	
					// Testa condicoes de filtro	
					If (nRecChkd <> NEWSE5->SE5RECNO) .AND. !Fr190TstCond(cFilSe5)
						NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
						Loop
					Else
						nRecChkd := NEWSE5->SE5RECNO
					Endif	  								
												
					If NEWSE5->E5_SITUACA $ "C/E/X" 
						dbSelectArea("NEWSE5")
						NEWSE5->( dbSkip() )
						Loop
					EndIF
					
					If NEWSE5->E5_LOJA != cLoja
						Exit
					Endif
	
					If NEWSE5->E5_FILORIG < mv_par33 .or. NEWSE5->E5_FILORIG > mv_par34
						dbSelectArea("NEWSE5")
						NEWSE5->( dbSkip() )
						Loop
					Endif
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Nao imprime os registros de emprestimos excluidos ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
					If NEWSE5->E5_TIPODOC == "EP"
						aAreaSE5 := NEWSE5->(GetArea())	
						dbSelectArea("SEH")
						dbSetOrder(1)
						lAchouEmp := MsSeek(xFilial("SEH")+Substr(NEWSE5->E5_DOCUMEN,1,nTamEH))
						RestArea(aAreaSE5)
						If !lAchouEmp
							NEWSE5->(dbSkip())
							Loop
						EndIf
					EndIf
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Nao imprime os registros de pagamento de emprestimos estornados ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
					If NEWSE5->E5_TIPODOC == "PE"
						aAreaSE5 := NEWSE5->(GetArea())	
						dbSelectArea("SEI")
						dbSetOrder(1)
						If	MsSeek(xFilial("SEI")+"EMP"+Substr(NEWSE5->E5_DOCUMEN,1,nTamEI))
							If SEI->EI_STATUS == "C"
								lAchouEst := .T.
							EndIf
						EndIf
						RestArea(aAreaSE5)
						If lAchouEst
							NEWSE5->(dbSkip())
							Loop
						EndIf
					EndIf
	  
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica o vencto do Titulo ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cFilTrb := If(mv_par11==1,"SE1","SE2")
					If (cFilTrb)->(!Eof()) .And.;
						((cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") < mv_par31 .Or. (!Empty(mv_par32) .And. (cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") > mv_par32))
						dbSelectArea("NEWSE5")
						NEWSE5->(dbSkip())
						Loop
					Endif
	            
					dBaixa     	:= NEWSE5->E5_DATA
					cBanco     	:= NEWSE5->E5_BANCO
					cAge		:= NEWSE5->E5_AGENCIA
					cContaBco	:= NEWSE5->E5_CONTA
					cNatureza  	:= NEWSE5->E5_NATUREZ
					cCliFor    	:= NEWSE5->E5_BENEF
					cSeq       	:= NEWSE5->E5_SEQ
					cNumCheq   	:= NEWSE5->E5_NUMCHEQ
					cRecPag		:= NEWSE5->E5_RECPAG
					cMotBaixa	:= NEWSE5->E5_MOTBX
					cTipo190	:= NEWSE5->E5_TIPO
					cFilorig    := NEWSE5->E5_FILORIG
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Obter moeda da conta no Banco.                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ( cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA) ) .OR. FXMultSld()
						SA6->(DbSetOrder(1))
						SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
						nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
					Else
						nMoedaBco	:=	1
					Endif
	
					If !Empty(NEWSE5->E5_NUMERO)
						If (NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)) .or. ;
							(NEWSE5->E5_RECPAG == "P" .and. NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG) .Or.;
							(NEWSE5->E5_RECPAG == "P" .And. NEWSE5->E5_TIPODOC $ "DB#OD")
							dbSelectArea( "SA1")
							dbSetOrder(1)
							lAchou := .F.							
							If MSSeek(xFilial("SA1")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
								lAchou := .T.
							Endif
							If !lAchou
								cFilOrig := NEWSE5->E5_FILIAL //Procuro SA1 pela filial do movimento
								If MSSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Else
										cFilOrig := NEWSE5->E5_FILORIG //Procuro SA1 pela filial origem
										If MSSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
											If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
												lAchou := .T.
											Endif
										Endif
									Endif
								Else
									cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA1 pela filial origem
									If MSSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif							
							EndIF
							If lAchou 
								cCliFor := Iif(mv_par30==1,SA1->A1_NREDUZ,SA1->A1_NOME)
							Else
								cCliFor	:= 	Upper(Alltrim(NEWSE5->E5_BENEF))
							Endif
						Else
							dbSelectArea( "SA2")
							dbSetOrder(1)
							lAchou := .F.							
							If MSSeek(xFilial("SA2")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
								lAchou := .T.
							Endif
							If !lAchou 
								cFilOrig := NEWSE5->E5_FILIAL //Procuro SA2 pela filial do movimento
								If MSSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Else
										cFilOrig := NEWSE5->E5_FILORIG //Procuro SA2 pela filial origem
										If MSSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
											If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
												lAchou := .T.
											Endif
										Endif
									Endif
								Else
									cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA2 pela filial origem
									If MSSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif							
							EndIF
							If lAchou 
								cCliFor := Iif(mv_par30==1,SA2->A2_NREDUZ,SA2->A2_NOME)
							Else
								cCliFor	:= 	Upper(Alltrim(NEWSE5->E5_BENEF))
							Endif
						EndIf
					EndIf
					dbSelectArea("SM2")
					dbSetOrder(1)
					dbSeek(NEWSE5->E5_DATA)
					dbSelectArea("NEWSE5") 
					nTaxa:= 0

					If cPaisLoc=="BRA"
						If !Empty(NEWSE5->E5_TXMOEDA)
							nTaxa:=NEWSE5->E5_TXMOEDA
						Else
							If nMoedaBco == 1
								nTaxa := NEWSE5->E5_VALOR / NEWSE5->E5_VLMOED2
							Else
								nTaxa := NEWSE5->E5_VLMOED2 / NEWSE5->E5_VALOR
							EndIf																
						EndIf
					EndIf
					nRecSe5 := NEWSE5->SE5RECNO
					nDesc+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLDESCO,Round(xMoeda(NEWSE5->E5_VLDESCO,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
					nJuros+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLJUROS,Round(xMoeda(NEWSE5->E5_VLJUROS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
					nMulta+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLMULTA,Round(xMoeda(NEWSE5->E5_VLMULTA,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
					nJurMul+= nJuros + nMulta
					nCM+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLCORRE,Round(xMoeda(NEWSE5->E5_VLCORRE,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))

					If lPccBaixa .and. Empty(NEWSE5->E5_PRETPIS) .And. Empty(NEWSE5->E5_PRETCOF) .And. Empty(NEWSE5->E5_PRETCSL) .And. cCarteira == "P" 
						If nRecSE2 > 0 
						
							aAreabk  := Getarea()
							aAreaSE2 := SE2->(Getarea())
							SE2->(DbGoto(nRecSE2))
						
							nTotAbImp += (NEWSE5->E5_VRETPIS) + (NEWSE5->E5_VRETCOF) + (NEWSE5->E5_VRETCSL) + ;
										SE2->E2_INSS + SE2->E2_ISS + SE2->E2_IRRF
										
							Restarea(aAreaSE2)
							Restarea(aAreabk)
						Else
							nTotAbImp += (NEWSE5->E5_VRETPIS) + (NEWSE5->E5_VRETCOF) + (NEWSE5->E5_VRETCSL) + Iif( lMvGlosa , NEWSE5->E5_VRETIRF + NEWSE5->E5_VRETISS + NEWSE5->E5_VRETINS , 0 )
						Endif

						nVlrGlosa := nTotAbImp
					EndIf				

					If NEWSE5->E5_TIPODOC $ "VL/V2/BA/RA/PA/CP"
						nValTroco := 0                                          					
						cHistorico := NEWSE5->E5_HISTOR

						If mv_par11 == 2
							If cPaisLoc == "ARG" .and. !EMPTY(NEWSE5->E5_ORDREC)
								nValor += Iif(VAL(NEWSE5->E5_MOEDA)==mv_par12,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,VAL(NEWSE5->E5_MOEDA),mv_par12,NEWSE5->E5_DATA,nDecs+1,NEWSE5->E5_TXMOEDA),nDecs+1))
							Else
						 		If NEWSE5->E5_VLMOED2 > 0 .And. MovMoedEs(NEWSE5->E5_MOEDA, NEWSE5->E5_TIPODOC, NEWSE5->E5_MOTBX, DTOC(NEWSE5->E5_DATA))
						 			nValor += If(mv_par12 == 2, NEWSE5->E5_VALOR, NEWSE5->E5_VLMOED2) 
						 		Else 							 	
							 		nValor += Iif(mv_par12==nMoedaBco,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VLMOED2,SE2->E2_MOEDA,mv_par12,SE2->E2_BAIXA,nDecs+1,If(cPaisLoc=="BRA",nTaxa,0)),nDecs+1))
								EndIf
							Endif
						Else
							If cPaisLoc <> "BRA" .and. !EMPTY(NEWSE5->E5_ORDREC)
								nValor+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VLMOED2,VAL(NEWSE5->E5_MOEDA),mv_par12,NEWSE5->E5_DATA,nDecs+1,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
							Else
						 		If NEWSE5->E5_VLMOED2 > 0 .And. MovMoedEs(NEWSE5->E5_MOEDA, NEWSE5->E5_TIPODOC, NEWSE5->E5_MOTBX, DTOC(NEWSE5->E5_DATA))
						 			nValor += If(mv_par12 == 2, NEWSE5->E5_VALOR, NEWSE5->E5_VLMOED2) 
						 		Else 
						 			nValor += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VLMOED2,SE1->E1_MOEDA,mv_par12,SE1->E1_BAIXA,nDecs+1,If(cPaisLoc=="BRA",nTaxa,0)),nDecs+1))	
						 		EndIf 
						 	EndIf
						EndIf						

						If lMVLjTroco
							lTroco := If(Substr(NEWSE5->E5_HISTOR,1,3)=="LOJ",.T.,.F.)
							If lTroco						
								nRecnoSE5 := SE5->(Recno())
								DbSelectArea("SE5")
								DbSetOrder(7)
								If dbSeek(xFilial("SE5")+NEWSE5->E5_PREFIXO+NEWSE5->E5_NUMERO+NEWSE5->E5_PARCELA+Space(TamSX3("E5_TIPO")[1])+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									While !Eof() .AND. xFilial("SE5") == SE5->E5_FILIAL .AND. NEWSE5->E5_PREFIXO+NEWSE5->E5_NUMERO+NEWSE5->E5_PARCELA+Space(TamSX3("E5_TIPO")[1])+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA == SE5->E5_PREFIXO+;
														SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA
										
										If SE5->E5_MOEDA = "TC" .AND. SE5->E5_TIPODOC = "VL" .AND.;
											SE5->E5_RECPAG = "P" 
											nValTroco := SE5->E5_VALOR
										EndIf  
										SE5->(DbSkip())				    					
									EndDo
								EndIf
								SE5->(DbGoTo(nRecnoSE5)) 			   
							Endif
                        Endif                                                              
                        
						dbSelectArea("NEWSE5") 										
						
						nValor -= nValTroco

						//Pcc Baixa CR
						If cCarteira == "R" .and. lPccBxCr .and. cPaisLoc == "BRA" .And. (IiF(lRaRtImp,NEWSE5->E5_TIPO $ MVRECANT,.T.) .OR. lPccBaixa)
							If Empty(NEWSE5->E5_PRETPIS) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETPIS,Round(xMoeda(NEWSE5->E5_VRETPIS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif						
							If Empty(NEWSE5->E5_PRETCOF) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETCOF,Round(xMoeda(NEWSE5->E5_VRETCOF,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif						
							If Empty(NEWSE5->E5_PRETCSL) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETCSL,Round(xMoeda(NEWSE5->E5_VRETCSL,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif											
						Endif

					Else
						nVlMovFin+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
						cHistorico := Iif(Empty(NEWSE5->E5_HISTOR),"MOV FIN MANUAL",NEWSE5->E5_HISTOR)
						cNatureza  	:= NEWSE5->E5_NATUREZ
					Endif	

					cAuxFilNome := cFilAnt + " - "+ cFilNome
					cAuxCliFor  := cCliFor					    
					cAuxLote    := E5_LOTE
					dAuxDtDispo := E5_DTDISPO

					Exit
				EndDO
	
				If (nDesc+nValor+nJurMul+nVlMovFin) > 0    
					AAdd(aRet, Array(32))

					// Defaults >>>
					aRet[Li][01] := ""
					aRet[Li][02] := ""
					aRet[Li][03] := ""
					aRet[Li][04] := ""
					aRet[Li][05] := ""
					aRet[li][32] := ""
					// <<< Defaults
					
					aRet[Li][22] := cAuxFilNome
					aRet[Li][23] := cAuxCliFor
					aRet[Li][24] := cAuxLote
					aRet[Li][25] := dAuxDtDispo
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ C lculo do Abatimento        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cCarteira == "R" .and. !lManual
						dbSelectArea("SE1")
						nRecno := Recno()
						nAbat := 0
						nAbatLiq := 0
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Entra no if abaixo se titulo totalmente baixado e se for a maior
						// sequnecia de baixa no SE5 
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .and. Empty(SE1->E1_SALDO) .and.;
						    cMaxSeq == cSeq //NEWSE5->E5_SEQ
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Calcula o valor total de abatimento do titulo e impostos se houver ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							nTotAbImp  := 0  
							nAbat := SumAbatRec(cPrefixo,cNumero,cParcela,SE1->E1_MOEDA,"V",dBaixa,@nTotAbImp)
							nAbatLiq := nAbat - nTotAbImp

							cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
                                                                      
							SA1->(DBSetOrder(1))
							If cPaisLoc == "BRA" .And. SA1->(DBSeek(xFilial("SA1")+cCliFor190) )
								lCalcIRF := SA1->A1_RECIRRF == "1" .and. SA1->A1_IRBAX == "1" // se for na baixa 
							Else
								lCalcIRF := .F.	
							EndIf	
							If lCalcIRF .And. !lMvGlosa
								nTotAbImp += SE1->E1_IRRF
							EndIf							
						EndIf
						dbSelectArea("SE1")
						dbGoTo(nRecno)
					Elseif !lManual
						dbSelectArea("SE2")
						nRecno := Recno()
						nAbat := 0
						nAbatLiq := 0						
						If !SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. Empty(SE2->E2_SALDO) .and.;
						    cMaxSeq == cSeq //NEWSE5->E5_SEQ
							nAbat :=	SomaAbat(cPrefixo,cNumero,cParcela,"P",mv_par12,,cFornece,cLoja)
							nAbatLiq := nAbat	
						EndIf			
						dbSelectArea("SE2")
						dbGoTo(nRecno)
					EndIF
					aRet[li][05]:= " "
					aRet[Li][32]:= " "
					IF mv_par11 == 1 .and. aTam[1] > 6 .and. !lManual
						If lBxTit
							aRet[li][05] := SE1->E1_CLIENTE
							aRet[Li][32] := SE1->E1_LOJA
						Endif
						aRet[li][06] := AllTrim(cCliFor)
					Elseif mv_par11 == 2 .and. aTam[1] > 6 .and. !lManual
						If lBxTit
							aRet[li][05] := SE2->E2_FORNECE
							aRet[Li][32] := SE2->E2_LOJA
						Endif
						aRet[li][06] := AllTrim(cCliFor)
					Endif
	
					aRet[li][01] := cPrefixo
					aRet[li][02] := cNumero
					aRet[li][03] := cParcela
					aRet[li][04] := cTipo		
	
					If !lManual
						dbSelectArea("TRB")
						lOriginal := .T.
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Baixas a Receber             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If cCarteira == "R"
							cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
							nVlr := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par12,SE1->E1_BAIXA,nDecs+1,If(cPaisLoc=="BRA",nTaxa,0)),nDecs+1)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Baixa de PA                  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Else
							cCliFor190 := SE2->E2_FORNECE+SE2->E2_LOJA
                                                                      
							If cPaisLoc=="BRA"
								lCalcIRF:= Posicione("SA2",1,xFilial("SA2")+cCliFor190,"A2_CALCIRF") == "1" .Or.;//1-Normal, 2-Baixa
								    	   Posicione("SA2",1,xFilial("SA2")+cCliFor190,"A2_CALCIRF") == " "
							Else 
								lCalcIRF:=.f.
							EndIf

							// MV_MRETISS "1" retencao do ISS na Emissao, "2" retencao na Baixa.
					   		nVlr := Round(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par12,SE2->E2_BAIXA,nDecs+1,If(cPaisLoc=="BRA",nTaxa,0)),nDecs+1)
					   		
							If lConsImp   //default soma os impostos no valor original
								nVlr += SE2->E2_INSS+ Iif(GetNewPar('MV_MRETISS',"1")=="1",SE2->E2_ISS,0) +;
									   	Iif(lCalcIRF,SE2->E2_IRRF,0)
								If ! lPccBaixa  // SE PCC NA EMISSAO SOMA PCC
									nVlr += SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSL
								EndIf
							EndIf

							If mv_par12 > 1
								nVlr := Round(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par12,SE2->E2_BAIXA,nDecs+1,If(cPaisLoc=="BRA",nTaxa,0)),nDecs+1)
							Endif
						Endif
						aRet[li,28] := nRecSE5
						dbgoto(nRecSe5)
						cFilTrb := If(cCarteira=="R","SE1","SE2")
						IF DbSeek( xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo)
							nAbat:= 0
							lOriginal := .F.
						Else
							If cMaxSeq == cSeq
								RecLock("TRB",.T.)
								Replace linha With xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo
								MsUnlock()
							EndIf
						EndIF
					Else
						dbSelectArea("SE5")
						aRet[li,28] := nRecSE5
						dbgoto(nRecSe5)
						nVlr := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par12,E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",nTaxa,0)),nDecs+1)
						
						nAbat:= 0
						lOriginal := .t.
						nRecSe5	:= NEWSE5->SE5RECNO
						dbSelectArea("TRB")
					Endif
					IF cCarteira == "R"
						If ( !lManual )
							If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
								cHistorico := Iif(Empty(cHistorico), SE1->E1_HIST, cHistorico )
							Else
								cHistorico := Iif(Empty(SE1->E1_HIST), cHistorico, SE1->E1_HIST )
							Endif
						EndIf
						If aTam[1] <= 6 .and. !lManual
							If lBxTit
								aRet[li][05] := SE1->E1_CLIENTE
								aRet[li][32] := SE1->E1_LOJA
							Endif
							aRet[li][06] := AllTrim(cCliFor)
						Endif
						cMascNat := MascNat(cNatureza)
						aRet[li][07] := If(Len(Alltrim(cNatureza))>8, cNatureza, cMascNat)  
						If Empty( dDtMovFin ) .or. dDtMovFin == Nil
							dDtMovFin := CtoD("  /  /  ")
						Endif
						aRet[li][08] := IIf(lManual,dDtMovFin,SE1->E1_VENCREA) //Vencto
						aRet[li][09] := AllTrim(cHistorico)
						aRet[li][10] := dBaixa
						IF nVlr > 0
							aRet[li][11] := nVlr // Picture tm(nVlr,14,nDecs)
						Endif
					Else
						If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
							cHistorico := Iif(Empty(cHistorico), SE2->E2_HIST, cHistorico )
						Else
							cHistorico := Iif(Empty(SE2->E2_HIST), cHistorico, SE2->E2_HIST )
						Endif
						If aTam[1] <= 6 .and. !lManual
							If lBxTit
								aRet[li][05] := SE2->E2_FORNECE
								aRet[li][32] := SE2->E2_LOJA
							Endif
							aRet[li][06] := AllTrim(cCliFor)
						Endif
						cMascNat := MascNat(cNatureza)
						aRet[li][07] := If(Len(Alltrim(cNatureza))>8, cNatureza, cMascNat)  
						If Empty( dDtMovFin ) .or. dDtMovFin == Nil
							dDtMovFin := CtoD("  /  /  ")
						Endif
						aRet[li][08] := IIf(lManual,dDtMovFin,SE2->E2_VENCREA)
						If !Empty(cCheque)
							aRet[li][09] := ALLTRIM(cCheque)+"/"+Trim(cHistorico)
						Else
							aRet[li][09] := ALLTRIM(cHistorico)
						EndIf
						aRet[li][10] := dBaixa
						IF nVlr > 0
							aRet[li][11] := nVlr //Picture tm(nVlr,14,nDecs)
						Endif
					Endif
					nCT++
					aRet[li][12] := nJurMul    //PicTure tm(nJurMul,11,nDecs)
										
					If cCarteira == "R" .and. mv_par12 == SE1->E1_MOEDA					
					   aRet[li][13] := 0
					
					ElseIf cCarteira == "P" .and. mv_par12 == SE2->E2_MOEDA
					   aRet[li][13] := 0
					   
					Else					   
					   aRet[li][13] := nCM        //PicTure tm(nCM ,11,nDecs)
					Endif

					//PCC Baixa CR
					//Somo aos abatimentos de impostos, os impostos PCC na baixa.
					//Caso o calculo do PCC CR seja pela emissao, esta variavel estara zerada
					//O sistema encontra duas vezes o valor de impostos por conta do parâmetro mv_glosa, portanto é necessário somar apenas um deles
					If lMvGlosa .And. cCarteira == "R" .And. Empty( nTotAbImp ) .And. nVlrGlosa > 0 .And. nVlrGlosa > nPccBxCr
						nTotAbImp := nVlrGlosa
					ElseIf !lMvGlosa
						nTotAbImp := nTotAbImp + nPccBxCr
					EndIf

					aRet[li][14] := nDesc       //PicTure tm(nDesc,11,nDecs)
					aRet[li][15] := nAbatLiq   	//Picture tm(nAbatLiq,11,nDecs) 
					aRet[li][16] := nTotAbImp 	//Picture tm(nTotAbImp,11,nDecs)
					
					If nVlMovFin > 0
						aRet[li][17] := nVlMovFin     //PicTure tm(nVlMovFin,15,nDecs)
					Else
						aRet[li][17] := nValor			//PicTure tm(nValor,15,nDecs)
					Endif
					aRet[li][18] := cBanco
					aRet[li][30] := cAge
					aRet[li][31] := cContaBco
					If Len(DtoC(dDigit)) <= 8
						aRet[li][19] := dDigit
					Else                   
						aRet[li][19] := dDigit
					EndIf
	
					If empty(cMotBaixa)
						cMotBaixa := "NOR"  //NORMAL
					Endif
	
					aRet[li][20] := Substr(cMotBaixa,1,3)
					aRet[li][21] := cFilorig
					
					aRet[li][26] := lOriginal 
					aRet[li][27] := If( nVlMovFin <> 0, nVlMovFin, If( MovBcoBx( cMotBaixa ), nValor, 0 ))
					aRet[li][29] := aRet[li][27] = 0
					nTotOrig   += If( lOriginal, nVlr, 0 )
					nTotBaixado+= If(cTipodoc $ "CP/BA" .AND. cMotBaixa $ "CMP/FAT",0,nValor)		// n„o soma, j  somou no principal
					nTotDesc   += nDesc
					nTotJurMul += nJurMul
					nTotCM     += nCM
					nTotAbLiq  += nAbatLiq
					nTotImp    += nTotAbImp
					nTotValor  += If( nVlMovFin <> 0, nVlMovFin , If( MovBcoBx ( cMotBaixa ), nValor, 0 ))
					nTotMovFin += nVlMovFin
					nTotComp   += If(cTipodoc == "CP",nValor,0)
					nTotFat    += If(cMotBaixa $ "FAT",nValor,0)
					nDesc := nJurMul := nValor := nCM := nAbat := nTotAbImp := nAbatLiq := nVlMovFin := 0
					nPccBxCr	:= 0		//PCC Baixa CR
					li++
				Endif
				
				dbSelectArea("NEWSE5")
				NEWSE5->(DbSkip())
				If lManual
					Exit
				EndIf
			Enddo

			If (nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8)
				cQuebra := DtoS(cAnterior)
			Else //nOrdem == 2 .or. nOrdem == 3 .or. nOrdem == 4 .or. nOrdem == 5 .or. nOrdem == 7
				cQuebra := cAnterior
			EndIf

			If (nTotValor+nDesc+nJurMul+nCM+nTotOrig+nTotMovFin+nTotComp+nTotFat)>0
				If nCT > 0
						If nTotBaixado > 0
							AAdd(aTotais,{cQuebra,STR0028,nTotBaixado})  //"Baixados"
						Endif	
						If nTotMovFin > 0
							AAdd(aTotais,{cQuebra,STR0031,nTotMovFin})  //"Mov Fin."
						Endif
						If nTotComp > 0
							AAdd(aTotais,{cQuebra,STR0037,nTotComp})  //"Compens."
						Endif
						If nTotFat > 0
							AAdd(aTotais,{cQuebra,STR0076,nTotFat})  //"Bx.Fatura"
						Endif						
				Endif
			Endif      
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Incrementa Totais Gerais ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nGerBaixado += nTotBaixado
			nGerMovFin	+= nTotMovFin
			nGerComp	+= nTotComp
			nGerFat		+= nTotFat

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Incrementa Totais Filial ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nFilOrig	+= nTotOrig
			nFilValor	+= nTotValor
			nFilDesc	+= nTotDesc
			nFilJurMul	+= nTotJurMul
			nFilCM		+= nTotCM
			nFilAbLiq	+= nTotAbLiq 
			nFilAbImp	+= nTotImp 		
			nFilBaixado += nTotBaixado
			nFilMovFin	+= nTotMovFin
			nFilComp	+= nTotComp 
			nFilFat     += nTotFat
		Enddo
	Endif	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir TOTAL por filial somente quan-³
	//³ do houver 1 filial ou mais.            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if mv_par17 == 1 .and. SM0->(Reccount()) >= 1
		If nFilBaixado > 0 
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), STR0028, nFilBaixado } )  //"Baixados"
		Endif
		If nFilMovFin > 0
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), STR0031, nFilMovFin } )  //"Mov Fin."
		Endif
		If nFilComp > 0
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), STR0037, nFilComp } )  //"Compens."
		Endif
		If nFilFat > 0
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), STR0076, nFilFat } )  //"Compens."
		Endif
		
		If mv_par17 == 2 .And. Empty(xFilial("SE5"))
			Exit
		Endif	

		nFilOrig:=nFilJurMul:=nFilCM:=nFilDesc:=nFilAbLiq:=nFilAbImp:=nFilValor:=0
		nFilBaixado:=nFilMovFin:=nFilComp:=nFilFat:=0
	Endif
	dbSelectArea("SM0")
	cCodUlt := SM0->M0_CODIGO
	cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	SM0->(dbSkip())
Enddo

If nGerBaixado > 0
	AAdd(aTotais,{STR0075,STR0028,nGerBaixado})  //"Baixados"
Endif	
If nGerMovFin > 0
	AAdd(aTotais,{STR0075,STR0031,nGerMovFin})  //"Mov Fin."
Endif
If nGerComp > 0
	AAdd(aTotais,{STR0075,STR0037,nGerComp})  //"Compens."
EndIf                             
If nGerFat > 0
	AAdd(aTotais,{STR0075,STR0076,nGerFat})  //"Bx.Fatura"
EndIf                             

SM0->(dbgoto(nRecEmp))                                                                            
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
If(_oFINR190 <> NIL)

	_oFINR190:Delete()
	_oFINR190 := NIL

EndIf
dbSelectArea("NEWSE5")
dbCloseArea() 

/* GESTAO - inicio */
If !Empty(cTmpSE5Fil)
	CtbTmpErase(cTmpSE5Fil)
Endif
/* GESTAO - fim */

If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif
dbSelectArea("SE5")
dbSetOrder(1)

Return aRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FR190MovCan³ Autor ³ Marcelo Celi Marques ³ Data ³ 05.10.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se o registro selecionado pertente a um titulo    ³±± 
±±³          ³ cuja baixa foi cancelada, mas, que gerou mov bancario      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FR190MovCan(nIndexSE5,_SE5)								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nIndexSE5 - Filtro provisório criado no inicio da rotina	  ³±± 
±±³          ³ E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ    >>	  ³±± 
±±³          ³ +E5_TIPODOC+E5_SEQ                                   	  ³±±
±±³          ³ 															  ³±± 
±±³          ³ _SE5 - Nome da tabela temporária do SE5 gerada       	  ³±±
±±³          ³ no inicio da rotina										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINR190/FINR199											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FR190MovCan(nIndexSE5,_SE5)
	Local lRet := .F.
	Local aAreaSE5 := (_SE5)->(GetArea())
	
	If Empty((_SE5)->E5_MOTBX)
		dbSelectArea("SE5")
		dbSetOrder(nIndexSE5)
		If dbSeek((_SE5)->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+"EC"+E5_SEQ))
			lRet := .T.
		Endif
		dbSelectArea(_SE5)
		RestArea(aAreaSE5)
	Endif	
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} FR190InFilial

Formata uma string com todas as filiais selecionadas pelo usuario,
para que seja usada no parametro "IN" da query

@author daniel.mendes

@since 05/05/2014
@version P1180
 
@return Retorna uma string com as filiais selecionadas
/*/
//-------------------------------------------------------------------
Static Function FR190InFilial()
Local cRetornoIn := ""
Local nFor := 0

	For nFor := 1 To Len(aSelFil)
		cRetornoIn += aSelFil[nFor] + '|' 
	Next nFor

Return " IN " + FormatIn( SubStr( cRetornoIn , 1 , Len( cRetornoIn ) -1 ) , '|' )

//-------------------------------------------------------------------
/*/{Protheus.doc} FR190MaxSeq

Busca a maior sequência de baixa válida (Que não foi estornada)

@author  renato.ito
@since   14/15/2019
@version P12

@return MAX E5_SEQ válido
/*/
//-------------------------------------------------------------------

Static Function FR190MaxSeq(cQFil, cQPre, cQNum, cQPar, cQTip, cQCliFor, cQLoj, cQRecPag, cQSit, cQNat)
Local aArea			:= GetArea()
Local cAliasSeq		:= GetNextAlias()
Local cSequencia	:= ""


BeginSQL Alias cAliasSeq

	SELECT MAX(E5_SEQ) SEQ
		FROM 
			%Table:SE5% SE5
		WHERE 
			SE5.E5_FILIAL = %Exp:cQFil%
			AND SE5.E5_PREFIXO = %Exp:cQPre%
			AND SE5.E5_NUMERO = %Exp:cQNum%
			AND SE5.E5_PARCELA = %Exp:cQPar%
			AND SE5.E5_TIPO = %Exp:cQTip%
			AND SE5.E5_CLIFOR = %Exp:cQCliFor%
			AND SE5.E5_LOJA = %Exp:cQLoj%
			AND SE5.E5_RECPAG =%Exp:cQRecPag%
			AND SE5.E5_SITUACA = %Exp:cQSit%
			AND SE5.E5_NATUREZ = %Exp:cQNat%
			AND SE5.E5_SITUACA NOT IN ('C','E','X')
			AND SE5.%NotDel%
			AND NOT EXISTS 
				(SELECT A.E5_NUMERO
				FROM 
					%Table:SE5% A
				WHERE 
					A.E5_FILIAL = SE5.E5_FILIAL
					AND A.E5_PREFIXO = SE5.E5_PREFIXO
					AND A.E5_NUMERO = SE5.E5_NUMERO
					AND A.E5_PARCELA = SE5.E5_PARCELA
					AND A.E5_TIPO = SE5.E5_TIPO
					AND A.E5_CLIFOR = SE5.E5_CLIFOR
					AND A.E5_LOJA = SE5.E5_LOJA
					AND A.E5_SEQ = SE5.E5_SEQ
					AND A.E5_TIPODOC = 'ES'
				)
EndSQL

If !(cAliasSeq)->(Eof())
	cSequencia := (cAliasSeq)->SEQ
EndIf

(cAliasSeq)->(DbCloseArea())

RestArea(aArea)

Return cSequencia