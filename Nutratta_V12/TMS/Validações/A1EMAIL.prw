#Include 'Protheus.ch'
//Fonte que valida se o e-mail digitado no cadstro do cliente é válido.
//O usuario pode digitar, por exemplo: a@a.com, logo o tamanho mínimo aceitável é: 7 caracteres e é obrigatório ter o @
//O campo deve ser obrigatório, ainda que o usuário tenha que digitar algum e-mail próprio da Nutratta. O recomendado é que a Nutratta tenha
//uma conta de e-mail para armazenar o XML enviado pelo TSS para os casos onde o cliente não tiver e-mail. É bom lembrar que, além de armazenados
//nas tabelas SPED*** os XML´s precisam ser guardados em outro lugar por, pelo menos, cinco anos. 

User Function A1EMAIL()
	Local lRet	:= .T.
	If Len(Alltrim(M->A1_EMAIL)) < 7 .OR. !(ISEMAIL(M->A1_EMAIL))
		MsgInfo("Preencha corretamente o campo EMAIL. Ex.: nome@dominio.com.br")
		lRet := .F.
	Endif
Return(lRet)

