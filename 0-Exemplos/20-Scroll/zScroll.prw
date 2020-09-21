#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zScroll.
Cria um objeto do tipo painel com barra de rolagem (Scroll).

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zScroll() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TScrollBox
/*/
//--------------------------------------------------------------------
User Function zScroll()

    Local aSaveArea := GetArea()

    local bTexto    := {|| 'Texto para exibição ' +;
        'Texto para exibição ' +;
        'Texto para exibição' }
        

    DEFINE DIALOG oDlg TITLE "Exemplo TScrollBox" FROM 180,180 TO 550,700 PIXEL
    
    // Usando o método New
    oScr1 := TScrollBox():New(oDlg,01,01,92,260,.T.,.T.,.T.)

    // Cria objetos para teste do Scroll
    oFont := TFont():New('Courier new',,-22,.T.)

    oSay1:= TSay():New(01, 01, bTexto, oScr1,,oFont,,;
        ,,.T.,CLR_RED,CLR_WHITE,400,20)

    oSay2:= TSay():New(01,01, bTexto, oScr1,,oFont,,;
        ,,.T.,CLR_RED,CLR_WHITE,400,20)

    // Usando o método Create
    oScr2 := TScrollBox():Create(oDlg,93,01,92,260,.T.,.T.,.T.)

    oSay3:= TSay():New(01, 01, bTexto, oScr2,,oFont,,;
        ,,.T.,CLR_RED,CLR_WHITE,400,20)

    oSay4:= TSay():New(01, 01, bTexto, oScr2,,oFont,,;
        ,,.T.,CLR_RED,CLR_WHITE,400,20)
    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zScroll() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
