#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*
===============================================================================================================================
Programa--------: AWEB006
Autor-----------: Alexandre Villar
Data da Criacao-: 26/07/2016
===============================================================================================================================
Descri��o-------: Rotina para configura��o das Tabelas do Portal
===============================================================================================================================
Parametros------: Nenhum
===============================================================================================================================
Retorno---------: Nenhum
===============================================================================================================================
*/

User Function AWEB006()

Local _oBrowse	:= Nil

//====================================================================================================
// Configura e inicializa a Classe do Browse
//====================================================================================================
_oBrowse := FWMBrowse():New()
_oBrowse:SetAlias('ZP0')
_oBrowse:SetDescription( 'Tabelas do Portal' )
_oBrowse:DisableDetails()
_oBrowse:Activate()

Return()

/*
===============================================================================================================================
Programa--------: MenuDef
Autor-----------: Alexandre Villar
Data da Criacao-: 26/07/2016
===============================================================================================================================
Descri��o-------: Rotina para defini��o do menu padr�o da rotina principal
===============================================================================================================================
Parametros------: Nenhum
===============================================================================================================================
Retorno---------: _aRotina - Configura��o de Menu
===============================================================================================================================
*/

Static Function MenuDef()

Local _aRotina	:= {}

ADD OPTION _aRotina Title 'Visualizar' 		Action 'VIEWDEF.AWEB006'	OPERATION 2 ACCESS 0
ADD OPTION _aRotina Title 'Incluir'	   		Action 'VIEWDEF.AWEB006'	OPERATION 3 ACCESS 0
ADD OPTION _aRotina Title 'Alterar'	   		Action 'VIEWDEF.AWEB006'	OPERATION 4 ACCESS 0
ADD OPTION _aRotina Title 'Excluir'	   		Action 'VIEWDEF.AWEB006'	OPERATION 5 ACCESS 0

Return( _aRotina )

/*
===============================================================================================================================
Programa--------: ModelDef
Autor-----------: Alexandre Villar
Data da Criacao-: 26/07/2016
===============================================================================================================================
Descri��o-------: Rotina para defini��o do modelo de dados da rotina
===============================================================================================================================
Parametros------: Nenhum
===============================================================================================================================
Retorno---------: _oModel - Modelo de dados da rotina
===============================================================================================================================
*/

Static Function ModelDef()

Local _aGatAux	:= {}

Local _oCabec	:= FWFormStruct( 1 , 'ZP0' )
Local _oItens	:= FWFormStruct( 1 , 'ZP1' )
Local _oModel	:= MpFormModel():New( "AWEB006M" )

//====================================================================================================
// Monta a estrutura dos campos
//====================================================================================================
_oModel:AddFields(	'ZP0MASTER'	,				, _oCabec )
_oModel:AddGrid(	'ZP1DETAIL'	, 'ZP0MASTER'	, _oItens )

_oModel:SetRelation( 'ZP1DETAIL' , {	{ 'ZP1_FILIAL' , 'xFilial("ZP0")'	}	,;
										{ 'ZP1_ARQUIV' , 'ZP0_CHAVE'		} }	,;
										ZP1->( IndexKey(1) ) )

_oModel:SetDescription( 'Tabelas do Portal - Configura��o de Exibi��o'		)

_oModel:GetModel( 'ZP0MASTER' ):SetDescription( 'Configura��o da Tabela'	)
_oModel:GetModel( 'ZP1DETAIL' ):SetDescription( 'Configura��es dos Campos'	)

_oModel:GetModel( 'ZP1DETAIL' ):SetUniqueLine( { 'ZP1_ORDEM' , 'ZP1_CAMPO' } )
_oModel:GetModel( 'ZP1DETAIL' ):SetOptional( .T. )

_oModel:SetPrimaryKey( { 'ZP0_FILIAL' , 'ZP0_CHAVE' } )

Return( _oModel )

/*
===============================================================================================================================
Programa--------: ViewDef
Autor-----------: Alexandre Villar
Data da Criacao-: 26/07/2016
===============================================================================================================================
Descri��o-------: Rotina para defini��o da interface de utiliza��o
===============================================================================================================================
Parametros------: Nenhum
===============================================================================================================================
Retorno---------: _oView - Interface de utiliza��o
===============================================================================================================================
*/

Static Function ViewDef()

Local _oModel	:= FWLoadModel( 'AWEB006' )
Local _oCabec	:= FWFormStruct( 2 , 'ZP0' )
Local _oItens	:= FWFormStruct( 2 , 'ZP1' )
Local _oView	:= FWFormView():New()
Local _bIniCpos	:= {|| U_AWEB006I() }

_oItens:RemoveField( 'ZP1_ARQUIV' )

_oView:SetModel( _oModel )

_oView:AddUserButton( 'Carregar Campos' , 'METAS_BAIXO_16' , _bIniCpos )

_oView:AddField( 'VIEW_CAB' , _oCabec , 'ZP0MASTER' )
_oView:AddGrid(  'VIEW_DET' , _oItens , 'ZP1DETAIL' )

_oView:CreateHorizontalBox( 'SUPERIOR' , 40 )
_oView:CreateHorizontalBox( 'INFERIOR' , 60 )

_oView:SetOwnerView( 'VIEW_CAB' , 'SUPERIOR' )
_oView:SetOwnerView( 'VIEW_DET' , 'INFERIOR' )

_oView:EnableTitleView( 'VIEW_CAB' , 'Configura��o da Tabela' )
_oView:EnableTitleView( 'VIEW_DET' , 'Configura��o de Campos' )

Return( _oView )

/*
===============================================================================================================================
Programa--------: AWEB006I
Autor-----------: Alexandre Villar
Data da Criacao-: 26/07/2016
===============================================================================================================================
Descri��o-------: Rotina para facilitar a inclus�o de novas tabelas na configura��o
===============================================================================================================================
Parametros------: Nenhum
===============================================================================================================================
Retorno---------: Nenhum
===============================================================================================================================
*/

User Function AWEB006I()

Local _oModel	:= FWModelActive()
Local _oView	:= FWViewActive()
Local _oGrid	:= _oModel:GetModel('ZP1DETAIL')

Local _cTabela	:= _oModel:GetValue( 'ZP0MASTER' , 'ZP0_CHAVE' )
Local _nQtdLin	:= _oGrid:Length()
Local _lExec	:= .T.

If !Empty( _cTabela )

	If _nQtdLin > 0
		
		_oGrid:GoLine(1)
		
		If Empty( _oGrid:GetValue( 'ZP1_ORDEM' ) )
			_lExec := .T.
		Else
			_lExec := .F.
			MsgStop( 'J� existem campos configurados! Essa opera��o s� pode ser realizada na inclus�o de uma nova tabela e com os registros ainda em branco.' , 'Aten��o!' )
		EndIf
			
	EndIf
	
	If _lExec
	
		DBSelectArea('SX3')
		SX3->( DBSetOrder(1) )
		If SX3->( DBSeek( _cTabela ) )
			
			While SX3->( !Eof() ) .And. SX3->X3_ARQUIVO == _cTabela
				
				_nQtdLin++
				
				If _nQtdLin > 1
					_oGrid:AddLine()
				EndIf
				
				_oGrid:GoLine( _nQtdLin )
				
				_oGrid:LoadValue( 'ZP1_ARQUIV'	, SX3->X3_ARQUIVO	)
				_oGrid:LoadValue( 'ZP1_ORDEM'	, SX3->X3_ORDEM		)
				_oGrid:LoadValue( 'ZP1_CAMPO'	, SX3->X3_CAMPO		)
				_oGrid:LoadValue( 'ZP1_TIPO'	, SX3->X3_TIPO		)
				_oGrid:LoadValue( 'ZP1_TAMANH'	, SX3->X3_TAMANHO	)
				_oGrid:LoadValue( 'ZP1_DECIMA'	, SX3->X3_DECIMAL	)
				_oGrid:LoadValue( 'ZP1_TITULO'	, SX3->X3_TITULO	)
				_oGrid:LoadValue( 'ZP1_OBRIGA'	, IIF( EMPTY( SX3->X3_OBRIGAT ) , 'N' , 'S' ) )
				_oGrid:LoadValue( 'ZP1_TRIGGE'	, IIF( EMPTY( SX3->X3_TRIGGER ) .OR. SX3->X3_TRIGGER <> 'S' , 'N' , 'S' ) )
				_oGrid:LoadValue( 'ZP1_VALID'	, IIF( EMPTY( SX3->X3_VALID ) .AND. EMPTY( SX3->X3_VLDUSER ) , 'N' , 'S' ) )
				_oGrid:LoadValue( 'ZP1_USADO'	, IIF( X3USO( SX3->X3_USADO ) , 'S' , 'N' ) )
				_oGrid:LoadValue( 'ZP1_F3'		, SX3->X3_F3		)
				_oGrid:LoadValue( 'ZP1_CONTEX'	, SX3->X3_CONTEXT	)
				_oGrid:LoadValue( 'ZP1_BOX'		, SX3->X3_CBOX		)
				_oGrid:LoadValue( 'ZP1_FOLDER'	, SX3->X3_FOLDER	)
				
			SX3->( DBSkip() )
			EndDo
			
		EndIf
		
	EndIf
	
EndIf

_oGrid:GoLine(1)
_oView:Refresh()

Return()