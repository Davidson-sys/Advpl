#Include "Rwmake.ch"
#Include "Colors.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"  
#include "Totvs.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MBrwSA1.
Teste rotina de mBrowse
@Author   Davidson Carvalho
@Since 	   25/08/2020
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico nome da empresa/cliente.

A Mbrowse() � uma funcionalidade de cadastro que permite a utiliza��o de recursos mais aprimorados na
visualiza��o e manipula��o das informa��es do sistema, possuindo os seguintes componentes:

Browse padr�o para visualiza��o das informa��es da base de dados, de acordo com as configura��es do SX3 �
Dicion�rio de Dados (campo browse).

Parametriza��o para fun��es espec�ficas para as a��es de visualiza��o, inclus�o, altera��o e exclus�o de
informa��es, o que viabiliza a manuten��o de informa��es com estrutura de cabe�alhos e itens.

A diferen�a entre AxCadastro e MBrowse, � que a segunda possui o Menudef permitindo assim 
mais funcionalidades � tela, como a cria��o de bot�es. Alem dos padr�es Pesquisar,Incluir,Alterar,Excluir

u_MBrwSA1()

xxx......
/*/
//-----------------------------------------------------------------------------------------------------------
User Function MBrwSA1()
    
    Local cAlias := "SA1"

    Private cCadastro   := "Cadastro de Clientes"
    Private aRotina     := {}

    AADD(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
    AADD(aRotina,{"Visualizar" ,"AxVisual",0,2})
    AADD(aRotina,{"Incluir" ,"U_Inclui",0,3})
    AADD(aRotina,{"Alterar" ,"AxAltera",0,4})
    AADD(aRotina,{"Excluir" ,"AxDeleta",0,5})

    dbSelectArea(cAlias)
    dbSetOrder(1)
    mBrowse( , , , ,cAlias)

Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} Inclui.
Descri��o do objetivo da Fun��o 
@Author   Davidson Carvalho
@Since 	   25/08/2020
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico nome da empresa/cliente.

xxx......
/*/
//-----------------------------------------------------------------------------------------------------------
User Function Inclui(cAlias, nReg, nOpc)
    
    Local cTudoOk := "( Alert('OK'),.T.)"
    Local nOpcao := 0
    
    Alert("entrou no incluir")
    
    nOpcao := AxInclui(cAlias,nReg,nOpc,,,,cTudoOk)
    
    If nOpcao == 1
        MsgInfo("Inclus�o conclu�da com sucesso!")
    
    ElseIf nOpcao == 2
        MsgInfo("Inclus�o cancelada!")
    
    Endif

Return Nil

/*
u_MBrwSA1()
Resultado: em 25/08/2020 Davidson
Teste com a rotina - 100% Funcionando.
*/

