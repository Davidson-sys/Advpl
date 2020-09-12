#Include "Rwmake.ch"
#Include "Colors.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"  
#include "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} zExecutor.
Executar rotinas como se fosse o cadastro de formulas.
@Author   Davidson Carvalho
@Since 	  25/08/2020
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Assim como o formulas foi bloqueado na versão 12, o executor ira substituir seu papel.
/*/
//-----------------------------------------------------------------------------------------------------------

User Function zExecutor()

    Local aArea := GetArea()

    //Variaveis de tela
    Private oDlgForm
    Private oGrpForm
    Private oGetForm
    Private cGetForm := "Exemplo: u_zNomeUserFunction()  -->> Limpar"//Space(250)
    Private oGrpAco
    Private oBtnExec

    //Tamanho da Janela
    Private nJanLarg := 500
    Private nJanAltu := 120
    Private nJanMeio := ((nJanLarg)/2)/2
    Private nTamBtn  := 048

    //Criando a janela
    DEFINE MSDIALOG oDlgForm TITLE "Executor - Execução de Formulas" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
    //Grupo Formula com o Get
    @ 003, 003  GROUP oGrpForm TO 30, (nJanLarg/2)-1        PROMPT "Formula: " OF oDlgForm COLOR 0, 16777215 PIXEL
    @ 010, 006  MSGET oGetForm VAR cGetForm SIZE (nJanLarg/2)-9, 013 OF oDlgForm COLORS 0, 16777215 PIXEL

    //Grupo acões com o botão
    @ (nJanAltu/2)-30, 003 GROUP oGrpAco TO (nJanAltu/2)-3, (nJanLarg/2)-1 PROMPT "Ações: " OF oDlgForm COLOR 0, 16777215 PIXEL
    @ (nJanAltu/2)-24, nJanMeio - (nTamBtn/2) BUTTON oBtnExec PROMPT "Executar" SIZE nTamBtn, 018 OF oDlgForm ACTION(fExecuta()) PIXEL

    //Ativando a janela
    ACTIVATE MSDIALOG oDlgForm CENTERED

    RestArea(aArea)
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} fExecuta.
Executa a formula digitada
@Author   Davidson Carvalho
@Since 	   25/08/2020
@Version 	12.1.25
@param   	n/t
@return  	Retorno da Static Function
xxxxx
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function fExecuta()

    Local aArea    := GetArea()
    Local cFormula := Alltrim(cGetForm)   
    Local cError   := ""
    Local bError   := ErrorBlock({ |oError| cError := oError:Description})

    //Se tiver conteudo digitado
    If ! Empty(cFormula)

        //Inicio a utilização da tentativa
        Begin Sequence
            &(cFormula)
        End Sequence

        //Restaurando bloco de erro do sistema
        ErrorBlock(bError)

        //Se houve erro, sera mostrado ao usuario
        If ! Empty(cError)
            MsgStop("Houve um erro na formula digitada: "+CRLF+CRLF+cError, "Atenção")
        EndIf
    EndIf

    RestArea(aArea)  
Return

//Resultado: em 25/08/2020 Davidson --> Teste com a rotina - 100% Funcionando.

