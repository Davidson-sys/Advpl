#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"  
 
/*      
+-----------+------------+----------------+----------------------+-------+------------+
| Programa  | Bol_Itaú   | Desenvolvedor  |Davidson Nutratta     | Data  | 05/06/2015 |
+-----------+------------+----------------+----------------------+-------+------------+
| Descricao |Impressão exclusiva do boleto Itaú			                              |
+-----------+-------------------------------------------------------------------------+
| Modulos   |                                                                         |
+-----------+-------------------------------------------------------------------------+
| Processos |                                                                         |
+-----------+-------------------------------------------------------------------------+
|                  Modificacoes desde a construcao inicial                            |
+----------+-------------+------------------------------------------------------------+
| DATA     | PROGRAMADOR | MOTIVO                                                     |
+----------+-------------+------------------------------------------------------------+
|          |             |                                                            |
+----------+-------------+------------------------------------------------------------+
*/


/******************************************************************************************************************/
User Function  NTAFIN09(lImp,cNumero,cPrefixo,cPortador,cAgencia,cConta,cParcela1,cParcela2,cFilOrig)
/******************************************************************************************************************/
Local lEmite
Local cMsg

Private oPrint
Private cNossoNum
Private cBanco
Private cAgeEmp
Private cCtaEmp
Private cDigEmp
Private cDigAge
Private cCdBarra
Private cRepNum
Private cCNPJ
Private aLog := {}
Private aLog2:= {}
Private cCartEmp
Private cCodCed := ''
Private nValTit	:= 0

Private _cCliente := '17318042'


SetPrvt("CPERG")

If Funname() == "SPEDNFE"

	MV_PAR01  := cNumero
	MV_PAR02  := cNumero
	MV_PAR03  := cPrefixo
	MV_PAR04  := "341"
	MV_PAR05  := "0342"
	MV_PAR06  := "17305"
	MV_PAR07  := ""
	MV_PAR08  := "ZZZ"
	MV_PAR09  := xFilial("SE1")
	MV_PAR10  := xFilial("SE1") 

	
Else
	If lImp
		MV_PAR01  := cNumero
		MV_PAR02  := cNumero
		MV_PAR03  := cPrefixo
		MV_PAR04  := cPortador
		MV_PAR05  := cAgencia
		MV_PAR06  := cConta
		MV_PAR07  := cParcela1
		MV_PAR08  := cParcela2
		MV_PAR09  := cFilOrig
		MV_PAR10  := cFilOrig
	Else
		cPerg:= "BOLITA1"
		ValidPerg()
			
		If !Pergunte(cPerg, .t.)
			MSGBOX("Emissao de boletos de cobranca cancelada!", "Boleto Laser", "INFO")
			Return
		EndIf
	EndIf
EndIf

Processa({|| RunProc()})

Return

/******************************************************************************************************************/
Static Function RunProc()
/******************************************************************************************************************/
Local cSql
Local cLog:= ""
Local cNNLimpo:= ""
Local cMsg
Local nRegs:= 0
Local _xi
CRIA_MV()

Private cForm1:= SuperGetMV("MV_X_MSBL1",,"")
Private cForm2:= SuperGetMV("MV_X_MSBL2",,"")
Private cForm3:= SuperGetMV("MV_X_MSBL3",,"")

PRIVATE nCB1Linha	:= GETMV("PV_BOL_LI1") //27.5
Private nCBColuna	:= GETMV("PV_BOL_COL") //1.3
Private nCBLargura	:= GETMV("PV_BOL_LAR") //0.0280
Private nCBAltura	:= GETMV("PV_BOL_ALT") //1.4

Private nMULTA	:= GETMV("MV_MULTA") //2
Private nJUROS	:= 0 

//consulta contendo os dados dos boleto a serem impressos
cSql := " SELECT * "
cSql += " FROM " +RetSqlName("SE1")+" SE1 "
cSql += " WHERE SE1.D_E_L_E_T_<>'*'"
cSql += " AND E1_FILIAL = '" + xFilial("SE1") + "'"
cSql += " AND E1_NUM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' 
cSql += " AND E1_PARCELA BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'
cSql += " AND E1_FILORIG BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "'
//cSql += " AND E1_CLIENTE BETWEEN '" + _cCliente + "' AND '" + _cCliente + "' 

If !Empty(MV_PAR03)
	cSql += " AND E1_PREFIXO = '" + mv_par03 + "'"
EndIf  

cSql += " AND E1_SALDO > 0 " 
cSql += " ORDER BY E1_NUM, E1_PREFIXO" 

//MemoWrit("C:\TEMP\boleto.sql", cSql)
TcQuery cSql NEW ALIAS "QRY"

dbSelectArea("QRY")
dbGotop()

Do While !Eof()
	nRegs++
	dbSkip()
Enddo     

If nRegs = 0
	MsgBox(OemToAnsi("Não há dados selecionados!"), "Mensagem", "ALERT")
    QRY->(DbCloseArea())
	Return
EndIf

nBol:=0

oPrint:= TMSPrinter():New("Boleto Laser")
oPrint:StartPage()   // Inicia uma nova página
oPrint:SetPortrait() // ou SetLandscape()
oPrint:SetPaperSize(9)//tamanho do papel (9)=A4 -(8)=A3
oPrint:Setup()

ProcRegua(nRegs)

cChaSEE:=SuperGetMV("MV_X_BCOBL",,"")
//Ex. B3560616 27064156  001,B0330092 13000757  001,B2370004300137456  001 

dbSelectArea("QRY")
dbGotop()

Do While QRY->(!Eof())
	//ALERT("TESTE")
	IncProc("Processando Boletos: " + ALLTRIM(QRY->E1_NUM) + "-" + ALLTRIM(QRY->E1_PREFIXO) + "-" +ALLTRIM(QRY->E1_PARCELA) + " ...")
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial()+QRY->E1_CLIENTE+QRY->E1_LOJA)
		
		// Posicionar parametros de banco
		DbSelectArea("SEE")
		SEE->(DbSetOrder(1))
				// banco + agencia + conta
		cChaPsq:= Padr(MV_PAR04,3,"")+Padr(MV_PAR05,5,"")+Padr(MV_PAR06,10,"")
		
		If SEE->(DbSeek(xFilial() + cChaPsq ))
						
			If !Empty(SEE->EE_FAXATU)
				
				If SEE->EE_CODIGO == "341" 
					cAgeEmp := Alltrim(SEE->EE_AGENCIA)
					cCtaEmp := Alltrim(SEE->EE_CONTA)
					cDvCtaEmp := Alltrim(SEE->EE_DVCTA)
					cDigAge := Alltrim(SEE->EE_DVAGE)
//					cCodCed := AllTrim(SEE->EE_CODEMP)
					cCartEmp:= Alltrim(SEE->EE_CODCART) 
					cBanco := "341"
				EndIf
				
				If LastKey() == 286 .Or. LastKey() == 27
					@ prow()+1,001 say "CANCELADO PELO OPERADOR"
					Exit
				EndIf
				
				DbSelectArea("SE1")
				DbSetOrder(2)
				If DbSeek(QRY->(E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO))
					Do While !Eof() .And. QRY->(E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO) == SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) .AND. SE1->E1_SALDO > 0
						
					    
						If  SEE->EE_CODIGO == "341" .And. SE1->E1_PORTADO == "341"
							  
							Imp_Bol(@cNNLimpo)
						EndIf
											
					
						// atualizo o titulo com o nosso numero e os dados do portador/agencia/banco
						If Empty(SE1->E1_NUMBCO)	
							DbSelectArea("SE1")
							
							RecLock("SE1", .F.)							
								Replace E1_NUMBCO 	With Substr(cNNLimpo,1,8)+Modu10( StrZero(Val(cAgeEmp),4) + StrZero(Val(cCtaEmp),5)+cCartEmp+cNNLimpo)//"000"+Substr(cNNLimpo,1,8)+Modu10( StrZero(Val(cAgeEmp),4) + StrZero(Val(cCtaEmp),5)+cCartEmp+cNNLimpo)
								Replace E1_PORTADO	With MV_PAR04
								Replace E1_AGEDEP	With MV_PAR05
								Replace E1_CONTA	With MV_PAR06
							SE1->(MSUNLOCK())		
						EndIf    
						
					
					    nBol++ 
					    
					    If nBol>1
							oPrint:EndPage()
						    oPrint:StartPage()   // Inicia uma nova página.  
					    EndIf    
					    
						DbSelectArea("SE1")
						SE1->(DbSkip())
					EndDo
					
				Else
					cLog := "  Titulo inexistente ("+QRY->E1_PREFIXO+" "+QRY->E1_NUM+")"
					aAdd(aLog2, OemToAnsi(cLog))
					Alert(cLog)
				Endif
			Else
				cLog := "  Campo Nosso Numero nao configurado ("+cChaPsq+")"
				aAdd(aLog2, OemToAnsi(cLog))
				Alert(cLog)
			Endif
		Else
			cLog := "  Banco + Agencia + Conta + SubConta nao cadastrado ("+cChaPsq+")"
			aAdd(aLog2, OemToAnsi(cLog))
			Alert(cLog)
		EndIf
	Else
		cLog := "  Cliente nao econtrado"
		aAdd(aLog2, OemToAnsi(cLog))
		Alert(cLog)
	Endif
	
	If Len(aLog2)>0
		cLog:= "Título "+QRY->E1_NUM + " - " + QRY->E1_PREFIXO + "  Cliente "+QRY->E1_CLIENTE+" "+QRY->E1_LOJA
		aAdd(aLog, OemToAnsi(cLog))
		For _xi:=1 to len(aLog2)
			Aadd(aLog,aLog2[_xi])
		Next
		aLog2:={}
	Endif
	
	DbSelectArea("QRY")
	QRY->(DbSkip())
	
EndDo

QRY->(DbCloseArea())

If Len(aLog)==0
	If nBol>0
		oPrint:EndPage()     // Finaliza a página
		oPrint:Preview()     // Visualiza antes de imprimir
	Else
		Alert("Nao Existem Informacoes para Impressao de Boletos Bancarios")
	Endif
EndIf

/*
If Len(aLog)>0
	Resultado()
Endif	
*/

Return

/******************************************************************************************************************/
Static Function FatVencto(cBanco)
/******************************************************************************************************************/
Local nResul:=0
nResul:= (SE1->E1_VENCTO - CTOD('07/10/1997'))
Return nResul

/******************************************************************************************************************/
Static Function FormatData(cData)
/******************************************************************************************************************/
Return Substr(cData, 7, 2) + '/' + Substr(cData, 5, 2) + '/' + Substr(cData, 1, 4)

/******************************************************************************************************************/
Static Function Modu10(cLinha)
/******************************************************************************************************************/
Local nSoma:= 0
Local nResto
Local nCont
Local cDigRet
Local nResult
Local lDobra:= .F.
Local cValor
Local nAux

For nCont:= Len(cLinha) To 1 Step -1
	lDobra:= !lDobra
	
	If lDobra
		cValor:= AllTrim(Str(Val(Substr(cLinha, nCont, 1)) * 2))
	Else
		cValor:= AllTrim(Str(Val(Substr(cLinha, nCont, 1))))
	EndIf
	
	For nAux:= 1 To Len(cValor)
		nSoma += Val(Substr(cValor, nAux, 1))
	Next n
Next nCont

nResto:= MOD(nSoma, 10)

nResult:= 10 - nResto

If nResult == 10
	cDigRet:= "0"
Else
	cDigRet:= StrZero(10 - nResto, 1)
EndIf

Return cDigRet

****************************************************************************
** Programa  ³ Modulo11 ³ Autor ³                       ³ Data ³ 01/08/02 **
** Descricao ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      **
** Uso       ³ Especifico para Clientes Microsiga                         **
****************************************************************************
Static Function Modu11(cLinha)
Local L := Len(cLinha)
Local D := 0
Local P := 1

While L > 0
   P := P + 1
   D := D + (Val(SubStr(cLinha, L, 1)) * P)
   If P = 9
      P := 1
   End
   L := L - 1
EndDo

D := 11 - (mod(D,11))

If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
   D := 1
EndIf

Return(str(D))


/**********************************************/
// Rotinas de impressao do boleto do Itau //
/**********************************************/
/******************************************************************************************************************/
Static Function Imp_Bol(cNNLimpo)
/******************************************************************************************************************/
Local oFont4
Local oFont8
Local oFont10
Local oFont14n
Local oFont16
Local oFont16n
Local oFont24
Local aCoords1:= {2250,1900,2350,2300}
Local aCoords2:= {2520,1900,2590,2300}
Local oBrush
Local cTexto 
Local cTexto4
Local cValor
Local nValor
Local cNumDoc
Local cCedente
Local nDescFin
Local cAgenc
Local cLogo_itau	:= GetSrvProfString('Startpath','') + 'LOGO_ITAU.bmp'
Local cLogo_Mar		:= GetSrvProfString('Startpath','') + 'logo_cont.jpg'


nValor:=SaldoTit( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, SE1->E1_NATUREZ, "R", SE1->E1_CLIENTE, SE1->E1_MOEDA, dDataBase, ;
                  dDataBase, SE1->E1_LOJA)
nValor:=Round(nValor, 2)
nValTit := nValor
	
cValor:=AllTrim(Transform(nValor, "@E 999,999,999.99"))
cNumDoc:= SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA

If Empty(SE1->E1_NUMBCO)
	DbSelectArea("SEE")						
	RecLock("SEE", .F.)
	
	cNextFxtu 	:=soma1(SubStr(Alltrim(SEE->EE_FAXATU),1,8))
	cNNLimpo 	:= cNextFxtu //cNext
	cDigNN		:= Modu10( StrZero(Val(cAgeEmp),4) + StrZero(Val(cCtaEmp),5)+cCartEmp+cNNLimpo)
	pNossoNum	:= cCartEmp+"/"+cNNLimpo+'-'+cDigNN
	cNossoNum 	:= cNNLimpo+cDigNN

	Replace EE_FAXATU With cNNLimpo+"-"+cDigNN
	SEE->(MSUNLOCK())
	DbSelectArea("SE1")						
							  	
Else 
	pNossoNum := cCartEmp+"/"+SubSTr(SE1->E1_NUMBCO,1,8)+'-'+SubSTr(SE1->E1_NUMBCO,9,1)//AllTrim(Transform(cCartEmp+SubSTr(SE1->E1_NUMBCO,1,12),"@R 99/99999999999-9")) //cCartEmp + "/"+Alltrim(SE1->E1_NUMBCO)+"-"+Modu10(cAgeEmp+cCtaEmp+cCartEmp+StrZero(Val(SE1->E1_NUMBCO),8))
//	cNossoNum := SubStr(SE1->E1_NUMBCO,4,8)+SubSTr(SE1->E1_NUMBCO,12,1) //Alltrim(SE1->E1_NUMBCO+Modu10(cAgeEmp+cCtaEmp+cCartEmp+StrZero(Val(SE1->E1_NUMBCO),8)))
	cNossoNum := Alltrim(SE1->E1_NUMBCO) 

EndIf

Bar_Sicoob()

oFont4 	:= TFont():New("Arial",9,4,,.T.,,,,,.F.)
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.) 
oFont9n	:= TFont():New("Arial",9,9,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oCouNew10N:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)

oBrush:= TBrush():New("",4)



oPrint:StartPage()   // Inicia uma nova página

SM0->(DBSEEK(cEmpAnt+SE1->E1_FILORIG))
cTexto:= "CEP: " + Substr(SM0->M0_CEPCOB, 1, 5) + "-" + Substr(SM0->M0_CEPCOB, 6, 3) + Space(3) + SM0->M0_BAIRCOB
cCNPJ:= "CNPJ: " + Substr(SM0->M0_CGC, 1, 2) + "." + Substr(SM0->M0_CGC, 3, 3) + "." + Substr(SM0->M0_CGC, 6, 3) +;
"/" + Substr(SM0->M0_CGC, 9, 4) + "-" + Substr(SM0->M0_CGC, 13, 2)
cTexto:= "I.E.: " + Substr(SM0->M0_INSC, 1, 3) + "." + Substr(SM0->M0_INSC, 4, 3) + "." + Substr(SM0->M0_INSC, 7, 3) +;
"." + Substr(SM0->M0_INSC,10,3)
cCedente:= cAgeEmp +"/"+cCtaEmp + '-' + cDvCtaEmp


// VERTICAIS 1o.PARTE - COMPROVANTE DE ENTREGA
oPrint:Line(0130, 0550, 0210, 0550) 
oPrint:Line(0130, 0780, 0210, 0780) 
oPrint:Line(0210, 0900, 0350, 0900)
oPrint:Line(0210, 1310, 0630, 1310)
oPrint:Line(0490, 0450, 0560, 0450)
oPrint:Line(0490, 0700, 0560, 0700)
oPrint:Line(0490, 0900, 0560, 0900)
oPrint:Line(0560, 0550, 0630, 0550)
oPrint:Line(0560, 0800, 0630, 0800)
oPrint:Line(0560, 1500, 0630, 1500)
  
//HORIZONTAIS 1o.PARTE - COMPROVANTE DE ENTREGA
oPrint:Line(0210, 0100, 0210, 2300) 
oPrint:Line(0280, 0100, 0280, 1300)
oPrint:Line(0350, 0100, 0350, 1300) 
oPrint:Line(0490, 0100, 0490, 1300)
oPrint:Line(0560, 0100, 0560, 2300)
oPrint:Line(0630, 0100, 0630, 2300)
  

oPrint:SayBitmap( 0110, 0100,cLogo_itau,340,100 )
//oPrint:Say( 0110, 0100, "BANCO ITÁU S.A",oFont24,100)
oPrint:Say( 0125, 0560, "341-7"                  ,oFont24,100)
oPrint:Say( 0140, 0800, 'COMPROVANTE DE ENTREGA'                   ,oFont14n,150)

//Beneficiário
oPrint:Say( 0215, 0100, "Beneficiário"               ,oFont8,100  )
oPrint:Say( 0240, 0100, ALLTRIM(SM0->M0_NOMECOM),oFont10,100  )

oPrint:Say( 0215, 0920, "Agência/Código do Beneficiário"  ,oFont8,100  )
oPrint:Say( 0240, 0920, Transform(AllTrim(SEE->EE_AGENCIA)+AllTrim(SEE->EE_conta)+alltrim(see->ee_dvcta),"@R 9999/99999-9")  ,oFont10,100  )

oPrint:Say( 0285, 0100, "Pagador"               ,oFont8,100  )
oPrint:Say( 0310, 0100, AllTrim(Substr(SA1->A1_NOME,1,41))  ,oFont9n,100  )

oPrint:Say( 0285, 0920, "Nosso Número"               ,oFont8,100  )
oPrint:Say( 0310, 0930, pNossoNum  ,oFont10,100  )

oPrint:Say( 0355, 0100, "Endereço do Pagador"               ,oFont8,100  )
oPrint:Say( 0380, 0100, AllTrim(SA1->A1_END)+ ' - '+AllTrim()(SA1->A1_BAIRRO)  ,oFont10,100  )
oPrint:Say( 0415, 0100, AllTrim(SA1->A1_CEP)+ '  '+AllTrim(SA1->A1_MUN)+ ' - '+AllTrim(SA1->A1_EST)  ,oFont10,100  )

oPrint:Say( 0495, 0100, "Vencimento"               ,oFont8,100  )
oPrint:Say( 0520, 0100, DTOC(SE1->E1_VENCREA)  ,oFont10,100  )

oPrint:Say( 0495, 0460, "Nr. Documento"               ,oFont8,100  )
oPrint:Say( 0520, 0460, SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA  ,oFont10,100  )

oPrint:Say( 0495, 0710, "Espécie"               ,oFont8,100  )
oPrint:Say( 0520, 0750, "R$"  ,oFont10,100  )

oPrint:Say( 0495, 0920, "Valor do Documento"               ,oFont8,100  )
oPrint:Say( 0520, 0920, Padl(cValor, 16)  ,oFont10,100  )

oPrint:Say( 0575, 0100, "Recebi(emos) o bloqueto de"               ,oFont8,100  )
oPrint:Say( 0600, 0100, "características acima"               ,oFont8,100  )

oPrint:Say( 0575, 0560, "Data"               ,oFont8,100  )

oPrint:Say( 0575, 0810, "Assinatura"               ,oFont8,100  )

oPrint:Say( 0575, 1320, "Data"               ,oFont8,100  )

oPrint:Say( 0575, 1520, "Entregador"               ,oFont8,100  )

oPrint:Say( 0215, 1320, "Motivos de Não Entrega (Para Uso da Empresa Entregadora)"               ,oFont8,100  )

oPrint:Say( 0265, 1323, "( )Mudou-se"               ,oFont10,100  )
oPrint:Say( 0265, 1620, "( )Ausente"               ,oFont10,100  )
oPrint:Say( 0265, 1930, "( )Não Existe Nº Indicado"     ,oFont10,100  )
oPrint:Say( 0365, 1323, "( )Recusado"               ,oFont10,100  )
oPrint:Say( 0365, 1620, "( )Não Procurado"               ,oFont10,100  )
oPrint:Say( 0365, 1930, "( )Falecido"               ,oFont10,100  )
oPrint:Say( 0465, 1323, "( )Desconhecido"               ,oFont10,100  )
oPrint:Say( 0465, 1620, "( )End. Inexistente"               ,oFont10,100  )
oPrint:Say( 0465, 1930, "( )Outros (Anotar Abaixo)"               ,oFont10,100  )
                      
                        
//HORIZONTAIS 2o. PARTE
oPrint:Line (1065,0100,1065,2300)
oPrint:Line (1165,0100,1165,2300)
oPrint:Line (1265,0100,1265,2300)
oPrint:Line (1335,1900,1335,2300)
oPrint:Line (1405,0100,1405,2300)
oPrint:Line (1475,0100,1475,2300)
oPrint:Line (1545,0100,1545,2300)
oPrint:Line (1615,1900,1615,2300)
oPrint:Line (1685,1900,1685,2300)
oPrint:Line (1755,0100,1755,2300)
oPrint:Line (1995,0100,1995,2300)

//VERTICAIS 2o. PARTE
oPrint:Line (0965,0550,1065,0550)
oPrint:Line (0965,0800,1065,0800)
oPrint:Line (1405,0500,1545,0500)
oPrint:Line (1475,0750,1545,0750)
oPrint:Line (1405,1000,1545,1000)
oPrint:Line (1405,1350,1475,1350)
oPrint:Line (1405,1550,1545,1550)
oPrint:Line (1065,1900,1755,1900)

cBitMap := "itau.BMP"//"logoitau.bmp"  
oPrint:SayBitmap( 0955,100,cLogo_itau,340,100 )
oPrint:Say(0975, 567, "341-7", oFont24)
oPrint:Say(0975, 820, "VIA DO PAGADOR",oFont14n,150)
oPrint:Say(1065, 100, "Local de Pagamento", oFont8)
cTexto:="ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAÚ" 
cTexto1="APÓS O VENCIMENTO PAGUE SOMENTE NO ITAÚ "
oPrint:Say(1085, 100, cTexto, oFont10) 
oPrint:Say(1120, 100, cTexto1, oFont10)
oPrint:Say(1065, 1910, "Vencimento", oFont8)
oPrint:Say(1105, 1920, Padl(FormatData(DTOS(SE1->E1_VENCTO)), 16), oCouNew10N)
oPrint:Say(1165, 100, "Beneficiário", oFont8)
oPrint:Say(1205, 100, SM0->M0_NOMECOM + " " + cCNPJ + "", oFont10)
oPrint:Say(1270, 100, "Endereço Beneficiário", oFont8)
oPrint:Say(1310, 100, alltrim(SM0->M0_ENDCOB)+" "+"-"+" "+alltrim(SM0->M0_BAIRCOB), oFont10)
oPrint:Say(1350, 100, alltrim(SM0->M0_CEPCOB)+" "+"-"+" "+alltrim(SM0->M0_CIDCOB)+" "+"-"+" "+alltrim(SM0->M0_ESTCOB), oFont10)
oPrint:Say(1165, 1910, "Agência/Código do Beneficiário", oFont8)
oPrint:Say(1205, 1920, Padl(cCedente, 16), oCouNew10N)
oPrint:Say(1405, 100, "Data do Documento", oFont8)
oPrint:Say(1435, 160, FormatData(DTOS(Date())), oFont10)

oPrint:Say(1405, 505, "Nro.Documento", oFont8)
oPrint:Say(1435, 605, cNumDoc, oFont10)

oPrint:Say(1405, 1005, "Espécie Documento", oFont8)
oPrint:Say(1435, 1105, "DM", oFont10)
oPrint:Say(1405, 1355, "Aceite", oFont8)
oPrint:Say(1435, 1400, "N", oFont10)

oPrint:Say(1405, 1555, "Data do Processamento", oFont8)
oPrint:Say(1435, 1615, FormatData(DTOS(SE1->E1_EMISSAO)), oFont10)

oPrint:Say(1265, 1910, "Nosso Número", oFont8)
oPrint:Say(1295, 1930, pNossoNum, oCouNew10N)

oPrint:Say(1475, 100 , "Uso do Banco", oFont8)
oPrint:Say(1505, 110 , " ", oFont10)

oPrint:Say(1475, 505 , "Carteira", oFont8)
oPrint:Say(1505, 515 , cCartEmp, oFont10)

oPrint:Say(1475, 755 , "Espécie", oFont8)
oPrint:Say(1505, 805 , "R$", oFont10)

oPrint:Say(1475, 1005, "Quantidade", oFont8)
oPrint:Say(1475, 1555, "Valor", oFont8)

oPrint:Say(1335, 1910, "(=)Valor do Documento", oFont8)
oPrint:Say(1365, 1920, Padl(cValor, 16), oCouNew10N)

cTexto:= "Instruções de responsabilidade do BENEFICIÁRIO. Qualquer dúvida sobre este boleto, contate o BENEFICIÁRIO"
oPrint:Say(1545, 100, cTexto, oFont8)

cTexto2:= "APOS O VENCIMENTO INCLUIR MULTA DE 5%."//5%
oPrint:Say(1605, 100, cTexto2, oFont10) //oPrint:Say(2690, 100, cTexto2, oFont10)  

														// fazer o calculo de 2% do valor do boleto   (fazer o calculo de 1% do valor do boleto dividido por 30) ..
cTexto3:="APOS O VENCIMENTO INCLUIR JUROS DE 3% AO MES."//3%
oPrint:Say(1665, 100, cTexto3, oFont10) //oPrint:Say(2740, 100, cTexto3, oFont10)

cTexto4:= UPPER(SE1->E1_TEXBOL)
oPrint:Say(1700, 100, cTexto4, oFont10) //oPrint:Say(2740, 100, cTexto3, oFont10)

oPrint:Say(1405, 1910, "(-)Desconto/Abatimento", oFont8)
oPrint:Say(1475, 1910, "(-)Outras Deduções", oFont8)
oPrint:Say(1545, 1910, "(+)Mora/Multa", oFont8)
oPrint:Say(1615, 1910, "(+)Outros Acréscimos", oFont8)
oPrint:Say(1685, 1910, "(=)Valor Cobrado", oFont8)

oPrint:Say(1755, 100, "Pagador", oFont8)

oPrint:Say(1785, 200, AllTrim(SA1->A1_NOME) + " " + AllTrim(SA1->A1_COD) + ""+IIF(Len(Alltrim(SA1->A1_CGC))==11, " CPF: " +AllTrim(Transform(SA1->A1_CGC,"@r 999.999.999-99"))," CNPJ: " +AllTrim(Transform(SA1->A1_CGC,"@r 99.999.999/9999-99"))), oFont10)
If !Empty(SA1->A1_ENDCOB)
	oPrint:Say(1838, 200, AllTrim(SA1->A1_ENDCOB), oFont10)
	oPrint:Say(1891, 200, AllTrim(SA1->A1_MUNC) + " - " + AllTrim(SA1->A1_ESTC)+"    "+"CEP:"+Substr(SA1->A1_CEPC, 1, 5) + '-' + Substr(SA1->A1_CEPC, 6, 3)+"  "+SA1->A1_BAIRROC, oFont10)
Else
	oPrint:Say(1838, 200, AllTrim(SA1->A1_END), oFont10)
	oPrint:Say(1891, 200, AllTrim(SA1->A1_MUN) + " - " + AllTrim(SA1->A1_EST)+"    "+"CEP: "+Substr(SA1->A1_CEP, 1, 5) + '-' + Substr(SA1->A1_CEP, 6, 3)+"  "+SA1->A1_BAIRRO, oFont10)
EndIf

oPrint:Say(1963, 0100, "Sacador/Avalista", oFont8)
oPrint:Say(1998, 1580, "Autenticação Mecânica / FICHA DE COMPENSAÇÃO", oFont8) //oPrint:Say(3185, 1800, "Autenticação Mecânica / Ficha de Compensação", oFont8)


oPrint:Line (2250,1900,2940,1900)
oPrint:Line (2660,1900,2660,2300)
oPrint:Line (2730,1900,2730,2300)
oPrint:Line (2800,1900,2800,2300)
oPrint:Line (2870,1900,2870,2300)
oPrint:Line (2940,0100,2940,2300)
oPrint:Line (3180,0100,3180,2300)


oPrint:Line (2250,100,2250,2300)
oPrint:Line (2250,550,2150,0550)
oPrint:Line (2250,800,2150,0800)


cBitMap := "itau.BMP"//"logoitau.bmp"  
oPrint:SayBitmap( 2140,100,cLogo_itau,340,100 )
oPrint:Say(2162, 567, "341-7", oFont24)

oPrint:Say(2184, 820, cRepNum, oFont14n)

oPrint:Line (2350,100,2350,2300)
oPrint:Line (2450,100,2450,2300)
oPrint:Line (2520,100,2520,2300)
oPrint:Line (2590,100,2590,2300)

oPrint:Line (2450,500,2590,500)
oPrint:Line (2520,750,2590,750)
oPrint:Line (2450,1000,2590,1000)
oPrint:Line (2450,1350,2520,1350)
oPrint:Line (2450,1550,2590,1550)

oPrint:Say(2250, 100, "Local de Pagamento", oFont8)
cTexto:="ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAÚ" 
cTexto1="APÓS O VENCIMENTO PAGUE SOMENTE NO ITAÚ "
oPrint:Say(2275, 100, cTexto, oFont10) 
oPrint:Say(2310, 100, cTexto1, oFont10)

oPrint:Say(2250, 1910, "Vencimento", oFont8)
oPrint:Say(2290, 1920, Padl(FormatData(DTOS(SE1->E1_VENCTO)), 16), oCouNew10N)

oPrint:Say(2350, 100, "Beneficiário", oFont8)
oPrint:Say(2390, 100, SM0->M0_NOMECOM + " " + cCNPJ + "", oFont10)

oPrint:Say(2350, 1910, "Agência/Código do Beneficiário", oFont8)
oPrint:Say(2390, 1920, Padl(cCedente, 16), oCouNew10N)

oPrint:Say(2450, 100, "Data do Documento", oFont8)
oPrint:Say(2480, 160, FormatData(DTOS(Date())), oFont10)

oPrint:Say(2450, 505, "Nro.Documento", oFont8)
oPrint:Say(2480, 605, cNumDoc, oFont10)

oPrint:Say(2450, 1005, "Espécie Documento", oFont8)
oPrint:Say(2480, 1105, "DM", oFont10)
oPrint:Say(2450, 1355, "Aceite", oFont8)
oPrint:Say(2480, 1400, "N", oFont10)

oPrint:Say(2450, 1555, "Data do Processamento", oFont8)
oPrint:Say(2480, 1615, FormatData(DTOS(SE1->E1_EMISSAO)), oFont10)

oPrint:Say(2450, 1910, "Nosso Número", oFont8)
oPrint:Say(2480, 1930, pNossoNum, oCouNew10N)

oPrint:Say(2520, 100 , "Uso do Banco", oFont8)
oPrint:Say(2550, 110 , " ", oFont10)

oPrint:Say(2520, 505 , "Carteira", oFont8)
oPrint:Say(2550, 515 , cCartEmp, oFont10)

oPrint:Say(2520, 755 , "Espécie", oFont8)
oPrint:Say(2550, 805 , "R$", oFont10)

oPrint:Say(2520, 1005, "Quantidade", oFont8)
oPrint:Say(2520, 1555, "Valor", oFont8)

oPrint:Say(2520, 1910, "(=)Valor do Documento", oFont8)
oPrint:Say(2550, 1920, Padl(cValor, 16), oCouNew10N)

cTexto:= "Instruções de responsabilidade do BENEFICIÁRIO. Qualquer dúvida sobre este boleto, contate o BENEFICIÁRIO"
oPrint:Say(2590, 100, cTexto, oFont8)

cTexto2:= "APOS O VENCIMENTO INCLUIR MULTA DE 5%."	//"Juros por dia de atraso após vencimento: "+ Alltrim(Transform((nValTit*0.334)/100,"@E 999,999,999.99"))
oPrint:Say(2620, 100, cTexto2, oFont10) //oPrint:Say(2690, 100, cTexto2, oFont10)  
// fazer o calculo de 2% do valor do boleto   (fazer o calculo de 1% do valor do boleto dividido por 30) ..
cTexto3:="APOS O VENCIMENTO INCLUIR JUROS DE 3% AO MES." //"PROTESTAR NO 5º DIA APÓS O VENCIMENTO."
oPrint:Say(2660, 100, cTexto3, oFont10) //oPrint:Say(2740, 100, cTexto3, oFont10)

cTexto4:=UPPER(SE1->E1_TEXBOL)
oPrint:Say(2700, 100, cTexto4, oFont10) //oPrint:Say(2740, 100, cTexto3, oFont10)

/*
cTextoA:=	"Taxa de Autenticações: CARTÓRIO=R$.6,50 / CARTORIO + CARTA REGISTRADA=R$.10,50"+CHR(10)+CHR(13)
cTextoB:=	"OUTROS ACRESCIMOS: Quando houver, refere-se ao CUSTO P/ REVERSAO DE FRETE"+CHR(10)+CHR(13)
cTextoC:=	"Prezado Cliente, não utilize DOC, TED, Transferência ou depósito como forma de pagamento."+CHR(10)+CHR(13)
cTextoD:=	"Nosso sistema não identifica esses pagamentos. Entre em contato conosco: (31) 2107-4777."

oPrint:Say(2720, 100, cTextoA, oFont8) //oPrint:Say(2740, 100, cTexto3, oFont10)
oPrint:Say(2750, 100, cTextoB, oFont8) //oPrint:Say(2740, 100, cTexto3, oFont10)
oPrint:Say(2780, 100, cTextoC, oFont8) //oPrint:Say(2740, 100, cTexto3, oFont10)
oPrint:Say(2810, 100, cTextoD, oFont8) //oPrint:Say(2740, 100, cTexto3, oFont10)
*/
cTexto:= Formula(cForm1)
If !Empty(cTexto)
	oPrint:Say(2790, 100, cTexto, oFont10)
EndIf
cTexto:= Formula(cForm2)
If !Empty(cTexto)
	oPrint:Say(2840, 100, cTexto, oFont10)
EndIf
cTexto:= Formula(cForm3)
If !Empty(cTexto)
	oPrint:Say(2890, 100, cTexto, oFont10)
EndIf

oPrint:Say(2590, 1910, "(-)Desconto/Abatimento", oFont8)
oPrint:Say(2660, 1910, "(-)Outras Deduções", oFont8)
oPrint:Say(2730, 1910, "(+)Mora/Multa", oFont8)
oPrint:Say(2800, 1910, "(+)Outros Acréscimos", oFont8)
oPrint:Say(2870, 1910, "(=)Valor Cobrado", oFont8)

oPrint:Say(2940, 100, "Pagador", oFont8)

oPrint:Say(2970, 200, AllTrim(SA1->A1_NOME) + " " + AllTrim(SA1->A1_COD) + ""+IIF(Len(Alltrim(SA1->A1_CGC))==11, " CPF: " +AllTrim(Transform(SA1->A1_CGC,"@r 999.999.999-99"))," CNPJ: " +AllTrim(Transform(SA1->A1_CGC,"@r 99.999.999/9999-99"))), oFont10)
If !Empty(SA1->A1_ENDCOB)
	oPrint:Say(3023, 200, AllTrim(SA1->A1_ENDCOB), oFont10)
	oPrint:Say(3076, 200, AllTrim(SA1->A1_MUNC) + " - " + AllTrim(SA1->A1_ESTC)+"    "+"CEP:"+Substr(SA1->A1_CEPC, 1, 5) + '-' + Substr(SA1->A1_CEPC, 6, 3)+"  "+SA1->A1_BAIRROC, oFont10)
Else
	oPrint:Say(3023, 200, AllTrim(SA1->A1_END), oFont10)
	oPrint:Say(3076, 200, AllTrim(SA1->A1_MUN) + " - " + AllTrim(SA1->A1_EST)+"    "+"CEP: "+Substr(SA1->A1_CEP, 1, 5) + '-' + Substr(SA1->A1_CEP, 6, 3)+"  "+SA1->A1_BAIRRO, oFont10)
EndIf

oPrint:Say(3150, 0100, "Sacador/Avalista", oFont8)
oPrint:Say(3185, 1580, "Autenticação Mecânica / FICHA DE COMPENSAÇÃO", oFont8) //oPrint:Say(3185, 1800, "Autenticação Mecânica / Ficha de Compensação", oFont8)


oPrint:Line (2250,1900,2940,1900)
oPrint:Line (2660,1900,2660,2300)
oPrint:Line (2730,1900,2730,2300)
oPrint:Line (2800,1900,2800,2300)
oPrint:Line (2870,1900,2870,2300)
oPrint:Line (2940,0100,2940,2300)
oPrint:Line (3180,0100,3180,2300)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MSBAR       ³ Autor ³ ALEX SANDRO VALARIO ³ Data ³  06/99   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime codigo de barras                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 01 cTypeBar String com o tipo do codigo de barras          ³±±
±±³          ³ 				"EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"     ³±±
±±³          ³ 				"INT25","MAT25,"IND25","CODABAR","CODE3_9"     ³±±
±±³          ³ 02 nRow		Numero da Linha em centimentros                ³±±
±±³          ³ 03 nCol		Numero da coluna em centimentros			   ³±±
±±³          ³ 04 cCode		String com o conteudo do codigo                ³±±
±±³          ³ 05 oPr		Objecto Printer                                ³±±
±±³          ³ 06 lcheck	Se calcula o digito de controle                ³±±
±±³          ³ 07 Cor 		Numero  da Cor, utilize a "common.ch"          ³±±
±±³          ³ 08 lHort		Se imprime na Horizontal                       ³±±
±±³          ³ 09 nWidth	Numero do Tamanho da barra em centimetros      ³±±
±±³          ³ 10 nHeigth	Numero da Altura da barra em milimetros        ³±±
±±³          ³ 11 lBanner	Se imprime o linha em baixo do codigo          ³±±
±±³          ³ 12 cFont		String com o tipo de fonte                     ³±±
±±³          ³ 13 cMode		String com o modo do codigo de barras CODE128  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ImpressÆo de etiquetas c¢digo de Barras para HP e Laser    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//-- Exemplo:
//-- MSBAR("CODE128",3,1,"12345678901",oPr,,,,,,,,"A")

//MSBARHP.PRW
//MSBAR("INT25",27.7,2.0,cCdBarra,oPrint,.F.,,,,1.3,,,,.F.)

/* Implementação do codigo de barras no relatorio.
 //	     	1		  2    3     4	            5	  6      7	   8    9	   10       11     12   13    14      15       16
// * MSBAR(cTypeBar,nRow,nCol,cCode        ,oPrint,lCheck,Color,lHorz,nWidth,nHeigth,lBanner,cFont,cMode,lPrint,nPFWidth,nPFHeigth)*/
//   MSBAR("INT25",14,1,cCdBarra,oPrint,.F.,Nil,.T.,0.015,0.75,NIL,NIL,NIL,.F.)  
//	 MSBAR("INT25",13.53,0.48,cCdBarra,oPrint,.F.,Nil,.T.,0.012,0.75,NIL,NIL,NIL,.F.) 
	 MSBAR("INT25",27.6,1.3,cCdBarra,oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)	 
oPrint:EndPage() // Finaliza a página

Return

/******************************************************************************************************************/
Static Function Bar_Sicoob()
/******************************************************************************************************************/
Local cDigCdBarra
Local cFatVencto:= ""
Local cValor
//Local nValor
Local cCampo1:= ""
Local cCampo2:= ""
Local cCampo3:= ""
Local cCampo4:= ""
Local cCampo5:= ""
Local cCpoLivre:= ""
Local cDigCodB := ""

cFatVencto:= Strzero(FatVencto(cBanco),4)
///nValor:= Round(SE1->E1_SALDO, 2)
nValor:=SaldoTit( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, SE1->E1_NATUREZ, "R", SE1->E1_CLIENTE, SE1->E1_MOEDA, dDataBase, ;
                  dDataBase, SE1->E1_LOJA)
nValor:=Round(nValor, 2)

cValor:=StrZero(nValor*100,10)


/* 
CODIGO DE BARRAS
Deve conter 44 (quarenta e quatro) posições, sendo:
POSIÇÃO 	TAMANHO 	PICTURE 	CONTEÚDO
01 a 03 	03 			9(03) 		Código do Banco na Câmara de Compensação = '341'
04 a 04 	01 			9(01) 		Código da Moeda = '9'
05 a 05 	01 			9(01) 		DAC código de Barras (Anexo 2)
06 a 09 	04 			9(04) 		Fator de Vencimento (Anexo 6)
10 a 19 	10 			9(08)V(2)	Valor
20 a 22 	03 			9(03) 		Carteira
23 a 30 	08 			9(08) 		Nosso Número
31 a 31 	01 			9(01) 		DAC [Agência /Conta/Carteira/Nosso Número] (Anexo 4)
32 a 35 	04 			9(04) 		N.º da Agência BENEFICIÁRIO
36 a 40 	05 			9(05) 		N.º da Conta Corrente
41 a 41 	01 			9(01) 		DAC [Agência/Conta Corrente] (Anexo 3)
42 a 44 	03 			9(03) 		Zeros
*/
	cBarra := alltrim(cBanco)
	cBarra += "9"
	cBarra += cFatVencto
	cBarra += cValor
	cBarra += cCartEmp
	cBarra += cNossoNum
	cBarra += cAgeEmp
	cBarra += cCtaEmp
	cBarra += cDvCtaEmp
	cBarra += "000"
	cDigCodB:= Modu11(cBarra)   
	
cCdBarra := alltrim(substr(cBarra,1,4))+alltrim(cDigCodB)+alltrim(Substr(cBarra,5,39))


/*REPRESENTAÇÃO NUMERICA

Campo 1    |  Campo 2 	 |  Campo 3  |4|   Campo 5 	  |
AAABC.CCDDX DDDDD.DEFFFY FGGGG.GGHHHZ K UUUUVVVVVVVVVV 

Campo 1 (AAABC.CCDDX) 
AAA = Código do Banco na Câmara de Compensação ( Itaú=341) 
B = Código da moeda = "9" (*) 
CCC = Código da carteira de cobrança 
DD = Dois primeiros dígitos do Nosso Número 
X = DAC que amarra o campo 1 (Anexo3) 

Campo 2 (DDDDD.DEFFFY) 
DDDDDD= Restante do Nosso Número 
E =  DAC do campo [ Agência/Conta/Carteira/ Nosso Número ] 
FFF = Três primeiros números que identificam a Agência 
Y = DAC que amarra o campo 2 (Anexo 3) 

Campo 3 (FGGGG.GGHHHZ)  
F = Restante do número que identifica a agência 
GGGGGG = Número da conta corrente + DAC 
HHH = Zeros ( Não utilizado ) 
Z = DAC que amarra o campo 3 (Anexo 3)  

Campo 4 (K) 
K = DAC do Código de Barras (Anexo 2)  

Campo 5 (UUUUVVVVVVVVVV) 
UUUU= Fator de vencimento 
VVVVVVVVVV= Valor do Título (*)
*/
	
/* Calculo da representacao numerica */
	cCampo1:= cBanco + "9" +cCartEmp+SubStr(cNossoNum,1,2) 
	cCampo1:= cCampo1 + Modu10(cCampo1)
	 
	cCampo2:= SubStr(cNossoNum,3,7)+SubStr(cAgeEmp,1,3)
	cCampo2:= cCampo2 + Modu10(cCampo2)
	
	cCampo3:= SubStr(cAgeEmp,4,1)+cCtaEmp+cDvCtaEmp+"000"  
	cCampo3:= cCampo3 + Modu10(cCampo3) 

	cCampo4 := cDigCodB

	cCampo5:= cFatVencto+cValor
	                    
	
/* XXX LINHA DIGITÁVEL BOLETO (REPRESENTAÇAO NUMERICA DO CODIGO DE BARRAS XXX */
	cRepNum := alltrim(Substr(cCampo1,1,5)+"."+Substr(cCampo1,6,5))+"  "
	cRepNum += alltrim(Substr(cCampo2,1,5)+"."+Substr(cCampo2,6,6))+"  "
	cRepNum += alltrim(Substr(cCampo3,1,5)+"."+Substr(cCampo3,6,6))+"  "
	cRepNum += alltrim(cCampo4)+"  "
	cRepNum += alltrim(cCampo5)    
	

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CRIA_MV ³Descri‡…o³ Criacao dos Param.Necessarios no (SX6) ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION CRIA_MV()
//
dbSelectArea("SX6")
dbSetOrder(1)
//
If !dbSeek(cFilant+"PV_BOL_LI1")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_LI1"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO."
	SX6->X6_CONTEUD	:= "27.5"
	SX6->X6_CONTSPA	:= "27.5"
	SX6->X6_CONTENG	:= "27.5"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_COL")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_COL"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO."
	SX6->X6_CONTEUD	:= "1.3"
	SX6->X6_CONTSPA	:= "1.3"
	SX6->X6_CONTENG	:= "1.3"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_LAR")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_LAR"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO."
	SX6->X6_CONTEUD	:= "0.0280"
	SX6->X6_CONTSPA	:= "0.0280"
	SX6->X6_CONTENG	:= "0.0280"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_ALT")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_ALT"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO."
	SX6->X6_CONTEUD	:= "1.40"
	SX6->X6_CONTSPA	:= "1.40"
	SX6->X6_CONTENG	:= "1.40"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif   

//
If !dbSeek(cFilant+"MV_X_MSBL1")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "MV_X_MSBL1"
	SX6->X6_TIPO	:= "C"
	SX6->X6_DESCRIC	:= "MENSAGEM BOLETO LINHA 1 "
	SX6->X6_DSCSPA	:= "MENSAGEM BOLETO LINHA 1 "
	SX6->X6_DSCENG	:= "MENSAGEM BOLETO LINHA 1 "
	SX6->X6_DESC1	:= " "
	SX6->X6_DSCSPA1	:= " "
	SX6->X6_DSCENG1	:= " "
	SX6->X6_DESC2	:= " "
	SX6->X6_DSCSPA2	:= " "
	SX6->X6_DSCENG2	:= " "
	SX6->X6_CONTEUD	:= "Mensagem 01(MV_X_MSBL1)"
	SX6->X6_CONTSPA	:= " "
	SX6->X6_CONTENG	:= " "
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif   
//
If !dbSeek(cFilant+"MV_X_MSBL2")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "MV_X_MSBL2"
	SX6->X6_TIPO	:= "C"
	SX6->X6_DESCRIC	:= "MENSAGEM BOLETO LINHA 2 "
	SX6->X6_DSCSPA	:= "MENSAGEM BOLETO LINHA 2 "
	SX6->X6_DSCENG	:= "MENSAGEM BOLETO LINHA 2 "
	SX6->X6_DESC1	:= " "
	SX6->X6_DSCSPA1	:= " "
	SX6->X6_DSCENG1	:= " "
	SX6->X6_DESC2	:= " "
	SX6->X6_DSCSPA2	:= " "
	SX6->X6_DSCENG2	:= " "
	SX6->X6_CONTEUD	:= "Mensagem 02(MV_X_MSBL2)"
	SX6->X6_CONTSPA	:= " "
	SX6->X6_CONTENG	:= " "
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif   
//
If !dbSeek(cFilant+"MV_X_MSBL3")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "MV_X_MSBL3"
	SX6->X6_TIPO	:= "C"
	SX6->X6_DESCRIC	:= "MENSAGEM BOLETO LINHA 3 "
	SX6->X6_DSCSPA	:= "MENSAGEM BOLETO LINHA 3 "
	SX6->X6_DSCENG	:= "MENSAGEM BOLETO LINHA 3 "
	SX6->X6_DESC1	:= " "
	SX6->X6_DSCSPA1	:= " "
	SX6->X6_DSCENG1	:= " "
	SX6->X6_DESC2	:= " "
	SX6->X6_DSCSPA2	:= " "
	SX6->X6_DSCENG2	:= " "
	SX6->X6_CONTEUD	:= "Mensagem 03(MV_X_MSBL3)"
	SX6->X6_CONTSPA	:= " "
	SX6->X6_CONTENG	:= " "
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif   
//          
If !dbSeek(cFilant+"MV_X_BCOBL")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "MV_X_BCOBL"
	SX6->X6_TIPO	:= "C"
	SX6->X6_DESCRIC	:= "CONTAS DE COBRANCA  "
	SX6->X6_DSCSPA	:= "CONTAS DE COBRANCA  "
	SX6->X6_DSCENG	:= "CONTAS DE COBRANCA  "
	SX6->X6_DESC1	:= " "
	SX6->X6_DSCSPA1	:= " "
	SX6->X6_DSCENG1	:= " "
	SX6->X6_DESC2	:= " "
	SX6->X6_DSCSPA2	:= " "
	SX6->X6_DSCENG2	:= " "
	SX6->X6_CONTEUD	:= " "
	SX6->X6_CONTSPA	:= " "
	SX6->X6_CONTENG	:= " "
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif   

If !dbSeek(cFilant+"MV_MULTA")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "MV_MULTA"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "percentual de Juros"
	SX6->X6_DSCSPA	:= "CONTAS DE COBRANCA  "
	SX6->X6_DSCENG	:= "CONTAS DE COBRANCA  "
	SX6->X6_DESC1	:= " "
	SX6->X6_DSCSPA1	:= " "
	SX6->X6_DSCENG1	:= " "
	SX6->X6_DESC2	:= " "
	SX6->X6_DSCSPA2	:= " "
	SX6->X6_DSCENG2	:= " "
	SX6->X6_CONTEUD	:= "2"
	SX6->X6_CONTSPA	:= "2"
	SX6->X6_CONTENG	:= "2"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
Return()

Static Function ValidPerg()
_sAlias	:=	Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 	:=	PADR(cPerg,10)
//                                                                                         -SA1-
putSx1(     cPerg,"01","Do Titulo?","."     	,"."	,"mv_ch1","C",09,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
putSx1(     cPerg,"02","Ate o Titulo?","."     	,"."	,"mv_ch2","C",09,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
putSx1(     cPerg,"03","Prefixo?","."     	,"."	,"mv_ch3","C",03,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
putsx1(		cPerg,"04","Banco?","."		,"."	,"mv_ch4","C",03,0,0,"G","","SA6","","","","","","","","","","","","","","","","","","","","","","","","","","")
putsx1(		cPerg,"05","Agencia?","."		,"."	,"mv_ch5","C",05,0,0,"G","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
putsx1(		cPerg,"06","Conta?","."		,"."	,"mv_ch6","C",10,0,0,"G","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
putSx1(     cPerg,"07","Da Parcela?","."     	,"." 	,"mv_ch7","C",03,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","")
putSx1(     cPerg,"08","Ate Parcela?","."     	,"." 	,"mv_ch8","C",03,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","")
putSx1(     cPerg,"09","Filial de ?","."     	,"." 	,"mv_ch9","C",04,0,0,"G","","SM0","","","mv_par09","","","","","","","","","","","","","","","","")
putSx1(     cPerg,"10","Filial Até?","."     	,"." 	,"mv_cha","C",04,0,0,"G","","SM0","","","mv_par10","","","","","","","","","","","","","","","","")

dbSelectArea(_sAlias)

Return
         


         

