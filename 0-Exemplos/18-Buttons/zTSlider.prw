#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTSlider.
Cria um objeto do tipo botão deslizante.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTSlider() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TSlider
/*/
//--------------------------------------------------------------------
User Function zTSlider()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TSlider" FROM 180,180 TO 550,700 PIXEL
    
    oSlider := TSlider():New( 01,01,oDlg,{|x|Alert("oSlider: "+str(x,4))},260,30,"Mensagem",nil)
    
    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTSlider() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
