#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "XMLXFUN.CH"

//===========================================================

//Estrutura de Retorno da Browser
WsStruct Browser
	WsData Table		As String
	WsData Rows			As Array	Of	Row
	WsData Captions		As Array	Of	Caption
	WsData Valida		As Float
	WsData Erro			As String
EndWsStruct

//Estrutura de Retorno da Legenda
WsStruct Caption
	WsData Image		As String
	WsData Rule			As String	
	WsData Label		As String
EndWsStruct

//Estrutura de Retorno do Registro
WsStruct Row
	WsData Key			As String
	WsData Index		As String
	WsData Recno		As String
	WsData Caption		As String
	WsData Fields		As Array	Of	Field
EndWsStruct

//Estrutura de Retorno do Campo
WsStruct Field
	WsData Field		As String
	WsData Label		As String	
	WsData Order		As String
	WsData Type			As String
	WsData Length		As String
	WsData Value		As String
	WsData Relacao		As String
	WsData TipRel		As String	
EndWsStruct

//===========================================================

//Estrutura de Retorno das Rules
WsStruct Table
	WsData Valida		As Float
	WsData Erro			As String
	WsData Fields		As Array	Of	Rules
	WsData Folders		As Array	Of	Folder
EndWsStruct

//Estrutura de Retorno de Abas
WsStruct Folder
	WsData Value		As String
	WsData Label		As String	
EndWsStruct

//Estrutura de Retorno das regras dos campos
WsStruct Rules
	WsData Field		As String
	WsData Label		As String	
	WsData Order		As String
	WsData Type			As String
	WsData Length		As String
	WsData Mandatory	As Float
	WsData Triggers		As Float
	WsData Validation	As Float
	WsData Used			As Float
	WsData F3			As String
	WsData Context		As String
	WsData Folder		As String
	WsData ComboBox		As Array	Of	Combo
EndWsStruct

//Estrutura de Retorno do ComboBox
WsStruct Combo
	WsData Value		As String
	WsData Mask			As String	
EndWsStruct

//===========================================================

//Estrutura de Retorno do RunTrigger
WsStruct Trigger
	WsData Valida		As Float
	WsData Erro			As String
	WsData Triggers		As Array	Of	FieldM2
EndWsStruct

//Estrutura de Retorno do FieldM2
WsStruct FieldM2
	WsData Field		As String
	WsData Value		As String	
EndWsStruct

//===========================================================

//Estrutura de Retorno de GetAnx
WsStruct Anexo
	WsData Table		As String
	WsData Key			As String
	WsData Files		As Array	Of	Files
	WsData Valida		As Float
	WsData Erro			As String
EndWsStruct

//Estrutura de Retorno do Files
WsStruct Files
	WsData CodObj		As String
	WsData Name			As String
	WsData Descri		As String
	WsData B64Bin		As Base64Binary
	WsData URL			As String
EndWsStruct

//===========================================================

//Estrutura de Envio de arquivos para gravação (Rotina de Conhecimento)
WsStruct IncFiles
	WsData _cCodEmp		As String
	WsData _cCodFil		As String
	WsData _cTabela		As String
	WsData _cChave		As String
	WsData _cNome		As String
	WsData _cDescri		As String
//	WsData _cB64Bin		As Base64Binary
EndWsStruct

//===========================================================

//Estrutura de Retorno de Gravação de Anexos (Rotina de Conhecimento)
WsStruct RetAnexo
	WsData _lValida		As Boolean
	WsData _cMsgRet		As String
	WsData _cUrlFile	As String
	WsData _cNameFile	As String
EndWsStruct


/*/{Protheus.doc} NTWSBROWSER
WebService retorna os registro de uma alias baseado no browser
@author Marco Aurelio Braga
@since 10/12/2015
/*/

WsService NTWSBROWSER Description "Browser Web"

	// Atributos para requisicao
	WsData Table		As String
	WsData ModelID		As String
	WsData Filter		As String
	WsData Start		As Float
	WsData Amount		As Float
	WsData Index		As Float
	WsData Key			As String
	WsData Obj			As String
	WsData Usr			As String
	WsData Psw			As String
	WsData Emp			As String
	WsData Fil			As String
	WsData MethodWS		As String
	WsData ModelXML		As Base64Binary
	WsData ModelXSD		As Base64Binary
	WsData ModelPAR		As Base64Binary
	WsData lOK			As Boolean
	WsData lStruct		As Boolean

	// Atributos para retorno
	WsData Browser		As Array	Of	Browser
	WsData Rules		As Array	Of	Table
//	WsData Trigger		As Array	Of	Trigger
	WsData Anexo		As Array	Of	Anexo
	WsData IncAnexo		As IncFiles
	WsData RetAnexo		As RetAnexo

	// Metodos
	WsMethod Browser	Description "Retorna os registro de um Alias baseado no browser."
	WsMethod Rules		Description "Retorna regras dos campos de uma tabela."
//	WsMethod Trigger	Description "Executa e retona valores das triggers."
	WsMethod GetAnx		Description "Retorna anexos do registro."
	WsMethod SetAnx		Description "Grava anexos no registro."
	WsMethod DelAnx		Description "Deleta anexos no registro."
	WsMethod PutXMLDATA	Description "Faz a gravacao de registro no modelo MVC com Autenticacao."
	WsMethod GetXSD		Description "Retorna o XSD para operações."
	WsMethod GetXML		Description "Retorna o XML para operações."
	WsMethod SetValReg	Description "Edita valor de campos de um registro."
	WsMethod RunFunERP	Description "Executa funcao dentro do ERP."

EndWsService

/*/{Protheus.doc} MLOGIN
Retorna os registro de uma alias baseado no browser
@author Marco Aurelio Braga
@since 10/12/2015
/*/

WsMethod Browser WsReceive Table, ModelID, Filter, Start, Amount, Index, Key, lStruct, Usr, Psw, Emp, Fil WsSend Browser WsService NTWSBROWSER

	Local cCpoFil	:= ""
	Local cCpoVlr	:= ""
	Local cIdxKey	:= ""
	Local cIdxVlr	:= ""
	Local cError	:= ""
	Local cRunBloc	:= ""
	Local cCaption	:= ""
	Local nCount	:= 0
	Local nRow		:= 0
	Local nField	:= 0
	Local nScan		:= 0
	Local nCaption	:= 0
	Local aCaption	:= {}

	// Valida parêmetros		
	Do Case
		Case (Empty(Table))
			cError := "Tabela não informada!"
		Case (Start < 0)
			cError := "Linha de inicio de registros invalida!"
		Case (Amount < 0)
			cError := "Quantidade de registros a ser exibida invalida!"
		Case (Index < 0)
			cError := "Numero do indice invalido!"
		Case (Empty(Usr) .OR. Empty(Psw))
			cError := "Login ou senha não informados!"
		Case (Empty(Emp) .OR. Empty(Fil))
			cError := "Empresa ou Filial não informados!"
	EndCase
	
	If !Empty(cError)
	
		aAdd(::Browser,WsClassNew("Browser"))	
		::Browser[01]:Valida	:=	0
		::Browser[01]:Erro		:=	cError
		::Browser[01]:Table		:=	Table
		::Browser[01]:Rows		:=	{}
		::Browser[01]:Captions	:=	{}
		
		aAdd(::Browser[01]:Captions,WsClassNew("Caption"))
		::Browser[01]:Captions[01]:Image	:=	""
		::Browser[01]:Captions[01]:Rule		:=	""
		::Browser[01]:Captions[01]:Label	:=	""
		
		aAdd(::Browser[01]:Rows,WsClassNew("Row"))
		::Browser[01]:Rows[01]:Key		:=	""
		::Browser[01]:Rows[01]:Index	:=	""
		::Browser[01]:Rows[01]:Recno	:=	""
		::Browser[01]:Rows[01]:Caption	:=	""
		::Browser[01]:Rows[01]:Fields	:=	{}
		
		aAdd(::Browser[01]:Rows[01]:Fields,WsClassNew("Field"))
		::Browser[01]:Rows[01]:Fields[01]:Field		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Label		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Order		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Type		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Length	:=	""
		::Browser[01]:Rows[01]:Fields[01]:Value		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Relacao	:=  ""
		::Browser[01]:Rows[01]:Fields[01]:TipRel	:=  ""
		
		Return(.T.)
		
	Endif  

	// Valida Login/Senha
	If !fVldPsw(Usr, Psw)
	
		aAdd(::Browser,WsClassNew("Browser"))	
		::Browser[01]:Valida	:=	0
		::Browser[01]:Erro		:=	"Erro de acesso. Login ou senha inválidos!"
		::Browser[01]:Table		:=	Table
		::Browser[01]:Rows		:=	{}
		::Browser[01]:Captions	:=	{}
		
		aAdd(::Browser[01]:Captions,WsClassNew("Caption"))
		::Browser[01]:Captions[01]:Image	:=	""
		::Browser[01]:Captions[01]:Rule		:=	""
		::Browser[01]:Captions[01]:Label	:=	""
		
		aAdd(::Browser[01]:Rows,WsClassNew("Row"))
		::Browser[01]:Rows[01]:Key		:=	""
		::Browser[01]:Rows[01]:Index	:=	""
		::Browser[01]:Rows[01]:Recno	:=	""
		::Browser[01]:Rows[01]:Caption	:=	""
		::Browser[01]:Rows[01]:Fields	:=	{}
		
		aAdd(::Browser[01]:Rows[01]:Fields,WsClassNew("Field"))
		::Browser[01]:Rows[01]:Fields[01]:Field		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Label		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Order		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Type		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Length	:=	""
		::Browser[01]:Rows[01]:Fields[01]:Value		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Relacao	:=  ""
		::Browser[01]:Rows[01]:Fields[01]:TipRel	:=  ""
	
		Return(.T.)

	Endif
	
	// Inicializa Ambiente	
	RESET ENVIRONMENT
	
	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA Emp FILIAL Fil MODULO "SIGAFAT"
	Endif
	
	// Valida Dados
	If Table <> 'SX3'
		
		DbSelectArea("SX3")
		SX3->(DbSetOrder(1))
		If SX3->(!DbSeek(Table))
		
			aAdd(::Browser,WsClassNew("Browser"))	
			::Browser[01]:Valida	:=	0
			::Browser[01]:Erro		:=	"Tabela invalida!"
			::Browser[01]:Table		:=	Table
			::Browser[01]:Rows		:=	{}
			::Browser[01]:Captions	:=	{}
			
			aAdd(::Browser[01]:Captions,WsClassNew("Caption"))
			::Browser[01]:Captions[01]:Image	:=	""
			::Browser[01]:Captions[01]:Rule		:=	""
			::Browser[01]:Captions[01]:Label	:=	""
			
			aAdd(::Browser[01]:Rows,WsClassNew("Row"))
			::Browser[01]:Rows[01]:Key		:=	""
			::Browser[01]:Rows[01]:Index	:=	""
			::Browser[01]:Rows[01]:Recno	:=	""
			::Browser[01]:Rows[01]:Caption	:=	""
			::Browser[01]:Rows[01]:Fields	:=	{}
			
			aAdd(::Browser[01]:Rows[01]:Fields,WsClassNew("Field"))
			::Browser[01]:Rows[01]:Fields[01]:Field		:=	""
			::Browser[01]:Rows[01]:Fields[01]:Label		:=	""
			::Browser[01]:Rows[01]:Fields[01]:Order		:=	""
			::Browser[01]:Rows[01]:Fields[01]:Type		:=	""
			::Browser[01]:Rows[01]:Fields[01]:Length	:=	""
			::Browser[01]:Rows[01]:Fields[01]:Value		:=	""
			::Browser[01]:Rows[01]:Fields[01]:Relacao	:=  ""
			::Browser[01]:Rows[01]:Fields[01]:TipRel	:=  ""
		
			Return(.T.)
			
		Endif
	
	EndIf
	
	// Executa Filtro Definido
	DbSelectArea(Table)
	If !Empty(Filter) 
		(Table)->(DbSetFilter({|| &Filter},Filter))
	Endif
	
	// Cria Chave para While
	If Empty( Key )
	
		If Table <> 'SX3'
			cIdxVlr	:= xFilial(Table)
		Else
			cIdxVlr := Table
		EndIf
			
	Else
		cIdxVlr	:= Key
	Endif
	
	// Define Index
	If Empty(Index)
		Index := 1
	Endif
	
	// Busca Dados
	(Table)->(DbSetOrder(Index))
	If (Table)->(DbSeek(cIdxVlr))
	
		aAdd(::Browser,WsClassNew("Browser"))	
		::Browser[01]:Valida	:=	1
		::Browser[01]:Erro		:=	""
		::Browser[01]:Table		:=	Table
		::Browser[01]:Rows		:=	{}
		::Browser[01]:Captions	:=	{}
		
		// Adiciona Legenda
		If !Empty(ModelID)
			cRunBloc	:= 'StaticCall('+ModelID+',BrowseDef)'
			aCaption	:= &cRunBloc	
			If !Empty(aCaption)			
				nScan := aScan(aCaption, {|x| x[1] == "Legend"})
				If nScan > 0 .AND. Len(aCaption[nScan,2]) > 0			
					For nCaption := 1 To Len(aCaption[nScan,2])
						aAdd(::Browser[01]:Captions,WsClassNew("Caption"))
						::Browser[01]:Captions[nCaption]:Image	:=	aCaption[nScan,2][nCaption,2]
						::Browser[01]:Captions[nCaption]:Rule	:=	aCaption[nScan,2][nCaption,1]
						::Browser[01]:Captions[nCaption]:Label	:=	aCaption[nScan,2][nCaption,3]
					Next nCaption
				Else
					aAdd(::Browser[01]:Captions,WsClassNew("Caption"))
					::Browser[01]:Captions[01]:Image	:=	""
					::Browser[01]:Captions[01]:Rule		:=	""
					::Browser[01]:Captions[01]:Label	:=	""
				Endif
			Else
				aAdd(::Browser[01]:Captions,WsClassNew("Caption"))
				::Browser[01]:Captions[01]:Image	:=	""
				::Browser[01]:Captions[01]:Rule		:=	""
				::Browser[01]:Captions[01]:Label	:=	""
			Endif
		Else
			aAdd(::Browser[01]:Captions,WsClassNew("Caption"))
			::Browser[01]:Captions[01]:Image	:=	""
			::Browser[01]:Captions[01]:Rule		:=	""
			::Browser[01]:Captions[01]:Label	:=	""
		Endif
		
		nRow	:= 1
		nCount	:= 1
		nField	:= 1
		cIdxKey	:= (Table)->( IndexKey(Index) )
		
		// Adiciona Campo
		While (Table)->(!Eof()) .AND. SubStr((Table)->(&cIdxKey),1,Len(cIdxVlr)) == cIdxVlr
		
			// Valida linha de inicio definida
			If Start > 0 .AND. nCount < Start 
				nCount++
				(Table)->(DbSkip())
				Loop
			Endif
			
			cCaption := ""
			
			If !Empty(aCaption)	.AND. nScan > 0
				For nCaption := 1 To Len(aCaption[nScan,2])
					cRunBloc := aCaption[nScan,2][nCaption,1]
					If &cRunBloc
						cCaption := aCaption[nScan,2][nCaption,2]
					Endif
				Next nCaption
			Endif
			
			If Table == 'SX3'
				
				If nRow == 1
					
					aAdd(::Browser[01]:Rows,WsClassNew("Row"))
					::Browser[01]:Rows[nRow]:Key		:=	"|"+(Table)->(&cIdxKey)+"|"
					::Browser[01]:Rows[nRow]:Index		:=	cIdxKey
					::Browser[01]:Rows[nRow]:Recno		:=	cValToChar((Table)->(Recno()))
					::Browser[01]:Rows[nRow]:Caption	:=	cCaption
					::Browser[01]:Rows[nRow]:Fields		:=	{}
					
				EndIf
				
			Else
			
				aAdd(::Browser[01]:Rows,WsClassNew("Row"))
				::Browser[01]:Rows[nRow]:Key		:=	"|"+(Table)->(&cIdxKey)+"|"
				::Browser[01]:Rows[nRow]:Index		:=	cIdxKey
				::Browser[01]:Rows[nRow]:Recno		:=	cValToChar((Table)->(Recno()))
				::Browser[01]:Rows[nRow]:Caption	:=	cCaption
				::Browser[01]:Rows[nRow]:Fields		:=	{}
			
			EndIf
			
			If Table == 'SX3'
				
				If SX3->X3_CONTEXT <> 'V'
				
					aAdd(::Browser[01]:Rows[01]:Fields,WsClassNew("Field"))
					::Browser[01]:Rows[01]:Fields[nField]:Field		:=	SX3->X3_CAMPO
					::Browser[01]:Rows[01]:Fields[nField]:Label		:=	SX3->X3_TITULO
					::Browser[01]:Rows[01]:Fields[nField]:Order		:=	SX3->X3_ORDEM
					::Browser[01]:Rows[01]:Fields[nField]:Type		:=	SX3->X3_TIPO
					::Browser[01]:Rows[01]:Fields[nField]:Length	:=	cValToChar(SX3->X3_TAMANHO) +","+ cValToChar(SX3->X3_DECIMAL)
					::Browser[01]:Rows[01]:Fields[nField]:Value		:=	''
					::Browser[01]:Rows[01]:Fields[nField]:Relacao	:=	SX3->X3_RELACAO
					::Browser[01]:Rows[01]:Fields[nField]:TipRel	:=  'V'
					
					nField++
					
				EndIf
				
			Else
				
				nField := 1
				
				DbSelectArea("SX3")
				SX3->(DbSetOrder(1))
				If SX3->(DbSeek(Table))
					While SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == Table
					
						cCpoVlr := SX3->X3_CAMPO
					
						If SX3->X3_BROWSE == 'S' .AND. SX3->X3_CONTEXT <> 'V' .AND. ValType((Table)->(&cCpoVlr)) <> "U"
	
							aAdd(::Browser[01]:Rows[nRow]:Fields,WsClassNew("Field"))
							::Browser[01]:Rows[nRow]:Fields[nField]:Field	:=	SX3->X3_CAMPO
							::Browser[01]:Rows[nRow]:Fields[nField]:Label	:=	SX3->X3_TITULO
							::Browser[01]:Rows[nRow]:Fields[nField]:Order	:=	SX3->X3_ORDEM
							::Browser[01]:Rows[nRow]:Fields[nField]:Type	:=	SX3->X3_TIPO
							::Browser[01]:Rows[nRow]:Fields[nField]:Length	:=	cValToChar(SX3->X3_TAMANHO)+","+cValToChar(SX3->X3_DECIMAL)
							
							Do Case
								Case (SX3->X3_TIPO == 'N')
									::Browser[01]:Rows[nRow]:Fields[nField]:Value	:=	cValToChar((Table)->(&cCpoVlr))
								Case (SX3->X3_TIPO == 'D')
									::Browser[01]:Rows[nRow]:Fields[nField]:Value	:=	DTOC((Table)->(&cCpoVlr))
								OtherWise
									::Browser[01]:Rows[nRow]:Fields[nField]:Value	:=	(Table)->(&cCpoVlr)
							EndCase
							
							::Browser[01]:Rows[nRow]:Fields[nField]:Relacao	:=	SX3->X3_RELACAO
							::Browser[01]:Rows[nRow]:Fields[nField]:TipRel	:=  'V'
	
							nField++
						
						Endif				
	
						SX3->(DbSkip())
						
					Enddo
									
				Endif
			
			EndIf
			
			nRow++
			nCount++
			(Table)->(DbSkip())
			
			// Valida quantidade de linhas defida
			If Amount > 0 .AND. nRow > Amount
				Exit
			Endif
			
		Enddo
		
	ElseIf lStruct
	
		aAdd(::Browser,WsClassNew("Browser"))	
		::Browser[01]:Valida	:=	1
		::Browser[01]:Erro		:=	""
		::Browser[01]:Table		:=	Table
		::Browser[01]:Rows		:=	{}
		::Browser[01]:Captions	:=	{}
		
		// Adiciona Legenda
		If !Empty(ModelID)
			cRunBloc	:= 'StaticCall('+ModelID+',BrowseDef)'
			aCaption	:= &cRunBloc	
			If !Empty(aCaption)			
				nScan := aScan(aCaption, {|x| x[1] == "Legend"})
				If nScan > 0 .AND. Len(aCaption[nScan,2]) > 0			
					For nCaption := 1 To Len(aCaption[nScan,2])
						aAdd(::Browser[01]:Captions,WsClassNew("Caption"))
						::Browser[01]:Captions[nCaption]:Image	:=	aCaption[nScan,2][nCaption,2]
						::Browser[01]:Captions[nCaption]:Rule	:=	aCaption[nScan,2][nCaption,1]
						::Browser[01]:Captions[nCaption]:Label	:=	aCaption[nScan,2][nCaption,3]
					Next nCaption
				Else
					aAdd(::Browser[01]:Captions,WsClassNew("Caption"))
					::Browser[01]:Captions[01]:Image	:=	""
					::Browser[01]:Captions[01]:Rule		:=	""
					::Browser[01]:Captions[01]:Label	:=	""
				Endif
			Else
				aAdd(::Browser[01]:Captions,WsClassNew("Caption"))
				::Browser[01]:Captions[01]:Image	:=	""
				::Browser[01]:Captions[01]:Rule		:=	""
				::Browser[01]:Captions[01]:Label	:=	""
			Endif
		Else
			aAdd(::Browser[01]:Captions,WsClassNew("Caption"))
			::Browser[01]:Captions[01]:Image	:=	""
			::Browser[01]:Captions[01]:Rule		:=	""
			::Browser[01]:Captions[01]:Label	:=	""
		Endif
		
		aAdd(::Browser[01]:Rows,WsClassNew("Row"))
		::Browser[01]:Rows[01]:Key		:=	"||"
		::Browser[01]:Rows[01]:Index	:=	""
		::Browser[01]:Rows[01]:Recno	:=	"0"
		::Browser[01]:Rows[01]:Caption	:=	""
		::Browser[01]:Rows[01]:Fields	:=	{}
		
		nField := 1
		
		DbSelectArea("SX3")
		SX3->(DbSetOrder(1))
		If SX3->(DbSeek(Table))
			While SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == Table
			
				If SX3->X3_BROWSE == 'S' .AND. SX3->X3_CONTEXT <> 'V'

					aAdd(::Browser[01]:Rows[01]:Fields,WsClassNew("Field"))
					::Browser[01]:Rows[01]:Fields[nField]:Field		:=	SX3->X3_CAMPO
					::Browser[01]:Rows[01]:Fields[nField]:Label		:=	SX3->X3_TITULO
					::Browser[01]:Rows[01]:Fields[nField]:Order		:=	SX3->X3_ORDEM
					::Browser[01]:Rows[01]:Fields[nField]:Type		:=	SX3->X3_TIPO
					::Browser[01]:Rows[01]:Fields[nField]:Length	:=	cValToChar(SX3->X3_TAMANHO)+","+cValToChar(SX3->X3_DECIMAL)
					
					Do Case
						Case (SX3->X3_TIPO == 'N')
							::Browser[01]:Rows[01]:Fields[nField]:Value	:=	"0." + Replicate("0", SX3->X3_DECIMAL)
						Case (SX3->X3_TIPO == 'D')
							::Browser[01]:Rows[01]:Fields[nField]:Value	:=	"//"
						OtherWise
							::Browser[01]:Rows[01]:Fields[nField]:Value	:=	""
					EndCase
					
					::Browser[01]:Rows[01]:Fields[nField]:Relacao	:=	SX3->X3_RELACAO
					::Browser[01]:Rows[01]:Fields[nField]:TipRel	:=  'V'

					nField++
				
				Endif				

				SX3->(DbSkip())
			Enddo				
		Endif
	
		Return(.T.)
		
	Else
	
		aAdd(::Browser,WsClassNew("Browser"))	
		::Browser[01]:Valida	:=	0
		::Browser[01]:Erro		:=	"Tabela Nao encontrada!"
		::Browser[01]:Table		:=	Table
		::Browser[01]:Rows		:=	{}
		::Browser[01]:Captions	:=	{}
		
		aAdd(::Browser[01]:Captions,WsClassNew("Caption"))
		::Browser[01]:Captions[01]:Image	:=	""
		::Browser[01]:Captions[01]:Rule		:=	""
		::Browser[01]:Captions[01]:Label	:=	""
		
		aAdd(::Browser[01]:Rows,WsClassNew("Row"))
		::Browser[01]:Rows[01]:Key		:=	""
		::Browser[01]:Rows[01]:Index	:=	""
		::Browser[01]:Rows[01]:Recno	:=	""
		::Browser[01]:Rows[01]:Caption	:=	""
		::Browser[01]:Rows[01]:Fields	:=	{}
		
		aAdd(::Browser[01]:Rows[01]:Fields,WsClassNew("Field"))
		::Browser[01]:Rows[01]:Fields[01]:Field		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Label		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Order		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Type		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Length	:=	""
		::Browser[01]:Rows[01]:Fields[01]:Value		:=	""
		::Browser[01]:Rows[01]:Fields[01]:Relacao	:=  ""
		::Browser[01]:Rows[01]:Fields[01]:TipRel	:=  ""
	
		Return(.T.)
		
	Endif
	
	(Table)->(DbCloseArea())
	
Return(.T.)

/*/{Protheus.doc} MLOGIN
Retorna regras de cadastro para montagem de tela
@author Marco Aurelio Braga
@since 10/12/2015
/*/

WsMethod Rules WsReceive Table, ModelID, Usr, Psw, Emp, Fil WsSend Rules WsService NTWSBROWSER

	Local cError	:= ""
	Local nField	:= 0
	Local nFolder	:= 0
	Local nCombo	:= 0
	Local nInd		:= 0
	Local lFldOut	:= .F.
	Local _lNaoEnc	:= .T.
	Local aCombo	:= {}
	
	// Valida parêmetros	
	Do Case
		Case (Empty(Table))
			cError := "Tabela não informada!"
		Case (Empty(Usr) .OR. Empty(Psw))
			cError := "Login ou senha não informados!"
		Case (Empty(Emp) .OR. Empty(Fil))
			cError := "Empresa ou Filial não informados!"
	EndCase
	
	If !Empty(cError)
	
		aAdd(::Rules,WsClassNew("Table"))	
		::Rules[01]:Valida		:=	0
		::Rules[01]:Erro		:=	cError
		::Rules[01]:Fields		:=	{}
		::Rules[01]:Folders		:=	{}
		
		aAdd(::Rules[01]:Folders,WsClassNew("Folder"))
		::Rules[01]:Folders[01]:Value		:=	""
		::Rules[01]:Folders[01]:Label		:=	""
		
		aAdd(::Rules[01]:Fields,WsClassNew("Rules"))
		::Rules[01]:Fields[01]:Field		:=	""
		::Rules[01]:Fields[01]:Label		:=	""
		::Rules[01]:Fields[01]:Order		:=	""
		::Rules[01]:Fields[01]:Type			:=	""		
		::Rules[01]:Fields[01]:Length		:=	""
		::Rules[01]:Fields[01]:Mandatory	:=	0
		::Rules[01]:Fields[01]:Triggers		:=	0
		::Rules[01]:Fields[01]:Validation	:=	0
		::Rules[01]:Fields[01]:Used			:=	0			
		::Rules[01]:Fields[01]:F3			:=	""
		::Rules[01]:Fields[01]:Context		:=	""
		::Rules[01]:Fields[01]:Folder		:=	""
		::Rules[01]:Fields[01]:ComboBox		:=	{}
		
		aAdd(::Rules[01]:Fields[01]:ComboBox,WsClassNew("Combo"))
		::Rules[01]:Fields[01]:ComboBox[01]:Value		:=	""
		::Rules[01]:Fields[01]:ComboBox[01]:Mask		:=	""

		Return(.T.)
		
	Endif

	// Valida Login/Senha	
	If !fVldPsw(Usr, Psw)

		aAdd(::Rules,WsClassNew("Table"))	
		::Rules[01]:Valida		:=	0
		::Rules[01]:Erro		:=	"Erro de acesso. Login ou senha inválidos!"
		::Rules[01]:Fields		:=	{}
		::Rules[01]:Folders		:=	{}
		
		aAdd(::Rules[01]:Folders,WsClassNew("Folder"))
		::Rules[01]:Folders[01]:Value		:=	""
		::Rules[01]:Folders[01]:Label		:=	""
		
		aAdd(::Rules[01]:Fields,WsClassNew("Rules"))
		::Rules[01]:Fields[01]:Field		:=	""
		::Rules[01]:Fields[01]:Label		:=	""
		::Rules[01]:Fields[01]:Order		:=	""
		::Rules[01]:Fields[01]:Type			:=	""		
		::Rules[01]:Fields[01]:Length		:=	""
		::Rules[01]:Fields[01]:Mandatory	:=	0
		::Rules[01]:Fields[01]:Triggers		:=	0
		::Rules[01]:Fields[01]:Validation	:=	0
		::Rules[01]:Fields[01]:Used			:=	0		
		::Rules[01]:Fields[01]:F3			:=	""
		::Rules[01]:Fields[01]:Context		:=	""
		::Rules[01]:Fields[01]:Folder		:=	""
		::Rules[01]:Fields[01]:ComboBox		:=	{}
		
		aAdd(::Rules[01]:Fields[01]:ComboBox,WsClassNew("Combo"))
		::Rules[01]:Fields[01]:ComboBox[01]:Value		:=	""
		::Rules[01]:Fields[01]:ComboBox[01]:Mask		:=	""

		Return(.T.)

	Endif

	// Inicializa Ambiente	
	RESET ENVIRONMENT
	
	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA Emp FILIAL Fil MODULO "SIGAFAT"
	Endif
	
	// Valida Dados
	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	If SX3->(!DbSeek(Table))
	
		aAdd(::Rules,WsClassNew("Table"))	
		::Rules[01]:Valida		:=	0
		::Rules[01]:Erro		:=	"Tabela não exite no banco de dados!"
		::Rules[01]:Fields		:=	{}
		::Rules[01]:Folders		:=	{}
		
		aAdd(::Rules[01]:Folders,WsClassNew("Folder"))
		::Rules[01]:Folders[01]:Value		:=	""
		::Rules[01]:Folders[01]:Label		:=	""
		
		aAdd(::Rules[01]:Fields,WsClassNew("Rules"))
		::Rules[01]:Fields[01]:Field		:=	""
		::Rules[01]:Fields[01]:Label		:=	""
		::Rules[01]:Fields[01]:Order		:=	""
		::Rules[01]:Fields[01]:Type			:=	""		
		::Rules[01]:Fields[01]:Length		:=	""
		::Rules[01]:Fields[01]:Mandatory	:=	0
		::Rules[01]:Fields[01]:Triggers		:=	0
		::Rules[01]:Fields[01]:Validation	:=	0
		::Rules[01]:Fields[01]:Used			:=	0		
		::Rules[01]:Fields[01]:F3			:=	""
		::Rules[01]:Fields[01]:Context		:=	""
		::Rules[01]:Fields[01]:Folder		:=	""
		::Rules[01]:Fields[01]:ComboBox		:=	{}
		
		aAdd(::Rules[01]:Fields[01]:ComboBox,WsClassNew("Combo"))
		::Rules[01]:Fields[01]:ComboBox[01]:Value		:=	""
		::Rules[01]:Fields[01]:ComboBox[01]:Mask		:=	""

		Return(.T.)
	
	Else
	
		aAdd(::Rules,WsClassNew("Table"))	
		::Rules[01]:Valida		:=	1
		::Rules[01]:Erro		:=	""
		::Rules[01]:Fields		:=	{}
		::Rules[01]:Folders		:=	{}
		
		// Busca regras da SX3
		nField := 0
		
		While SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == Table
		
			If !lFldOut .AND. Empty(SX3->X3_FOLDER)
				lFldOut := .T.
			Endif
			
			If NTCampoWeb( SX3->X3_ARQUIVO ) .And. !( '_FILIAL' $ Upper( AllTrim( SX3->X3_CAMPO ) ) )
				
				DBSelectArea('ZP1')
				ZP1->( DBSetOrder(1) )
				If ZP1->( DBSeek( xFilial('ZP1') + SX3->X3_ARQUIVO ) )
					
					_lNaoEnc := .T.
					
					While ZP1->( !Eof() ) .And. ZP1->( ZP1_FILIAL + ZP1_ARQUIV ) == xFilial('ZP1') + SX3->X3_ARQUIVO .And. _lNaoEnc
						
						If Upper( AllTrim( ZP1->ZP1_CAMPO ) ) == Upper( AllTrim( SX3->X3_CAMPO ) )
						
							nField++
							
							aAdd(::Rules[01]:Fields,WsClassNew("Rules"))
							
							::Rules[01]:Fields[nField]:Field		:=	ZP1->ZP1_CAMPO
							::Rules[01]:Fields[nField]:Label		:=	ZP1->ZP1_TITULO
							::Rules[01]:Fields[nField]:Order		:=	ZP1->ZP1_ORDEM
							::Rules[01]:Fields[nField]:Type			:=	ZP1->ZP1_TIPO
							::Rules[01]:Fields[nField]:Length		:=	cValToChar( ZP1->ZP1_TAMANH ) +","+ cValToChar( ZP1->ZP1_DECIMA )
							::Rules[01]:Fields[nField]:Mandatory	:=	IIF( ZP1->ZP1_OBRIGA == 'S' , 1 , 0 )
							::Rules[01]:Fields[nField]:Triggers		:=	IIF( ZP1->ZP1_TRIGGE == 'S' , 1 , 0 )
							::Rules[01]:Fields[nField]:Validation	:=	IIF( ZP1->ZP1_VALID  == 'S' , 1 , 0 )
							::Rules[01]:Fields[nField]:Used			:=	IIF( ZP1->ZP1_USADO  == 'S' , 1 , 0 )
							::Rules[01]:Fields[nField]:F3			:=	IIF( ZP1->ZP1_USADO  == 'S' , ZP1->ZP1_F3 , '' )
							::Rules[01]:Fields[nField]:Context		:=	ZP1->ZP1_CONTEX
							::Rules[01]:Fields[nField]:Folder		:=	IIF( Empty( ZP1->ZP1_FOLDER ) , "Z" , ZP1->ZP1_FOLDER )
							::Rules[01]:Fields[nField]:ComboBox		:=	{}
							
							_lNaoEnc := .F.
							
							nCombo := 1
						
							If !Empty(SX3->X3_CBOX)
							
								aCombo := StrToKarr(SX3->X3_CBOX, ";")
								
								For nInd := 1 To Len(aCombo)			
				
									aAdd(::Rules[01]:Fields[nField]:ComboBox,WsClassNew("Combo"))
									::Rules[01]:Fields[nField]:ComboBox[nCombo]:Value		:=	SubStr( aCombo[nInd] , 1 , AT("=", aCombo[nInd]) - 1 )
									::Rules[01]:Fields[nField]:ComboBox[nCombo]:Mask		:=	SubStr( aCombo[nInd] ,  AT("=", aCombo[nInd]) + 1 , Len(aCombo[nInd]) )
									
									nCombo++
									
								Next nInd
							
							Else
							
								aAdd(::Rules[01]:Fields[nField]:ComboBox,WsClassNew("Combo"))
								::Rules[01]:Fields[nField]:ComboBox[nCombo]:Value		:=	""
								::Rules[01]:Fields[nField]:ComboBox[nCombo]:Mask		:=	""
							
							Endif
							
						EndIf
						
					ZP1->( DBSkip() )
					EndDo
					
				EndIf
				
			Else
				
				nField++
				
				aAdd(::Rules[01]:Fields,WsClassNew("Rules"))
				
				::Rules[01]:Fields[nField]:Field		:=	SX3->X3_CAMPO
				::Rules[01]:Fields[nField]:Label		:=	SX3->X3_TITULO
				::Rules[01]:Fields[nField]:Order		:=	SX3->X3_ORDEM
				::Rules[01]:Fields[nField]:Type			:=	SX3->X3_TIPO
				::Rules[01]:Fields[nField]:Length		:=	cValToChar(SX3->X3_TAMANHO)+","+cValToChar(SX3->X3_DECIMAL)
				::Rules[01]:Fields[nField]:Mandatory	:=	IIF(Empty(SX3->X3_OBRIGAT),0,1)
				::Rules[01]:Fields[nField]:Triggers		:=	IIF(Empty(SX3->X3_TRIGGER),0,1)
				::Rules[01]:Fields[nField]:Validation	:=	IIF(Empty(SX3->X3_VALID) .AND. Empty(SX3->X3_VLDUSER),0,1)
				::Rules[01]:Fields[nField]:Used			:=	IIF(X3Uso(SX3->X3_USADO),1,0)
				::Rules[01]:Fields[nField]:F3			:=	SX3->X3_F3
				::Rules[01]:Fields[nField]:Context		:=	SX3->X3_CONTEXT
				::Rules[01]:Fields[nField]:Folder		:=	IIF(Empty(SX3->X3_FOLDER),"Z",SX3->X3_FOLDER)
				::Rules[01]:Fields[nField]:ComboBox		:=	{}
				
				nCombo := 1
			
				If !Empty(SX3->X3_CBOX)
				
					aCombo := StrToKarr(SX3->X3_CBOX, ";")
					
					For nInd := 1 To Len(aCombo)			
	
						aAdd(::Rules[01]:Fields[nField]:ComboBox,WsClassNew("Combo"))
						::Rules[01]:Fields[nField]:ComboBox[nCombo]:Value		:=	SubStr(aCombo[nInd], 1, AT("=", aCombo[nInd]) - 1)
						::Rules[01]:Fields[nField]:ComboBox[nCombo]:Mask		:=	SubStr(aCombo[nInd],  AT("=", aCombo[nInd]) + 1, Len(aCombo[nInd]))
						
						nCombo++
						
					Next nInd
				
				Else

					aAdd(::Rules[01]:Fields[nField]:ComboBox,WsClassNew("Combo"))
					::Rules[01]:Fields[nField]:ComboBox[nCombo]:Value		:=	""
					::Rules[01]:Fields[nField]:ComboBox[nCombo]:Mask		:=	""
				
				Endif
			
			EndIf
			
		SX3->(DbSkip())
		Enddo
		
		// Busca Abas
		nFolder := 1
		
		DbSelectArea("SXA")
		SXA->(DbSetOrder(1))
		If SXA->(DbSeek(Table))
			While SXA->(!Eof()) .AND. SXA->XA_ALIAS == Table
				aAdd(::Rules[01]:Folders,WsClassNew("Folder"))
				::Rules[01]:Folders[nFolder]:Value		:=	SXA->XA_ORDEM
				::Rules[01]:Folders[nFolder]:Label		:=	SXA->XA_DESCRIC
				nFolder++
				SXA->(DbSkip())
			Enddo
			If lFldOut
				aAdd(::Rules[01]:Folders,WsClassNew("Folder"))
				::Rules[01]:Folders[nFolder]:Value		:=	"Z"
				::Rules[01]:Folders[nFolder]:Label		:=	"Outros"
				nFolder++
				SXA->(DbSkip())
			Endif
		Else	
			aAdd(::Rules[01]:Folders,WsClassNew("Folder"))
			::Rules[01]:Folders[nFolder]:Value		:=	""
			::Rules[01]:Folders[nFolder]:Label		:=	""
		Endif
		
	Endif
		
Return(.T.)

/*/{Protheus.doc} RTriggers
Retorna regras de cadastro para montagem de tela
@author Marco Aurelio Braga
@since 10/12/2015
/*/

//WsMethod Trigger WsReceive Field, ModelID, Usr, Psw, Emp, Fil WsSend Trigger WsService NTWSBROWSER
//
//	Local cError	:= .F.
//	Local nSequen	:= 0
//	Local xValue	:= Nil
//
//	// Valida parêmetros	
//	Do Case
//		Case (Empty(Field))
//			cError := "Campo não informad0!"
//		Case (Empty(Usr) .OR. Empty(Psw))
//			cError := "Login ou senha não informados!"
//		Case (Empty(Emp) .OR. Empty(Fil))
//			cError := "Empresa ou Filial não informados!"
//	EndCase
//	
//	If !Empty(cError)
//	
//		aAdd(::Trigger,WsClassNew("Trigger"))	
//		::Trigger[01]:Valida	:=	0
//		::Trigger[01]:Erro		:=	cError
//		::Trigger[01]:Triggers	:=	{}
//		
//		aAdd(::Trigger[01]:Triggers,WsClassNew("FieldM2"))
//		::Trigger[01]:Triggers[01]:Field		:=	""
//		::Trigger[01]:Triggers[01]:Value		:=	""
//		
//		Return(.T.)
//
//	Endif
//	
//	// Inicializa Ambiente		
//	RESET ENVIRONMENT
//	
//	If Select("SX6") == 0
//		RpcClearEnv()
//		RpcSetType(3)
//		PREPARE ENVIRONMENT EMPRESA Emp FILIAL Fil MODULO "SIGAFAT"
//	Endif
//
//	// Valida Login/Senha	
//	If !fVldPsw(Usr, Psw)
//	
//		aAdd(::Trigger,WsClassNew("Trigger"))	
//		::Trigger[01]:Valida	:=	0
//		::Trigger[01]:Erro		:=	"Erro de acesso. Login ou senha inválidos!"
//		::Trigger[01]:Triggers	:=	{}
//		
//		aAdd(::Trigger[01]:Triggers,WsClassNew("FieldM2"))
//		::Trigger[01]:Triggers[01]:Field		:=	""
//		::Trigger[01]:Triggers[01]:Value		:=	""
//		
//		Return(.T.)
//
//	Endif
//	
//	// Executa Gatilhos
//	DbSelectArea("SX7")
//	SX7->(DbSetOrder(1))
//	If SX7->(DbSeek(Field))
//	
//		aAdd(::Trigger,WsClassNew("Trigger"))	
//		::Trigger[01]:Valida	:=	1
//		::Trigger[01]:Erro		:=	""
//		::Trigger[01]:Triggers	:=	{}
//		
//		nSequen	:= 1
//		xValue	:= Nil
//		cAlias	:= IIF(AT("_", Field) == 3, "S"+SubStr(Field,1,2), SubStr(Field,1,3))
//		
//		//RegToMemory(cAlias)
//		
//		While SX7->(!Eof()) .AND. SX7->X7_CAMPO == Field
//		
//			If SX7->X7_SEEK == "S" .AND. !Empty(SX7->X7_ALIAS)
//				
//				cAlias := SX7->X7_ALIAS
//							
//				DbSelectArea(cAlias)
//				(cAlias)->(DbSetOrder(SX7->X7_ORDEM))
//				If (cAlias)->(DbSeek(&(SX7->X7_CHAVE)))
//					xValue := &(SX7->X7_REGRA)
//				Endif
//
//			Else
//				xValue := &(SX7->X7_REGRA)
//			Endif
//		
//			aAdd(::Trigger[01]:Triggers,WsClassNew("FieldM2"))
//			::Trigger[01]:Triggers[nSequen]:Field	:=	SX7->X7_CDOMIN
//			
//			Do Case
//				Case ValType(xValue) == "N"
//					::Trigger[01]:Triggers[nSequen]:Value		:=	cValToChar(xValue)
//				Case ValType(xValue) == "D"
//					::Trigger[01]:Triggers[nSequen]:Value		:=	DTOC(xValue)
//				Case ValType(xValue) == "U"
//					::Trigger[01]:Triggers[nSequen]:Value		:=	"Nil"
//				OtherWise
//					::Trigger[01]:Triggers[nSequen]:Value		:=	xValue
//			EndCase	
//			
//			nSequen++
//			xValue	:= Nil
//	
//			SX7->(DbSkip())
//		Enddo
//		
//	Else
//	
//		aAdd(::Trigger,WsClassNew("Trigger"))	
//		::Trigger[01]:Valida	:=	0
//		::Trigger[01]:Erro		:=	"Gatilhos não encontrados!"
//		::Trigger[01]:Triggers	:=	{}
//		
//		aAdd(::Trigger[01]:Triggers,WsClassNew("FieldM2"))
//		::Trigger[01]:Triggers[01]:Field		:=	""
//		::Trigger[01]:Triggers[01]:Value		:=	""
//		
//		Return(.T.)
//		
//	Endif
//		
//Return(.T.)

/*/{Protheus.doc} GetAnx
Retorna anexos do registro
@author Marco Aurelio Braga
@since 10/12/2015
/*/

WsMethod GetAnx WsReceive Table, Key, Usr, Psw, Emp, Fil WsSend Anexo WsService NTWSBROWSER

	Local cError	:= ""
	Local cFile		:= ""
	Local cDescri	:= "" 
	Local cDirDocs	:= ""
	Local cTempPath	:= ""
	Local cPathTerm	:= ""
	Local cPathFile	:= ""
	Local nHandle	:= 0
	Local lLinux	:= GetRemoteType() == 2
	Local nFile		:= 1

	// Valida parêmetros		
	Do Case
		Case (Empty(Table))
			cError := "Tabela não informada!"
		Case (Empty(Key))
			cError := "Chave do registro não informada!"
		Case (Empty(Usr) .OR. Empty(Psw))
			cError := "Login ou senha não informados!"
		Case (Empty(Emp) .OR. Empty(Fil))
			cError := "Empresa ou Filial não informados!"
	EndCase
	
	If !Empty(cError)
	
		aAdd(::Anexo,WsClassNew("Anexo"))	
		::Anexo[01]:Valida	:=	0
		::Anexo[01]:Erro	:=	cError
		::Anexo[01]:Table	:=	Table
		::Anexo[01]:Key		:=	Key
		::Anexo[01]:Files	:=	{}
		
		aAdd(::Anexo[01]:Files,WsClassNew("Files"))
		::Anexo[01]:Files[01]:CodObj	:=	""
		::Anexo[01]:Files[01]:Name		:=	""
		::Anexo[01]:Files[01]:Descri	:=	""
		::Anexo[01]:Files[01]:B64Bin	:=	""
		::Anexo[01]:Files[01]:URL		:=	""
		
		Return(.T.)
		
	Endif  

	// Valida Login/Senha
	If !fVldPsw(Usr, Psw)
		
		aAdd(::Anexo,WsClassNew("Anexo"))	
		::Anexo[01]:Valida	:=	0
		::Anexo[01]:Erro	:=	"Erro de acesso. Login ou senha inválidos!"
		::Anexo[01]:Table	:=	Table
		::Anexo[01]:Key		:=	Key
		::Anexo[01]:Files	:=	{}
		
		aAdd(::Anexo[01]:Files,WsClassNew("Files"))
		::Anexo[01]:Files[01]:CodObj	:=	""
		::Anexo[01]:Files[01]:Name		:=	""
		::Anexo[01]:Files[01]:Descri	:=	""
		::Anexo[01]:Files[01]:B64Bin	:=	""
		::Anexo[01]:Files[01]:URL		:=	""
		
		Return(.T.)

	Endif
	
	// Inicializa Ambiente	
	RESET ENVIRONMENT
	
	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA Emp FILIAL Fil MODULO "SIGAFAT"
	Endif

	// Valida Dados	
	DbSelectArea("AC9")
	AC9->(DbSetOrder(2))
	If AC9->(!DbSeek( xFilial("AC9") + Table + Fil + Key ) )
		
		aAdd(::Anexo,WsClassNew("Anexo"))	
		::Anexo[01]:Valida	:=	0
		::Anexo[01]:Erro	:=	"Não há arquivos no registro!"
		::Anexo[01]:Table	:=	Table
		::Anexo[01]:Key		:=	Key
		::Anexo[01]:Files	:=	{}
		
		aAdd(::Anexo[01]:Files,WsClassNew("Files"))
		::Anexo[01]:Files[01]:CodObj	:=	""
		::Anexo[01]:Files[01]:Name		:=	""
		::Anexo[01]:Files[01]:Descri	:=	""
		::Anexo[01]:Files[01]:B64Bin	:=	""
		::Anexo[01]:Files[01]:URL		:=	""
		
		Return(.T.)
		
	Else
	
		aAdd( ::Anexo , WsClassNew("Anexo") )	
		::Anexo[01]:Valida	:=	1
		::Anexo[01]:Erro	:=	""
		::Anexo[01]:Table	:=	Table
		::Anexo[01]:Key		:=	Key
		::Anexo[01]:Files	:=	{}
	
		While AC9->(!Eof()) .AND. AllTrim( AC9->( AC9_FILIAL + AC9_ENTIDA + AC9->AC9_FILENT + AC9_CODENT ) ) == AllTrim( xFilial("AC9") + Table + Fil + Key )
		
			DbSelectArea("ACB")
			ACB->(DbSetOrder(1))
			If ACB->(DbSeek(xFilial("ACB")+AC9->AC9_CODOBJ))
						
				cFile	:= AllTrim(ACB->ACB_OBJETO)
				cDescri	:= AllTrim(ACB->ACB_DESCRI)

				If MsMultDir()
				   	cDirDocs := MsRetPath(cFile)
				Else
					cDirDocs := MsDocPath()
				Endif

				cDirDocs  := MsDocRmvBar(cDirDocs)
				cPathFile := Lower(cDirDocs + "\" + cFile)				
				
				If File(cPathFile)				
					aAdd(::Anexo[01]:Files,WsClassNew("Files"))
					::Anexo[01]:Files[nFile]:CodObj	:=	ACB->ACB_CODOBJ
					::Anexo[01]:Files[nFile]:Name	:=	cFile
					::Anexo[01]:Files[nFile]:Descri	:=	cDescri
					::Anexo[01]:Files[nFile]:B64Bin	:=	""	// MemoRead(cPathFile)
					::Anexo[01]:Files[nFile]:URL	:=	StrTran(StrTran(cPathFile,"\dirdoc",""),"\","/")
					
//					nHandle := fOpen(cPathFile, FO_READWRITE + FO_SHARED)
//					::Anexo[01]:Files[nFile]:B64Bin	:= FReadStr(nHandle, 256000)

				Else
					aAdd(::Anexo[01]:Files,WsClassNew("Files"))
					::Anexo[01]:Files[nFile]:CodObj	:=	ACB->ACB_CODOBJ
					::Anexo[01]:Files[nFile]:Name	:=	cFile
					::Anexo[01]:Files[nFile]:Descri	:=	"Arquivo não encontrado!"
					::Anexo[01]:Files[nFile]:B64Bin	:=	""
					::Anexo[01]:Files[nFile]:URL	:=	StrTran(StrTran(cPathFile,"\dirdoc",""),"\","/")
				Endif									
			Else
				aAdd(::Anexo[01]:Files,WsClassNew("Files"))
				::Anexo[01]:Files[nFile]:CodObj	:=	AC9->AC9_CODOBJ
				::Anexo[01]:Files[nFile]:Name	:=	""
				::Anexo[01]:Files[nFile]:Descri	:=	"Registro não encontrado!"
				::Anexo[01]:Files[nFile]:B64Bin	:=	""
				::Anexo[01]:Files[nFile]:URL	:=	""
			Endif
			
			nFile++			
			AC9->(DbSkip())
		Enddo		
	Endif
	
	AC9->(DbCloseArea())
	
Return(.T.)

/*/{Protheus.doc} DelAnx
Deleta anexos do registro
@author Marco Aurelio Braga
@since 10/12/2015
/*/

WsMethod DelAnx WsReceive Table, Key, Obj, Usr, Psw, Emp, Fil WsSend RetAnexo WsService NTWSBROWSER

	Local cError	:= ""
	Local cFile		:= ""
	Local cDescri	:= "" 
	Local cDirDocs	:= ""
	Local cTempPath	:= ""
	Local cPathTerm	:= ""
	Local cPathFile	:= ""
	Local lLinux	:= GetRemoteType() == 2

	// Valida parêmetros		
	Do Case
		Case (Empty(Table))
			cError := "Tabela não informada!"
		Case (Empty(Key))
			cError := "Chave do registro não informada!"
		Case (Empty(Usr) .OR. Empty(Psw))
			cError := "Login ou senha não informados!"
		Case (Empty(Emp) .OR. Empty(Fil))
			cError := "Empresa ou Filial não informados!"
		Case (Empty(Obj))
			cError := "Codigo do objeto nulo!"
	EndCase
	
	If !Empty(cError)
	
		::RetAnexo:_lValida   := .F.
		::RetAnexo:_cMsgRet	  := cError
		::RetAnexo:_cUrlFile  := ''
		::RetAnexo:_cNameFile := ''
		
		Return(.T.)
		
	Endif  

	// Valida Login/Senha
	If !fVldPsw(Usr, Psw)
		
		::RetAnexo:_lValida   := .F.
		::RetAnexo:_cMsgRet	  := "Erro de acesso. Login ou senha inválidos!"
		::RetAnexo:_cUrlFile  := ''
		::RetAnexo:_cNameFile := ''
		
		Return(.T.)

	Endif
	
	// Inicializa Ambiente	
	RESET ENVIRONMENT
	
	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA Emp FILIAL Fil MODULO "SIGAFAT"
	Endif

	// Valida Dados	
	DbSelectArea("AC9")
	AC9->(DbSetOrder(2))
	If AC9->(!DbSeek( xFilial("AC9") + Table + Fil + PadR(Key,TAMSX3("AC9_CODENT")[1]," ") + Obj ) )
		
		::RetAnexo:_lValida   := .F.
		::RetAnexo:_cMsgRet	  := "Registro AC9 não encotado!"
		::RetAnexo:_cUrlFile  := ''
		::RetAnexo:_cNameFile := ''
		
		Return(.T.)
		
	Else
	
		DbSelectArea("ACB")
		ACB->(DbSetOrder(1))
		If ACB->(!DbSeek(xFilial("ACB")+AC9->AC9_CODOBJ))
		
			::RetAnexo:_lValida   := .F.
			::RetAnexo:_cMsgRet	  := "Registro ACB não encotado!"
			::RetAnexo:_cUrlFile  := ''
			::RetAnexo:_cNameFile := ''
			
			Return(.T.)
			
		Else
		
			cFile	:= AllTrim(ACB->ACB_OBJETO)

			RecLock('ACB', .F.)
			ACB->(DbDelete())
			ACB->(MsUnLock())
			
			RecLock('AC9', .F.)
			AC9->(DbDelete())
			AC9->(MsUnLock())

			If MsMultDir()
			   	cDirDocs := MsRetPath(cFile)
			Else
				cDirDocs := MsDocPath()
			Endif

			cDirDocs  := MsDocRmvBar(cDirDocs)
			cPathFile := cDirDocs + "\" + cFile
			
			If File(cPathFile)
				fErase(cPathFile)
			Endif
			
			::RetAnexo:_lValida   := .T.
			::RetAnexo:_cMsgRet	  := "Registro excluido com sucesso!"
			::RetAnexo:_cUrlFile  := ''
			::RetAnexo:_cNameFile := ''
			
		Endif
		
		ACB->(DbCloseArea())
			
	Endif
	
	AC9->(DbCloseArea())
	
Return(.T.)

/*
========================================================================================================================
Rotina----: SetAnx
Autor-----: Alexandre Villar
Data------: 26/07/2016
========================================================================================================================
Descrição-: Rotina que verifica se a tabela informada utiliza a configuração customizada de campos para exibição
========================================================================================================================
*/

WsMethod SetAnx WsReceive IncAnexo WsSend RetAnexo WsService NTWSBROWSER

	Local _cDirDocs	:= ''
	Local _cFile	:= ''
	Local _cNomArq	:= ''
	Local _cUrlArq	:= ''
	Local _cTipo	:= ''
	Local _aTipo	:= {}	
	Local _nI		:= 0
	
	// Inicializa Ambiente	
	RESET ENVIRONMENT
	
	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ::IncAnexo:_cCodEmp FILIAL ::IncAnexo:_cCodFil MODULO "SIGAFAT"
	Endif
	
	// Valida extensão/tipo do arquivo
	_aTipo := StrToKarr(::IncAnexo:_cNome, ".")
	_cTipo := _aTipo[Len(_aTipo)]
	
	If !(Upper(_cTipo) $ ("PDF/BMP/JPG/JPEG/PNG/DOC/DOCX/XLS/XLSX/TXT/ZIP/RAR/"))
	
		::RetAnexo:_lValida   := .F.
		::RetAnexo:_cMsgRet	  := 'Extensão do arquivo não permitida!'
		::RetAnexo:_cUrlFile  := ''
		::RetAnexo:_cNameFile := ''
		
		Return(.T.)
		
	Endif
	
	// Carrega diretorio
	If MsMultDir()
	   	_cDirDocs := MsRetPath()
	Else
		_cDirDocs := MsDocPath()
	Endif
	
	_cDirDocs  := MsDocRmvBar(_cDirDocs)
	
	// Grava dados do arquivo
	If ExistDir( _cDirDocs )
		
		_cFile	 := _cDirDocs +'\'+ AllTrim( ::IncAnexo:_cNome )
		_cUrlArq := Lower(_cDirDocs)
		_cNomArq := ::IncAnexo:_cNome
		
		While File( _cFile )
			
			_nI++
			_cNomArq := StrZero(_nI,3) +'_'+ AllTrim( ::IncAnexo:_cNome )
			_cFile	 := _cDirDocs +'\'+ _cNomArq
			
		EndDo
		
//		MemoWrite( _cNomArq , ::IncAnexo:_cB64Bin )
		
		DBSelectArea('ACB')
		ACB->( DBSetOrder(1) )
		RecLock( 'ACB' , .T. )
			
			ACB->ACB_FILIAL	:= xFilial('ACB')
			ACB->ACB_CODOBJ	:= GETSXENUM( 'ACB' , 'ACB_CODOBJ' )
			ACB->ACB_OBJETO	:= _cNomArq
			ACB->ACB_DESCRI	:= AllTrim( ::IncAnexo:_cDescri )
			
		ACB->( MsUnLock() )
		
		If __lSX8
			ConfirmSX8()
		EndIf
		
		DBSelectArea('AC9')
		AC9->( DBSetOrder(1) )
		RecLock( 'AC9' , .T. )
			
			AC9->AC9_FILIAL	:= xFilial('AC9')
			AC9->AC9_FILENT	:= xFilial( ::IncAnexo:_cTabela )
			AC9->AC9_ENTIDA	:= ::IncAnexo:_cTabela
			AC9->AC9_CODENT	:= ::IncAnexo:_cChave
			AC9->AC9_CODOBJ	:= ACB->ACB_CODOBJ
			
		AC9->( MsUnLock() )
		
		::RetAnexo:_lValida   := .T.
		::RetAnexo:_cMsgRet	  := 'Arquivo gravado com sucesso!'
		::RetAnexo:_cUrlFile  := StrTran(StrTran(_cUrlArq,"\dirdoc",""),"\","/")
		::RetAnexo:_cNameFile := _cNomArq
		
	Else
	
		::RetAnexo:_lValida   := .F.
		::RetAnexo:_cMsgRet	  := 'Rotina em desenvolvimento'
		::RetAnexo:_cUrlFile  := ''
		::RetAnexo:_cNameFile := ''
		
		Return(.T.)
	
	EndIf

Return(.T.)

/*/{Protheus.doc} PutXMLDATA
Faz a gravacao de registro no modelo MVC com Autenticacao
@author Marco Aurelio Braga
@since 10/12/2015
/*/

WSMETHOD PutXMLDATA WSRECEIVE ModelID, ModelXML, ModelPAR, Usr, Psw, Emp, Fil  WSSEND lOk WSSERVICE NTWSBROWSER

	Local aError	:= {}
	Local aPK		:= {}
	Local aPar		:= {}
	Local lRet		:= .T.
	Local lFilial	:= .F.
	Local cWarning	:= ""
	Local cAlias	:= ""
	Local cPK		:= ""
	Local cError	:= ""
	Local nX		:= 0
	Local nInd		:= 0
	Local nIndice	:= 0
	Local oModel	:= Nil
	Local oXML		:= Nil
	
	Private lNTJobWS	:= .T.
	Private aNTParWS	:= {}

	// Valida Atributos		
	Do Case
		Case (Empty(Usr) .OR. Empty(Psw))
			cError := "Login ou senha não informados!"
		Case (Empty(Emp) .OR. Empty(Fil))
			cError := "Empresa ou Filial não informados!"
	EndCase
	
	If !Empty(cError)
		SetSoapFault("NTWSBROWSER:PutXMLDATA",cError)
		lRet	:= .F.
		::lOk	:= .F.
		Return(lRet)
	Endif  

	// Valida Login/Senha
	If !fVldPsw(Usr, Psw)
		SetSoapFault("NTWSBROWSER:PutXMLDATA","Erro de acesso. Login ou senha inválidos!")
		lRet	:= .F.
		::lOk	:= .F.
		Return(lRet)
	Endif
	
	// Inicializa Ambiente	
	RESET ENVIRONMENT
	
	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA Emp FILIAL Fil MODULO "SIGAFAT"
	Endif

	//---------------------------------------------------
	// Seta o modo de compatibilidade com o Protheus
	//---------------------------------------------------
	
	SetCompP10(.T.)
	
	//---------------------------------------------------
	// Carrega parâmetros
	//---------------------------------------------------
	
	If !Empty(::ModelPAR)
	
		// Valida o schema
		MemoWrit(GetPathSemaforo()+"PutXMLDATA.xsd",fXSDPXD("XSD"))
		XmlSVldSchema(::ModelPAR,GetPathSemaforo()+"PutXMLDATA.xsd",@cError,@cWarning)
		fErase("PutXMLDATA.xsd")
		
		If !Empty(cError) .OR. !Empty(cWarning)
			SetSoapFault("NTWSBROWSER:PutXMLDATA","ModelPAR Schema: "+cError+" "+cWarning)
			lRet	:= .F.
			::lOk	:= .F.
			Return(lRet)
		Endif
		
		// Valida XML
		oXml	:= XmlParser( ::ModelPAR, "_", @cError, @cWarning )
		
		If !Empty(cError) .OR. !Empty(cWarning) .OR. oXml == Nil
			SetSoapFault("NTWSBROWSER:PutXMLDATA","ModelPAR XML: "+cError+" "+cWarning)
			lRet	:= .F.
			::lOk	:= .F.
			Return(lRet)
		Endif
		
		If ValType(oXml:_Parameters:_Parameter) == "A"	
			For nInd := 1 To Len(oXml:_Parameters:_Parameter)				
				aAdd(aPar, {oXml:_Parameters:_Parameter[nInd]:_Value:Text, oXml:_Parameters:_Parameter[nInd]:_Type:Text})			
			Next nInd
		Else
			aAdd(aPar, {oXml:_Parameters:_Parameter:_Value:Text, oXml:_Parameters:_Parameter:_Type:Text})
		Endif
		
		For nInd := 1 To Len(aPar)
			Do Case
				Case aPar[nInd,2] == "N"
					aAdd(aNTParWS, Val(aPar[nInd,1]))
				Case aPar[nInd,2] == "D"
					aAdd(aNTParWS, STOD(aPar[nInd,1]))
				Case aPar[nInd,2] == "L"
					aAdd(aNTParWS, &(aPar[nInd,1]))
				Case aPar[nInd,2] == "B"
					aAdd(aNTParWS, &(aPar[nInd,1]))
				OtherWise
					aAdd(aNTParWS, aPar[nInd,1])
			EndCase
		Next nInd
	
	Endif
	
	//---------------------------------------------------
	// Pesquisa o modelo informado
	//---------------------------------------------------
	
	oModel := FWLoadModel(::MODELID)
	
	If oModel <> Nil
	
		//---------------------------------------------------
		// Valida o schema
		//---------------------------------------------------
		
		MemoWrit(GetPathSemaforo()+lower(AllTrim(::MODELID))+".xsd",oModel:GetXMLSchema())
		XmlSVldSchema(::ModelXML,GetPathSemaforo()+lower(AllTrim(::MODELID))+".xsd",@cError,@cWarning)
		Ferase(lower(AllTrim(::MODELID))+".xsd")
		
		If Empty(cError) .And. Empty(cWarning)
					
			aPK := oModel:LoadXMLPK(::MODELXML)
			
			//--------------------------------------------------------------------
			// Identifico a chave-primaria e posiciono
			//--------------------------------------------------------------------
					
			If aPK[MODELO_PK_OPERATION] <> MODEL_OPERATION_INSERT
			
				//--------------------------------------------------------------------
				// Verifico o Alias da tabela
				//--------------------------------------------------------------------
				
				nX := At("_",aPK[MODELO_PK_KEYS][1][MODELO_PK_IDFIELD])
				
				If nX > 0
					cAlias := SubStr(aPK[MODELO_PK_KEYS][1][MODELO_PK_IDFIELD],1,nX-1)
					If Len(cAlias) == 2
						cAlias := "S"+Upper(cAlias)
					Else
						cAlias := Upper(cAlias)	
					EndIf
				EndIf
							
				//--------------------------------------------------------------------
				// Encontro o melhor indice da chave primaria
				//--------------------------------------------------------------------
				
				dbSelectArea("SX2")
				dbSetOrder(1)
				MsSeek(cAlias)
				If Empty(SX2->X2_UNICO)
					nIndice := 1
				Else
					nX := 0
					dbSelectArea("SIX")
					dbSetOrder(1)
					MsSeek(cAlias)
					While !Eof() .And. cAlias == SIX->INDICE
						nX++
						If AllTrim(SX2->X2_UNICO) $ SIX->CHAVE
							nIndice := nX
							Exit
						EndIf
						dbSelectArea("SIX")
						dbSkip()
					EndDo
					nIndice := Max(nIndice,1)
				EndIf
				
				//--------------------------------------------------------------------
				// Monto a chave de busca
				//--------------------------------------------------------------------
				
				For nX := 1 To Len(aPK[MODELO_PK_KEYS])
					If "_FILIAL"$aPK[MODELO_PK_KEYS][nX][MODELO_PK_IDFIELD]
						lFilial := .T.
					EndIf
					cPK += aPK[MODELO_PK_KEYS][nX][MODELO_PK_VALUE]
				Next nX
				dbSelectArea(cAlias)
				dbSetOrder(nIndice)
				If !lFilial .And. "_FILIAL" $ (cAlias)->(IndexKey())
					cPK := xFilial(cAlias)+cPK
				EndIf
				
				//--------------------------------------------------------------------
				// Posiciono na chave primaria
				//--------------------------------------------------------------------	
					
				dbSelectArea(cAlias)
				dbSetOrder(nIndice)
				If !MsSeek(cPK)
					SetSoapFault("NTWSBROWSER:PUTXMLDATA","Primary key ("+cPK+") not found!")
					lRet	:= .F.
					::lOk	:= .F.								
				EndIf
				
			EndIf
			
			If lRet
			
				//---------------------------------------------------
				// Carrega os dados
				//---------------------------------------------------
				
				::MODELXML := oModel:LoadXMLData(::ModelXML)
				If oModel:VldData()
					oModel:CommitData()
					::lOk := .T.
				Else
					lRet	:= .F.
					::lOk	:= .F.
					aError	:= oModel:GetErrorMessage()			
					SetSoapFault(aError[MODEL_MSGERR_IDFORM]+":"+aError[MODEL_MSGERR_IDFIELD]+":"+aError[MODEL_MSGERR_IDFORMERR]+":"+aError[MODEL_MSGERR_IDFIELDERR]+":"+aError[MODEL_MSGERR_ID],aError[MODEL_MSGERR_MESSAGE]+"/"+aError[MODEL_MSGERR_SOLUCTION])
				EndIf
				
			EndIf
		Else
			SetSoapFault("NTWSBROWSER:PUTXMLDATA","ModelXML Schema: "+cError+" "+cWarning)
			lRet	:= .F.
			::lOk	:= .F.
		EndIf
	Else
		SetSoapFault("NTWSBROWSER:PUTXMLDATA","Invalid ModelId!")
		lRet	:= .F.
		::lOk	:= .F.
	EndIf

Return(lRet)

/*/{Protheus.doc} GetXSD
Retorna o XSD para operações.
@author Marco Aurelio Braga
@since 10/12/2015
/*/

WSMETHOD GetXSD WSRECEIVE MethodWS WSSEND ModelXSD WSSERVICE NTWSBROWSER

	Local lRet := .T.

	Do Case
		Case (Upper(::MethodWS) == "SETVALREG")
			::ModelXSD := fXSDSVR("XSD") 
		Case (Upper(::MethodWS) == "RUNFUNERP")
			::ModelXSD := fXSDRFE("XSD")
		Case (Upper(::MethodWS) == "PUTXMLDATA")
			::ModelXSD := fXSDPXD("XSD")
		OtherWise
			SetSoapFault("NTWSBROWSER:GetXSD", "Nome do MethodWS invalido!")
			lRet := .F.
	EndCase

Return(lRet)

/*/{Protheus.doc} GetXML
Retorna o XML para operações.
@author Marco Aurelio Braga
@since 10/12/2015
/*/

WSMETHOD GetXML WSRECEIVE MethodWS WSSEND ModelXML WSSERVICE NTWSBROWSER

	Local lRet := .T.

	Do Case
		Case (Upper(::MethodWS) == "SETVALREG")
			::ModelXML := fXSDSVR("XML") 
		Case (Upper(::MethodWS) == "RUNFUNERP")
			::ModelXML := fXSDRFE("XML")
		Case (Upper(::MethodWS) == "PUTXMLDATA")
			::ModelXML := fXSDPXD("XML")
		OtherWise
			SetSoapFault("NTWSBROWSER:GetXSD", "Nome do MethodWS invalido!")
			lRet := .F.
	EndCase

Return(lRet)

/*/{Protheus.doc} SetValReg
Edita valor de campos de um registro
@author Marco Aurelio Braga
@since 10/12/2015
/*/

WSMETHOD SetValReg WSRECEIVE Table, Index, Key, ModelXML, Usr, Psw, Emp, Fil  WSSEND lOk WSSERVICE NTWSBROWSER

	Local lRet		:= .T.
	Local nInd		:= 0
	Local cError	:= ""
	Local cWarning	:= ""
	Local cField	:= ""
	Local cValue	:= ""
	Local oXml		:= Nil
	Local cAlias	:= ::Table
	
	// Valida Atributos		
	Do Case
		Case (Empty(::Table))
			cError := "Tabela não informada!"
		Case (Empty(::Index))
			cError := "Indice não informado!"
		Case (Empty(::Key))
			cError := "Chave não informada!"
		Case (Empty(::ModelXML))
			cError := "XML de dados não informado!"
		Case (Empty(::Usr) .OR. Empty(::Psw))
			cError := "Login ou senha não informados!"
		Case (Empty(::Emp) .OR. Empty(::Fil))
			cError := "Empresa ou Filial não informados!"
	EndCase
	
	If !Empty(cError)
		SetSoapFault("NTWSBROWSER:SetValReg",cError)
		lRet	:= .F.
		::lOk	:= .F.
		Return(lRet)
	Endif
	
	// Valida Login/Senha
	If !fVldPsw(Usr, Psw)
		SetSoapFault("NTWSBROWSER:SetValReg","Erro de acesso: Login ou senha inválidos!")
		lRet	:= .F.
		::lOk	:= .F.
		Return(lRet)
	Endif
	
	// Inicializa Ambiente	
	RESET ENVIRONMENT
	
	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA Emp FILIAL Fil MODULO "SIGAFAT"
	Endif

	// Seta o modo de compatibilidade com o Protheus
	SetCompP10(.T.)
	
	// Valida o schema
	MemoWrit(GetPathSemaforo()+"SetValReg.xsd",fXSDSVR("XSD"))
	XmlSVldSchema(::ModelXML,GetPathSemaforo()+"SetValReg.xsd",@cError,@cWarning)
	fErase("SetValReg.xsd")
	
	If !Empty(cError) .OR. !Empty(cWarning)
		SetSoapFault("NTWSBROWSER:SetValReg","Schema: "+cError+" "+cWarning)
		lRet	:= .F.
		::lOk	:= .F.
		Return(lRet)
	Endif
	
	// Valida XML
	oXml	:= XmlParser( ::ModelXML, "_", @cError, @cWarning )
	
	If !Empty(cError) .OR. !Empty(cWarning) .OR. oXml == Nil
		SetSoapFault("NTWSBROWSER:SetValReg","XML: "+cError+" "+cWarning)
		lRet	:= .F.
		::lOk	:= .F.
		Return(lRet)
	Endif
	
	// Valida registro
	DbSelectArea(cAlias)
	(cAlias)->(DbSetOrder(::Index))
	If (cAlias)->(!DbSeek(::Key))
		SetSoapFault("NTWSBROWSER:SetValReg","Registro não encontrado!")
		lRet	:= .F.
		::lOk	:= .F.
		Return(lRet)
	Endif

	// Altera campos do registro
	Begin Transaction

	(cAlias)->(RecLock(cAlias,.F.))
	
	If ValType(oXml:_Fields:_Field) == "A"	
		For nInd := 1 To Len(oXml:_Fields:_Field)		
			cField := oXml:_Fields:_Field[nInd]:_FieldId:Text 
			cValue := oXml:_Fields:_Field[nInd]:_Value:Text
	
			If (cAlias)->(FieldPos(cField)) < 1
				DisarmTransaction()
				SetSoapFault("NTWSBROWSER:SetValReg","Field "+cField+" doesn`t exist!")
				lRet	:= .F.
				::lOk	:= .F.
				Return(lRet)
			Endif
			
			Do Case
				Case ValType((cAlias)->(&cField)) == "N"
					(cAlias)->(&cField) := Val(cValue)
				Case ValType((cAlias)->(&cField)) == "D"
					(cAlias)->(&cField) := STOD(cValue)
				OtherWise
					(cAlias)->(&cField) := cValue
			EndCase				
		Next nInd
	Else
		cField := oXml:_Fields:_Field:_FieldId:Text 
		cValue := oXml:_Fields:_Field:_Value:Text

		If (cAlias)->(FieldPos(cField)) < 1
			DisarmTransaction()
			SetSoapFault("NTWSBROWSER:SetValReg","Field "+cField+" doesn`t exist!")
			lRet	:= .F.
			::lOk	:= .F.
			Return(lRet)
		Endif
		
		Do Case
			Case ValType((cAlias)->(&cField)) == "N"
				(cAlias)->(&cField) := Val(cValue)
			Case ValType((cAlias)->(&cField)) == "D"
				(cAlias)->(&cField) := STOD(cValue)
			OtherWise
				(cAlias)->(&cField) := cValue
		EndCase
	Endif
	
	(cAlias)->(MsUnLock())
	
	End Transaction

	::lOk	:= .T.
	
Return(lRet)

/*/{Protheus.doc} RunFunERP
Executa funcao dentro do ERP
@author Marco Aurelio Braga
@since 10/12/2015
/*/

WSMETHOD RunFunERP WSRECEIVE ModelXML, Usr, Psw, Emp, Fil WSSEND lOk WSSERVICE NTWSBROWSER

	Local lRet		:= .T.
	Local nInd		:= 0
	Local cError	:= ""
	Local cWarning	:= ""
	Local cFunc		:= ""
	Local cSource	:= ""
	Local cType		:= ""
	Local cExec		:= ""
	Local oXml		:= Nil
	
	Private aPar	:= {}
	
	// Valida Atributos		
	Do Case
		Case (Empty(::ModelXML))
			cError := "XML de dados não informado!"
		Case (Empty(::Usr) .OR. Empty(::Psw))
			cError := "Login ou senha não informados!"
		Case (Empty(::Emp) .OR. Empty(::Fil))
			cError := "Empresa ou Filial não informados!"
	EndCase
	
	If !Empty(cError)
		SetSoapFault("NTWSBROWSER:RunFunERP",cError)
		lRet	:= .F.
		::lOk	:= .F.
		Return(lRet)
	Endif
	
	// Valida Login/Senha
	If !fVldPsw(Usr, Psw)
		SetSoapFault("NTWSBROWSER:RunFunERP","Erro de acesso: Login ou senha inválidos!")
		lRet	:= .F.
		::lOk	:= .F.
		Return(lRet)
	Endif
	
	// Inicializa Ambiente	
	RESET ENVIRONMENT
	
	If Select("SX6") == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA Emp FILIAL Fil MODULO "SIGAFAT"
	Endif

	// Seta o modo de compatibilidade com o Protheus
	SetCompP10(.T.)
	
	// Valida o schema
	MemoWrit(GetPathSemaforo()+"RunFunERP.xsd",fXSDRFE("XSD"))
	XmlSVldSchema(::ModelXML,GetPathSemaforo()+"RunFunERP.xsd",@cError,@cWarning)
	fErase("RunFunERP.xsd")
	
	If !Empty(cError) .OR. !Empty(cWarning)
		SetSoapFault("NTWSBROWSER:RunFunERP","Schema: "+cError+" "+cWarning)
		lRet	:= .F.
		::lOk	:= .F.
		Return(lRet)
	Endif
	
	// Valida XML
	oXml	:= XmlParser( ::ModelXML, "_", @cError, @cWarning )
	
	If !Empty(cError) .OR. !Empty(cWarning) .OR. oXml == Nil
		SetSoapFault("NTWSBROWSER:RunFunERP","XML: "+cError+" "+cWarning)
		lRet	:= .F.
		::lOk	:= .F.
		Return(lRet)
	Endif
	
	// Executa funcao
	Begin Transaction
	
	cFunc	:= oXml:_Function:_Name:Text
	cSource	:= oXml:_Function:_Source:Text
	cType	:= oXml:_Function:_Type:Text
	
	If ValType(oXml:_Function:_Parameters:_Parameter) == "A"	
		For nInd := 1 To Len(oXml:_Function:_Parameters:_Parameter)				
			aAdd(aPar, {oXml:_Function:_Parameters:_Parameter[nInd]:_Value:Text, oXml:_Function:_Parameters:_Parameter[nInd]:_Type:Text})			
		Next nInd
	Else
		aAdd(aPar, {oXml:_Function:_Parameters:_Parameter:_Value:Text, oXml:_Function:_Parameters:_Parameter:_Type:Text})
	Endif
	
	If cType $ "1/2"
		cExec := cFunc + "("
	Else
		cExec := "StaticCall(" + cSource + ", " + cFunc + IIF(Empty(aPar), "", ", ")
	Endif
	
	For nInd := 1 To Len(aPar)
		Do Case
			Case aPar[nInd,2] == "N"
				cExec += "Val(aPar["+cValToChar(nInd)+",1])"
			Case aPar[nInd,2] == "D"
				cExec += "STOD(aPar["+cValToChar(nInd)+",1])"
			Case aPar[nInd,2] == "L"
				cExec += "&(aPar["+cValToChar(nInd)+",1])"
			Case aPar[nInd,2] == "B"
				cExec += "&(aPar["+cValToChar(nInd)+",1])"
			OtherWise
				cExec += "aPar["+cValToChar(nInd)+",1]"
		EndCase
		If nInd < Len(aPar)
			cExec += ", "
		Endif
	Next nInd
	
	cExec += ")"
	&(cExec)
	
	End Transaction

	::lOk	:= .T.
	
Return(lRet)

/*/{Protheus.doc} fVldPsw
Validacao da senha do usuario
@author Marco Aurelio Braga
@since 10/12/2015
/*/

Static Function fVldPsw(cUsr, cPsw)

	Local lRet := .T.

	PswOrder(1)
	If PswSeek(cUsr,.T.)
		If PswName(cPsw)
			lRet := .T.
		Else
			lRet := .F.
		EndIf
	Else
		lRet := .F.
	Endif

Return(lRet)

/*
========================================================================================================================
Rotina----: NTCampoWeb
Autor-----: Alexandre Villar
Data------: 26/07/2016
========================================================================================================================
Descrição-: Rotina que verifica se a tabela informada utiliza a configuração customizada de campos para exibição
========================================================================================================================
*/

Static Function NTCampoWeb( _cTabela )

Local _lRet := .F.

If AliasInDic('ZP0')

	DBSelectArea('ZP0')
	ZP0->( DBSetOrder(1) )
	If ZP0->( DBSeek( xFilial('ZP0') + _cTabela ) )
		
		If ZP0->ZP0_ATIVO == 'S'
			_lRet := .T.
		EndIf
		
	EndIf

EndIf

Return( _lRet )

/*/{Protheus.doc} fXSDSVR
Retorna XSD/XML para para metodo SetValReg
@author Marco Aurelio Braga
@since 10/12/2015
/*/

Static Function fXSDSVR(cPar)

	Local cRet	:= ""

	If cPar == "XSD"
		cRet := '<?xml version="1.0" encoding="UTF-8"?>
		cRet += '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified" attributeFormDefault="unqualified">
		cRet += '       <xs:element name="Fields">
		cRet += '              <xs:complexType>
		cRet += '                     <xs:sequence>
		cRet += '                            <xs:element name="Field" maxOccurs="unbounded">
		cRet += '                                   <xs:complexType>
		cRet += '                                          <xs:sequence>
		cRet += '                                                 <xs:element name="FieldID" type="xs:string"></xs:element>
		cRet += '                                                 <xs:element name="Value" type="xs:string"></xs:element>
		cRet += '                                           </xs:sequence>
		cRet += '                                      </xs:complexType>
		cRet += '                               </xs:element>
		cRet += '                        </xs:sequence>
		cRet += '                 </xs:complexType>
		cRet += '          </xs:element>
		cRet += '   </xs:schema>
	ElseIf  cPar == "XML"
		cRet := '<?xml version="1.0" encoding="utf-8"?>
		cRet += '<Fields>
		cRet += '  <Field>
		cRet += '    <FieldID>str1234</FieldID>
		cRet += '    <Value>str1234</Value>
		cRet += '  </Field>
		cRet += '</Fields>
	Endif

Return(cRet)

/*/{Protheus.doc} fXSDRFE
Retorna XSD/XML para para metodo RunFunERP
@author Marco Aurelio Braga
@since 10/12/2015
/*/

Static Function fXSDRFE(cPar)

	Local cRet	:= ""

	If cPar == "XSD"
		cRet := '<?xml version="1.0" encoding="UTF-8"?>
		cRet += '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified" attributeFormDefault="unqualified">
		cRet += '       <xs:element name="Function">
		cRet += '              <xs:complexType>
		cRet += '                     <xs:sequence>
		cRet += '                            <xs:element name="Source" type="xs:string"></xs:element>
		cRet += '                            <xs:element name="Type">
		cRet += '								<xs:simpleType>
		cRet += '									<xs:annotation>
		cRet += '										<xs:documentation>Tipo de funcao: 1 - Function 2 - User Function 3 - Static Function</xs:documentation>
		cRet += '									</xs:annotation>
		cRet += '									<xs:restriction base="xs:string">
		cRet += '										<xs:whiteSpace value="preserve"/>
		cRet += '										<xs:enumeration value="1"/>
		cRet += '										<xs:enumeration value="2"/>
		cRet += '										<xs:enumeration value="3"/>
		cRet += '									</xs:restriction>							
		cRet += '								</xs:simpleType>
		cRet += '							</xs:element>
		cRet += '                            <xs:element name="Name" type="xs:string"></xs:element>
		cRet += '                            <xs:element name="Parameters">
		cRet += '                                   <xs:complexType>
		cRet += '                                          <xs:sequence>
		cRet += '                                                 <xs:element name="Parameter" maxOccurs="unbounded">
		cRet += '                                                        <xs:complexType>
		cRet += '                                                               <xs:sequence>
		cRet += '                                                                      <xs:element name="Type">
		cRet += '																			<xs:simpleType>
		cRet += '																				<xs:annotation>
		cRet += '																					<xs:documentation>Tipo de dado: C - Caracter, D - Data, N - Numerico, L - Logico, B - Bloco</xs:documentation>
		cRet += '																				</xs:annotation>
		cRet += '																				<xs:restriction base="xs:string">
		cRet += '																					<xs:whiteSpace value="preserve"/>
		cRet += '																					<xs:enumeration value="C"/>
		cRet += '																					<xs:enumeration value="D"/>
		cRet += '																					<xs:enumeration value="N"/>
		cRet += '																					<xs:enumeration value="L"/>
		cRet += '																					<xs:enumeration value="B"/>
		cRet += '																				</xs:restriction>
		cRet += '																			</xs:simpleType>
		cRet += '																	  </xs:element>
		cRet += '                                                                      <xs:element name="Value" type="xs:string"></xs:element>
		cRet += '                                                                  </xs:sequence>
		cRet += '                                                           </xs:complexType>
		cRet += '                                                    </xs:element>
		cRet += '                                             </xs:sequence>
		cRet += '                                      </xs:complexType>
		cRet += '                               </xs:element>
		cRet += '                        </xs:sequence>
		cRet += '                 </xs:complexType>
		cRet += '          </xs:element>
		cRet += '   </xs:schema>'
	ElseIf cPar == "XML"
		cRet := '<?xml version="1.0" encoding="utf-8"?>
		cRet += '<Function>
		cRet += '  <Source>str1234</Source>
		cRet += '  <Type>1</Type>
		cRet += '  <Name>str1234</Name>
		cRet += '  <Parameters>
		cRet += '    <Parameter>
		cRet += '      <Type>C</Type>
		cRet += '      <Value>str1234</Value>
		cRet += '    </Parameter>
		cRet += '  </Parameters>
		cRet += '</Function>
	Endif
	
Return(cRet)


/*/{Protheus.doc} fXSDRFE
Retorna XSD/XML para para metodo PutXMLDATA / ModelPAR
@author Marco Aurelio Braga
@since 10/12/2015
/*/

Static Function fXSDPXD(cPar)

	Local cRet	:= ""

	If cPar == "XSD"
		cRet += '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified" attributeFormDefault="unqualified">
		cRet += '       <xs:element name="Parameters">
		cRet += '              <xs:complexType>
		cRet += '                     <xs:sequence>
		cRet += '                            <xs:element name="Parameter" maxOccurs="unbounded">
		cRet += '                                   <xs:complexType>
		cRet += '                                          <xs:sequence>
		cRet += '                                                    <xs:element name="Type">
		cRet += '														<xs:simpleType>
		cRet += '															<xs:annotation>
		cRet += '																<xs:documentation>Tipo de dado: C - Caracter, D - Data, N - Numerico, L - Logico, B - Bloco</xs:documentation>
		cRet += '															</xs:annotation>
		cRet += '															<xs:restriction base="xs:string">
		cRet += '																<xs:whiteSpace value="preserve"/>
		cRet += '																<xs:enumeration value="C"/>
		cRet += '																<xs:enumeration value="D"/>
		cRet += '																<xs:enumeration value="N"/>
		cRet += '																<xs:enumeration value="L"/>
		cRet += '																<xs:enumeration value="B"/>
		cRet += '															</xs:restriction>
		cRet += '														</xs:simpleType>
		cRet += '													 </xs:element>
		cRet += '                                                 <xs:element name="Value"></xs:element>
		cRet += '                                             </xs:sequence>
		cRet += '                                      </xs:complexType>
		cRet += '                               </xs:element>
		cRet += '                        </xs:sequence>
		cRet += '                 </xs:complexType>
		cRet += '          </xs:element>
		cRet += '   </xs:schema>
	ElseIf cPar == "XML"
		cRet := '<?xml version="1.0" encoding="utf-8"?>
		cRet += '<Parameters>
  		cRet += '  <Parameter>
		cRet += '    <Type></Type>
		cRet += '    <Value></Value>
		cRet += '  </Parameter>
		cRet += '</Parameters>
	Endif
	
Return(cRet)