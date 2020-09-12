#Include "Rwmake.ch"
#Include "Colors.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"  
#include "Totvs.ch"	

//-------------------------------------------------------------------
/*/{Protheus.doc} zAxCadastro.
Rotina de axCadastro no Protheus 
@Author   Davidson Carvalho
@Since 	   25/08/2020.
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico 

u_zAxCadastro()

Modelo 1 ou AxCadastro: Para cadastramentos em tela cheia. Exemplo: Cadastro de Cliente.

AxCadastro() � uma funcionalidade de cadastro simples,com poucas op��es de customiza��o
  	   a qual � composta de 
		Browse-> Padr�o para visualiza��o da informa��es da base de dados de acordo com as configura��es da SX3.
		Fun��es de Pesquisa,Visualiza��o,Inclus�o,Altera��o e exclus�o.sem a op��o de cabe�alho e itens.
		
		cAlias->Alias padr�o do sistema para utiliza��o,o qual deve estar definido no dicionario de dados-SX3
		cTitulo->Titulo da Janela
		cVldExc->Valida��o para exclus�o
		cVldAlt->Valida��o para Altera��o.	
/*/
//-----------------------------------------------------------------------------------------------------------
User Function zAxCadastro()

    Local cAlias := "SA2"
    Local cTitulo := "Cadastro de Fornecedores"
    Local cVldExc := .T.
    Local cVldAlt := .T.


    dbSelectArea(cAlias)
    dbSetOrder(1)

    AxCadastro(cAlias,cTitulo,cVldExc,cVldAlt)
Return Nil



//-------------------------------------------------------------------
/*/{Protheus.doc} VldAltCad.
Descri��o do objetivo da Static Function
@Author   Davidson Carvalho
@Since 	   04/08/2020
@Version 	12.1.17
@param   	n/t
@return  	Retorno da Static Function
xxxxx
/*/
//-----------------------------------------------------------------------------------------------------------
User Function VldAltCad(cAlias,nReg,nOpc)

    Local lRet      := .T.
    Local aArea     := GetArea()
    Local nOpcao    := 0

    nOpcao := AxAltera(cAlias,nReg,nOpc)

    If nOpcao == 1
        MsgInfo("Altera��o conclu�da com sucesso!") 
    Endif

    RestArea(aArea)
Return lRet


//Resultado: em 25/08/2020 Davidson --> Teste com a rotina - 100% Funcionando.
