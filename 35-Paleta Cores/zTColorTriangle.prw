#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTColorTriangle.
Cria um objeto do tipo paleta de cores.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTColorTriangle() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TColorTriangle
/*/
//--------------------------------------------------------------------
User Function zTColorTriangle()

    Local aSaveArea := GetArea()
    Local nColorIni := CLR_HRED

    DEFINE DIALOG oDlg TITLE "Exemplo TColorTriangle" FROM 180,180 TO 650,800 PIXEL

    // Usando Create
    oTColorTriangle1 := tColorTriangle():Create( oDlg  )
    oTColorTriangle1:SetColorIni( nColorIni )

    // Usando New
    oTColorTriangle2 := tColorTriangle():New(100,01,oDlg,200,80)

    oTColorTriangle2:SetColorIni( nColorIni )
    oTColorTriangle2:SetColor(CLR_BLUE)
    oTColorTriangle2:SetSizeTriangle( 200, 80 )

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTColorTriangle() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 100% Funcionando.
