#Include "Protheus.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//--------------------------------------------------------------------------
/* {Protheus.doc} MT103IPC
Ponto de entrada para realizar as validações na linha de itens do pedido de vendas.
 
Preencher automaticamente o campo descrição do produto.

Empresa - Copyright - Nutratta Nutrição Animal.
@author Davidson Clayton
@since 16/09/2016
@version P11 R8   

@return Logico (.T. ou .F.)
*/
//--------------------------------------------------------------------------
User Function MT103IPC()

Local aAreSav 	:= GetArea()
Local nLinAux 	:= ParamIXB[1]
//Local nPosXML	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_XIMPXML'})
//Local nPosVun	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_XVUNIT'})
//Local nPosVto	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_XTOTXML'})

GdFieldPut("D1_C_DESCP",SC7->C7_DESCRI, nLinAux)

RestArea(aAreSav)

Return