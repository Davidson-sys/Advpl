#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTHButton.
Cria um objeto do tipo botão com aparência de hiperlink 
(como em um navegar de Internet). 

Desta forma, esse objeto terá os mesmos eventos e ações da classe TButton.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTHButton() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/THButton
/*/
//--------------------------------------------------------------------
User Function zTHButton()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo THButton" FROM 180,180 TO 550,700 PIXEL

    // Cria uma instância da classe TFont
    oFont := TFont():New('Courier new',,18,.T.)

    oTHButton := THButton():New(01,01,"Caption",oDlg,{||Alert("THButton")},40,20,oFont,"Observação")
    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTHButton() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
