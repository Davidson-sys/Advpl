#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTRadioMenu.
Cria um objeto do tipo Radio Button (elemento de seleção de única escolha).

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTRadioMenu() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TRadMenu
/*/
//--------------------------------------------------------------------
User Function zTRadioMenu()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TRadMenu" FROM 180,180 TO 550,700 PIXEL

    nRadio := 1
    aItems := {'Item01','Item02','Item03','Item04','Item05'}
    oRadio := TRadMenu():New (01,01,aItems,,oDlg,,,,,,,,100,12,,,,.T.)
    oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTRadioMenu() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
