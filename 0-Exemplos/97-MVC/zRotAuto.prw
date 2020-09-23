//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} zRotAuto
Exemplo de ExecAuto utilizando MVC (inclusão na Z02)
@type function
@author Atilio
@since 24/10/2016
@version 1.0
    @example
    u_zRotAuto()
/*/
User Function zRotAuto()
    
    Local aArea         := GetArea()
    Local aDados        := {}
    Private aRotina     := StaticCall(zModel1, MenuDef)
    Private oModel      := StaticCall(zModel1, ModelDef)
    Private lMsErroAuto := .F.

    //Adicionando os dados do ExecAuto
    aAdd(aDados, {"Z02_DESC", "ROT AUTO", Nil})

    //Chamando a inclusão - Modelo 1
    lMsErroAuto := .F.
    FWMVCRotAuto(    oModel,;                        //Model
    "Z02",;                         //Alias
    MODEL_OPERATION_INSERT,;        //Operacao
    {{"FORMZ02", aDados}})          //Dados

    //Se tiver mais de um Form, deve se passar dessa forma:
    // {{"ZZ2MASTER", aAutoCab}, {"ZZ3DETAIL", aAutoItens}})

    //Se houve erro no ExecAuto, mostra mensagem
    If lMsErroAuto
        MostraErro()

        //Senão, mostra uma mensagem de inclusão
    Else
        MsgInfo("Registro incluido!", "Atenção")
    EndIf

    RestArea(aArea)
Return
