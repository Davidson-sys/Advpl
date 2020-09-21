#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zToolBox.
Cria um objeto do tipo caixa de ferramenta,
cujo objetivo é agrupar diferentes tipos de objetos.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zToolBox() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TToolBox
/*/
//--------------------------------------------------------------------
User Function zToolBox()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TToolBox" FROM 180,180 TO 550,700 PIXEL
    
    // Cria os painéis que conterão os containers
    oPanel1:= TPanel():New(01,01," Painel 01 ",oDlg,,,,,CLR_YELLOW,100,80)
    oPanel2:= TPanel():New(01,01," Painel 02 ",oDlg,,,,,CLR_HRED,100,80)

    // Cria a Toolbox e adiciona os painéis
    oTb := TToolBox():New(01,01,oDlg,200,184)
    oTb:bChangeGrp := {|x| Alert(Str(x))}
    oTb:AddGroup( oPanel1, 'Opção 1',nil )
    oTb:AddGroup( oPanel2, 'Opção 2',nil )

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zToolBox() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 100% Funcionando.
