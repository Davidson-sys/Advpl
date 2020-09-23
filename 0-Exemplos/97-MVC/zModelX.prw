//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Variáveis Estáticas
Static cTitulo := "Artistas (Mod.X)"

/*/{Protheus.doc} zMode1X
Função de exemplo de Modelo X (Pai, Filho e Neto), com as tabelas de Artistas, CDs e Músicas
@author Atilio
@since 03/09/2016
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_zMode1X()
/*/

User Function zMode1X()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()

    SetFunName("zMode1X")

    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()

    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("Z02")

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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zMode1X' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    Local oModel   := Nil
    Local oStPai   := FWFormStruct(1, 'Z02' )
    Local oStFilho := FWFormStruct(1, 'Z03' )
    Local oStNeto  := FWFormStruct(1, 'Z04' )
    Local aZ03Rel  := {}
    Local aZ04Rel  := {}
     
    //Criando o modelo e os relacionamentos
    oModel := MPFormModel():New('zMode1XM')
    oModel:AddFields('Z02MASTER',/*cOwner*/,oStPai)
    oModel:AddGrid('Z03DETAIL','Z02MASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:AddGrid('Z04DETAIL','Z03DETAIL',oStNeto,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
     
    //Fazendo o relacionamento entre o Pai e Filho
    aAdd(aZ03Rel, {'Z03_FILIAL',    'Z02_FILIAL'} )
    aAdd(aZ03Rel, {'Z03_CODART',    'Z02_COD'})
     
    //Fazendo o relacionamento entre o Filho e Neto
    aAdd(aZ04Rel, {'Z04_FILIAL',    'Z03_FILIAL'} )
    aAdd(aZ04Rel, {'Z04_CODART',    'Z03_CODART'})
    aAdd(aZ04Rel, {'Z04_CODCD',     'Z03_CODCD'}) 
     
    oModel:SetRelation('Z03DETAIL', aZ03Rel, Z03->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('Z03DETAIL'):SetUniqueLine({"Z03_CODCD"})    //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
     
    oModel:SetRelation('Z04DETAIL', aZ04Rel, Z04->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('Z04DETAIL'):SetUniqueLine({"Z04_CODMUS"})    //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
     
    //Setando as descrições
    oModel:SetDescription("Grupo de Produtos - Mod. X")
    oModel:GetModel('Z02MASTER'):SetDescription('Modelo Artistas')
    oModel:GetModel('Z03DETAIL'):SetDescription('Modelo CDs')
    oModel:GetModel('Z04DETAIL'):SetDescription('Modelo Musicas')
     
    //Adicionando totalizadores
    oModel:AddCalc('TOTAIS', 'Z02MASTER', 'Z03DETAIL', 'Z03_PRECO',  'XX_VALOR', 'SUM',   , , "Valor Total:" )
    oModel:AddCalc('TOTAIS', 'Z03DETAIL', 'Z04DETAIL', 'Z04_CODMUS', 'XX_TOTAL', 'COUNT', , , "Total Musicas:" )
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()

    Local oView    := Nil
    Local oModel   := FWLoadModel( 'zMode1X' )
    Local oStPai   := FWFormStruct(2, 'Z02' )
    Local oStFilho := FWFormStruct(2, 'Z03' )
    Local oStNeto  := FWFormStruct(2, 'Z04' )
    Local oStTot   := FWCalcStruct(oModel:GetModel( 'TOTAIS' ))
     
    //Criando a View
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Adicionando os campos do cabeçalho e o grid dos filhos
    oView:AddField('VIEW_Z02', oStPai,   'Z02MASTER')
    oView:AddGrid('VIEW_Z03',  oStFilho, 'Z03DETAIL')
    oView:AddGrid('VIEW_Z04',  oStNeto,  'Z04DETAIL')
    oView:AddField('VIEW_TOT', oStTot,   'TOTAIS')
     
    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC', 20)
    oView:CreateHorizontalBox('GRID',  40)
    oView:CreateHorizontalBox('GRID2', 27)
    oView:CreateHorizontalBox('TOTAL', 13)
     
    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_Z02', 'CABEC')
    oView:SetOwnerView('VIEW_Z03', 'GRID')
    oView:SetOwnerView('VIEW_Z04', 'GRID2')
    oView:SetOwnerView('VIEW_TOT', 'TOTAL')
     
    //Habilitando título
    oView:EnableTitleView('VIEW_Z02','Artista')
    oView:EnableTitleView('VIEW_Z03','CDs')
    oView:EnableTitleView('VIEW_Z04','Musicas')
     
    //Removendo campos
    oStFilho:RemoveField('Z03_CODART')
    oStNeto:RemoveField('Z04_CODART')
    oStNeto:RemoveField('Z04_CODCD')
Return oView
