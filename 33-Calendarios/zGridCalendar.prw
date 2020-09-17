#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//------------------------------------------------------------------
/*/{Protheus.doc} zGridCalendar.
Cria um objeto do tipo calendário

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zGridCalendar() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/MsCalendGrid

/*/
//--------------------------------------------------------------------
User Function zGridCalendar()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo MsCalendGrid" FROM 180,180 TO 550,700 PIXEL

    // Cria Calendário
    nResolution := 4

    oMsCalendGrid := MsCalendGrid():New( oDlg, 01, 01, 260,184,;
        date(), nResolution, ,{|x,y| Alert(x) },;
        RGB(255,255,196), {|x,y|Alert(x,y)}, .T. )

    // Adiciona periodos
    oMsCalendGrid:Add('caption 01', 1, 10, 20, RGB(255,000,0), 'Descricao 01')
    oMsCalendGrid:Add('caption 02', 2, 20, 30, RGB(255,255,0), 'Descricao 02')
    oMsCalendGrid:Add('caption 03', 3, 01, 05, RGB(255,0,255), 'Descricao 03')

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zGridCalendar() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.

