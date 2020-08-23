#Include "Protheus.ch" 

//Em teste n�o compilar 12/05/2017.
/*
�+-----------------------------------------------------------------------------+�
��Programa  �MT103FIM	       � Autor � Lucas Nogueira     � Data � 19/08/2016��
�+----------+------------------------------------------------------------------��
��Descri��o �Ap�s o destravamento de todas as tabelas envolvidas na grava��o   ��
��          �do documento de entrada, depois de fechar a opera��o realizada    ��
��			�neste, � utilizado para realizar alguma opera��o ap�s a grava��o  ��
��			�da NFE.                                                 		   ��
�+----------+------------------------------------------------------------------��
��			ATUALIZA��ES SOFRIDAS DESDE A CONSTRU��O INICIAL     			   ��
�+-----------------------------------------------------------------------------��
�� Analista 	 � Data    �  Motivo da Altera��o				       		   ��
�+---------------+---------+---------------------------------------------------��
��	   			 �	       �							       				   ��
�+---------------+---------+---------------------------------------------------��
��	 		     �	       �											       ��
�+---------------+---------+---------------------------------------------------+�
*/
User Function MT103FIM()

Local nOpcao 		:= PARAMIXB[1]   // Op��o Escolhida pelo usuario no aRotina
Local nConfirma 	:= PARAMIXB[2]   // Se o usuario confirmou a opera��o de grava��o da NFE CODIGO DE APLICA��O DO USUARIO.....

	If nConfirma == 1
		U_ACOM001()
	Endif

Return()