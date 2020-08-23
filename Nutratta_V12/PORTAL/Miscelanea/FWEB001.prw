#INCLUDE "TOTVS.CH"                 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH" 

/*/{Protheus.doc} FWEB001
// Faz envio de e-mail
@author Marco Aurélio Braga - Nelltech Gestão de TI
@since 16/03/2016
@version 1.0
@type function
@param cSubject, string, Assunto do e-mail
@param cBody, string, Corpo do e-mail
@param cTo, string, E-mail do destinatario
@param cCC, string, E-mail em copia
@param cCO, string, E-mail em copia oculta
@param cAttach, string, Url do arquivo de anexo
@param cSource, string, Função de origem
@return logico, Informa se conseguiu enviar o e-mail
/*/

User Function FWEB001(cSubject, cBody, cTo, cCC, cCO, cAttach, cSource)

	Local cServer		:= AllTrim(GetMv("MV_RELSERV",," "))
	Local cAccount		:= AllTrim(GetMv("MV_RELACNT",," "))
	Local cPassword		:= AllTrim(GetMv("MV_RELPSW",," "))
	Local cUserAut		:= AllTrim(cAccount)				// Usuario para Autenticação no Servidor de Email
	Local cPassAut		:= AllTrim(cPassword)				// Senha para Autenticação no Servidor de Email
	Local nTimeOut		:= GetMv("MV_RELTIME",,120)			// Tempo de Espera antes de abortar a Conexao
	Local lAutentica	:= GetMv("MV_RELAUTH",,.F.)			// Determina se o Servidor de Email necessita de Autenticação
	Local cMailTst		:= GetMv("NT_TWFCRM",.T.,"")		// E-Mail de teste de envio do processo de CRM
	Local cFrom			:= AllTrim(SM0->M0_NOME)+"<"+AllTrim(GetMv("MV_RELACNT",," "))+">"
	Local lOk			:= .F.
	Local lRet			:= .T.
	
	Default cSubject	:= ""
	Default cBody		:= ""
	Default cTo			:= ""
	Default cCC			:= ""
	Default cCO			:= ""
	Default cAttach		:= ""
	Default cSource		:= FunName()
	
	If Empty(cTo) .AND. Empty(cCC) .AND. Empty(cCO)
		ConOut(cSource + "  |  MAIL TO => Destinatario nulo!")
		Return(.F.)	
	Endif
	
	If !Empty(cMailTst)
		cTo := cMailTst
	Endif
	
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword TIMEOUT nTimeOut Result lOk

	If lOk
		If lAutentica
			If !MailAuth(cUserAut,cPassAut)
				ConOut(cSource + "  |  MAIL AUTHENTICATION => Erro de autenticacao!")
				lRet := .F.
			Endif
		Endif

		If lRet
			SEND MAIL FROM cFrom TO cTo CC cCC BCC cCO SUBJECT cSubject BODY cBody ATTACHMENT cAttach RESULT lOk
	
			If !lOk
				Get MAIL ERROR cErrorMsg
				ConOut(cSource + "  |  MAIL SEND => "+cErrorMsg)
				lRet := .F.
			Endif
		Endif
	Else
		Get MAIL ERROR cErrorMsg
		ConOut(cSource + "  |  MAIL CONNECT => "+cErrorMsg)
		lRet := .F.
	Endif

	DISCONNECT SMTP SERVER RESULT lOk

	If !lOk
		Get MAIL ERROR cErrorMsg
		ConOut(cSource + "  |  MAIL DISCONNECT => "+cErrorMsg)
	Endif

Return(lRet)