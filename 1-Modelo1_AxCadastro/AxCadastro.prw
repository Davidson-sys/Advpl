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

AxCadastro() é uma funcionalidade de cadastro simples,com poucas opções de customização
  	   a qual é composta de 
		Browse-> Padrão para visualização da informações da base de dados de acordo com as configurações da SX3.
		Funções de Pesquisa,Visualização,Inclusão,Alteração e exclusão.sem a opção de cabeçalho e itens.
		
		cAlias->Alias padrão do sistema para utilização,o qual deve estar definido no dicionario de dados-SX3
		cTitulo->Titulo da Janela
		cVldExc->Validação para exclusão
		cVldAlt->Validação para Alteração.	
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
Descrição do objetivo da Static Function
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
        MsgInfo("Alteração concluída com sucesso!") 
    Endif

    RestArea(aArea)
Return lRet


//Resultado: em 25/08/2020 Davidson --> Teste com a rotina - 100% Funcionando.
