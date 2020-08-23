#INCLUDE "PROTHEUS.CH"

/*
========================================================================================================================
Rotina----: CMA150AMNU
Autor-----: Davidson Clayton
Data------: 07/06/2018
========================================================================================================================
Descri��o-: Permite incluir novos itens no menu "A��es Relacionadas".
Uso-------:  
========================================================================================================================
*/
User Function CMA150AMNU()
      
Local aRotAdic:={}	//PARAMIXB[1]

	aAdd( aRotAdic, {"Armaz.Bloq/Desbloq","U_MPCP001()", 0, 4, 0, Nil } ) 

Return (aRotAdic)



