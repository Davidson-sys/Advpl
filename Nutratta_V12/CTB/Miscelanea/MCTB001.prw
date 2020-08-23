#include "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MCTB001   º Autor ³ ANTONIO VASCONCELOSº Data ³  19/04/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Altera parametros MV_DATAFIN, MV_DATAFIS, MV_DATAREC e	  º±±
±±º          ³MV_DBLQMOV para não permitir movimentações.			      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 			 ³			³ 		  ³ 					               ±±
±±³ 			 ³			³ 		  ³ 								   ±±
±±³ 			 ³			³ 		  ³ 								   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MCTB001()
                                        
Local _dAtualEst 		:= GETMV("MV_ULMES") 
Local _dAtualFin 		:= GETMV("MV_DATAFIN") 
Local _datualFis 		:= GETMV("MV_DATAFIS") 
Local _datualRec 		:= GETMV("MV_DATAREC") 
Local _dAtualAtivo	:= GETMV("MV_DBLQMOV")

IF alltrim(__CUSERID) $ GETNEWPAR("NT_USRCTB","000000") //apenas o usuario autorizado.

	Private oDlg1
	Private cString := "SX6"
	Private _dDataEst   := ctod(space(8))
	Private _dDataFin   := ctod(space(8))
	Private _dDataFis   := ctod(space(8))    
	Private _dDataRec	   := ctod(space(8)) 
	Private _dDataAtivo := ctod(space(8))   
	
	DEFINE FONT oFont10 NAME "Arial" SIZE 6,10 BOLD
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da tela de processamento.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	                 
	DEFINE MSDIALOG oDlg1 TITLE "MCTB001 - Fechamento parametros contabeis" FROM 0,0 TO 200,750 PIXEL
		
	@  05, 005 SAY "FINANCEIRO"      FONT oFont10	PIXEL
	@  20, 005 SAY "ATUAL: "      		PIXEL
	@  20, 030 SAY _dAtualFin          	PIXEL
	@  40, 005 SAY "NOVA: "      			PIXEL
	@  40, 025 MSGET _dDataFin    SIZE 40,8 OF oDlg1 	PIXEL
	
	@  05, 075 SAY "RECONCILIACAO"      FONT oFont10	PIXEL
	@  20, 075 SAY "ATUAL: "      		PIXEL
	@  20, 100 SAY _datualRec          	PIXEL
	@  40, 075 SAY "NOVA: "      			PIXEL
	@  40, 095 MSGET _dDataRec    SIZE 40,8 OF oDlg1 	PIXEL
	
	@  05, 140 SAY "F I S C A L"      FONT oFont10	PIXEL
	@  20, 140 SAY "ATUAL: "      		PIXEL
	@  20, 165 SAY _dAtualFis          	PIXEL
	@  40, 140 SAY "NOVA: "      			PIXEL
	@  40, 160 MSGET _dDataFis    SIZE 40,8 OF oDlg1 	PIXEL
	
	@  05, 210 SAY "ATIVO FIXO"      FONT oFont10	PIXEL
	@  20, 210 SAY "ATUAL: "      		PIXEL
	@  20, 235 SAY _dAtualAtivo          	PIXEL
	@  40, 210 SAY "NOVA: "      			PIXEL
	@  40, 230 MSGET _dDataAtivo    SIZE 40,8 OF oDlg1 	PIXEL
	/*
	@  05, 280 SAY "ATIVO FIXO"      FONT oFont10	PIXEL
	@  20, 280 SAY "ATUAL: "      		PIXEL
	@  20, 305 SAY _dAtualAtivo          	PIXEL
	@  40, 280 SAY "NOVA: "      			PIXEL
	@  40, 300 MSGET _dDataAtivo    SIZE 40,8 OF oDlg1 	PIXEL
	*/
	@  70, 120 BUTTON "Ok"     SIZE 40,10 PIXEL ACTION ( OkFecha() )
	@  70, 170 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (oDlg1:End())
	ACTIVATE DIALOG oDlg1 CENTERED

ELSE
	MsgAlert("Para utilizar esta rotina você deve ter autorização do setor contábil.","MCTB001 - Atenção")
ENDIF
	
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKFecha  º Autor ³ LIBERDADE CONSULTORº Data ³  17/04/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkFecha()

IF !EMPTY(_dDataFin)
	DBSELECTAREA("SX6")
	DBSETORDER(1)
	DBSEEK("    MV_DATAFIN")
	IF FOUND()
			RECLOCK("SX6",.F.)
			SX6->X6_CONTEUD:=	DTOS(_dDataFin)
			MsUnlock()
	ELSE
		DBSELECTAREA("SM0")
		DBSETORDER(1)
		DBGOTOP()
		WHILE !EOF()
			DBSELECTAREA("SX6")
			DBSETORDER(1)
			DBSEEK(ALLTRIM(SM0->M0_CODFIL)+"MV_DATAFIN")
			IF FOUND()
				RECLOCK("SX6",.F.)
				SX6->X6_CONTEUD:=	DTOS(_dDataFin)
				MsUnlock()
			ENDIF
			DBSELECTAREA("SM0")
			DBSKIP()
		END
	ENDIF
ENDIF	
             

IF !EMPTY(_dDataRec)
	DBSELECTAREA("SX6")
	DBSETORDER(1)
	DBSEEK("    MV_DATAREC")
	IF FOUND()
			RECLOCK("SX6",.F.)
			SX6->X6_CONTEUD:=	DTOS(_dDataRec)
			MsUnlock()
	ELSE
		DBSELECTAREA("SM0")
		DBSETORDER(1)
		DBGOTOP()
		WHILE !EOF()
			DBSELECTAREA("SX6")
			DBSETORDER(1)
			DBSEEK(ALLTRIM(SM0->M0_CODFIL)+"MV_DATAREC")
			IF FOUND()
				RECLOCK("SX6",.F.)
				SX6->X6_CONTEUD:=	DTOS(_dDataRec)
				MsUnlock()
			ENDIF
			DBSELECTAREA("SM0")
			DBSKIP()
		END
	ENDIF
ENDIF	

IF !EMPTY(_dDataFis)
	DBSELECTAREA("SX6")
	DBSETORDER(1)
	DBSEEK("    MV_DATAFIS")
	IF FOUND()
			RECLOCK("SX6",.F.)
			SX6->X6_CONTEUD:=	DTOS(_dDataFis)
			MsUnlock()
	ELSE
		DBSELECTAREA("SM0")
		DBSETORDER(1)
		DBGOTOP()
		WHILE !EOF()
			DBSELECTAREA("SX6")
			DBSETORDER(1)
			DBSEEK(ALLTRIM(SM0->M0_CODFIL)+"MV_DATAFIS")
			IF FOUND()
				RECLOCK("SX6",.F.)
				SX6->X6_CONTEUD:=	DTOS(_dDataFis)
				MsUnlock()
			ENDIF
			DBSELECTAREA("SM0")
			DBSKIP()
		END
	ENDIF
ENDIF

IF !EMPTY(_dDataAtivo)
	DBSELECTAREA("SX6")
	DBSETORDER(1)
	DBSEEK("    MV_DBLQMOV")
	
	IF FOUND()
			RECLOCK("SX6",.F.)
			SX6->X6_CONTEUD:=	DTOS(_dDataAtivo)
			MsUnlock()
	ELSE
		DBSELECTAREA("SM0")
		DBSETORDER(1)
		DBGOTOP()
		WHILE !EOF()
			DBSELECTAREA("SX6")
			DBSETORDER(1)
			DBSEEK(ALLTRIM(SM0->M0_CODFIL)+"MV_DBLQMOV")
			IF FOUND()
				RECLOCK("SX6",.F.)
				SX6->X6_CONTEUD:=	DTOS(_dDataAtivo)
				MsUnlock()
			ENDIF
			DBSELECTAREA("SM0")
			DBSKIP()
		END
	ENDIF
ENDIF	
	

MSGINFO("Parametros alterados com sucesso!","MCTB001 - Informação")

oDlg1:End()

Return