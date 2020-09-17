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

A Mbrowse() é uma funcionalidade de cadastro que permite a utilização de recursos mais aprimorados na
visualização e manipulação das informações do sistema, possuindo os seguintes componentes:

Browse padrão para visualização das informações da base de dados, de acordo com as configurações do SX3 –
Dicionário de Dados (campo browse).

Parametrização para funções específicas para as ações de visualização, inclusão, alteração e exclusão de
informações, o que viabiliza a manutenção de informações com estrutura de cabeçalhos e itens.

A diferença entre AxCadastro e MBrowse, é que a segunda possui o Menudef permitindo assim 
mais funcionalidades à tela, como a criação de botões. Alem dos padrões Pesquisar,Incluir,Alterar,Excluir

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
Descrição do objetivo da Função 
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
        MsgInfo("Inclusão concluída com sucesso!")
    
    ElseIf nOpcao == 2
        MsgInfo("Inclusão cancelada!")
    
    Endif

Return Nil

/*
u_MBrwSA1()
Resultado: em 25/08/2020 Davidson
Teste com a rotina - 100% Funcionando.
*/

