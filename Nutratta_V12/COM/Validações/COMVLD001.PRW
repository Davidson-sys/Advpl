#INCLUDE 'Protheus.ch'
#INCLUDE "TOTVS.CH"   
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBTREE.CH"

/*
========================================================================================================================
Rotina----: COMVLD001
Autor-----: Davidson Carvalho
Data------: 24/01/2018
========================================================================================================================
Descrição-: Validação do codigo do produto.
Uso-------:
========================================================================================================================
*/

User Function COMVLD001()   
      
Local cGrupo	:=	M->B1_GRUPO
Local cFamilia	:=	M->B1_C_CDFAM
Local lRet		:=	.T.
            
//Aviso("Nutratta","Chave virada para o Banco: "+cCodBco+Chr(13)+Chr(10)+" Operação realizada com sucesso!!",{"OK"},2)

/*
Grupo 2000 esolher familia Bovinos,Ovinos..Equinos
outros grupos levar o grupo 00-Não PA*/
                                               
//--Validação do conteudo do campo B1_C_FAMIL        
dbSelectArea("SX5")
dbSetOrder(1)
If dbSeek(xFilial("SX5")+'1X'+cFamilia)

	//Não permitir prosseguir se o grupo for 2000 e familia 00-NAO PA - OUTRO.
	If cGrupo $ '2000' .And. '00' $ Alltrim(cFamilia)
		Aviso("Nutratta","Para produto acabado escolher a familia correta:",{"Voltar"},2)
		lRet:=.F.
	ElseIf cGrupo # '2000' .And. '00' # Alltrim(cFamilia)
		Aviso("Nutratta","Favor selecionar a familia 'NAO PA - OUTRO' para este grupo de produto.",{"Voltar"},2)
		lRet:=.F.
	EndIf
Else
	Aviso("Nutratta","Favor informar uma familia de produtos valida:",{"Voltar"},2)
	lRet:=.F.
EndIf

Return(lRet)