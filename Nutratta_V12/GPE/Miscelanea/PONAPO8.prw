#Include 'Protheus.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
//--------------------------------------------------------------------------
/* {Protheus.doc} PONAPO8
Esse ponto de entrada, na de 'Leitura/Apontamento', � executado ap�s todo o processamento e antes de retornar ao menu.
Esse ponto de entrada � utilizao para modificar o parametro MV_APHEDTM para N.

MV_APHEDTM = Aponta hora extra considerando a data da marcacao.
Aponta hora extra considerando a data da marcacao.

Empresa - Copyright -Nutratta Nutri��o Animal.
@author Davidson Clayton
@since 31/10/2016
@version P11 R8
*/
//--------------------------------------------------------------------------
User Function PONAPO8()

//-----------------------------------------------------------------------------------
// Posicona no paramentro para alterar seu cont�udo.
//-----------------------------------------------------------------------------------
PUTMV("MV_APHEDTM","N")

Return


 
