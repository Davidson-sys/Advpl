#INCLUDE "TOTVS.CH"   
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBTREE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} NUT_CheckTime.
Função para validar a hora informada no campo.	
@Author   Davidson
@Since 	   17/07/2017
@Version 	P11 R5
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico NUTRATTA 
	ZZJ_HRECDE
	ZZJ_HRECA
xxx......
/*/
//-----------------------------------------------------------------------------------------------------------
User Function NUT_CheckTime() 

	Local cHora	:= &(__READVAR)
	Local lRet 	:= .T.
	Local cH 	:= SubStr(cHora,1,2)
	Local cM 	:= SubStr(cHora,4,2)
	
	If Len(AllTrim(cHora)) < 5
		Return .F.
	EndIf
	
	If (Val(cH) < 0) .or. (Val(cH) > 23)
		Return .F.
	EndIf
	
	If (Val(cM) < 0) .or. (Val(cM) > 59)
		Return .F.
	EndIf
	//Obrigatorio o uso da mascara.
	If !(":" $ cHora) 
		Return .F.
	End    

Return lRet