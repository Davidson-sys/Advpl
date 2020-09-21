#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTwBrowse.
Cria um objeto do tipo grade.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTwBrowse() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TWBrowse
/*/
//--------------------------------------------------------------------
User Function zTwBrowse()

    Local aSaveArea := GetArea()
    Local oOK       := LoadBitmap(GetResources(), 'br_verde' )
    Local oNO       := LoadBitmap(GetResources(), 'br_vermelho' )
    
    DEFINE DIALOG oDlg TITLE "Exemplo TWBrowse" FROM 180,180 TO 550,700 PIXEL

    oBrowse := TWBrowse():New( 01 , 01, 260,184,,{'','Codigo','Descrição'},{20,30,30},;
        oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
    aBrowse   := {{.T.,'C   LIENTE 001','RUA CLIENTE 001','BAIRRO CLIENTE 001'},;
        {.F.,'CLIENTE 002','RUA CLIENTE 002','BAIRRO CLIENTE 002'},;
        {.T.,'CLIENTE 003','RUA CLIENTE 003','BAIRRO CLIENTE 003'} }
    
    oBrowse:SetArray(aBrowse)
    
    oBrowse:bLine := {||{If(aBrowse[oBrowse:nAt,01],oOK,oNO),aBrowse[oBrowse:nAt,02],;
        aBrowse[oBrowse:nAt,03],aBrowse[oBrowse:nAt,04] } }
    
    // Troca a imagem no duplo click do mouse    
    oBrowse:bLDblClick := {|| aBrowse[oBrowse:nAt][1] := !aBrowse[oBrowse:nAt][1],;
        oBrowse:DrawSelect()}

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTwBrowse() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
