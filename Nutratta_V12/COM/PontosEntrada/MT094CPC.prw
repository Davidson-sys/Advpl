#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
//--------------------------------------------------------------------------
/* {Protheus.doc} MT094CPC
A chamada do Ponto de Entrada MT094CPC ocorre ao acionar o botão "Aprovar"
na rotina Liberação de Documentos (MATA094).
Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Carvalho
@since 27/06/2018
@version P11 R8

*/
//--------------------------------------------------------------------------

User Function MT094CPC()

Local _cCampos 	:=""
Local _cDescCC	:=""                                         
Local _cDescCta	:=""
Local _cCentCust:="" 
Local _cContCt1	:="" 
Local _cNumPed	:=Alltrim(SCR->CR_NUM)
Local _nCont	:=0


//For _nCont :=1 To Len(aCols)

	_cDescCC	:=""                                         
	_cDescCta	:=""
	_cCentCust	:="" 
	_cContCt1	:="" 	

	//Localiza o centro de custo e preenche a descriçao
	dbSelectArea("SC7")
	dbSetOrder(1)
	If	dbSeek(xFilial("SC7")+_cNumPed)
		
		_cCentCust	:= SC7->C7_CC
		_cContCt1	:= SC7->C7_CONTA
		
		//Localiza o centro de custo e preenche a descriçao
		dbSelectArea("CTT")
		dbSetOrder(1)
		If	dbSeek(xFilial("CTT")+_cCentCust)
			
			_cDescCC	:= CTT->CTT_DESC01
			
			//Localiza a conta contabil e pega a descrição.
			dbSelectArea("CT1")
			dbSetOrder(1)
			If	dbSeek(xFilial("CT1")+_cContCt1)
				
				_cDescCta	:= CT1->CT1_DESC01
				
				//Grava as descrições na SC7.
				dbSelectArea("SC7")
				RecLock("SC7",.F.)
				Replace C7_ZDESCTT	With _cDescCC
				Replace C7_ZDESCTA	With _cDescCta
				
				MsUnlock()
				_cCampos:="|C7_CC|C7_ZDESCTT|C7_ZDESCTA|C7_CONTA" //  O retorno deve começar com uma barra vertical ( | ) e ir intercalando o nomes do campos com barras verticais.
			EndIf
		EndIf
	EndIf
//Next _nCont  

Return (_cCampos)
