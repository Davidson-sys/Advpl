#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"                 
#INCLUDE "TOPCONN.CH" 
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} AWEB004
// Rotina de Vendedores em MVC - MATA040
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

User Function AWEB004()

Return()

/*/{Protheus.doc} MenuDef
// Menu Default
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function MenuDef()

	Local aRotina := {}
	
//	ADD OPTION aRotina TITLE "Pesquisar"	ACTION 'AxPesqui'		 	OPERATION 1	ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'U_AWEB004A("VIS")'	OPERATION 2	ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"		ACTION 'U_AWEB004A("INC")'	OPERATION 3	ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"		ACTION 'U_AWEB004A("EDT")'	OPERATION 4	ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"		ACTION 'U_AWEB004A("EXC")'	OPERATION 5	ACCESS 0
	ADD OPTION aRotina TITLE "Senha portal"	ACTION 'U_AWEB004A("PSW")'	OPERATION 9	ACCESS 0
	ADD OPTION aRotina TITLE "Perfil portal"ACTION 'U_AWEB004A("PFL")'	OPERATION 9	ACCESS 0
	ADD OPTION aRotina TITLE "Clientes"		ACTION 'U_AWEB004A("SA1")'	OPERATION 9	ACCESS 0

Return(aRotina)

/*/{Protheus.doc} BrowseDef
// Integração Web
@author Marco Aurelio Braga
@since 04/02/2016
@version 1.0
@type function
/*/

Static Function BrowseDef()

	Local aRet	:= {}
	
	// Array principal
	
	aAdd(aRet, {"Legend"	, {} })
	aAdd(aRet, {"Alias"		, {} })
	aAdd(aRet, {"Filter"	, {} })
	
	// Array Legenda
	
	aAdd(aRet[1,2], {})
	
	// Array Alias
	
	aAdd(aRet[2,2], {"SA3"})
	
	// Array Filter
	
	aAdd(aRet[3,2], {""})	

Return(aRet)

/*/{Protheus.doc} AWEB004A
// Opações do Menu - MATA040
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

User Function AWEB004A(cOpcao)

	Local lRet	:= .T.

	// Compatibilidade com MATA040
	
	Private cCadastro	:= 'Vendedores'
	Private aRotina		:= StaticCall(MATA040,MenuDef)
	Private xAuto		:= {}
	Private bFiltraBrw	:= {|| Nil}
	Private nOpc		:= 0	

	Do Case

		Case (cOpcao == "VIS")
			nOpc := 2
			A040Visualiza("SA3",SA3->(Recno()),2)
		Case (cOpcao == "INC")
			nOpc := 3
			lRet := A040Inclui("SA3",SA3->(Recno()),3)
		Case (cOpcao == "EDT")
			nOpc := 4
			lRet := A040Altera("SA3",SA3->(Recno()),4)
		Case (cOpcao == "EXC")
			nOpc := 5
			lRet := A040Exclui("SA3",SA3->(Recno()),5)
		Case (cOpcao == "PSW")
			fSetPsw()
		Case (cOpcao == "PFL")
			fSetPfl()
		Case (cOpcao == "SA1")
			fEdtSA1()
	EndCase

Return(lRet)



/*/{Protheus.doc} fEdtSA1
// Altera vendedor do cliente
@author Marco Aurelio Braga
@since 06/02/2016
@version 1.0
@type function
@return Logico, Retorno nulo
/*/

Static Function fEdtSA1()

	Local nOpcao	:= 0
	Local nLin1		:= 0
	Local nCol1		:= 0
	Local nLin2		:= 0
	Local nCol2		:= 0
	Local nLenX		:= 0
	Local nLenY		:= 0
	Local cValid	:= ""
	Local cCombo	:= ""
	Local cAlias	:= ""
	Local cFiltro	:= ""
	Local aCoors	:= {}
	Local aHeader	:= {}
	Local aCols		:= {}
	Local aButtons	:= {}
	Local oSize		:= Nil
	Local oDlgSA1	:= Nil
	
	Private oGetSA1	:= Nil
	
	cAlias	:= GetNextAlias()
	cFiltro	:= BuildExpr('SA1',,,.T.,,,,"Filtro")
	cFiltro	:= IIF(!Empty(cFiltro), "% "+ cFiltro +" AND %","% %")
	
	BeginSql alias cAlias
		SELECT	SA1.A1_COD, SA1.A1_NOME, SA1.A1_EST, SA1.A1_MSBLQL, SA1.R_E_C_N_O_, SA3.A3_COD, SA3.A3_NOME, SA3.A3_MSBLQL, CC2.CC2_MUN
		FROM	%Table:SA1% SA1	LEFT JOIN %Table:SA3% SA3 ON (SA3.%NOTDEL% AND SA3.A3_COD = SA1.A1_VEND)
								LEFT JOIN %Table:CC2% CC2 ON (CC2.%NOTDEL% AND CC2.CC2_CODMUN = SA1.A1_COD_MUN)
		WHERE	%exp:cFiltro% SA1.%NOTDEL%
		ORDER BY SA1.A1_NOME
	EndSql
	
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	If (cAlias)->(!Eof())
		While (cAlias)->(!Eof())
		
			aAdd(aCols, {	(cAlias)->A1_COD,;
							(cAlias)->A1_NOME,;
							(cAlias)->CC2_MUN,;
							(cAlias)->A1_EST,;
							(cAlias)->A3_COD,;
							(cAlias)->A3_NOME,;
							(cAlias)->A3_MSBLQL,;
							" ",;
							(cAlias)->R_E_C_N_O_,;
							(cAlias)->A1_MSBLQL == "1" })
	
			(cAlias)->(DbSkip())
		Enddo
	Endif
	
	(cAlias)->(DbCloseArea())
	
	If Len(aCols) == 0
		MsgStop("Não há registros para carregar!")
		Return()
	Endif
	
	cValid	:= "(Vazio() .OR. ExistCPO('SA3', M->VENDE)) .AND. StaticCall(AWEB004, fVldEdt)"
	cCombo	:= "1=Sim;2=Nao
	
	aAdd(aHeader,{"Codigo"			,"CODIGO"		,"@!" 					,10,0,,,"C",,,,,,,,,.F.})
	aAdd(aHeader,{"Nome"			,"NOME"			,"@!"		 			,50,0,,,"C",,,,,,,,,.F.})
	aAdd(aHeader,{"Municipio"		,"MUNICIPIO"	,"@!"		 			,50,0,,,"C",,,,,,,,,.F.})
	aAdd(aHeader,{"Estado"			,"ESTADO"		,"@!" 					,02,0,,,"C",,,,,,,,,.F.})
	aAdd(aHeader,{"Vendedor"		,"VENDE"		,"@!"	 				,10,0,cValid,,"C","SA31",,,,,,,,.F.})
	aAdd(aHeader,{"Nome"			,"NOMVEND"		,"@!" 					,50,0,,,"C",,,,,,,,,.F.})
	aAdd(aHeader,{"Bloqueado"		,"BLOQUEADO"	,"@!"					,03,0,,,"C",,,cCombo,,,,,,.F.})
	aAdd(aHeader,{"Editado"			,"EDIT"			,"@!"	 				,01,0,,,"C",,,,,,,,,.F.})
	aAdd(aHeader,{"Recno"			,"RECNO"		,"@E 9999999999"		,10,0,,,"N",,,,,,,,,.F.})
	
	oSize	:= FwDefSize():New(.T.) 
	oSize:AddObject("GetDados",100, 100, .T., .T. )
	oSize:lProp		:= .T.
	oSize:lLateral	:= .F.
	oSize:Process()
	
	aCoors	:= oSize:aWindSize
	
	aAdd(aButtons, {"SIMULACA",{|| Processa({|| StaticCall(AWEB004, fRplCad) },"Processado dados...") }, "Replicar", 	"Replicar"	} )
	aAdd(aButtons, {"SIMULACA",{|| Processa({|| StaticCall(AWEB004, fGerCSV) },"Gravando dados...") }, "Gerar CSV", "Gerar CSV"	} )
	
	Define MsDialog oDlgSA1 Title ' Cliente x Vendedores' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel
	
		nLin1	:= oSize:GetDimension("GetDados","LININI")
		nCol1	:= oSize:GetDimension("GetDados","COLINI")
		nLin2	:= oSize:GetDimension("GetDados","LINEND")
		nCol2	:= oSize:GetDimension("GetDados","COLEND")
		nLenX	:= oSize:GetDimension("GetDados","XSIZE")
		nLenY	:= oSize:GetDimension("GetDados","YSIZE")
		
		oGetSA1 := MsNewGetDados():New(nLin1,nCol1,nLin2,nCol2,GD_UPDATE,{||.T.},{||.T.},NIL,{"VENDE"},1,Len(aCols),NIL,NIL,{||.T.},oDlgSA1,aHeader,aCols)
	
	Activate MSDialog oDlgSA1 Centered On Init EnchoiceBar(oDlgSA1,{|| nOpcao := 1, aCols := aClone(oGetSA1:Acols), oDlgSA1:End()},{|| nOpcao := 2, oDlgSA1:End()},,aButtons)
	
	If nOpcao == 1
		DbSelectArea("SA1")
		For nX := 1 To Len(aCols)
			If !Empty(aCols[nX,8])
				SA1->(DbGoTo(aCols[nX,9]))
				If SA1->(Recno()) == aCols[nX,9]
					RecLock("SA1",.F.)
					SA1->A1_VEND := aCols[nX,5]
					SA1->(MsUnLock())
				Endif
			Endif
		Next nX
	Endif

Return()

/*/{Protheus.doc} fSetPsw
// Menu de criacao de senha
@author Marco Aurelio Braga
@since 04/02/2016
@version 1.0
@type function
/*/

Static Function fSetPsw()

	Local oDlgTmp	:= Nil
	Local oTFld01	:= Nil
	Local oSay1		:= Nil
	Local oSay2		:= Nil
	Local oTBut1	:= Nil
	Local oTBut2	:= Nil
	Local bValid	:= {|| IIF(fVldPsw(cNewPsw1, cNewPsw2), nOpcao := 1, nOpcao := 0), IIF( nOpcao == 1,  oDlgTmp:End(), .F.) }
	Local nOpcao	:= 0
	Local cNewPsw1	:= Space(30)
	Local cNewPsw2	:= Space(30)
	
	DEFINE MSDIALOG oDlgTmp TITLE UPPER("Acesso Portal") FROM 000,000 TO 145,300 PIXEL
	
		oTFld01	:= TFolder():New(003,003,{" Definir Senha "},,oDlgTmp,,,,.T.,,145,068)
	
		oSay1	:= TSay():New(006,005,{||"Nova senha: "},oTFld01:aDialogs[1],,,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)		
	
		@ 004,060 Get cNewPsw1 Size 080,009 PassWord Pixel Of oTFld01:aDialogs[1]
		
		oSay2	:= TSay():New(021,005,{||"Confirme nova senha: "},oTFld01:aDialogs[1],,,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)		
	
		@ 019,060 Get cNewPsw2 Size 080,009 PassWord Pixel Of oTFld01:aDialogs[1]
		
		oTBut1	:= TButton():New(038,073,"Confirmar"	,oTFld01:aDialogs[1],bValid				,32,11,,,.F.,.T.,.F.,,.F.,,,.F.)
		oTBut2	:= TButton():New(038,107,"Cancelar"		,oTFld01:aDialogs[1],{|| oDlgTmp:End() },32,11,,,.F.,.T.,.F.,,.F.,,,.F.)
		
	ACTIVATE MSDIALOG oDlgTmp CENTERED
	
	If nOpcao == 1
		SA3->(RecLock("SA3",.F.))
		SA3->A3_N_PSW	:= Encode64(AllTrim(cNewPsw1))
		SA3->(MsUnLock())
		
		MsgInfo("Senha alterada com sucesso!")
	Endif
		
Return()

/*/{Protheus.doc} fVldPsw
// Valida senha
@author Marco Aurelio Braga
@since 06/02/2016
@version 1.0
@type function
@return Logico, Retorno nulo
/*/

Static Function fVldPsw(cPsw1, cPsw2)

	Local lRet := .T.
	
	If Empty(cPsw1) .OR. Empty(cPsw2)
		MsgStop("Senha invalida!")
		lRet := .F.
	Else
		If AllTrim(cPsw1) <> AllTrim(cPsw2)
			MsgStop("Senhas não conferem!")
			lRet := .F.
		Endif
	Endif

Return(lRet)

/*/{Protheus.doc} fVldEdt
// Flag registro editado
@author Marco Aurelio Braga
@since 06/02/2016
@version 1.0
@type function
@return Logico, Retorno nulo
/*/

Static Function fVldEdt()

	Local lRet := .T.
	
	oGetSA1:Acols[oGetSA1:oBrowse:nAt,8] := 'X'
	
	oGetSA1:Refresh()

Return(lRet)

/*/{Protheus.doc} fRplCad
// Replica vender posicionada na GetDados
@author Marco Aurelio Braga
@since 06/02/2016
@version 1.0
@type function
@return Logico, Retorno nulo
/*/

Static Function fRplCad()

	Local cVend := ""
	Local cNome	:= ""
	Local nInd	:= 0

	If !MsgYesNo("Deseja replicar vendedor atual para todos os cadastros?")
		Return()
	Endif
	
	ProcRegua(0)
	
	cVend := oGetSA1:Acols[oGetSA1:oBrowse:nAt,5]
	cNome := oGetSA1:Acols[oGetSA1:oBrowse:nAt,6]
	
	For nInd := 1 To Len(oGetSA1:Acols)
		oGetSA1:Acols[nInd,5] := cVend
		oGetSA1:Acols[nInd,6] := cNome	
		oGetSA1:Acols[nInd,8] := "X"
		
		IncProc("Aguarde... " + cValToChar(nInd))
	Next nInd
	
	oGetSA1:Refresh()

Return()

/*/{Protheus.doc} fGerCSV
// Gera CSV da GetDados
@author Marco Aurelio Braga
@since 06/02/2016
@version 1.0
@type function
@return Logico, Retorno nulo
/*/

Static Function fGerCSV()

	Local aHld	:= oGetSA1:aHeader
	Local aCls	:= oGetSA1:aCols
	Local cTxt	:= ""
	Local nInd	:= 0
	Local nCol	:= 0
	Local cSlv	:= Alltrim(cGetFile("*.*","Salvar",1,"c:\",.F.,GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY))
	Local nHnd	:= fCreate(cSlv+"Clientes_"+DTOS(Date())+"_"+StrTran(Time(),":","-")+".csv")

	If nHnd == -1
	    MsgAlert("O arquivo CSV nao pode ser executado!","Erro!")
	   	Return()
	Endif
	
	ProcRegua(0)
	
	For nInd := 1 To Len(aHld)
		cTxt += aHld[nInd,1] + ";"
	Next nInd
	
	cTxt += chr(13) + chr(10)
	
	If fWrite(nHnd,cTxt,Len(cTxt)) != Len(cTxt)
		MsgAlert("Ocorreu um erro na gravacao do arquivo.","Erro!")
		Return()
	Endif	
	
	For nInd := 1 To Len(aCls)	
		cTxt := ""
	
		For nCol := 1 To Len(aHld)
		
			Do Case
				Case (aHld[nCol,8] == 'N')
					cTxt += cValToChar(aCls[nInd,nCol]) + ";"
				Case (aHld[nCol,8] == 'D')
					cTxt += DTOC(aCls[nInd,nCol]) + ";"
				OtherWise
					cTxt += aCls[nInd,nCol] + ";"
			EndCase	

		Next nCol
		
		cTxt += chr(13) + chr(10)
		If fWrite(nHnd,cTxt,Len(cTxt)) != Len(cTxt)
			MsgAlert("Ocorreu um erro na gravacao do arquivo.","Erro!")
			Return()
		Endif
		
		IncProc("Aguarde... " + cValToChar(nInd))		
		
	Next nInd
	
	If nHnd <> -1
		fClose(nHnd)
		MsgInfo("Fim!"+CHR(13)+CHR(10)+"Arquivo gerado em "+cSlv+"Clientes_"+DTOS(Date())+"_"+StrTran(Time(),":","-")+".csv")
	Endif

Return()

/*/{Protheus.doc} fSetPfl
// Define perfil de acesso ao portal
@author Marco Aurelio Braga
@since 04/02/2016
@version 1.0
@type function
/*/

Static Function fSetPfl()

	Local oDlgTmp	:= Nil
	Local oTFld01	:= Nil
	Local oCheck1	:= Nil
	Local oCheck2	:= Nil
	Local oTBut1	:= Nil
	Local oTBut2	:= Nil
	Local bValid	:= {|| nOpcao := 1,  oDlgTmp:End() }
	Local nOpcao	:= 0
	Local lCheck1	:= SubStr(SA3->A3_TIPSUP,1,1) == "A"
	Local lCheck2	:= SubStr(SA3->A3_TIPSUP,2,1) == "A"
	
	DEFINE MSDIALOG oDlgTmp TITLE UPPER("Acesso Portal") FROM 000,000 TO 145,300 PIXEL
	
		oTFld01	:= TFolder():New(003,003,{" Definir Perfil "},,oDlgTmp,,,,.T.,,145,068)		
		
		oCheck1 := TCheckBox():New(006,005,'Administrador',{|u|if(PCount()>0,lCheck1:=u,lCheck1)},oTFld01:aDialogs[1],100,210,,,,,,,,.T.,,,)
		oCheck2 := TCheckBox():New(021,005,'Aprovador',{|u|if(PCount()>0,lCheck2:=u,lCheck2)},oTFld01:aDialogs[1],100,210,,,,,,,,.T.,,,)
	
		oTBut1	:= TButton():New(038,073,"Confirmar"	,oTFld01:aDialogs[1],bValid				,32,11,,,.F.,.T.,.F.,,.F.,,,.F.)
		oTBut2	:= TButton():New(038,107,"Cancelar"		,oTFld01:aDialogs[1],{|| oDlgTmp:End() },32,11,,,.F.,.T.,.F.,,.F.,,,.F.)
		
	ACTIVATE MSDIALOG oDlgTmp CENTERED
	
	If nOpcao == 1
	
		// Regra:
		// Posicao 1 = A - Administrador, U - Usuario	(Acesso ao menu de administração de videos)
		// Posicao 2 = A - Aprovador, V - Vendedor		(Acesso ao menu de aprovação de orçamentos)
		// Posicao 3 = Não Usado
	
		SA3->(RecLock("SA3",.F.))
		SA3->A3_TIPSUP	:= IIF(lCheck1, "A", "U") + IIF(lCheck2, "A", "V") + Space(1) 
		SA3->(MsUnLock())
		
		MsgInfo("Perfil alterado com sucesso!")
	Endif
		
Return()