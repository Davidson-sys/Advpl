#Include "Rwmake.ch"
#Include "Colors.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"
#include "Totvs.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} zEnchoice.
Função de teste de Enchoice
@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico nome da empresa/cliente.

u_zEnchoice() 		//Chamar no executor.

Funcionalidade descontinuada,substituida pelo AxCadastro e MVC.
Fonte: Boas-Praticas-de-Programacao-Advpl
em 
D:\Desenvolvimento\A_Material_ADVPL I
/*/
//--------------------------------------------------------------------
User Function zEnchoice()

    Local aSize     := {}
    Local aPObj     := {}
    Local cAlias1   := "SA2"

    // Retorna a area util das janelas Protheus
    aSize := MsAdvSize()

    // Será utilizado três áreas na janela
    // 1ª - Enchoice, sendo 80 pontos pixel
    AADD( aObj, { 100, 080, .T., .F. })
    AADD( aObj, { 100, 100, .T., .T. })
    AADD( aObj, { 100, 015, .T., .F. })

    // Cálculo automático da dimensões dos objetos (altura/largura) em pixel
    aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
    aPObj := MsObjSize( aInfo, aObj )

    // Cálculo automático de dimensões dos objetos MSGET
    oDialog:=MSDialog():New(aSize[7],aSize[1],aSize[6],aSize[5],;
        "MSDialog",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
    EnChoice( cAlias1, nReg, nOpc, , , , , aPObj[1])
    oDialog:Activate(,,,.T.)
Return


//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Erro.
