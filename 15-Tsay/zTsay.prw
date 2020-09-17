#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTSay.
Cria um objeto do tipo label. Desta forma, o objeto apresentar� o conte�do do
texto est�tico sobre uma janela ou controle visual.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTSay() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TSay
/*/
//--------------------------------------------------------------------
User Function zTSay()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TSay" FROM 180,180 TO 550,700 PIXEL

    // Cria Fonte para visualiza��o
    oFont := TFont():New('Courier new',,-18,.T.)

    // Usando o m�todo New
    oSay1:= TSay():New(01,01,{||'Texto para exibi��o I'},oDlg,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)

    // Usando o m�todo Create
    oSay:= TSay():Create(oDlg,{||'Texto para exibi��o'},20,01,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)

    // M�todos
    oSay:CtrlRefresh()

    oSay:SetText( "Novo Texto Novo Texto Novo Texto Novo Texto Novo Texto Novo Texto Novo Texto Novo Texto Novo Texto Novo Texto Novo Texto Novo Texto Novo Texto Novo Texto " )

    oSay:SetTextAlign( 2, 2 )

    // Propriedades
    oSay:lTransparent = .T.

    oSay:lWordWrap = .F.

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTSay() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.

