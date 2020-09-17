#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zBitmap.
Exibe uma imagem no objeto

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zBitmap() 		//Chamar no executor.

Esta classe não suporta imagens no formato BMP e JPG com resolução de 24 bits. 
Caso haja necessidade de utilizar a resolução de 24 bits, use o formato PNG.

Link TDN:
https://tdn.totvs.com/display/tec/TBitmap
/*/
//--------------------------------------------------------------------
User Function zBitmap()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TBitmap" FROM 180,180 TO 550,700 PIXEL

    // Usando o New
    oTBitmap1 := TBitmap():New(01,01,260,184,,"C:\Temp\TOTVS.PNG",.T.,oDlg,;
        {||Alert("Clique em TBitmap1")},,.F.,.F.,,,.F.,,.T.,,.F.)
    oTBitmap1:lAutoSize := .T.

    // Usando o Create
    oTBitmap2 := TBitmap():Create(oDlg,01,146,260,184,,"D:\CLIENTES_DCARVALHO\NUTRATTA\Logo\01.PNG",.T.,;
        {||Alert("Clique em TBitmap1")},,.F.,.F.,,,.F.,,.T.,,.F.)

    oTBitmap2:lAutoSize := .T.

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zBitmap() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
