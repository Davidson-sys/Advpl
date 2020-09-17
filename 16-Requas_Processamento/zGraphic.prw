#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'
#INCLUDE "MSGRAPHI.CH"

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zGraphic.
Cria um objeto para apresentar gráfico.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zGraphic() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TMSGraphic
/*/
//--------------------------------------------------------------------
User Function zGraphic()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TMSGraphic" FROM 180,180 TO 550,700 PIXEL

    // Cria o gráfico
    oGraphic := TMSGraphic():New( 01,01,oDlg,,,RGB(239,239,239),260,184)
    oGraphic:SetTitle('Titulo do Grafico', "Data:" + dtoc(Date()), CLR_HRED, A_LEFTJUST, GRP_TITLE )
    oGraphic:SetMargins(2,6,6,6)
    oGraphic:SetLegenProp(GRP_SCRRIGHT, CLR_LIGHTGRAY, GRP_AUTO, .T.)

    // Itens do Gráfico
    nSerie := oGraphic:CreateSerie( GRP_PIE )

    oGraphic:Add(nSerie, 200, 'Item 01', CLR_HGREEN )
    oGraphic:Add(nSerie, 180, 'Item 02', CLR_HRED)
    oGraphic:Add(nSerie, 210, 'Item 03', CLR_YELLOW )

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zGraphic() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 100% Funcionando.
