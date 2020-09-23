//Bibliotecas
#Include 'Protheus.ch'
#Include 'FwMVCDef.ch'

/*/{Protheus.doc} zMkMVC
MarkBrow em MVC da tabela de Artistas
@author Atilio
@since 03/09/2016
@version 1.0
@obs Criar a coluna Z02_OK com o tamanho 2 no Configurador e deixar como não usado

u_zMkMVC()
Link:
https://terminaldeinformacao.com/2016/09/29/vd-advpl-022/
/*/

User Function zMkMVC()
    
    Local cFunBkp := FunName()
    
    SetFunName("zMkMVC")

    Private oMark

    //Criando o MarkBrow
    oMark := FWMarkBrowse():New()
    oMark:SetAlias('Z02')

    //Setando semáforo, descrição e campo de mark
    oMark:SetSemaphore(.T.)
    oMark:SetDescription('Seleção do Cadastro de Artistas')
    oMark:SetFieldMark( 'Z02_OK' )

    //Setando Legenda
    oMark:AddLegend( "Z02->Z02_COD <= '000005'", "GREEN",    "Menor ou igual a 5" )
    oMark:AddLegend( "Z02->Z02_COD >  '000005'", "RED",    "Maior que 5" )

    SetFunName(cFunBkp)
    
    //Ativando a janela
    oMark:Activate()
Return NIL

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
  
Static Function MenuDef()
    Local aRotina := {}
     
    //Criação das opções
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.zMkMVC' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.zMkMVC' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Processar'  ACTION 'u_zMarkProc'     OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Legenda'    ACTION 'u_zMod1Leg'      OPERATION 2 ACCESS 0
Return aRotina
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
  
Static Function ModelDef()
Return FWLoadModel('zMkMVC')
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
  
Static Function ViewDef()
Return FWLoadView('zMkMVC')
 
/*/{Protheus.doc} zMarkProc
Rotina para processamento e verificação de quantos registros estão marcados
@author Atilio
@since 03/09/2016
@version 1.0
/*/

User Function zMarkProc()
    Local aArea    := GetArea()
    Local cMarca   := oMark:Mark()
    Local lInverte := oMark:IsInvert()
    Local nCt      := 0

    //Percorrendo os registros da Z02
    Z02->(DbGoTop())
    While !Z02->(EoF())
        //Caso esteja marcado, aumenta o contador
        If oMark:IsMark(cMarca)
            nCt++

            //Limpando a marca
            RecLock('Z02', .F.)
            Z02_OK := ''
            Z02->(MsUnlock())
        EndIf

        //Pulando registro
        Z02->(DbSkip())
    EndDo

    //Mostrando a mensagem de registros marcados
    MsgInfo('Foram marcados <b>' + cValToChar( nCt ) + ' artistas</b>.', "Atenção")

    //Restaurando área armazenada
    RestArea(aArea)
Return NIL
