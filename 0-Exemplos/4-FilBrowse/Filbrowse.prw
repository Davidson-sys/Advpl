#Include "Rwmake.ch"
#Include "Colors.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"
#include "Totvs.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} zFilbrowse.
Cria o filtro na Mbrowse utilizando a função FilBrowse 
@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	A rotina cria um browse que já nasce filtrado.

u_zFilbrowse() 		//Chamar no executor.

xxx......
/*/
//--------------------------------------------------------------------
User Function zFilbrowse()

    Local cAlias    := "SA1"
    Local aCores    := {}
    Local cFiltra   := "A1_FILIAL == '"+xFilial('SA1')+"' .And. A1_EST == 'MG'"

    Private cCadastro   := "Cadastro de Clientes"

    // opções de filtro utilizando a FilBrowse
    Private aRotina     := {}
    Private aIndexSA1   := {}

    //Quando a função FilBrowse for utilizada a função de pesquisa deverá ser a PesqBrw ao invés da AxPesqui
    Private bFiltraBrw  := { || FilBrowse(cAlias,@aIndexSA1,@cFiltra,.T.) }

    AADD(aRotina,{"Pesquisar" ,"PesqBrw" ,0,1})
    AADD(aRotina,{"Visualizar" ,"AxVisual",0,2})
    AADD(aRotina,{"Incluir" ,"AxInclui",0,3})
    AADD(aRotina,{"Alterar" ,"AxAltera",0,4})
    AADD(aRotina,{"Excluir" ,"U_Exclui",0,5})

    // inclui as configurações da legenda
    AADD(aRotina,{"Legenda" ,"U_zBlengend" ,0,3})
    AADD(aCores,{"A1_TIPO == 'F'" ,"BR_VERDE" })
    AADD(aCores,{"A1_TIPO == 'L'" ,"BR_AMARELO" })
    AADD(aCores,{"A1_TIPO == 'R'" ,"BR_LARANJA" })
    AADD(aCores,{"A1_TIPO == 'S'" ,"BR_MARRON" })
    AADD(aCores,{"A1_TIPO == 'X'" ,"BR_AZUL" })

    // Cria o filtro na MBrowse utilizando a função FilBrowse
    dbSelectArea(cAlias)
    dbSetOrder(1)

    Eval(bFiltraBrw)

    dbSelectArea(cAlias)
    dbGoTop()

    // Deleta o filtro utilizado na função FilBrowse
    mBrowse(6,1,22,75,cAlias, , , , , , aCores)
    EndFilBrw(cAlias,aIndexSA1)
Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} Exclui.
Determinando a opção do aRotina pela informação recebida em nOpc
@Author   DNome Sobrenome
@Since 	   25/08/2020
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico nome da empresa/cliente.
xxx......
/*/
//--------------------------------------------------------------------
User Function Exclui(cAlias, nReg, nOpc)

    Local   nOpcao := 0
    nOpcao := AxDeleta(cAlias,nReg,nOpc)

    If nOpcao == 2 //Se confirmou a exclusão
        MsgInfo("Exclusão realizada com sucesso!")

    ElseIf nOpcao == 1
        MsgInfo("Exclusão cancelada!")

    Endif
Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} zBlengend.
Rotina de Legenda 
@Author   Nome Sobrenome
@Since 	   25/08/22020
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico nome da empresa/cliente.

u_zNomeUserFunction() 		//Chamar no executor.

xxx......
/*/
//--------------------------------------------------------------------    
User Function zBlengend()
    
    Local aLegenda := {}
    
    AADD(aLegenda,{"BR_VERDE" ,"Cons.Final" })
    AADD(aLegenda,{"BR_AMARELO" ,"Produtor Rural" })
    AADD(aLegenda,{"BR_LARANJA" ,"Revendedor" })
    AADD(aLegenda,{"BR_MARRON" ,"Solidario" })
    AADD(aLegenda,{"BR_AZUL" ,"Exportação" })
    
    BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil


//Resultado: em 25/08/2020 Davidson --> Teste com a rotina - 100% Funcionando.
