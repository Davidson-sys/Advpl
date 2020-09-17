#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zMsWorkTime.
Cria um objeto do tipo barra de período.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zMsWorkTime() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/MsWorkTime
/*/
//--------------------------------------------------------------------
User Function zMsWorkTime()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo MsWorkTime" FROM 180,180 TO 550,700 PIXEL

    oMsWorkTime := MsWorkTime():New(oDlg,01,01,260,184,0,'',{||.T.},{||} )
    oMsWorkTime:SetValue('X X XX X                          X X XX X')

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zMsWorkTime() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
