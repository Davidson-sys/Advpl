#Include 'Protheus.ch'
#Include 'Topconn.ch'
//Fonte que valida no cadastro do cliente se o DDD digitado está no formato: 062
User Function A1DDD()
	Local lRet	:= .T.
	IF Len(AllTrim(M->A1_DDD)) < 3
		MsgInfo("Preencha corretamente o campo DDD. Ex.:062!")
		lRet := .F.
	Endif
Return(lRet)

