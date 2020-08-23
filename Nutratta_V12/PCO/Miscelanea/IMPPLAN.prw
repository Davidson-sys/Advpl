#INCLUDE "Protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"

/*
¦+------------------------------------------------------------------------+¦
¦¦Função    ¦ IMPPLAN  ¦ Autor ¦ Lucas Nogueira       ¦ Data ¦ 04/12/2015 ¦¦
¦+----------+-------------------------------------------------------------¦¦
¦¦Descrição ¦ Rotina para importação de itens orçamentários               ¦¦
¦¦          ¦                                                             ¦¦
¦+----------+-------------------------------------------------------------¦¦
¦¦Uso       ¦                                                             ¦¦
¦+------------------------------------------------------------------------+¦
*/
User Function MPCO001()

//¦+-------------------------------------------------------------¦¦
//¦¦ Declara Variaveis                                           ¦¦
//¦+-------------------------------------------------------------+¦
Local aSays 	:= {}
Local aButtons	:= {}

Private cPlanOrc
Private cVersao
Private cPerg 		:= "PCON204"
Private cCadastro	:= "Importação da Planilha Orçamentaria"

	//¦+-------------------------------------------------------------¦¦
	//¦¦ Valida Pergunta                                             ¦¦
	//¦+-------------------------------------------------------------+¦
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	//¦+-------------------------------------------------------------¦¦
	//¦¦ Montagem da tela de processamento.                          ¦¦
	//¦+-------------------------------------------------------------+¦
	
	ProcLogIni( aButtons ) // Inicializa o log de processamento
	
	AADD(aSays, ' Este programa fara importacao da Planilha Orçamentaria para o PCO ')
	AADD(aSays, ' por meio de um arquivo CSV conforme parametros definidos pelo usuario.')
	AADD(aSays, ' ')
	AADD(aSays, ' ATENÇÃO: Após a importação das Contas Orçamentárias, você importará ')
	AADD(aSays, ' os itens da Planilha a partir de um arquivo .CSV ')
	//AADD(aSays, '       2.: Itens do Orçamento - AK2')
	
	AADD(aButtons, { 5,.T.,{ || Pergunte(cPerg,.T.) }} )
	AADD(aButtons, { 1,.T.,{ || ImpPlan()			}} )
	AADD(aButtons, { 2,.T.,{ || FechaBatch() 		}} )
	
	FormBatch(cCadastro, aSays, aButtons,, 260, 450 )

Return

/*
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Função    ¦ ImpPlan  ¦ Autor ¦ Lucas Nogueira       ¦ Data ¦ 04/12/2015 ¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Chama funções de processamento da Planilha Eletrônica       ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦                                                             ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
Static Function ImpPlan()
Private oProcess

	ProcLogAtu('INICIO')

	cPlanOrc 	:= mv_par02
	cVersao 	:= mv_par03

		/*
		MsNewProcess(): New ( [ bAction], [ cTitle], [ cMsg], [ lAbort] )
		Parâmetros
		bAction = Bloco de código = Bloco de código a ser executado pela janela
		cTitle = Caracter = Título a ser apresentado na janela
		cMsg = Caracter = Mensagem apresentada ao usuário na primeira barra de processamento
		lAbort = Lógico = Caso o parâmetro lAbort seja igual a .T. ele habilita o botão Cancelar, possibilitando o cancelamento do processo utilizado pela janela. 
				Caso contrário, o botão Cancelar fica desabilitado.
		*/

	oProcess := MsNewProcess():New( { || ProcAK2() } , cCadastro, "Contas Orçamentárias ["+ Alltrim(cPlanOrc)+"]" , .F. )
	oProcess:Activate()


Return

/*
¦+------------------------------------------------------------------------+¦
¦¦Função    ¦ ProcAK2  ¦ Autor ¦ Lucas Nogueira       ¦ Data ¦ 04/12/2015 ¦¦
¦+----------+-------------------------------------------------------------¦¦
¦¦Descrição ¦ Funcao chamada pelo botao OK na tela inicial de processamen ¦¦
¦¦          ¦ to. Executa a leitura do arquivo texto.                     ¦¦
¦+----------+-------------------------------------------------------------¦¦
¦¦Uso       ¦ Programa principal                                          ¦¦
¦+------------------------------------------------------------------------+¦
*/
Static Function ProcAK2()

	//¦+-------------------------------------------------------------¦¦
	//¦¦ Declaração de Variáveis                                     ¦¦
	//¦+-------------------------------------------------------------+¦

Local aArea		:= GetArea()
Local aOpcoes	:= {"Prosseguir","Cancelar"}
Local aTabela	:= {}
Local aCampos	:= {}
Local lPrim		:= .T.
Local cId		:= ""
Local dDtIni
Local cMsg		:= ""

Local cFileOpen	:= ""
Local cTitulo1	:= "Selecione o Arquivo"
Local cExtens	:= "Arquivo CSV | *.csv"

Private aDados	:= {}
Private aError	:= {}


	//¦+-------------------------------------------------------------+¦
	//¦¦ Validação do Arquivo Selecionado   				         ¦¦
	//¦+-------------------------------------------------------------+¦

	DbSelectArea("AK1")
	DbSetOrder(1)
	
	If !DbSeek(xFilial("AK1") + cPlanOrc + cVersao)
		MsgAlert("Planilha Orçamentária: "+ cPlanOrc + " na versão: " + cVersao + " NÃO LOCALIZADA!",cCadastro)
		Return
	Endif
	
	
	//¦+-------------------------------------------------------------¦¦
	//¦¦ Inicia a inserção das Contas Orçamentárias para a planilha  ¦¦
	//¦+-------------------------------------------------------------+¦
	ProcAK3()
	
	
	_Ini	:= Time()
	
	//¦+-------------------------------------------------------------¦¦
	//¦¦ Inicialização do processamento arquivo CSV				     ¦¦
	//¦+-------------------------------------------------------------+¦
	
	nOp:= Aviso("ATENÇAO!","Por favor selecione a Planilha para Importação!",aOpcoes)
	
	If nOp <> 1
		Return
	EndIf
	
	
	/*
	* _________________________________________________________
	* cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)
	*  ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯
	* <ExpC1> - Expressão de filtro
	* <ExpC2> - Titulo da janela
	* <ExpN1> - Numero de mascara default 1 para *.Exe
	* <ExpC3> - Diretório inicial se necessário
	* <ExpL1> - .F. botão salvar - .T. botão abrir
	* <ExpN2> - Mascara de bits para escolher as opções de visualização do objeto
	* (prconst.ch)
	*/
	
	cFileOpen	:= cGetFile(cExtens,cTitulo1,,,.T.)
	
	If !File(cFileOpen)
		MsgAlert("Planilha: "+ cFileOpen + " não localizada!",cCadastro)
		Return
	Endif
	
	FT_FUSE(cFileOpen)
	
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	
	//¦+-------------------------------------------------------------------------------¦¦
	//¦¦Ajustas as informações da planilha, separando os registros em linha e campos   ¦¦
	//¦+-------------------------------------------------------------------------------+¦
	
	While !FT_FEOF()
		
		IncProc("Lendo Planilha...")
		
		cLinha	:= FT_FREADLN()
		
		If lPrim
			aCampos	:= Separa(cLinha,";",.T.) //SEPARA ( < cString > , < cToken > , < lEmpty > ) 
			lPrim	:= .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		Endif
		
		FT_FSKIP()
	End
	
	FT_FUSE()
	
	//¦+-------------------------------------------------------------¦¦
	//¦¦ Inserção dos Registros na AK2      				         ¦¦
	//¦+-------------------------------------------------------------+¦
	
	ProcRegua(Len(aDados))
	oProcess:SetRegua1(Len(aDados)) //Alimenta a primeira barra de progresso
	
	For i := 1 to Len(aDados)
		
		nPerc := int(( ( i / Len(aDados)  ) * 100))  //Fazendo a Porcentagem
		oProcess:IncRegua1("Planilha Orcamentária: "+ Alltrim(cPlanOrc) + " -   " + cValToChar(nPerc) + '%' )
	
		
		//¦+-------------------------------------------------------------¦¦
		//¦¦Validando Tabelas AK5, AK6, CTT, CTD E CTH			         ¦¦
		//¦+-------------------------------------------------------------+¦
		DbSelectArea("AK5")
		AK5->(DbSetOrder(1))
				
		If !AK5->(DbSeek(xFilial("AK5") + aDados[i][3]))
			cMsg	:= "[AK5] - Conta Orçamentária não cadastrada! [ " + aDados[i][3] + " ] ."
			If Ascan(aError,cMsg) == 0
				AADD(aError,cMsg)
				Loop
			EndIf
		Endif
		
		
		DbSelectArea("AK6")
		AK6->(DbSetOrder(1))
		
		If !AK6->(DbSeek(xFilial("AK6") + aDados[i][8]))
			cMsg	:= "[AK6] - Classe Orçamentária não cadastrado! [ " + aDados[i][8] + " ] ."
			If Ascan(aError,cMsg) == 0
				AADD(aError,cMsg)
				Loop
			EndIf
		Endif
		
		DbSelectArea("CTT")
		CTT->(DbSetOrder(1))
		If !CTT->(DbSeek(xFilial("CTT") + aDados[i][5]))
			cMsg	:= "[CTT] - Centro de Cuto não cadastrado! [ " + aDados[i][5] + " ] ."
			If Ascan(aError,cMsg) == 0
				AADD(aError,cMsg)
				Loop
			EndIf
		Endif
	
		DbSelectArea("CTD")
		CTD->(DbSetOrder(1))
		
		If !CTD->(DbSeek(xFilial("CTD") + aDados[i][6]))
			cMsg	:= "[CTD] - Item Contábil não cadastrado! [ " + aDados[i][6] + " ] ."
			If Ascan(aError,cMsg) == 0
				AADD(aError,cMsg)
				Loop
			EndIf
		Endif
		
		DbSelectArea("CTH")
		CTH->(DbSetOrder(1))
		
		If !CTH->(DbSeek(xFilial("CTH") + aDados[i][7]))
			cMsg	:= "[CTH] - Classe Valor não cadastrado! [ " + aDados[i][7] + " ] ."
			If Ascan(aError,cMsg) == 0
				AADD(aError,cMsg)
				Loop
			EndIf
		Endif
		
		dDtIni:= aDados[i,4]
		
		//¦+-------------------------------------------------------------¦¦
		//¦¦  Verificando se não tem dados duplicados			         ¦¦
		//¦+-------------------------------------------------------------+¦
		cQuery := " SELECT * "
		cQuery += "  FROM "+	RetSqlName("AK2")+" (NOLOCK)"
		cQuery += " WHERE AK2_FILIAL = '" + xFilial("AK2") + "'"
		cQuery += " 	AND AK2_ORCAME 	= '" + aDados[i][1] + "'"
		cQuery += " 	AND AK2_CO 		= '" + aDados[i][3] + "'"
		cQuery += " 	AND AK2_VERSAO 	= '" + aDados[i][2] + "'"
		cQuery += " 	AND AK2_CC 		= '" + aDados[i][5] + "'"
		cQuery += " 	AND AK2_ITCTB 	= '" + aDados[i][6] + "'"
		cQuery += " 	AND AK2_CLVLR 	= '" + aDados[i][7] + "'"
		cQuery += " 	AND D_E_L_E_T_ <> '*' "
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TMPAK2',.F.,.T.)
		
		If !TMPAK2->(EOF())
			aadd(aError, "Inf. duplicadas-> Periodo: "+ Alltrim(dDtIni) +" - C.O.: "+Rtrim(aDados[i][3])+" - C.Custo: "+Rtrim(aDados[i][5])+" - Prod.: "+Rtrim(aDados[i][6])+" - Segmento: "+Rtrim(aDados[i][7])+" - Versão: "+Rtrim(aDados[i][2]))
			TMPAK2->(DbCloseArea())
			Loop
		Endif
		
		TMPAK2->(DbCloseArea())
		
		//¦+--------------------------------------------------------------+¦
		//¦¦  Iniciando Inserção na Tabela AK2 (Por Periodo Jan - Dez)    ¦¦
		//¦+--------------------------------------------------------------+¦
		oProcess:SetRegua2(12) //Alimenta a segunda barra de progresso
		For j:=9 to 20

			oProcess:IncRegua2("Centro de Custo: " + Alltrim(aDados[i][3]) + "  Período:  " + Alltrim(aCampos[j]) ) //processamento da segunda barra de progresso 
			
			//Verifica e soma a 1 o ID para não ter erro de chave duplicada! UNIQUE [AK2_FILIAL, AK2_ORCAME, AK2_VERSAO, AK2_CO, AK2_PERIOD, AK2_ID, R_E_C_D_E_L_]
			cQuery := " SELECT Isnull( RIGHT ('0000' + Ltrim(Str(MAX(AK2_ID)+1)),4), '0001')  AK2_ID"
			cQuery += "  FROM "+	RetSqlName("AK2")+" (NOLOCK)"
			cQuery += " WHERE AK2_FILIAL 	= '" + xFilial("AK2") + "'"
			cQuery += " AND AK2_ORCAME 		= '" + aDados[i][1] + "'"
			cQuery += " AND AK2_CO 			= '" + aDados[i][3] + "'"
			cQuery += " AND AK2_VERSAO 		= '" + aDados[i][2] + "'"
			cQuery += " AND AK2_PERIOD 		= '" + Left(dDtIni,4) + strZero(j-8,2)+'01' + "'"
			cQuery += " AND D_E_L_E_T_ <> '*' "
			dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TMP_MAX_AK2',.F.,.T.)
				
			cID := TMP_MAX_AK2->AK2_ID
			TMP_MAX_AK2->(DbCloseArea())
			
			RecLock("AK2",.T.)
			AK2->AK2_FILIAL 	:=	xFilial("AK2")
			AK2->AK2_ID 		:=	cID  
			AK2->AK2_ORCAME 	:= 	aDados[i][1]
			AK2->AK2_VERSAO		:= 	aDados[i][2]
			AK2->AK2_CO			:= 	aDados[i][3]
			AK2->AK2_PERIOD		:= 	StoD(Left(dDtIni,4) + strZero(j-8,2)+'01')
			AK2->AK2_CC			:= 	aDados[i][5]
			AK2->AK2_ITCTB		:= 	aDados[i][6]
			AK2->AK2_CLVLR		:= 	aDados[i][7]
			AK2->AK2_CLASSE		:= 	aDados[i][8]
			AK2->AK2_VALOR		:= 	Val(aDados[i][j])
			AK2->AK2_MOEDA		:= 	1
			AK2->AK2_DATAF		:= 	LastDay(StoD(Left(dDtIni,4) + strZero(j-8,2)+'01'))
			AK2->AK2_DATAI		:= 	StoD(Left(dDtIni,4) + strZero(j-8,2)+'01')
			AK2->(MsUnlock())
		Next
	Next
	
	_fim	:= Time()
	
	ApMsgInfo("Importação finalizado! " + Chr(13) + Chr(10) + "Início: " +_ini+ "   Fim: "+_fim )
	
	ImprRel()
Return

/*
¦+------------------------------------------------------------------------+¦
¦¦Função    ¦ ProcAK3  ¦ Autor ¦ Lucas Nogueira       ¦ Data ¦ 04/12/2015 ¦¦
¦+----------+-------------------------------------------------------------¦¦
¦¦Descrição ¦ Funcao chamada pelo programa ProcAK2() para Inserção da AK3 ¦¦
¦¦          ¦ - Cabeçalho da Planilha Orçamentária.                       ¦¦
¦+----------+-------------------------------------------------------------¦¦
¦¦Uso       ¦ Interno                                                     ¦¦
¦+------------------------------------------------------------------------+¦
*/
Static Function ProcAK3

Local aArea    	:= GetArea()
Local nTotAK3  	:= 0
Local nAtuAK3 	:= 0
/*
Local aOpcoes	:= {"Prosseguir","Cancelar"}

	nOp:= Aviso("ATENÇAO!","Você esta IMPORTANDO as Contas Orçamentárias da Planilha: "+cPlanOrc+". Confirme antes de proseguir.",aOpcoes)
	
	If nOp <> 1
		Return
	EndIf
*/	
	//¦+-------------------------------------------------------------¦¦
	//¦¦ Inserção dos Registros na AK3                               ¦¦
	//¦+-------------------------------------------------------------+¦
	
	DbSelectArea("AK5")
	DbGoTop()
	
	nTotAK3 := AK5->(Reccount())
	
	ProcRegua(nTotAK3)
	oProcess:SetRegua1(nTotAK3) //Alimenta a primeira barra de progresso
	
	DbSelectArea("AK3")
	DbSetOrder(2)
	
	While AK5->(!Eof())
		
		IncProc(nAtuAK3)
		nPerc := int(( ( nAtuAK3 / nTotAK3  ) * 100))  //Fazendo a Porcentagem
		oProcess:IncRegua1("Contas Orcamentária: "+ Alltrim(cPlanOrc) + " -   " + cValToChar(nPerc) + '%' )
			
					//uniq - [AK3_FILIAL, AK3_ORCAME, AK3_VERSAO, AK3_PAI, AK3_CO, R_E_C_D_E_L_]
		If !(AK3->(DbSeek(xFilial("AK3") + cPlanOrc + cVersao + IIF(AK5->AK5_COSUP = ' ',cPlanOrc,AK5->AK5_COSUP) + AK5->AK5_CODIGO)))
			
			Do Case
				Case Len(Alltrim(AK5->AK5_CODIGO)) == 1
					cNivel = "002"
				
				Case Len(Alltrim(AK5->AK5_CODIGO)) == 2
					cNivel = "003"
					
				Case Len(Alltrim(AK5->AK5_CODIGO)) == 3
					cNivel = "004"
					
				Case Len(Alltrim(AK5->AK5_CODIGO)) == 5
					cNivel = "005"
					
				Case Len(Alltrim(AK5->AK5_CODIGO)) == 7
					cNivel = "006"
					
				Case Len(Alltrim(AK5->AK5_CODIGO)) == 9
					cNivel = "007"
					
				Case Len(Alltrim(AK5->AK5_CODIGO)) == 11
					cNivel = "008"
				
				Otherwise
					cNivel	:= "005"
			EndCase
			
			IF SUBSTR(ALLTRIM(AK5->AK5_CODIGO),1,1) == "4"
		
					RecLock("AK3",.T.)
					AK3->AK3_FILIAL 	:= xFilial("AK3")
					AK3->AK3_ORCAME 	:= cPlanOrc
					AK3->AK3_VERSAO		:= cVersao
					AK3->AK3_CO			:= AK5->AK5_CODIGO
					AK3->AK3_PAI		:= IIF(AK5->AK5_COSUP = ' ',cPlanOrc,AK5->AK5_COSUP)
					AK3->AK3_TIPO		:= AK5->AK5_TIPO
					AK3->AK3_DESCRI		:= AK5->AK5_DESCRI
					AK3->AK3_NIVEL		:= cNivel
					AK3->(MsUnlock())
					
					nAtuAK3++
			Endif
		EndIf
	
		AK5->(DbSkip())
	Enddo
	
	MsgInfo("Contas Orçamentárias da Planilha: "+ Alltrim(cPlanOrc) +" na versão: "+Alltrim(cVersao) + Chr(13) + Chr(10) +" IMPORTADA COM SUCESSO!",cCadastro)

Return


/*
¦+------------------------------------------------------------------------+¦
¦¦Função    ¦ ImprRel  ¦ Autor ¦ Lucas Nogueira       ¦ Data ¦ 04/12/2015 ¦¦
¦+----------+-------------------------------------------------------------¦¦
¦¦Descrição ¦ Relatório de Crítica Importação Planilha Orçamentária       ¦¦
¦¦          ¦                                                             ¦¦
¦+----------+-------------------------------------------------------------¦¦
¦¦Uso       ¦                                                             ¦¦
¦+------------------------------------------------------------------------+¦
*/
Static Function ImprRel
	
	//¦+-------------------------------------------------------------¦¦
	//¦¦ Declaração de Variáveis                                     ¦¦
	//¦+-------------------------------------------------------------+¦
	
Local cDesc1       	 	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3        	:= "Importação Plan. Orçamentária"
Local cPict         	:= ""
Local titulo      		:= "Importação Planilha Orçamentária"
Local nLin         		:= 80

Local Cabec1       		:= "Relatório de Inconsistências - Planilha Orçamentária [" + Alltrim(cPlanOrc) +"] - Versão [" + Alltrim(cVersao) + "]"
Local Cabec2       		:= ""
Local imprime      		:= .T.
Local aOrd 				:= {}

Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite          := 132
Private tamanho         := "M"
Private nomeprog        := "ImprRel" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo           := 15
Private aReturn         := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1} 
Private nLastKey        := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "ImprRel" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString 		:= ""

	/*
	**Estrutura aReturn:
	**aReturn[1] Caracter, tipo do formulário
	**aReturn[2] Numérico, opção de margem
	**aReturn[3] Caracter, destinatário
	**aReturn[4] Numérico, formato da impressão
	**aReturn[5] Numérico, dispositivo de impressão
	**aReturn[6] Caracter, driver do dispositivo de impressão
	**aReturn[7] Caracter, filtro definido pelo usuário
	**aReturn[8] Numérico, ordem
	**aReturn[x] A partir a posição [9] devem ser informados os nomes dos campos que
	**devem ser considerados no processamento, definidos pelo uso da opção Dicionário da SetPrint().
	*/

	//¦+-------------------------------------------------------------¦¦
	//¦¦ Monta a interface padrao com o usuario...                   ¦¦
	//¦+-------------------------------------------------------------+¦
	
	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)  // Monta a tela de impressao                                                               
	
	If nLastKey == 27 //Referente a tecla ESC para sair.
		ProcLogAtu('CANCEL','Cancalado pelo usuario') 
		Return
	Endif
	
	SetDefault(aReturn,cString) //Estabelece padrão para impressão, conforme informado ao usuário. ()
	
	If nLastKey == 27
		ProcLogAtu('CANCEL','Cancalado pelo usuario') 
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//¦+--------------------------------------------------------------------¦¦
	//¦¦ Processamento. RPTSTATUS monta janela com a regua de processamento.¦¦
	//¦+--------------------------------------------------------------------+¦
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*
¦+----------------------------------------------------------------------------+¦
¦¦Função    ¦ ³RUNREPORT  ¦  Autor ¦ Lucas Nogueira       ¦ Data ¦ 04/12/2015 ¦¦
¦+----------+-----------------------------------------------------------------¦¦
¦¦Descrição ¦Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS       ¦¦
¦¦          ¦ monta a janela com a regua de processamento.                    ¦¦
¦+----------+-----------------------------------------------------------------¦¦
¦¦Uso       ¦ Programa Principal                                              ¦¦
¦+----------------------------------------------------------------------------+¦
*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local i := 0

	SetRegua(RecCount())
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	Endif
	
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	aError := aSort(aError)
	
	For i:=1 to len(aError)
		@nLin,005 PSAY aError[i]
		nLin++
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
	Next
	
	//¦+--------------------------------------------------------------------¦¦
	//¦¦ Finaliza a execucao do relatorio...                                ¦¦
	//¦+--------------------------------------------------------------------+¦
	
	SET DEVICE TO SCREEN
	//¦+--------------------------------------------------------------------¦¦
	//¦¦ Se impressao em disco, chama o gerenciador de impressao...         ¦¦
	//¦+--------------------------------------------------------------------+¦
	
	If aReturn[5] == 1
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	ProcLogAtu('FIM')
Return


/*
¦+--------------------------------------------------------------------------+¦
¦¦Função    ¦ ValidPerg  ¦ Autor ¦ Lucas Nogueira       ¦ Data ¦ 04/12/2015 ¦¦
¦+----------+---------------------------------------------------------------¦¦
¦¦Descrição ¦                                                               ¦¦
¦¦          ¦                                                               ¦¦
¦+----------+---------------------------------------------------------------¦¦
¦¦Uso       ¦                                                               ¦¦
¦+--------------------------------------------------------------------------+¦
*/
Static Function ValidPerg(cPerg)

PutSx1(cPerg,"01","Operacao"   			    ,"Operação       ? ","Importar       ? ","mv_ch1","N",01,0,0,"C","",""      ,"","","mv_par01","Importar"	  ,"","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"02","Nome Plan Orcamentaria"	,"Planilha       ? ","Planilha       ? ","mv_ch2","C",15,0,1,"G","",""      ,"","","mv_par02",""			  ,"","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"03","Versao Plan Orcamentaria","Versão         ? ","Versão         ? ","mv_ch3","C",04,0,1,"G","",""      ,"","","mv_par03",""              ,"","","","","","","","","","","","","","","",{},{},{})

Return