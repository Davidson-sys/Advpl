#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zLegend.
Funcao para ver legendas de rotinas da Gtex

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zLegend() 		//Chamar no executor.

Link TDN:
https://terminaldeinformacao.com/2020/09/18/como-fazer-um-atalho-de-legendas-com-shift-f8-em-advpl/
/*/
//--------------------------------------------------------------------
User Function zLegend()

    Local aSaveArea  := GetArea() /*Salva a área atual */
    Local cUrl       := "D:\PROTHEUS_LOCAL\protheus_data\x_legenda/legendas.html"
    
    //Tamanho da janela
    Private aTamanho := MsAdvSize()
    Private nJanLarg := aTamanho[5]
    Private nJanAltu := aTamanho[6]
    
    //Navegador Internet
    Private oWebChannel
    Private nPort
    Private oWebEngine

    DEFINE DIALOG oDlg TITLE "Legendas" FROM 000,000 TO nJanAltu,nJanLarg PIXEL

    // Prepara o conector WebSocket
    oWebChannel := TWebChannel():New()
    nPort       := oWebChannel::connect()

    // Cria componente
    oWebEngine  := TWebEngine() :New(oDlg, 0, 0, 100, 100, , nPort)
    //oWebEngine:bLoadFinished := {|self,url| fRodaScript(url) }
    oWebEngine:navigate(cUrl)
    oWebEngine:Align := CONTROL_ALIGN_ALLCLIENT

    ACTIVATE DIALOG oDlg CENTERED


    RestArea(aSaveArea)  /* Restaura a área atual */

Return

//  u_zLegend() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.

//-------------------------------------------------------------------
/*/{Protheus.doc} AfterLogin.
Ponto de entrada após o login

@Author   Nome Sobrenome
@Since 	99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	Retorno da Static Function
xxxxx
/*/
//-----------------------------------------------------------------------------------------------------------
User Function AfterLogin()

    Local aSaveArea :=  GetArea()  /* Salva a área atual */

    SetKey(K_SH_F8, { || u_zLegend() })    //Shift + F8

    RestArea(aSaveArea)  /* Restaura a área atual */
Return

