#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTGet.
Cria um objeto para entrada de dados editáveis. 
Esta classe permite armazenar ou alterar o conteúdo de uma variável 
através da digitação. No entanto, o conteúdo da variável será alterado
quando o objeto perder o foco de edição para outro objeto

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTGet() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TGet
/*/
//--------------------------------------------------------------------
User Function zTGet()

    Local aSaveArea  := GetArea()
    Local cGet1      := "Define variable value" // Variavel do tipo caracter
    Local nGet2      := 0 // Variável do tipo numérica
    Local dGet3      := Date() // Variável do tipo Data
    Local lHasButton := .T.

    DEFINE MSDIALOG oDlg TITLE "Picture test" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

    oGet1 := TGet():New( 005, 009, { | u | If( PCount() == 0, cGet1, cGet1 := u ) },oDlg, ;
        060, 010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cGet1",,,,lHasButton  )
    oGet2 := TGet():New( 020, 009, { | u | If( PCount() == 0, nGet2, nGet2 := u ) },oDlg, ;
        060, 010, "@E 999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nGet2",,,,lHasButton  )
    oGet3 := TGet():New( 035, 009, { | u | If( PCount() == 0, dGet3, dGet3 := u ) },oDlg, ;
        060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dGet3",,,,lHasButton  )

    ACTIVATE MSDIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTGet() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
