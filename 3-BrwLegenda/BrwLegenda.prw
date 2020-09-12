#Include "Rwmake.ch"
#Include "Colors.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"  
#include "Totvs.ch"
	
//-------------------------------------------------------------------
/*/{Protheus.doc} zBrwLegenda.
Fun��o para cria��o da legenda
@Author   Davidson Carvalho
@Since 	   10/08/2020
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico nome da empresa/cliente.

A BrwLegenda() � uma funcionalidade que permite a inclus�o de legendas na MBrowse().
u_zBrwLegenda()

xxx......
/*/
//-------------------------------------------------------------------
User Function zBrwLegenda()

    Local cAlias := "SA2"
    Local aCores := {}
    Local cFiltra := ""

    cFiltra:="A2_FILIAL == '"+xFilial('SA2')+"' .And. A2_EST == 'SP'"
   
    Private cCadastro := "Cadastro de Fornecedores"
    Private aRotina := {}
    Private aIndexSA2 := {}
    Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSA2,@cFiltra) }

    AADD(aRotina,{"Pesquisar" ,"PesqBrw" ,0,1})
    AADD(aRotina,{"Visualizar" ,"AxVisual" ,0,2})
    AADD(aRotina,{"Incluir" ,"U_zBrwInclui" ,0,3})
    AADD(aRotina,{"Alterar" ,"U_zBrwAltera" ,0,4})
    AADD(aRotina,{"Excluir" ,"U_zBrwDeleta" ,0,5})
    AADD(aRotina,{"Legenda" ,"U_zBrLegenda" ,0,3})
    
    AADD(aCores,{"A2_TIPO == 'F'" ,"BR_VERDE" })
    AADD(aCores,{"A2_TIPO == 'J'" ,"BR_AMARELO" })
    AADD(aCores,{"A2_TIPO == 'X'" ,"BR_LARANJA" })
    AADD(aCores,{"A2_TIPO == 'R'" ,"BR_MARRON" })
    AADD(aCores,{"Empty(A2_TIPO)" ,"BR_PRETO" })

    dbSelectArea(cAlias)
    dbSetOrder(1)
    
    
    //Cria o filtro na MBrowse utilizando a fun��o FilBrowse
    Eval(bFiltraBrw)
    dbSelectArea(cAlias)
    dbGoTop()
    mBrowse(6,1,22,75,cAlias,,,,,,aCores)

    // Deleta o filtro utilizado na fun��o FilBrowse
    EndFilBrw(cAlias,aIndexSA2)
Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} zBrwInclui.
Rotina de inclus�o 
@Author   Davidson Carvalho
@Since 	   25/08/2020
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico nome da empresa/cliente.
xxx......
/*/
//--------------------------------------------------------------------
User Function zBrwInclui(cAlias,nReg,nOpc)
    
    Local nOpcao := 0
    
    nOpcao := AxInclui(cAlias,nReg,nOpc)
    
    If nOpcao == 1
        MsgInfo("Inclus�o efetuada com sucesso!")
    
    Else
        MsgInfo("Inclus�o cancelada!")
    
    Endif
Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} zBrwAltera.
Rotina de Altera��o 
@Author   Davidson Carvalho
@Since 	   25/08/2020
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico nome da empresa/cliente.
xxx......
/*/
//--------------------------------------------------------------------
User Function zBrwAltera(cAlias,nReg,nOpc)
    
    Local nOpcao := 0
    
    nOpcao := AxAltera(cAlias,nReg,nOpc)
    
    If nOpcao == 1
        MsgInfo("Altera��o efetuada com sucesso!")
    
    Else
        MsgInfo("Altera��o cancelada!")
    
    Endif
Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} zBrwDeleta.
Rotina de Exclus�o
@Author   Davidson Carvalho
@Since 	   25/08/2020
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico nome da empresa/cliente.
xxx......
/*/
//--------------------------------------------------------------------
User Function zBrwDeleta(cAlias,nReg,nOpc)
    
    Local nOpcao := 0
    
    nOpcao := AxDeleta(cAlias,nReg,nOpc)
    
    If nOpcao == 1    
        MsgInfo("Exclus�o efetuada com sucesso!")
    
    Else
        MsgInfo("Exclus�o Endif cancelada!")
    
    EndIf
Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} zBrLegenda.
Rotina de Legenda
@Author   Davidson Carvalho
@Since 	   25/08/2020
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico nome da empresa/cliente.
xxx......
/*/
//--------------------------------------------------------------------
User Function zBrLegenda()
    
    Local ALegenda :={}
    
    AADD(aLegenda,{"BR_VERDE" ,"Pessoa F�sica" })
    AADD(aLegenda,{"BR_AMARELO" ,"Pessoa Jur�dica" })
    AADD(aLegenda,{"BR_LARANJA" ,"Exporta��o" })
    AADD(aLegenda,{"BR_MARRON" ,"Fornecedor Rural" })
    AADD(aLegenda,{"BR_PRETO" ,"N�o Classificado" })
    BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil


//Resultado: em 25/08/2020 Davidson --> Teste com a rotina - 100% Funcionando.

