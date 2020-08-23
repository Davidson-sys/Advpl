#INCLUDE "TOTVS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ SPFCLOSEบ Autor ณ Nelltech Gestao de TI บ Data ณ 15/12/15  บฑฑ
ฑฑฬออออออออออุอออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Funcao utilizada para fechar aqquivo de senha para recuperaบฑฑ
ฑฑบ          ณ cao senha ADMINISTRADOR                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CONFIGURADOR - Nutratta                                    บฑฑ
ฑฑฬออออออออออฯอออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบNelltech Gestao de TI ณ Leandro Otoni                                  บฑฑ
ฑฑศออออออออออออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
/*/{Protheus.doc} SPFCLOSE
Fechar arquivo de senha
@Example U_SPFCLOSE()
@Example U_SPFCLOSEX()
/*/
User Function SPFCLOSE()

SPF_CLOSE("SIGAPSS.SPF")

Return( Nil )