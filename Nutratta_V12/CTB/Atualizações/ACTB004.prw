#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACTB004   ºAutor  ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a conta DEBITO/CREDITO/HISTORICO de um grupo de tesº±±
±±º          ³ de entrada.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS11                                      				º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ACTB004(_cCod)

Local _cRetorno := ''
Local _cNatureza := ''
Local _cCC := ''
Local _aArea := GetArea()
Local _cGrupo := ''
                            

	
dbSelectArea("SF4")
dbSetOrder(1)
dbSeek(xFilial("SF4")+ALLTRIM(SD1->D1_TES),.T.)
_cGrupo := SF4->F4_Z_GRPTE
//_cGrupo := SF4->F4_GRPTES


dbSelectArea("ZZ5")
dbSetOrder(1)
If dbSeek(xFilial("ZZ5")+ALLTRIM(_cGrupo),.T.)

	IF SD1->D1_RATEIO <> "1" // Se a nota NÃO for rateada
			DO CASE
				CASE _cCod == "CC" // PRIORIDADE - GRUPO DE TES -> PRODUTO -> NATUREZA
					IF !EMPTY(ALLTRIM(ZZ5->ZZ5_CTACRE)) // SE O GRUPO DE TES ESTIVER PREENCHIDO PREVALECE A CONTA CREDITO DO GRUPO DE TES
						_cRetorno := ZZ5->ZZ5_CTACRE
						
				   	ELSEIF SF4->F4_ESTOQUE = "S"   .AND. EMPTY(_cRetorno) 
				   	
				   			dbSelectArea("SBM")
							dbSetOrder(1)
							IF dbSeek(xFilial("SBM")+ALLTRIM(SD1->D1_GRUPO),.T.)
				         	
				         	_cRetorno := SBM->BM_C_CTEST  
				         	
				         	ENDIF
			         	
						
					ELSEIF SF4->F4_DUPLIC = "S"  .AND. EMPTY(_cRetorno) 
						_cNatureza := Posicione("SE2",6,XFILIAL("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC, "E2_NATUREZ") //E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
						
						DbSelectArea("SED")
						DbSetOrder(1)
						DbSeek(xFilial("SED")+_cNatureza)
						_cRetorno := SED->ED_CREDIT	
						
					ELSEIF EMPTY(_cRetorno)
						DbSelectArea("SA2")
						DbSetOrder(1)
						DbSeek(xFilial("SA2")+ALLTRIM(SF1->F1_FORNECE)+ALLTRIM(SF1->F1_LOJA))
						
						_cRetorno := SA2->A2_CONTA
				
					ENDIF                          
					
				CASE _cCod == "CD"
					IF !EMPTY(ALLTRIM(ZZ5->ZZ5_CTADEB)) // SE O GRUPO DE TES ESTIVER PREENCHIDO PREVALECE A CONTA DEBITO DO GRUPO DE TES
						_cRetorno := ZZ5->ZZ5_CTADEB
						
					ELSEIF  (SF4->F4_ESTOQUE = "S" .AND. !ALLTRIM(SF4->F4_CF) $ "1353/2353") .AND. !EMPTY(SBM->BM_B_CONTA)  .AND. EMPTY(_cRetorno) 
					
					   		dbSelectArea("SBM")
							dbSetOrder(1)
							IF dbSeek(xFilial("SBM")+ALLTRIM(SD1->D1_GRUPO),.T.)
				         	
				         		_cRetorno := SBM->BM_C_CTEST  
				         	
				         	ENDIF			
					
						
						
					ELSEIF  SF4->F4_DUPLIC = "S" .AND. EMPTY(_cRetorno)
						_cNatureza := Posicione("SE2",6,XFILIAL("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC, "E2_NATUREZ") //E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
						
												    
						DbSelectArea("SED")
						DbSetOrder(1)
						DbSeek(xFilial("SED")+_cNatureza)
								_cRetorno := SED->ED_DEBITO
						
						/*
						DO CASE
							CASE ALLTRIM(_cCC) $ "01" // ADMINISTRATIVO
								_cRetorno := SED->ED_DEBITO
							CASE ALLTRIM(_cCC) $ "02" // PRODUCAO
								_cRetorno := SED->ED_DEBPR
							CASE ALLTRIM(_cCC) $ "03" // VENDA
								_cRetorno := SED->ED_DEBVE
							CASE ALLTRIM(_cCC) $ "04" .OR. EMPTY(ALLTRIM(_cCC)) // OUTROS OU EM BRANCO
								_cRetorno := SED->ED_DEBOU
						ENDCASE
						 */                              
						
					ENDIF
				CASE _cCod == "HT"
					_cRetorno := ALLTRIM(ZZ5->ZZ5_HISTOR)
			ENDCASE
	Endif
EndIf

RestArea(_aArea)

Return (_cRetorno)
