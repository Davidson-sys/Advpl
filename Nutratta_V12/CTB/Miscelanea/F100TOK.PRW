#include "protheus.ch"

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ F100TOK   ¦ Autor ¦ CARLOS GOMES		 ¦ Data ¦ 20/06/12¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada na confirmação da MB                      ¦¦¦
¦¦¦          ¦ Utilizado para validar o preenchimento do C.Custo Deb      ¦¦¦
¦¦¦          ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ NUT                                                   ¦¦¦    
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/                                                                         

User Function F100TOK()
Local lRet:=.t.

if empty(M->E5_CCD) .and. cRecPag='P'.and. M->E5_RATEIO<>'S'
  Aviso('Atenção!','Informar o campo [C.Custo Deb]',{'Ok'})
  lRet:=.f.
endif

if empty(M->E5_CCC) .and. cRecPag='R' .and. M->E5_RATEIO<>'S'
  Aviso('Atenção!','Informar o campo [C.Custo Cre]',{'Ok'})
  lRet:=.f.
endif

Return lRet
