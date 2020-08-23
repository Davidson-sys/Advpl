#Include 'Protheus.ch'
//Fonte que valida se o e-mail digitado no cadstro do cliente � v�lido.
//O usuario pode digitar, por exemplo: a@a.com, logo o tamanho m�nimo aceit�vel �: 7 caracteres e � obrigat�rio ter o @
//O campo deve ser obrigat�rio, ainda que o usu�rio tenha que digitar algum e-mail pr�prio da Nutratta. O recomendado � que a Nutratta tenha
//uma conta de e-mail para armazenar o XML enviado pelo TSS para os casos onde o cliente n�o tiver e-mail. � bom lembrar que, al�m de armazenados
//nas tabelas SPED*** os XML�s precisam ser guardados em outro lugar por, pelo menos, cinco anos. 

User Function A1EMAIL()
	Local lRet	:= .T.
	If Len(Alltrim(M->A1_EMAIL)) < 7 .OR. !(ISEMAIL(M->A1_EMAIL))
		MsgInfo("Preencha corretamente o campo EMAIL. Ex.: nome@dominio.com.br")
		lRet := .F.
	Endif
Return(lRet)

