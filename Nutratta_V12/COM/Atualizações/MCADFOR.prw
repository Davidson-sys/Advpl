#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
//--------------------------------------------------------------------------
/*{Protheus.doc} MCADFOR
Rotina para ajustar o cadastro de novos fornecedores com 
varias lojas e outras inscrições estaduais.  
Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 20/06/2018
@version P11 R8
Gatilho chamado no campo A2_CGC com retono no campo A2_LOJA   
U_MCADFOR()        
 
A2_CGC
014
A2_LOJA
"00"+SUBSTR(M->A2_CGC,10,2)                                                                             

SUBSTR(M->A2_CGC,1,8)   
Condição 	M->A2_TIPO=="C"                                                                                                     
*/
//--------------------------------------------------------------------------
User Function MCADFOR()  

Local _cFilial	:=	xFilial("SA2")
Local _cCGC		:= 	M->A2_CGC  
Local _cTipo	:=  M->A2_TIPO
Local _cCodFor	:= Substr(M->A2_CGC,1,8) 
Local _nPos		:= IIF( M->A2_TIPO == 'J',11,10)
Local _nTam		:= IIF( M->A2_TIPO == 'J',4,2)
Local _cCodLoj	:= StrZero(Val(SubStr(M->A2_CGC,_nPos,_nTam)),4)
Local _lRet		:= 	.T.
Local _nXi		:=	0
Local _nLoj		:=	0 
Local _lExit	:= .F. 
            
For _nXi := 1 To 100

	dbSelectArea("SA2")
	dbSetOrder(1) //A2_FILIAL+A2_COD+A2_LOJA                                                                                                                                        
	If dbSeek(_cFilial+Padr(_cCodFor,8)+Padr(_cCodLoj,4))

		_lExit 	:= .T. 
		_cCodLoj	:= Alltrim(StrZero(Val(_cCodLoj)+1,4))
	EndIf	   	
    
	If !_lExit
	
   		exit
	EndIf
Next _nXi


Return(_cCodLoj) 
// O gailho só funciona se for pessoa fisica.
//M->A2_LOJA	:= IIF( _cTipo == 'J',SUBSTR(M->A2_CGC,11,4),"00"+SUBSTR(M->A2_CGC,10,2))
//_cCodLoj	:= IIF( _cTipo == 'J',SUBSTR(M->A2_CGC,11,4),"00"+SUBSTR(M->A2_CGC,10,2))
			