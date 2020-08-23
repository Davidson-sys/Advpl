#include "PROTHEUS.ch"
 

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ FA050INC  ¦ Utilizador ¦ CARLOS GOMES¦ Data ¦ 20/06/12¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada na confirmação do Tit Pagar               ¦¦¦
¦¦¦          ¦ Utilizado para validar o preenchimento do C.Custo Deb      ¦¦¦
¦¦¦          ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦  NUT¦¦¦    
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/  

User Function FA050INC()
Local lRet:=.t.

if 'TMSA144D'$Funname() .or. 'TMSA250'$Funname()
  M->E2_CCD:=DT7->DT7_CC
endif

if 'GPEM670'$Funname()
  Return .t. //Ignora Titulo folha
endif

if empty(M->E2_CCD) .AND. M->E2_RATEIO<>'S'.AND.!ALLTRIM(M->E2_TIPO)$"PA/EMP/FI"
  Aviso('Atenção!','Informar o campo [C.Custo Deb]',{'Ok'})
  lRet:=.f.
endif
if ALLTRIM(M->E2_TIPO)$"EMP/FI" .AND. EMPTY(M->E2_ITEMD)
  Aviso('Atenção!','Informar o campo [Item Ctb. Deb]',{'Ok'})
  lRet:=.f.
endif

Return lRet