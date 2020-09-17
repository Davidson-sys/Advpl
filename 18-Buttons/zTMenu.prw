#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'
#INCLUDE "PTMENU.CH"
#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTMenu.
Cria um objeto do tipo menu.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTMenu() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TMenu
/*/
//--------------------------------------------------------------------
User Function zTMenu()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TMenu" FROM 180,180 TO 550,700 PIXEL
    oMenuMain := TMenu():New( 0,0,0,0,.F.,'',oDlg,CLR_BLACK,CLR_BLACK)

    // Adiciona item ao menu principal
    oMenuDiv := TMenuItem():New2( oMenuMain:Owner(),'Item 001','',,,)
    oMenuMain:Add( oMenuDiv )

    // Adiciona sub-Itens
    oMenuItem1 := TMenuItem():New2( oMenuMain:Owner(),'Sub-Item 001',,,{||Alert('TMenuItem 1')})
    oMenuDiv:Add( oMenuItem1 )
    oMenuItem2 := TMenuItem():New2( oMenuMain:Owner(),'Sub-Item 002',,,{||Alert('TMenuItem 2')})
    oMenuDiv:Add( oMenuItem2 )

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTMenu() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 50% Funcionando.
