#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zListBox.
Cria um objeto do tipo lista de itens com barra de rolagem.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zListBox() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TListBox

/*/
//--------------------------------------------------------------------
User Function zListBox()

    Local aSaveArea :=  GetArea()


    DEFINE DIALOG oDlg TITLE "Exemplo TListBox" FROM 180,180 TO 550,700 PIXEL
    aItems := {'Item 1','Item 2','Item 3','Item 4'}
    nList := 1

    // Usando o New
    oList1 := TListBox():New(001,001,{|u|if(Pcount()>0,nList:=u,nList)},aItems,100,100,;
        {||Alert("Mudou de linha")},oDlg,,,,.T.)

    // Usando o Create
    oList2 := TListBox():Create(oDlg,001,110,{|u|if(Pcount()>0,nList:=u,nList)},;
        aItems,100,100,,,,,.T.)
    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zListBox() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
