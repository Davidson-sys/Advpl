#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zMenuBar.
Cria um objeto do tipo barra de menu.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zMenuBar() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TMenuBar
/*/
//--------------------------------------------------------------------
User Function zMenuBar()

    Local aSaveArea :=  GetArea()

    oWindow:= TWindow():New(10, 10, 800, 600, 'Exemplo TWindow',,,,,,,,CLR_BLACK,CLR_WHITE,,,,,,,.T.)

    // Monta um Menu Suspenso
    oTMenuBar := TMenuBar():New(oWindow)

    oTMenu1 := TMenu():New(0,0,0,0,.T.,,oWindow)
    oTMenu2 := TMenu():New(0,0,0,0,.T.,,oWindow)
    oTMenuBar:AddItem('Arquivo'  , oTMenu1, .T.)
    oTMenuBar:AddItem('Relatorio', oTMenu2, .T.)

    // Cria Itens do Menu
    oTMenuItem := TMenuItem():New(oWindow,'TMenuItem 01',,,,{||Alert('TMenuItem 01')},,'AVGLBPAR1',,,,,,,.T.)
    oTMenu1:Add(oTMenuItem)
    oTMenu2:Add(oTMenuItem)

    oTMenuItem := TMenuItem():New(oWindow,'TMenuItem 02',,,,{||Alert('TMenuItem 02')},,,,,,,,,.T.)
    oTMenu1:Add(oTMenuItem)
    oTMenu2:Add(oTMenuItem)

    oWindow:Activate('MAXIMIZED')

    RestArea(aSaveArea)

Return

//  u_zMenuBar() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
