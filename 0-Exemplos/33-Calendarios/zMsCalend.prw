#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zMsCalendar.
Cria um objeto do tipo calendário

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zMsCalendar() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/MsCalend
/*/
//--------------------------------------------------------------------
User Function zMsCalendar()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo MsCalend" FROM 180,180 TO 550,700 PIXEL

    // Cria objeto
    oMsCalend            := MsCalend():New(01, 01, oDlg, .T.)

    // Define o dia a ser exibido no calendário
    oMsCalend:dDiaAtu    := ctod( "01/01/2008" )

    // Code-Block para mudança de Dia
    oMsCalend:bChange    :={|| Alert( 'Dia Selecionado: ' + dtoc(oMsCalend:dDiaAtu)) }

    // Code-Block para mudança de mes
    oMsCalend:bChangeMes :={|| alert( 'Mes alterado' ) }

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zMsCalendar() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 100% Funcionando.
