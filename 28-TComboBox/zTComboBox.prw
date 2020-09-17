#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTComboBox.
Cria um objeto do tipo caixa de seleção (ComboBox). 
Este controle permite a entrada de dados de múltipla escolha 
através dos itens definidos em uma lista vertical. Essa lista 
pode ser acessada ao pressionar a tecla F4 ou pelo botão à direita do controle.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTComboBox() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TComboBox
/*/
//--------------------------------------------------------------------
User Function zTComboBox()

    Local aSaveArea := GetArea()
    Local aItems    :={'Item1', 'Item2', 'Item3'}

    DEFINE DIALOG oDlg TITLE "Exemplo TComboBox" FROM 180,180 TO 550,700 PIXEL

    // Usando New
    cCombo1:= aItems[1]
    oCombo1 := TComboBox():New(02,02,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},;
        aItems,100,20,oDlg,,{||Alert('Mudou item da combo')};
        ,,,,.T.,,,,,,,,,'cCombo1')

    // Usando Create
    cCombo2:= aItems[2]
    oCombo2 :=  TComboBox():Create(oDlg,{|u|if(PCount()>0,cCombo2:=u,cCombo2)},22,02,;
        aItems,100,20,,{||Alert('Mudou item da combo')},,,,.T.,;
        ,,,,,,,,'cCombo2')

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTComboBox() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.

