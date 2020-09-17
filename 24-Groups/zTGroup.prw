#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zTGroup.
Cria um objeto do tipo painel, com borda e título,
para que outros possam ser agrupados ou classificados.

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zTGroup() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/tec/TGroup
/*/
//--------------------------------------------------------------------
User Function zTGroup()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo TGroup" FROM 180,180 TO 650,800 PIXEL

    // USANDO O NEW
    oGroup1:= TGroup():New(02,02,130,130,'Objeto TGroup 1',oDlg,,,.T.)

    cTGet1 := "Get dentro do TGroup"
    oTGet2 := TGet():New( 18,16,{||cTGet1},oGroup1,100,010,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,,)
    oTGet3 := TGet():New( 36,16,{||cTGet1},oGroup1,100,010,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,,)

    // USANDO CREATE
    oGroup2 := TGroup():Create(oDlg,02,140,130,260,'Objeto TGroup 2',,,.T.)

    cTGet4 := "Get dentro do TGroup"
    oTGet5 := TGet():New( 18,150,{||cTGet4},oGroup2,100,010,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet4,,,,)
    oTGet6 := TGet():New( 36,150,{||cTGet4},oGroup2,100,010,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet4,,,,)

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return

//  u_zTGroup() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 100% Funcionando.
