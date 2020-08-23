#include "rwmake.ch"
#include "protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MT120CPE
Este Ponto de entrada é executado após a inicialização das 
variáveis contendo os dados do cabeçalho do Pedido de Compras.
Este ponto de entrada tem por objetivo customizar os dados das variáveis do cabeçalho do Pedido de Compras.
exclusão e cópia dos PCs.

@author 	Davidson - Nutratta
@since 		09/11/2017.
@version 	P11 R8
@param   	n/t
@return  	n/t
@obs
Exclusivo para Nutratta
/*/
//-------------------------------------------------------------------

User Function MT120CPE()

Local ExpN1 := PARAMIXB[1]
Local ExpL1 := PARAMIXB[2] 
Local cTipo	:= SC7->C7_TPCOMP
          
M->C7_TPCOMP:=SC7->C7_TPCOMP     

//If 
//GDFIELDPOS("C7_TPCOMP",n)

/*
If Alltrim(_cTpCompra) $ "Normal"
	_cTpCompra:="1"
ElseIf Alltrim(_cTpCompra) $ "Regularização"
	_cTpCompra:="2"
Else 
	_cTpCompra:=
EndIf
*/

Return

