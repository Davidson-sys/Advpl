#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zMsSelBr
Cria um objeto do tipo grade

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zMsSelBr() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/MsSelBr
/*/
//--------------------------------------------------------------------
User Function zMsSelBr()

    Local aSaveArea :=  GetArea()


    DEFINE DIALOG oDlg TITLE "Exemplo MsSelBr" FROM 180,180 TO 550,700 PIXEL

    DbSelectArea('SA1')
    oBrowse := MsSelBr():New( 1,1,260,184,,,,oDlg,,,,,,,,,,,,.F.,'SA1',.T.,,.F.,,, )
    oBrowse:AddColumn(TCColumn():New('Codigo',{||SA1->A1_COD },,,,'LEFT',,.F.,.F.,,,,.F.,))
    oBrowse:AddColumn(TCColumn():New('Loja'  ,{||SA1->A1_LOJA},,,,'LEFT',,.F.,.F.,,,,.F.,))
    oBrowse:AddColumn(TCColumn():New('Nome'  ,{||SA1->A1_NOME},,,,'LEFT',,.F.,.F.,,,,.F.,))
    oBrowse:lHasMark := .T.
    oBrowse:bAllMark := {|| alert('Click no header da browse') }

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zMsSelBr() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
