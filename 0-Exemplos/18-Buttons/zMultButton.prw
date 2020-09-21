#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zMultButton.
Cria um objeto do tipo múltiplos botões.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zMultButton() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TMultiBtn
/*/
//--------------------------------------------------------------------
User Function zMultButton()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TMultiBtn" FROM 180,180 TO 550,700 PIXEL

    otMultiBtn := tMultiBtn():New( 01,01,'Titulo',oDlg,,200,150, 'Afastamento',0,'Mensagem',3 )
    otMultiBtn:SetFonts('Tahoma',16,'Tahoma',10)
    otMultiBtn:AddButton('Opção 01')
    otMultiBtn:AddButton('Opção 02')
    otMultiBtn:AddButton('Opção 03')
    otMultiBtn:AddButton('Opção 04')
    otMultiBtn:AddButton('Opção 05')
    otMultiBtn:bAction := {|x,y|Alert("Click no botão: "+Str(y,1)) }

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zMultButton() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
