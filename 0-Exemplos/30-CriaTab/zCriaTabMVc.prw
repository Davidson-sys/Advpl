//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zUpdTabmvc
Função que cria tabelas, campos e índices para utilização nos exemplos de MVC
@type function
@author Atilio
@since 23/04/2016
@version 1.0
u_zUpdTabmvc()
/*/

User Function zUpdTabmvc()
    Local aArea := GetArea()

    Processa( {|| fAtualiza()}, "Processando...")

    RestArea(aArea)
Return

/*---------------------------------------------------------------------*
 | Func:  fAtualiza                                                    |
 | Autor: Daniel Atilio                                                |
 | Data:  23/04/2016                                                   |
 | Desc:  Função que chama as rotinas para criação                     |
 *---------------------------------------------------------------------*/
 
Static Function fAtualiza()
    ProcRegua(6)
     
    //Z02 - Artistas
    IncProc('Atualizando Z02 - Artistas...')
    fAtuZ02()
     
    //Z03 - CDs
    IncProc('Atualizando Z03 - CDs...')
    fAtuZ03()
     
    //Z04 - Músicas do CD
    IncProc('Atualizando Z04 - Músicas do CD...')
    fAtuZ04()
     
    //Z05 - Venda de CDs
    IncProc('Atualizando Z05 - Venda de CDs...')
    fAtuZ05()
Return
 
/*---------------------------------------------------------------------*
 | Func:  fAtuZ02                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  23/04/2016                                                   |
 | Desc:  Função que cria a tabela Z02                                 |
 *---------------------------------------------------------------------*/
 
Static Function fAtuZ02()
    Local aSX2 := {}
    Local aSX3 := {}
    Local aSIX := {}
     
    //Tabela
    //            01            02                        03        04            05
    //            Chave        Descrição                Modo    Modo Un.    Modo Emp.
    aSX2 := {    'Z02',        'Artista',                'C',    'C',        'C'}
     
    //Campos
    //                01                02            03                                04            05        06                    07                                08                        09        10            11        12                13            14            15            16        17            18                19            20            21
    //                Campo            Filial?    Tamanho                        Decimais    Tipo    Titulo                Descrição                        Máscara                Nível    Vld.Usr    Usado    Ini.Padr.        Cons.F3    Visual        Contexto    Browse    Obrigat    Lista.Op        Mod.Edi    Ini.Brow    Pasta
    aadd(aSX3, {'Z02_FILIAL', .T., FWSizeFilial(), 0, 'C', "Filial"   , "Filial do Sistema", ""  , 1, "", .F., "", "", "" , "" , "N", .T., "", "", "", ""})
    aadd(aSX3, {'Z02_COD'   , .F., 06            , 0, 'C', "Codigo"   , "Codigo Artista"   , "@!", 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
    aadd(aSX3, {'Z02_DESC'  , .F., 50            , 0, 'C', "Descricao", "Descricao / Nome" , "@!", 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
     
    //Índices
    //                01            02            03                            04                05                06            07
    //                Índice        Ordem        Chave                        Descrição        Propriedade    NickName    Mostr.Pesq
    aadd(aSIX, {"Z02", "1", "Z02_FILIAL+Z02_COD", "Codigo", "U", "", "S"})
         
    //Criando os dados
    u_zCriaTab(aSX2, aSX3, aSIX)
Return
 
/*---------------------------------------------------------------------*
 | Func:  fAtuZ03                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  23/04/2016                                                   |
 | Desc:  Função que cria a tabela Z03                                 |
 *---------------------------------------------------------------------*/
 
Static Function fAtuZ03()
    Local aSX2 := {}
    Local aSX3 := {}
    Local aSIX := {}
     
    //Tabela
    //            01            02                        03        04            05
    //            Chave        Descrição                Modo    Modo Un.    Modo Emp.
    aSX2 := {    'Z03',        'CDs',                    'C',    'C',        'C'}
     
    //Campos
    //                01                02            03                                04            05        06                    07                                08                        09        10            11        12                13            14            15            16        17            18                19            20            21
    //                Campo            Filial?    Tamanho                        Decimais    Tipo    Titulo                Descrição                        Máscara                Nível    Vld.Usr    Usado    Ini.Padr.        Cons.F3    Visual        Contexto    Browse    Obrigat    Lista.Op        Mod.Edi    Ini.Brow    Pasta
    aadd(aSX3, {'Z03_FILIAL', .T., FWSizeFilial(), 0, 'C', "Filial"      , "Filial do Sistema", ""         , 1, "", .F., "", "", "" , "" , "N", .T., "", "", "", ""})
    aadd(aSX3, {'Z03_CODART', .F., 06            , 0, 'C', "Cod. Artista", "Codigo Artista"   , "@!"       , 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
    aadd(aSX3, {'Z03_CODCD' , .F., 06            , 0, 'C', "Cod. CD"     , "Codigo CD"        , "@!"       , 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
    aadd(aSX3, {'Z03_DESC'  , .F., 50            , 0, 'C', "Descricao"   , "Descricao / Nome" , "@!"       , 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
    aadd(aSX3, {'Z03_PRECO' , .F., 06            , 2, 'N', "Preco"       , "Preco"            , "@E 999.99", 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
     
    //Índices
    //                01            02            03                                        04                                    05                06            07
    //                Índice        Ordem        Chave                                    Descrição                            Propriedade    NickName    Mostr.Pesq
    aadd(aSIX, {"Z03", "1", "Z03_FILIAL+Z03_CODCD"           , "Codigo CD"                 , "U", "", "S"})
    aadd(aSIX, {"Z03", "2", "Z03_FILIAL+Z03_CODART+Z03_CODCD", "Codigo Artista + Codigo CD", "U", "", "S"})
         
    //Criando os dados
    u_zCriaTab(aSX2, aSX3, aSIX)
Return
 
/*---------------------------------------------------------------------*
 | Func:  fAtuZ04                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  23/04/2016                                                   |
 | Desc:  Função que cria a tabela Z04                                 |
 *---------------------------------------------------------------------*/
 
Static Function fAtuZ04()
    Local aSX2 := {}
    Local aSX3 := {}
    Local aSIX := {}
     
    //Tabela
    //            01            02                        03        04            05
    //            Chave        Descrição                Modo    Modo Un.    Modo Emp.
    aSX2 := {    'Z04',        'Musicas do CD',        'C',    'C',        'C'}
     
    //Campos
    //                01                02            03                                04            05        06                    07                                08                        09        10            11        12                13            14            15            16        17            18                19            20            21
    //                Campo            Filial?    Tamanho                        Decimais    Tipo    Titulo                Descrição                        Máscara                Nível    Vld.Usr    Usado    Ini.Padr.        Cons.F3    Visual        Contexto    Browse    Obrigat    Lista.Op        Mod.Edi    Ini.Brow    Pasta
    aadd(aSX3, {'Z04_FILIAL', .T., FWSizeFilial(), 0, 'C', "Filial"      , "Filial do Sistema", ""  , 1, "", .F., "", "", "" , "" , "N", .T., "", "", "", ""})
    aadd(aSX3, {'Z04_CODART', .F., 06            , 0, 'C', "Cod. Artista", "Codigo Artista"   , "@!", 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
    aadd(aSX3, {'Z04_CODCD' , .F., 06            , 0, 'C', "Cod. CD"     , "Codigo CD"        , "@!", 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
    aadd(aSX3, {'Z04_CODMUS', .F., 06            , 0, 'C', "Cod. Musica" , "Codigo Musica"    , "@!", 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
    aadd(aSX3, {'Z04_DESC'  , .F., 50            , 0, 'C', "Descricao"   , "Descricao / Nome" , "@!", 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
     
    //Índices
    //                01            02            03                                                    04                                                    05                06            07
    //                Índice        Ordem        Chave                                                Descrição                                            Propriedade    NickName    Mostr.Pesq
    aadd(aSIX, {"Z04", "1", "Z04_FILIAL+Z04_CODCD+Z04_CODMUS"           , "Codigo CD + Codigo Musica"                 , "U", "", "S"})
    aadd(aSIX, {"Z04", "2", "Z04_FILIAL+Z04_CODART+Z04_CODCD+Z04_CODMUS", "Codigo Artista + Codigo CD + Codigo Musica", "U", "", "S"})
         
    //Criando os dados
    u_zCriaTab(aSX2, aSX3, aSIX)
Return
 
/*---------------------------------------------------------------------*
 | Func:  fAtuZ05                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  23/04/2016                                                   |
 | Desc:  Função que cria a tabela Z05                                 |
 *---------------------------------------------------------------------*/
 
Static Function fAtuZ05()
    Local aSX2 := {}
    Local aSX3 := {}
    Local aSIX := {}
     
    //Tabela
    //            01            02                        03        04            05
    //            Chave        Descrição                Modo    Modo Un.    Modo Emp.
    aSX2 := {    'Z05',        'Vendas dos CDs',        'C',    'C',        'C'}
     
    //Campos
    //                01                02            03                                04            05        06                    07                                08                        09        10            11        12                13            14            15            16        17            18                19            20            21
    //                Campo            Filial?    Tamanho                        Decimais    Tipo    Titulo                Descrição                        Máscara                Nível    Vld.Usr    Usado    Ini.Padr.        Cons.F3    Visual        Contexto    Browse    Obrigat    Lista.Op        Mod.Edi    Ini.Brow    Pasta
    aadd(aSX3, {'Z05_FILIAL', .T., FWSizeFilial(), 0, 'C', "Filial"    , "Filial do Sistema", ""            , 1, "", .F., "", "", "" , "" , "N", .T., "", "", "", ""})
    aadd(aSX3, {'Z05_CODVEN', .F., 06            , 0, 'C', "Codigo"    , "Codigo Venda"     , "@!"          , 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
    aadd(aSX3, {'Z05_DESC'  , .F., 50            , 0, 'C', "Descricao" , "Descricao / Nome" , "@!"          , 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
    aadd(aSX3, {'Z05_CODCD' , .F., 06            , 0, 'C', "Codigo CD" , "Codigo do CD"     , "@!"          , 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
    aadd(aSX3, {'Z03_QUANT' , .F., 03            , 0, 'N', "Quantidade", "Quantidade"       , "@E 999"      , 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
    aadd(aSX3, {'Z03_PRECO' , .F., 06            , 2, 'N', "Preco"     , "Preco"            , "@E 999.99"   , 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
    aadd(aSX3, {'Z03_TOTAL' , .F., 08            , 2, 'N', "Total"     , "Total"            , "@E 99,999.99", 1, "", .T., "", "", "A", "R", "S", .T., "", "", "", ""})
     
    //Índices
    //                01            02            03                            04                05                06            07
    //                Índice        Ordem        Chave                        Descrição        Propriedade    NickName    Mostr.Pesq
    aAdd(aSIX,{    "Z05",        "1",        "Z05_FILIAL+Z05_CODVEN",    "Codigo",        "U",            "",            "S"})
         
    //Criando os dados
    u_zCriaTab(aSX2, aSX3, aSIX)
Return
