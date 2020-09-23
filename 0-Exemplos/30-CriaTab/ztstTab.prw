//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zTstTab
Função que testa a criação de tabelas, campos e índices
@type function
@author Atilio
@since 03/10/2015
@version 1.0
	@example
	u_zTstTab()
/*/
User Function zTstTab()
    Processa( {|lEnd| fRunProc(@lEnd)}, "Aguarde...","Atualizando tabelas...", .T. )
Return

/*---------------------------------------------------------------------*
 | Func:  fRunCroc                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/10/2015                                                   |
 | Desc:  Função auxiliar chamada pelo Processamento                   |
 *---------------------------------------------------------------------*/
Static Function fRunProc(lEnd)
	
    DbSelectArea("SX2")
	
	//Setando a régua
	ProcRegua(2) 
	
	//Chamando a criação da tabela customizada
	IncProc("Atualizando Z02 - Logs")
	fAtualZ02()
	
	//Atualizando tabelas padrão
	IncProc("Atualizando tabelas padrão...")
	cMsg := "Atenção, as seguintes tabelas <b>serão atualizadas</b>: <br>"
	cMsg += "<b>SB1:</b> Produtos <br>"
	cMsg += "<br>Verifique se elas não estão sendo utilizadas.<br>"
	cMsg += "<b>Deseja atualizar essas tabelas?</b>"
    
    If MsgYesNo(cMsg, "Atenção")
		fAtualSB1()
    EndIf
	
	MSGInfo('Atualizações concluídas.','Atenção')
Return
/*---------------------------------------------------------------------*
 | Func:  fAtualZ02                                                    |
 | Autor: Daniel Atilio                                                |
 | Data:  03/10/2015                                                   |
 | Desc:  Função para criar a tabela Z02 - Logs                        |
 *---------------------------------------------------------------------*/
Static Function fAtualZ02()
	Local aSX2 := {}
	Local aSX3 := {}
	Local aSIX := {}
	
	//Tabela
	//			01			02								03		04			05
	//			Chave		Descrição						Modo	Modo Un.	Modo Emp.
	aSX2 := {'Z02'       , 'Itens', 'C'                 , 'C'        , 'C'}
	
	//Campos
	//				01				02			03					04			05		06					07							08			09		10			11		12										13			14			15			16		17			18					19			20			21
	//				Campo			Filial?	Tamanho			Decimais	Tipo	Titulo				Descrição					Máscara	Nível	Vld.Usr	Usado	Ini.Padr.								Cons.F3	Visual		Contexto	Browse	Obrigat	Lista.Op			Mod.Edi	Ini.Brow	Pasta
	aadd(aSX3, {'Z02_FILIAL', .T.             , FWSizeFilial()      , 0          , 'C', "Filial"     , "Filial do Sistema", ""  , 1, "", .F., ""                              , "", "" , "" , "N", .T., "", "", "", ""})
	aadd(aSX3, {'Z02_SEQ'   , .F.             , 10                  , 0          , 'C', "Sequencia"  , "Sequencia"        , "@!", 1, "", .T., "GetSXENum( 'Z00' , 'Z00_SEQ' )", "", "A", "R", "S", .T., "", "", "", ""})
	aadd(aSX3, {'Z02_USRCOD', .F.             , 10                  , 0          , 'C', "Usr.Codigo" , "Código do Usuário", ""  , 1, "", .T., ""                              , "", "A", "R", "N", .T., "", "", "", ""})
	aadd(aSX3, {'Z02_USRNOM', .F.             , 30                  , 0          , 'C', "Usr.Nome"   , "Nome do Usuário"  , ""  , 1, "", .T., ""                              , "", "A", "R", "S", .F., "", "", "", ""})
	aadd(aSX3, {'Z02_DATA'  , .F.             , 8                   , 0          , 'D', "Data"       , "Data"             , ""  , 1, "", .T., "Date()"                        , "", "A", "R", "S", .T., "", "", "", ""})
	aadd(aSX3, {'Z02_HORA'  , .F.             , 8                   , 0          , 'C', "Hora"       , "Hora"             , ""  , 1, "", .T., "Time()"                        , "", "A", "R", "S", .T., "", "", "", ""})
	aadd(aSX3, {'Z02_DESCRI', .F.             , 100                 , 0          , 'C', "Descricao"  , "Descricao"        , ""  , 1, "", .T., ""                              , "", "A", "R", "S", .T., "", "", "", ""})
	aadd(aSX3, {'Z02_FUNC'  , .F.             , 20                  , 0          , 'C', "Funcao"     , "Funcao"           , ""  , 1, "", .T., ""                              , "", "A", "R", "N", .F., "", "", "", ""})
	aadd(aSX3, {'Z02_FILORI', .F.             , FWSizeFilial()      , 0          , 'C', "Fil.Orig."  , "Filial Origem"    , ""  , 1, "", .T., ""                              , "", "A", "R", "N", .F., "", "", "", ""})
	aadd(aSX3, {'Z02_AMB'   , .F.             , 30                  , 0          , 'C', "Ambiente"   , "Ambiente"         , ""  , 1, "", .T., ""                              , "", "A", "R", "N", .F., "", "", "", ""})
	aadd(aSX3, {'Z02_TAB'   , .F.             , 3                   , 0          , 'C', "Tabela"     , "Alias da Tabela"  , ""  , 1, "", .T., ""                              , "", "A", "R", "N", .F., "", "", "", ""})
	aadd(aSX3, {'Z02_CAMPO' , .F.             , 10                  , 0          , 'C', "Campo"      , "Campo"            , ""  , 1, "", .T., ""                              , "", "A", "R", "N", .F., "", "", "", ""})
	aadd(aSX3, {'Z02_CONANT', .F.             , 240                 , 0          , 'C', "Cont.Ant."  , "Conteudo Antigo"  , ""  , 1, "", .T., ""                              , "", "A", "R", "N", .F., "", "", "", ""})
	aadd(aSX3, {'Z02_CONNOV', .F.             , 240                 , 0          , 'C', "Cont.Nov."  , "Conteudo Novo"    , ""  , 1, "", .T., ""                              , "", "A", "R", "N", .F., "", "", "", ""})
	aadd(aSX3, {'Z02_CHAVE' , .F.             , 100                 , 0          , 'C', "Chave"      , "Chave da Tabela"  , ""  , 1, "", .T., ""                              , "", "A", "R", "N", .F., "", "", "", ""})
	aadd(aSX3, {'Z02_CONCHA', .F.             , 100                 , 0          , 'C', "Cont.Chave" , "Conteudo da Chave", ""  , 1, "", .T., ""                              , "", "A", "R", "N", .F., "", "", "", ""})
	aadd(aSX3, {'Z02_REC'   , .F.             , 18                  , 0          , 'N', "RecNo Chave", "RecNo da Chave"   , ""  , 1, "", .T., ""                              , "", "A", "R", "N", .F., "", "", "", ""})
	//Índices
	//				01			02			03								04				05				06			07
	//				Índice		Ordem		Chave							Descrição		Propriedade	NickName	Mostr.Pesq
	aadd(aSIX, {"Z02"       , "1"             , "Z02_FILIAL+Z02_SEQ", "Sequencia", "U", ""           , "S"})
		
	//Criando os dados
	u_zCriaTab(aSX2, aSX3, aSIX)
Return 

/*---------------------------------------------------------------------*
 | Func:  fAtualSB1                                                    |
 | Autor: Daniel Atilio                                                |
 | Data:  03/10/2015                                                   |
 | Desc:  Função para criar campos na tabela SB1 - Produtos            |
 *---------------------------------------------------------------------*/
Static Function fAtualSB1()
	
    Local aSX2   := {}
	Local aSX3   := {}
	Local aSIX   := {}
	Local cOrdem := ""
	
	//Tabela
	//			01			02								03		04			05
	//			Chave		Descrição						Modo	Modo Un.	Modo Emp.
	aSX2 := {'SB1'       , ''    , ''                    , ''          , ''}
	
	//Campos
	//				01				02			03					04			05		06					07							08			09		10			11		12				13			14			15			16		17			18					19			20			21
	//				Campo			Filial?	Tamanho			Decimais	Tipo	Titulo				Descrição					Máscara	Nível	Vld.Usr	Usado	Ini.Padr.		Cons.F3	Visual		Contexto	Browse	Obrigat	Lista.Op			Mod.Edi	Ini.Brow	Pasta
	aadd(aSX3, {'B1_X_CAMPO', .F.   , 10                    , 0           , 'C', "Campo Novo", "Campo Novo", "", 1, "", .T., "", "", "A", "R", "S", .F., "", ".F.", "", ""})
	
    //Somente se não existir o índice do pocket
    If ! u_zExistSIX( 'SB1' , 'CAMPO' , @cOrdem)
		//Índices
		//				01			02			03								04				05				06				07
		//				Índice		Ordem		Chave							Descrição		Propriedade	NickName		Mostr.Pesq
		aadd(aSIX, {"SB1"       , cOrdem, "B1_FILIAL+B1_X_CAMPO", "Campo Novo", "U", "CAMPO"     , "N"})
    EndIf
	
	//Criando os dados
	u_zCriaTab(aSX2, aSX3, aSIX)
Return
