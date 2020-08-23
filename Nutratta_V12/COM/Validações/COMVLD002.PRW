#INCLUDE 'Protheus.ch'
#INCLUDE "TOTVS.CH"   
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBTREE.CH"

/*
========================================================================================================================
Rotina----: COMVLD002
Autor-----: Davidson Carvalho
Data------: 21/03/2018
========================================================================================================================
Descrição-: Validação da linha de produtos Nutratta
Uso-------: validação adicionada ao campo B1_LINPRD 
========================================================================================================================
*/

User Function COMVLD02()   
 
Local cGrupo	:=  M->B1_GRUPO    
Local cLinha	:=	M->B1_LINPRD
Local cDesc		:=	M->B1_LINDESC
Local lRet		:=	.T.
                                               
//--Validação do conteudo do campo B1_LINPRD       
If cGrupo $ '2000' .And. Empty(cLinha) 

	Aviso("Nutratta","Favor preencher o camo linha de produto para PA-Produto acabado.",{"Voltar"},2)
	lRet:=.F.
EndIf

Return(lRet)