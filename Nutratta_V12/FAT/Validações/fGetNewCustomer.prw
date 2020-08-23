#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
//--------------------------------------------------------------------------
/*{Protheus.doc} fGetNewCustomer
Realiza a verifica��o se � a primeira compra do cliente.
Empresa - Copyright -Nutratta Nutri��o Animal.
@author Davidson Clayton
@since 09/08/2018                               
@version P11 R8
*/
//--------------------------------------------------------------------------

User Function fGetNewCustomer(cCodCliente,cCodLoja)
      
Local lFirst	:=.F.
       
dbSelectArea("SF2")
dbSetOrder(2)
If !dbSeek(xFilial("SF2")+cCodCliente+cCodLoja)
	lFirst		:=.T.
EndIf

Return(lFirst)