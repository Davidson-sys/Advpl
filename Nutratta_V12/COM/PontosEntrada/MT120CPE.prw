#include "rwmake.ch"
#include "protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MT120CPE
Este Ponto de entrada � executado ap�s a inicializa��o das 
vari�veis contendo os dados do cabe�alho do Pedido de Compras.
Este ponto de entrada tem por objetivo customizar os dados das vari�veis do cabe�alho do Pedido de Compras.
exclus�o e c�pia dos PCs.

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
ElseIf Alltrim(_cTpCompra) $ "Regulariza��o"
	_cTpCompra:="2"
Else 
	_cTpCompra:=
EndIf
*/

Return

