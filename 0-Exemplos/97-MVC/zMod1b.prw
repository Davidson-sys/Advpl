//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Vari�veis Est�ticas
Static cTitulo  := "Artista"
Static cDefault := "NOME DO ARTISTA"

/*/{Protheus.doc} zMod1b
Exemplo de Modelo 1 para cadastro de Artistas com valida��es
@author Atilio
@since 03/09/2016
@version 1.0
    @return Nil, Fun��o n�o tem retorno
    @example
    u_zMod1b()
/*/

User Function zMod1b()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()

    SetFunName("zMod1b")

    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMBrowse():New()

    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("Z02")

    //Setando a descri��o da rotina
    oBrowse:SetDescription(cTitulo)

    //Ativa a Browse
    oBrowse:Activate()

    SetFunName(cFunBkp)
    RestArea(aArea)
Return Nil

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando op��es
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zMod1b' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1s
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zMod1b' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMod1b' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMod1b' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    //Blocos de c�digo nas valida��es
    Local bVldPre := {|| u_zM1bPre()} //Antes de abrir a Tela
    Local bVldPos := {|| u_zM1bPos()} //Valida��o ao clicar no Confirmar
    Local bVldCom := {|| u_zM1bCom()} //Fun��o chamadao ao cancelar
    Local bVldCan := {|| u_zM1bCan()} //Fun��o chamadao ao cancelar
     
    //Cria��o do objeto do modelo de dados
    Local oModel := Nil
     
    //Cria��o da estrutura de dados utilizada na interface
    Local oStZ02 := FWFormStruct(1, "Z02")
     
    //Editando caracter�sticas do dicion�rio
    oStZ02:SetProperty('Z02_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi��o
    oStZ02:SetProperty('Z02_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("Z02", "Z02_COD")'))         //Ini Padr�o
    oStZ02:SetProperty('Z02_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigat�rio
    oStZ02:SetProperty('Z02_DESC',  MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  "'"+cDefault+"'"))                              //Ini Padr�o
     
    //Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("zMod1bM", bVldPre, bVldPos, bVldCom, bVldCan) 
     
    //Atribuindo formul�rios para o modelo
    oModel:AddFields("FORMZ02",/*cOwner*/,oStZ02)
     
    //Setando a chave prim�ria da rotina
    oModel:SetPrimaryKey({'Z02_FILIAL','Z02_COD'})
     
    //Adicionando descri��o ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descri��o do formul�rio
    oModel:GetModel("FORMZ02"):SetDescription("Formul�rio do Cadastro "+cTitulo)
     
    //Pode ativar?
    oModel:SetVldActive( { | oModel | fAlterar( oModel ) } )
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o da vis�o MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local aStruZ02    := Z02->(DbStruct())
     
    //Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("zMod1b")
     
    //Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStZ02 := FWFormStruct(2, "Z02")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZ02_NOME|SZ02_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formul�rios para interface
    oView:AddField("VIEW_Z02", oStZ02, "FORMZ02")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando t�tulo do formul�rio
    oView:EnableTitleView('VIEW_Z02', 'Dados - '+cTitulo )  
     
    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})
     
    //O formul�rio da interface ser� colocado dentro do container
    oView:SetOwnerView("VIEW_Z02","TELA")
Return oView
 
/*/{Protheus.doc} zM1bPre
Fun��o chamada na cria��o do Modelo de Dados (pr�-valida��o)
@type function
@author Atilio
@since 03/09/2016
@version 1.0
/*/

User Function zM1bPre()
    Local oModelPad  := FWModelActive()
    Local nOpc       := oModelPad:GetOperation()
    Local lRet       := .T.

    //Se for inclus�o ou exclus�o
    If nOpc == MODEL_OPERATION_INSERT
        If RetCodUsr() == '000000'
            oModelPad:GetModel('FORMZ02'):GetStruct():SetProperty('Z02_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))
        EndIf
    EndIf
Return lRet

/*/{Protheus.doc} zM1bPos
Fun��o chamada no clique do bot�o Ok do Modelo de Dados (p�s-valida��o)
@type function
@author Atilio
@since 03/09/2016
@version 1.0
u_zM1bPos()
/*/

User Function zM1bPos()
    Local oModelPad  := FWModelActive()
    Local cDescri    := oModelPad:GetValue('FORMZ02', 'Z02_DESC')
    Local lRet       := .T.

    //Se a descri��o estiver em branco
    If Empty(cDescri) .Or. Alltrim(Upper(cDescri)) == cDefault
        lRet := .F.
        Aviso('Aten��o', 'Campo Descri��o esta em branco!', {'OK'}, 03)
    EndIf

Return lRet

/*/{Protheus.doc} zM1bCom
Fun��o chamada ap�s validar o ok da rotina para os dados serem salvos
@type function
@author Atilio
@since 03/09/2016
@version 1.0
/*/

User Function zM1bCom()
    Local oModelPad  := FWModelActive()
    Local cCodigo    := oModelPad:GetValue('FORMZ02', 'Z02_COD')
    Local cDescri    := oModelPad:GetValue('FORMZ02', 'Z02_DESC')
    Local nOpc       := oModelPad:GetOperation()
    Local lRet       := .T.

    //Se for Inclus�o
    If nOpc == MODEL_OPERATION_INSERT
        RecLock('Z02', .T.)
        Z02_FILIAL := FWxFilial('Z02')
        Z02_COD    := cCodigo
        Z02_DESC   := cDescri
        Z02->(MsUnlock())
        ConfirmSX8() //confirma a numera��o automatica.

        Aviso('Aten��o', 'Inclus�o realizada!', {'OK'}, 03)

        //Se for Altera��o
    ElseIf nOpc == MODEL_OPERATION_UPDATE
        RecLock('Z02', .F.)
        Z02_DESC := cDescri
        Z02->(MsUnlock())

        Aviso('Aten��o', 'Altera��o realizada!', {'OK'}, 03)

        //Se for Exclus�o
    ElseIf nOpc == MODEL_OPERATION_DELETE
        RecLock('Z02', .F.)
        DbDelete()
        Z02->(MsUnlock())

        Aviso('Aten��o', 'Exclus�o realizada!', {'OK'}, 03)
    EndIf
Return lRet

/*/{Protheus.doc} zM1bCan
Fun��o chamada ao cancelar as informa��es do Modelo de Dados (bot�o Cancelar)
@type function
@author Atilio
@since 03/09/2016
@version 1.0
/*/

User Function zM1bCan()
    Local oModelPad  := FWModelActive()
    Local lRet       := .T.

    //Somente permite cancelar se o usu�rio confirmar
    lRet := MsgYesNo("Deseja cancelar a opera��o?", "Aten��o")
Return lRet

/*---------------------------------------------------------------------*
 | Func:  fAlterar                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Define se pode abrir o Modelo de Dados                       |
 *---------------------------------------------------------------------*/
 
Static Function fAlterar( oModel )
    Local lRet       := .T.
    Local nOperation := oModel:GetOperation()
 
    //Se for exclus�o
    If nOperation == MODEL_OPERATION_DELETE
        //Se n�o for o Administrador
        If RetCodUsr() != '000000'
            lRet := .F.
            Aviso('Aten��o', 'Somente o Administrador pode excluir registros!', {'OK'}, 03)
        EndIf
    EndIf
 
Return lRet
