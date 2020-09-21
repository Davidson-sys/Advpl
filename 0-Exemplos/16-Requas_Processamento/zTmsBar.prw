#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTmsBar.
Cria um objeto do tipo barra de status.
Atualiza o ropapé com o status

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTmsBar() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TMsgBar
/*/
//--------------------------------------------------------------------
User Function zTmsBar()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TMsgBar" FROM 180,180 TO 550,700 PIXEL

    oFont := TFont():New('Courier new',,-14,.T.)

    // Cria barra de status
    oTMsgBar := TMsgBar():New(oDlg, 'MP10 | Totvs/Software',.F.,.F.,.F.,.F., RGB(116,116,116),,oFont,.F.)

    // Cria itens
    oTMsgItem1 := TMsgItem():New( oTMsgBar,'oTMsgItem1', 100,,,,.T., {||} )
    oTMsgItem2 := TMsgItem():New( oTMsgBar,'oTMsgItem2', 100,,,,.T., {||Alert("Clique na barra de status")} )

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTmsBar() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
