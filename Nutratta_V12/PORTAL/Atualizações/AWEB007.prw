#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"                 
#INCLUDE "TOPCONN.CH" 
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} AWEB007
// Rotina de Cond Pgto (Customizada Tiago em MVC)
@author Marco Aurelio Braga
@since 14/11/2016
@version 1.0
@type function
/*/

User Function AWEB007()
	Local oBrowse

	oBrowse := FWMBrowse():New()

	oBrowse:SetAlias('ZZ8')
	oBrowse:SetDescription('Condicoes de Pagamento')
	oBrowse:DisableDetails()

	oBrowse:Activate()
Return()

/*/{Protheus.doc} MenuDef
// Menu Default
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function MenuDef()

Local _aRotina	:= {}

ADD OPTION aRotina Title 'Visualizar' 		Action 'VIEWDEF.AWEB007'	OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir'	   		Action 'VIEWDEF.AWEB007'	OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar'	   		Action 'VIEWDEF.AWEB007'	OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir'	   		Action 'VIEWDEF.AWEB007'	OPERATION 5 ACCESS 0
	
Return(aRotina)

/*/{Protheus.doc} ModelDef
// Modelo de dados
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function ModelDef()

//Cria a estrutura a ser usada no Modelo de Dados
Local oStruZZ8	:= FWFormStruct( 1, 'ZZ8', /*bAvalCampo*/, /*lViewUsado*/ )

//Cria o objeto do Modelo de Dados
Local oModel	:= MPFormModel():New( 'AWEB007M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

//Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZZ8MASTER', /*cOwner*/, oStruZZ8 )

//Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'Condicoes de Pagamento' )

oModel:GetModel( 'ZZ8MASTER' ):SetDescription( 'Condicoes de Pagamento Customizada'	)



oModel:SetPrimaryKey({ 'ZZ8_FILIAL', 'ZZ8_RISCO', 'ZZ8_CODIGO' }) 

Return(oModel)

/*/{Protheus.doc} ModelDef
// Modelo de tela
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oStruZZ8	:= FWFormStruct( 2, 'ZZ8' )

	// Cria a estrutura a ser usada na View
	Local oModel	:= FWLoadModel( 'AWEB007' )
	Local oView		:= FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZZ8', oStruZZ8, 'ZZ8MASTER'	)

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR', 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZZ8', 'SUPERIOR' 	)

	// Habilita titulo dos objetos
	oView:EnableTitleView( 'VIEW_ZZ8', , 0 )

Return(oView)

/*/{Protheus.doc} BrowseDef
// Integração Web
@author Marco Aurelio Braga
@since 04/02/2016
@version 1.0
@type function
/*/

/*Static Function BrowseDef()

	Local aRet	:= {}
	
	// Array principal
	
	aAdd(aRet, {"Legend"	, {} })
	aAdd(aRet, {"Alias"		, {} })
	aAdd(aRet, {"Filter"	, {} })
	
	// Array Legenda
	
//	aAdd(aRet[1,2], {"SUS->US_STATUS == '1'", "BR_MARROM"		,'Classificado'			})
//	aAdd(aRet[1,2], {"SUS->US_STATUS == '1'", "BR_MARROM"		,'Aguardando'			})
//	aAdd(aRet[1,2], {"SUS->US_STATUS == '2'", "BR_VERMELHO"		,'Desenvolvimento'		})
//	aAdd(aRet[1,2], {"SUS->US_STATUS == '3'", "BR_AZUL"			,'Gerente'				})
//	aAdd(aRet[1,2], {"SUS->US_STATUS == '4'", "BR_AMARELO"		,'Standy by'			})
//	aAdd(aRet[1,2], {"SUS->US_STATUS == '5'", "BR_PRETO"		,'Cancelado'			})
//	aAdd(aRet[1,2], {"SUS->US_STATUS == '6'", "BR_VERDE"		,'Cliente' 				})
//	aAdd(aRet[1,2], {"Empty(SUS->US_STATUS)", "BR_BRANCO"		,'Maling (sem status)'	})

	// Legenda altera a pedido do cliente Nutratta
	//aAdd(aRet[1,2], {"SUS->US_STATUS == '1'", "BR_VERMELHO"		,'Aguardando'			})
	//aAdd(aRet[1,2], {"SUS->US_STATUS == '5'", "BR_PRETO"		,'Cancelado'			})
	//aAdd(aRet[1,2], {"SUS->US_STATUS == '6'", "BR_VERDE"		,'Cliente' 				})
	
	// Array Alias
	
	aAdd(aRet[2,2], {"SUS"})
	
	// Array Filter
	
	aAdd(aRet[3,2], {""})	

Return(aRet)
*/
