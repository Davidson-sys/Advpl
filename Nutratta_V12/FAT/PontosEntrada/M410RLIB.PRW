#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
//--------------------------------------------------------------------------
/* {Protheus.doc} M410RLIB
É executado após a gravação das alterações, para refazer as 
liberações de estoque considerando os registros do arquivo 
SDC (composição de empenho) da liberação anterior.

Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 15/04/2019
@version P11 R8
*/
//--------------------------------------------------------------------------
User Function M410RLIB()

Private _lEnd	   	:= .F.
Private _oProcess   := NIL

oProcess := MsNewProcess():New( { |_lEnd| StaticCall(MT410TOK,fProcNut2,_lEnd,oProcess)} ,"Processamento...", "Processando gravação do Pedido...", .F. )
oProcess:Activate()


Return 

