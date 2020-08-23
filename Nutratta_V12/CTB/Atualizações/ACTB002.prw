#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACTB002   ºAutor  ³                    º Data ³  17/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a conta DEBITO/CREDITO/HISTORICO de um grupo de tesº±±
±±º          ³ de saida.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ACTB002(_cCod)

	Local _cRetorno := ''
	Local _aArea := GetArea()
	Local _cGrupo := ''    
	


	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek(xFilial("SF4")+ALLTRIM(SD2->D2_TES),.T.)
	_cGrupo := SF4->F4_Z_GRPTE

	dbSelectArea("ZZ5")
	dbSetOrder(1)
	If dbSeek(xFilial("ZZ5")+ALLTRIM(_cGrupo),.T.)

		DO CASE
			CASE _cCod == "CC"
			IF !EMPTY(ALLTRIM(ZZ5->ZZ5_CTACRE)) // SE O GRUPO DE TES ESTIVER PREENCHIDO PREVALECE A CONTA CREDITO DO GRUPO DE TES
				_cRetorno := ZZ5->ZZ5_CTACRE


			ELSEIF SF4->F4_ESTOQUE = "S"   .AND. SF4->F4_DUPLIC = "N"  
			
							dbSelectArea("SBM")
							dbSetOrder(1)
							IF dbSeek(xFilial("SBM")+ALLTRIM(SD1->D1_GRUPO),.T.)
				         	
				         		_cRetorno := SBM->BM_C_CTEST  
				         	
				         	ENDIF	

			ELSEIF SF4->F4_DUPLIC = "S" .AND. ALLTRIM(SD2->D2_CF) != "5202/6202"
				_cNatureza := Posicione("SE1",2,XFILIAL("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DOC,"E1_NATUREZ")

				DbSelectArea("SED")
				DbSetOrder(1)
				DbSeek(xFilial("SED")+ALLTRIM(_cNatureza))
				_cRetorno := SED->ED_CREDIT				

			ENDIF   

			CASE _cCod == "CD"
			IF !EMPTY(ALLTRIM(ZZ5->ZZ5_CTADEB)) // SE O GRUPO DE TES ESTIVER PREENCHIDO PREVALECE A CONTA CREDITO DO GRUPO DE TES
				_cRetorno := ZZ5->ZZ5_CTADEB

				/*	
				ELSEIF  SF4->F4_ESTOQUE == "S"  .AND. !EMPTY(NNR->NNR_N_CTCO) 
				_cRetorno := NNR->NNR_N_CTCO 
				*/	
			ELSEIF  SF4->F4_DUPLIC == "S"
				_cNatureza := Posicione("SE1",2,XFILIAL("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DOC,"E1_NATUREZ")

				DbSelectArea("SED")
				DbSetOrder(1)
				DbSeek(xFilial("SED")+ALLTRIM(_cNatureza))
				_cRetorno := SED->ED_DEBITO

			ENDIF

			CASE _cCod == "HT"
			_cRetorno := ALLTRIM(ZZ5->ZZ5_HISTOR)
		ENDCASE
	EndIf

	RestArea(_aArea)

Return (_cRetorno)
