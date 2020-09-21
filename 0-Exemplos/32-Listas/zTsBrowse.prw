#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTsBrowse.
Cria um objeto do tipo grade.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTsBrowse() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TSBrowse
/*/
//--------------------------------------------------------------------
User Function zTsBrowse()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TSBrowse" FROM 180,180 TO 550,700 PIXEL

    aBrowse   := {{'CLIENTE 001','RUA CLIENTE 001','BAIRRO CLIENTE 001'},;
        {'CLIENTE 002','RUA CLIENTE 002','BAIRRO CLIENTE 002'},;
        {'CLIENTE 003','RUA CLIENTE 003','BAIRRO CLIENTE 003'} }

    oBrowse := TSBrowse():New(01,01,260,184,oDlg,,16,,5)
    oBrowse:AddColumn( TCColumn():New('Nome',,,{|| },{|| }) )
    oBrowse:AddColumn( TCColumn():New('Endereço',,,{|| },{|| }) )
    oBrowse:AddColumn( TCColumn():New('Bairro',,,{|| },{|| }) )
    oBrowse:SetArray(aBrowse)

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTsBrowse() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
