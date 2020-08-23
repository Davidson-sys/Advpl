#Include 'Protheus.ch'
#Include 'TopConn.ch'

//POLIESTER MOREIRA - CHAUS - 31/07/2017
//Ponto de Entrada na geração do Contrato Carreteiro, retorna .T. ou .F. para seguir adiante ou não com a geração do Contrato Carreteiro.
//Motivo: Gerar os títulos referentes aos contratos carreteiros para PF de maneira correta no financeiro. Obs.: O sistema já gerava os títulos,
//mas os usuários não estavam preenchendo os cadastros corretamente. Com esse PE o sistema apresenta uma mensagem indicando quais são os campos
//e qual é o formato correto de preenchimento.

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
	
	//Agora já tenho o código do fornecedor, vou verificar se o cadastro dele está correto. 
	//Motivo?	1) Geração dos títulos no financeiro de maneira correta
	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	If SA2->(DbSeek(xFilial("SA2")+cCodFor+cLojFor))
		If SA2->A2_TIPO == "F" //Precisa ser igual a F - Físico porque não se recolhem impostos (INSS+SESTSENAT) para PJ.
			cMsg := "Atenção, existem campos que precisam ser preenchidos no cadastro do fornecedor: "+cCodFor+" - "+cLojFor+", proprietário do veículo: "+cCodVei+CHR(13)+CHR(10)
			If Empty(Alltrim(SA2->A2_NATUREZ)) //Nao pode estar em branco
				cMsg += "- O campo Natureza não pode estar em branco."+CHR(13)+CHR(10)
				lRet := .F.
			Endif
			If Empty(Alltrim(SA2->A2_COND)) //Nao pode estar em branco
				cMsg += "- O campo Cond. Pagto não pode estar em branco."+CHR(13)+CHR(10)
				lRet := .F.
			Endif
			If SA2->A2_RECINSS <> "S" //Precisa ser igual a "S"
				cMsg += "- O campo Calc.INSS precisa estar preenchido com o conteúdo 'Sim'."+CHR(13)+CHR(10)
				lRet := .F.
			Endif
			If SA2->A2_RECSEST <> "1" //Precisa ser igual a "1" - Sim
				cMsg += "- O campo Recolhe SEST precisa estar preenchido com o conteúdo 'Sim'."+CHR(13)+CHR(10)
				lRet := .F.
			Endif
			If Empty(SA2->A2_CODINSS) //Não pode estar em branco
				cMsg += "- O campo Cód.INSS não pode estar em branco."+CHR(13)+CHR(10)
				lRet := .F.
			Endif
			If Empty(Alltrim(SA2->A2_RNTRC)) //Não pode estar em branco
				cMsg += "- O campo RNTRC não pode estar em branco."+CHR(13)+CHR(10)
				lRet := .F.
			Endif
		Endif
	Endif
	
	If !lRet
		MsgInfo(cMsg)
	Endif

Return lRet
