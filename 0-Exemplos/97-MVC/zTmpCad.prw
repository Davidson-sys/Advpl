//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Vari�veis Est�ticas
Static cTitulo := "Tempor�ria"

/*/{Protheus.doc} zTmpCad
Exemplo de Modelo 1 com tabela tempor�ria
@author Atilio
@since 22/04/2017
@version 1.0
    @return Nil, Fun��o n�o tem retorno
    @example
    u_zTmpCad()
Link
https://terminaldeinformacao.com/2017/07/10/vd-advpl-026/
/*/

User Function zTmpCad()
    
    Local aArea       := GetArea()
    Local oBrowse
    Local cFunBkp     := FunName()
    Local cArquivo    := "\teste"+GetDBExtension()
    Local cArqs       := ""
    Local aStrut      := {}
    Local aBrowse     := {}
    Local aSeek       := {}
    Local aIndex      := {}
    Private cAliasTmp := "CADTMP"

    //Pode se usar tamb�m a FWTemporaryTable

    //Criando a estrutura que ter� na tabela
    aAdd(aStrut, {"TMP_COD", "C", 06, 0} )
    aAdd(aStrut, {"TMP_DES", "C", 50, 0} )
    aAdd(aStrut, {"TMP_VAL", "N", 10, 2} )
    aAdd(aStrut, {"TMP_DAT", "D", 08, 0} )

    //Se o arquivo dbf / ctree existir, usa ele
    If Select(cAliasTmp) == 0
        If File(cArquivo)
            DbUseArea(.T., "DBFCDX", cArquivo, cAliasTmp, .T., .F.)

            //Sen�o, cria uma tempor�ria
        Else
            //Criando a tempor�ria
            cArqs := CriaTrab( aStrut, .T. )
            DbUseArea(.T., "DBFCDX", cArqs, cAliasTmp, .T., .F.)

            MsgInfo("Arquivo criado '"+cArqs+GetDBExtension()+"'", "Aten��o")
        EndIf
    EndIf

    //Definindo as colunas que ser�o usadas no browse
    aAdd(aBrowse, {"Codigo",    "TMP_COD", "C", 06, 0, "@!"})
    aAdd(aBrowse, {"Descricao", "TMP_DES", "C", 50, 0, "@!"})
    aAdd(aBrowse, {"Valor",     "TMP_VAL", "N", 10, 0, "@E 9,999,999.99"})
    aAdd(aBrowse, {"Data",      "TMP_DAT", "D", 08, 0, "@D"})

    SetFunName("zTmpCad")

    aAdd(aIndex, "TMP_COD" )

    //Criando o browse da tempor�ria
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cAliasTmp)
    oBrowse:SetQueryIndex(aIndex)
    oBrowse:SetTemporary(.T.)
    oBrowse:SetFields(aBrowse)
    oBrowse:DisableDetails()
    oBrowse:SetDescription(cTitulo)
    oBrowse:Activate()

    SetFunName(cFunBkp)
    RestArea(aArea)
Return Nil

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Desc:  Cria��o do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando op��es
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zTmpCad' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zTmpCad' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zTmpCad' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zTmpCad' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/ 
Static Function ModelDef()
    //Cria��o do objeto do modelo de dados
    Local oModel := Nil
     
    //Cria��o da estrutura de dados utilizada na interface
    Local oStTMP := FWFormModelStruct():New()
     
    oStTMP:AddTable(cAliasTmp, {'TMP_COD', 'TMP_DES', 'TMP_VAL', 'TMP_DAT'}, "Temporaria")
     
    //Adiciona os campos da estrutura
    oStTmp:AddField(;
        "Codigo",;                                                                                  // [01]  C   Titulo do campo
        "Codigo",;                                                                                  // [02]  C   ToolTip do campo
        "TMP_COD",;                                                                                 // [03]  C   Id do Field
        "C",;                                                                                       // [04]  C   Tipo do campo
        06,;                                                                                        // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de valida��o do campo
        Nil,;                                                                                       // [08]  B   Code-block de valida��o When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigat�rio
        FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+cAliasTmp+"->TMP_COD,'')" ),;                   // [11]  B   Code-block de inicializacao do campo
        .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma opera��o de update.
        .F.)                                                                                        // [14]  L   Indica se o campo � virtual
    oStTmp:AddField(;
        "Descricao",;                                                                               // [01]  C   Titulo do campo
        "Descricao",;                                                                               // [02]  C   ToolTip do campo
        "TMP_DES",;                                                                                 // [03]  C   Id do Field
        "C",;                                                                                       // [04]  C   Tipo do campo
        50,;                                                                                        // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de valida��o do campo
        Nil,;                                                                                       // [08]  B   Code-block de valida��o When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigat�rio
        FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+cAliasTmp+"->TMP_DES,'')" ),;                   // [11]  B   Code-block de inicializacao do campo
        .F.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma opera��o de update.
        .F.)                                                                                        // [14]  L   Indica se o campo � virtual
    oStTmp:AddField(;
        "Valor",;                                                                                   // [01]  C   Titulo do campo
        "Valor",;                                                                                   // [02]  C   ToolTip do campo
        "TMP_VAL",;                                                                                 // [03]  C   Id do Field
        "N",;                                                                                       // [04]  C   Tipo do campo
        10,;                                                                                        // [05]  N   Tamanho do campo
        02,;                                                                                        // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de valida��o do campo
        Nil,;                                                                                       // [08]  B   Code-block de valida��o When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .F.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigat�rio
        FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+cAliasTmp+"->TMP_VAL,'')" ),;                   // [11]  B   Code-block de inicializacao do campo
        .F.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma opera��o de update.
        .F.)                                                                                        // [14]  L   Indica se o campo � virtual
    oStTmp:AddField(;
        "Data",;                                                                                    // [01]  C   Titulo do campo
        "Data",;                                                                                    // [02]  C   ToolTip do campo
        "TMP_DAT",;                                                                                 // [03]  C   Id do Field
        "D",;                                                                                       // [04]  C   Tipo do campo
        08,;                                                                                        // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de valida��o do campo
        Nil,;                                                                                       // [08]  B   Code-block de valida��o When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .F.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigat�rio
        FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+cAliasTmp+"->TMP_DAT,'')" ),;         // [11]  B   Code-block de inicializacao do campo
        .F.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma opera��o de update.
        .F.)                                                                                        // [14]  L   Indica se o campo � virtual
     
    //Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("zTmpCadM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formul�rios para o modelo
    oModel:AddFields("FORMTMP",/*cOwner*/,oStTMP)
     
    //Setando a chave prim�ria da rotina
    oModel:SetPrimaryKey({'TMP_COD'})
     
    //Adicionando descri��o ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descri��o do formul�rio
    oModel:GetModel("FORMTMP"):SetDescription("Formul�rio do Cadastro "+cTitulo)
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Desc:  Cria��o da vis�o MVC                                         |
 *---------------------------------------------------------------------*/ 
Static Function ViewDef()
    Local aStruTMP    := (cAliasTmp)->(DbStruct())
    Local oModel := FWLoadModel("zTmpCad")
    Local oStTMP := FWFormViewStruct():New()
    Local oView := Nil
 
    //Adicionando campos da estrutura
    oStTmp:AddField(;
        "TMP_COD",;                 // [01]  C   Nome do Campo
        "01",;                      // [02]  C   Ordem
        "Codigo",;                  // [03]  C   Titulo do campo
        "Codigo",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        Iif(INCLUI, .T., .F.),;     // [10]  L   Indica se o campo � alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior op��o do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo � virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha ap�s o campo
    oStTmp:AddField(;
        "TMP_DES",;                 // [01]  C   Nome do Campo
        "02",;                      // [02]  C   Ordem
        "Descricao",;               // [03]  C   Titulo do campo
        "Descricao",;               // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo � alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior op��o do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo � virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha ap�s o campo
    oStTmp:AddField(;
        "TMP_VAL",;                 // [01]  C   Nome do Campo
        "03",;                      // [02]  C   Ordem
        "Valor",;                   // [03]  C   Titulo do campo
        "Valor",;                   // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "N",;                       // [06]  C   Tipo do campo
        "@E 9,999,999.99",;         // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo � alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior op��o do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo � virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha ap�s o campo
    oStTmp:AddField(;
        "TMP_DAT",;                 // [01]  C   Nome do Campo
        "04",;                      // [02]  C   Ordem
        "Data",;                    // [03]  C   Titulo do campo
        "Data",;                    // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "D",;                       // [06]  C   Tipo do campo
        "@D",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo � alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior op��o do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo � virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha ap�s o campo
     
    //Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formul�rios para interface
    oView:AddField("VIEW_TMP", oStTMP, "FORMTMP")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando t�tulo do formul�rio
    oView:EnableTitleView('VIEW_TMP', 'Dados - '+cTitulo )  
     
    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})
     
    //O formul�rio da interface ser� colocado dentro do container
    oView:SetOwnerView("VIEW_TMP","TELA")
Return oView
