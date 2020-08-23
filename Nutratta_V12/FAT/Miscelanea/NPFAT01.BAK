#INCLUDE "PROTHEUS.CH"       
#INCLUDE "RWMAKE.CH"    
#INCLUDE "TOPCONN.CH"       
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NPFAT01 º Autor ³ Nelltech Gestao de TI º Data ³ 28/05/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para validacao no campo vendedor (C5_VEND1) para    º±±
±±º          ³ que seja valido apenas quando o vendedor digitado estiver  º±±
±±º          ³ no cadastro do cliente.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Logico								                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Pedido de Vendas(C5_VEND1) - Nutratta                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºNelltech Gestao de TI ³ Juarez Fernandes/Lucas Lima                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NPFAT01()

Local _aArea       := GetArea()
Local _aAreaSA1    := SA1->(GetArea())
Local _cTipo       := M->C5_TIPO
Local _cCliente    := M->C5_CLIENTE
Local _cLojacli    := M->C5_LOJACLI
Local _cVendedor   := M->C5_VEND1
Local _cVend       := ""
Local _lRet        := .T.

//tipo Pedido 
If _cTipo $ "NCIP"

	//vendedor cadastrado para o cliente
	_cVend  := Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLojaCli,"A1_VEND")
	
	//se vendedor salvo para cliente diferente do digitado no pedido
	If _cVend <> _cVendedor
		_lRet := .F.
		MsgInfo("Vendedor "+_cVendedor+" não está cadastrado para o Cliente "+_cCliente+". ")
	EndIf
	
EndIf 

SA1->(RestArea(_aAreaSA1))
RestArea(_aArea)

Return(_lRet)