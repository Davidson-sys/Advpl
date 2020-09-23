//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Vari�veis Est�ticas
Static cTitulo := "Composi��o de CDs"

/*/{Protheus.doc} zModel3
Fun��o para cadastro de Composi��o de CDs (Exemplo de Modelo 3 - Z03 x Z04)
@author Atilio
@since 03/09/2016
@version 1.0
    @return Nil, Fun��o n�o tem retorno
    @example
    u_zModel3()
/*/

User Function zModel3()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()

    SetFunName("zModel3")
    
    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMBrowse():New()

    //Setando a tabela de cadastro de CDs
    oBrowse:SetAlias("Z03")

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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zModel3' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zModel3' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zModel3' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zModel3' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    Local oModel         := Nil
    Local oStPai         := FWFormStruct(1, 'Z03')
    Local oStFilho     := FWFormStruct(1, 'Z04')
    Local aZ04Rel        := {}
     
    //Defini��es dos campos
    oStPai:SetProperty('Z03_CODCD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi��o
    oStPai:SetProperty('Z03_CODCD',    MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("Z03", "Z03_CODCD")'))       //Ini Padr�o
    oStPai:SetProperty('Z03_CODART',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("Z02", M->Z03_CODART)'))      //Valida��o de Campo
    oStFilho:SetProperty('Z04_CODCD',  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi��o
    oStFilho:SetProperty('Z04_CODCD',  MODEL_FIELD_OBRIGAT, .F. )                                                                          //Campo Obrigat�rio
    oStFilho:SetProperty('Z04_CODART', MODEL_FIELD_OBRIGAT, .F. )                                                                          //Campo Obrigat�rio
    oStFilho:SetProperty('Z04_CODMUS', MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'u_zIniMus()'))                         //Ini Padr�o
     
    //Criando o modelo e os relacionamentos
    oModel := MPFormModel():New('zModel3M')
    oModel:AddFields('Z03MASTER',/*cOwner*/,oStPai)
    oModel:AddGrid('Z04DETAIL','Z03MASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence
     
    //Fazendo o relacionamento entre o Pai e Filho
    aAdd(aZ04Rel, {'Z04_FILIAL','Z03_FILIAL'} )
    aAdd(aZ04Rel, {'Z04_CODCD',  'Z03_CODCD'})
    aAdd(aZ04Rel, {'Z04_CODART','Z03_CODART'}) 
     
    oModel:SetRelation('Z04DETAIL', aZ04Rel, Z04->(IndexKey(1))) //IndexKey -> quero a ordena��o e depois filtrado
    oModel:GetModel('Z04DETAIL'):SetUniqueLine({"Z04_DESC"})    //N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
     
    //Setando as descri��es
    oModel:SetDescription("Grupo de Produtos - Mod. 3")
    oModel:GetModel('Z03MASTER'):SetDescription('Cadastro')
    oModel:GetModel('Z04DETAIL'):SetDescription('CDs')
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o da vis�o MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local oView    := Nil
    Local oModel   := FWLoadModel( 'zModel3' )
    Local oStPai   := FWFormStruct(2, 'Z03' )
    Local oStFilho := FWFormStruct(2, 'Z04' )
     
    //Criando a View
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Adicionando os campos do cabe�alho e o grid dos filhos
    oView:AddField('VIEW_Z03',oStPai,'Z03MASTER')
    oView:AddGrid('VIEW_Z04',oStFilho,'Z04DETAIL')
     
    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC',30)
    oView:CreateHorizontalBox('GRID',70)
     
    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_Z03','CABEC')
    oView:SetOwnerView('VIEW_Z04','GRID')
     
    //Habilitando t�tulo
    oView:EnableTitleView('VIEW_Z03','Cabe�alho - Cadastro')
    oView:EnableTitleView('VIEW_Z04','Grid - CDs')
     
    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})
     
    //Remove os campos de C�digo do Artista e CD
    oStFilho:RemoveField('Z04_CODART')
    oStFilho:RemoveField('Z04_CODCD')
Return oView
 
/*/{Protheus.doc} zIniMus
Fun��o que inicia o c�digo sequencial da grid
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

        //Sen�o, pega o valor da �ltima linha
    Else
        cCod := oModelGrid:aCols[nLinAtu][nPosCod]
        cCod := Soma1(cCod)
    EndIf

    RestArea(aArea)
Return cCod
