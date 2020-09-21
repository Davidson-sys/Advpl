#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTFolder.
Cria um objeto para exibir pastas.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTFolder() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TFolder
/*/
//--------------------------------------------------------------------
User Function zTFolder()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TFolder" FROM 180,180 TO 550,700 PIXEL

    // Cria a Folder
    aTFolder := { 'Aba 01', 'Aba 02', 'Aba 03' }
    oTFolder := TFolder():New( 0,0,aTFolder,,oDlg,,,,.T.,,260,184 )

    // Insere um TGet em cada aba da folder
    cTGet1 := "Teste TGet 01"
    oTGet1 := TGet():New( 01,01,{||cTGet1},oTFolder:aDialogs[1],096,009,;
        "",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,, )

    cTGet2 := "Teste TGet 02"
    oTGet2 := TGet():New( 01,01,{||cTGet2},oTFolder:aDialogs[2],096,009,;
        "",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet2,,,, )

    cTGet3 := "Teste TGet 03"
    oTGet3 := TGet():New( 01,01,{||cTGet3},oTFolder:aDialogs[3],096,009,;
        "",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet3,,,, )

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTFolder() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 100% Funcionando.
