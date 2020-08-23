#Include "Protheus.ch" 

//Em teste não compilar 12/05/2017.
/*
¦+-----------------------------------------------------------------------------+¦
¦¦Programa  ¦MT103FIM	       ¦ Autor ¦ Lucas Nogueira     ¦ Data ¦ 19/08/2016¦¦
¦+----------+------------------------------------------------------------------¦¦
¦¦Descrição ¦Após o destravamento de todas as tabelas envolvidas na gravação   ¦¦
¦¦          ¦do documento de entrada, depois de fechar a operação realizada    ¦¦
¦¦			¦neste, é utilizado para realizar alguma operação após a gravação  ¦¦
¦¦			¦da NFE.                                                 		   ¦¦
¦+----------+------------------------------------------------------------------¦¦
¦¦			ATUALIZAÇÕES SOFRIDAS DESDE A CONSTRUÇÃO INICIAL     			   ¦¦
¦+-----------------------------------------------------------------------------¦¦
¦¦ Analista 	 ¦ Data    ¦  Motivo da Alteração				       		   ¦¦
¦+---------------+---------+---------------------------------------------------¦¦
¦¦	   			 ¦	       ¦							       				   ¦¦
¦+---------------+---------+---------------------------------------------------¦¦
¦¦	 		     ¦	       ¦											       ¦¦
¦+---------------+---------+---------------------------------------------------+¦
*/
User Function MT103FIM()

Local nOpcao 		:= PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina
Local nConfirma 	:= PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFE CODIGO DE APLICAÇÃO DO USUARIO.....

	If nConfirma == 1
		U_ACOM001()
	Endif

Return()