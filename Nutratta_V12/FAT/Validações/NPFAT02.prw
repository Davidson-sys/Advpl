#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NPFAT02 º Autor ³ Nelltech Gestao de TI º Data ³ 16/07/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao executada nos campos C6_QTDVEN e C6_C_VLRDI.	      º±±
±±º          ³ Calcula Encargo Financeiro e preenche campos C6_PRCVEN     º±±
±±º          ³ e C6_VALOR.									 			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ nCampo = 1: C6_QTDVEN | 2: C6_C_VLRDI                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vendas - Nutratta                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºNelltech Gestao de TI ³ Lucas Lima									  º±±
±±º Davidson comentado os campos de encargos financeiros.                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NPFAT02(nCampo)

Local aArea     := GetArea()
Local aAreaSE4  := SE4->(GetArea())
Local cCliente  := M->C5_CLIENTE
Local cLoja     := M->C5_LOJACLI
Local cCondPag  := M->C5_CONDPAG
Local nEncFin   := M->C5_C_ENCFI
Local cProd     := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})]
Local nVrDig    := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_C_VLRDI"})]
Local nVrFrete  := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_C_FRETE"})]
Local nVrEncF	:= aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_C_ENCF"})]
Local nQuantVen := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})]
Local cUnd 		:= aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_UM"})]
Local cDiasCond := Posicione("SE4",1,xFilial("SE4")+cCondPag,"E4_COND")
Local cTipCond	:= Posicione("SE4",1,xFilial("SE4")+cCondPag,"E4_TIPO")
Local nDias     := 0
Local nVlUnit   := 0
Local nI		:= 0  
Local nII		:= 0 
Local nVrNew	:= 0
Local nVrEncF	:= 0
Local nFreteTot	:= 0 
Local nPesoLqTot:= 0 
Local nPesBruTot:= 0 

Local aDias		:= {}
Local lContinua := .F.
Local lData		:= .T.

//quantidade maior que zero
If nQuantVen > 0
	
	If nCampo == 2		//salva valor que esta em memoria ao digitar C6_C_VLRDI
		//Busca o valor do desconto Financeiro
		nVrDig 	:= M->C6_C_VLRDI
		/*nVrTbl	:= nVrDig
		nVrNew	:= U_GFAT005()
		VrEncF 	:= nVrNew - nVrTbl
		nVrDig	:= nVrNew   */
		 
	//	aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_C_ENCF"})] := nVrEncF   //atualiza acols linha posicionada		
	EndIf
	/*
	If nCampo == 4		//salva valor que esta em memoria ao digitar C6_C_VLRDI
		nVrEncF := M->C6_C_ENCF //nVrDig - nVrDig	 
	EndIf
	*/
	//valor unitario maior que zero
	If nVrDig > 0
		
		//valor encargo financeiro maior que zero
		If nEncFin > 0
			//tipo de condicao de pagamento com datas predefinidas
			If cTipCond == "1"
		
				If "," $ Alltrim(cDiasCond)
					aDias := StrToKarr(cDiasCond,",")
					nDias := Val(aDias[Len(aDias)])
				Else
					nDias := Val(cDiasCond)
				EndIf
				
				lContinua := .T.
			//tipo de condicao de pagamento sem data predefinida
			ElseIf cTipCond == "9"
					
				If !Empty(M->C5_DATA1)
					//procura ultima data prevista
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
						
					lContinua := .T.
						
				Else
						//se nao tem data pagamento preenchida, obriga a digitacao
					Aviso("Atenção","Tipo de Condição de Pagamento é 'Data/Valor' e não existem datas de pagamentos digitadas no cabeçalho do Pedido. Favor preencher as datas e digitar o Valor de Venda novamente.",{"OK"})
					aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_C_VLRDI"})] := 0
					
				EndIf
					
			EndIf
				
			//se condicao pagamento preenchidas
			If lContinua
			
			    //Dias de dispensa encargo financeiro Produto	
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1")+cProd)
				If Found()
					nDiasProd := SB1->B1_C_DENCF
				Else
					nDiasProd := 0
				EndIf
					
			    //Dias de dispensa encargo financeiro Cliente
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial("SA1")+cCliente+cLoja)
				If Found()
					nDiasCli := SA1->A1_C_DENCF
				Else
					nDiasCli := 0
				EndIf
						
			    //DbSelectArea("SA3")
			    //DbSetOrder(1)
			    //DbSeek(xFilial("SA3")+cVend)
						
				If nDiasProd > nDias	//se dias concessao do produto maior que o da Cond Pagamento
					nEncFin := 0
					If nDias > 0
						lContinua:= .F.
						MsgInfo("O Valor Unitário não teve reajuste pois o Produto tem concessão de Encargo Financeiro por "+CValToChar(nDiasProd)+" dias.")
					EndIf
				Else
					If nDiasCli > nDias	//se dias concessao do cliente maior que o da Cond Pagamento
						nEncFin := 0
						If nDias > 0
							lContinua:= .F.
							MsgInfo("O Valor Unitário não teve reajuste pois o Cliente tem concessão de Encargo Financeiro por "+CValToChar(nDiasCli)+" dias.")
						EndIf 
					//Else
						// dias vendedor
					EndIf
				EndIf
				
				//calcula encargo
				If lContinua
				    
					//se Enc Fin no Acols já estiver preenchido
                	/*If nVrEncF > 0
                		If nCampo <> 4
							If Aviso("Atenção","Valor Encargo Financeiro já preenchido. Recalcular ou Manter valor?",{"Recalcular","Manter"})== 1				   
								nVrEncF := nVrDig * (nEncFin/100)
								nVlUnit := NoRound(nVrDig + nVrEncF,2)+nVrFrete

								aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_C_ENCF"})] := nVrEncF

							Else
								nVlUnit :=NoRound(nVrDig,2)+nVrFrete+nVrEncF
							EndIf
						EndIf
					Else
						nVrEncF := Round(nVrDig * (nEncFin/100),2)
						nVlUnit := NoRound(nVrDig + nVrEncF,2)+nVrFrete

						aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_C_ENCF"})] := nVrEncF
					EndIf
					*/
					//se valor unitario ACOLS diferente do valor unitario calculado
					If aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})] <> NoRound(nVlUnit,2) .And. nCampo <> 4
						
						aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})] := NoRound(nVlUnit,2)
						aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})]  := NoRound((NoRound(nVlUnit,2) * nQuantVen),2)
			
						/*If nEncFin > 0
							MsgInfo("Valor Unitário reajustado de R$ "+AllTrim(Transform(nVrDig,"@E 999999.99"))+" para R$ "+AllTrim(Transform(nVlUnit,"@E 999999.99"))+chr(10)+chr(10)+chr(13);
									+"Enc Financeiro...R$ "+AllTrim(Transform(nVrEncF ,"@E 9999.99"))+chr(10);
									+"Frete Unitário...R$ "+AllTrim(Transform(nVrFrete,"@E 9999.99")) )
						EndIf */
						
					EndIf
				
				//senao, nao tem calculo encargo	
                Else
					
					nVlUnit := NoRound(nVrDig,2)+nVrFrete
					
					If aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})] <> NoRound(nVlUnit,2)
						
						aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})] := NoRound(nVlUnit,2)
						aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})]  := NoRound((NoRound(nVlUnit,2) * nQuantVen),2)
					
						If nEncFin = 0 .And. nVrFrete > 0
							MsgInfo("Valor Unitário reajustado de R$ "+AllTrim(Transform(nVrDig,"@E 999999.99"))+" para R$ "+AllTrim(Transform(nVlUnit,"@E 999999.99"))+chr(10)+chr(10)+chr(13);
									+"Enc Financeiro...R$ 0.00 "+chr(10);
									+"Frete Unitário...R$ "+AllTrim(Transform(nVrFrete,"@E 9999.99")) )
						EndIf
						
					EndIf
					
				EndIf
					
			EndIf
		
		//valor encargo financeiro cabecalho igual a 0	
		Else
				
			aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})] := NoRound(nVrDig,2)+nVrFrete
			aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})]  := NoRound(((NoRound(nVrDig,2)+nVrFrete) * nQuantVen),2)
			
			If nVrFrete > 0
				MsgInfo("Valor Unitário reajustado de R$ "+AllTrim(Transform(nVrDig,"@E 999999.99"))+" para R$ "+AllTrim(Transform(nVrDig+nVrFrete,"@E 999999.99"))+": "+chr(10)+chr(10)+chr(13);
				 		+"Frete Unitário...R$ "+AllTrim(Transform(nVrFrete,"@E 9999.99")) )
			EndIf
				
		EndIf		
		
		//campo Frete = C6_C_FRETE
		If nCampo == 3
        
            //retira o frete antigo
			aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})] := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]-aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_C_FRETE"})]
			//salva novo valor de frete digitado
			nVrFrete := M->C6_C_FRETE													//salva valor que esta em memoria ao digitar C6_C_FRETE
			aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_C_FRETE"})] := nVrFrete      //atualiza acols linha posicionada
			aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]  := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]+nVrFrete	//valor unit + frete
			
			//calcula novo valor Total do Item
			aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})]  := NoRound((nQuantVen * aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]),2)
			
			//--------------------------------------------------------------------------
			/* Atualiza cabecalho campo de FRETE								 		 */
			//--------------------------------------------------------------------------
			While nI < Len(Acols)
				nI++
				If !aCols[nI,Len(Acols[nI])]
					nFreteTot := nFreteTot + (aCols[nI,aScan(aHeader,{|x| AllTrim(x[2])=="C6_C_FRETE"})]* aCols[nI,aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})])
				EndIf
			EndDo
				
			M->C5_C_VFRET := nFreteTot	//salva na memoria campo de frete cabecalho
			       
			//atualiza enchoice (cabecalho)
			oGetPV:EnchRefreshAll()
			
//			MsgInfo("Valor Unitário reajustado de R$ "+AllTrim(Transform(nVrDig,"@E 999999.99"))+" para R$ "+AllTrim(Transform(aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})],"@E 999999.99"))+chr(10)+chr(10)+chr(13);
//					+"Enc Financeiro...R$ "+AllTrim(Transform(nVrEncF ,"@E 9999.99"))+chr(10);
//					+"Frete Unitário...R$ "+AllTrim(Transform(nVrFrete,"@E 9999.99")) )
			
		EndIf
                      
       	//--------------------------------------------------------------------------
		/* Atualiza cabecalho campo peso liquido e bruto do pedido de vendas	 */
		//--------------------------------------------------------------------------
	   	If nCampo == 1
			
			While nII < Len(Acols)
				nII++
				If !aCols[nII,Len(Acols[nII])]
					
					If  cUnd == "UN"
						
						nPesoLqTot := nPesoLqTot +aCols[nII,aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})]* 25
						nPesBruTot := nPesBruTot +(aCols[nII,aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})]* 25.074)		
					
					ElseIf cUnd == "TL"
						
						nPesoLqTot := nPesoLqTot +aCols[nII,aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})]* 1000
						nPesBruTot := nPesBruTot +aCols[nII,aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})]* 1000								
					EndIf
				EndIf
			EndDo
			
			M->C5_PESOL  := nPesoLqTot	//salva na memoria campo de peso liquido cabecalho
   			M->C5_PBRUTO := nPesBruTot	//salva na memoria campo de peso Bruto cabecalho

			//atualiza enchoice (cabecalho)
			oGetPV:EnchRefreshAll()
		EndIf
		
        
        //campo ENC. FINANCEIRO - C6_C_ENCF
        If nCampo == 4
            //retira o Enc Financeiro calculado
			aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})] := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]-aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_C_ENCF"})]
			//salva novo valor de frete digitado
			//nVrEncF := M->C6_C_ENCF													//salva valor que esta em memoria ao digitar C6_C_ENCF
			//aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_C_ENCF"})] := nVrEncF   //atualiza acols linha posicionada
			aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]  := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})] //+nVrEncF
			
			//calcula novo valor Total do Item
			aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})]  := NoRound((nQuantVen * aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]),2)
			
			/*MsgInfo("Valor Unitário reajustado de R$ "+AllTrim(Transform(nVrDig,"@E 999999.99"))+" para R$ "+AllTrim(Transform(aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})],"@E 999999.99"))+chr(10)+chr(10)+chr(13);
					+"Enc Financeiro...R$ "+AllTrim(Transform(nVrEncF ,"@E 9999.99"))+chr(10);
					+"Frete Unitário...R$ "+AllTrim(Transform(nVrFrete,"@E 9999.99")) )*/					
        EndIf
        
	EndIf

EndIf

SE4->(RestArea(aAreaSE4))
RestArea(aArea)

Return(.T.)