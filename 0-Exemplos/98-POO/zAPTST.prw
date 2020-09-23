#include "protheus.ch"

USER FUNCTION APTST()
    Local oObj := APHello():New("Olá mundo Advpl")
    oObj:SayHello()
Return

CLASS APHELLO
    Data cMsg as String
    Method New(cMsg) CONSTRUCTOR
    Method SayHello()
ENDCLASS

METHOD NEW(cMsg) CLASS APHELLO
    self:cMsg := cMsg
Return self

METHOD SAYHELLO() CLASS APHELLO
    MsgInfo(self:cMsg)
Return .T.
