#include "tbiconn.ch"
#include "colors.ch"

//-------------------------------------------------------------------------------------------
/*/{Protheus.doc} NTFTENTREG.
Valida��o para n�o permitir informar data de entrega menor que data atual 
e diferente das regras abaixo.
Especifico Nutratta Nutri��o Animal.	
@author   Davidson-Nutratta.
@since 	   17/07/2017.
@version 	P11 R5
@return  	n/t
@obs.......  
o	Chamada:C5_FECENT.
Retorno logico .T. ou .F.
xxx......
/*/
//----------------------------------------------------------------------------------------------------------- 
User Function NTFTENTREG() 

Local lRet		:=.T.
Local cRisco	:=""
Local aAreaSC5	:=GetARea("SC5")
Local dTEntrega	:=M->C5_FECENT
Local dTEmissao	:=M->C5_EMISSAO
Local lTipo		:=.T.
Local dtValida	:="" 
Local cDtDomingo:=Dow(dTEntrega)

//DataValida - Verifica data v�lida no sistema ( [ dData], [ lTipo] ) --> dData   
dtValida:=DataValida(dTEntrega,.T.)

//Valida se a data de entrega � domingo
If cDtDomingo == 1 //Domingo	 

   	Aviso("Nutratta","Data inv�l�da gentileza selecionar um dia util."+Chr(13)+Chr(10)+;
	"N�o s�o relizadas entregas aos domingos!!!",{"Voltar"},2)
	lRet:=.F.

//Se a data de emissao sexta feira conta 4 dias para pular o domingo. 
ElseIf Dow(dTEmissao) == 6  .And. (dTEntrega) < (dTEmissao+4)
	
	Aviso("Nutratta","Prazo m�nimo de entrega D + 3 dias �teis carga fechada"+Chr(13)+Chr(10)+;
	"Prazo m�nimo de entrega D + 3 dias �teis ap�s forma��o de carga para pedidos fracionados.",{"Voltar"},2)
	lRet:=.F.

ElseIf (dTEntrega) < (dTEmissao+3)    
	Aviso("Nutratta","Prazo m�nimo de entrega D + 3 dias �teis carga fechada"+Chr(13)+Chr(10)+;
	"Prazo m�nimo de entrega D + 3 dias �teis ap�s forma��o de carga para pedidos fracionados.",{"Voltar"},2)
	lRet:=.F.
EndIf

RestArea(aAreaSC5)
Return(lRet)

