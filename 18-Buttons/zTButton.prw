#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTButton.
Cria um objeto do tipo botão.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTButton() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TButton

/*/
//--------------------------------------------------------------------
User Function zTButton()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TButton" FROM 180,180 TO 550,700 PIXEL

    // Usando o New
    oTButton1 := TButton():New( 002, 002, "Botão 01",oDlg,{||alert("Botão 01")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    oTButton2 := TButton():New( 022, 002, "Botão 02",oDlg,{||alert("Botão 02")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    oTButton3 := TButton():New( 042, 002, "Botão 03",oDlg,{||alert("Botão 03")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

    // Usando o Create
    oTButton4 := TButton():Create( oDlg,062,002,"Botão 04",{||alert("Botão 04")},40,10,,,,.T.,,,,,,)
    
    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTButton() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.

