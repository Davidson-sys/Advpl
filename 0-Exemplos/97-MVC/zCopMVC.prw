//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Vari�veis Est�ticas
Static cTitulo  := "Composi��o de CDs"

/*/{Protheus.doc} zCopMVC
Fun��o para c�pia do cadastro de Composi��o de CDs (Exemplo de Modelo 3 - Z03 x Z04)
@author Atilio
@since 29/04/2017
@version 1.0
    @return Nil, Fun��o n�o tem retorno
    @example
    u_zCopMVC()
Link:
https://terminaldeinformacao.com/2017/07/17/advpl-027/
/*/

User Function zCopMVC()
    
    Local  aArea     := GetArea()
    Local  oBrowse
    Local  cFunBkp   := FunName()
    Private __lCopia := .F.

    SetFunName("zCopMVC")

    //Inst�nciando FWMBrowse
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("Z03")
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
     
    //Adicionando op��es - est�o no zCopMVC.prw
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zCopMVC' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zCopMVC' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zCopMVC' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zCopMVC' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
    //Rotina de Copiar
    ADD OPTION aRot TITLE 'Copiar'     ACTION 'u_zCopyZ03'      OPERATION 9                      ACCESS 0
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()

    Local oModel     := Nil
    Local oStPai     := FWFormStruct(1, 'Z03')
    Local oStFilho     := FWFormStruct(1, 'Z04')
    Local aZ04Rel    := {}
     
    //Defini��es dos campos
    oStPai:SetProperty('Z03_CODCD',    MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("Z03", "Z03_CODCD")'))       //Ini Padr�o
    oStPai:SetProperty('Z03_CODART',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("Z02", M->Z03_CODART)'))      //Valida��o de Campo
    oStFilho:SetProperty('Z04_CODCD',  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi��o
    oStFilho:SetProperty('Z04_CODCD',  MODEL_FIELD_OBRIGAT, .F. )                                                                          //Campo Obrigat�rio
    oStFilho:SetProperty('Z04_CODART', MODEL_FIELD_OBRIGAT, .F. )                                                                          //Campo Obrigat�rio
     
    //Criando o modelo e os relacionamentos
    oModel := MPFormModel():New('zCopMVCM')
    oModel:AddFields('Z03MASTER',/*cOwner*/,oStPai)
    oModel:AddGrid('Z04DETAIL','Z03MASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence
     
    //Fazendo o relacionamento entre o Pai e Filho
    aAdd(aZ04Rel, {'Z04_FILIAL','Z03_FILIAL'} )
    aAdd(aZ04Rel, {'Z04_CODCD',    'Z03_CODCD'})
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
 | Desc:  Cria��o da vis�o MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    
    Local oView    := Nil
    Local oModel   := FWLoadModel( 'zCopMVC' )
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
     
    //Define campo com auto incremento
    oView:AddIncrementField('VIEW_Z04', 'Z04_CODMUS')
     
    //Habilitando t�tulo
    oView:EnableTitleView('VIEW_Z03','Cabe�alho - Cadastro')
    oView:EnableTitleView('VIEW_Z04','Grid - CDs')
     
    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})
     
    //Remove os campos de C�digo do Artista e CD
    oStFilho:RemoveField('Z04_CODART')
    oStFilho:RemoveField('Z04_CODCD')
Return oView
 
/*/{Protheus.doc} zCopyZ03
Fun��o para c�pia dos dados em MVC
@type function
@author Atilio
@since 29/04/2017
@version 1.0
/*/

User Function zCopyZ03()
    
    Local aArea        := GetArea()
    Local cTitulo      := "C�pia"
    Local cPrograma    := "zCopMVC"
    Local nOperation   := MODEL_OPERATION_INSERT
    Local nLin         := 0
    Local nCol         := 0
    Local nTamanGrid   := 0

    //Caso precise testar em algum lugar
    __lCopia     := .T.

    //Carrega o modelo de dados
    oModel := FWLoadModel(cPrograma)
    oModel:SetOperation(nOperation) // Inclus�o
    oModel:Activate(.T.) // Ativa o modelo com os dados posicionados

    //Pegando o campo de chave
    cCodCd := GetSXENum("Z03", "Z03_CODCD")
    ConfirmSX8()

    //Setando os campos do cabe�alho
    oModel:SetValue("Z03MASTER", "Z03_CODCD",  cCodCd)
    oModel:SetValue("Z03MASTER", "Z03_DESC",   "COP - "+Alltrim(Z03->Z03_DESC))

    //Pegando os dados do filho
    oModelGrid := oModel:GetModel("Z04DETAIL")
    oStruct    := oModelGrid:GetStruct()
    aCampos    := oStruct:GetFields()

    //Se n�o for P12, pega do aCols, sen�o pega do aDataModel
    nTamanGrid := Iif(GetVersao(.F.) < "12", Len(oModelGrid:aCols), Len(oModelGrid:aDataModel))

    //Zerando os campos da grid
    For nLin := 1 To nTamanGrid

        //Setando a linha atual
        oModelGrid:SetLine(nLin)

        //Percorrendo as colunas
        For nCol := 1 To Len(aCampos)

            //Se for a coluna desejada, ir� zerar
            If Alltrim(aCampos[nCol][3]) == "Z04_DESC"
                oModel:SetValue("Z04DETAIL", aCampos[nCol][3], "Linha "+cValToChar(nLin))
            EndIf
        Next nCol
    Next nLin
    oModelGrid:SetLine(1)

    //Executando a visualiza��o dos dados para manipula��o
    nRet     := FWExecView( cTitulo , cPrograma, nOperation, /*oDlg*/, {|| .T. } ,/*bOk*/ , /*nPercReducao*/, /*aEnableButtons*/, /*bCancel*/ , /*cOperatId*/, /*cToolBar*/, oModel )
    __lCopia := .F.
    oModel:DeActivate()

    //Se a c�pia for confirmada
    If nRet == 0
        MsgInfo("C�pia confirmada!", "Aten��o")
    EndIf

    RestArea(aArea)
Return oModel
