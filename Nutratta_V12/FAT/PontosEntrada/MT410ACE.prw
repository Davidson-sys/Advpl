#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "topconn.ch"      
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"


//--------------------------------------------------------------------------
/* {Protheus.doc} MT410ACE
Ponto de entrada criado para verificar o acesso dos usuários nas rotinas: 
Excluir, Visualizar, Resíduo, Copiar e Alterar.

Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 21/10/2016
@version P11 R8
*/
//--------------------------------------------------------------------------

User Function MT410ACE()


//--Variaveis Private
Private cNumens	:=""
Private nOpc		:= PARAMIXB [1] 
Private lRet		:= .T.

//--Visualizar ou Residuo.
If nOpc == 2
	
	//Se for residuo
	If "RESIDUO" $ CCADASTRO
		
		//-Chama a função para realizar a verificação.
		//----------->Se achar pedido retornar .F. senao retorna .T.
		Processa( {|| lRet:=fProcessa()}, "Aguarde...", "Verificando remessas para o contrato...",.F.)
		
		//--Exibe a mensagem caso tenha encontrato pedidos a serem eliminados para o contrato
		If !lRet
			
			Aviso("Nutratta","Existe remessa em aberto para este pedido mãe !!!!"+Chr(13)+Chr(10)+;
			"Favor eliminar residuo do(s) pedido(s):  "+Chr(13)+Chr(10)+cNumens,{"Voltar"},2)
		EndIf
	EndIf
EndIf

Return(lRet)


//--------------------------------------------------------------------------
/* {Protheus.doc} fProcessa
Função para verificar se existe PV para eliminação de residuo.

Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 21/10/2016
@version P11 R8
*/
//--------------------------------------------------------------------------
Static Function fProcessa()

Local aAreaSC5	:= GetArea("SC5")
Local cNum			:= SC5->C5_NUM
Local cFilz		:= xFilial("SC5")
Local cTEs			:=""
Local cTesMae		:="503" //TES de faturamento para Matriz e Orizona 503.
Local cContrat	:=""
Local cNumAnt		:= ""
Local lContinua	:=.F.
Local lRet			:= .T. //Se achar pedido retornar .F. senao retorna .T.	


//-Posiciona na SC6 para pegar o numero do contrato.
dbSelectArea("SC6")
SC6->(dbSetOrder(1))
If SC6->(dbSeek(xFilial("SC5")+cNum))
	
	cTEs		:=SC6->C6_TES
	cContrat	:=SC6->C6_CONTRAT
EndIf

//--Verifica se o campo contrato esta preenchido.
If ! Empty (cContrat)
	
	//--So entra na validação se for pv mae,verifica a TES.
	If cTEs == cTesMae
		
		lContinua	:=.T.
	Else
		
		lContinua	:=.F.
	EndIf
EndIf



//--Caso a TES seja igual prosseguir....
If lContinua

	ProcRegua(Reccount())
	
	dbSelectArea("SC6")
	SC6->(dbGotop())
	While SC6->(!Eof())	
	
		IncProc("Verificando remessas para o contrato...")		
	
		//--Verifica se é o mesmo contrato e Pedido de remessa.
		If SC6->C6_FILIAL == cFilz .And. SC6->C6_CONTRAT == cContrat
			
			If "503" != Alltrim(SC6->C6_TES)
				
				//--Verifica se o Pedido de remessa .
				dbSelectArea("SC5")
				SC5->(dbSetOrder(1))
				If SC5->(dbSeek(xFilial("SC6")+SC6->C6_NUM))
					
					If Empty(SC5->C5_NOTA) // Não foi fautrado e não teve residuo eliminado XXXXXX
						
						If cNumAnt != SC6->C6_NUM
							
							cNumens+=SC6->C6_NUM+Chr(13)+Chr(10)
						EndIf
						cNumAnt:=SC6->C6_NUM
						lRet := .F.
					EndIf
					
					//--Reposiciona do pedido original.
					dbSelectArea("SC5")
					SC5->(dbSetOrder(1))
					SC5->(dbSeek(xFilial("SC6")+cNum))
				EndIf
			EndIf
		EndIf
		SC6->(dbSkip())
	EndDo
EndIf

RestArea(aAreaSC5)
Return(lRet)

