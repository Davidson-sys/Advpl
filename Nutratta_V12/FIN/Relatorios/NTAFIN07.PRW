#Include 'RwMake.ch'
#Include 'TopConn.ch'
#Include 'Protheus.ch'
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#include "TbiCode.ch"
#include "TbiConn.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} NTAFIN07
Impressão do Boleto do Banco Santander REGISTRADO
@author  Nelltech
@version P11 R11.80
@since   13/09/2017
@obs inicio desenvolvimento
/*/
//-------------------------------------------------------------------

User Function NTAFIN07()
	Local	aPergs      := {}
	Private lExec      	:= .F.
	Private cIndexName  := ''
	Private cIndexKey   := ''
	Private cFilter     := ''
	Private Tamanho		:= "M"
	Private titulo		:= "Impressao de Boleto com Codigo de Barras"
	Private cDesc1		:= "Este programa destina-se a impressao do Boleto com Codigo de Barras"
	Private cDesc2		:= "do Banco Santander - REGISTRADO"
	Private cDesc3		:= ""
	Private cString		:= "SE1"
	Private wnrel		:= "EDFIN01"
	Private cPerg		:= "NTAFIN07"+SPACE(02)
	Private aReturn		:= {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	Private nLastKey	:= 00
	Private lEnd		:= .F.

	//Seleciona a tabela de titulos a receber
	DbSelectArea( "SE1" )

	//Valida o grupo de perguntas
	ValidPerg()

	//Chama a tela de parametros
	Pergunte(cPerg,.T.)

	//if MV_PAR07 <> '033'
	//	MsgStop("Banco Informado nos Parâmetros da rotina diferente de 033 - Santander","A T E N Ç Ã O !!!")
	//	Return
	//endif

	//Efetua o Filtro dos Títulos baseado nos preechimento dos parametros
	cIndexName	:= Criatrab(Nil,.F.)
	cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"

    cFilter		+= " E1_SALDO > 0 " //E1_FILIAL == '" +xFilial("SE1")+ "' .And.
	cFilter		+= " .and. E1_PREFIXO >= '" +MV_PAR01+ "' .And. E1_PREFIXO <= '" +MV_PAR02+ "'"
	cFilter		+= " .and. E1_NUM >= '" +MV_PAR03+ "' .And. E1_NUM <= '" +MV_PAR04+ "'"
	cFilter		+= " .and. E1_PARCELA >= '" +MV_PAR05+ "' .And. E1_PARCELA <= '" +MV_PAR06+ "'"
	cFilter		+= " .and. (  (E1_PORTADO == '" +MV_PAR07+ "' .And. E1_CONTA == '" +MV_PAR09+ "') )"
	cFilter		+= " .and. E1_CLIENTE >= '" +MV_PAR10+ "' .And. E1_CLIENTE <= '" +MV_PAR11+ "'"
	cFilter		+= " .and. E1_LOJA >= '" +MV_PAR12+ "' .And. E1_LOJA <= '" +MV_PAR13+ "'"
	cFilter		+= " .and. DTOS(E1_EMISSAO) >= '" +DTOS(mv_par14)+"' .And. DTOS(E1_EMISSAO) <= '" +DTOS(mv_par15)+ "'"
	cFilter		+= " .and. DTOS(E1_VENCREA) >= '" +DTOS(mv_par16)+"' .And. DTOS(E1_VENCREA) <= '" +DTOS(mv_par17)+ "'"
	cFilter		+= " .and. !(E1_TIPO$MVABATIM)"
	cFilter     == " .and. E1_NUMBOR   = '"+MV_PAR20+"' "
	//cFilter		+= " .and. E1_TIPO <> 'CC' .and. E1_TIPO <> 'CD' .and. E1_TIPO <> 'BOL' .and. E1_TIPO <> 'FI '"

	//Cria a regua na tela
	IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")

	//Abre a tabela de titulos a receber e posiciona no primerio registro
	dbSelectArea("SE1")
	dbGoTop()

	//Cria tela de selecao de titulos localizados
	@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Títulos"
	@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
	@ 180,310 BMPBUTTON TYPE 01 ACTION( lExec := .T.,Close( oDlg ) )
	@ 180,280 BMPBUTTON TYPE 02 ACTION( lExec := .F.,Close( oDlg ) )

	ACTIVATE DIALOG oDlg CENTERED

	//Posicina no primeiro registro
	SE1->(dbGoTop())
	If lExec
		//Processa a funcao EDFIN01B
		Processa( { |lEnd| EDFIN02B() } )
	EndIf

	RetIndex("SE1")
	Ferase(cIndexName+OrdBagExt())

Return

/*/{Protheus.doc} EDFIN02B
Impressão do Boleto do Banco Santander
@author  Nelltech Gestão de Tecnologia
@version 1
@since 20/12/2016
@return Nil
@obs

/*/

Static Function EDFIN02B()
	Local oPrint
	Local nX := 0
	Local cNroDoc 	   :=  " "
	Local aDadosEmp
	Local aDadosTit
	Local aDadosBanco
	Local aDatSacado
	Local aBolText := {	"JUROS DE MORA DE R$ "			,;
	"POR DIA CORRIDO. "  			,;
	"ATÉ O VENCIMENTO DESC. R$ "	,;
	"PROTESTAR NO "					,;
	"DIA ÚTIL APÓS O VENCIMENTO "	}
	Local nI           	:= 1
	Local aCB_RN_NN    	:= {}
	Local nVlrAbat	   	:= 0
	Local nDvnn 	   	:= 0
	Local _cEndCli		:= ''
	Local _cCepCli 		:= ''
	Local _cEstCli 		:= ''
	Private cBanco   	:= ""
	Private cAgencia 	:= ""
	Private cConta   	:= ""
	Private aCabec  	:= {}
	Private cDestin 	:= ""
	Private cNomPdf

	If MV_PAR18 == 1

		oPrint := FWMsPrinter():New(DToS(dDataBase) + "-" + StrTran(time(),":"), IMP_PDF, .T., , .T., , , , , , .F., )
		oPrint:setup() //habilitar quando nÃ£o for mail
		oPrint:SetResolution(75)
		oPrint:SetPortrait() // ordem rerlatorio retrato
		oPrint:SetPaperSize(DMPAPER_A4)
		oPrint:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
		oPrint:lViewPDF := .T. //Visualizar PDF gerado

	Endif

	DbGoTop()

	ProcRegua(RecCount())
	dbSelectArea("SE1")
	dbGoTop()

	Do While !SE1->(EOF())

		//Se E1_OK, imprir o boleto
		If Marked("E1_OK")

			//Posiciona no Banco informado nos parametros
			DbSelectArea("SA6")
			SA6->(DbSetOrder(1))
			If !SA6->(DbSeek(xFilial("SA6")+mv_par07+mv_par08+mv_par09))
				Aviso(OemToAnsi("ATENCAO"),OemToAnsi("Banco nao localizado"),{"OK"})
				SE1->(DbSkip())
				Loop
			EndIf

			//Posiciona no Arq de Paramentros CNAB
			//	DbSelectArea("SEE")
			//	DbSetOrder(1) // EE_FILIAL + EE_CODIGO + EE_AGENCIA + EE_CONTA + EE_SUBCTA
			//	If !DbSeek(xFilial("SEE")+mv_par07+mv_par08+mv_par09 + "100")
			//		Aviso(OemToAnsi("ATENCAO"),OemToAnsi("Não localizado banco no cadastro de parametros para envio"),{"OK"})
			//		DbSelectArea("SE1")
			//		SE1->(DbSkip())
			//		Loop
			//	EndIf

			// Posiciona na Arq de Parametros CNAB
			dbSelectArea("SEE")
			dbSetOrder(1)
			dbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)

			// Posiciona o SA1 (Cliente)
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)

			DbSelectArea("SE1")

        	aDadosBanco  := {	Substr(SA6->A6_COD,1,3)			   					,;  //  [1]	Numero do Banco
			Substr(Alltrim(SA6->A6_NOME),1,15)					       					,;  //  [2]	Nome do Banco
			SA6->A6_AGENCIA										     	   					,;  //  [3]	Agencia
			Alltrim(SA6->A6_NUMCON)								       					,;  //  [4]	Conta Corrente
			Alltrim(SA6->A6_DVCTA)								     	  					,;  //  [5]	Digito da conta corrente
			Substr(SEE->EE_CODCART,1,3)                               					,;  //  [6]	Codigo da Carteira  
			''	   													                       					,;  //  [7]	Codigo do cedente
			AllTrim(SA6->A6_NUMCON) + "-" + AllTrim(SA6->A6_DVCTA)	}   	//	[8] Conta Corrente completa para impressao

			//Dados da empresa                                                                   
			aDadosEmp    := {SM0->M0_NOMECOM			   					   			,;	//	[1]	Nome da Empresa 
			SM0->M0_ENDCOB											   					   			,;	//	[2]	Endereco
			SM0->M0_BAIRCOB                                             					   			,;  //  [3] Bairro
			SM0->M0_CIDCOB                                               					   			,;  //  [4] Cidade
			SM0->M0_ESTCOB											   					   			,;	//	[5]	Estado
	    	Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)		,;	//	[6]	CEP
			SM0->M0_TEL												   						   			,;	//	[7]	Telefone
			SM0->M0_CGC												   						   			,;	//	[8]	CNPJ
			Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+			 ;  //  [9] Inscricao Estadual
			Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)			}

			//Antes verifica qual endereco o sistema deve buscar
			_cEndCli := Iif(Empty(SA1->A1_ENDCOB),AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;
			AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC) )
			_cCepCli := Iif(Empty(SA1->A1_ENDCOB),SA1->A1_CEP,SA1->A1_CEPC)
			_cEstCli := Iif(Empty(SA1->A1_ENDCOB),SA1->A1_EST,SA1->A1_ESTC)

			//Dados do Sacado
			aDatSacado   := {AllTrim(SA1->A1_NOME)            	 						,; 	// [1] Razão Social
			AllTrim(SA1->A1_COD)+"-"+SA1->A1_LOJA           		                	,; 	// [2] Código + Loja
			_cEndCli												   										,;  // [3] Endereço
			AllTrim(SA1->A1_MUN)									  								,;  // [4] Cidade
			_cEstCli                                      			   										,;	// [5] Estado
			Transform(_cCepCli,PesqPict("SA1","A1_CEP"))			  					,;  // [6] Cep
			SA1->A1_CGC										           								,;  // [7] Cnpj
			SA1->A1_PESSOA											   							,; 	// [8] Pessoa
			"N"				                           		 		   										,; 	// [9] Protesta SIM ou NAO
			""															 }											// [10]Dias de Protesto

			//Valor de abatimento
			nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

			//VErifica o numero de parcelas
			cParcel  := If(Empty(SE1->E1_PARCELA),"0",SE1->E1_PARCELA)

			//Monta codigo de barras
			//Variaveis enviadas: [1]No BCO + [2]Agencia + [3]Conta + [4]Divito Conta + [5]Codigo Carteira + [6]Numero Titulo + [7]Parcela;
			//					  [8]Valor do Titulo + [9]Vencimento do titulo + [10]Convenio + [11]Nosso Numero + [12]Desconto? (T,F) + Sequencial (compoe Nosso Numero)
			aCB_RN_NN	:= Ret_cBarra(aDadosBanco[1],aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],aDadosBanco[6],AllTrim(SE1->E1_NUM),SE1->E1_PARCELA,;
			((SE1->E1_SALDO+SE1->E1_ACRESC-SE1->E1_DECRESC)-nVlrAbat),SE1->E1_VENCREA,AllTrim(SEE->EE_CODEMP),AllTrim(SE1->E1_NUMBCO),Iif(SE1->E1_DECRESC > 0,.t.,.f.),SEE->EE_FAXATU)

			//Dados do Titulo
			aDadosTit	:= {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		                	,;  // [1] Número do título
			E1_EMISSAO                              				                                         	,;  // [2] Data da emissao do titulo
			dDataBase                    																		,;  // [3] Data da emissao do boleto
			E1_VENCREA                               				   										,;  // [4] Data do vencimento
			((SE1->E1_SALDO+SE1->E1_ACRESC-SE1->E1_DECRESC)-nVlrAbat)   ,;  // [5] Valor do titulo
			aCB_RN_NN[3]                             				   											 ,;  // [6] Nosso numero (Ver formula para calculo)
			E1_PREFIXO                               				   											 ,;  // [7] Prefixo da NF
			E1_TIPO	                           		   	 			   											 ,;  // [8] Tipo do Titulo
			E1_DECRESC                               				                                         ,;  // [9] Valor do desconto
			E1_VALJUR														                                     ,;   // [10] Valor da taxa de permanencia     
			E1_PARCELA                                         }                                                   // [11] Valor da taxa de permanencia  

			If MV_PAR18 == 2
				cNomPdf := StrTran(StrTran(StrTran(Alltrim(SE1->E1_NUM), "/"), "\"), ";")
				cNomPdf := cNomPdf+"-"+DToS(dDataBase) + "-" + StrTran(time(),":")
				oPrint := FWMsPrinter():New(cNomPdf, IMP_PDF, .T., , .T., , , , , , .F., )
				oPrint:SetResolution(75)
				oPrint:SetPortrait() // ordem rerlatorio retrato
				oPrint:SetPaperSize(DMPAPER_A4)
				oPrint:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
				oPrint:lViewPDF := .F. //false quando for mail
				oPrint:cPathPDF := "\spool\" // caminho onde será gerado o boleto
				cDestin := Alltrim(SA1->A1_EMAIL)

			Endif

			//Funca de impressao
			Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
			//nX := nX + 1

			If MV_PAR18 == 2
				oPrint:Preview()
				FreeObj(oPrint)
				oPrint := Nil
				If !Empty(cDestin)
					ENVIAEMAIL()
				EndIf
			EndIf

		EndIf

		//Pula o registro
		SE1->(DbSkip())
		IncProc()

		//Acrescenta +1 na variavel nI
		nI := nI + 1
	EndDo

	If MV_PAR18 == 1
		oPrint:Preview()
		FreeObj(oPrint)
		oPrint := Nil
	EndIf

Return nil

/*/{Protheus.doc} Impress
Impressão do Boleto do Banco Santander

@author Nelltech Gestão de Tecnologia
@version 1
@since 20/12/2016
@return Nil
@obs

/*/

Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
	Local oFont8
	Local oFont11c
	Local oFont11
	Local oFont10
	Local oFont13
	Local oFont16n
	Local oFont15
	Local oFont14n
	Local oFont24
	Local nI := 0

	Local cMailDestino := Space(70)
	Local oMailDestino
	Local _oDlg

	Local cMsg 	  := " "

	oPrint:StartPage()// Inicia uma nova pagina

	//Parametros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)
	oFont8   := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9   := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11  := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont13  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont18  := TFont():New("Arial",9,19,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont21  := TFont():New("Arial",9,22,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont22n := TFont():New("Arial",9,23,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n := TFont():New("Arial",9,17,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15  := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont24  := TFont():New("Arial",9,25,.T.,.T.,5,.T.,5,.T.,.F.)

	/******************/
	/* PRIMEIRA PARTE */
	/******************/

	nRow1 := 0

	oPrint:Line (nRow1+0120,500,nRow1+0040, 500)
	oPrint:Line (nRow1+0120,710,nRow1+0040, 710)
	oPrint:SayBitmap(nRow1+0020,100,"BOL033.JPG",0350,0090)

	oPrint:Say  (nRow1+0075,510,aDadosBanco[1]+"-7",oFont20 )		// [1]Numero do Banco

	oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
	oPrint:Line (nRow1+0120,100,nRow1+0120,2300)

	oPrint:Say  (nRow1+0150,100 ,"Beneficiario",oFont8)
	oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10)					//Nome + CNPJ

	oPrint:Say  (nRow1+0150,1060,"Agência/Código Cedente",oFont8)
	oPrint:Say  (nRow1+0200,1060,AllTrim(aDadosBanco[3]) + " / " + aDadosBanco[4] + "-" + aDadosBanco[5],oFont10)
	//oPrint:Say  (nRow1+0200,1060,AllTrim(aDadosBanco[3]) + " / " + aDadosBanco[8] ,oFont10)

	oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
	oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1]+" / "+aDadosTit[11],oFont10) //Prefixo +Numero+Parcela

	oPrint:Say  (nRow1+0250,100 ,"Pagador",oFont8)
	oPrint:Say  (nRow1+0300,100 ,left(aDatSacado[1],40),oFont10)	//Nome

	oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
	oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

	oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
	oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

	oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título"	,oFont10 )
	oPrint:Say  (nRow1+0450,0100,"com as caracteristicas acima."	,oFont10 )
	oPrint:Say  (nRow1+0350,1060,"Data"								,oFont8  )
	oPrint:Say  (nRow1+0350,1410,"Assinatura"						,oFont8  )
	oPrint:Say  (nRow1+0450,1060,"Data"								,oFont8  )
	oPrint:Say  (nRow1+0450,1410,"Entregador"						,oFont8  )

	oPrint:Line (nRow1+0220, 100,nRow1+0220,1900 )
	oPrint:Line (nRow1+0320, 100,nRow1+0320,1900 )
	oPrint:Line (nRow1+0420,1050,nRow1+0420,1900 )
	oPrint:Line (nRow1+0520, 100,nRow1+0520,2300 )

	oPrint:Line (nRow1+0520,1050,nRow1+0120,1050 )
	oPrint:Line (nRow1+0520,1400,nRow1+0320,1400 )
	oPrint:Line (nRow1+0320,1500,nRow1+0120,1500 )
	oPrint:Line (nRow1+0520,1900,nRow1+0120,1900 )

	oPrint:Say  ( nRow1+0165,1910,"(  )Mudou-se"					,oFont8 )
	oPrint:Say  ( nRow1+0205,1910,"(  )Ausente"						,oFont8 )
	oPrint:Say  ( nRow1+0245,1910,"(  )Não existe não indicado"		,oFont8 )
	oPrint:Say  ( nRow1+0285,1910,"(  )Recusado"					,oFont8 )
	oPrint:Say  ( nRow1+0325,1910,"(  )Não procurado"				,oFont8 )
	oPrint:Say  ( nRow1+0365,1910,"(  )Endeço insuficiente"			,oFont8 )
	oPrint:Say  ( nRow1+0405,1910,"(  )Desconhecido"				,oFont8 )
	oPrint:Say  ( nRow1+0445,1910,"(  )Falecido"					,oFont8 )
	oPrint:Say  ( nRow1+0485,1910,"(  )Outros(anotar no verso)"		,oFont8 )

	/*****************/
	/* SEGUNDA PARTE */
	/*****************/
	nRow2 := 110

	//Pontilhado separador
	For nI := 100 to 2300 step 50
		oPrint:Line(nRow2+0550, nI,nRow2+0550, nI+30)
	Next nI

	oPrint:Line (nRow2+0680,100,nRow2+0680,2300)
	oPrint:Line (nRow2+0680,500,nRow2+0600, 500)
	oPrint:Line (nRow2+0680,710,nRow2+0600, 710)
	oPrint:SayBitmap(nRow2+0580,100,"BOL033.JPG",0350,0090)

	oPrint:Say  (nRow2+0635,510,aDadosBanco[1]+"-7",oFont20 )	// [1]Numero do Banco

	oPrint:Say  (nRow2+0644,1800,"Recibo do Pagador",oFont10)

	oPrint:Line (nRow2+0780,100,nRow2+0780,2300 )
	oPrint:Line (nRow2+0880,100,nRow2+0880,2300 )
	oPrint:Line (nRow2+0950,100,nRow2+0950,2300 )
	oPrint:Line (nRow2+1020,100,nRow2+1020,2300 )
    oPrint:Line (nRow2+1090,100,nRow2+1090,2300 )

	oPrint:Line (nRow2+0950,500,nRow2+1090,500)
	oPrint:Line (nRow2+1020,770,nRow2+1090,770)
	oPrint:Line (nRow2+0950,1000,nRow2+1090,1000)
	oPrint:Line (nRow2+0950,1300,nRow2+1020,1300)
	oPrint:Line (nRow2+0950,1480,nRow2+1090,1480)

	oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
	oPrint:Say  (nRow2+0750,100 ,"PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO, APÓS SOMENTE NO BANCO SANTANDER.",oFont10)
	oPrint:Say  (nRow2+0765,400 ," ",oFont10)

	oPrint:Say  (nRow2+0710,1810,"Vencimento",oFont8)
	cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol := 1820+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

	oPrint:Say  (nRow2+0810,100 ,"Beneficiário",oFont8)
	oPrint:Say  (nRow2+0850,100 ,AllTrim(aDadosEmp[1])  ,oFont10) //Nome + CNPJ

	oPrint:Say  (nRow2+0810,1250 ,"CNPJ do Beneficiário: " + Transform(aDadosEmp[8],"@R 99.999.999/9999-99") ,oFont8)

	oPrint:Say  (nRow2+0810,1810,"Agência/Código Beneficiário",oFont8)
	cString := Alltrim(AllTrim(aDadosBanco[3]) + " / " + aDadosBanco[4] + "-" + aDadosBanco[5])
	//cString := Alltrim(AllTrim(aDadosBanco[3]) + " / " + aDadosBanco[8])
	nCol := 1820+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)

    oPrint:Say (nRow2+0910,0100,"Endereço Beneficiário",oFont8)
    oPrint:Say (nRow2+0940,0100,AllTrim(aDadosEmp[2])+" "+Alltrim(aDadosEmp[3])+" "+Alltrim(aDadosEmp[4]) + " - " + AllTrim(aDadosEmp[5]) + " - " + AllTrim(aDadosEmp[6]) + " - " + AllTrim(aDadosEmp[7]) ,oFont10)					// [1] Nome
	

	oPrint:Say  (nRow2+0980,100 ,"Data do Documento",oFont8)
	oPrint:Say  (nRow2+1010,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

	oPrint:Say  (nRow2+0980,505 ,"Nro.Documento",oFont8)
	oPrint:Say  (nRow2+1010,605 ,aDadosTit[7]+aDadosTit[1]+" / "+aDadosTit[11],oFont10) //Prefixo +Numero+Parcela

	oPrint:Say  (nRow2+0980,1005,"Especie Doc.",oFont8)
	oPrint:Say  (nRow2+1010,1050,"DM",oFont10) 		  //Tipo do Titulo

	oPrint:Say  (nRow2+0980,1305,"Aceite",oFont8)
	oPrint:Say  (nRow2+1010,1400,"N",oFont10)

	oPrint:Say  (nRow2+0980,1485,"Data do Processamento",oFont8)
	oPrint:Say  (nRow2+1010,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao



	oPrint:Say  (nRow2+0910,1810,"Nosso Número",oFont8)
	nCol := 1820+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0940,nCol, Transform(aCB_RN_NN[3],"@R 999999999999-9") ,oFont11c)

	oPrint:Say  (nRow2+1050,100 ,"Uso do Banco",oFont8)

	oPrint:Say  (nRow2+1050,505 ,"Carteira",oFont8)
	oPrint:Say  (nRow2+1080,500 ,"   RCR" /*aDadosBanco[6]*/,oFont9)

	oPrint:Say  (nRow2+1050,775 ,"Especie",oFont8)
	oPrint:Say  (nRow2+1080,805 ,"REAL",oFont10)
	oPrint:Say  (nRow2+1050,1005,"Quantidade",oFont8)
	oPrint:Say  (nRow2+1050,1485,"Valor"     ,oFont8)


	oPrint:Say  (nRow2+0980,1810,"Valor do Documento",oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol := 1820+(374-(len(cString)*22))
	oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)


	oPrint:Say  (nRow2+1120,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Cedente)",oFont8)

	oPrint:Say  (nRow2+1160,100 ,"APOS O VENCIMENTO COBRAR MORA DE  R$ "+Alltrim(Transform((SE1->E1_SALDO*SE1->E1_PORCJUR)/100, "@E 99,999,999.99"))+"  AO DIA",oFont10)  
	oPrint:Say  (nRow2+1200,100 ,"APOS O VENCIMENTO COBRAR R$ "+Alltrim(Transform(((SE1->E1_SALDO*SEE->EE_N_MULTA)/100), "@E 99,999,999.99"))+"  DE MULTA.",oFont10)       

	//oPrint:Say  (nRow2+1150,100 ,aBolText[1] + " " + AllTrim(Transform((aDadosTit[10]),"@E 99,999.99") + " " + aBolText[2])  ,oFont10)
	//If aDadosTit[9] <> 0
	//	oPrint:Say  (nRow2+1200,100 ,aBolText[3] + " " + AllTrim(Transform(aDadosTit[9],"@E 99,999.99"))  ,oFont10)
	//EndIf

	//If aDatSacado[9] <> "N"
	//	 oPrint:Say  (nRow2+1250,100 ,aBolText[4]+"  "+aDatSacado[10]+"  "+aBolText[5] ,oFont10)
	//Endif

	oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento",oFont8)
	oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções"    ,oFont8)
	oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"         ,oFont8)
	oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"  ,oFont8)
	oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"      ,oFont8)

	oPrint:Say  (nRow2+1400,100 ,"Pagador",oFont8)
	oPrint:Say  (nRow2+1430,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)
	oPrint:Say  (nRow2+1483,350 ,aDatSacado[3],oFont10)
	oPrint:Say  (nRow2+1536,350 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

	if aDatSacado[8] = "J"
		oPrint:Say  (nRow2+1589,350 ,"CNPJ: " + TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:Say  (nRow2+1589,350 ,"CPF: " + TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf

	//oPrint:Say  (nRow2+1589,1850,Substr(aDadosTit[6],1,3)+" "+Substr(aDadosTit[6],4)  ,oFont10)

	oPrint:Say  (nRow2+1605,100 ,"Pagador/Avalista",oFont8)
	oPrint:Say  (nRow2+1645,1500,"Autenticacao Mecanica",oFont8)

	oPrint:Line (nRow2+0680,1800,nRow2+1370,1800 )
	oPrint:Line (nRow2+1090,1800,nRow2+1090,2300 )
	oPrint:Line (nRow2+1160,1800,nRow2+1160,2300 )
	oPrint:Line (nRow2+1230,1800,nRow2+1230,2300 )
	oPrint:Line (nRow2+1300,1800,nRow2+1300,2300 )
	oPrint:Line (nRow2+1370,100 ,nRow2+1370,2300 )
	oPrint:Line (nRow2+1610,100 ,nRow2+1610,2300 )

	/******************/
	/* TERCEIRA PARTE */
	/******************/

	nRow3 := 20

	For nI := 100 to 2300 step 50
		oPrint:Line(nRow3+1850, nI, nRow3+1850, nI+30)
	Next nI

	oPrint:Line (nRow3+1970,100,nRow3+1970,2300)
	oPrint:Line (nRow3+1970,500,nRow3+1890, 500)
	oPrint:Line (nRow3+1970,710,nRow3+1890, 710)
	oPrint:SayBitmap(nRow3+1870,100,"BOL033.JPG",0350,0090)

	oPrint:Say  (nRow3+1925,510,aDadosBanco[1]+"-7",oFont20 )	// 	[1]Numero do Banco

	oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont15)  	//	Linha Digitavel do Codigo de Barras

	oPrint:Line (nRow3+2070,100,nRow3+2070,2300 )
	oPrint:Line (nRow3+2170,100,nRow3+2170,2300 )
	oPrint:Line (nRow3+2240,100,nRow3+2240,2300 )
	oPrint:Line (nRow3+2310,100,nRow3+2310,2300 )

	oPrint:Line (nRow3+2170,500 ,nRow3+2310,500 )
	oPrint:Line (nRow3+2240,770 ,nRow3+2310,770 )
	oPrint:Line (nRow3+2170,1000,nRow3+2310,1000)
	oPrint:Line (nRow3+2170,1300,nRow3+2240,1300)
	oPrint:Line (nRow3+2170,1480,nRow3+2310,1480)

	oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
	oPrint:Say  (nRow3+2040,100 ,"PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO, APÓS SOMENTE NO BANCO SANTANDER.",oFont10)

	oPrint:Say  (nRow3+2055,400 ," ",oFont10)

	oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
	cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol	 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

	oPrint:Say  (nRow3+2100,100 ,"Beneficiário",oFont8)
	oPrint:Say  (nRow3+2140,100 ,AllTrim(aDadosEmp[1]) + " - "+aDadosEmp[2]	,oFont10) //Nome + CNPJ

	oPrint:Say  (nRow3+2100,1810,"Agência/Código Beneficiário",oFont8)
	cString := Alltrim(AllTrim(aDadosBanco[3]) + " / " + aDadosBanco[4] + "-" + aDadosBanco[5])
	//cString := Alltrim(AllTrim(aDadosBanco[3]) + " / " + aDadosBanco[8] )
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)

	oPrint:Say  (nRow3+2200,100 ,"Data do Documento",oFont8)
	oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

	oPrint:Say  (nRow3+2200,505 ,"Nro.Documento",oFont8)
	oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1]+" / "+aDadosTit[11],oFont10) //Prefixo +Numero+Parcela

	oPrint:Say  (nRow3+2200,1005,"Espécie Doc.",oFont8)
	oPrint:Say  (nRow3+2230,1050,"DM",oFont10) 		  //Tipo do Titulo

	oPrint:Say  (nRow3+2200,1305,"Aceite",oFont8)
	oPrint:Say  (nRow3+2230,1400,"N"     ,oFont10)

	oPrint:Say  (nRow3+2200,1485,"Data do Processamento",oFont8)
	oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

	oPrint:Say  (nRow3+2200,1810,"Nosso Número",oFont8)
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2230,nCol,Transform(aCB_RN_NN[3],"@R 999999999999-9"),oFont11c)

	oPrint:Say  (nRow3+2270,100 ,"Uso do Banco",oFont8)

	oPrint:Say  (nRow3+2270,505 ,"Carteira"	,oFont8)
	oPrint:Say  (nRow3+2300,500 ,"   RCR" /*aDadosBanco[6]*/,oFont9)

	oPrint:Say  (nRow3+2270,775 ,"Espécie"	,oFont8)
	oPrint:Say  (nRow3+2300,805 ,"REAL"     ,oFont10)
	oPrint:Say  (nRow3+2270,1005,"Quantidade",oFont8)
	oPrint:Say  (nRow3+2270,1485,"Valor"     ,oFont8)

	oPrint:Say  (nRow3+2270,1810,"Valor do Documento",oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

	oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiário)",oFont8) 
	
	oPrint:Say  (nRow2+2300,100 ,"APOS O VENCIMENTO COBRAR MORA DE  R$ "+Alltrim(Transform((SE1->E1_SALDO*SE1->E1_PORCJUR)/100, "@E 99,999,999.99"))+"  AO DIA",oFont10)  
	oPrint:Say  (nRow2+2340,100 ,"APOS O VENCIMENTO COBRAR R$ "+Alltrim(Transform(((SE1->E1_SALDO*SEE->EE_N_MULTA)/100), "@E 99,999,999.99"))+"  DE MULTA.",oFont10)    

	oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento",oFont8)
	oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduções"    ,oFont8)
	oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"         ,oFont8)
	oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"  ,oFont8)
	oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"      ,oFont8)

	oPrint:Say  (nRow3+2690,100 ,"Pagador",oFont8)
	oPrint:Say  (nRow3+2700,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)

	if aDatSacado[8] = "J"
		oPrint:Say (nRow3+2700,1800,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:Say (nRow3+2700,1800,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 		// CPF
	EndIf

	oPrint:Say  (nRow3+2753,350 ,aDatSacado[3],oFont10)
	oPrint:Say  (nRow3+2806,350 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) 		// CEP+Cidade+Estado

	//oPrint:Say  (nRow3+2806,1850,Substr(aDadosTit[6],1,3)+" "+Substr(aDadosTit[6],4)  ,oFont10)

	oPrint:Say  (nRow3+2815,100 ,"Pagador/Avalista",oFont8)
	oPrint:Say  (nRow3+2855,1500,"Autenticações Mecânica - Ficha de Compensação",oFont8)

	oPrint:Line (nRow3+1970,1800,nRow3+2660,1800)
	oPrint:Line (nRow3+2380,1800,nRow3+2380,2300)
	oPrint:Line (nRow3+2450,1800,nRow3+2450,2300)
	oPrint:Line (nRow3+2520,1800,nRow3+2520,2300)
	oPrint:Line (nRow3+2590,1800,nRow3+2590,2300)
	oPrint:Line (nRow3+2660,100 ,nRow3+2660,2300)
	oPrint:Line (nRow3+2820,100 ,nRow3+2820,2300)

	//MSBAR("INT25",26.7,1.5,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
	oPrint:FWMSBAR("INT25", 68, 2, aCB_RN_NN[1], oPrint, .F., Nil, .T., 0.035, 1.2, Nil, Nil, "A", .F.)

	//oPrint:FwMsBar("INT25",  40.3 ,1.7,CB_RN_NN[1],oPrint, .F. ,NIL               ,  .T.  , 0.0250   ,1.1  , NIL       , "Arial",   Nil,.T.,  1,  1 ,.F. )

	cConta := SA6->A6_NUMCON

	oPrint:EndPage() // Finaliza a pagina

Return Nil

/*/ {Protheus.doc} Ret_cBarra
Retorna o Código de Barras do Boleto
@author Nelltech Gestão de Tecnologia
@version 1
@since 224/12/2016
@return Nil
@obs
@sample
/*/

Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,_cParcela,nValor,dvencimento,cCodCed,cNossNum,_lTemDesc,cSequencial)
	Local cNumSeq 		:= StrZero(Val(cSequencial) + 1 ,12)
	Local nValBar 		:= Strzero((nValor*100),10)
	Local cNossNumSD	:= ''
	Local cCodBarSD		:= ''
	Local cDvCodBar		:= ''
	Local cDv			:= ''
	Local cCodBarra		:= ''
	Local cCpoLivre 	:= ''
	Local cFatVenc 		:= ''
	Local cLBlSDv01		:= ''
	Local cLBlCDv01		:= ''
	Local cLBlSDv02		:= ''
	Local cLBlCDv02		:= ''
	Local cLBlSDv03		:= ''
	Local cLBlCDv03		:= ''
	Local cLBlSDv04		:= ''
	Local cLBlSDv05		:= ''
	Local cLindig		:= ''

	//Verifica o numero da parcela
	_cParcela := NumParcela(_cParcela)

	//Fator Vencimento - POSICAO DE 06 A 09
	cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)

	//Composicao do nosso numero
	If Empty(cNossNum)  //Verificar se o boleto já foi impresso para esse título anteriormente
		//Nosso Numero sem DigitoADMINA
	//	cNossNumSD := cNumSeq

		// Grava o número utilizado na tabela de Parâmetros de Banco
//		DbSelectArea("SA6")
	//	RecLock("SA6",.F.)
	//	SA6->A6_XSEQNOS := cNumSeq
	//	SA6->(DbUnlock())

	//Pega o nosso numero dos parametros de banco
	cNossNumSD := StrZero(Val(Alltrim(SEE->EE_FAXATU))+1,12)
	cNumSeq    := cNossNumSD
				
	//Grava o próximo número
	SEE->(RecLock("SEE",.f.))
	SEE->EE_FAXATU := cNossNumSD
	SEE->(MsUnlock())
			

		// Grava no título o seu "N/N" Nosso Número para futura consulta no ato da baixa do título
		DbSelectArea("SE1")
		RecLock("SE1",.F.)
		SE1->E1_NUMBCO 	:= cNumSeq    //Nosso numero
		SE1->E1_IDCNAB 	:= cNumSeq    //Nosso numero
		SE1->E1_PORTADO	:= cBanco
		SE1->E1_AGEDEP	:= cAgencia
		SE1->E1_CONTA	:= cConta
		SE1->(DbUnlock())

		//Nosso numero completo
		cNossNum := cNossNumSD + cvaltochar(u_Modulo11a(cNossNumSD))
	else
		cNossNumSD := AllTrim(SE1->E1_NUMBCO)
		cNossNum := cNossNumSD + cvaltochar(u_Modulo11a(cNossNumSD))
	Endif

	//Composicao do Ccdigo de barras sem o DV
	//No BCO + Cod Moeda + Fat Vencto + Valor + Fixo 9 + Cod Cedente +  Nosso Numero + IOP = 0 + Tp Mod Carteira
	cCodBarSD := cBanco + '9' + cFatVenc + nValBar + '9' + substr(cCodCed,1,7)+  cNossNum + '0' + cCarteira

	//Calculo do Dv do Codigo de barras
	//Seguir o modelo 11 do leiaute do banco Santander
	cDvCodBar := Modulo11b(cCodBarSD)

	//Transformar o valor recebido em string
	cDv := cvaltochar(cDvCodBar)

	//Composicao do codigo de barras completo
	//           No BCO + Cod Moeda + Dv Cod Barras + Fat Vencto + Valor + Fixo 9 + Cod Cedente + Nosso Numero + IOP = 0 + Tp Mod Carteira
	cCodBarra := cBanco + '9' + cDv + cFatVenc + nValBar + '9' + substr(cCodCed,1,7) + cNossNum + '0' + cCarteira

	//Linha digitavel
	//Primeiro Grupo
	/*-------------------------------------------------------------------------------------------------
	Utilizar o  Modulo 10 para calculo do DV do campo

	Posicao 	Tamanho 	Picture 	Conteudo
	01-03 		3 			9 (03) 		Banco = 033
	04-04 		1 			9 (01) 		Codigo da moeda = 9 (real) / Codigo da moeda = 8 (outras moedas)
	05-05 		1 			9 (01) 		Fixo 9
	06-09 		4			9 (04) 		Codigo do Cedente padrao Santander Banespa
	10-10 		1 			9 (01) 		Codigo verificador do primeiro grupo
	-------------------------------------------------------------------------------------------------*/
	cLBlSDv01 := cBanco + '99' + "." + SubStr(cCodCed,1,4) + AllTrim(cvaltochar(Modulo10(cBanco+'99'+SubStr(cCodCed,1,4))))	//Bloco 01 com o digito

	//Segundo Grupo
	/*-------------------------------------------------------------------------------------------------
	Utilizar o  Modulo 10 para calculo do DV do campo

	Posicao 	Tamanho 	Picture 	Conteudo
	11-13 		3 			9 (03) 		Restante do codigo do cedente padrao Santander Banespa
	14-20 		7 			9 (07) 		7 primeiros campos do N/N
	21-21 		1 			9 (01) 		Digito verificador do segundo grupo

	Ex.:  033 5666124

	0 3 3 5 6 6 6 1 2 4
	x x x x x x x x x x
	1 2 1 2 1 2 1 2 1 2
	---------------------------------------------------------------------------------------------------*/
	cLBlSDv02 := SubStr(cCodCed,5,3) + Substr(cNossNum,1,7)																	//Bloco 02 sem o digito
	cLBlCDv02 := SubStr(cLBlSDv02,1,5) + '.' + SubStr(cLBlSDv02,6,Len(cLBlSDv02)) + AllTrim(cvaltochar(Modulo10(cLBlSDv02)))//Bloco 02 com o digito

	//Terceiro Grupo
	/*-------------------------------------------------------------------------------------------------
	Utilizar o  Modulo 10 para calculo do DV do campo

	Posicao 	Tamanho 	Picture 	Conteudo
	22-27 		6 			9 (06) 		Restante do Nosso Numero
	28-28 		1 			9 (01) 		IOS e somente para Seguradoras (Se 7%informar 7, limitado a 9%)
	Demais clientes usar 0 (zero)
	29-31 		3 			9 (03) 		Tipo de Modalidade Carteira 101-Cobranca Simples Rapida COM Registro
	102- Cobranca simples SEM Registro
	201- Penhor
	32-32 		1 			9 (01) 		Digito verificador do terceiro grupo

	Ex.:  578000 0 102

	5 7 8 0 0 0 0 1 0 2
	x x x x x x x x x x
	1 2 1 2 1 2 1 2 1 2
	--------------------------------------------------------------------------------------------------*/
	cLBlSDv03 := Substr(cNossNum,8,Len(cNossNum)) + '0' + cCarteira				//Bloco 03 sem o digito
	cLBlCDv03 := SubStr(cLBlSDv03,1,5) + '.' + SubStr(cLBlSDv03,6,Len(cLBlSDv03)) + AllTrim(cvaltochar(Modulo10(cLBlSDv03)))		//Bloco 03 com o digito

	//Quarto Grupo
	/*-------------------------------------------------------------------------------------------------
	Composto apenas pelo DV do codigo de barras.
	Para o calculo, utilizar os valores referentes aos campos do Codigo de Barras
	O resultado sera o quarto grupo da linha digitavel IPTE.

	Posicao 	Tamanho 	Picture 	Conteudo
	33-33 		1 			9 (01) 		Digito Verificador do Codigo de Barras
	--------------------------------------------------------------------------------------------------*/
	cLBlSDv04 := cDv 														//Bloco 04 com o digito

	//Quarto Grupo
	/*-------------------------------------------------------------------------------------------------
	Composto pelas 04 posicoes do fator vencimento e as 10 posicoes do valor nominal do titulo.
	Este campo nao tem digito verificador.
	Quando se tratar de valor zerado, a representacao deve ser 0000000000 (Dez zeros).

	Posicao 	Tamanho 	Picture 	Conteudo
	34-36 		4 			9 (04) 		Fator de Vencimento
	37-47 		10 			9 (10) 		Valor do Titulo

	Ex.:  2046 0000027371
	--------------------------------------------------------------------------------------------------*/
	cLBlSDv05 := cFatVenc +  nValBar						//Bloco 05 com o digito

	//Compposicao da linha digitavel
	//Exemplo: 99999.99999 99999.999999 99999.999999 9 99999999999999
	cLindig := cLBlSDv01 + Space(1) + cLBlCDv02 + Space(1) + cLBlCDv03 + Space(1) + cLBlSDv04 + Space(1) + cLBlSDv05

	//Retorna um array com o codigo de barras, linha digitavel e nosso numero
Return({cCodBarra,cLinDig,cNossNum})

/*/ {Protheus.doc} NumParcela
Ajusta a parcela
@author Klaus Schneider Peres
@version 1
@since 04/10/2013
@return Nil
@obs
@sample
/*/
Static Function NumParcela(_cParcela)
	Local _cRet := ""

	If ASC(_cParcela) >= 65 .or. ASC(_cParcela) <= 90
		_cRet := StrZero(Val(Chr(ASC(_cParcela)-16)),1)
	Else
		_cRet := StrZero(Val(_cParcela),2)
	Endif

Return(_cRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} Modulo11a
Calculo do digito verificador Nosso Numero
@author  Antonio Nascimento
@version P11 R11.80
@since   03/2014
/*/
//-------------------------------------------------------------------

USER  Function Modulo11a(cCodBarSD)
	/*----------------------------------------------------------------------------------------------------------------
	Módulo 11 - Multiplicar da direita para a esquerda, aplicando o peso de 2 até 9, até o final do número,
	reiniciando em 2 se necessário. Somar os resultados obtidos e dividi-lo por 11 (onze).
	Se o resto desta divisão for igual a 10(dez) o dígito será = 1 (um), se for igual a 0 (zero) ou  1 (um)  o digito será 0 (zero).
	Qualquer “Resto” diferente de “0,1 ou 10” subtrair o resto de 11 para obter o dígito.
	------------------------------------------------------------------------------------------------------------------*/
	Local nPeso1 	:= 2
	Local nPeso2 	:= 9
	Local nTot 		:= 0
	Local nMul 		:= nPeso1
	Local i         := 0
	Local nResult	:= 0
	Local cRet		:= ''

	//Executa o calculo dos valores recebidos para compor o digito
	For i := Len(cCodBarSD) to 1 step -1
		nTot += Val(SubStr(cCodBarSD,i,1)) * nMul
		nMul := if(nMul=nPeso2, nPeso1, nMul+1)
	Next

	//Modulo do resultado
	_nResto := Mod(nTot,11)
	nResult :=  _nResto

	//Testa se o resto esta entre 0,1 ou 10
	If(nResult == 10)
		cRet := '1'
	ElseIf (nResult == 1 .Or. nResult == 0)
		cRet := '0'
	Else
		nResult := nResult-11
		cRet := Str(abs(nResult),1)
	EndIf

Return(cRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} Modulo11b
calculo do digito verificador do codigo de barras
@author  Antonio Nascimento
@version P11 R11.80
@since   03/2014
/*/
//-------------------------------------------------------------------

Static Function Modulo11b(cCodBarSD)

	Local nPeso1 	:= 2
	Local nPeso2 	:= 9
	Local nTot 		:= 0
	Local nMul 		:= nPeso1
	Local i         := 0
	Local nResult	:= 0
	Local cRet		:= ''

	//Executa o calculo dos valores recebidos para compor o digito
	For i := Len(cCodBarSD) to 1 step -1
		nTot += Val(SubStr(cCodBarSD,i,1)) * nMul
		nMul := if(nMul=nPeso2, nPeso1, nMul+1)
	Next

	//Multiplica o resultado por 10
	nResult := (nTot*10)

	//Modulo do resultado
	nResult := Mod(nResult,11)

	//Testa se o resto esta entre 0,1 ou 10
	/*------------------------------------------------------------------
	Nota: O resto desta divisao sera o digito de controle.
	Se o resto for igual a 0, 1 ou 10 o digito sera = 1 (um).
	-------------------------------------------------------------------*/
	If(nResult == 10 .Or. nResult == 1 .Or. nResult == 0)
		cRet := '1'
	Else
		cRet := Str(nResult,1)
	EndIf

Return(cRet)

/*/ {Protheus.doc} Modulo10
Cálculo do dígito verificador da linha digitável
@author Klaus Schneider Peres
@version 1
@since 04/10/2013
@return Nil
@obs
@sample
/*/
Static Function Modulo10(cLBlSDv01)
	Local i			:= 0
	Local nMul 		:= 2
	Local nTot		:= 0
	Local nVal		:= 0
	Local nResult 	:= 0

	/*--------------------------------------------------------------------------------------------
	Módulo 10 - CÁLCULO:

	Multiplicar, da direita para a esquerda, por 2 e 1, respectivamente, ate o final do numero.
	Somar os resultados obtidos. Dividir o total desta soma por dez.
	Se o resto for = 0, o dogito sera = 0, se diferente subtrair o divisor pelo resto, ou seja,
	subtrair 10 do resto.
	Obs.: Quando o resultado da multiplicacao for > 9, efetuar a soma os dois digitos.
	Ex: 9 x 2 = 18, entao 1+ 8 = 9

	Exemplo:  033 9 9 0282

	0 3 3 9 9 0 2 8 2
	x x x x x x x x x
	2 1 2 1 2 1 2 1 2
	---------------------------------------------------------------------------------------------*/

	//Executa o calculo dos valores recebidos para compor o digito
	For i := Len(cLBlSDv01) to 1 step -1
		nVal := Val(SubStr(cLBlSDv01,i,1)) * nMul

		//Verifica se o total é > que 9, se sim somar os dois algoritimos
		If nVal > 9
			nTot += Val(LEFT (cValToChar(nVal),1))
			nTot += Val(RIGHT(cValToChar(nVal),1))
		Else //Caso contraio só somar o número
			nTot += nVal
		Endif

		//Fator multiplicador que deve ser alterado a cada calculo, 2 e 1 respectivamente
		nMul := If(nMul=2, 1, nMul+1)

	Next

	//Dividir o somatorio dos valores por 10
	nResult := (nTot%10)

	//Se o resto for 0, retornar Zero, caso contrario subtrair o divisor pelo resto
	If nResult == 0
		cRet := '0'
	Else
		cRet := Str(10 - nResult)
	Endif

Return (cRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} ENVIAEMAIL
Rotina de Envio de E-mail dos Boletos

@author  Antonio Nascimento
@version P11 R11.80
@since   11/03/2014
@obs
/*/
//-------------------------------------------------------------------

Static Function ENVIAEMAIL()

	Local lResult   	:= .f.	// Resultado da tentativa de comunicacao com servidor de E-Mail
	Local cTitulo 		:= "Titulo: Boleto Bancario - NUTRATTA"
	Local cAttachment 	:=  ""
	Local lAutentica    := GetMV("MV_RELAUTH") //Renato S. Parreira - 29/01/07
	Local cNome         := ""
	Local cMensagem     :=""

	cMensagem := "Prezado Cliente, "+ CRLF+ CRLF
	cMensagem += "Segue em anexo boleto bancário para pagamento. "+ CRLF
	cMensagem += "Colocamo-nos à disposição para dirimir eventuais dúvidas."+ CRLF + CRLF
	cMensagem += "Desde já agradecemos."+ CRLF + CRLF
	cMensagem += "Atenciosamente,"+ CRLF + CRLF

	cMensagem += "'Financeiro - Nutratta Ração Inteligente "+ CRLF
	cMensagem += "'financeiro.nutratta@nutratta.com.br "+ CRLF
	cMensagem += "www.nutratta.com.br "+ CRLF
	cMensagem += "(64) 3432 - 7200 "+ CRLF

	cAttachment := "\SPOOL\"+ALLTRIM(cNomPdf)+".PDF"

	//Tenta conexao com o servidor de E-Mail
	CONNECT SMTP;
	SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
	ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
	PASSWORD GetMV("MV_RELPSW") ; 	// Senha
	RESULT   lResult             	// Resultado da tentativa de conexÃ£o

	If !lResult

		//Nao foi possivel estabelecer conexao com o servidor
		Help(" ",1,"ACAA170_01") 	// _cErro := MailGetErr()

	Else

		//Verifica se o E-mail necessita de Autenticacao
		if lAutentica
			MailAuth(GetMV("MV_RELACNT"),GetMV("MV_RELPSW"))
		endif

		SEND MAIL;
		FROM 		GetMV("MV_RELFROM");
		TO 			cDestin;
		BCC			alltrim(MV_PAR19);
		SUBJECT 	cTitulo;
		BODY 		cMensagem;
		ATTACHMENT	cAttachment;
		RESULT 		lResult

		//Finaliza conexao com o servidor de E-Mail
		DISCONNECT SMTP SERVER

	EndIf

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} ValidPerg
Cria as Perguntas no SX1

@author  Antonio Nascimento
@version P11 R11.80
@since   11/03/2014
@obs
/*/
//-------------------------------------------------------------------

Static Function ValidPerg()
	Local _aArea	:= (GetArea())
	Local aRegs		:= {}
	Local i,j

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))
	cPerg := PADR(cPerg,10)

	aAdd(aRegs,{cPerg,"01","De Prefixo     ?","","","mv_ch1","C",03,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Ate Prefixo    ?","","","mv_ch2","C",03,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","De Numero      ?","","","mv_ch3","C",09,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Ate Numero     ?","","","mv_ch4","C",09,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","De Parcela     ?","","","mv_ch5","C",02,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Ate Parcela    ?","","","mv_ch6","C",02,0,0,"G","","MV_PAR06","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"07","Do Portador	   ?","","","mv_ch7","C",03,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	Aadd(aRegs,{cPerg,"08","Da Agencia	   ?","","","mv_ch8","C",05,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"09","Da Conta	   ?","","","mv_ch9","C",10,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"10","De Cliente     ?","","","mv_cha","C",08,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
	aAdd(aRegs,{cPerg,"11","Ate Cliente    ?","","","mv_chb","C",08,0,0,"G","","MV_PAR11","","","","ZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
	aAdd(aRegs,{cPerg,"12","De Loja        ?","","","mv_chc","C",04,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"13","Ate Loja       ?","","","mv_chd","C",04,0,0,"G","","MV_PAR13","","","","ZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"14","De Emissao     ?","","","mv_che","D",08,0,0,"G","","MV_PAR14","","","","01/01/17","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"15","Ate Emissao    ?","","","mv_chf","D",08,0,0,"G","","MV_PAR15","","","","31/12/20","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"16","De Vencimento  ?","","","mv_chg","D",08,0,0,"G","","MV_PAR16","","","","01/01/17","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"17","Ate Vencimento ?","","","mv_chh","D",08,0,0,"G","","MV_PAR17","","","","31/12/20","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"18","E-mail/Impressao ?","","","mv_chi","C",01,0,0,"C","","mv_par18","Impresso","","","","","E-mail","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"19","E-mail Cp Oculta?","","","mv_chj","C",50,0,0,"C","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"20","Numero Bordero?"  ,"","","mv_chk","C",6,0,0,"C","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	RestArea(_aArea)

Return()

