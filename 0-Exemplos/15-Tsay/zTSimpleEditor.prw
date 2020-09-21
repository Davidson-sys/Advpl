#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTSimpleEditor.
Cria um objeto do tipo editor de texto simples

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTSimpleEditor() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TSimpleEditor
/*/
//--------------------------------------------------------------------
User Function zTSimpleEditor()

    Local aSaveArea := GetArea()
    local oDlg      := nil, oEdit := nil

    DEFINE DIALOG oDlg TITLE "tSimpleEditor" FROM 180, 180 TO 550, 700 PIXEL
    
    oEdit := tSimpleEditor():New(0, 0, oDlg, 260, 184)
    
    oEdit:Load("Novo texto <b>Negrito</b>" + ;
        "<font color=red> Texto em Vermelho</font>" + ;
        "<font size=14> Texto com tamanho grande</font>")
    
    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTSimpleEditor() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
