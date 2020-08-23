#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
//--------------------------------------------------------------------------
/* {Protheus.doc} N_INSERCT2
Realiza a inclus�o dos registros na CT2.
Empresa - Copyright -Nutratta Nutri��o Animal.
@author Davidson Clayton
@since 20/06/2018
@version P11 R8

*/
//--------------------------------------------------------------------------
User Function MT094CCR()
Local cCampos := "|CR_PRAZO|CR_AVISO" //  O retorno deve come�ar com uma barra vertical ( | ) e ir intercalando o nomes do campos com barras verticais. 
Return (cCampos)