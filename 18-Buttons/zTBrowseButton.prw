#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTBrowseButton.
Cria um objeto do tipo botão que não permite foco.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTBrowseButton() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TBrowseButton
/*/
//--------------------------------------------------------------------
User Function zTBrowseButton()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TBrowseButton" FROM 180,180 TO 550,700 PIXEL
    
    oTBrowseButton1 := TBrowseButton():New( 01,01,'TBrowseButton1',oDlg,;
        {||Alert('Clique em TBrowseButton1')},50,10,,,.F.,.T.,.F.,,.F.,,,)

    oTBrowseButton2 := TBrowseButton():New( 20,01,'TBrowseButton2',oDlg,;
        {||Alert('Clique em TBrowseButton2')},50,10,,,.F.,.T.,.F.,,.F.,,,)
    
    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTBrowseButton() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
