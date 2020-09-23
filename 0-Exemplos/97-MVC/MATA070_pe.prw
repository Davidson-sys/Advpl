//Bibliotecas
#Include "Protheus.ch"

/*---------------------------------------------------------------------------------------------------------------------------*
 | P.E.:  MATA070                                                                                                            |
 | Autor: Daniel Atilio                                                                                                      |
 | Data:  23/10/2016                                                                                                         |
 | Desc:  Ponto de entrada MVC no cadastro de Bancos                                                                         |
 | Obs.:  Ao criar um P.E. em MVC com o mesmo nome do ModelDef, deixe o nome do prw com outro nome, por exemplo,             |
 |        MATAXXX_pe.prw                                                                                                     |
 | Ref.:  http://tdn.totvs.com/display/public/mp/Pontos+de+Entrada+para+fontes+Advpl+desenvolvidos+utilizando+o+conceito+MVC |
 *---------------------------------------------------------------------------------------------------------------------------*/
 
 
User Function MATA070()
    
    Local aParam     := PARAMIXB
    Local xRet       := .T.
    Local oObj       := Nil
    Local cIdPonto   := ''
    Local cIdModel   := ''
    Local nOper      := 0
    Local cCampo     := ''
    Local cTipo      := ''
 
    //Se tiver par�metros
    If aParam <> NIL
        ConOut("> "+aParam[2])
         
        //Pega informa��es dos par�metros
        oObj     := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
         
        //Valida a abertura da tela
        If cIdPonto == "MODELVLDACTIVE"
            nOper := oObj:nOperation
             
            //Se for Exclus�o, n�o permite abrir a tela
            If nOper == 5
                xRet := .F.
            EndIf
         
        //Pr� configura��es do Modelo de Dados
        ElseIf cIdPonto == "MODELPRE"
            xRet := .T.
         
        //Pr� configura��es do Formul�rio de Dados
        ElseIf cIdPonto == "FORMPRE"
            nOper  := oObj:GetModel(cIdPonto):nOperation
            cTipo  := aParam[4]
            cCampo := aParam[5]
             
            //Se for Altera��o
            If nOper == 4
                //N�o permite altera��o dos campos chave
                If cTipo == "CANSETVALUE" .And. Alltrim(cCampo) $ ("A6_COD.A6_AGENCIA.A6_NUMCON")
                   xRet := .F.
                EndIf
            EndIf
  
         
        //Adi��o de op��es no A��es Relacionadas dentro da tela
        ElseIf cIdPonto == 'BUTTONBAR'
            xRet := {}
            aAdd(xRet, {"* Titulo 1", "", {|| Alert("Bot�o 1")}, "Tooltip 1"})
            aAdd(xRet, {"* Titulo 2", "", {|| Alert("Bot�o 2")}, "Tooltip 2"})
            aAdd(xRet, {"* Titulo 3", "", {|| Alert("Bot�o 3")}, "Tooltip 3"})
         
        //P�s configura��es do Formul�rio
        ElseIf cIdPonto == 'FORMPOS'
            xRet := .T.
         
        //Valida��o ao clicar no Bot�o Confirmar
        ElseIf cIdPonto == 'MODELPOS'
            //Se o campo de contato estiver em branco, n�o permite prosseguir
            If Empty(M->A6_CONTATO)
                Aviso('Aten��o', 'Por favor, informe um Contato!', {'OK'}, 03)
                xRet := .F.
            EndIf
                  
        //Pr� valida��es do Commit
        ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
         
        //P�s valida��es do Commit
        ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
             
        //Commit das opera��es (antes da grava��o)
        ElseIf cIdPonto == 'MODELCOMMITTTS'
             
        //Commit das opera��es (ap�s a grava��o)
        ElseIf cIdPonto == 'MODELCOMMITNTTS'
            nOper := oObj:nOperation
             
            //Se for inclus�o, mostra mensagem de sucesso
            If nOper == 3
                Aviso('Aten��o', 'Banco criado com sucesso!', {'OK'}, 03)
            EndIf
        EndIf
    EndIf
Return xRet
