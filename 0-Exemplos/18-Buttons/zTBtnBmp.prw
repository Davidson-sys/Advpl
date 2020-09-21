#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTBtnBmp.
Componente do tipo botão.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTBtnBmp() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TBtnBmp
/*/
//--------------------------------------------------------------------
User Function zTBtnBmp()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TBtnBmp" FROM 180, 180 TO 550, 700 PIXEL

    // Cria barra de botões
    oTBar := TBar():New( oDlg, 25, 32, .T.,,,, .F. )

    // Cria botões
    oTBtnBmp1 := TBtnBmp():NewBar( 'RPMNEW',,,, '', { || Alert( 'TBtnBmp 01' ) }, .F., oTBar, .T., { || .T. },, .F.,,, 1,,,,, .T. )
    oTBtnBmp2 := TBtnBmp():NewBar( 'copyuser',,,, '', { || Alert( 'TBtnBmp 02' ) }, .F., oTBar, .T., { || .T. },, .F.,,, 1,,,,, .T. )

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTBtnBmp()	//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 100% Funcionando.
