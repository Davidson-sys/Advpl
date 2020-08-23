#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"


//------------------------------------------------------------------+

/*/{Protheus.doc} RNUTB01()
Relatorio de Ticket de Pesagem
@author 	Davis Magalhaes
@since 		31/08/2015
@version 	P11 R5
@param   	n/t
@return  	n/t
@obs        Programa Especifico para Nutratta
/*/
//------------------------------------------------------------------+

User Function RNUTB01()

Local   nOpca  := 0                      
Private oTkt		

//????????????????????????????????
//?Ajustar perguntas do SX1	   			  				     ?//????????????????????????????????
//AjustaSX1(cPerg)

//Pergunte(cPerg,.F.)

//????????????????????????????????
//?Tela de configuracao do Relatorio			         	     ?//????????????????????????????????


nOpca := Aviso("Nutratta","Deseja Emitir o Ticket de Pessagem ?",{"Emitir","Sair"},2,"Ticket: "+ZA3->ZA3_NUMTKT)


If nOpca == 1
	    
		RptStatus({|lEnd| RNUTB1Imp(@lEnd)})
		
	
EndIf

Return Nil                                                     
                           
                               
//------------------------------------------------------------------+

/*/{Protheus.doc} RRPA01Imp()

@author 	Davis Magalhaes
@since 		31/08/2015
@version 	P11 R5
@param   	n/t
@return  	n/t
@obs        Programa Especifico para Nutratta
/*/
//------------------------------------------------------------------+
      
Static Function RNUTB1Imp(lEnd)


Local lAdjustToLegacy := .T.
Local lDisableSetup  := .T.
Local cDirSpool := GetMv("MV_RELT")
Local cLogo      	:= FisxLogo("1")
Local cLogoD	    := ""
local cLogoTotvs 	:= "Powered_by_TOTVS.bmp"
local cStartPath 	:= GetSrvProfString("Startpath","")
Local cDescLogo		:= ""
Local lMv_Logod     := If(GetNewPar("MV_LOGOD", "N" ) == "S", .T., .F.   )

Private oFont08 	:= TFont():New("Arial",08,10,,.T.,,,,.T.,.F.)
Private oFont10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
Private oFont10n	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
Private oFont11n	:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)
Private oFont12 	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
Private oFont12n	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
Private oFont14n	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
Private oFont16n	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
Private oFont18n	:= TFont():New("Arial",18,18,,.T.,,,,.T.,.F.)

Private nlin	:= 0
Private nPagina := 0
Private cTitRel := "Ticket Pesagem"
        

If oTkt == Nil
	lPreview := .T.
	oTkt 	:= FWMSPrinter():New("TKT"+ZA3->ZA3_NUMTKT, IMP_PDF,lAdjustToLegacy,cDirSpool, lDisableSetup)
	oTkt:SetPortrait()
	oTkt:Setup()
EndIf

// -- Verificar o LOGO

If lMv_Logod
	cGrpCompany	:= AllTrim(FWGrpCompany())
	cCodEmpGrp	:= AllTrim(FWCodEmp())
	cUnitGrp	:= AllTrim(FWUnitBusiness())
	cFilGrp		:= AllTrim(FWFilial())

	If !Empty(cUnitGrp)
		cDescLogo	:= cGrpCompany + cCodEmpGrp + cUnitGrp + cFilGrp
	Else
		cDescLogo	:= cEmpAnt + cFilAnt
	EndIf

	cLogoD := GetSrvProfString("Startpath","") + "DANFE" + cDescLogo + ".BMP"
	If !File(cLogoD)
		cLogoD	:= GetSrvProfString("Startpath","") + "DANFE" + cEmpAnt + ".BMP"
		If !File(cLogoD)
			lMv_Logod := .F.
		EndIf
	EndIf
EndIf



oTkt:SetResolution(78) //Tamanho estipulado para a Danfe
oTkt:SetPortrait()
oTkt:SetPaperSize(DMPAPER_A4)
oTkt:SetMargin(60,60,60,60)             
/*
oTkt:lServer := oSetup:GetProperty(PD_DESTINATION)==AMB_SERVER
// ----------------------------------------------
// Define saida de impress?
// ----------------------------------------------
If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
	oTkt:nDevice := IMP_SPOOL
	// ----------------------------------------------
	// Salva impressora selecionada
	// ----------------------------------------------
	fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
	oTkt:cPrinter := oSetup:aOptions[PD_VALUETYPE]
ElseIf oSetup:GetProperty(PD_PRINTTYPE) == IMP_PDF
	oTkt:nDevice := IMP_PDF
	// ----------------------------------------------
	// Define para salvar o PDF
	// ----------------------------------------------
	oTkt:cPathPDF := oSetup:aOptions[PD_VALUETYPE]
Endif
                             


  */       
                    

SetRegua(8)
  
dbSelectArea("ZA3")

If  ! ZA3->( Eof() )
	
	            
	
	IncRegua() 
	
	                
	nlin	:= 005
	
	
	oTkt:StartPage()	//-- Inicia uma nova pagina
	
	
	If lMv_Logod
		oTkt:SayBitmap(000,005,cLogoD,950,250)
	Else
		oTkt:SayBitmap(000,005,cLogo,950,250)
	EndIF
	
	oTkt:Say(nLin,1000,Alltrim(SM0->M0_NOMECOM),oFont18n)
	nLin += 45 		//"Emissao.: "
	oTkt:Say(nLin,1050,Alltrim(SM0->M0_ENDCOB)+' - '+ALLTRIM(SM0->M0_BAIRCOB),oFont14n) 
	nLin += 45 		//"Emissao.: "
	oTkt:Say(nLin,1050,Alltrim(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB+"  CEP: "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont14n) 
	nLin += 45 		//"Emissao.: "
	oTkt:Say(nLin,1050,"CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+"  Insc. Estadual: "+SM0->M0_INSC,oFont14n) 
	nLin += 70
	//oTkt:Say(nLin,000,Replicate("-",310),oFont12n)
	nLin += 130
	
	
	
	//oTkt:Box(000,350,095,603)
	
	//oTkt:Box(nLin,0010,095,500)
	oTkt:Say(nLin,0030,"N?Ticket: "+ZA3->ZA3_NUMTKT,oFont12n)
	nFontSize := 18
	oTkt:Code128C(nLin+80,060,ZA3->ZA3_NUMTKT, nFontSize )
			
	nLin += 100
	
	
	
	CNRBox1(0010,300,"PLACA VEICULO",ZA3->ZA3_CODVEI,.F.,3,oFont12n)
	CNRBox1(0320,610,"PLACA S.REB 1",ZA3->ZA3_CODSR1,.F.,3,oFont12n)
	CNRBox1(0630,940,"PLACA S.REB 2",ZA3->ZA3_CODSR2,.T.,3,oFont12n)
	
	
	
	
	nLin += 5
	oTkt:Box(nLin,1500,nLin+300,2250)
	oTkt:Say(nLin+50,1550,"IMPUREZA: ",oFont12n)
	oTkt:Say(nLin+50,2200,"%",oFont12n)
	oTkt:Say(nLin+100,1550,"UMIDADE: ",oFont12n)
	oTkt:Say(nLin+100,2200,"%",oFont12n)
	oTkt:Say(nLin+150,1550,"ARDIDOS: ",oFont12n)
	oTkt:Say(nLin+150,2200,"%",oFont12n)
	oTkt:Say(nLin+200,1550,"QEBRADOS: ",oFont12n)
	oTkt:Say(nLin+200,2200,"%",oFont12n)
	oTkt:Say(nLin+250,1550,"QEBRA TECNICA: ",oFont12n)
	oTkt:Say(nLin+250,2200,"%",oFont12n)
	
	oTkt:Say(nLin+400,1900,"OBSERVA?ES",oFont14n) 
	oTkt:Say(nLin+450,1500,SUBSTR(ZA3->ZA3_OBSERV,1,60),oFont10)
	oTkt:Say(nLin+500,1500,SUBSTR(ZA3->ZA3_OBSERV,61,60),oFont10)
	oTkt:Say(nLin+550,1500,SUBSTR(ZA3->ZA3_OBSERV,121,60),oFont10)
	oTkt:Say(nLin+600,1500,SUBSTR(ZA3->ZA3_OBSERV,181,60),oFont10)
	oTkt:Say(nLin+650,1500,SUBSTR(ZA3->ZA3_OBSERV,241,60),oFont10)
	oTkt:Say(nLin+700,1500,SUBSTR(ZA3->ZA3_OBSERV,301,60),oFont10)
	oTkt:Say(nLin+750,1500,SUBSTR(ZA3->ZA3_OBSERV,361,60),oFont10)
	oTkt:Say(nLin+800,1500,SUBSTR(ZA3->ZA3_OBSERV,421,60),oFont10) 
	oTkt:Say(nLin+850,1500,SUBSTR(ZA3->ZA3_OBSERV,481,60),oFont10)
	oTkt:Say(nLin+900,1500,SUBSTR(ZA3->ZA3_OBSERV,541,60),oFont10)
	
	CNRBox1(0010,1400,"TRANSPORTADORA",ZA3->ZA3_CODTRP+'-'+ZA3->ZA3_NOMTRP,.T.,3,oFont12n)
	
	
	nLin += 5
	CNRBox1(0010,1400,"MOTORISTA",ZA3->ZA3_CODMOT+'-'+ZA3->ZA3_NOMMOT,.T.,3,oFont12n)
	
	
	nLin += 5
	If ZA3->ZA3_TIPPRD == "1"
		CNRBox1(0010,1400,"ITEM/PRODUTO",Alltrim(ZA3->ZA3_DESPRD),.T.,3,oFont12n)
	Else
		CNRBox1(0010,1400,"ITEM/PRODUTO",Alltrim(ZA3->ZA3_ITEPES),.T.,3,oFont12n)
	EndIF

	nLin += 5
	CNRBox1(0010,1400,"DOCUMENTOS FISCAIS",Alltrim(ZA3->ZA3_DOCFIS),.T.,3,oFont12n)
	
	
	
	
	nLin += 5
	CNRBox1(0010,0650,"       PESAGEM INICIAL","Data / Hora: "+dToc(ZA3->ZA3_DATPEI)+" - "+ZA3->ZA3_HORPEI,.F.,5,oFont12n,.F.,Space(20)+Transform(ZA3->ZA3_PESINI,"@E 999,999,999.999"))
	CNRBox1(0750,1400,"       PESAGEM FINAL","Data / Hora: "+dToc(ZA3->ZA3_DATPEF)+" - "+ZA3->ZA3_HORPEF,.T.,5,oFont12n,.F.,Space(20)+Transform(ZA3->ZA3_PESFIN,"@E 999,999,999.999"))
	
	
	nLin += 5
	CNRBox1(0010,650,"                PESO LIQUIDO",Space(25)+Transform(ZA3->ZA3_PESOLQ,"@E 999,999,999.999"),.F.,3,oFont12n)
	
	CNRBox1(0750,1400,"             LIQUIDO CORRIGIDO",Space(25)+Transform(ZA3->ZA3_PESOLQ,"@E 999,999,999.999"),.T.,3,oFont12n)
	
	oTkt:Say(nLin+200,0010,"Supervisor de Balan?: _____________________________________________________",oFont14n)
	oTkt:Say(nLin+300,0010,"Motorista: _________________________________________________________________",oFont14n)
	
	
	
	
	
	oTkt:EndPage() 	//-- Encerra a pagina anterior

	
EndiF
    

oTkt:Preview()//Visualiza antes de imprimir
FreeObj(oTkt)
oTkt := Nil

Return

/*/
???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????un?ao    ?CNRBox1() ?Autor ?Davis Magalhaes     ?Data ?7/01/2011???????????????????????????????????????????escri??o ?Cria Box para Textos			                                ???????????????????????????????????????????arametros?ExpN1 = Posicao inicial da coluna para criacao do Box      ????         ?ExpN2 = Posicao final da coluna para criacao do Box        ????         ?ExpC3 = Texto da 1a. linha do Box                          ????         ?ExpC4 = Texto da 2a. linha do Box                          ????         ?ExpL5 = Quebra para proxima linha apos a impressao do Box  ????         ?        (.T. Com  Quebra / .F. Sem Quebra)                 ????         ?ExpN6 = Tipo do Box : 									           ????         ?                     1 - Linha de Cabecalho                ????         ?                     2 - Linha Unica Simples               ????         ?                     3 - Linha de Detalhe                  ????         ?                     4 - Somente Texto                     ????         ?ExpO7 = Fonte para impressao do Texto                      ????         ?ExpL8 = Se .T. realiza o alinhamento do cTexto1 a Direita. ???????????????????????????????????????????Uso      ?                                                           ???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????/*/
Static Function CNRBox1(nCol1,nCol2,cTexto1,cTexto2,lQuebra,nTipo,oFontB,lAlinDir,cTexto3)
//????????????????????????????????
//?Inicializa Fontes											           ?//????????????????????????????????
Local oFont10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
Local oFont10n	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)

Default nCol1	:= 0
Default nCol2	:= 0
Default cTexto1 := ""
Default cTexto2 := ""
Default lQuebra := .T.
Default nTipo   := 3
Default oFontB  := oFont12
Default lAlinDir:= .F.
/*
If nLin >= 2400
	CNRCabec1(Nil,Nil,OemToAnsi(cTitRel)) //-- Impressao do Cabecalho da pagina
EndIf
 */
If nTipo == 1  //-- Linha de Cabecalho
	oTkt:Box(nLin,nCol1,nLin+55,nCol2)
	oTkt:Box(nLin+5,nCol1+5,nLin+50,nCol2-5)
	oTkt:Say(nLin+10,((nCol2-nCol1)/2)-((Len(alltrim(cTexto1))/2)*20),cTexto1,oFont12n)
ElseIf nTipo == 2 //-- Linha Unica Simples
	oTkt:Box(nLin,nCol1,nLin+45,nCol2)
	If lAlinDir //-- Alinhamento a Direita
		oTkt:Say(nLin+28,nCol2-5-TamTexto(Alltrim(cTexto1)),AllTrim(cTexto1),oFontB)
		//      oTkt:Say(nLin+7,nCol2-5-TamTexto(cTexto1),cTexto1,oFontB)
	Else
		oTkt:Say(nLin+28,nCol1+10,cTexto1,oFontB)
	EndIf
ElseIf nTipo == 3 //-- Linha de Detalhe
	oTkt:Box(nLin,nCol1,nLin+095,nCol2)
	oTkt:Say(nLin+25,nCol1+10,cTexto1,oFont12n)
	oTkt:Say(nLin+65,nCol1+10,cTexto2,oFont12)
ElseIf nTipo == 4 //-- Somente Texto
	oTkt:Say(nLin+7,nCol1,cTexto1,oFontB)
	
ElseIf nTipo == 5 //-- Linha de Detalhe
	oTkt:Box(nLin,nCol1,nLin+135,nCol2)
	oTkt:Say(nLin+25,nCol1+10,cTexto1,oFont12n)
	oTkt:Say(nLin+65,nCol1+10,cTexto2,oFont12)
	oTkt:Say(nLin+105,nCol1+10,cTexto3,oFont12n)
	//oTkt:Say(nLin+105,((nCol2-nCol1)/2)-((Len(alltrim(cTexto3))/2)*20),cTexto3,oFont12n)
EndIf
If lQuebra //-- Quebra Linha
	If nTipo == 1
		nLin += 60	//-- Cabecalho
	ElseIf nTipo == 2
		nLin += 50	//-- Unica Simples
	ElseIf nTipo == 3
		nLin += 105	//-- Detalhe
	ElseIf nTipo == 4
		nLin += 50 //-- Somente Texto
	ElseIf nTipo == 5
		nLin += 145	//-- Detalhe
	EndIf
EndIf


Return


