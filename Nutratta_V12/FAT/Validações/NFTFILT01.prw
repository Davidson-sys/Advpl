#include "tbiconn.ch"
#include "colors.ch"

//-------------------------------------------------------------------------------------------
/*/{Protheus.doc} FILTCOND.
	Fun��o para realizar o filtro dentro da consulta padrao SE4FAT.

Especifico Nutratta Nutri��o Animal.	
@author   Davidson
@since 	   04/10/2016.
@version 	P11 R5
@return  	n/t
@obs.......  
o	
xxx......
/*/
//-----------------------------------------------------------------------------------------------------------  
User Function FILTCOND()
Local cFiltx:=""
Local cRisco:=""
Local aAreaSE4:=GetARea("SE4")

//--Filtro ser� realizado somente para tipo normal.
If M->C5_TIPO="N"

	//#IIF(ALLTRIM(RETCODUSR())$"000081/000013/000037/000068","@E4_CODIGO <> '' ","@E4_N_CRM = 'S'")
	If Alltrim(RETCODUSR())$ "000081/000013/000037/000068"

		cFiltx:=SE4->E4_CODIGO <> '' .And. SE4->E4_CODIGO <='089'
	Else

		//--Filtra a condi��o de acordo com o risco do cliente.
		If !Empty(M->C5_CLIENTE)
	
			//--Risco do cliente.
			dbSelectArea("SA1")
			dbSetOrder(1)
			If dbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)
		
				cRisco:=SA1->A1_RISCO
				//cFiltx:=SE4->E4_N_CRM = 'S' //Condi��es de pagamentos utilizadas no portal.
			EndIf

			//--Busca na ZZ8 as condi��es de pagamento de acordo com o risco do cliente.
			If !Empty(cRisco)
				dbSelectArea("ZZ8")
				dbSetOrder(1)
				dbGotop()
				While ZZ8->(!Eof())
					If ZZ8->ZZ8_RISCO == cRisco
	
						cFiltx+=ZZ8->ZZ8_CODIGO+"/"  //Filtra as condi��es de pagamento.
					EndIf
					ZZ8->(dbSkip())
				End
			EndIf
		EndIf
	EndIf
Else
	//--Caso n�o seja pedido de venda normal.
	cFiltx:="001" //A vista
EndIf
RestArea(aAreaSE4)
Return(@cFiltx)
                                                                                                                                                                                                                                            


