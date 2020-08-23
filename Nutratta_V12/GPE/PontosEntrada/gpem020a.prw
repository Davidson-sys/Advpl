#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "GPEM1020.CH"

Static cFilUsua := ""
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ?GPEM020A ?Autor ?Leandro Drumond            ?Data   ?6/05/2016³±?
±±³ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ?Cálculo Unificado.					                             ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ?GPEM020A()		                   	                             ³±?
±±³ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±?Uso      ?Mensal                                                            ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±?        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                    ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ?  Data ?  FNC     ? Motivo da Alteracao                       ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

Function GPEM020A()
Local aColsMark		:= {}
Local cIdCab
Local cIdGrid
Local lMarcar     	:= .F.
Local oPanelUp
Local oTela
Local oPanelDown
Local oGroup
LOcal oFont
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
Local aObjCoords	:= {}
Local bCalcula 		:= {||If (GPM020IniProc(),oDlgMark:End(),Nil) }
Local bFiltro 		:= {||GPM020IniFilt() }

Private aRotMark   	:= {}
Private cFilCalc	:= Space( GetSx3Cache("RCH_FILIAL", "X3_TAMANHO") )
Private cProcesso	:= Space( GetSx3Cache("RCH_PROCES", "X3_TAMANHO") )
Private cRoteiro	:= Space( GetSx3Cache("RCH_ROTEIR", "X3_TAMANHO") )
Private cPeriodo	:= Space( GetSx3Cache("RCH_PER", "X3_TAMANHO") )
Private cNumPag		:= Space( GetSx3Cache("RCH_NUMPAG", "X3_TAMANHO") )
Private cAliasMark 	:= "TABAUX"
Private oMark
Private oDlgMark	:= Nil

If cPaisLoc <> "BRA"
	Help( ,, STR0005,, STR0090, 1, 0) //"Rotina não disponivel."
	return
EndIf

If !fCriaTmp()
	Help( ,, STR0005,, STR0075, 1, 0) //"Nenhum dos roteiro aptos para cálculo possuem período ativo."
EndIf

AjustaSX1()

DbSelectArea(cAliasMark)
SET FILTER TO

aColsMark:= fMntColsMark()


aAdvSize	:= MsAdvSize( .F.,.F.,370)
aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 5 , 15 }
aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
aObjSize	:= MsObjSize( aInfoAdvSize , aObjCoords )

Define MsDialog oDlgMark FROM 0, 0 To 500, 800 Title STR0076 Pixel  ////"Cálculo Unificado"

// Cria o conteiner onde serão colocados os paineis
oTela     := FWFormContainer():New( oDlgMark )
cIdCab	  := oTela:CreateHorizontalBox( 13 )
cIdGrid   := oTela:CreateHorizontalBox( 80 )

oTela:Activate( oDlgMark, .F. )

//Cria os paineis onde serao colocados os browses
oPanelUp  	:= oTela:GeTPanel( cIdCab )
oPanelDown  := oTela:GeTPanel( cIdGrid )
 	//ATUSX fechado, incluir string quando abrir
	@ 0 , aObjSize[1,2]	GROUP oGroup TO 26,aObjSize[1,4]*0.62 LABEL OemToAnsi(STR0077) OF oPanelUp PIXEL	//"Selecione os filtros para cálculo"
	oGroup:oFont:=oFont
	
	@ aObjSize[1,1]*0.5, aObjSize[1,2]+1 		SAY   OemToAnsi(GetSx3Cache("RCH_FILIAL", "X3_TITULO")) SIZE 038,007 OF oPanelUp PIXEL
	@ (aObjSize[1,1]*0.5)+6, aObjSize[1,2]+1 	MSGET cFilCalc SIZE 010,007	OF oPanelUp PIXEL WHEN .T. F3 'SM0' HASBUTTON VALID Gp20FilMark()

	@ aObjSize[1,1]*0.5, aObjSize[1,2]+80 		SAY   OemToAnsi(GetSx3Cache("RCH_PROCES", "X3_TITULO")) SIZE 038,007 OF oPanelUp PIXEL
	@ (aObjSize[1,1]*0.5)+6, aObjSize[1,2]+80 	MSGET cProcesso SIZE 010,007	OF oPanelUp PIXEL WHEN .T. F3 "RCJ" HASBUTTON VALID Gp20FilMark()
	
	@ aObjSize[1,1]*0.5	, aObjSize[1,2]+160 	SAY   OemToAnsi(GetSx3Cache("RCH_ROTEIR", "X3_TITULO")) SIZE 038,007 OF oPanelUp PIXEL
	@ (aObjSize[1,1]*0.5)+6, aObjSize[1,2]+160	MSGET cRoteiro SIZE 010,007	OF oPanelUp PIXEL WHEN .T. F3 "SRY" HASBUTTON VALID Gp20FilMark()
	
	@ aObjSize[1,1]*0.5	, aObjSize[1,2]+240		SAY   OemToAnsi(GetSx3Cache("RCH_PER", "X3_TITULO")) SIZE 038,007 OF oPanelUp PIXEL
	@ (aObjSize[1,1]*0.5)+6, aObjSize[1,2]+240	MSGET cPeriodo SIZE 010,007	OF oPanelUp PIXEL WHEN .T. HASBUTTON VALID Gp20FilMark()
	
	@ aObjSize[1,1]*0.5	, aObjSize[1,2]+320		SAY   OemToAnsi(GetSx3Cache("RCH_NUMPAG", "X3_TITULO")) SIZE 038,007 OF oPanelUp PIXEL
	@ (aObjSize[1,1]*0.5)+6, aObjSize[1,2]+320	MSGET cNumPag SIZE 010,007	OF oPanelUp PIXEL  WHEN .T.	HASBUTTON VALID Gp20FilMark()

	oMark := FWMarkBrowse():New()
	
	oMark:SetAlias((cAliasMark))
	oMark:SetFields(aColsMark)
	
	//Indica o container onde sera criado o browse
	oMark:SetOwner(oPanelDown)
	
	oMark:AddButton(STR0003, bCalcula,,,, .F., 2 ) //'Calcular'
	oMark:AddButton(STR0078, bFiltro,,,, .F., 2 ) //'Filtrar Cálculo'
	
	oMark:bAllMark := { || SetMarkAll(oMark:Mark(),lMarcar := !lMarcar ), oMark:Refresh(.T.)  }
	
	// Define o campo que sera utilizado para a marcação
	oMark:SetFieldMark( 'TAB_OK')
	
	oMark:Activate()

ACTIVATE MSDIALOG oDlgMark CENTERED

Return Nil

/*/{Protheus.doc} GPM020IniProc
Inicia o processo de cálculo
@author Leandro Drumond
@since 16/05/2016
@version 1.0
/*/
Static Function GPM020IniProc()
Local cMarca 		:= oMark:Mark()
Local lRet			:= .T.
Local lRetPerg		:= .T.
Local lRotFer		:= .F.
Local lRot131		:= .F.
Local lRot132		:= .F.
Local lRotVTR		:= .F.
Local lRotVRF		:= .F.
Local lRotVAL		:= .F.

DbSelectArea(cAliasMark)
DbGoTop()

While !Eof()
	If oMark:IsMark(cMarca)
		aAdd(aRotMark,{TAB_PROC, TAB_ROT, TAB_PER, TAB_NPAG, TAB_TPROT, TAB_FIL})
	EndIf 
	
	//tela de parametros para roteiros 131, 132, Férias programadas VTR, VAL, e VRF 
	If oMark:IsMark(cMarca) .and. TAB_TPROT == "5" .And. !lRot131
		lRetPerg := Pergunte("GPEM250A",.T., STR0099)
		lRot131  := .T.
	ElseIf oMark:IsMark(cMarca) .and. TAB_TPROT == "6" .And. !lRot132
		lRetPerg := Pergunte("GPEM270A",.T., STR0100)
		lRot132  := .T.
	ElseIf oMark:IsMark(cMarca) .and. TAB_TPROT == "3" .and. !lRotFer
		lRetPerg := Pergunte("GPM062A",.T., STR0101)
		If mv_par02 == 2 .and. Empty(mv_par03)
			lRetPerg := .F.
			Help( ,, STR0005,, STR0094, 1, 0) //"A Data de Pagamento deve ser informada."
		ElseIf Empty(mv_par04) .or. Empty(mv_par05)
			lRetPerg := .F.
			Help( ,, STR0005,, STR0095, 1, 0) //"As datas de filtro da programação de férias devem ser informadas."
		EndIf
		lRotFer	 := .T.
	ElseIf oMark:IsMark(cMarca) .And. TAB_TPROT == "8" .And. ! lRotVTR
		lRetPerg := Pergunte("GP021VTR", .T., STR0102)
		lRotVTR := .T.
	ElseIf oMark:IsMark(cMarca) .And. TAB_TPROT == "D" .And. ! lRotVRF
		lRetPerg := Pergunte("GP021VRF", .T., STR0103)
		lRotVRF := .T.
	ElseIf oMark:IsMark(cMarca) .And. TAB_TPROT == "E" .And. ! lRotVAL
		lRetPerg := Pergunte("GP021VAL", .T., STR0104)
		lRotVAL := .T.
	EndIf
	
	DbSkip()
EndDo

If Empty(aRotMark)
	Help( ,, STR0005,, STR0017, 1, 0) //"Nenhum roteiro selecionado."
	lRet := .F.
ElseIf lRetPerg
	GPCallCmpAll("SRY",.T.,.F.)
	Proc2BarGauge( { || GPM020Processa() } , STR0076 , NIL , NIL , .F. , .T. , .F. , .F. )	// "Cálculo Unificado"
EndIf

Return lRet

/*/{Protheus.doc} GPM020Processa
Processa os cálculos seleiconados
@author Leandro Drumond
@since 16/05/2016
@version 1.0
/*/
Static Function GPM020Processa()
Local aArea			:= GetArea()
Local aLogTitle		:= {}
Local aLogItens		:= {}
Local aLogThd		:= {}
Local aParams		:= {}
Local cFilBkp		:= ""
Local cFilRCJ		:= ""
Local cFilter		:= ""
Local cUserAux		:= __cUserId
Local cTimeIni		:= Time()		// Informacoes da Regua
Local lGrid			:= GetMvRH("MV_GRID",, .F.) // Se o parametro esta configurado para utilizacao do GRID
Local nTotThread	:= Min(GetMvRH("MV_CALCTHD",, 5),5) // Se o parametro esta configurado para utilizacao do GRID
Local nPos			:= 0
Local nRotFim		:= 0
Local nThreads		:= 0
Local nTotProc		:= 0
Local nRotAux		:= 0
Local nX			:= 0
Local nPosAux		:= 0
Local nFimAux		:= 0

Private lAutoErrNoFile 	:= .T.

BarGauge1Set( Len(aRotMark) ) 

cFilBkp := cFilAnt

DbSelectArea("SRA")
DbSetOrder(1)

nTotProc := Len(aRotMark)

If !lGrid .and. nTotProc > 1
	nThreads := Min(nTotProc,nTotThread)
	VarSetUID("GPEM020A",.T.)
	VarSetXD("GPEM020A","nRotFim",0)
	VarSetAD("GPEM020A","aLogThd",{})
EndIf

For nPos := 1 to Len(aRotMark)
	nPosAux++
	IncPrcG1Time( STR0079 + aRotMark[nPos,6] + " / " + aRotMark[nPos,1] + " / " + aRotMark[nPos,2] + " / " + aRotMark[nPos,3] + " / " + aRotMark[nPos,4] , Len(aRotMark) , cTimeIni , .T. , 1 , 1 , .T. )
	
	If aRotMark[nPos,5] == "3"
		Pergunte("GPM062A",.F.)
		aParams := {aRotMark[nPos,1], mv_par01, mv_par02, mv_par03, mv_par04, mv_par05, mv_par06, mv_par07 }
		SetMVValue("GPM062","MV_PAR01",aRotMark[nPos,1])
		SetMVValue("GPM062","MV_PAR02",mv_par01)
		SetMVValue("GPM062","MV_PAR03",mv_par02)
		SetMVValue("GPM062","MV_PAR04",mv_par03)
		SetMVValue("GPM062","MV_PAR05",mv_par04)
		SetMVValue("GPM062","MV_PAR06",mv_par05)
		SetMVValue("GPM062","MV_PAR07",mv_par06)
		SetMVValue("GPM062","MV_PAR08",mv_par07)
		Pergunte("GPM062",.F.)					
	EndIf
	
	If SRA->(DbSeek(AllTrim(aRotMark[nPos,6]))) .or. nThreads > 1 //Busca primeiro funcionário da filial
	
		cFilter := ""
		
		If SRA->(DbSeek(AllTrim(aRotMark[nPos,6])))
			cFilAnt := SRA->RA_FILIAL
			cFilRCJ := AllTrim(xFilial("RCJ"))
			
			If !Empty(cFilUsua)
				cFilter := "( " + cFilUsua + " ) .AND. "
			EndIf
			
			cFilter += " RA_FILIAL >= '" + SubStr(cFilRCJ+Space(FWGETTAMFILIAL),1,FWGETTAMFILIAL) + "'"
			cFilter += " .and. RA_FILIAL <= '" + SubStr(cFilRCJ+Replicate("Z",FWGETTAMFILIAL),1,FWGETTAMFILIAL) + "'"			
		EndIf
		If nThreads > 1
			If !Empty(cFilter)
				StartJob("Gpm020Thread",GetEnvServer(),.F.,cEmpAnt,cFilAnt,"000000",aRotMark,cFilter,nPos,aParams)
			Else
				aAdd(aLogItens,{STR0057})
				
				//Soma 1 no controle de threads finalizadas
				VarBeginT("GPEM020A","nRotFim")
					VarGetXD("GPEM020A","nRotFim",@nRotAux)
					nRotAux++
					VarSetXD("GPEM020A","nRotFim",nRotAux)
				VarEndT("GPEM020A","nRotFim")
				
				nRotFim := nRotAux
			EndIf
				
			//Processa enquanto as threads não forem finalizadas
			While nPosAux == nTotThread .or. nPos == nTotProc
				VarGetXD("GPEM020A","nRotFim",@nRotFim)
				
				If nRotFim == nTotProc
					VarGetA("GPEM020A","aLogThd",@aLogThd)
					For nX := 1 to Len(aLogThd)
						If nX % 2 == 0
							aAdd(aLogItens,aLogThd[nX])
						Else
							aAdd(aLogTitle,aLogThd[nX][1])
						EndIf
					Next nX
					VarClean("GPEM020A")
					Exit
				EndIf
				If nRotFim > nFimAux
					nPosAux -= ( nRotFim - nFimAux )
					nFimAux := nRotFim
				EndIf				
			EndDo
		Else

			aAdd(aLogTitle,STR0080 + aRotMark[nPos,6] + " / " + STR0081 + aRotMark[nPos,1] + " / " + STR0082 + aRotMark[nPos,2] + " / " + STR0083 + aRotMark[nPos,3] + " / " + STR0084 + aRotMark[nPos,4])		

			If aRotMark[nPos,5] == "3"
				GPM060Proc(cFilter,.T.)
			Else		
				Gpem020(.T.,;			//Define Que a Chamada Esta Sendo Efetuada Atraves do WorkFlow
						aRotMark[nPos,1],;		//Define o processo que sera calculado
						aRotMark[nPos,2],;		//Define o roteiro que sera calculado
						cFilter;				//Filtro executado na rotina
						)
			 EndIf
			 
			 aLogAux := GetAutoGRLog()
			 aAdd(aLogItens,aLogAux)
			 
			 RstExecCalc() //Reseta variaveis staticas utilizadas no cálculo
		EndIf
	Else
		aAdd(aLogItens,{STR0057})
	EndIf	

Next nPos

__cUserId := cUserAux

MsAguarde( { || fMakeLog( aLogItens, aLogTitle , "GPEM020A" , NIL , FunName() , STR0016 ) } ,  STR0016)

cFilAnt := cFilBkp

SetMarkAll(oMark:Mark(),.F. )
aRotMark := {}

RestArea(aArea)

Return Nil

/*
{Protheus.doc} Gpm020Thread
Inicia threads de cálculo
@author Leandro Drumond
@since 19/10/2016
@version 1.0
*/
Function Gpm020Thread(xEmp,xFil,xUser,aRotMark,cFilter,nPos,aParams)
Local aLogAux	:= {}
Local aLogThd	:= {}
Local aLogTitle	:= {}
Local nRotFim	:= 0

//Prepara ambiente
RPCSetType( 3 )
RpcSetEnv( xEmp, xFil,,,"GPE") 
SetsDefault()

Private lAutoErrNoFile 	:= .T.

If Empty(cFilAnt)
	cFilAnt:= xFil
EndIf

__cUserId := xUser

aAdd(aLogTitle,STR0080 + aRotMark[nPos,6] + " / " + STR0081 + aRotMark[nPos,1] + " / " + STR0082 + aRotMark[nPos,2] + " / " + STR0083 + aRotMark[nPos,3] + " / " + STR0084 + aRotMark[nPos,4])

If aRotMark[nPos,5] == "3"
	SetMVValue("GPM062","MV_PAR01",aParams[1])
	SetMVValue("GPM062","MV_PAR02",aParams[2])
	SetMVValue("GPM062","MV_PAR03",aParams[3])
	SetMVValue("GPM062","MV_PAR04",aParams[4])
	SetMVValue("GPM062","MV_PAR05",aParams[5])
	SetMVValue("GPM062","MV_PAR06",aParams[6])
	SetMVValue("GPM062","MV_PAR07",aParams[7])
	SetMVValue("GPM062","MV_PAR08",aParams[8])
	Pergunte("GPM062",.F.)						
	GPM060Proc(cFilter,.T.)
Else
	Gpem020(.T.,;			//Define Que a Chamada Esta Sendo Efetuada Atraves do WorkFlow
			aRotMark[nPos,1],;		//Define o processo que sera calculado
			aRotMark[nPos,2],;		//Define o roteiro que sera calculado
			cFilter;				//Filtro executado na rotina
			)
EndIf

aLogAux := GetAutoGRLog()

If !Empty(aLogAux)
	VarBeginT("GPEM020A","aLogThd")
	VarGetAD("GPEM020A","aLogThd",@aLogThd)
	aAdd(aLogThd, aLogTitle)
	aAdd(aLogThd, aLogAux)
	VarSetAD("GPEM020A","aLogThd",aLogThd)
	VarEndT("GPEM020A","aLogThd")
EndIf

//Soma 1 no controle de threads finalizadas
VarBeginT("GPEM020A","nRotFim")
	VarGetXD("GPEM020A","nRotFim",@nRotFim)
	nRotFim++
	VarSetXD("GPEM020A","nRotFim",nRotFim)
VarEndT("GPEM020A","nRotFim")

RstExecCalc() //Reseta variaveis staticas utilizadas no cálculo

Return Nil

/*/{Protheus.doc} fCriaTmp
Cria tabela temporária para uso do FwMarkBrowse
@author Leandro Drumond
@since 16/05/2016
@version 1.0
/*/
Static Function fCriaTmp()
Local aColumns	 := {}
Local cArqTmp	 := ''
Local cQuery	 := ''
Local cKeyAux	 := ''
Local cAliasRCH	 := 'QRCH'
Local cAcessaSRA := &( " { || " + IF( Empty( cAcessaSRA := ChkRH( "GPEM020" , "SRA" , "2" ) ) , ".T." , cAcessaSRA ) + " } " )
Local lRet		 := .F.
	
If Select(cAliasMark) > 0
	DbSelectArea(cAliasMark)
	DbCloseArea()
EndIf 

aAdd( aColumns, { "TAB_OK"		,"C",02,00 })
aAdd( aColumns, { "TAB_ROT"		,"C",TAMSX3("RY_CALCULO")[1],TAMSX3("RY_CALCULO")[2]})
aAdd( aColumns, { "TAB_DESC"	,"C",TAMSX3("RY_DESC")[1],TAMSX3("RY_DESC")[2]})
aAdd( aColumns, { "TAB_PROC"	,"C",TAMSX3("RCH_PROCES")[1],TAMSX3("RCH_PROCES")[2]})
aAdd( aColumns, { "TAB_PER"		,"C",TAMSX3("RCH_PER")[1],TAMSX3("RCH_PER")[2]})
aAdd( aColumns, { "TAB_NPAG"	,"C",TAMSX3("RCH_NUMPAG")[1],TAMSX3("RCH_NUMPAG")[2]})
aAdd( aColumns, { "TAB_TPROT"	,"C",TAMSX3("RY_TIPO")[1],TAMSX3("RY_TIPO")[2]})
aAdd( aColumns, { "TAB_FIL"		,"C",TAMSX3("RCH_FILIAL")[1],TAMSX3("RCH_FILIAL")[2]})

cArqTmp := CriaTrab(aColumns,.T.)
dbUseArea( .T.,, cArqTmp, cAliasMark )

dbSelectArea( "RCH" )
DbSetOrder(RetOrdem("RCH","RCH_FILIAL+RCH_PROCES+RCH_ROTEIR+RCH_PER+RCH_NUMPAG"))

cQuery := "SELECT RY_DESC, RY_TIPO, RCH_FILIAL, RCH_PROCES, RCH_ROTEIR, RCH_PER, RCH_NUMPAG, RCH_DTINI"
cQuery += 		" FROM " + RetSqlName("RCH") + " RCH"
cQuery +=			" INNER JOIN " + RetSqlName("SRY") + " SRY"
cQuery +=			" ON RCH_ROTEIR = RY_CALCULO AND "
cQuery +=			FWJoinFilial( "RCH", "SRY" )
cQuery +=		" WHERE"
cQuery +=			" RY_TIPO NOT IN  ('4','G','J') AND"
cQuery +=			" RCH_PERSEL = '1' AND"
cQuery +=			" RCH_DTINTE = '        ' AND"
cQuery +=			" SRY.D_E_L_E_T_ <> '*' AND RCH.D_E_L_E_T_ <> '*'"
cQuery += 		" ORDER BY " + SqlOrder(RCH->(IndexKey()))

cQuery := ChangeQuery( cQuery )

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasRCH)

DbSelectArea(cAliasRCH)

DbSelectArea(cAliasMark)

While (cAliasRCH)->(!Eof())
	If cKeyAux <> (cAliasRCH)->(RCH_FILIAL+RCH_PROCES+RCH_ROTEIR+RCH_PER+RCH_NUMPAG)

		If ( !(Empty((cAliasRCH)->RCH_FILIAL)) .And. !(AllTrim((cAliasRCH)->RCH_FILIAL) $ fValidFil()) ) .Or. !Eval( cAcessaSRA )
			dbSelectArea(cAliasRCH)
			dbSkip()
			Loop
		EndIf

		lRet := .T.
	
		RecLock(cAliasMark,.T.)
		(cAliasMark)->TAB_FIL 	:= (cAliasRCH)->RCH_FILIAL
		(cAliasMark)->TAB_ROT 	:= (cAliasRCH)->RCH_ROTEIR
		(cAliasMark)->TAB_DESC 	:= (cAliasRCH)->RY_DESC
		(cAliasMark)->TAB_PROC	:= (cAliasRCH)->RCH_PROCES
		(cAliasMark)->TAB_PER	:= (cAliasRCH)->RCH_PER
		(cAliasMark)->TAB_NPAG	:= (cAliasRCH)->RCH_NUMPAG
		(cAliasMark)->TAB_TPROT	:= (cAliasRCH)->RY_TIPO
		
		MsUnLock()
		cKeyAux := (cAliasRCH)->(RCH_FILIAL+RCH_PROCES+RCH_ROTEIR+RCH_PER+RCH_NUMPAG)
	EndIf

	(cAliasRCH)->(DbSkip())

EndDo

( cAliasRCH )->( dbCloseArea() )

Return lRet

/*/{Protheus.doc} FMntColsMark
Carrega tabela temporária com dados para exibição na MarkBrowse
@author Leandro Drumond
@since 16/05/2016
@version 1.0
/*/
Static Function fMntColsMark()
Local aArea		:= GetArea()
Local aColsAux 	:=`{}
Local aColsSX3	:= {}
Local aCampos  	:= {"RCH_FILIAL","RCH_PROCES","RCH_PER","RY_CALCULO","RY_DESC","RCH_NUMPAG"}
Local aDados	:= {{||(cAliasMark)->TAB_FIL},{||(cAliasMark)->TAB_PROC},{||(cAliasMark)->TAB_PER},{||(cAliasMark)->TAB_ROT}, {||(cAliasMark)->TAB_DESC},{||(cAliasMark)->TAB_NPAG}}
Local nX		:= 0

DbSelectArea("SX3")
DbSetOrder(2)

For nX := 1 to Len(aCampos)
	If SX3->( dbSeek(aCampos[nX]) )
	    aColsSX3 := {X3Titulo(),aDados[nX], SX3->X3_TIPO, SX3->X3_PICTURE,1,SX3->X3_TAMANHO,SX3->X3_DECIMAL,.F.,,,,,,,,1}
	    aAdd(aColsAux,aColsSX3)
	    aColsSX3 := {}
	EndIf
Next nX

RestArea(aArea)

Return aColsAux

/*/{Protheus.doc} SetMarkAll
Marca/Desmarca todos os itens da markbrowse
@author Leandro Drumond
@since 16/05/2016
@version 1.0
/*/
Static Function SetMarkAll(cMarca,lMarcar )

Local aAreaMark  := (cAliasMark)->( GetArea() )

dbSelectArea(cAliasMark)
(cAliasMark)->( dbGoTop() )

While !(cAliasMark)->( Eof() )
	RecLock( (cAliasMark), .F. )
	(cAliasMark)->TAB_OK := IIf( lMarcar, cMarca, '  ' )
	MsUnLock()
	(cAliasMark)->( dbSkip() )
EndDo

RestArea( aAreaMark )

Return .T.

/*/{Protheus.doc} GP20FilMark
Filtra dados da MarkBrowse de acordo com opções preenchidas
@author Leandro Drumond
@since 16/05/2016
@version 1.0
/*/
Static Function Gp20FilMark()

	Local cFilBkp := cFilCalc 
	
	If !Empty(cFilCalc)
		cFilCalc := xFilial("RCH",cFilCalc) //Altera o cFilCalc para ficar de acordo com o compartilhamento utilizado.
	EndIf

	DbSelectArea(cAliasMark)
	SET FILTER TO

	SetMarkAll(oMark:Mark(),.F. )
	oMark:Refresh(.T.) 
	
	DbSelectArea(cAliasMark)
	
	If Empty(cFilCalc)
		If !Empty(cProcesso) .and. !Empty(cPeriodo) .and. !Empty(cNumPag) .and. !Empty(cRoteiro)
			SET FILTER TO TAB_PROC == cProcesso .And.  TAB_PER ==  cPeriodo .And. TAB_NPAG ==cNumPag .And.  TAB_ROT  ==   cRoteiro
		ElseIf !Empty(cProcesso) .and. !Empty(cPeriodo) .and. !Empty(cNumPag) .and. Empty(cRoteiro)
			SET FILTER TO TAB_PROC == cProcesso .And.  TAB_PER ==  cPeriodo .And. TAB_NPAG ==cNumPag 
		ElseIf !Empty(cProcesso) .and. !Empty(cPeriodo) .and. Empty(cNumPag) .and. !Empty(cRoteiro)
		 	SET FILTER TO TAB_PROC == cProcesso .And.  TAB_PER ==  cPeriodo .And.  TAB_ROT  ==   cRoteiro
		ElseIf !Empty(cProcesso) .and. Empty(cPeriodo) .and. !Empty(cNumPag) .and. !Empty(cRoteiro)
			SET FILTER TO TAB_PROC == cProcesso .And. TAB_NPAG == cNumPag .And. TAB_ROT == cRoteiro
		ElseIf !Empty(cProcesso) .and. Empty(cPeriodo) .and. !Empty(cNumPag) .and. Empty(cRoteiro)
			SET FILTER TO TAB_PROC == cProcesso .And. TAB_NPAG ==cNumPag 
		ElseIf !Empty(cProcesso) .and. Empty(cPeriodo) .and. Empty(cNumPag) .and. !Empty(cRoteiro)
			SET FILTER TO TAB_PROC == cProcesso .And. TAB_ROT  == cRoteiro
		ElseIf !Empty(cProcesso) .and. !Empty(cPeriodo) .and. Empty(cNumPag) .and. Empty(cRoteiro)
			SET FILTER TO TAB_PROC == cProcesso .And.  TAB_PER == cPeriodo
		ElseIf !Empty(cProcesso) .and. Empty(cPeriodo) .and. Empty(cNumPag) .and. Empty(cRoteiro)
			SET FILTER TO TAB_PROC == cProcesso
		ElseIf Empty(cProcesso) .and. !Empty(cPeriodo) .and. Empty(cNumPag) .and. Empty(cRoteiro)
			SET FILTER TO TAB_PER == cPeriodo
		ElseIf Empty(cProcesso) .and. !Empty(cPeriodo) .and. !Empty(cNumPag) .and. !Empty(cRoteiro)
			SET FILTER TO TAB_PER == cPeriodo .And. TAB_NPAG == cNumPag .And. TAB_ROT == cRoteiro
		ElseIf Empty(cProcesso) .and. !Empty(cPeriodo) .and. !Empty(cNumPag) .and. Empty(cRoteiro)
			SET FILTER TO TAB_PER == cPeriodo .And. TAB_NPAG == cNumPag
		ElseIf Empty(cProcesso) .and. !Empty(cPeriodo) .and. Empty(cNumPag) .and. !Empty(cRoteiro)
			SET FILTER TO  TAB_PER ==  cPeriodo .And.  TAB_ROT  ==   cRoteiro
		ElseIf Empty(cProcesso) .and. Empty(cPeriodo) .and. !Empty(cNumPag) .and. !Empty(cRoteiro)
			SET FILTER TO  TAB_NPAG == cNumPag .And.  TAB_ROT == cRoteiro
		ElseIf Empty(cProcesso) .and. Empty(cPeriodo) .and. !Empty(cNumPag) .and. Empty(cRoteiro)
			SET FILTER TO TAB_NPAG == cNumPag
		ElseIf Empty(cProcesso) .and. Empty(cPeriodo) .and. Empty(cNumpag) .and. !Empty(cRoteiro)
			SET FILTER TO TAB_ROT == cRoteiro
		EndIf
	Else
		If !Empty(cProcesso) .and. !Empty(cPeriodo) .and. !Empty(cNumPag) .and. !Empty(cRoteiro)
			SET FILTER TO TAB_FIL == cFilCalc .And. TAB_PROC == cProcesso .And.  TAB_PER ==  cPeriodo .And. TAB_NPAG ==cNumPag .And.  TAB_ROT  ==   cRoteiro
		ElseIf !Empty(cProcesso) .and. !Empty(cPeriodo) .and. !Empty(cNumPag) .and. Empty(cRoteiro)
			SET FILTER TO TAB_FIL == cFilCalc .And. TAB_PROC == cProcesso .And.  TAB_PER ==  cPeriodo .And. TAB_NPAG ==cNumPag 
		ElseIf !Empty(cProcesso) .and. !Empty(cPeriodo) .and. Empty(cNumPag) .and. !Empty(cRoteiro)
		 	SET FILTER TO TAB_FIL == cFilCalc .And. TAB_PROC == cProcesso .And.  TAB_PER ==  cPeriodo .And. TAB_ROT  ==   cRoteiro
		ElseIf !Empty(cProcesso) .and. Empty(cPeriodo) .and. !Empty(cNumPag) .and. !Empty(cRoteiro)
			SET FILTER TO TAB_FIL == cFilCalc .And. TAB_PROC == cProcesso .And. TAB_NPAG == cNumPag .And. TAB_ROT == cRoteiro
		ElseIf !Empty(cProcesso) .and. Empty(cPeriodo) .and. !Empty(cNumPag) .and. Empty(cRoteiro)
			SET FILTER TO TAB_FIL == cFilCalc .And. TAB_PROC == cProcesso .And. TAB_NPAG ==cNumPag 
		ElseIf !Empty(cProcesso) .and. Empty(cPeriodo) .and. Empty(cNumPag) .and. !Empty(cRoteiro)
			SET FILTER TO TAB_FIL == cFilCalc .And. TAB_PROC == cProcesso .And. TAB_ROT  == cRoteiro
		ElseIf !Empty(cProcesso) .and. !Empty(cPeriodo) .and. Empty(cNumPag) .and. Empty(cRoteiro)
			SET FILTER TO TAB_FIL == cFilCalc .And. TAB_PROC == cProcesso .And.  TAB_PER == cPeriodo
		ElseIf !Empty(cProcesso) .and. Empty(cPeriodo) .and. Empty(cNumPag) .and. Empty(cRoteiro)
			SET FILTER TO TAB_FIL == cFilCalc .And. TAB_PROC == cProcesso
		ElseIf Empty(cProcesso) .and. !Empty(cPeriodo) .and. Empty(cNumPag) .and. Empty(cRoteiro)
			SET FILTER TO TAB_FIL == cFilCalc .And. TAB_PER == cPeriodo
		ElseIf Empty(cProcesso) .and. !Empty(cPeriodo) .and. !Empty(cNumPag) .and. !Empty(cRoteiro)
			SET FILTER TO TAB_FIL == cFilCalc .And. TAB_PER == cPeriodo .And. TAB_NPAG == cNumPag .And. TAB_ROT == cRoteiro
		ElseIf Empty(cProcesso) .and. !Empty(cPeriodo) .and. !Empty(cNumPag) .and. Empty(cRoteiro)
			SET FILTER TO TAB_FIL == cFilCalc .And. TAB_PER == cPeriodo .And. TAB_NPAG == cNumPag
		ElseIf Empty(cProcesso) .and. !Empty(cPeriodo) .and. Empty(cNumPag) .and. !Empty(cRoteiro)
			SET FILTER TO TAB_FIL == cFilCalc .And. TAB_PER ==  cPeriodo .And.  TAB_ROT  ==   cRoteiro
		ElseIf Empty(cProcesso) .and. Empty(cPeriodo) .and. !Empty(cNumPag) .and. !Empty(cRoteiro)
			SET FILTER TO TAB_FIL == cFilCalc .And. TAB_NPAG == cNumPag .And.  TAB_ROT == cRoteiro
		ElseIf Empty(cProcesso) .and. Empty(cPeriodo) .and. !Empty(cNumPag) .and. Empty(cRoteiro)
			SET FILTER TO TAB_FIL == cFilCalc .And. TAB_NPAG == cNumPag
		ElseIf Empty(cProcesso) .and. Empty(cPeriodo) .and. Empty(cNumpag) .and. !Empty(cRoteiro)
			SET FILTER TO TAB_FIL == cFilCalc .And. TAB_ROT == cRoteiro
		Else
			SET FILTER TO TAB_FIL == cFilCalc
		EndIf	
	EndIf	
	
	oMark:GoTop(.T.)
	oMark:Refresh()	
	
	cFilCalc := cFilBkp

Return .T.

/*
{Protheus.doc} GPM020IniFilt
Monta filtro utilizado no cálculo
@author Leandro Drumond
@since 16/05/2016
@version 1.0
*/
Static Function GPM020IniFilt()

GpFltBldExp( "SRA" , NIL , @cFilUsua , NIL )

Return Nil

/*
{Protheus.doc} AjustaSX1
Cria grupo de perguntas para cálculo de férias programadas
@author Leandro Drumond
@since 27/09/2017
@version 1.0
*/
Static Function AjustaSX1()
	If FindFunction("EngSX1114")
		EngSX1114("GPM062A", "01", "Calcular em Ordem ?           ", "¿Calcular en orden ?          ", "Calculate in Order ?          ", "mv_ch1", "N", 1, 0,  1,"C", "","","","","mv_par01", "Matricula      ", "Matricula      ",  "Registration   ", "","Centro Custo   ", "Centro costo   ",  "Cost Center    ", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06202.")
		EngSX1114("GPM062A", "02", "Dt Pagto Informada ?          ", "¿Fecha pago informada ?       ", "Entered Pymt Dt ?             ", "mv_ch2", "N", 1, 0,  1,"C", "","","","","mv_par02", "Nao            ", "No             ",  "No             ", "","Sim			   ", "Si			  ",  "Yes			  ", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06203.")
		EngSX1114("GPM062A", "03", "Dt Pagto Fer.Prog. ?          ", "¿Fecha pafo fer. prog. ?      ", "Sched. Holiday Pymt. Dt. ?    ", "mv_ch3", "D", 8, 0,  0,"G", "","","","","mv_par03", 				 "", 			 	"",  				"", "", 			  "", 			  	 "",  				 "", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06204.")
		EngSX1114("GPM062A", "04", "Dt Inicio Prog. De ?          ", "¿De fecha inicio prog. ?      ", "From Sched. Start Date ?      ", "mv_ch4", "D", 8, 0,  0,"G", "","","","","mv_par04", 				 "", 			 	"",  				"", "", 			  "", 			  	 "",  				 "", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06205.")
		EngSX1114("GPM062A", "05", "Dt Inicio Prog. Ate ?         ", "¿A fecha inicio prog. ?       ", "To Sched. Start Date ?        ", "mv_ch5", "D", 8, 0,  0,"G", "","","","","mv_par05", 				 "", 			 	"",  				"", "", 			  "", 			  	 "",  				 "", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06206.")
		EngSX1114("GPM062A", "06", "Media do Mes Atual ?          ", "¿Promedio del mes actual ?    ", "Average of Current Month ?    ", "mv_ch6", "N", 1, 0,  1,"C", "","","","","mv_par06", "Sim			  ", "Si			 ",  "Yes			 ", "","Nao            ", "No             ",  "No             ", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06207.")
		EngSX1114("GPM062A", "07", "Calcular p/ periodo ?         ", "¿Calcular p/ periodo ?        ", "Calculate by Period ?         ", "mv_ch7", "N", 1, 0,  3,"C", "","","","","mv_par07", "Vencido        ", "Vencido        ",  "Overdue        ", "","A Vencer       ", "Por vencer     ",  "To Be Due      ", "Ambos          ", "Ambos          ", "Both           ",  "", "", "", "",  "",  "", , , ,".GPM06208.")	
	ElseIf FindFunction("EngSX1116")
		EngSX1116("GPM062A", "01", "Calcular em Ordem ?           ", "¿Calcular en orden ?          ", "Calculate in Order ?          ", "mv_ch1", "N", 1, 0,  1,"C", "","","","","mv_par01", "Matricula      ", "Matricula      ",  "Registration   ", "","Centro Custo   ", "Centro costo   ",  "Cost Center    ", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06202.")
		EngSX1116("GPM062A", "02", "Dt Pagto Informada ?          ", "¿Fecha pago informada ?       ", "Entered Pymt Dt ?             ", "mv_ch2", "N", 1, 0,  1,"C", "","","","","mv_par02", "Nao            ", "No             ",  "No             ", "","Sim			   ", "Si			  ",  "Yes			  ", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06203.")
		EngSX1116("GPM062A", "03", "Dt Pagto Fer.Prog. ?          ", "¿Fecha pafo fer. prog. ?      ", "Sched. Holiday Pymt. Dt. ?    ", "mv_ch3", "D", 8, 0,  0,"G", "","","","","mv_par03", 				 "", 			 	"",  				"", "", 			  "", 			  	 "",  				 "", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06204.")
		EngSX1116("GPM062A", "04", "Dt Inicio Prog. De ?          ", "¿De fecha inicio prog. ?      ", "From Sched. Start Date ?      ", "mv_ch4", "D", 8, 0,  0,"G", "","","","","mv_par04", 				 "", 			 	"",  				"", "", 			  "", 			  	 "",  				 "", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06205.")
		EngSX1116("GPM062A", "05", "Dt Inicio Prog. Ate ?         ", "¿A fecha inicio prog. ?       ", "To Sched. Start Date ?        ", "mv_ch5", "D", 8, 0,  0,"G", "","","","","mv_par05", 				 "", 			 	"",  				"", "", 			  "", 			  	 "",  				 "", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06206.")
		EngSX1116("GPM062A", "06", "Media do Mes Atual ?          ", "¿Promedio del mes actual ?    ", "Average of Current Month ?    ", "mv_ch6", "N", 1, 0,  1,"C", "","","","","mv_par06", "Sim			  ", "Si			 ",  "Yes			 ", "","Nao            ", "No             ",  "No             ", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06207.")
		EngSX1116("GPM062A", "07", "Calcular p/ periodo ?         ", "¿Calcular p/ periodo ?        ", "Calculate by Period ?         ", "mv_ch7", "N", 1, 0,  3,"C", "","","","","mv_par07", "Vencido        ", "Vencido        ",  "Overdue        ", "","A Vencer       ", "Por vencer     ",  "To Be Due      ", "Ambos          ", "Ambos          ", "Both           ",  "", "", "", "",  "",  "", , , ,".GPM06208.")	
	ElseIf FindFunction("EngSX1117")
		EngSX1117("GPM062A", "01", "Calcular em Ordem ?           ", "¿Calcular en orden ?          ", "Calculate in Order ?          ", "mv_ch1", "N", 1, 0,  1,"C", "","","","","mv_par01", "Matricula      ", "Matricula      ",  "Registration   ", "","Centro Custo   ", "Centro costo   ",  "Cost Center    ", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06202.")
		EngSX1117("GPM062A", "02", "Dt Pagto Informada ?          ", "¿Fecha pago informada ?       ", "Entered Pymt Dt ?             ", "mv_ch2", "N", 1, 0,  1,"C", "","","","","mv_par02", "Nao            ", "No             ",  "No             ", "","Sim			   ", "Si			  ",  "Yes			  ", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06203.")
		EngSX1117("GPM062A", "03", "Dt Pagto Fer.Prog. ?          ", "¿Fecha pafo fer. prog. ?      ", "Sched. Holiday Pymt. Dt. ?    ", "mv_ch3", "D", 8, 0,  0,"G", "","","","","mv_par03", 				 "", 			 	"",  				"", "", 			  "", 			  	 "",  				 "", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06204.")
		EngSX1117("GPM062A", "04", "Dt Inicio Prog. De ?          ", "¿De fecha inicio prog. ?      ", "From Sched. Start Date ?      ", "mv_ch4", "D", 8, 0,  0,"G", "","","","","mv_par04", 				 "", 			 	"",  				"", "", 			  "", 			  	 "",  				 "", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06205.")
		EngSX1117("GPM062A", "05", "Dt Inicio Prog. Ate ?         ", "¿A fecha inicio prog. ?       ", "To Sched. Start Date ?        ", "mv_ch5", "D", 8, 0,  0,"G", "","","","","mv_par05", 				 "", 			 	"",  				"", "", 			  "", 			  	 "",  				 "", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06206.")
		EngSX1117("GPM062A", "06", "Media do Mes Atual ?          ", "¿Promedio del mes actual ?    ", "Average of Current Month ?    ", "mv_ch6", "N", 1, 0,  1,"C", "","","","","mv_par06", "Sim			  ", "Si			 ",  "Yes			 ", "","Nao            ", "No             ",  "No             ", 				"", 			   "", 				  "",  "", "", "", "",  "",  "", , , ,".GPM06207.")
		EngSX1117("GPM062A", "07", "Calcular p/ periodo ?         ", "¿Calcular p/ periodo ?        ", "Calculate by Period ?         ", "mv_ch7", "N", 1, 0,  3,"C", "","","","","mv_par07", "Vencido        ", "Vencido        ",  "Overdue        ", "","A Vencer       ", "Por vencer     ",  "To Be Due      ", "Ambos          ", "Ambos          ", "Both           ",  "", "", "", "",  "",  "", , , ,".GPM06208.")
	EndIf
Return Nil