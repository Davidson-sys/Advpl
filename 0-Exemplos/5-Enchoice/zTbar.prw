#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTbar.
Barra de botões para a parte superior da interface.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTbar() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TBar
/*/
//--------------------------------------------------------------------
User Function zTbar()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TBar" FROM 180, 180 TO 550, 700 PIXEL

    oTBar := TBar():New( oDlg, 25, 32, .T.,,,, .F. )

    oTBtnBmp1 := TBtnBmp2():New( 00, 00, 35, 25, 'copyuser',,,, { || Alert( 'TBtnBmp1' ) }, oTBar, 'msGetEx',, .F., .F. )
    oTBtnBmp2 := TBtnBmp2():New( 00, 00, 35, 25, 'critica',,,, { || }, oTBar, 'Critica',, .F., .F. )
    oTBtnBmp3 := TBtnBmp2():New( 00, 00, 35, 25, 'bmpcpo',,,, { || }, oTBar, 'PCO',, .F., .F. )
    oTBtnBmp4 := TBtnBmp2():New( 00, 00, 35, 25, 'preco',,,, { || }, oTBar, 'Preço',, .F., .F. )

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTbar() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 100% Funcionando.
