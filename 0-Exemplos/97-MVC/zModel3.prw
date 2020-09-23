//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Variáveis Estáticas
Static cTitulo := "Composição de CDs"

/*/{Protheus.doc} zModel3
Função para cadastro de Composição de CDs (Exemplo de Modelo 3 - Z03 x Z04)
@author Atilio
@since 03/09/2016
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_zModel3()
/*/

User Function zModel3()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()

    SetFunName("zModel3")
    
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()

    //Setando a tabela de cadastro de CDs
    oBrowse:SetAlias("Z03")

    //Setando a descrição da rotina
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
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zModel3' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zModel3' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zModel3' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zModel3' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    Local oModel         := Nil
    Local oStPai         := FWFormStruct(1, 'Z03')
    Local oStFilho     := FWFormStruct(1, 'Z04')
    Local aZ04Rel        := {}
     
    //Definições dos campos
    oStPai:SetProperty('Z03_CODCD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
    oStPai:SetProperty('Z03_CODCD',    MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("Z03", "Z03_CODCD")'))       //Ini Padrão
    oStPai:SetProperty('Z03_CODART',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("Z02", M->Z03_CODART)'))      //Validação de Campo
    oStFilho:SetProperty('Z04_CODCD',  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
    oStFilho:SetProperty('Z04_CODCD',  MODEL_FIELD_OBRIGAT, .F. )                                                                          //Campo Obrigatório
    oStFilho:SetProperty('Z04_CODART', MODEL_FIELD_OBRIGAT, .F. )                                                                          //Campo Obrigatório
    oStFilho:SetProperty('Z04_CODMUS', MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'u_zIniMus()'))                         //Ini Padrão
     
    //Criando o modelo e os relacionamentos
    oModel := MPFormModel():New('zModel3M')
    oModel:AddFields('Z03MASTER',/*cOwner*/,oStPai)
    oModel:AddGrid('Z04DETAIL','Z03MASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
     
    //Fazendo o relacionamento entre o Pai e Filho
    aAdd(aZ04Rel, {'Z04_FILIAL','Z03_FILIAL'} )
    aAdd(aZ04Rel, {'Z04_CODCD',  'Z03_CODCD'})
    aAdd(aZ04Rel, {'Z04_CODART','Z03_CODART'}) 
     
    oModel:SetRelation('Z04DETAIL', aZ04Rel, Z04->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('Z04DETAIL'):SetUniqueLine({"Z04_DESC"})    //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
     
    //Setando as descrições
    oModel:SetDescription("Grupo de Produtos - Mod. 3")
    oModel:GetModel('Z03MASTER'):SetDescription('Cadastro')
    oModel:GetModel('Z04DETAIL'):SetDescription('CDs')
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local oView    := Nil
    Local oModel   := FWLoadModel( 'zModel3' )
    Local oStPai   := FWFormStruct(2, 'Z03' )
    Local oStFilho := FWFormStruct(2, 'Z04' )
     
    //Criando a View
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Adicionando os campos do cabeçalho e o grid dos filhos
    oView:AddField('VIEW_Z03',oStPai,'Z03MASTER')
    oView:AddGrid('VIEW_Z04',oStFilho,'Z04DETAIL')
     
    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC',30)
    oView:CreateHorizontalBox('GRID',70)
     
    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_Z03','CABEC')
    oView:SetOwnerView('VIEW_Z04','GRID')
     
    //Habilitando título
    oView:EnableTitleView('VIEW_Z03','Cabeçalho - Cadastro')
    oView:EnableTitleView('VIEW_Z04','Grid - CDs')
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //Remove os campos de Código do Artista e CD
    oStFilho:RemoveField('Z04_CODART')
    oStFilho:RemoveField('Z04_CODCD')
Return oView
 
/*/{Protheus.doc} zIniMus
Função que inicia o código sequencial da grid
@type function
@author Atilio
@since 03/09/2016
@version 1.0
/*/

User Function zIniMus()
    Local aArea      := GetArea()
    Local cCod       := StrTran(Space(TamSX3( 'Z04_CODMUS' )[1]), ' ' , '0' )
    Local oModelPad  := FWModelActive()
    Local oModelGrid := oModelPad:GetModel( 'Z04DETAIL' )
    
    //Local nOperacao  := oModelPad:nOperation
    Local nLinAtu    := oModelGrid:nLine
    Local nPosCod    := aScan(oModelGrid:aHeader, {|x| AllTrim(x[2]) == AllTrim("Z04_CODMUS")})

    //Se for a primeira linha
    If nLinAtu < 1
        cCod := Soma1(cCod)

        //Senão, pega o valor da última linha
    Else
        cCod := oModelGrid:aCols[nLinAtu][nPosCod]
        cCod := Soma1(cCod)
    EndIf

    RestArea(aArea)
Return cCod
