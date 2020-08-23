#Include 'Protheus.ch'
#Include 'TopConn.ch'

//POLIESTER MOREIRA - CHAUS - 31/07/2017
//Ponto de Entrada na gera��o do Contrato Carreteiro, retorna .T. ou .F. para seguir adiante ou n�o com a gera��o do Contrato Carreteiro.
//Motivo: Gerar os t�tulos referentes aos contratos carreteiros para PF de maneira correta no financeiro. Obs.: O sistema j� gerava os t�tulos,
//mas os usu�rios n�o estavam preenchendo os cadastros corretamente. Com esse PE o sistema apresenta uma mensagem indicando quais s�o os campos
//e qual � o formato correto de preenchimento.

User Function TMA250FIL()
	Local cFilOri   := PARAMIXB[1]               
	Local cViagem   := PARAMIXB[2]
	Local nOpcx     := PARAMIXB[3]
	Local lRet 		:= .T.
	Local cCodVei	:= ""
	Local cCodFor	:= ""
	Local cLojFor	:= ""
	
	//Posicionar na DTR para pegar a placa usada na viagem
	cCodVei := Posicione("DTR",1,xFilial("DTR")+xFilial("DTR")+cViagem,"DTR_CODVEI")
	
	//Posicionar na DA3 para pegar o codigo e a loja do dono do veiculo
	cCodFor	:= Posicione("DA3",1,xFilial("DA3")+cCodVei,"DA3_CODFOR")
	cLojFor	:= Posicione("DA3",1,xFilial("DA3")+cCodVei,"DA3_LOJFOR")
	
	//Agora j� tenho o c�digo do fornecedor, vou verificar se o cadastro dele est� correto. 
	//Motivo?	1) Gera��o dos t�tulos no financeiro de maneira correta
	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	If SA2->(DbSeek(xFilial("SA2")+cCodFor+cLojFor))
		If SA2->A2_TIPO == "F" //Precisa ser igual a F - F�sico porque n�o se recolhem impostos (INSS+SESTSENAT) para PJ.
			cMsg := "Aten��o, existem campos que precisam ser preenchidos no cadastro do fornecedor: "+cCodFor+" - "+cLojFor+", propriet�rio do ve�culo: "+cCodVei+CHR(13)+CHR(10)
			If Empty(Alltrim(SA2->A2_NATUREZ)) //Nao pode estar em branco
				cMsg += "- O campo Natureza n�o pode estar em branco."+CHR(13)+CHR(10)
				lRet := .F.
			Endif
			If Empty(Alltrim(SA2->A2_COND)) //Nao pode estar em branco
				cMsg += "- O campo Cond. Pagto n�o pode estar em branco."+CHR(13)+CHR(10)
				lRet := .F.
			Endif
			If SA2->A2_RECINSS <> "S" //Precisa ser igual a "S"
				cMsg += "- O campo Calc.INSS precisa estar preenchido com o conte�do 'Sim'."+CHR(13)+CHR(10)
				lRet := .F.
			Endif
			If SA2->A2_RECSEST <> "1" //Precisa ser igual a "1" - Sim
				cMsg += "- O campo Recolhe SEST precisa estar preenchido com o conte�do 'Sim'."+CHR(13)+CHR(10)
				lRet := .F.
			Endif
			If Empty(SA2->A2_CODINSS) //N�o pode estar em branco
				cMsg += "- O campo C�d.INSS n�o pode estar em branco."+CHR(13)+CHR(10)
				lRet := .F.
			Endif
			If Empty(Alltrim(SA2->A2_RNTRC)) //N�o pode estar em branco
				cMsg += "- O campo RNTRC n�o pode estar em branco."+CHR(13)+CHR(10)
				lRet := .F.
			Endif
		Endif
	Endif
	
	If !lRet
		MsgInfo(cMsg)
	Endif

Return lRet
