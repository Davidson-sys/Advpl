#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTCBrowse.
Cria um objeto do tipo grade.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTCBrowse() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TCBrowse
/*/
//--------------------------------------------------------------------
User Function zTCBrowse()

    Local aSaveArea := GetArea()
    Local oOK       := LoadBitmap(GetResources(), 'br_verde' )
    Local oNO       := LoadBitmap(GetResources(), 'br_vermelho' )
    //Local aList     := {}

    DEFINE DIALOG oDlg TITLE "Exemplo TCBrowse" FROM 180,180 TO 550,700 PIXEL

    // Vetor com elementos do Browse
    aBrowse := { {.T.,'CLIENTE 001','RUA CLIENTE 001',111.11},;
        {.F.,'CLIENTE 002','RUA CLIENTE 002',222.22},;
        {.T.,'CLIENTE 003','RUA CLIENTE 003',333.33} }

    // Cria Browse
    oBrowse := TCBrowse():New( 01 , 01, 260, 156,, {'','Codigo','Nome','Valor'},{20,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

    // Seta vetor para a browse
    oBrowse:SetArray(aBrowse)

    // Monta a linha a ser exibina no Browse
    oBrowse:bLine := {||{ If(aBrowse[oBrowse:nAt,01],oOK,oNO),;
        aBrowse[oBrowse:nAt,02],;
        aBrowse[oBrowse:nAt,03],;
        Transform(aBrowse[oBrowse:nAT,04],'@E 99,999,999,999.99') } }

    // Evento de clique no cabeçalho da browse
    oBrowse:bHeaderClick := {|o, nCol| alert('bHeaderClick') }

    // Evento de duplo click na celula
    oBrowse:bLDblClick := {|| alert('bLDblClick') }

    // Cria Botoes com metodos básicos
    TButton():New( 160, 002, "GoUp()", oDlg,{|| oBrowse:GoUp(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 160, 052, "GoDown()" , oDlg,{|| oBrowse:GoDown(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 160, 102, "GoTop()" , oDlg,{|| oBrowse:GoTop(),oBrowse:setFocus()}, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F.)
    TButton():New( 160, 152, "GoBottom()", oDlg,{|| oBrowse:GoBottom(),oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
    TButton():New( 172, 002, "Linha atual", oDlg,{|| alert(oBrowse:nAt) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 172, 052, "Nr Linhas", oDlg,{|| alert(oBrowse:nLen) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 172, 102, "Linhas visiveis", oDlg,{|| alert(oBrowse:nRowCount()) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
    TButton():New( 172, 152, "Alias", oDlg,{|| alert(oBrowse:cAlias) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTCBrowse() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 100% Funcionando.

