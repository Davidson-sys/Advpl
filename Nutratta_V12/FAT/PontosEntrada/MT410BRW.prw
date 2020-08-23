#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MTA410BRW
Ponto de Entrada Para Criar Opcao do Menu de Liberacao de PEdido.

@author Davis Magalhães
@since  27/04/2016
@version 1.0 

@param  N/H

@return Logico (.T. ou .F.)
/*/

User Function MT410BRW()

Local cUsuLib 	:= SuperGetMv("NT_USULBP",.F.,"000000")
Local cCodUsr 	:= RetCodUsr()


If cCodUsr $ cUsuLib
	aadd(aRotina,{"Lib Bloqueio Nutratta" ,"U_NFATLIB",0,len(aRotina)+1})	
EndIf

return
