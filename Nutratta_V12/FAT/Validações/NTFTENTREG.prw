#include "tbiconn.ch"
#include "colors.ch"

//-------------------------------------------------------------------------------------------
/*/{Protheus.doc} NTFTENTREG.
Validação para não permitir informar data de entrega menor que data atual 
e diferente das regras abaixo.
Especifico Nutratta Nutrição Animal.	
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

//DataValida - Verifica data válida no sistema ( [ dData], [ lTipo] ) --> dData   
dtValida:=DataValida(dTEntrega,.T.)

//Valida se a data de entrega é domingo
If cDtDomingo == 1 //Domingo	 

   	Aviso("Nutratta","Data inválída gentileza selecionar um dia util."+Chr(13)+Chr(10)+;
	"Não são relizadas entregas aos domingos!!!",{"Voltar"},2)
	lRet:=.F.

//Se a data de emissao sexta feira conta 4 dias para pular o domingo. 
ElseIf Dow(dTEmissao) == 6  .And. (dTEntrega) < (dTEmissao+4)
	
	Aviso("Nutratta","Prazo mínimo de entrega D + 3 dias úteis carga fechada"+Chr(13)+Chr(10)+;
	"Prazo mínimo de entrega D + 3 dias úteis após formação de carga para pedidos fracionados.",{"Voltar"},2)
	lRet:=.F.

ElseIf (dTEntrega) < (dTEmissao+3)    
	Aviso("Nutratta","Prazo mínimo de entrega D + 3 dias úteis carga fechada"+Chr(13)+Chr(10)+;
	"Prazo mínimo de entrega D + 3 dias úteis após formação de carga para pedidos fracionados.",{"Voltar"},2)
	lRet:=.F.
EndIf

RestArea(aAreaSC5)
Return(lRet)

