#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTPageView.
Cria um objeto que permite visualizar um arquivo no formato gerado pelo spool de impressão.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTPageView() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TPageView
/*/
//--------------------------------------------------------------------
User Function zTPageView()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TPageView" FROM 180,180 TO 550,700 PIXEL

    oPrinter := TMsPrinter():New()
    oPrinter:SetFile( '\SPOOL\rfin07.prt', .F.)
    oTPageView := TPageView():New( 0,0,510,354,oPrinter,oDlg,550,550 )
    oTPageView:Show()
    oTPageView:nZoom := 150

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTPageView() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
