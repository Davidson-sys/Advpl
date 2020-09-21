#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zSButton.
Cria um objeto do tipo botão

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zSButton() 		//Chamar no executor.

A aparência deste objeto depende do tema (Flat, Ocean, Classic, TemaP10)
que estiver em uso

Link TDN:
https://tdn.totvs.com/display/tec/SButton
/*/
//--------------------------------------------------------------------
User Function zSButton()

    Local aSaveArea :=  GetArea()


    DEFINE DIALOG oDlg TITLE "Exemplo SButton - Tema TemaP10" FROM 180,180 TO 550,700 PIXEL

    // Cria relação de botões
    @ 01,001 SAY 'Tipo: 1' OF oDlg PIXEL
    @ 01,031 SAY 'Tipo: 2' OF oDlg PIXEL
    @ 01,061 SAY 'Tipo: 3' OF oDlg PIXEL
    @ 01,091 SAY 'Tipo: 4' OF oDlg PIXEL
    @ 01,121 SAY 'Tipo: 5' OF oDlg PIXEL

    SButton():New( 11,001,01,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 11,031,02,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 11,061,03,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 11,091,04,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 11,121,05,{||Alert('SButton')},oDlg,.T.,,)

    @ 31,001 SAY 'Tipo: 6' OF oDlg PIXEL
    @ 31,031 SAY 'Tipo: 7' OF oDlg PIXEL
    @ 31,061 SAY 'Tipo: 8' OF oDlg PIXEL
    @ 31,091 SAY 'Tipo: 9' OF oDlg PIXEL
    @ 31,121 SAY 'Tipo:10' OF oDlg PIXEL

    SButton():New( 41,001,06,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 41,031,07,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 41,061,08,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 41,091,09,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 41,121,10,{||Alert('SButton')},oDlg,.T.,,)

    @ 61,001 SAY 'Tipo:11' OF oDlg PIXEL
    @ 61,031 SAY 'Tipo:12' OF oDlg PIXEL
    @ 61,061 SAY 'Tipo:13' OF oDlg PIXEL
    @ 61,091 SAY 'Tipo:14' OF oDlg PIXEL
    @ 61,121 SAY 'Tipo:15' OF oDlg PIXEL

    SButton():New( 71,001,11,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 71,031,12,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 71,061,13,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 71,091,14,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 71,121,15,{||Alert('SButton')},oDlg,.T.,,)

    @ 91,001 SAY 'Tipo:16' OF oDlg PIXEL
    @ 91,031 SAY 'Tipo:17' OF oDlg PIXEL
    @ 91,061 SAY 'Tipo:18' OF oDlg PIXEL
    @ 91,091 SAY 'Tipo:19' OF oDlg PIXEL
    @ 91,121 SAY 'Tipo:20' OF oDlg PIXEL

    SButton():New( 101,001,16,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 101,031,17,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 101,061,18,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 101,091,19,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 101,121,20,{||Alert('SButton')},oDlg,.T.,,)

    @ 121,001 SAY 'Tipo:21' OF oDlg PIXEL
    @ 121,031 SAY 'Tipo:22' OF oDlg PIXEL
    @ 121,061 SAY 'Tipo:23' OF oDlg PIXEL

    SButton():New( 131,001,21,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 131,031,22,{||Alert('SButton')},oDlg,.T.,,)
    SButton():New( 131,061,23,{||Alert('SButton')},oDlg,.T.,,)

    ACTIVATE DIALOG oDlg CENTERED
    RestArea(aSaveArea)

Return

//  u_zSButton()		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 100% Funcionando.
