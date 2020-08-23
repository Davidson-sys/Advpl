#include 'protheus.ch'
#include 'parmtype.ch'
/*/
{Protheus.doc} MT410ALT
Ponto de Entrada para Flag de Bloqueio

@author Davidson Carvalho
@since  09/05/2019
@version 1.0 

@param  N/H

@return Logico (.T. ou .F.)
/*/
User Function MT410ALT()

Local _aAreaINC 	:= GetArea()
Local _lContinua	:=.T.
 
//-----------------------------------------------------------------------------------
// Não enterar na gravação caso não tenha o valor de frete preenchido.
//-----------------------------------------------------------------------------------
For nxy :=1 To Len(aCols)
	
	_nValFrete	:= aCols[nxy][8]
	
	If _nValFrete == 0 
   		_lContinua:=.F.
   		Exit
	EndIf
Next

If _lContinua

	dbSelectArea("SC5")
	SC5->(dbSetOrder(3))
	If dbSeek(xFilial("SC5")+M->C5_CLIENT+M->C5_LOJACLI+M->C5_NUM)
		If SC5->C5_DIFRTBL <> 0 .And. SC5->C5_LIBTMS=.F.  //Bloqueio Logistica
			
			dbSelectArea("SC5")
			
			RecLock("SC5",.F.)
			
			Replace C5_BLQ With "2"
			SC5->( MsUnLock())
		EndIf
	EndIf
EndIf

	
RestArea(_aAreaINC)	
Return