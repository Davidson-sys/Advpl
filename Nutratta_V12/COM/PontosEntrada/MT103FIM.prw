#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออออออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณ MT103FIM บ Autor ณ Fabricio Antunes      บ Data da Criacao  ณ 25/04/2014                						บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada    para digitacao de observacao no ato do documento de entrada para preencher o campo de    บฑฑ
ฑฑบ          ณ historio no titulos a pagar SE2->E2_HIST                                                                     บฑฑ
ฑฑบ          ณ                                                                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento Nutrata                                                                                          บฑฑ
ฑฑบ          ณ                                                                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nenhum						   							                               						บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nenhum						  							                               						บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUsuario   ณ Microsiga                                                                                					บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSetor     ณ Faturamento                                                                             						บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ            			          	ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL                   						บฑฑ
ฑฑฬออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออัออออออออออออออออออออออออออออออออออัอออออออออออออนฑฑ
ฑฑบAutor     ณ Data     ณ Motivo da Alteracao  				               ณUsuario(Filial+Matricula+Nome)    ณSetor        บฑฑ
ฑฑบฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤบฑฑ
ฑฑบ          ณ00/00/0000ณ                               				   ณ00-000000 -                       ณ TI	        บฑฑ
ฑฑบ----------ณ----------ณ--------------------------------------------------ณ----------------------------------ณ-------------บฑฑ
ฑฑบWANDER LIBณ03/03/2014ณ IDENTIFICAวรO DE PA/NDF PARA COMPENSAวรO ONLINE  ณ                                  ณ LIBERDADE	บฑฑ
ฑฑบ----------ณ----------ณ--------------------------------------------------ณ----------------------------------ณ-------------บฑฑ
ฑฑศออออออออออฯออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออฯออออออออออออออออออออออออออออออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MT103FIM()
Local nOpcao 	:= PARAMIXB[1]
Local nConfirma := PARAMIXB[2] 
Local oGroup1
Local oHist
Local cHist 	:= Space(80)
Local oSay1
Local oSButton1
Local lCompLiber:=	.F.
Static oDlg
                      

GravaNaturez()

IF nOpcao = 3 .AND. nConfirma = 1 
  DEFINE MSDIALOG oDlg TITLE "Nutratta - Ra็ใo de alta qualidade" FROM 000, 000  TO 200, 415 COLORS 0, 16777215 PIXEL

    @ 004, 005 GROUP oGroup1 TO 095, 201 PROMPT " Nutratta " OF oDlg COLOR 0, 16777215 PIXEL
    @ 016, 014 SAY oSay1 PROMPT "Favor digitar o hist๓rico da nota. Esta informa็ใo serแ gravada no Hist๓rico do Titulo do Contas a Pagar" SIZE 182, 018 OF oDlg COLORS 0, 16777215 PIXEL
    @ 038, 014 MSGET oHist VAR cHist SIZE 178, 010 OF oDlg  PICTURE "@!" COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 076, 165 TYPE 01 OF oDlg ENABLE ACTION IIF(Alltrim(cHist) <> '',GravaHist(cHist),MsgStop("Favor informar o hist๓rio!"))

  ACTIVATE MSDIALOG oDlg CENTERED
  
EndIF

//LIBERDADE 03/03/2015 - WANDER SOUZA
IF( nOpcao = 3 .AND. nConfirma = 1 )

	aAreaSE2:=	SE2->(GetArea())
	
	DBSELECTAREA("SE2")
	DbSetOrder(1)
	DbSeek(SF1->(F1_FILIAL+F1_PREFIXO+F1_DOC))
	WHILE !EOF() .AND. SF1->(F1_FILIAL+F1_PREFIXO+F1_DOC) == SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM)

		cQuery:=	"SELECT R_E_C_N_O_ REC FROM "+RETSQLNAME("SE2")+" SE2 "
		cQuery+=	"WHERE D_E_L_E_T_ = ' ' AND "
		cQuery+=	"E2_FORNECE='"+SF1->F1_FORNECE+"' AND "
		cQuery+=	"E2_LOJA='"+SF1->F1_LOJA+"' And "
		cQuery+=	"E2_SALDO > 0 And "
		cQuery+=	"E2_TIPO IN "+FORMATIN(GETNEWPAR("NT_TPDBFOR","PA /NDF"),"/")+" "
	
		dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), "LIBTMP", .F., .T.)
	
		If !LIBTMP->(EOF())	
		
			If Type("lCompLiber") == "U"
				If MsgYesNo("Este cliente contem titulo(s) do Tipo NCC e/ou RA em aberto, deseja compensa-lo(s) neste momento?")
					lCompLiber:=.T.
					
					SetKey (VK_F12,{|a,b| AcessaPerg("AFI340",.T.)})
					Pergunte("AFI340",.T.)
					
				Else
					lCompLiber:=.F.
				EndIf
			EndIf
		
		EndIf		
			
		If lCompLiber
		
			DbSelectArea("SE2")
			
			PRIVATE	lFina340 := ExistBlock("FA340FILT")

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Define o cabealho da tela de baixas				ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			PRIVATE cCadastro := OemToAnsi("Compensao de Titulos")  //"Compensao de Titulos"
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Verifica o numero do Lote 							ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			PRIVATE cLote
			LoteCont( "FIN" )
			
			PRIVATE	VALOR 	:= 0
			PRIVATE VALOR4	:= 0
			PRIVATE VLRINSTR := 0
			PRIVATE	cMarca	:= GetMark()
			PRIVATE	lFina340 := ExistBlock("FA340FILT")
			PRIVATE	cCpoNum
			
			PRIVATE nTamTit := TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]+TamSX3("E2_PARCELA")[1]
			PRIVATE nTamTip := TamSX3("E2_TIPO")[1]
			Private aTxMoedas	:=	{}
			Private lCalcIssBx := !Empty( SE5->( FieldPos( "E5_VRETISS" ) ) ) .and. !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .and. ;
									  !Empty( SE2->( FieldPos( "E2_TRETISS" ) ) ) .and. GetNewPar("MV_MRETISS","1") == "2"  //Retencao do ISS pela emissao (1) ou baixa (2)
			
			Private aTxMoedas	:=	{}
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Estrutura aTxMoedas         ณ
			//ณ [1] -> Nome Moeda          	ณ
			//ณ [2] -> Taxa a Ser Utilizada	ณ
			//ณ [3] -> Picture          	ณ
			//ณ [4] -> Taxa do dia atual    ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
			Aadd(aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1"),1})
			For nA := 2	To MoedFin()
				cMoedaTx :=	Str(nA,IIf(nA <= 9,1,2))
				If !Empty(GetMv("MV_MOEDA"+cMoedaTx))
					nVlMoeda := RecMoeda(dDataBase,nA)
					Aadd(aTxMoedas,{GetMv("MV_MOEDA"+cMoedaTx),nVlMoeda,PesqPict("SM2","M2_MOEDA"+cMoedaTx),nVlMoeda })
				Else
					Exit
				Endif
			Next
						
			Fa340Comp("SE2",,4)
			
		EndIf
		DbSelectArea("LIBTMP")
		DbCloseArea()
		
		DbSelectArea("SE2")
		DbSkip()
	END        

	//Dele็ใo de Provis๕es caso exista para o fornecedor+natureza
	
	nOpct	:=	0
	DBSELECTAREA("SE2")
	DbSetOrder(1)
	DbSeek(SF1->(F1_FILIAL+F1_PREFIXO+F1_DOC))
	IF FOUND()
		cFiltro:=	"E2_NATUREZ = '"+SE2->E2_NATUREZ+"' .AND. E2_SALDO > 0 .AND. E2_TIPO $ '"+GetNewPar("NT_TPPROV","PR /")+"' "
	
		DbSelectArea("SE2")
		Set Filter To &(cFiltro)		
		DbSelectArea("SE2")
		dbgotop()
		If !Eof()
		
			lInverte:=	.F.
			cMarca	:=	GetMark()
			
			DEFINE MSDIALOG oDlg1 TITLE "Selecao para Delecao de PROVISIONAMENTOS" From 9,0 To 28,160 OF oMainWnd
			
			oMark := MsSelect():New("SE2","E2_OK",,,@lInverte,@cMarca,{1,1,110,633})
			ACTIVATE MSDIALOG oDlg1 CENTERED ON INIT EnchoiceBar(oDlg1,{|| nOpct:=1,oDlg1:End()},{|| nOpct:=2,oDlg1:End()})			
			
		EndIf
		
		If nOpct == 1
			DbSelectArea("SE2")
			DbGoTop()
			While !Eof()
			
				If SE2->E2_OK == cMarca
					RecLock("SE2",.f.)
					DbDelete()
					MsUnLock()
				EndIf
				
				DbSelectArea("SE2")
				DbSkip()
			End
		EndIf

		DbSelectArea("SE2")
		dbClearFilter() 
	
	EndIf
	
	RestArea(aAreaSE2)
	lCompLiber:=Nil

//--Forma de Pagamento no Contas a receber-Davidson-17/05/2017.
	If nConfirma == 1
		U_ACOM001()
	Endif 	
EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravahist บAutor  ณMicrosiga           บ Data ณ  04/25/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gravahist(cGrava)
Local xAreaSE2:=GetArea("SE2")
Local cQuery

dbSelectArea("SE2")

cQuery:= "SELECT R_E_C_N_O_ AS REC FROM "+RetSqlName("SE2")+" WHERE E2_PREFIXO = '"+SE2->E2_PREFIXO+"' AND E2_NUM = '"+SE2->E2_NUM+"' AND E2_TIPO= '"+SE2->E2_TIPO+"' "
cQuery+=" AND E2_FORNECE = '"+SE2->E2_FORNECE+"' AND E2_LOJA= '"+SE2->E2_LOJA+"' AND D_E_L_E_T_ = ''"
cQuery+=" ORDER BY E2_PARCELA"
TcQuery ChangeQuery(cQuery) New Alias "TMP"

While !TMP->(EOF())

	SE2->(DbGoto(TMP->REC))
	RecLock("SE2",.F.)
		SE2->E2_HIST	:=cGrava
	MsUnLock()
	TMP->(dbSkip())
EndDo	       

TMP->(dbCloseArea())
RestArea(xAreaSE2)
Close(oDlg)
Return                  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravaNaturez บAutor  ณMicrosiga        บ Data ณ  04/25/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GravaNaturez()
Local xAreaSE2:=GetArea("SE2")
Local cQuery

dbSelectArea("SE2")

cQuery:= "SELECT R_E_C_N_O_ AS REC FROM "+RetSqlName("SE2")+" WHERE E2_PREFIXO = '"+SE2->E2_PREFIXO+"' AND E2_NUM = '"+SE2->E2_NUM+"' AND E2_TIPO= '"+SE2->E2_TIPO+"' "
cQuery+=" AND E2_FORNECE = '"+SE2->E2_FORNECE+"' AND E2_LOJA= '"+SE2->E2_LOJA+"' AND D_E_L_E_T_ = ''"
cQuery+=" ORDER BY E2_PARCELA"
TcQuery ChangeQuery(cQuery) New Alias "TMP"

While !TMP->(EOF())

	SE2->(DbGoto(TMP->REC))
	RecLock("SE2",.F.)
		SE2->E2_E_NATUR	:= POSICIONE("SED", 1, xFilial("SED")+SE2->E2_NATUREZ, "ED_DESCRIC" )
	MsUnLock()
	TMP->(dbSkip())
EndDo	       

TMP->(dbCloseArea())
RestArea(xAreaSE2)
Return                  
