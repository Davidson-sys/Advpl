#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zCheckBox.
Cria um objeto do tipo caixa de seleção (CheckBox).

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zCheckBox() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TCheckBox
/*/
//--------------------------------------------------------------------
User Function zCheckBox()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TCheckBox" FROM 180,180 TO 550,700 PIXEL
    
    lCheck := .T.    // Usando New
    
    oCheck1 := TCheckBox():New(01,01,'CheckBox 001',{||lCheck},oDlg,100,210,,,,,,,,.T.,,,)
    oCheck2 := TCheckBox():New(11,01,'CheckBox 002',{||lCheck},oDlg,100,210,,,,,,,,.T.,,,)
    oCheck3 := TCheckBox():New(21,01,'CheckBox 003',,oDlg,100,210,,,,,,,,.T.,,,)
    oCheck4 := TCheckBox():New(31,01,'CheckBox 004',,oDlg,100,210,,,,,,,,.T.,,,)
    oCheck5 := TCheckBox():New(41,01,'CheckBox 005',,oDlg,100,210,,,,,,,,.T.,,,)
    
    // Usando Create
    oCheck6 := TCheckBox():Create( oDlg,{||lCheck},61,01,'CheckBox 006',100,210,,,,,,,,.T.,'CheckBox 006',,)
    oCheck7 := TCheckBox():Create( oDlg,{||lCheck},71,01,'CheckBox 007',100,210,,,,,,,,.T.,'CheckBox 007',,)
    
    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zCheckBox() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.

