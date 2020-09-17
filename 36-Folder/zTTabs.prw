#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTTabs
Cria um objeto do tipo aba.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTTabs() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TTabs
/*/
//--------------------------------------------------------------------
User Function zTTabs()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TTabs" FROM 180,180 TO 550,700 PIXEL

    // Cria a TTab
    oTTabs := TTabs():New(01,01,{'Aba01','Aba02','Aba03'},;
        {||oPanel01:lVisibleControl:=(oTTabs:nOption==1)},;
        oDlg,,CLR_HRED,,.T.,,260,184,)

    // Insere um painel na TTab
    oPanel01 := TPanel():New( 1,1,'',oTTabs,,,,,,100,100,,.T. )

    oBtn01  := TButton():New( 01,01,'TButton01',oPanel01,;
        {||oTTabs:SetOption(2)},;
        037, 012,,,.F.,.T.,.F.,,.F.,,,.F. )

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTTabs() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
