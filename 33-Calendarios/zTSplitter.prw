#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTSplitter.
Cria um objeto do tipo barra de divisão.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTSplitter() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TSplitter
/*/
//--------------------------------------------------------------------
User Function zTSplitter()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TSplitter" FROM 180,180 TO 550,700 PIXEL
    
    oSplitter := tSplitter():New( 01,01,oDlg,260,184 )
    oPanel1:= tPanel():New(322,02," Painel 01",oSplitter,,,,,CLR_YELLOW,60,60)
    oPanel2:= tPanel():New(322,02," Painel 02",oSplitter,,,,,CLR_HRED,60,80)
    oPanel3:= tPanel():New(322,02," Painel 03",oSplitter,,,,,CLR_HGRAY,60,60)
    
    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTSplitter() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
