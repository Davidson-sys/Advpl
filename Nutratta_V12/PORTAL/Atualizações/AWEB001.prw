#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"                 
#INCLUDE "TOPCONN.CH" 
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} AWEB001
// Rotina de orçamento em MVC - MATA415
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

User Function AWEB001()

	Local oBrowse		:= Nil
	
	Private cCadastro	:= "Orçamentos de Venda"

	oBrowse := FWmBrowse():New()

	oBrowse:SetAlias( 'SCJ' )
	oBrowse:SetDescription( 'Orçamentos' )

//	oBrowse:AddLegend( 'SCJ->CJ_STATUS=="A"' , 'BR_VERDE' 	, "Orçamento em Aberto" 	)
//	oBrowse:AddLegend( 'SCJ->CJ_STATUS=="B"' , 'BR_VERMELHO', "Orçamento Baixado" 		)
//	oBrowse:AddLegend( 'SCJ->CJ_STATUS=="C"' , 'BR_PRETO'	, "Orçamento cancelado" 	)
//	oBrowse:AddLegend( 'SCJ->CJ_STATUS=="D"' , 'BR_AMARELO'	, "Orçamento nao Orçado" 	)
//	oBrowse:AddLegend( 'SCJ->CJ_STATUS=="F"' , 'BR_MARROM'	, "Orçamento bloqueado" 	)

	// Legenda altera a pedido do cliente Nutratta
	oBrowse:AddLegend( 'SCJ->CJ_STATUS=="A"' , 'BR_VERMELHO', "Pedido em Aberto" 		)
	oBrowse:AddLegend( 'SCJ->CJ_STATUS=="B"' , 'BR_VERDE'	, "Pedido Baixado" 			)
	oBrowse:AddLegend( 'SCJ->CJ_STATUS=="F"' , 'BR_MARROM'	, "Pedido Bloqueado" 		)
	oBrowse:AddLegend( 'SCJ->CJ_STATUS=="R"' , 'BR_PRETO'	, "Pedido Reprovado" 		)
	
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

	Local aRotina := {}

	ADD OPTION aRotina Title 'Pesquisar'  	Action 'VIEWDEF.AWEB001'	OPERATION 1 ACCESS 0
	ADD OPTION aRotina Title 'Visualizar'	Action 'U_AWEB001A("VIS")'	OPERATION 2 ACCESS 0
//	ADD OPTION aRotina Title 'Incluir'   	Action 'U_AWEB001A("INC")'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar'    	Action 'U_AWEB001A("EDT")'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Excluir'    	Action 'U_AWEB001A("EXC")'	OPERATION 5 ACCESS 0
	ADD OPTION aRotina Title 'Efetivar'    	Action 'U_AWEB001A("EFT")'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Desbloquear' 	Action 'U_AWEB001A("DSB")'	OPERATION 2 ACCESS 0
//	ADD OPTION aRotina Title 'Cancela'		Action 'U_AWEB001A("CLD")'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Imprimir'		Action 'U_AWEB001A("IMP")'	OPERATION 2 ACCESS 0
//	ADD OPTION aRotina Title 'Copiar'		Action 'U_AWEB001A("CPY")'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Legenda'		Action 'U_AWEB001A("LEG")'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Log Aprovação'Action 'U_AWEB001A("LOG")'	OPERATION 8 ACCESS 0
//	ADD OPTION aRotina Title 'Conhecimento'	Action 'MsDocument'			OPERATION 4 ACCESS 0
	
Return(aRotina)

/*/{Protheus.doc} ModelDef
// Modelo de dados
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSCJ	:= FWFormStruct( 1, 'SCJ', /*bAvalCampo*/, /*lViewUsado*/ )
	Local oStruSCK	:= FWFormStruct( 1, 'SCK', /*bAvalCampo*/, /*lViewUsado*/ )

	// Cria o objeto do Modelo de Dados
	Local oModel	:= MPFormModel():New( 'AWEB001M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'SCJMASTER', /*cOwner*/, oStruSCJ )

	// Adiciona ao modelo uma estrutura de formulário de edição por grid
	oModel:AddGrid( 'SCKDETAIL', 'SCJMASTER', oStruSCK, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

	// Faz relaciomaneto entre os compomentes do model
	oModel:SetRelation( 'SCKDETAIL', { { 'CK_FILIAL', 'xFilial( "SCK" )' }, { 'CK_NUM', 'CJ_NUM' } }, SCK->(IndexKey(1)) )

	// Liga o controle de nao repeticao de linha
	oModel:GetModel( 'SCKDETAIL' ):SetUniqueLine( { 'CK_FILIAL','CK_NUM','CK_ITEM' } )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Orçamentos' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'SCKDETAIL' ):SetDescription( 'Itens' )

	oModel:SetPrimaryKey({ 'CJ_FILIAL', 'CJ_NUM' }) 

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
	Local oStruSCJ	:= FWFormStruct( 2, 'SCJ' )
	Local oStruSCK	:= FWFormStruct( 2, 'SCK' )

	// Cria a estrutura a ser usada na View
	Local oModel	:= FWLoadModel( 'AWEB001' )
	Local oView		:= FWFormView():New()

	// Oculta Campos da Grid
	oStruSCK:RemoveField( 'CK_FILIAL' )
	oStruSCK:RemoveField( 'CK_NUM' )

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_SCJ', oStruSCJ, 'SCJMASTER'	)

	//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
	oView:AddGrid(  'VIEW_SCK', oStruSCK, 'SCKDETAIL'	)

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR', 50 )
	oView:CreateHorizontalBox( 'INFERIOR', 50 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_SCJ', 'SUPERIOR' 	)
	oView:SetOwnerView( 'VIEW_SCK', 'INFERIOR'	)

	// Habilita titulo dos objetos
	oView:EnableTitleView( 'VIEW_SCJ', , 0 )

Return(oView)

/*/{Protheus.doc} BrowseDef
// Integração Web
@author Marco Aurelio Braga
@since 04/02/2016
@version 1.0
@type function
/*/

Static Function BrowseDef()

	Local aRet	:= {}
	
	// Array principal
	
	aAdd(aRet, {"Legend"	, {} })
	aAdd(aRet, {"Alias"		, {} })
	aAdd(aRet, {"Filter"	, {} })
	
	// Array Legenda
	
//	aAdd(aRet[1,2], {'SCJ->CJ_STATUS=="A"' , 'BR_VERDE' 	, "Orçamento em Aberto"		})
//	aAdd(aRet[1,2], {'SCJ->CJ_STATUS=="B"' , 'BR_VERMELHO'	, "Orçamento Baixado"		})
//	aAdd(aRet[1,2], {'SCJ->CJ_STATUS=="C"' , 'BR_PRETO'		, "Orçamento cancelado"		})
//	aAdd(aRet[1,2], {'SCJ->CJ_STATUS=="D"' , 'BR_AMARELO'	, "Orçamento nao Orçado"	})
//	aAdd(aRet[1,2], {'SCJ->CJ_STATUS=="F"' , 'BR_MARROM'	, "Orçamento bloqueado"		})
	
	// Legenda altera a pedido do cliente Nutratta
	aAdd(aRet[1,2], {'SCJ->CJ_STATUS=="A"' , 'BR_VERMELHO' 	, "Pedido em Aberto"		})
	aAdd(aRet[1,2], {'SCJ->CJ_STATUS=="B"' , 'BR_VERDE'		, "Pedido Baixado"			})
	aAdd(aRet[1,2], {'SCJ->CJ_STATUS=="F"' , 'BR_MARROM'	, "Pedido Bloqueado"		})
	aAdd(aRet[1,2], {'SCJ->CJ_STATUS=="R"' , 'BR_PRETO'		, "Pedido Reprovado"		})
	
	// Array Alias
	
	aAdd(aRet[2,2], {"SCJ"})
	
	// Array Filter
	
	aAdd(aRet[3,2], {""})	

Return(aRet)

/*/{Protheus.doc} AWEB001A
// Opações do Menu - MATA415
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

User Function AWEB001A(cOpcao)

	Local lRet	:= .T.

	// Compatibilidade com MATA415

	Private cCadastro	:= 'Orçamento'
	Private aRotina		:= StaticCall(MATA415,MenuDef)
	
	Pergunte("MTA416",.F.)
	
	// Deixa SA1 aberta
	
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	Do Case	
		Case (cOpcao == "VIS")
			A415Visual("SCJ",SCJ->(Recno()),2)
		Case (cOpcao == "INC")
			lRet := A415Inclui("SCJ",SCJ->(Recno()),3)	
		Case (cOpcao == "EDT")
			lRet := fEdtOrc()
		Case (cOpcao == "EXC")
			lRet := fExcOrc()
		Case (cOpcao == "EFT")
			lRet := fEftOrc()
		Case (cOpcao == "DSB")
			lRet := fDsbOrc()
		Case (cOpcao == "CLD")
			lRet := fCLDOrc()			
		Case (cOpcao == "IMP")
			A415Impri("SCJ",SCJ->(Recno()),2)
		Case (cOpcao == "CPY")
			lRet := A415PCpy("SCJ",SCJ->(Recno()),4)			
		Case (cOpcao == "LEG")
			//A415Legend()
			fGetLeg()
		Case (cOpcao == "LOG")
			fGetLog()
	EndCase
	
Return(lRet)

/*/{Protheus.doc} fEdtOrc
// Edita orçamento
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function fEdtOrc()

	Local lRet := A415Altera("SCJ",SCJ->(Recno()),4)
	
	If lRet
		MsgInfo("Orçamento alterado com sucesso!")
		fSndWF("EDT")
	Endif
	
Return(lRet)

/*/{Protheus.doc} fExcOrc
// Exclui orçamento
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/
/* Alterações por Daniel em 11/08/2016
 * - Erro ao excluir -> Trocado o 4(editar) por 5 (excluir) nao funcao A415Exclui
 * - Mesmo ao cancelar a tela de exlusao estava enviando o email de exclusao -> reposicionado no recno e adicionado SCJ->( Deleted()) no if
**/

Static Function fExcOrc()
	Local nRecno := SCJ->( Recno() )
	Local lRet := A415Exclui("SCJ", SCJ->(Recno()), 5)  
	
	DbGoTo( SCJ->( nRecno ) )
	
	If lRet .And. SCJ->( Deleted() )
		MsgInfo("Orçamento excluido com sucesso!")
		fSndWF("EXC")
	Endif
	
Return(lRet)

/*/{Protheus.doc} fEftOrc
// Efetiva orçamento
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function fEftOrc()

	Local lRet		:= .F.
	Local cBkpFil	:= cFilAnt

	If Empty(SCJ->CJ_CLIENTE) .OR. Empty(SCJ->CJ_LOJA) .OR. SCJ->CJ_CLIENTE+SCJ->CJ_LOJA == GetMv("MV_ORCLIPD")
		MsgStop("Efetive o cadastro do prospect!")
		Return()
	Endif
	
	If SCJ->CJ_STATUS $ "F/R"
		MsgStop("Pre pedido não liberado!")
		Return()
	Endif              

	// Declaração de variaveis para Pedido de Venda
	
	Private aHeadC6		:= {}
	Private aHeadD4		:= {}
	Private aDataOPC1	:= {}
	Private aDataOPC7	:= {}
	Private aOPC1		:= {}
	Private aOPC7		:= {}
	Private lEnd		:= .F.
	Private INCLUI		:= .T.
	Private lMTA650I	:= (ExistBlock( "MTA650I" ) )
	Private lMT650C1	:= (ExistBlock( "MT650C1" ) )
	Private lM650EmpT	:= (ExistTemplate( "EMP650"  ) ) 
	Private lM650Emp	:= (ExistBlock( "EMP650"  ) )
	Private cPedido		:= ""
	Private cItemPV		:= ""
	Private cCadastro	:= OemtoAnsi("Baixa de Orçamentos") 
	Private l416Auto	:= .F.
	Private aAutoCab	:= {}
	Private aAutoItens	:= {}
	Private aValidGet	:= {}
	Private aSav650		:= Array(20)
	Private lConsTerc
	Private lConsNPT
	Private _lEnd	   	:= .F.
	Private _oProcess   := NIL
	
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC6",.T.)
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
		If (  ((X3Uso(SX3->X3_USADO) .And. ;
				!(Trim(SX3->X3_CAMPO) == "C6_NUM" ) .And.;
				Trim(SX3->X3_CAMPO) != "C6_QTDEMP"  .And.;
				Trim(SX3->X3_CAMPO) != "C6_QTDENT") .And.;
				cNivel >= SX3->X3_NIVEL) .Or.;
				Trim(SX3->X3_CAMPO)=="C6_NUMORC" .Or. ;
				Trim(SX3->X3_CAMPO)=="C6_NUMOP"  .Or. ;
				Trim(SX3->X3_CAMPO)=="C6_ITEMOP" .Or. ;
   				Trim(SX3->X3_CAMPO)=="C6_OP" ) //.Or. )//; //				Trim(SX3->X3_CAMPO)=="C6_OPC" )	
  
			Aadd(aHeadC6,{TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				If(Trim(SX3->X3_CAMPO)=="C6_NUMORC",".F.",SX3->X3_VALID),;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo

	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SD4")
	While ( !Eof() .And. SX3->X3_ARQUIVO == "SD4" )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			Aadd(aHeadD4,{ Trim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT })
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	dbSelectArea("ABI")
	dbSelectArea("SCJ")
	lRet := A415Baixa("SCJ",SCJ->(Recno()),4)	

	If lRet
		MsgInfo("Orçamento efetivado com sucesso!")
		//Removido WF a pedido do Tiado e Davdson
		//[quinta-feira, 10 de novembro de 2016 14:54] Davidson Carvalho: 2-Remover o envio automático de email ao Desbloquear e efetivar pré-pedidos no portal;
		//fSndWF("EFT")
	EndIf	

Return(lRet)

/*/{Protheus.doc} fDsbOrc
// Desbloqueia orçamento
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function fDsbOrc()

	Local lRet	:= .T.
	
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	If !SA3->(DbSeek(xFilial("SA3")+__cUserId))
		MsgStop("Usuário não esta cadastrado com vendedor!")
		lRet := .F.
	Else
		If SubStr(SA3->A3_TIPSUP,2,1) <> "A"
			MsgStop("Vendedor não esta com perfil de aprovação!")
			lRet := .F.		
		ElseIf !(SCJ->CJ_VEND1 $ fVend(SA3->A3_COD))
			MsgStop("Usuário não esta como superior do vendedor do Pre Pedido!")
			lRet := .F.
		Endif
	Endif
	
	If lRet
		//lRet := A416Desbl("SCJ",SCJ->(Recno()),2)
		
		DbSelectArea("SCJ")
		SCJ->( DbGoTo(SCJ->(Recno() ) ))
		SCJ->( RecLock("SCJ",.F.) )
		SCJ->CJ_STATUS := "A"
		SCJ->(Msunlock())
		
		lRet := .T.
		
		If lRet .And. SCJ->CJ_STATUS == "A"
			MsgInfo("Orçamento desbloqueado com sucesso!")
			//Removido WF a pedido do Tiado e Davdson
			//[quinta-feira, 10 de novembro de 2016 14:54] Davidson Carvalho: 2-Remover o envio automático de email ao Desbloquear e efetivar pré-pedidos no portal;
			//fSndWF("DSB")
		Endif
	Endif
	
Return(lRet)

/*/{Protheus.doc} fCLDOrc
// Cancela orçamento
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function fCLDOrc()

	Local lRet := A415Cancel("SCJ",SCJ->(Recno()),2)
	
	If lRet
		MsgInfo("Orçamento cancelado com sucesso!")
		fSndWF("CLD")
	Endif
	
Return(lRet)

/*/{Protheus.doc} fVend
 Retorna Vendedores subordinados
@type   function
@author Marco Aurelio Braga
@since  01/02/2016
/*/

Static Function fVend(cVend)
	
	Local aArea		:= GetArea()
	Local cAlias	:= GetNextAlias()
	Local cVends	:= "'"+cVend+"',"
	Local lLoop		:= Upper(ProcName(1)) == Upper("fVend")
	
	BeginSql alias cAlias
		SELECT	SA3.A3_COD
		FROM	%Table:SA3% SA3
		WHERE	SA3.%NOTDEL% 
				AND SA3.A3_FILIAL	= %Exp:xFilial("SA3")%
				AND SA3.A3_SUPER	= %Exp:cVend%
	EndSql
	
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	If (cAlias)->(!Eof())
		While (cAlias)->(!Eof())
			cVends += fVend((cAlias)->A3_COD)
			(cAlias)->(DbSkip())
		Enddo
	Endif
	
	If !lLoop
		cVends := SubStr(cVends,1,Len(cVends)-1)
	Endif
	
	(cAlias)->(DbCloseArea())
	
	RestArea(aArea)

Return(cVends)

/*/{Protheus.doc} fGetLeg
// Legenda do orçamento
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function fGetLeg()

	Local aLeg := {}
	
	aAdd(aLeg, {'BR_VERMELHO' 	, "Pedido em Aberto"	} )
	aAdd(aLeg, {'BR_VERDE'		, "Pedido Baixado"		} )
	aAdd(aLeg, {'BR_MARROM'		, "Pedido Bloqueado"	} )
	aAdd(aLeg, {'BR_PRETO'		, "Pedido Reprovado"	} )
	
	BrwLegenda("Legenda","Legenda",aLeg)

Return()

/*/{Protheus.doc} fGetLog
// Exibe log de aprovacao
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function fGetLog()

	Local cLog		:= SCJ->CJ_C_MOT
	Local oDlgTmp	:= Nil
	Local oTFld		:= Nil
	Local oSay		:= Nil
	Local oMemo		:= Nil
	Local oTButton	:= Nil
	Local oTMsgBar	:= Nil
	Local oTMsgItm	:= Nil	
	
	DEFINE MSDIALOG oDlgTmp TITLE UPPER("Log Aprovação") FROM 000,000 TO 330,550 PIXEL
	
		oTFld		:= TFolder():New(003,003,{" Log Aprovação "},,oDlgTmp,,,,.T.,,270,130)		
		oSay		:= TSay():New(005,005,{|| "Histórico: "},oTFld:aDialogs[1],,,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)		
		oMemo		:= tMultiget():New(015,002,{|u|if(Pcount()>0,cLog:=u,cLog)},oTFld:aDialogs[1],264,100,,,,,,.T.,,,,,,.T.,,,,.T.)
		oMemo:lWordWrap := .F.
		oMemo:EnableHScroll( .T. )
		oMemo:EnableVScroll( .T. )
		
		oTButton	:= TButton():New(138,240,"Fechar",oDlgTmp,{ || oDlgTmp:End() },32,11,,,.F.,.T.,.F.,,.F.,,,.F.)		
		oTMsgBar	:= TMsgBar():New(oDlgTmp," AWEB001 ",.F.,.F.,.F.,.F.,RGB(255,255,255),,,.F.,)
		oTMsgItm	:= TMsgItem():New(oTMsgBar," Nelltech | Gestão de TI ",100,,,,.T.,)
	
	ACTIVATE MSDIALOG oDlgTmp CENTERED

Return()

/*/{Protheus.doc} fSndWF
// Envia notificacao para o vendendor
@author Marco Aurelio Braga
@since 26/05/2016
@version 1.0
@type function
/*/

Static Function fSndWF(cOpcao)

	Local aArea		:= GetArea()
	Local cTitulo	:= ""
	Local cSubj		:= ""
	Local cVend		:= ""
	Local cMail		:= ""
	Local cHtml		:= ""
	Local oHtml		:= Nil
	Local cMailSup	:= ""

	Do Case	
		Case (cOpcao == "EDT")
			cTitulo := "Editado"
		Case (cOpcao == "EXC")
			cTitulo := "Excluido"
		Case (cOpcao == "EFT")
			cTitulo := "Efetivado"
		Case (cOpcao == "DSB")
			cTitulo := "Desbloqueado"
		Case (cOpcao == "CLD")
			cTitulo := "Cancelado"
	EndCase

	cSubj	:= "Pre Pedido "+cTitulo
	
	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))
	If SA3->(!DbSeek(xFilial("SA3")+SCJ->CJ_VEND1))
		Return()
	Endif
	
	cMail	:= AllTrim(SA3->A3_EMAIL)
	cVend	:= AllTrim(SA3->A3_NOME)
	
	StaticCall( CRA00001 , fVend, cVend, @cMailSup)
		
	oHtml := TWFHtml():New()
	oHtml:lUsaJS := .F.
	oHtml:LoadFile( "\web\sigacrm\html\crm_orc01.htm" )
	oHtml:ValByName("URL_IMG"		, "")
	oHtml:ValByName("EMPRESA"		, AllTrim(SM0->M0_NOME))
	oHtml:ValByName("FILIAL"		, AllTrim(SM0->M0_FILIAL))		
	oHtml:ValByName("CODEMP"		, cEmpAnt)
	oHtml:ValByName("CODFIL"		, cFilAnt)
	oHtml:ValByName("NUMERO"		, SCJ->CJ_NUM )
	oHtml:ValByName("RETORNO"		, cTitulo )	
	oHtml:ValByName("EMISSAO"		, DTOC(SCJ->CJ_EMISSAO) )
	oHtml:ValByName("CLIENTE"		, SCJ->CJ_CLIENTE+SCJ->CJ_LOJA)
	oHtml:ValByName("NOME"			, Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_NOME"))
	oHtml:ValByName("VENDEDOR"		, SCJ->CJ_VEND1 + " - " + cVend)
	oHtml:ValByName("ENTREGA"		, DTOC(SCJ->CJ_FECENT))
	
	oHtml:ValByName("TB.ITEM"		,{})
	oHtml:ValByName("TB.PRODUTO"	,{})
	oHtml:ValByName("TB.QTDE"		,{})
	oHtml:ValByName("TB.UM"			,{})
	oHtml:ValByName("TB.PRECO"		,{})
	oHtml:ValByName("TB.ENTREGA"	,{})
	oHtml:ValByName("TB.FRETE"		,{})
	oHtml:ValByName("TB.TOTAL"		,{})
	oHtml:ValByName("TB.OBS"		,{})	
	
	DbSelectArea("SCK")
	SCK->(DbSetOrder(1))
	If SCK->(DbSeek(xFilial("SCK")+SCJ->CJ_NUM))
		While SCK->(!Eof()) .AND. SCK->(CK_FILIAL+CK_NUM) == xFilial("SCK")+SCJ->CJ_NUM
		
			AAdd( (oHtml:ValByName("TB.ITEM" 	))	, SCK->CK_ITEM						)
			AAdd( (oHtml:ValByName("TB.PRODUTO"	))	, SCK->CK_PRODUTO					)
			AAdd( (oHtml:ValByName("TB.QTDE" 	))	, cValToChar(SCK->CK_QTDVEN)		)
			AAdd( (oHtml:ValByName("TB.UM"	  	))	, SCK->CK_UM						)
			AAdd( (oHtml:ValByName("TB.PRECO"	))	, cValToChar(SCK->CK_PRCVEN)		)
			//AAdd( (oHtml:ValByName("TB.ENTREGA"	))	, cValToChar(DTOC(SCK->CK_ENTREG))	)
			AAdd( (oHtml:ValByName("TB.FRETE"	))	, cValToChar(SCK->CK_C_FRETE)		)
			AAdd( (oHtml:ValByName("TB.TOTAL"	))	, cValToChar(SCK->CK_VALOR)			)
			AAdd( (oHtml:ValByName("TB.OBS"	  	))	, AllTrim(SCK->CK_OBS)				)
	
			SCK->(DbSkip())
		Enddo
	Endif
	
	cHtml := oHtml:HtmlCode()
	cHtml := STRTRAN ( cHtml , CHR(10), "" )
		
	If U_FWEB001(cSubj,cHtml,cMail,cMailSup)
		MsgInfo("E-Mail enviado para "+cMail)
	Else
		MsgAlert("Erro ao enviar e-mail para o vendedor.")
	Endif
		
	oHtml:Free()
	RestArea(aArea)

Return()
