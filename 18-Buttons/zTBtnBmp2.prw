#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTBtn2Bmp.
Cria um objeto do tipo botão com imagem ou Pop-up.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTBtn2Bmp() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TBtnBmp2
/*/
//--------------------------------------------------------------------
User Function zTBtn2Bmp()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TBtnBmp2" FROM 180,180 TO 550,700 PIXEL

    oBtn1 := TBtnBmp2():New( 02,02,26,26,'copyuser',,,,{||Alert("Botão 01")},oDlg,,,.T. )
    oBtn2 := TBtnBmp2():New( 02,32,26,26,'critica',,,,{||Alert("Botão 02")},oDlg,,,.T. )

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTBtn2Bmp() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 100% Funcionando.
