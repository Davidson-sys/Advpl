#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

#DEFINE CRLF Chr(13)+Chr(10)
/*
�+-----------------------------------------------------------------------------+�
��Programa  �MA020TOK          � Autor � Davidson Clayton    � Data �15/08/2017��
�+----------+------------------------------------------------------------------��
��Descri��o �  Nas valida��es ap�s a confirma��o, antes da grava��o do 		   ��
��          �fornecedor, deve ser utilizado para valida��es adicionais para    ��
��			�a INCLUS�O do fornecedor.										   ��
�+----------+------------------------------------------------------------------��
��			ATUALIZA��ES SOFRIDAS DESDE A CONSTRU��O INICIAL				   ��
�+-----------------------------------------------------------------------------��
�� Analista           � Dat			a        �  Motivo da Altera��o			   ��
�+--------------------+-------------+------------------------------------------��
�� 				      �				�		  								   ��
�+--------------------+-------------+------------------------------------------+�
*/

User Function MA020TOK()

Local lRet	:= .T.
Local cMsg	:= "     Quando o Tipo � PESSOA F�SICA, � necess�rio preencher os campos abaixo!" + CRLF

	If M->A2_TIPO == "F"
		
		//----------------------------------------------------------------------------------------------------------------------
		// Caso tenha inscri��o estadual significa que o mesmo � produtor rural e nao precisa de PIS/MAE/DTNAS.
		//---------------------------------------------------------------------------------------------------------------------- 
		If M->A2_INSCR $ 'ISENTO' 
				
			If Empty(M->A2_N_DTNAS)
				cMsg	+= "     [ Dt. Nascimento -      A2_N_DTNAS ]" + CRLF
				lRet	:= .F.
			Endif
			
			If Empty(M->A2_N_NMAE)
				cMsg	+= "     [ Nome Mae  -            A2_N_NMAE ]" + CRLF
				lRet	:= .F.
			Endif
			
			If Empty(M->A2_N_PIS)
				cMsg	+= "     [ numero do PIS  -       A2_N_PIS ]" + CRLF
				lRet	:= .F.
			Endif
		EndIf
		
		/*
		If Empty(M->A2_RECINSS)
			cMsg 	+= "[ Calc. INSS - A2_RECINSS ]" + CRLF
			lRet	:= .F.
		Endif
		
		If Empty(M->A2_RECSEST)
			cMsg 	+= "[Recolhe SEST - A2_RECSEST ]" + CRLF
			lRet	:= .F.
		Endif
		*/
		If Len(cMsg) > 73
			MsgInfo(cMsg,"Campos Obrigat�rios.")
		Endif
	Endif

Return (lRet)