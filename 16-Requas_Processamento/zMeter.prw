#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zMeter.
Cria um objeto do tipo régua de progressso.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zMeter() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TMeter
/*/
//--------------------------------------------------------------------
User Function zMeter()

    //Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TMeter" FROM 180,180 TO 550,700 PIXEL
    
    // Usando o New
    nMeter1 := 50
    oMeter1 := TMeter():New(02,02,{|u|if(Pcount()>0,nMeter1:=u,nMeter1)},100,oDlg,100,16,,.T.)
    oMeter1:setFastMode(.T.)
    
    // Usando o Create
    nMeter2 := 50
    oMeter2 := TMeter():Create(oDlg,{|u|if(Pcount()>0,nMeter2:=u,nMeter2)},100,oDlg,100,16,,.T.)
    oMeter2:setFastMode(.T.)
    ACTIVATE DIALOG oDlg CENTERED

    //RestArea(aSaveArea)

Return

//  u_zMeter() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.

