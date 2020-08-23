#Include "Totvs.ch"
#Include "Rwmake.ch"
#Include "Colors.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MT110END
Função da Solicitação de Compras responsavel pela aprovação das SCs
EM QUE PONTO : Após o acionamento dos botões Solicitação Aprovada, Rejeita ou Bloqueada,
deve ser utilizado para validações do usuario após a execução das ações dos botões. 

Campos criados SC1 - C1_N_OBS C 250  

@author 	Davidson
@since 		05/10/2017
@version 	P11 R5
@obs
xxx......
/*/
//-------------------------------------------------------------------

User Function MT110END()
   
Local nNumSC 	:= PARAMIXB[1] // Numero da Solicitação de compras 
Local nOp  		:= PARAMIXB[2] // 1 = Aprovar; 2 = Rejeitar; 3 = Bloquear 
Local cObs		:=""
Local cOBserv	:=""
   
private cMemo
   
If nOp == 2 .Or. nOp == 3 //Rejeição ou Bloqueio.
	
	dbSelectArea("SC1")
	dbSetOrder(1)
	If dbSeek(xFilial("SC1")+nNumSC+SC1->C1_ITEM)
	//	cObs := SC1->C1_N_OBS
		cObs := SC1->C1_C_OBS
	EndIf

	While !U_fMotReje(OemToAnsi("Justificativa de Rejeição/Bloqueio"))
		MsgBox(OemToAnsi("Favor informar motivo da Rejeição/Bloqueio!!!"),OemToAnsi("Alerta!!!"),OemToAnsi("STOP"))
	EndDo

	dbSelectArea("SC1")
	dbSetOrder(1)
	If DbSeek(xFilial("SC1")+nNumSC+SC1->C1_ITEM)
		If RecLock("SC1",.F.)

			Replace SC1->C1_C_OBS  With " Motivo: " +cMemo+" - "+"Usuario:"+cUserName
			Replace SC1->C1_DTAPROV  With Stod("") 
			MsUnlock()
		EndIf
	EndIf

ElseIf nOp == 1 //1-Aprovação

	dbSelectArea("SC1")
	dbSetOrder(1)
	If DbSeek(xFilial("SC1")+nNumSC+SC1->C1_ITEM)
		If RecLock("SC1",.F.)

			Replace SC1->C1_DTAPROV  With DDATABASE 
			MsUnlock()
		EndIf
	EndIf
	
EndIf

Return

/*
========================================================================================================================
Rotina----: fMotReje
Autor-----: Davidson Clayton
Data------: 05/10/2017
========================================================================================================================
Descrição-: Funcao registrar o motivo da reprovacao/Rejeição
Uso-------: 
========================================================================================================================
*/

User Function fMotReje(cTitulo)
	
Local lOk
Local oDlgMotivo
	
DEFINE MSDIALOG oDlgMotivo FROM 000,000 TO 250,400 PIXEL TITLE OemToAnsi(cTitulo)
TBitMap():New(000,000,320,390,"ProjetoAP",,.t.,oDlgMotivo,,,,,,,,,.t.)

tSay():New(005,005,{||"Motivo:"},oDlgMotivo,,,,,,.T.,CLR_BLACK,CLR_BLACK,200,350)

TMultiGet():New(015,005,{|u| if(PCount()>0,cMemo:=u,cMemo)},oDlgMotivo,193,092,,.T.,,,,.T.,OemToAnsi(cTitulo))

TButton():New(110,006/*110,005*/,"&Registrar",oDlgMotivo,{|| lOk:= .T., oDlgMotivo:End()},035,015,,,.T.,.T.,,OemToAnsi("Registrar motivo"))
//TButton():New(110,043,"&Cancelar",oDlgMotivo, {|| lOk:= .F., oDlgMotivo:End()},035,015,,,.T.,.T.,,OemToAnsi("Cancelar"))

Activate MsDialog oDlgMotivo Center

If lOk
	If Len(Alltrim(cMemo))<5
		lOk:= .F.
	EndIf
EndIf

Return(lOk) 


