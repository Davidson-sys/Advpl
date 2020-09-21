#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zDbTree.
Cria um objeto do tipo árvore de itens

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zDbTree() 		//Chamar no executor.

Link TDN:
https://tdn.totvs.com/display/public/PROT/DBTree
/*/
//--------------------------------------------------------------------
User Function zDbTree()

    Local aSaveArea :=  GetArea()

    DEFINE DIALOG oDlg TITLE "Exemplo de DBTree" FROM 180,180 TO 550,700 PIXEL	    // Cria a Tree

    oTree := DbTree():New(0,0,160,260,oDlg,,,.T.)// Insere itens
    oTree:AddItem("Primeiro nível da DBTree","001", "FOLDER5" ,,,,1)

    If oTree:TreeSeek("001")
        oTree:AddItem("Segundo nível da DBTree","002", "FOLDER10",,,,2)
        If oTree:TreeSeek("002")
            oTree:AddItem("Subnível 01","003", "FOLDER6",,,,2)
            oTree:AddItem("Subnível 02","004", "FOLDER6",,,,2)
            oTree:AddItem("Subnível 03","005", "FOLDER6",,,,2)
        EndIf
    EndIf

    oTree:TreeSeek("001") // Retorna ao primeiro nível

    // Cria botões com métodos básicos
    TButton():New( 160, 002, "Seek Item 4", oDlg,{|| oTree:TreeSeek("004")};
        ,40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 160, 052, "Enable"	, oDlg,{|| oTree:SetEnable() },;
        40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 160, 102, "Disable"	, oDlg,{|| oTree:SetDisable() },;
        40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 160, 152, "Novo Item", oDlg,{|| TreeNewIt() },;
        40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 172,02,"Dados do item", oDlg,{|| ;
        Alert("Cargo: "+oTree:GetCargo()+chr(13)+"Texto: "+oTree:GetPrompt(.T.)) },;
        40,10,,,.F.,.T.,.F.,,.F.,,,.F.)

    TButton():New( 172, 052, "Muda Texto", oDlg,{|| ;
        oTree:ChangePrompt("Novo Texto Item 001","001") },;
        40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 172, 102, "Muda Imagem", oDlg,{||,;
        oTree:ChangeBmp("LBNO","LBTIK",,,"001") },;
        40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 172, 152, "Apaga Item", oDlg,{|| ;
        IIF(oTree:TreeSeek("006"),oTree:DelItem(),) },;
        40,010,,,.F.,.T.,.F.,,.F.,,,.F. )    // Indica o término da contrução da Tree
    oTree:EndTree()

    ACTIVATE DIALOG oDlg CENTERED

    RestArea(aSaveArea)

Return


//----------------------------------------// Função auxiliar para inserção de item//----------------------------------------

//-------------------------------------------------------------------
/*/{Protheus.doc} TreeNewIt.
Descrição do objetivo da Static Function

@Author   Nome Sobrenome
@Since 	99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	Retorno da Static Function
xxxxx
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function TreeNewIt()

    Local aSaveArea :=  GetArea()

    oTree:AddTreeItem("Novo Item","FOLDER7",,"006")
    If oTree:TreeSeek("006")
        oTree:AddItem("Sub-nivel 01","007", "FOLDER6",,,,2)
        oTree:AddItem("Sub-nivel 02","008", "FOLDER6",,,,2)
    EndIf

    RestArea(aSaveArea)
Return

//  u_zDbTree() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.
