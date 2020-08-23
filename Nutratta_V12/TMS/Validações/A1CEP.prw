#Include 'Protheus.ch'
#Include 'Topconn.ch'
//Fonte que valida se o CEP digitado no cadastro do cliente est� correto com rela��o � quantidade de d�gitos.
User Function A1CEP()
Local lRet	:= .T.
	If Len(Alltrim(M->A1_CEP)) < 8
		MsgInfo("Preencha corretamente o campo CEP. Ex.: 75500-000.")
		lRet := .F.
	Endif
Return(lRet)

