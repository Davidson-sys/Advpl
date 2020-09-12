#Include 'Rwmake.ch'
#Include 'Colors.ch'
#Include 'Protheus.ch'
#include 'Totvs.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} zMsDialog.
Exemplo da utiliza��o da Classe MsDialog
utilizada para entrada de dados.

� uma janela de aplica��o,dentro da qual s�o constru�das as demais interfaces,
como telas, bot�es, valida��es, etc

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zMsDialog() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/pages/viewpage.action?pageId=24346988
/*/
//--------------------------------------------------------------------
User Function zMsDialog()

    Local aSize     := {}
    Local bOk       := {|| }
    Local bCancel   := {|| oDialog:End() }
    Local aItens    :=  {'Normal','Regulariza��o','Ambos'}
    Local oFtTxt    := TFont():New('Tahoma',,018,,.T.,,,,,.F.,.F.)
    Local aSaveArea :=  GetArea()
    Local oDialog
    Local cItens

    aSize           := MsAdvSize(.F.)

    /*
    MsAdvSize (http://tdn.totvs.com/display/public/mp/MsAdvSize+-+Dimensionamento+de+Janelas) 
    aSize[1] = 1 -> Linha inicial �rea trabalho.
    aSize[2] = 2 -> Coluna inicial �rea trabalho.
    aSize[3] = 3 -> Linha final �rea trabalho.
    aSize[4] = 4 -> Coluna final �rea trabalho.
    aSize[5] = 5 -> Coluna final dialog (janela).
    aSize[6] = 6 -> Linha final dialog (janela).
    aSize[7] = 7 -> Linha inicial dialog (janela).
    */

    Define MsDialog oDialog TITLE 'Atualiza��o' STYLE DS_MODALFRAME From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
    //Se n�o utilizar o MsAdvSize, pode-se utilizar a propriedade lMaximized igual a T para maximizar a janela
    //oDialog:lMaximized := .T. //Maximiza a janela
    //Usando o estilo STYLE DS_MODALFRAME, remove o bot�o X


    //Lin e Col
    @ 050,005 SAY 'Pedidos :' FONT oFtTxt PIXEL OF oDialog
    @ 050,045 COMBOBOX cItens ITEMS aItens SIZE 052,008 PIXEL OF oDialog
    @ 049,102 BUTTON 'Filtrar' SIZE 060,012 ACTION oDlg:End() OF oDialog PIXEL

    ACTIVATE MSDIALOG oDialog ON INIT EnchoiceBar(oDialog, bOk , bCancel) CENTERED

    RestArea(aSaveArea)

Return

//  u_zMsDialog() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 100% Funcionando

//Teste git hub 17:46

