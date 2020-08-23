#INCLUDE "RWMAKE.CH"          
#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "topconn.ch"      
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"   
                     
//-------------------------------------------------------------------
/*/{Protheus.doc} RFIN04
Relatorios Faturamento x Titulos
Observação:Gerar relatorio em Excel.
@protected
@author        Davidson Clayton
@since         22/09/2016.
/*/
//-------------------------------------------------------------------
 
 
 //Relatorio foi abortado por Rodrigo Samaia em 22/09/2016.
 //Solicitou que trabalhassemos na pendencia de Risco de credito do cliente.
User Function RFAT04()

Private oReport      
Private oSection1
Private oSection2
Private oSection3
Private oBreak
Private oBreak2
Private aCampos 		:= {}
Private cFilMov    	:= ""
Private cAuxFil    	:= ""
Private cDescFil   	:= ""
Private cDescGrif  	:= ""
  
Static EQUIPAMENTOS 	:= 1
Static LOCACAO		:= 2
Static SERVICOS	 	:= 3
Static PRODUTOS	 	:= 4

//Private oProcess
Private oReport  
Private cPerg:="NUTREALFAT"
oReport := ReportDef()
oReport:PrintDialog()
	
Return



/*
+-----------------------------------------------------------------------+
¦Programa  ¦ ReportDef   ¦ Autor ¦Davidson-P2P 	  ¦ Data ¦04/05/2016    ¦
¦----------+------------------------------------------------------------¦
¦Descrição ¦ Definição do relatório                                     ¦
¦----------+------------------------------------------------------------¦
¦ Uso      ¦                                              		        ¦
+-----------------------------------------------------------------------+
*/

Static Function ReportDef()

	Local cHelp			:= 'Relatório Faturados em aberto'
	Local cTitulo		:= cHelp

	Private cAliasZA 	:= ""
	Private cAlTmpOrc	:= ""
	Private aStruZA 	:= {}
	Private aCmpZA 		:= {}
	
	oReport   := TReport():New(cPerg,cTitulo,cPerg,{|oReport| ReportPrint(oReport) },cHelp)
	oReport:SetLandscape(.T.)
	
	oSection1 := TRSection():New(oReport,'Relatório Mensal', {"TRBA"})
	
	TRCell():New(oSection1,"DOCUMENTO"		,"TRBA",""				,PesqPict("SF2","F2_DOC")		,TamSX3("F2_DOC")[1]+5)
	TRCell():New(oSection1,"SERIE"			,"TRBA",""	 			,PesqPict("SF2","F2_SERIE")		,TamSX3("F2_SERIE")[1]+5)
	TRCell():New(oSection1,"CLIENTE"		,"TRBA",""				,PesqPict("SF2","F2_CLIENTE")	,TamSX3("F2_CLIENTE")[1]+5)
	TRCell():New(oSection1,"LOJA"			,"TRBA",""				,PesqPict("SF2","F2_LOJA")		,TamSX3("F2_LOJA")[1]+5)
	TRCell():New(oSection1,"EMISSAO"		,"TRBA",""				,PesqPict("SF2","F2_EMISSAO")	,TamSX3("F2_EMISSAO")[1]+5)
	TRCell():New(oSection1,"VALOR"			,"TRBA",""				,PesqPict("SF2","F2_VALBRUT")	,TamSX3("F2_VALBRUT")[1]+5)
	TRCell():New(oSection1,"TITULO"			,"TRBA",""				,PesqPict("SE1","E1_TITULO")	,TamSX3("E1_TITULO")[1]+5)
	TRCell():New(oSection1,"PREFIXO"		,"TRBA",""				,PesqPict("SE1","PREFIXO")		,TamSX3("PREFIXO")[1]+5)
   	TRCell():New(oSection1,"VACRE"			,"TRBA",""				,PesqPict("SZA","ZA_VLRACRE")	,TamSX3("ZA_VLRACRE")[1]+5)
   	TRCell():New(oSection1,"FORM"			,"TRBA",""				,PesqPict("SZA","ZA_DESPGTO")	,TamSX3("ZA_DESPGTO")[1]+5)
	TRCell():New(oSection1,"VTITULO"		,"TRBA",""				,PesqPict("SZA","ZA_VALOR")		,TamSX3("ZA_VALOR")[1]+5)
 
 
Return oReport    

/*
+-----------------------------------------------------------------------+
¦Programa  ¦ ReportPrint ¦ Autor ¦Davidson-P2P 	  ¦ Data ¦04/05/2016    ¦
¦----------+------------------------------------------------------------¦
¦Descrição ¦ Função de impressão do relatório                           ¦
¦----------+------------------------------------------------------------¦
¦ Uso      ¦ ReportPrint                                                ¦
+-----------------------------------------------------------------------+
*/
Static Function ReportPrint(oReport)
	
	Local cChave 	:= ""
	Local oSecao1 	:= oReport:Section(1)
    Local cQuery 	:= ""
    Local cQueryZ	:=""
	Local nQtdRes	:= 0
	Local nPos      := 0
	Local cAuxCart 	:=""
	Local cTipo    	:=""
	Local nValor	:=0
	Local cArquTrab
    Local cCodAux	:=""
    Local nTtFixo	:=0
    Local nTtReajus :=0
    Local nTtcopar	:=0
    Local nTotTaxa	:=0
    Local nTotTit	:=0
    Local nCobDeb	:=0
	Local nValDeb	:=0
	Local nCobBol	:=0
	Local nValBol	:=0
	Local nQtdTitula:=0
	Local nQtdDepend:=0

	aStruZA := {}
	aCmpZA 	:= {}

	Aadd(aStruZA, {"SEGURADO"	,"C",50,0}) 
	Aadd(aStruZA, {"TIPO"		,"C",06,0})
	Aadd(aStruZA, {"VFIXO"		,"N",14,2})
	Aadd(aStruZA, {"VREAJUSTE"	,"N",14,2})
	Aadd(aStruZA, {"VCOPART"	,"N",14,2})
	Aadd(aStruZA, {"TOTMENS"	,"N",14,2})
	Aadd(aStruZA, {"TAXA"		,"C",10,0}) 
	Aadd(aStruZA, {"VTAXA"		,"N",14,2})
	Aadd(aStruZA, {"VACRE"		,"N",14,2})	
	Aadd(aStruZA, {"FORM"		,"C",10,0})
	Aadd(aStruZA, {"VTITULO"	,"N",14,2}) 
	Aadd(aStruZA, {"CODCART"	,"C",14,0})
 
	AADD(aCmpZA,{"SEGURADO"		,"","Segurado"})
	AADD(aCmpZA,{"TIPO"			,"","Tipo"})	
	AADD(aCmpZA,{"VFIXO"		,"","Vlr.Fixo"})	
	AADD(aCmpZA,{"VREAJUSTE" 	,"","Vlr.Reajuste"})
	AADD(aCmpZA,{"VCOPART" 		,"","Vlr.Copart"})
	AADD(aCmpZA,{"TOTMENS" 		,"","Total Mensal"})
	AADD(aCmpZA,{"TAXA" 		,"","Taxa"})
	AADD(aCmpZA,{"VTAXA" 		,"","Vlr.Taxa"})  
	AADD(aCmpZA,{"VACRE" 		,"","Vlr.Acrescimo"})  	
	AADD(aCmpZA,{"FORM"		 	,"","Form.Pagto"})
	AADD(aCmpZA,{"VITULO" 		,"","Vlr.Titulo"}) 
	AADD(aCmpZA,{"CODCART" 		,"","Cod.Cart"})
	
	fCloseArea("TRBA")
 	
 	//cria arquivo de trab. "TRBA" 
	cArquTrab :=  CriaTrab(aStruZA,.T.)
	dbUseArea(.T.,,cArquTrab,"TRBA",.F.) 
	
	nPosBenefi	:=aScan(aHeader,{|x| AllTrim(x[2]) == 'NOME'}) 		//Segurado.
// 	nPosTipo	:=aScan(aHeader,{|x| AllTrim(x[2]) == 'ZA_TIPO'})  //Tipo.
 	nPosCart	:=aScan(aHeader,{|x| AllTrim(x[2]) == 'CODIGO'})   //Carteirinha   	
   	nPosValor	:=aScan(aHeader,{|x| AllTrim(x[2]) == 'VLR_FAMI'})  //Vlr.Fixo.
 	nPosVRejus	:=aScan(aHeader,{|x| AllTrim(x[2]) == 'TOTREAJUS'}) //Vlr.Reajuste.   		
   	nPosCopart	:=aScan(aHeader,{|x| AllTrim(x[2]) == 'COPART'})  	//Vlr.Co participa.
   	nPosTaxa	:=aScan(aHeader,{|x| AllTrim(x[2]) == 'TXAPLI'})	//Taxa.
   	nPosVtaxa	:=aScan(aHeader,{|x| AllTrim(x[2]) == 'VTAXA'})  	//Vlr.Taxa.
   	nPosVAcres	:=aScan(aHeader,{|x| AllTrim(x[2]) == 'ACRESCI'})  	//Vlr.Acrescimo   	
   	nPosForm	:=aScan(aHeader,{|x| AllTrim(x[2]) == 'DESPGTO'}) 	//Forma pagto.
 	nPosVTitulo	:=aScan(aHeader,{|x| AllTrim(x[2]) == 'TOTITU'})   	//Vlr.Titulo.
   
	For nxhi:=1 To Len (aCols)
		
		cAuxCart	:=StrTran(StrTran(StrTran(AllTrim(aCols[nxhi][nPosCart]),'.',''),'-',''),"'","")  
	  	
	  	dbSelectArea("SZA")
		dbSetOrder(1)
	    If dbSeek(xFilial("SZA")+cPremio+cAuxCart)//ZA_FILIAL+ZA_PREMIO+ZA_CODIGO
			cTipo		:=SZA->ZA_TIPO
			nValor		:=SZA->ZA_VALOR 
		EndIf
		
		//Valor Fixo+Reajuste+Co-participacao.
		nTotMensal	:=nValor+aCols[nxhi][nPosVRejus]+aCols[nxhi][nPosCopart]//Atribui o total mensal do Titular.
		
		If RecLock("TRBA",.T.)
			Replace ("TRBA")->SEGURADO	With Alltrim(aCols[nxhi][nPosBenefi]) ,;//Segurado.
					("TRBA")->TIPO		With cTipo ,; //Tipo.                                                                                                                                
					("TRBA")->VFIXO		With nValor	 ,;	//Vlr.Fixo.
					("TRBA")->VREAJUSTE	With aCols[nxhi][nPosVRejus] ,;//Vlr.Reajuste.
					("TRBA")->VCOPART	With aCols[nxhi][nPosCopart] ,;//Vlr.Co partipacao. 
					("TRBA")->TAXA		With Alltrim(aCols [nxhi][nPosTaxa]) ,;  //Taxa.
					("TRBA")->VTAXA		With aCols[nxhi][nPosVtaxa] ,; //Vlr.Taxa.
					("TRBA")->VACRE  	With aCols[nxhi][nPosVAcres] ,; //Vlr.Acrescimo					    
					("TRBA")->FORM		With aCols[nxhi][nPosForm] ,; 	//Forma pagto.
					("TRBA")->VTITULO	With aCols[nxhi][nPosVTitulo],; //Vlr.Titulo.
					("TRBA")->CODCART	With cAuxCart					//Codigo da Carteira
				
			MsUnlock()
		EndIf

	       //Verifica se o titular possui dependentes e inclui na TRB.	       
	    	cQueryZ	:= "	SELECT * "
			cQueryZ += "	FROM "+RetSqlName("SZA")+ " ZA " "
			cQueryZ	+= "	WHERE ZA_CODIGO LIKE '"+Substr(cAuxCart,1,13)+"%' " 
			cQueryZ += "	AND ZA.ZA_PREMIO='"+cPremio+"'"  
			cQueryZ += "	AND ZA.ZA_CONTRAT='"+cApolice+"'" 
			cQueryZ += "	AND ZA.ZA_TIPO IN ('D','A','R') "  
			cQueryZ += "	AND ZA.D_E_L_E_T_<> '*' " 	         
							    
			fCloseArea("SCOP")
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryZ),"SCOP",.T.,.T.)
	       	
	       	dbSelectArea("SCOP")
   			("SCOP")->(DbGoTop())
			While ("SCOP")->(!EOF())
                   			
       			//Valor Fixo+Reajuste+Co-participacao.
	  			nTotMensal	+=("SCOP")->ZA_VALOR+("SCOP")->ZA_COPART //Atribui o total mensal dos dependentes.

	        	If RecLock("TRBA",.T.)
			   		Replace ("TRBA")->SEGURADO		With Alltrim(("SCOP")->ZA_BENEFIC) ,;//Segurado.
							("TRBA")->TIPO			With Alltrim(("SCOP")->ZA_TIPO) ,; //Tipo.                                                                                                                                
							("TRBA")->VFIXO	   		With ("SCOP")->ZA_VALOR ,;	//Vlr.Fixo.
							("TRBA")->VCOPART		With ("SCOP")->ZA_COPART //Vlr.Co partipacao. 
					MsUnlock()
				EndIf	        
	       
	       		("SCOP")->(DbSkip())
			EndDo	
	       	
	       	//Grava o total mensal.
	       	dbSelectArea("TRBA")	
       		If RecLock("TRBA",.T.)       			
       			Replace ("TRBA")->TIPO		With "S" ,; 	//Tipo para filtro na tela.   
		   				("TRBA")->TOTMENS 	With nTotMensal //Total mensal.
				MsUnlock()
			EndIf
		
	Next nxhi
	 
	
 	oReport:PrintText("UNIMED SEGUROS-APOLICE:"+cApolice +" - "+"PREMIO:"+cPremio,10)
 	oReport:SkipLine(1)//pula linha

 	oReport:PrintText("Segurado",10) 
 	oReport:PrintText("Tipo",10)
 	oReport:PrintText("Vlr.Fixo",10)  
 	oReport:PrintText("Vlr.Reajuste",10)
 	oReport:PrintText("Vlr.Co-part",10)
 	oReport:PrintText("Total Mensal",10)
 	oReport:PrintText("Taxa",10)  
 	oReport:PrintText("Vlr.Taxa",10) 
	oReport:PrintText("Acrescimo",10) 
 	oReport:PrintText("Form.Pagto",10) 
 	oReport:PrintText("Vlr.Titulo",10) 
 	
	
	dbSelectArea("TRBA")
	
	dbSelectArea("TRBA")
	("TRBA")->(DbGoTop())
	While ("TRBA")->(!EOF())
	
		If oReport:Cancel()
			Exit
		EndIf
				
		//Inicia a sessão
		oSecao1:Init() 
		oReport:IncMeter()
		oSecao1:PrintLine()	//imprime as linhas 	
				
		If ("TRBA")->TOTMENS > 0
//			oReport:SkipLine()//pula linha 
//			oReport:FatLine()
//			TRFunction():New(oSecao1  :Cell("TOTMENS"),NIL,"SUM",oBreak2      ,  ,"@E 99999,999.99",       ,.F.,.T.) //Total Fixo.

		EndIf 	
			
		("TRBA")->(DbSkip())
		 		
	EndDo
	
	//Totalizadores gerais.
   	dbSelectArea("TRBA")
	("TRBA")->(DbGoTop())
	While ("TRBA")->(!EOF())
    	
    	nTtFixo		+=("TRBA")->VFIXO
     	nTtReajus 	+=("TRBA")->VREAJUSTE
     	nTtcopar	+=("TRBA")->VCOPART
     	nTotTaxa	+=("TRBA")->VTAXA
     	nTotTit		+=("TRBA")->VTITULO
     	
     	 If "DEBITO" $ ("TRBA")->FORM
     	 	nCobDeb++
     	    nValDeb+=("TRBA")->VTITULO
     	 ElseIf "BOLETO" $ ("TRBA")->FORM
     		nCobBol++
     	    nValBol+=("TRBA")->VTITULO     	   
     	 EndIf
     	 
     	 If  "T" $ ("TRBA")->TIPO
	     	 nQtdTitula++
     	 ElseIf "D" $ ("TRBA")->TIPO 
     	 	nQtdDepend++
     	 EndIf

	("TRBA")->(DbSkip())		 		
	EndDo
	
	oReport:PrintText("Total Geral:",10) 
	oReport:SkipLine()//pula linha
	oReport:PrintText("Vlr.Fixo: R$ "+Alltrim(Transform (nTtFixo,"@E 999,999.99")),10)	
	oReport:SkipLine()//pula linha
	oReport:PrintText("Vlr.Reajuste: R$ "+Alltrim(Transform (nTtReajus,"@E 999,999.99")),10)
	oReport:SkipLine()//pula linha
	oReport:PrintText("Vlr.Co-Part: R$ "+Alltrim(Transform (nTtcopar,"@E 999,999.99")),10)  
	oReport:SkipLine()//pula linha
	oReport:PrintText("Vlr.Taxa: R$ "+Alltrim(Transform (nTotTaxa,"@E 999,999.99")),10)
	oReport:SkipLine()//pula linha
	oReport:PrintText("Vlr.Titulo: R$ "+Alltrim(Transform (nTotTit,"@E 999,999.99")),10)
	
	oReport:SkipLine()//pula linha	  
    oReport:SkipLine()//pula linha
      
	oReport:PrintText("Debito:",10)
	oReport:SkipLine()//pula linha
 	oReport:PrintText("Cobrança:"+Alltrim(Transform (nCobDeb,"@E 9999")),10)	
	oReport:SkipLine()//pula linha
	oReport:PrintText("Valor: R$ "+Alltrim(Transform (nValDeb,"@E 999,999.99")),10)     
	
	oReport:SkipLine()//pula linha
    oReport:SkipLine()//pula linha  
	
	oReport:PrintText("Boleto:",10)
	oReport:SkipLine()//pula linha
 	oReport:PrintText("Cobrança:"+Alltrim(Transform (nCobBol,"@E 9999")),10)
	oReport:SkipLine()//pula linha
	oReport:PrintText("Valor: R$ "+Alltrim(Transform (nValBol,"@E 999,999.99")),10)     
	
	oReport:SkipLine()//pula linha
    oReport:SkipLine()//pula linha  

	oReport:PrintText("Total Debito+Boleto:  R$ "+Alltrim(Transform (nValDeb+nValBol,"@E 999,999.99")),10) 
	
	oReport:SkipLine()//pula linha

	oReport:PrintText("Indice de Reajuste:"+Alltrim(Transform (nReajuste,"@E 999.99")) +"%",10)
	oReport:SkipLine()//pula linha 
	oReport:PrintText("Salario Base: R$ "+Alltrim(Transform (nSalario,"@E 999,999.99")),10) 
	oReport:SkipLine()//pula linha
	oReport:PrintText("Data de vencimento: "+Dtoc(dVenc),10)

	oReport:SkipLine()//pula linha
	oReport:SkipLine()//pula linha	
    
	oReport:PrintText("Total Segurados:",10)
	oReport:SkipLine()//pula linha
	oReport:PrintText("Titular:"+Alltrim(Transform (nQtdTitula,"@E 9999")),10)
	oReport:SkipLine()//pula linha  
	oReport:PrintText("Dependentes:"+Alltrim(Transform (nQtdDepend,"@E 9999")),10)   
	
	oReport:EndPage(.F.)
Return
 
/*	oSecao1:Cell("VTITULO"):SetClrFore(CLR_WHITE) //cor da fonte
   oSecao1:Cell("VTITULO"):SetClrBack(CLR_BLACK) //cor do fundo
	Verifica se é um dependente do titular se sim imprime sem quebrar a linha.
	oSecao1:Cell("VTITULO"):SetClrBack(CLR_HRED) //cor do fundo
	oReport:SkipLine()//pula linha 
		If	("TRBA")->CODCART  //"T" $ ("TRBA")->TIPO  
		
		EndIf
 	
		oReport:FatLine()
	 
		oReport:FatLine()
	oReport:SkipLine(1)//pula linha
		oReport:SkipLine(1)//pula linha
*/ 


	//Totalizadores				 
//	oBreak 	:= TRBreak():New(oSecao1,{|| TRBA->TIPO },{|| "Totais do Usuário" })
//	TRFunction():New(oSecao1:Cell("VCOPART"),"","SUM",,,,,.F.,.F.)
//	TRFunction():New(oSecao1:Cell("VREAJUSTE"),"","SUM",,,,,.F.,.F.)
//	TRFunction():New(oSecao1:Cell("VTAXA"),"","SUM",,,,,.F.,.F.) 
	
//	TRFunction():New(oSecao1:Cell("VTITULO")   ,"","SUM",    ,                    ,,.F.,.F.)	
  
//    oReport:SkipLine(1)//pula linha
//	oBreak 	:= TRBreak():New(oSecao1,{|| "VCOPART" },{|| "Totais do Usuário" })
//	oBreak := TRBreak():New(oSecao1,oSecao1:Cell("VCOPART"),"Total Copart",.F.)
	
//  TRFunction():New(oSection1:Cell("nSalant"   ),NIL,"SUM",/*oBreak*/,"",cPictVl          ,/*uFormula*/,.F.,.T.) 
//    TRFunction():New(oSecao1  :Cell("VCOPART"   ),NIL,"SUM",oBreak    ,  ,"@E 99999,999.99",            ,.F.,.T.) 
    
  //  TRFunction():New(oSecao1:Cell("VREAJUSTE") ,  ,"SUM",    ,  ,"@E 99999,999.99",,.F.,.T.)
  //  TRFunction():New(oSecao1:Cell("VTITULO")   ,  ,"SUM",    ,  ,"@E 99999,999.99",,.F.,.T.)
  //  TRFunction():New(oSection1:Cell("nAp1"),"CALC_AP1","SUM",oBreak,"",PesqPictQt("D2_QUANT",16),/*uFormula*/,.F.,.T.) 
 	
// 	oReport:PrintText("Total Geral:",10)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ fCloseArea Autor ³ Davidson Clayton    ³ Data ³05/10/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Função para fechar a aerea       	                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function fCloseArea(pParTabe)
/***********************************************
* Funcao para verificar se existe tabela e exclui-la.
********/
	
	If (Select(pParTabe)!= 0)
		dbSelectArea(pParTabe)
		dbCloseArea()
		If File(pParTabe+GetDBExtension())
			FErase(pParTabe+GetDBExtension())
		EndIf
	EndIf

Return

