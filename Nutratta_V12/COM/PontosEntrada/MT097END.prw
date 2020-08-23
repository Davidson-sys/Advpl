#include "rwmake.ch"
#include "protheus.ch"
//-------------------------------------------------------------------
/*/{Protheus.doc} MT097END
O ponto se encontra no fim das funções A097LIBERA, A097SUPERI e A097TRANSF
Especifico para gravar as informações do aprovador e data de liberação.
@author 	Davidson
@since 		12/07/2017.
@version 	P11 R5
@param   	n/t
@return  	Nil (Nulo)
@obs
xxx......
/*/
//-------------------------------------------------------------------
User Function MT097END()

Local cDocto    := PARAMIXB[1] 
Local cTipoDoc 	:= PARAMIXB[2] 
Local nOpcao    := PARAMIXB[3] 
Local cFilDoc   := PARAMIXB[4]  
Local aSavSC7   := SC7->(GetArea()) 

//Aprovacao
If nOpcao ==2 
	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))           
	If SC7->(dbSeek(cFilDoc+Padr(cDocto,6))) 
		While !Eof() .And. (SC7->C7_FILIAL+SC7->C7_NUM) == (cFilDoc+Padr(cDocto,6))
	                      	
			dDtAprov	:=fDadosAprov(1)
			cUserAprov	:=fDadosAprov(2)
			
			RecLock("SC7",.F.)     
			Replace SC7->C7_DTAPROV With  dDtAprov//Data da aprovação ultima data de aprovação.
			Replace SC7->C7_ZAPROV  With  Alltrim(cUserAprov) //Ultimo aprovador 
			Replace SC7->C7_DESCPG  With  Posicione("SX5",1,xFilial("SX5")+"ZF"+SC7->C7_N_FORPG,"X5_DESCRI")		
			MsUnlock() 
		SC7->(dbSkip())
		EndDo
	EndIf
EndIf	

RestArea(aSavSC7)

Return 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lista de Aprovadores e data de liberação  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Static Function fDadosAprov(nOPc)

Local dDtaLib	:=StoD("")
Local dtLibAnt	:=StoD("")
Local cAprov	:=""

dbSelectArea("SC7")
If !Empty(C7_APROV)   
	cComprador := UsrFullName(SC7->C7_USER)
	If C7_CONAPRO != "B"
		lLiber := .T.
	EndIf
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM)
	While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM)==xFilial("SCR")+Alltrim(SC7->C7_NUM) .And. SCR->CR_TIPO == "PC"
        
		//Maior data de aprovação
		If nOPc == 1
			If !Empty(SCR->CR_DATALIB) .And. !Empty(CR_LIBAPRO)
				
				dDtaLib	:= SCR->CR_DATALIB
				cAprov  := AllTrim(UsrFullName(SCR->CR_USER))
				
				If dtLibAnt > dDtaLib  
		
					dDtaLib := dtLibAnt
				EndIf				
	   		EndIf 
		       
			dtLibAnt:=dDtaLib
		
		//Ultimo usuario aprovador
		ElseIf nOPc == 2     

			If !Empty(SCR->CR_DATALIB) .And. !Empty(CR_LIBAPRO)
				
				dDtaLib	:= SCR->CR_DATALIB
				cAprov  := AllTrim(UsrFullName(SCR->CR_USER))
				
				If dtLibAnt > dDtaLib 
		
					dDtaLib := dtLibAnt
				EndIf				
	   		EndIf 
		EndIf
				
		dbSelectArea("SCR")
		dbSkip()
	Enddo
EndIf

//Maior data de liberação      
If nOPc == 1
	Return(dDtaLib)      
//Ultimo aprovador.	
ElseIf nOPc == 2
	Return(cAprov)
EndIf     

  