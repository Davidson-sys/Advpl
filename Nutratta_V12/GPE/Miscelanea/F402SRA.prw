#INCLUDE 'PROTHEUS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ F402SRA  ³ Autor ³ Nelltech Gestao de TI ³ Data ³10/10/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada no fonte FINA402A.prx (Gera Dados Fin.)   ³±±
±±³			 ³ Permite inserir informacoes a mais na SRA 			 	  ³±±
±±³			 ³ (Cadastro de Colaboradores/Autonomos) ao integrar titulos  ³±±
±±³			 ³ de autonomos.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ SIGAGPE Nutratta					                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nelltech Gestao de TI ³ Lucas Lima									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F402SRA()

	Local aAreaSA2 := SA2->(GetArea())

	If AllTrim(FunName()) == "FINA402A"
		DbSelectArea("SA2")
		SA2->(DbSetOrdeR(3))
		If SA2->(DbSeek(xFilial("SA2") + SRA->RA_CIC ))
			RecLock('SRA',.F.)
			If Empty(SRA->RA_PIS)
				SRA->RA_PIS 	:= SA2->A2_N_PIS
			EndIf
			If Empty(SRA->RA_NUMCP)
				SRA->RA_NUMCP	:= '9999999999'
			EndIf
			If Empty(SRA->RA_SERCP)
				SRA->RA_SERCP 	:= '99999'
			EndIf
			If Empty(SRA->RA_NACIONA)
				SRA->RA_NACIONA := '10'
			EndIf
			If Empty(SRA->RA_HRSMES)
				SRA->RA_HRSMES 	:= 220
			EndIf
			If Empty(SRA->RA_HRSEMAN)
				SRA->RA_HRSEMAN := 44
			EndIf
			If Empty(SRA->RA_TNOTRAB)
				SRA->RA_TNOTRAB := '999'
			EndIf
//			If Empty(			
//				SRA->RA_CODFUNC := '00009'
//			EndIf
			If Empty(SRA->RA_COMPSAB)
				SRA->RA_COMPSAB := '2'
			EndIf
			If Empty(SRA->RA_HOPARC)
				SRA->RA_HOPARC	:= '2'
			EndIf
			If Empty(SRA->RA_ADTPOSE)
				SRA->RA_ADTPOSE := '***N**'
			EndIf
			If Empty(SRA->RA_TIPOADM)
				SRA->RA_TIPOADM := '9B'
			EndIf
			If Empty(SRA->RA_VIEMRAI)
				SRA->RA_VIEMRAI := '10'
			EndIf
			If Empty(SRA->RA_GRINRAI)
				SRA->RA_GRINRAI := '45'
			EndIf
			If Empty(SRA->RA_INSSSC)
				SRA->RA_INSSSC 	:= 'S'
			EndIf
			If Empty(SRA->RA_NACIONC)
				SRA->RA_NACIONC := '01058'
			EndIf
			If Empty(SRA->RA_NATURAL)
				SRA->RA_NATURAL := SA2->A2_ESTADO
			EndIf
			If Empty(SRA->RA_ESTCIVI)
				SRA->RA_ESTCIVI := 'S'
			EndIf
			If Empty(SRA->RA_SEXO)
				SRA->RA_SEXO 	:= 'M'
			EndIf
			If Empty(SRA->RA_OPCAO)
				SRA->RA_OPCAO 	:= CToD("01/"+StrZero(Month(dDataBase),2)+"/"+StrZero(Year(dDataBase),4))
			EndIf
			SRA->RA_TIPOPGT := 'S'
			SRA->(MsUnLock())
		EndIf
	EndIf
	
	//restaura SA2
	SA2->(RestArea(aAreaSA2))

Return Nil