#Include 'Rwmake.ch'
#Include 'Colors.ch'
#Include 'Topconn.ch'
#Include 'Protheus.ch'
#include 'Totvs.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} zbrGetDDB.
Cria um objeto do tipo grade com registros em linhas e informações em colunas.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zbrGetDDB() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/BrGetDDb
/*/
//--------------------------------------------------------------------
User Function zbrGetDDB()

    Local aSaveArea := GetArea()
    local oDlg      := nil

    DEFINE DIALOG oDlg TITLE "Exemplo BrGetDDB" FROM 180, 180 TO 550, 700 PIXEL

    dbSelectArea('SA1')
    oBrowse := BrGetDDB():new( 1,1,260,184,,,,oDlg,,,,,,,,,,,,.F.,'SA1',.T.,,.F.,,, )

    //Avaliar a documentação http://tdn.totvs.com.br/display/tec/bCustomEditCol
    oBrowse:bCustomEditCol := {|x,y,z| u_editLine(x,y,z) }
    oBrowse:bDelete := { || conOut( "bDelete" ) }

    oBrowse:addColumn( TCColumn():new( 'Codigo', { || SA1->A1_COD  },,,,'LEFT',, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( 'Loja', { || SA1->A1_LOJA },,,, 'LEFT',, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( 'Nome', { || SA1->A1_NOME },,,, 'LEFT',, .F., .F.,,,, .F. ) )

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)
Return nil

//-----------------------------------------------------------------------------------
// Função para validar a edição da linha do grid
//-----------------------------------------------------------------------------------
User Function editLine(x,y,z)

    ApMsgStop("editLine,não será possivel alterar!!!")
    RestArea(aSaveArea)
Return .T.

//  u_zbrGetDDB() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 100% Funcionando.




