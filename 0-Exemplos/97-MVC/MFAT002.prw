#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH" 
/*
�+-----------------------------------------------------------------------------+�
��Programa  �MFAT002           � Autor � Lucas Nogueira     � Data � 30/05/2016��
�+----------+------------------------------------------------------------------��
��Descri��o � Retorno dos Canhotos da NF									   ��
��          �                                                            	   ��
�+----------+------------------------------------------------------------------��
��Uso       �Faturamento					                              	   ��
�+----------+------------------------------------------------------------------��
��Parametros� 	                          	  								   ��
�+----------+------------------------------------------------------------------��
��Retorno	� 	                                        	  				   ��
�+-----------------------------------------------------------------------------��
��			ATUALIZA��ES SOFRIDAS DESDE A CONSTRU��O INICIAL				   ��
�+-----------------------------------------------------------------------------��
�� Analista           � Data        �  Motivo da Altera��o			           ��
�+--------------------+-------------+------------------------------------------��
�� 				      �				�		  								   ��
�+--------------------+-------------+------------------------------------------��
��			          �		  		�										   ��
�+--------------------+-------------+------------------------------------------+�
*/
Static cTitulo := "Retorno Canhotos NFs"

User Function MFAT002()
Local aArea   := GetArea()
Local oBrowse

Private aRotina 	:= MenuDef()
Private cCadastro	:= cTitulo
     
    oBrowse := FWMBrowse():New()

    oBrowse:SetAlias("ZZ1")
    
    oBrowse:SetDescription(cTitulo)
     
    oBrowse:AddLegend( " Empty(ZZ1->ZZ1_DTREC) "	, "BR_VERMELHO"	, "Aguard. Retorno Canhoto" 		)
    oBrowse:AddLegend( " !Empty(ZZ1->ZZ1_DTREC) "	, "BR_VERDE"	, "Informa��es do Canhoto Inseridas"	)
     
    oBrowse:Activate()
     
    RestArea(aArea)
	 
Return Nil

/*
�+-----------------------------------------------------------------------------+�
��Programa  �MenuDef           � Autor � Lucas Nogueira     � Data � 30/05/2016��
�+----------+------------------------------------------------------------------��
�+-----------------------------------------------------------------------------��
��			ATUALIZA��ES SOFRIDAS DESDE A CONSTRU��O INICIAL				   ��
�+-----------------------------------------------------------------------------��
�� Analista           � Data        �  Motivo da Altera��o			           ��
�+--------------------+-------------+------------------------------------------��
�� 				      �				�		  								   ��
�+--------------------+-------------+------------------------------------------��
��			          �		  		�										   ��
�+--------------------+-------------+------------------------------------------+�
*/
Static Function MenuDef()
Local aRotina := {}
     
    ADD OPTION aRotina TITLE 'Alterar'    	ACTION 'VIEWDEF.MFAT002'	OPERATION MODEL_OPERATION_UPDATE 	ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'	ACTION 'VIEWDEF.MFAT002' 	OPERATION MODEL_OPERATION_VIEW   	ACCESS 0 
    ADD OPTION aRotina TITLE 'Legenda'   	ACTION 'U_MFAT002Leg'    	OPERATION 6                      	ACCESS 0 
    ADD OPTION aRotina TITLE 'Conhecimento'	ACTION 'MSDOCUMENT' 		OPERATION 4						   	ACCESS 0
    //ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MFAT002' 	OPERATION MODEL_OPERATION_INSERT 	ACCESS 0 
    //ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MFAT002' 	OPERATION MODEL_OPERATION_DELETE 	ACCESS 0 
Return aRotina
 
 /*
 �+-----------------------------------------------------------------------------+�
 ��Programa  � ModelDef         � Autor � Lucas Nogueira     � Data � 10/03/2016��
 �+----------+------------------------------------------------------------------��
 ��Descri��o �                                                 		      		��
 �+-----------------------------------------------------------------------------��
 ��			ATUALIZA��ES SOFRIDAS DESDE A CONSTRU��O INICIAL				    ��
 �+-----------------------------------------------------------------------------��
 �� Analista           � Data        �  Motivo da Altera��o			            ��
 �+--------------------+-------------+------------------------------------------��
 �� 				      �				�		  								��
 �+--------------------+-------------+------------------------------------------��
 ��			          �		  		�										    ��
 �+--------------------+-------------+------------------------------------------+�
 */
 Static Function ModelDef()
Local oModel := Nil     				//Cria��o do objeto do modelo de dados
Local oStZZ1 := FWFormStruct(1, "ZZ1")  //Cria��o da estrutura de dados utilizada na interface
     
    //Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("MFAT002M",/*bPre*/, { |oModel| VldTela(oModel) },/*bCommit*/,/*bCancel*/)
     
    //Atribuindo formul�rios para o msodelo
    oModel:AddFields("FORMZZ1",/*cOwner*/,oStZZ1)
     
    //Setando a chave prim�ria da rotina
    oModel:SetPrimaryKey({'ZZ1_FILIAL+ZZ1_SERIE+ZZ1_NOTA'})
     
    //Adicionando descri��o ao modelo
    oModel:SetDescription(cTitulo)
     
    //Setando a descri��o do formul�rio
    oModel:GetModel("FORMZZ1"):SetDescription(cTitulo)
    
Return oModel


/*
�+-----------------------------------------------------------------------------+�
��Programa  �               � Autor � Lucas Nogueira     � Data � 10/03/2016��
�+----------+------------------------------------------------------------------��
��Descri��o �                                                 		           ��
��          �                                                            	   ��
�+----------+------------------------------------------------------------------��
��Uso       �  								                              	   ��
�+----------+------------------------------------------------------------------��
��Parametros� 	                          	  								   ��
�+----------+------------------------------------------------------------------��
��Retorno	� 	                                        	  				   ��
�+-----------------------------------------------------------------------------��
��			ATUALIZA��ES SOFRIDAS DESDE A CONSTRU��O INICIAL				   ��
�+-----------------------------------------------------------------------------��
�� Analista           � Data        �  Motivo da Altera��o			           ��
�+--------------------+-------------+------------------------------------------��
�� 				      �				�		  								   ��
�+--------------------+-------------+------------------------------------------��
��			          �		  		�										   ��
�+--------------------+-------------+------------------------------------------+�
*/
Static Function ViewDef()
//Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
Local oModel := FWLoadModel("MFAT002")
 
//Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
Local oStZZ1 := FWFormStruct(2, "ZZ1")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SBM_NOME|SBM_DTAFAL|'}
 
//Criando oView como nulo
Local oView := Nil
 
    //Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formul�rios para interface
    oView:AddField("VIEW_ZZ1", oStZZ1, "FORMZZ1")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando t�tulo do formul�rio
    oView:EnableTitleView('VIEW_ZZ1', cTitulo )  
     
    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})
     
    //O formul�rio da interface ser� colocado dentro do container
    oView:SetOwnerView("VIEW_ZZ1","TELA")
    
Return oView

/*
�+-----------------------------------------------------------------------------+�
��Programa  �               � Autor � Lucas Nogueira     � Data � 10/03/2016��
�+----------+------------------------------------------------------------------��
��Descri��o �                                                 		           ��
��          �                                                            	   ��
�+----------+------------------------------------------------------------------��
��Uso       �  								                              	   ��
�+----------+------------------------------------------------------------------��
��Parametros� 	                          	  								   ��
�+----------+------------------------------------------------------------------��
��Retorno	� 	                                        	  				   ��
�+-----------------------------------------------------------------------------��
��			ATUALIZA��ES SOFRIDAS DESDE A CONSTRU��O INICIAL				   ��
�+-----------------------------------------------------------------------------��
�� Analista           � Data        �  Motivo da Altera��o			           ��
�+--------------------+-------------+------------------------------------------��
�� 				      �				�		  								   ��
�+--------------------+-------------+------------------------------------------��
��			          �		  		�										   ��
�+--------------------+-------------+------------------------------------------+�
*/
User Function MFAT002Leg()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERMELHO",    "Aguardando Inclus�o Canhoto" })
    AADD(aLegenda,{"BR_VERDE"	,    "Informa��es do Canhoto Inseridas"	})
     
    BrwLegenda(cTitulo, " ", aLegenda)
Return

/*
�+-----------------------------------------------------------------------------+�
��Programa  �               � Autor � Lucas Nogueira     � Data � 10/03/2016��
�+----------+------------------------------------------------------------------��
��Descri��o �                                                 		           ��
��          �                                                            	   ��
�+----------+------------------------------------------------------------------��
��Uso       �  								                              	   ��
�+----------+------------------------------------------------------------------��
��Parametros� 	                          	  								   ��
�+----------+------------------------------------------------------------------��
��Retorno	� 	                                        	  				   ��
�+-----------------------------------------------------------------------------��
��			ATUALIZA��ES SOFRIDAS DESDE A CONSTRU��O INICIAL				   ��
�+-----------------------------------------------------------------------------��
�� Analista           � Data        �  Motivo da Altera��o			           ��
�+--------------------+-------------+------------------------------------------��
�� 				      �				�		  								   ��
�+--------------------+-------------+------------------------------------------��
��			          �		  		�										   ��
�+--------------------+-------------+------------------------------------------+�
*/

Static Function VldTela(oModel)

Local nOperation := oModel:GetOperation()

Local lRet			:= .T.

Local lUpload		:= .T.
Local cCodUsr 		:= RetCodUsr()

Local cFil			:= Alltrim(oModel:GetValue('FORMZZ1','ZZ1_FILIAL'))
Local dEmissao		:= oModel:GetValue('FORMZZ1','ZZ1_EMISSA')
Local dDtRec		:= oModel:GetValue('FORMZZ1','ZZ1_DTREC')
Local cSerie		:= Alltrim(oModel:GetValue('FORMZZ1','ZZ1_SERIE'))
Local cNota			:= Alltrim(oModel:GetValue('FORMZZ1','ZZ1_NOTA'))
Local cNome			:= Alltrim(oModel:GetValue('FORMZZ1','ZZ1_NOME'))
	
//Private aAnexo		:= {}
	
	If nOperation == 4
		If Empty(dDtRec) .Or. Empty(cNome)
			lRet	:= .F.
			Help("" ,1,cTitulo,, 'Favor preencher os campos Data de Recebimento e/ou Nome Recebedor ', 1, 0 ,.F.)
		Endif
	
        If lRet .And. MsgYesNo("Deseja Fazer Upload de Algum Documento?")
			MsDocument("ZZ1",ZZ1->(RECNO()),4)
            
            //Help("" ,1,cTitulo,, 'Favor selecionar o arquivo em a��es relacionadas.', 1, 0 ,.F.)
			
			/*While lUpload
				SelectFile(cFil+cSerie+cNota,cCodUsr)
				lUpload	:= MSGYESNO("Deseja Fazer Upload de Outro Documento?")
			End*/			
		Endif
	Endif
		
Return(lRet)


/*
�+-----------------------------------------------------------------------------+�
��Programa  �SelectFile        � Autor � Lucas Nogueira     � Data � 09/03/2016��
�+----------+------------------------------------------------------------------��
��Descri��o �Upload de Arquivo                                 		           ��
��          �                                                            	   ��
�+----------+------------------------------------------------------------------��
��Uso       �  								                              	   ��
�+----------+------------------------------------------------------------------��
��Parametros� 	                          	  								   ��
�+----------+------------------------------------------------------------------��
��Retorno	� 	                                        	  				   ��
�+-----------------------------------------------------------------------------��
��			ATUALIZA��ES SOFRIDAS DESDE A CONSTRU��O INICIAL				   ��
�+-----------------------------------------------------------------------------��
�� Analista           � Data        �  Motivo da Altera��o			           ��
�+--------------------+-------------+------------------------------------------��
�� 				      �				�		  								   ��
�+--------------------+-------------+------------------------------------------��
��			          �		  		�										   ��
�+--------------------+-------------+------------------------------------------+�
*/
Static Function SelectFile(cNome,cCodUsr)

Local cMascara 	:= "Todos (*.*) |*.*"
Local cTitulo 	:= "Anexo de Documento"
Local nMascpad  := 0
Local cDirini   := "\"
Local lSalvar   := .F. 			//.F. = Salva || .T. = Abre
Local nOpcoes   := GETF_LOCALHARD + GETF_NETWORKDRIVE
Local lArvore   := .F. 		//.T. = apresenta o �rvore do servidor || .F. = n�o apresenta
Local path  	:= '\Documentos\Canhoto_NF\' // DIRETORIO A SER SALVO NO SERVIDOR

Local cOldFile	:= ""
Local lSucess

Local cTime 	:= Time() 			 // Resultado: 10:37:17
Local cHora		:= Substr(cTime,1,2) // Resultado: 10
Local cMinutos 	:= Substr(cTime,4,2) // Resultado: 37
Local cSegundos := Substr(cTime,7,2) // Resultado: 17
		
	//�+------------------------------------------------------------------------------------+�
	//��Chave do Nome do Arquivo = (Filial + Serie + Nota + Data + Codigo Usu�rio + Hora   ��
	//�+------------------------------------------------------------------------------------+�																				
	cFileOpen	:= cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar, nOpcoes, lArvore)
	cAntgNome 	:= substr(cFileOpen,-(len(cFileOpen)-RAT('\',cFileOpen))) // PEGA NOME DO ARQUIVO ORIGINAL
	cExtensao 	:= substr(cFileOpen,- (len(cFileOpen) - RAT('.',cFileOpen) + 1)) //PEGA EXTENS�O DO ARQUIVO ORIGINAL
	cNovoNome 	:= alltrim(cNome) +"-"+ DTOS(Date()) + "-" +  cCodUsr + "-" + cHora+cMinutos+cSegundos   // NOME DO ARQUIVO GRAVADO NO SERVIDOR
	cAnti		:= path + cAntgNome
	cNovo		:= path + cNovoNome + cExtensao
	
	lSucess := CpyT2S ( cFileOpen, path)
	
	If lSucess
		lRenOk := FRename(cAnti, cNovo)	// RENOMEIA JA NO SERVIDOR O ARQUIVO ORIGINAL PARA O NOVO NOME
		MsgInfo('Arquivo salvo com sucesso')
		Aadd(aAnexo,cNovo)
	Else
		MsgAlert("Erro ao copiar o arquivo ''" + cAnti + "'!")
	EndIf

Return Nil

