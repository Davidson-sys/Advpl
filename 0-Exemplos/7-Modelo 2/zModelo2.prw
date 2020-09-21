#Include "Rwmake.ch"
#Include "Colors.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"  
#include "Totvs.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} zModelo2.
Exemplo de criação de uma roitna utilizando o modelo 2. 
@Author   Nome Sobrenome
@Since 	   99/99/999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico nome da empresa/cliente.

Trata-se de uma tela, onde seu objetivo é efetuar a manutenção em vários registros de uma só vez. 	
Por exemplo: efetuar o movimento interno de vários produtos do estoque em um único lote.

u_zModelo2() 		//Chamar no executor.

xxx......
/*/
//--------------------------------------------------------------------

User Function  zModelo2()
    
    Local cAlias := "SX5"
    
    Private cCadastro:= "Arquivo de Tabelas"
    Private aRotina := {}
    Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se //utilizar ExecBlock   
    
    AADD(aRotina,{"Pesquisar" ,"AxPesqui" ,0,1})
    AADD(aRotina,{"Visualizar" ,"U_SX52Vis" ,0,2})
    AADD(aRotina,{"Incluir" ,"U_SX52Inc" ,0,3})
    AADD(aRotina,{"Alterar" ,"U_SX52Alt" ,0,4})
    AADD(aRotina,{"Excluir" ,"U_SX52Exc" ,0,5})
    
    dbSelectArea(cAlias)
    dbSetOrder(1)
    mBrowse( 6,1,22,75,cAlias)
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} SX52INC.
Descrição do objetivo da Static Function
@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	Retorno da Static Function
xxxxx
/*/
//-----------------------------------------------------------------------------------------------------------
User  Function SX52INC(cAlias,nReg,nOpc)
    
    Local cTitulo   := "Inclusao de itens - Arquivo de Tabelas"
    Local aCab      := {} // Array com descricao dos campos do Cabecalho 
    Local aRoda     := {} // Array com descricao dos campos do Rodape
    Local aGrid     := {80,005,050,300} //Array com coordenadas da//GetDados no modelo2 - Padrao: {44,5,118,315} Linha Inicial–
    
    //Coluna Inicial - +Qts Linhas - +Qts Colunas : {080,005,050,300}
    Local cLinhaOk  := "AllwaysTrue()" // Validacoes na linha
    Local cTudoOk   := "AllwaysTrue()" // Validacao geral da GetDados
    Local lRetMod2  := .F. // Retorno da função Modelo2 - .T. Confirmo // .F. Cancelou
    Local nColuna   := 0
    Local nLinha    := 0

    // Variaveis para GetDados()
    Private aCols   := {}
    Private aHeader := {}

    // Variaveis para campos da Enchoice()
    Private cX5Filial := xFilial("SX5")
    Private cX5Tabela := SPACE(5)
        
    // Montagem do array de cabeçalho
    //AADD(aCab,{"Variável",{L,C}"Título","Picture","Valid","F3",lEnable})
    AADD(aCab,{"cX5Filial" ,{015,010} ,"Filial","@!",,,.F.})
    AADD(aCab,{"cX5Tabela" ,{015,080} ,"Tabela","@!",,,.T.})
    
    // Montagem do aHeader
    AADD(aHeader,{"Chave","X5_CHAVE","@!",5,0,"AllwaysTrue()",;
        "","C","","R"})
    AADD(aHeader,{"Descricao","X5_DESCRI","@!",40,0,"AllwaysTrue()",;
        "","C","","R"})
    
    // Montagem do aCols
    aCols := Array(1,Len(aHeader)+1)
    
    // Inicialização do aCols
    For nColuna := 1 to Len(aHeader)
        If aHeader[nColuna][8] == "C"
            aCols[1][nColuna] := SPACE(aHeader[nColuna][4])
        ElseIf aHeader[nColuna][8] == "N"
            aCols[1][nColuna] := 0
        ElseIf aHeader[nColuna][8] == "D"
            aCols[1][nColuna] := CTOD("")
        ElseIf aHeader[nColuna][8] == "L"
            aCols[1][nColuna] := .F.
        ElseIf aHeader[nColuna][8] == "M"
            aCols[1][nColuna] := ""
        Endif
    Next nColuna
    
    // Executa a função interna Modelo2.
    aCols[1][Len(aHeader)+1] := .F. // Linha não deletada
    lRetMod2 := Modelo2(cTitulo,aCab,aRoda,aGrid,nOpc,cLinhaOk,cTudoOk)
    
    If lRetMod2
        //MsgInfo("Você confirmou a operação","MBRW2SX5")
        For nLinha:= 1 To Len(acols)  // Ca m:p=o s1 dteo Claebne(çaaClohlos)
            Reclock("SX5",.T.)
            SX5->X5_FILIAL := cX5Filial
            SX5->X5_TABELA := cX5Tabela
            // Campos do aCols
            For nColuna := 1 to Len(aHeader)
                SX5->&(aHeader[nColuna][2]) := aCols[nLinha][nColuna]
            Next nColuna
            MsUnLock()
        Next nLinha
    Else
        MsgAlert("Você cancelou a operação","MBRW2SX5")
    EndIf
Return

//Resultado: em 31/08/2020 Davidson  ---> Teste com a rotina - 100% Funcionando.


