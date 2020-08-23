#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NPFAT03 º Autor ³ Nelltech Gestao de TI º Data ³ 22/07/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao executada no gatilho do campo C5_CONDPAG para       º±±
±±º          ³ preencher o campo C5_C_ENCFI-Encargo Financeiro            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Numerico			                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vendas - Nutratta                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºNelltech Gestao de TI ³ Lucas Lima		                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NPFAT03()

Local aArea		:= GetArea()
Local aAreaSE4	:= SE4->(GetArea())
Local nIndice	:= 0
Local nIndAtual	:= 0
Local cCondPag	:= M->C5_CONDPAG
Local cDiasCond := Posicione("SE4",1,xFilial("SE4")+cCondPag,"E4_COND")
Local cTipCond	:= Posicione("SE4",1,xFilial("SE4")+cCondPag,"E4_TIPO")
Local aDias		:= {}
Local nDias		:= 0
Local cData     := DToS(dDataBase)
Local lContinua := .F.
Local lData		:= .T.
Local oTButton
Local oDlgVen
Local dNewVcto1  := CToD("//")
Local dNewVcto2  := CToD("//")
Local dNewVcto3  := CToD("//")
Local dNewVcto4  := CToD("//")
Local dNewVcto5  := CToD("//")
Local dNewVcto6  := CToD("//")
Local dNewVcto7  := CToD("//")
Local dNewVcto8  := CToD("//")
Local dNewVcto9  := CToD("//")                             
Local dNewEmiss	 := ddatabase

//Gatilho para preencher a descrição da condição de pagamento.
M->C5_C_DCOND:=Posicione("SE4",1,xFilial("SE4")+cCondPag,"E4_DESCRI")

If cTipCond == "1"	//tipos de pagamentos com datas pre-definidas
	
	//monta array com datas ou data unica
	If ("," $ Alltrim(cDiasCond))
		aDias := StrToKarr(cDiasCond,",")
	Else
		nDias := Val(cDiasCond)
	EndIf
	
	//se montou array
	If nDias == 0 .And. Len(aDias)>0
		nDias := Val(aDias[Len(aDias)])
	EndIf

	//variavel logica para controle abaixo
	lContinua := .T.
	
ElseIf cTipCond == "9"	//tipos de pagamentos com datas variaveis
	
	//se vazio primeira data de vencimento, obriga preenchimento do total de dias
	If Empty(M->C5_DATA1)
	
		Aviso("Atenção","Condição de Pagamento tipo 9 = 'Data/Valor', favor preencher as datas dos pagamentos previstos.",{"OK"})

		Define MSDialog oDlgVen From 000,000 To 240,160 Title OemToAnsi("Pagamentos") Pixel
		
//			@002,002 MSGet dNewVcto Size 040,08 Pixel Of oDlgVen When .T.
//			oTButton := TButton():New(002,044,"OK",oDlgVen,{|| oDlgVen:End()},16,10,,,.F.,.T.,.F.,,.F.,,,.F.)
			@004,002 Say "Emissao ->" Size 26,10 Pixel Of oDlgVen //When .T.
			@002,036 MSGet dNewEmiss Size 040,08 Pixel Of oDlgVen When .F.
			@014,002 Say "Vencto 01 -" Size 26,10 Pixel Of oDlgVen //When .T.
			@012,036 MSGet dNewVcto1 Size 040,08 Valid(Empty(dNewVcto1) .or. dNewVcto1 >= dNewEmiss) Pixel Of oDlgVen When .T.
			@024,002 Say "Vencto 02 -" Size 26,10 Pixel Of oDlgVen //When .T.
			@022,036 MSGet dNewVcto2 Size 040,08 Valid(Empty(dNewVcto2) .or. dNewVcto2 > dNewVcto1) Pixel Of oDlgVen When .T.
			@034,002 Say "Vencto 03 -" Size 26,10 Pixel Of oDlgVen //When .T.
			@032,036 MSGet dNewVcto3 Size 040,08 Valid(Empty(dNewVcto3) .or. dNewVcto3 > dNewVcto2) Pixel Of oDlgVen When .T.
			@044,002 Say "Vencto 04 -" Size 26,10 Pixel Of oDlgVen //When .T.
			@042,036 MSGet dNewVcto4 Size 040,08 Valid(Empty(dNewVcto4) .or. dNewVcto4 > dNewVcto3) Pixel Of oDlgVen When .T.
			@054,002 Say "Vencto 05 -" Size 26,10 Pixel Of oDlgVen //When .T.
			@052,036 MSGet dNewVcto5 Size 040,08 Valid(Empty(dNewVcto5) .or. dNewVcto5 > dNewVcto4) Pixel Of oDlgVen When .F.
			@064,002 Say "Vencto 06 -" Size 26,10 Pixel Of oDlgVen //When .T.
			@062,036 MSGet dNewVcto6 Size 040,08 Valid(Empty(dNewVcto6) .or. dNewVcto6 > dNewVcto5) Pixel Of oDlgVen When .F.
			@074,002 Say "Vencto 07 -" Size 26,10 Pixel Of oDlgVen //When .T.
			@072,036 MSGet dNewVcto7 Size 040,08 Valid(Empty(dNewVcto7) .or. dNewVcto7 > dNewVcto6) Pixel Of oDlgVen When .F.
			@084,002 Say "Vencto 08 -" Size 26,10 Pixel Of oDlgVen //When .T.
			@082,036 MSGet dNewVcto8 Size 040,08 Valid(Empty(dNewVcto8) .or. dNewVcto8 > dNewVcto7) Pixel Of oDlgVen When .F.
			@094,002 Say "Vencto 09 -" Size 26,10 Pixel Of oDlgVen //When .T.
			@092,036 MSGet dNewVcto9 Size 040,08 Valid(Empty(dNewVcto9) .or. dNewVcto9 > dNewVcto8) Pixel Of oDlgVen When .F.
			oTButton := TButton():New(104,036,"OK",oDlgVen,{|| oDlgVen:End()},30,10,,,.F.,.T.,.F.,,.F.,,,.F.)
						
		Activate MSDialog oDlgVen Centered
		
		M->C5_EMISS := dNewEmiss
		M->C5_DATA1 := dNewVcto1
		M->C5_DATA2 := dNewVcto2		
		M->C5_DATA3 := dNewVcto3		
		M->C5_DATA4 := dNewVcto4
		M->C5_DATA5 := dNewVcto5
		M->C5_DATA6 := dNewVcto6
		M->C5_DATA7 := dNewVcto7
		M->C5_DATA8 := dNewVcto8
		M->C5_DATA9 := dNewVcto9
		
		Do Case
			Case !Empty(M->C5_DATA9) .And. lData
				nDias := M->C5_DATA9-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA8) .And. lData
				nDias := M->C5_DATA8-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA7) .And. lData
				nDias := M->C5_DATA7-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA6) .And. lData
				nDias := M->C5_DATA6-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA5) .And. lData
				nDias := M->C5_DATA5-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA4) .And. lData
				nDias := M->C5_DATA4-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA3) .And. lData
				nDias := M->C5_DATA3-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA2) .And. lData
				nDias := M->C5_DATA2-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA1) .And. lData
				nDias := M->C5_DATA1-M->C5_EMISSAO
				lData := .F.
		EndCase
		
//		nDias := dNewVcto-M->C5_EMISSAO
		
	Else	//senao verifica qual ultima data prevista nas 09 possiveis
		
		Do Case
			Case !Empty(M->C5_DATA9) .And. lData
				nDias := M->C5_DATA9-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA8) .And. lData
				nDias := M->C5_DATA8-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA7) .And. lData
				nDias := M->C5_DATA7-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA6) .And. lData
				nDias := M->C5_DATA6-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA5) .And. lData
				nDias := M->C5_DATA5-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA4) .And. lData
				nDias := M->C5_DATA4-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA3) .And. lData
				nDias := M->C5_DATA3-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA2) .And. lData
				nDias := M->C5_DATA2-M->C5_EMISSAO
				lData := .F.
			Case !Empty(M->C5_DATA1) .And. lData
				nDias := M->C5_DATA1-M->C5_EMISSAO
				lData := .F.
		EndCase
		
	EndIf
	
	//variavel logica para controle abaixo
	lContinua := .T.	
	
EndIf

//se .T. e nDias definido que ate 15 dias nao teriam encargo financeiro
If lContinua .And. nDias > 15
	
	//localiza indice atual
	DbSelectArea("ZC3")
	ZC3->(DbSetOrder(1))
	ZC3->(DbGoTop())
	While ZC3->(!Eof())
		If Empty(ZC3->ZC3_DATAV)
			nIndAtual := ZC3->ZC3_INDICE
		ElseIf cData < DToS(ZC3->ZC3_DATAV)
			nIndAtual := ZC3->ZC3_INDICE
		EndIf
		ZC3->(DbSkip())
	EndDo
	
	//indice cadastrado multiplicado pela quantidade de dias
	nIndice := Round(nIndAtual,2) * nDias
	
Else	//senao indice igual a 0

	nIndice := 0
	
EndIf
	
DbCloseArea("ZC3")
SE4->(RestArea(aAreaSE4))
RestArea(aArea)

Return(nIndice)