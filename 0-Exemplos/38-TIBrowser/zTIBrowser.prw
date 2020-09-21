#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTIBrowser.
Cria um objeto do tipo página de internet

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTIBrowser() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TIBrowser
/*/
//--------------------------------------------------------------------
User Function zTIBrowser()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TIBrowser" FROM 180,180 TO 550,700 PIXEL

    oTIBrowser := TIBrowser():New(0,0,260,170, "http://www.totvs.com.br", oDlg )
    TButton():New( 172, 002, "Navigate", oDlg,;
        {|| oTIBrowser:Navigate( "http://tdn.totvs.com/display/home/TDN+-+TOTVS+Developer+Network" ) },;
        ,40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 172, 052, "GoHome", oDlg,;
        {|| oTIBrowser:GoHome() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 172, 102, "Print", oDlg,;
        {|| oTIBrowser:Print() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

    // Disponível apenas em versões superiores a 7.00.170117A - 17.2.0.2
    TButton():New( 172, 152, "GetURL", oDlg,;
        {|| },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    // MsgAlert(oTIBrowser:GetURL())

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTIBrowser() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Erro.

