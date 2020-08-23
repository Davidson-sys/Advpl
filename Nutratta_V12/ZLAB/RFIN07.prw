#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "topconn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "parmtype.ch"

STATIC __aUserLg := {}

#DEFINE  _CRLF  CHR(13)+CHR(10)


 /*/{Protheus.doc} RFIN07
Relação de baixas contas a pagar por centro de custo.
@type  RFIN07
@author Davidson.Carvalho
@since 06/05/2020
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function RFIN07()

    Local oReport

    Private nRegTmp   := 0
    Private cArqTrab  := ""
    Private cArqTSA3  := ""
    Private cArqTSM0  := ""
    Private cIndTSA3  := Space(08)
    Private cIndTSM0  := Space(08)
    Private cIndTrb1  := Space(08)


//-----------------------------------------------------------------------------------
//-- Wizard com os parametros para o relatorio
//-----------------------------------------------------------------------------------
    FIN07WIZARD()

Return



 /*/{Protheus.doc} FIN07WIZARD
    Carrega o Wizard com os parametros necessarios para o relatório.
    @type  Static
    @author Davidson.Carvalho
    @since 06/05/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function FIN07WIZARD()

    Local cTexto1   := ""
    Local cTexto2   := ""
    Local cTexto3   := ""
    Local cTexTit   := ""
    Local cTexTit1  := "Gerados:   Titulos incluídos (Manualmente) ou gerados pelo Documento de entrada (Fiscal)."
    Local cTexTit2  := "Baixados:  Titulos baixados onde gerou-se movimentação bancária."
    Local cTexTit3  := "Ambos:     Titulos incluídos e títulos baixados onde gerou-se movimentação bancária."
    Local cMsgErro	:= "Erros encontrados emissao do relatorio " +_CRLF + _CRLF
    Local cMatriz	:= Space(CtbTamFil("033",2))
    Local aTexto    := {}
    Local aTxtPre 	:= {}

    Private oWizard
    Private cTipo   :=  ""
    Private cGet1   :=  ""          // Variavel do tipo caracter
    Private cErros	:=  ""
    Private cCamArq	:=  ""
    Private aTipos  :=  {"Gerados","Baixados","Ambos"}
    Private cMessage:=  "Processo finalizado...!"
    Private nGet2   := 0           // Variável do tipo numérica
    Private dGet1   := Date()      // Data da emissão incial
    Private dGet2   := Date()      // Data da emissão final
    Private dGet3   := Date()      // Data da baixa incial
    Private dGet4   := Date()      // Data da baixa final
    Private dGet5   := Date()      // Data Periodo incial
    Private dGet6   := Date()      // Data Periodo final
    Private cArq2	:= Space(200)
    Private cArq3	:= Space(200)
    Private cMesAno	:= Space(07)

    Private lContinua   := .T.
    Private lHasButton  := .T.

//-----------------------------------------------------------------------------------
//-- Monta wizard com as perguntas necessarias
//-----------------------------------------------------------------------------------
    aAdd(aTxtPre,"Relação de baixas contas a pagar por centro de custo") //1
    aAdd(aTxtPre,"Atenção")      //2
    aAdd(aTxtPre,"Informe os parâmetros para geração do relatório.")//3
    aAdd(aTxtPre,"Finalização da geração.")   //4

    cTexto1 := "Esta rotina tem como objetivo gerar o relatório de contas a pagar Nutratta "
    cTexto2 := "por centro de custo e natureza,detalhando os produtos contidos na nota fiscal."
    cTexto3 := "Os valores de encargos dos titulos serão rateados de acordo com o total de itens contidos na nota fiscal."

    aAdd(aTexto,cTexto1+cTexto2+cTexto3)

//--P1
    DEFINE WIZARD oWizard ;
        TITLE aTxtPre[1];
        HEADER aTxtPre[2];
        MESSAGE aTxtPre[1];
        TEXT aTexto[1] ;
    NEXT {|| .T.} ;
    FINISH {|| .T.} ;


//--P2
CREATE PANEL oWizard  ;
    HEADER aTxtPre[3] ;
    MESSAGE ""	;
    BACK {|| .T.} ;
    NEXT {|| Iif(fValNext(),fPrint(cTipo),.F.)} ;  //chama a função para impressão do relatório.
PANEL

//-----------------------------------------------------------------------------------
//-- Parametros do Painel 2
//-----------------------------------------------------------------------------------    
TSay():New(010,018,{||" Emitir o relatório com base em títulos: "},oWizard:oMPanel[2],,,,,,.T.,CLR_HBLUE,CLR_WHITE,150,010)
TComboBox():New(009,115,{|u|if(PCount()>0,cTipo:=u,cTipo)},aTipos,100,010,oWizard:oMPanel[2],,,,,,.T.,,,,,,,,,'cTipo')

TSay():New(040,020,{||"Da emissão: "},oWizard:oMPanel[2],,,,,,.T.,CLR_HBLUE,CLR_WHITE,070,010)
TGet():New(038,065,{|u|If( PCount() == 0, dGet1, dGet1 := u ) },oWizard:oMPanel[2],060,010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.T.,,.F.,.F. ,,"dGet1",,,,)

TSay():New(040,145,{||"Até emissão: "},oWizard:oMPanel[2],,,,,,.T.,CLR_HBLUE,CLR_WHITE,070,010)
TGet():New(038,185,{|u|If( PCount() == 0, dGet2, dGet2 := u ) },oWizard:oMPanel[2],060,010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dGet2",,,,)

TSay():New(060,020,{||"Da Baixa: "},oWizard:oMPanel[2],,,,,,.T.,CLR_HBLUE,CLR_WHITE,070,010)
TGet():New(058,065,{|u|If( PCount() == 0, dGet3, dGet3 := u ) },oWizard:oMPanel[2],060,010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dGet3",,,,)

TSay():New(060,145,{||"Até a baixa: "},oWizard:oMPanel[2],,,,,,.T.,CLR_HBLUE,CLR_WHITE,070,010)
TGet():New(058,185,{|u|If( PCount() == 0, dGet4, dGet4 := u ) },oWizard:oMPanel[2],060,010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dGet4",,,,)

TSay():New(080,020,{||"Período de : "},oWizard:oMPanel[2],,,,,,.T.,CLR_HBLUE,CLR_WHITE,070,010)
TGet():New(078,065,{|u|If( PCount() == 0, dGet5, dGet5 := u ) },oWizard:oMPanel[2],060,010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dGet5",,,,)

TSay():New(080,145,{||"Período até: "},oWizard:oMPanel[2],,,,,,.T.,CLR_HBLUE,CLR_WHITE,070,010)
TGet():New(078,185,{|u|If( PCount() == 0, dGet6, dGet6 := u ) },oWizard:oMPanel[2],060,010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dGet6",,,,)

TSay():New(107,040,{||cTexTit1},oWizard:oMPanel[2],,,,,,.T.,CLR_HRED,CLR_WHITE,250,010)
TSay():New(117,040,{||cTexTit2},oWizard:oMPanel[2],,,,,,.T.,CLR_HRED,CLR_WHITE,250,010)
TSay():New(127,040,{||cTexTit3},oWizard:oMPanel[2],,,,,,.T.,CLR_HRED,CLR_WHITE,250,010)


CREATE PANEL oWizard  ;
    HEADER aTxtPre[4] ;
    MESSAGE ""	;
    BACK {|| .F.} ;
    FINISH {|| .T.} ;
    PANEL

@ 030,010 SAY cMessage SIZE 270,020 COLOR CLR_BLUE PIXEL OF oWizard:oMPanel[3]

ACTIVATE WIZARD oWizard CENTERED

If !Empty(AllTrim(cErros))

    cMsgErro += cErros

    Aviso("Erros Importação",cMsgErro,{"Voltar"},3)
EndIf


Return

/*/{Protheus.doc} fPrint
Função para geração do relatorio
    @type  Static Function
    @author Davidson.carvalho
    @since 06/05/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fPrint(cTipo)

    Local oReport

    Private nRegTmp   := 0
    Private cArqTrab  := ""
    Private cArqTSA3  := ""
    Private cArqTSM0  := ""
    Private cIndTrb1  := Space(08)
    Private cIndTSA3  := Space(08)
    Private cIndTSM0  := Space(08)

//-----------------------------------------------------------------------------------
//-- Interface de impressao
//-----------------------------------------------------------------------------------

    oReport := ReportDef()
    oReport:PrintDialog()

Return


/*/{Protheus.doc} ReportDef
    A funcao estatica ReportDef devera ser criada para todos os
    relatorios que poderao ser agendados pelo usuario. 
    @type  Function
    @author Davidson.carvalho
    @since 06/05/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
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
    oReport:= TReport():New("RFIN07","Relação de baixas Nutrata","RFIN07", {|oReport| ReportPrint(oReport)},"Relação de baixas Nutrata")
    oReport:SetLandscape()
//oReport:SetTotalInLine(.F.)

//Pergunte(oReport:uParam,.F.)

//oSection1 := TRSection():New(oReport,"Relacao de Faturamento por Filial",{"SF2","DTC","SE4","DA3","DA4" }) 
    oSection1 :=TRSection():New(oReport,"Relação de baixas Nutrata")
    oSection1 :SetTotalInLine(.F.)
    oSection1 :SetHeaderPage()
    oSection1 :SetTotalText("Total Geral") //"Total Geral "

    TRCell():New(oSection1,"CCODFIL"	,"","Filial"		 ,"@!"	  					,04,/*lPixel*/	,{|| cCodFili })
    TRCell():New(oSection1,"CPREFIX"	,"","Prefixo"		 ,"@!"	  					,03,/*lPixel*/	,{|| cPrefix })
    TRCell():New(oSection1,"CNUMERO"	,"","Numero"    	 ,"@!"	  					,09,/*lPixel*/	,{|| cNum })
    TRCell():New(oSection1,"CTIPO"  	,"","Tipo"      	 ,"@!"	  					,03,/*lPixel*/	,{|| _cTipo })
    TRCell():New(oSection1,"CCODFOR"  	,"","Fornecedor"   	 ,"@!"	  					,08,/*lPixel*/	,{|| cCodFor })
    TRCell():New(oSection1,"CLOJA"		,"","Loja"		 	 ,"@!"	  					,02,/*lPixel*/	,{|| cLoja })
    TRCell():New(oSection1,"CNOMFOR"  	,"","Fornecedor"   	 ,"@!"	  					,60,/*lPixel*/	,{|| cNomFor })
    TRCell():New(oSection1,"CITEMNF"  	,"","Item NF"   	 ,"@!"	  					,05,/*lPixel*/	,{|| cItem })
    TRCell():New(oSection1,"CPROD"  	,"","Produto"   	 ,"@!"	  					,15,/*lPixel*/	,{|| cProd })
    TRCell():New(oSection1,"CDESPRD"  	,"","Descrição"   	 ,"@!"	  					,30,/*lPixel*/	,{|| cDesPrd })
    TRCell():New(oSection1,"CUNID"  	,"","Unidade"   	 ,"@!"	  					,02,/*lPixel*/	,{|| cUnid })
    TRCell():New(oSection1,"NQUANT"  	,"","Quant"			 ,"@E 9,999,999.999"		,11,/*lPixel*/	,{|| nQuant })
    TRCell():New(oSection1,"NVRUNIT"	,"","Vlr.Unit"		 ,"@E 999,999,999.99"		,12,/*lPixel*/	,{|| nVlrUnit })
    TRCell():New(oSection1,"NVRTOT" 	,"","Total Item"	 ,"@E 999,999,999.99"		,12,/*lPixel*/	,{|| nVlrTot })
    TRCell():New(oSection1,"NNPARC"		,"","Parcela"		 ,"@!"	  					,02,/*lPixel*/	,{|| nParc })
    TRCell():New(oSection1,"DEMIS"		,"","Emissao"    	 ,"@!"   					,10,/*lPixel*/	,{|| dEmissao })
    TRCell():New(oSection1,"DVENC"		,"","Vencto"    	 ,"@!"   					,10,/*lPixel*/	,{|| dVencOrig })
    TRCell():New(oSection1,"DBAIXA"		,"","Dt.Baixa"    	 ,"@!"   					,10,/*lPixel*/	,{|| dBaixa })
    TRCell():New(oSection1,"NVALORG"	,"","Vlr.Orig"		 ,"@E 999,999,999.99"		,12,/*lPixel*/	,{|| nVlrOrig })
    TRCell():New(oSection1,"NJUROS"	    ,"","Vlr.Juros"		 ,"@E 999,999,999.99"		,12,/*lPixel*/	,{|| nVlrJuros })
    TRCell():New(oSection1,"NMULTA"	    ,"","Vlr.Multa"		 ,"@E 999,999,999.99"		,12,/*lPixel*/	,{|| nVlrMulta })
    TRCell():New(oSection1,"NIMPOSTO"	,"","Vlr.Imposto"	 ,"@E 999,999,999.99"		,12,/*lPixel*/	,{|| nImposto })
    TRCell():New(oSection1,"NBAIXA" 	,"","Tot.Baixa"		 ,"@E 999,999,999.99"		,12,/*lPixel*/	,{|| nTotBx })
    TRCell():New(oSection1,"CNATUZ"  	,"","Natureza"   	 ,"@!"	  					,08,/*lPixel*/	,{|| cNatuz })
    TRCell():New(oSection1,"CDESNAT"  	,"","Desc.Nat"   	 ,"@!"	  					,30,/*lPixel*/	,{|| cDesNat })
    TRCell():New(oSection1,"CNATPAI"  	,"","Nat.Pai"   	 ,"@!"	  					,08,/*lPixel*/	,{|| cNatPai })
    TRCell():New(oSection1,"CDESPAI"  	,"","Desc.Pai"   	 ,"@!"	  					,30,/*lPixel*/	,{|| cDesPai })
    TRCell():New(oSection1,"CCENTRO"  	,"","Centro Custo" 	 ,"@!"	  					,08,/*lPixel*/	,{|| cCusto })
    TRCell():New(oSection1,"CDESCC"  	,"","Desc.CC"   	 ,"@!"	  					,30,/*lPixel*/	,{|| cDesCC })
    TRCell():New(oSection1,"CCPAI"  	,"","CC.Pai"    	 ,"@!"	  					,08,/*lPixel*/	,{|| cCPai })
    TRCell():New(oSection1,"CPAICC"  	,"","Desc.CC Pai"    ,"@!"	  					,30,/*lPixel*/	,{|| _cDesPai })
    TRCell():New(oSection1,"CCTABIL"  	,"","C.Contabil"   	 ,"@!"	  					,11,/*lPixel*/	,{|| cContab })
    TRCell():New(oSection1,"CDESTAB"  	,"","Desc Contabil"	 ,"@!"	  					,30,/*lPixel*/	,{|| cDesCtb })
    TRCell():New(oSection1,"CHIST"  	,"","Histórico"   	 ,"@!"	  					,30,/*lPixel*/	,{|| cHistori })

Return(oReport)



/*/{Protheus.doc} ReportPrint
    A funcao estatica ReportDef devera ser criada para todos os
    relatorios que poderao ser agendados pelo usuario.
    @type  Function
    @author Davidson Carvalho
    @since 06/05/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ReportPrint(oReport)

    Local oBreak
    Local oTotaliz
    Local oSection1 	:= oReport:Section(1)
    Local nTxMoeda		:= 1
    Local nRegTemp  	:= 0
    Local nXy           := 0
    Local lFirst    	:= .F.
    Local aFilsCalc  	:= {}
    Local aEmpresa   	:= {}

    Private cSelFil		:= ""
    Private cSelVen		:= ""
    Private cFilt		:= ""

    MsAguarde({ ||FGrvTmp07(cTipo) }, "Criando Arquivo de Trabalho...")  //-- Chamada da Funcao de Arquivo Temporarios

    oReport:SetTitle( oReport:Title()) //-- POR NUMERO"

    dbSelectArea("RFIN07")
    dbSetOrder(01)
    dbGoTop()

    oReport:SetMeter( nRegTMP )
    oSection1:Init()


    While ! oReport:Cancel() .And. ! RFIN07->( Eof() )


        If oReport:Cancel()

            Exit
        EndIf

        oReport:IncMeter()

        oSection1:Cell("CCODFIL"):SetValue(RFIN07->CCODFIL)
        oSection1:Cell("CPREFIX"):SetValue(RFIN07->CPREFIX)
        oSection1:Cell("CNUMERO"):SetValue(RFIN07->CNUMERO)
        oSection1:Cell("CTIPO"):SetValue(RFIN07->CTIPO)
        oSection1:Cell("CCODFOR"):SetValue(RFIN07->CCODFOR)
        oSection1:Cell("CLOJA"):SetValue(RFIN07->CLOJA)
        oSection1:Cell("CNOMFOR"):SetValue(RFIN07->CNOMFOR)
        oSection1:Cell("CITEMNF"):SetValue(RFIN07->CITEMNF)
        oSection1:Cell("CPROD"):SetValue(RFIN07->CPROD)
        oSection1:Cell("CDESPRD"):SetValue(RFIN07->CDESPRD)
        oSection1:Cell("CUNID"):SetValue(RFIN07->CUNID)
        oSection1:Cell("NQUANT"):SetValue(RFIN07->NQUANT)
        oSection1:Cell("NVRUNIT"):SetValue(RFIN07->NVRUNIT)
        oSection1:Cell("NVRTOT"):SetValue(RFIN07->NVRTOT)
        oSection1:Cell("NNPARC"):SetValue(RFIN07->NNPARC)
        oSection1:Cell("DEMIS"):SetValue(RFIN07->DEMIS) 
        oSection1:Cell("DVENC"):SetValue(RFIN07->DVENC)
        oSection1:Cell("DBAIXA"):SetValue(RFIN07->DBAIXA)
        oSection1:Cell("NVALORG"):SetValue(RFIN07->NVALORG)
        oSection1:Cell("NJUROS"):SetValue(RFIN07->NJUROS)
        oSection1:Cell("NMULTA"):SetValue(RFIN07->NMULTA)
        oSection1:Cell("NIMPOSTO"):SetValue(RFIN07->NIMPOSTO)
        oSection1:Cell("NBAIXA"):SetValue(RFIN07->NBAIXA)
        oSection1:Cell("CNATUZ"):SetValue(RFIN07->CNATUZ)
        oSection1:Cell("CDESNAT"):SetValue(RFIN07->CDESNAT)
        oSection1:Cell("CNATPAI"):SetValue(RFIN07->CNATPAI)
        oSection1:Cell("CDESPAI"):SetValue(RFIN07->CDESPAI)
        oSection1:Cell("CCENTRO"):SetValue(RFIN07->CCENTRO)
        oSection1:Cell("CDESCC"):SetValue(RFIN07->CDESCC)
        oSection1:Cell("CCPAI"):SetValue(RFIN07->CCPAI)
        oSection1:Cell("CPAICC"):SetValue(RFIN07->CPAICC)
        oSection1:Cell("CCTABIL"):SetValue(RFIN07->CCTABIL)
        oSection1:Cell("CDESTAB"):SetValue(RFIN07->CDESTAB)
        oSection1:Cell("CHIST"):SetValue(RFIN07->CHIST)

        oSection1:PrintLine()

        dbSelectArea("RFIN07")
        RFIN07->( dbSkip())

    End

//oSecTion1:Print()

    oSection1:Finish()

    dbSelectArea("RFIN07")
    dbCloseArea()

Return NIL


/*/{Protheus.doc} FGrvTmp07
    Gravação da tabela temporaria 
    @type  Function
    @author user
    @since 11/05/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function FGrvTmp07(cTipo)

    Local aStru     :={}
    Local aGrvDados :={}


//-----------------------------------------------------------------------------------
//-Monta a estrutua
//--------------------------------------------------------------------------------

    aadd(aStru,{"CCODFIL"	,"C" ,04 ,0})
    aadd(aStru,{"CPREFIX"	,"C" ,03 ,0})
    aadd(aStru,{"CNUMERO"	,"C" ,09 ,0})
    aadd(aStru,{"CTIPO"		,"C" ,03,0})
    aadd(aStru,{"CCODFOR"	,"C" ,08 ,0})
    aadd(aStru,{"CLOJA"		,"C" ,02 ,0})
    aadd(aStru,{"CNOMFOR"	,"C" ,60 ,0})
    aadd(aStru,{"CITEMNF"	,"C" ,05 ,0})
    aadd(aStru,{"CPROD"		,"C" ,15 ,0})
    aadd(aStru,{"CDESPRD"	,"C" ,30 ,0})
    aadd(aStru,{"CUNID"		,"C" ,02 ,0})
    aadd(aStru,{"NQUANT"	,"N" ,11 ,3})
    aadd(aStru,{"NVRUNIT"	,"N" ,12 ,2})
    aadd(aStru,{"NVRTOT"	,"N" ,12 ,2})
    aadd(aStru,{"NNPARC"	,"C" ,02 ,0})
    aadd(aStru,{"DEMIS"	    ,"D" ,08 ,0})
    aadd(aStru,{"DVENC"		,"D" ,08 ,0})
    aadd(aStru,{"DBAIXA"	,"D" ,08 ,0})
    aadd(aStru,{"NVALORG"	,"N" ,12 ,2})
    aadd(aStru,{"NJUROS"	,"N" ,12 ,2})
    aadd(aStru,{"NMULTA"	,"N" ,12 ,2})
    aadd(aStru,{"NIMPOSTO"	,"N" ,12 ,2})
    aadd(aStru,{"NBAIXA"	,"N" ,12 ,2})
    aadd(aStru,{"CNATUZ"	,"C" ,11 ,0})
    aadd(aStru,{"CDESNAT"	,"C" ,30 ,0})
    aadd(aStru,{"CNATPAI"	,"C" ,11 ,0})
    aadd(aStru,{"CDESPAI"	,"C" ,30 ,0})
    aadd(aStru,{"CCENTRO"	,"C" ,11 ,0})
    aadd(aStru,{"CDESCC"	,"C" ,30 ,0})
    aadd(aStru,{"CCPAI"		,"C" ,11 ,0})
    aadd(aStru,{"CPAICC"	,"C" ,30 ,0})
    aadd(aStru,{"CCTABIL"	,"C" ,11 ,0})
    aadd(aStru,{"CDESTAB"	,"C" ,30 ,0})
    aadd(aStru,{"CHIST"	 	,"C" ,50 ,0})

    cArqTrab  := CriaTrab(aStru)

    dbUseArea(.T.,, cArqTrab, "RFIN07", .F., .F. )

    IndRegua("RFIN07",cArqTrab,"CCODFIL",,,"Selecionando Registros...")

//-----------------------------------------------------------------------------------
//--Busca os dasos de acordo com o tipo selecionado
//-----------------------------------------------------------------------------------
    aGrvDados:= fBuscaDados(cTipo)


//-----------------------------------------------------------------------------------
//--Inicia a gravação 
//-----------------------------------------------------------------------------------

    For nXy:=1 To Len(aGrvDados)

        dbSelectArea("RFIN07")
        RecLock("RFIN07",.T.)

        Replace CCODFIL 	With    aGrvDados[nXy][1]
        Replace CPREFIX		With    aGrvDados[nXy][2]
        Replace CNUMERO	 	With    aGrvDados[nXy][3]
        Replace CTIPO		With    aGrvDados[nXy][4]
        Replace CCODFOR		With    aGrvDados[nXy][5]
        Replace CLOJA		With    aGrvDados[nXy][6]
        Replace CNOMFOR		With    aGrvDados[nXy][7]
        Replace NNPARC		With    aGrvDados[nXy][8]
        Replace DEMIS		With    Stod(aGrvDados[nXy][34])
        Replace DVENC		With    Stod(aGrvDados[nXy][9])
        Replace DBAIXA		With    Stod(aGrvDados[nXy][10])
        Replace NVALORG		With    aGrvDados[nXy][11]
        Replace NJUROS		With    aGrvDados[nXy][12]
        Replace NMULTA		With    aGrvDados[nXy][13]
        Replace NIMPOSTO	With    aGrvDados[nXy][14]+aGrvDados[nXy][15]
        Replace NBAIXA		With    aGrvDados[nXy][11]
        Replace CNATUZ		With    aGrvDados[nXy][17]
        Replace CHIST		With    aGrvDados[nXy][18]
        Replace CITEMNF		With    aGrvDados[nXy][19]
        Replace CPROD		With    aGrvDados[nXy][20]
        Replace CUNID		With    Upper(aGrvDados[nXy][21])
        Replace NQUANT		With    aGrvDados[nXy][22]
        Replace NVRUNIT		With    aGrvDados[nXy][23]
        Replace NVRTOT		With    aGrvDados[nXy][22] * aGrvDados[nXy][23]
        Replace CCENTRO		With    aGrvDados[nXy][24]
        Replace CCTABIL		With    aGrvDados[nXy][25]
        Replace CDESPRD		With    aGrvDados[nXy][26]
        Replace CDESNAT		With 	Upper(aGrvDados[nXy][27])
        Replace CNATPAI		With 	aGrvDados[nXy][28]
        Replace CDESPAI		With 	Upper(aGrvDados[nXy][29])
        Replace CDESCC		With 	Upper(aGrvDados[nXy][30])
        Replace CCPAI		With 	aGrvDados[nXy][31]
        Replace CPAICC		With 	aGrvDados[nXy][32]
        Replace CDESTAB		With 	Upper(aGrvDados[nXy][33])

        MsUnLock()
        nRegTMP++
    next nXy

    dbSelectArea("RFIN07")
    dbSetOrder(1)
    dbGoTop()

Return



 /*/{Protheus.doc} fBuscaDados
    Função para executar as querys de busca de dados.
    @type  Function
    @author Davidson Carvalho
    @since 12/05/2020
    @version version
    @param param_name, param_type, param_descr
    @return Retorna um array completo e calculado para posterior gravação.
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fBuscaDados(cTipo)

    Local   cQrySE5     := ""
    Local   cChaveSD1   := ""
    Local   cDescPrd    := ""
    Local   cDescNatF   := ""
    Local   cNatP       := ""
    Local   cDescNatP   := ""
    Local   cDesCC      := ""
    Local   cCCPai      := ""
    Local   cDesCCPai   := ""
    Local   cDesCTB     := ""
    Local   aStru       := {}
    Local   aItens      := {}
    Local   aTitulos    := {}
    Local   lGerado     :=.F.
    Local   lBaixado    :=.F.
    Local   lAmbos      :=.F.
    Local   cAliaSE5    := GetNextAlias()
    Local   cTipo       := cTipo
    Local   nYi         := 0
    Local   nOpc        := 0

//-----------------------------------------------------------------------------------
//--Analisa o tipo escolhido pelo usuário
//----------------------------------------------------------------------------------- 
    If 'Gerados' $ cTipo
        lGerado:=.T.

    Elseif 'Baixados' $ cTipo
        lBaixado:=.T.

    ElseIf 'Ambos' $ cTipo
        lAmbos:=.T.

    EndIf

//-----------------------------------------------------------------------------------
//--Gerados SE2 - Baixados SE5  - Ambos  SE2 SE5
//----------------------------------------------------------------------------------- 
    If lGerado

        cQrySE5 +=" SELECT E2_FILIAL,E2_PREFIXO,E2_NUM,E2_TIPO,E2_FORNECE,E2_LOJA,E2_NOMFOR,"
        cQrySE5 +=" E2_PARCELA,E2_VENCREA,E2_BAIXA,E2_VALOR,E2_JUROS,E2_MULTA,E2_ISS,E2_IRRF,"
        cQrySE5 +=" E2_SALDO,E2_NATUREZ,E2_E_NATUR,E2_HIST,E2_EMISSAO "
        cQrySE5 +=" FROM "+RetSqlName("SE2")+ " SE2"
        cQrySE5 +=" WHERE SE2.E2_FILIAL = '" + xFilial("SE2") + "' "
        cQrySE5 +=" AND E2_EMISSAO  BETWEEN '"+dToS(dGet1) +"' AND '"+dToS(dGet2)+"'"
        //cQrySE5+=" AND E2_TIPO IN ('NF') "
        //cQrySE5+=" AND E2_NUM IN ('000000195') "
        cQrySE5 +=" AND SE2.D_E_L_E_T_='' "

        cQrySE5 := ChangeQuery(cQrySE5)

        MemoWrite("RFIN07.SQL",cQrySE5)

        MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySE5),cAliaSE5,.T.,.T.)},"Selecionando Registros..." ) //"Selecionando Registros..."

    ElseIf lBaixado

        cQrySE5+=" SELECT E5_FILIAL,E5_DATA,E5_TIPO,E5_MOEDA,E5_VALOR,E5_NATUREZ,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ,E5_DOCUMEN,"
        cQrySE5+=" E5_VENCTO,E5_RECPAG,E5_BENEF,E5_HISTOR,E5_TIPODOC,E5_VLMOED2,E5_LA,E5_SITUACA,E5_LOTE,E5_PREFIXO,E5_NUMERO,E5_PARCELA,"
        cQrySE5+=" E5_CLIFOR,E5_LOJA,E5_DTDIGIT,E5_TIPOLAN,E5_DEBITO,E5_CREDITO,E5_MOTBX,E5_RATEIO,E5_RECONC,E5_SEQ,E5_DTDISPO,E5_CCD,E5_CCC,"
        cQrySE5+=" E5_OK,E5_ARQRAT,E5_IDENTEE,E5_ORDREC,E5_FILORIG,E5_ARQCNAB,E5_VLJUROS,E5_VLMULTA,E5_VLCORRE,E5_VLDESCO,E5_CNABOC,E5_SITUA,"
        cQrySE5+=" E5_ITEMD,E5_ITEMC,E5_CLVLDB,E5_CLVLCR,E5_PROJPMS,E5_EDTPMS,E5_TASKPMS,E5_MODSPB,E5_FATURA,E5_TXMOEDA,E5_FATPREF,E5_CODORCA,"
        cQrySE5+=" E5_SITCOB,E5_FORNADT,E5_LOJAADT,E5_CLIENTE,E5_FORNECE,E5_SERREC,E5_OPERAD,E5_MOVCX,E5_KEY,E5_MULTNAT,E5_AGLIMP,E5_VLACRES,"
        cQrySE5+=" E5_VLDECRE,E5_VRETPIS,E5_VRETCOF,E5_VRETCSL,E5_PRETPIS,E5_PRETCOF,E5_PRETCSL,E5_AUTBCO,E5_PRETIRF,E5_VRETIRF,E5_VRETISS,E5_NUMMOV,"
        cQrySE5+=" E5_PROCTRA,E5_BASEIRF,E5_NODIA,E5_ORIGEM,E5_DIACTB,E5_FORMAPG,E5_TPDESC,E5_PRISS,E5_PRINSS,E5_USERLGI,E5_USERLGA,E5_FLDMED,E5_CGC,"
        cQrySE5+=" E5_DTCANBX,E5_PRETINS,E5_VRETINS,E5_C_COMPG,E5_IDMOVI,E5_CCUSTO,E5_SEQCON,E5_MOVFKS,E5_IDORIG,E5_TABORI,E5_SDOCREC,"
        cQrySE5+=" SE5.R_E_C_N_O_ SE5RECNO FROM SE5010 SE5 WHERE E5_RECPAG = (CASE WHEN E5_TIPODOC =  'TR' "
        cQrySE5+=" AND E5_HISTOR LIKE '%Estorno de tranferencia%' THEN 'R' ELSE 'P' END ) "
        cQrySE5+=" AND E5_DATA   BETWEEN '"+dToS(dGet3) +"' AND '"+dToS(dGet4)+"'"
        cQrySE5+=" AND E5_DATA <= '"+dToS(dGet4) +"' AND E5_BANCO between '   ' AND 'ZZZ' AND  (E5_NATUREZ between ' ' AND 'ZZZZZZZZZZ' "
        cQrySE5+=" OR  EXISTS (SELECT EV_FILIAL, EV_PREFIXO, EV_NUM, EV_PARCELA, EV_CLIFOR, EV_LOJA
        cQrySE5+=" FROM SEV010 SEV  WHERE E5_FILIAL  = EV_FILIAL AND E5_PREFIXO = EV_PREFIXO AND E5_NUMERO  = EV_NUM AND E5_PARCELA = EV_PARCELA "
        cQrySE5+=" AND E5_TIPO    = EV_TIPO AND E5_CLIFOR  = EV_CLIFOR AND E5_LOJA    = EV_LOJA AND EV_NATUREZ between ' ' "
        cQrySE5+=" AND 'ZZZZZZZZZZ' AND SEV.D_E_L_E_T_ = ' ')) AND E5_CLIFOR  between ' ' AND 'ZZZZZZ' AND E5_DTDIGIT BETWEEN '"+dToS(dGet3) +"' AND '"+dToS(dGet4)+"'"
        cQrySE5+=" AND E5_LOTE between ' ' AND 'ZZZZ' AND E5_LOJA between '  ' AND 'ZZ' AND E5_PREFIXO between ' ' AND 'ZZZ' "
        cQrySE5+=" AND SE5.D_E_L_E_T_ = ' '  AND E5_SITUACA NOT IN ('C','E','X') "
        cQrySE5+=" AND NOT EXISTS (SELECT SE5ES.E5_NUMERO FROM SE5010 SE5ES WHERE SE5ES.E5_FILIAL  = SE5.E5_FILIAL "
        cQrySE5+=" AND SE5ES.E5_PREFIXO = SE5.E5_PREFIXO AND SE5ES.E5_NUMERO  = SE5.E5_NUMERO AND SE5ES.E5_PARCELA = SE5.E5_PARCELA  "
        cQrySE5+=" AND SE5ES.E5_TIPO    = SE5.E5_TIPO AND SE5ES.E5_CLIFOR  = SE5.E5_CLIFOR AND SE5ES.E5_LOJA = SE5.E5_LOJA"
        cQrySE5+=" AND SE5ES.E5_SEQ     = SE5.E5_SEQ  AND SE5ES.E5_TIPODOC = 'ES'  AND SE5ES.E5_ORIGEM <> 'FINA100 ') "
        cQrySE5+=" AND ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR (E5_TIPODOC != 'CD')) "
        cQrySE5+=" AND E5_HISTOR NOT LIKE '%Baixa Automatica / Lote%' "
        cQrySE5+=" AND E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','ES' ,'E2' ,' ' ,'CH' ,'TE' ,'TR' ) "
        cQrySE5+=" AND E5_NUMERO  != '' AND E5_FILIAL  = '0101'  AND (E5_MOTBX <> 'CNF')  "
        cQrySE5+=" ORDER BY E5_FILIAL,E5_DATA,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ "

        cQrySE5 := ChangeQuery(cQrySE5)

        MemoWrite("RFIN07.SQL",cQrySE5)

        MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySE5),cAliaSE5,.T.,.T.)},"Selecionando Registros..." ) //"Selecionando Registros..."

    ElseIf lAmbos

        cQrySE5 +=" SELECT E2_FILIAL,E2_PREFIXO,E2_NUM,E2_TIPO,E2_FORNECE,E2_LOJA,E2_NOMFOR,"
        cQrySE5 +=" E2_PARCELA,E2_VENCREA,E2_BAIXA,E2_VALOR,E2_JUROS,E2_MULTA,E2_ISS,E2_IRRF,"
        cQrySE5 +=" E2_SALDO,E2_NATUREZ,E2_E_NATUR,E2_HIST,E2_EMISSAO "
        cQrySE5 +=" FROM "+RetSqlName("SE2")+ " SE2"

        cQrySE5 +=" WHERE SE2.E2_FILIAL = '" + xFilial("SE2") + "' "
        cQrySE5 +=" AND E2_EMISSAO  BETWEEN '"+dToS(dGet5) +"' AND '"+dToS(dGet6)+"'"
        cQrySE5 +=" AND SE2.D_E_L_E_T_='' "

        cQrySE5 := ChangeQuery(cQrySE5)

        MemoWrite("RFIN07.SQL",cQrySE5)

        MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySE5),cAliaSE5,.T.,.T.)},"Selecionando Registros..." ) //"Selecionando Registros..."

    EndIf

//-----------------------------------------------------------------------------------
//--Monta o array para gravação
//-----------------------------------------------------------------------------------

    dbSelectArea(cAliaSE5)
    dbGoTop()


    While !  (cAliaSE5)->( Eof() )

        If lGerado
            Aadd(aTitulos,{((cAliaSE5))->E2_FILIAL,(cAliaSE5)->E2_PREFIXO,(cAliaSE5)->E2_NUM,(cAliaSE5)->E2_TIPO,;
                (cAliaSE5)->E2_FORNECE,(cAliaSE5)->E2_LOJA,(cAliaSE5)->E2_NOMFOR,(cAliaSE5)->E2_PARCELA,(cAliaSE5)->E2_VENCREA,;
                (cAliaSE5)->E2_BAIXA,(cAliaSE5)->E2_VALOR,(cAliaSE5)->E2_JUROS,(cAliaSE5)->E2_MULTA,(cAliaSE5)->E2_ISS,;
                (cAliaSE5)->E2_IRRF,(cAliaSE5)->E2_SALDO,(cAliaSE5)->E2_NATUREZ,(cAliaSE5)->E2_E_NATUR,;
                (cAliaSE5)->E2_HIST,(cAliaSE5)->E2_EMISSAO})

        Elseif lBaixado
            Aadd(aTitulos,{(cAliaSE5)->E5_FILIAL,(cAliaSE5)->E5_PREFIXO,(cAliaSE5)->E5_NUMERO,(cAliaSE5)->E5_TIPO,;
                (cAliaSE5)->E5_CLIFOR,(cAliaSE5)->E5_LOJA,(cAliaSE5)->E5_BENEF,(cAliaSE5)->E5_PARCELA,(cAliaSE5)->E5_VENCTO,;
                (cAliaSE5)->E5_DATA,(cAliaSE5)->E5_VALOR,(cAliaSE5)->E5_VLJUROS,(cAliaSE5)->E5_VLMULTA,(cAliaSE5)->E5_VRETISS,;
                (cAliaSE5)->E5_VRETIRF,(cAliaSE5)->E5_VALOR,(cAliaSE5)->E5_NATUREZ,'',;
                (cAliaSE5)->E5_HISTOR,(cAliaSE5)->E5_DATA})


        ElseIf lAmbos
            Aadd(aTitulos,{((cAliaSE5))->E2_FILIAL,(cAliaSE5)->E2_PREFIXO,(cAliaSE5)->E2_NUM,(cAliaSE5)->E2_TIPO,;
                (cAliaSE5)->E2_FORNECE,(cAliaSE5)->E2_LOJA,(cAliaSE5)->E2_NOMFOR,(cAliaSE5)->E2_PARCELA,(cAliaSE5)->E2_VENCREA,;
                (cAliaSE5)->E2_BAIXA,(cAliaSE5)->E2_VALOR,(cAliaSE5)->E2_JUROS,(cAliaSE5)->E2_MULTA,(cAliaSE5)->E2_ISS,;
                (cAliaSE5)->E2_IRRF,(cAliaSE5)->E2_SALDO,(cAliaSE5)->E2_NATUREZ,(cAliaSE5)->E2_E_NATUR,;
                (cAliaSE5)->E2_HIST})
        EndIf


        dbSelectArea(cAliaSE5)
        (cAliaSE5)->( dbSkip())
    Enddo

    dbSelectArea(cAliaSE5)
    dbCloseArea()

//-----------------------------------------------------------------------------------
//--Busca os Itens da nota fiscal
//----------------------------------------------------------------------------------- 
    For nYi := 1 To Len (aTitulos)

        cChaveSD1 :=(aTitulos[nYi][1]+aTitulos[nYi][3]+aTitulos[nYi][2]+aTitulos[nYi][5]+aTitulos[nYi][6])

        dbSelectArea("SD1")
        SD1->(dbSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
        If dbSeek(aTitulos[nYi][1]+aTitulos[nYi][3]+aTitulos[nYi][2]+aTitulos[nYi][5]+aTitulos[nYi][6])
            While SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == cChaveSD1

                //-Bucas informações do produto
                cDescPrd    :=  cBusProd(SD1->D1_COD,1)
                cDescNatF   :=  cBuscNat(aTitulos[nYi][17],1)
                cNatP       :=  cBuscNat(aTitulos[nYi][17],2)
                cDescNatP   :=  cBuscNat(aTitulos[nYi][17],3)
                cDesCC      :=  cBusCC(SD1->D1_CC,1)
                cCCPai      :=  cBusCC(SD1->D1_CC,2)
                cDesCCPai   :=  cBusCC(SD1->D1_CC,3)
                cDesCTB     :=  cBusCTB(SD1->D1_CONTA,1)


                Aadd(aItens,{aTitulos[nYi][1],aTitulos[nYi][2],aTitulos[nYi][3]     ,;
                    aTitulos[nYi][4],aTitulos[nYi][5],aTitulos[nYi][6]              ,;
                    aTitulos[nYi][7],aTitulos[nYi][8],aTitulos[nYi][9]              ,;
                    aTitulos[nYi][10],aTitulos[nYi][11],aTitulos[nYi][12]           ,;
                    aTitulos[nYi][13],aTitulos[nYi][14],aTitulos[nYi][15]           ,;
                    aTitulos[nYi][16],aTitulos[nYi][17],aTitulos[nYi][19]			,;
                    SD1->D1_ITEM,SD1->D1_COD,SD1->D1_UM ,SD1->D1_QUANT				,;
                    SD1->D1_VUNIT,SD1->D1_CC,SD1->D1_CONTA,cDescPrd                 ,;
                    cDescNatF,cNatP,cDescNatP,cDesCC,cCCPai,cDesCCPai               ,;
                    cDesCTB,aTitulos[nYi][20]		                                })

                SD1->(dbSkip())
            EndDo
        Else

            cDescNatF   :=  cBuscNat(aTitulos[nYi][17],1)
            cNatP       :=  cBuscNat(aTitulos[nYi][17],2)
            cDescNatP   :=  cBuscNat(aTitulos[nYi][17],3)


            Aadd(aItens,{aTitulos[nYi][1],aTitulos[nYi][2],aTitulos[nYi][3]     ,;
                aTitulos[nYi][4],aTitulos[nYi][5],aTitulos[nYi][6]              ,;
                aTitulos[nYi][7],aTitulos[nYi][8],aTitulos[nYi][9]              ,;
                aTitulos[nYi][10],aTitulos[nYi][11],aTitulos[nYi][12]           ,;
                aTitulos[nYi][13],aTitulos[nYi][14],aTitulos[nYi][15]           ,;
                aTitulos[nYi][16],aTitulos[nYi][17],aTitulos[nYi][19]			,;
                "","CODIGO","UN"   ,0          			        	            ,;
                0,"00000","CONTA","SEM PRODUTO"                                 ,;
                cDescNatF,cNatP,cDescNatP,"CENTRO","00000","DESCPAI"            ,;
                "CONTA CONTABIL",aTitulos[nYi][20]  	                         })
        EndIf
    Next nYi
Return(aItens)


/*/{Protheus.doc} cBusCTB
    Retorna informações do cadastro Conta Contabil
    @type  Static Function
    @author Davidson Carvalho
    @since 06/05/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
 /*/
Static Function cBusCTB(cConta,nOpc)

    Local cDesCTB   :=""
    Local cRetorno  :=""


    dbSelectArea("CT1")
    CT1->(dbSetOrder(1))
    If dbSeek(xFilial("CT1")+cConta)

        cDesCTB    :=CT1->CT1_DESC01
    EndIf

    //--Retorna a descrição da conta contabil
    If nOpc == 1
        cRetorno:= cDesCTB
    EndIf

Return cRetorno


/*/{Protheus.doc} cBusCC
    Retorna informações do cadastro deCentro de custos
    @type  Static Function
    @author Davidson Carvalho
    @since 06/05/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
 /*/
Static Function cBusCC (cCentro,nOpc)

    Local cDesCC    :=""
    Local cCCPai    :=""
    Local cDesCCPai :=""
    Local cRetorno  :=""
   

    dbSelectArea("CTT")
    CTT->(dbSetOrder(1))
    IF dbSeek(xFilial("CTT")+cCentro)

        cDesCC       := CTT->CTT_DESC01
        cCCPai       := CTT->CTT_CCSUP
        cDesCCPai    := CTT->CTT_DESC01
    ENDIF
   
    IF nOpc == 3
        dbSelectArea("CTT")
        CTT->(dbSetOrder(1))
        IF dbSeek(xFilial("CTT")+cCCPai)

            cDesCCPai    := CTT->CTT_DESC01
        ENDIF
    ENDIF

    //--Retorna a descrição da natureza
    If nOpc == 1
        cRetorno:= cDesCC
    ElseIf nOpc == 2
        cRetorno:= cCCPai   //--Retorna Codigo do centro de custo  Pai
    ElseIf nOpc == 3
        cRetorno:= cDesCCPai  //--Retorna descrição  do centro de custo Pai
    EndIf

Return cRetorno


/*/{Protheus.doc} cBuscNat
    Retorna informações do cadastro de Naturezas
    @type  Static Function
    @author Davidson Carvalho
    @since 06/05/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
 /*/
Static Function cBuscNat(cCodNaturez,nOpc)

    Local cDescNatF := ""
    Local cNatP     := ""
    Local cDescNatP := ""
    Local cRetorno  := ""


    dbSelectArea("SED")
    SED->(dbSetOrder(1))
    If dbSeek(xFilial("SED")+cCodNaturez)

        cDescNatF   :=  SED->ED_DESCRIC
        cNatP       :=  SED->ED_PAI
        cDescNatP   :=  SED->ED_DESCRIC
    EndIf

    //--Retorna a descrição da natureza
    If nOpc == 1
        cRetorno:= cDescNatF
    ElseIf nOpc == 2
        cRetorno:= cNatP   //--Retorna Codigo Natureza Pai
    ElseIf nOpc == 3
        cRetorno:= cDescNatP  //--Retorna descrição  Natureza Pai
    EndIf

Return cRetorno



/*/{Protheus.doc} cBusProd
    Retorna informações do cadastro de produtos
    @type  Static Function
    @author Davidson Carvalho
    @since 06/05/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
 /*/
Static Function cBusProd(cCodigo,nOpc)

    Local cDescPrd  :=  ""
    Local cRetorno  :=  ""


    dbSelectArea("SB1")
    SB1->(dbSetOrder(1))
    If dbSeek(xFilial("SB1")+cCodigo)

        cDescPrd    :=SB1->B1_DESC
    EndIf

    //--Retorna a descrição do produto
    If nOpc == 1
        cRetorno:= cDescPrd
    EndIf

Return cRetorno


/*/{Protheus.doc} ³CtbTamFil
    Retorna o tamanho do campo
    @type  Static Function
    @author user
    @since 06/05/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
 /*/
Static Function CtbTamFil(cGrupo,nTamPad)
    Local nSize := 0

    DbSelectArea("SXG")
    DbSetOrder(1)

    If DbSeek(cGrupo)
        nSize := SXG->XG_SIZE
    Else
        nSize := nTamPad
    Endif

Return nSize


/*/{Protheus.doc} fValNext
    Realiza a validação dos campos do painel 2 
    @type  Static Function
    @author user
    @since 06/05/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static  Function fValNext()
    Local lRet := .T.

    // alert('Retorna .T. para continuar!')

Return lRet