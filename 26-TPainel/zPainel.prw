#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zPainel.
Cria um objeto do tipo painel estático. 
Além disso, permite criar outros controles visuais com objetivo de organizar
ou agrupar outros componentes visuais.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zPainel() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TPanel
/*/
//--------------------------------------------------------------------
User Function zPainel()

    Local aSaveArea :=  GetArea()


    DEFINE DIALOG oDlg TITLE "Exemplo TPanel" FROM 180,180 TO 550,700 PIXEL
    
    // TFont
    oTFont := TFont():New('Courier new',,16,.T.)

    // Usando o método New
    oPanel:= tPanel():New(01,01,"Teste",oDlg,oTFont,.T.,,CLR_YELLOW,CLR_BLUE,100,100)

    // Usando o método Create
    oPanel:= tPanel():Create(oDlg,01,102,"Teste",oTFont,.F.,,CLR_YELLOW,CLR_BLUE,100,100)
    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zPainel() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
