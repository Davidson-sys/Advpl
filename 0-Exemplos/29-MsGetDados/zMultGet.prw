#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zMultGet.
Cria um objeto do tipo campo memo.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zMultGet() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TMultiGet
/*/
//--------------------------------------------------------------------
User Function zMultGet()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TMultiget" FROM 180, 180 TO 550, 700 PIXEL

    // Usando o New
    cTexto1 := "Linha 01 Multiget 1"
    oTMultiget1 := tMultiget():new( 01, 01, {| u | if( pCount() > 0, cTexto1 := u, cTexto1 ) }, ;
        oDlg, 260, 92, , , , , , .T. )

    // Usando o Create
    cTexto2 := "Linha 01 Multiget 2"
    oTMultiget2 := tMultiget():create( oDlg, {| u | if( pCount() > 0, cTexto2 := u, cTexto2 ) }, 92, 01, ;
        260, 92, , , , , , .T. )
    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zMultGet() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
