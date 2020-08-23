#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//--------------------------------------------------------------------------
/* {Protheus.doc} M410LIOK
Ponto de entrada para realizar as validações na linha de itens do pedido de vendas.

*Criar validação onde, ao selecionar CIF obriga o preenchimento dos campos de 
frete item e no caso de FOB não precisar preencher-Solicitado por Tiago Medeiros 09/09/2016. 

* Validação para nao permitir criar o Pedido de Venda sem Contrato.

Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 09/09/2016
@version P11 R8   

@return Logico (.T. ou .F.)
*/
//--------------------------------------------------------------------------
User Function M410LIOK()

Local aAreaPRd	:= GetArea()
Local cTpFrete	:= M->C5_TPFRETE //C=CIF ; F=FOB ; T=Por conta de terceiros ; S=Sem frete 
Local cTabela	:= M->C5_TABELA
Local cCodCli	:= M->C5_CLIENTE
Local cCodLoj	:= M->C5_LOJACLI
Local cTipo		:= M->C5_TIPO
Local cLocEntr	:= M->C5_XLOCENT
	 

Local nPosPrd 	:= 	aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local cCodPrd	:= 	GDFieldGet("C6_PRODUTO",n)
Local nValFrete	:=	GDFieldGet("C6_C_FRETE",n)	
Local cTEs		:=	GDFieldGet("C6_TES",n)
Local cCFOP		:=	GDFieldGet("C6_CF",n)
Local cContrat	:=	GDFieldGet("C6_CONTRAT",n) 
Local lRet		:= .T.
Local lBonifica := .F.
Local cCFBonif	:= GETMV("MV_CTRBONI")	//CFOP utilizada para bonificacao no pedido de vendas.
Local cTesCtr	:= GETMV("MV_TESCTR")	//TES utilizada para contrato de parcerias.
	
If FUNNAME()=="MATA410"
	
	//--Validação tipo de Frete e frete zerado.
	If "C" $ cTpFrete .And. nValFrete == 0
		
		If aCols[n][Len(aCols[n])] == .F. //Valida se a linha não está deletada
			
			Aviso("Nutratta","Para o Tipo de frete CIF favor preencher o campo :"+Chr(13)+Chr(10)+"Frete Item. "+Chr(13)+Chr(10)+;
			"O conteúdo do campo deverá ser maior que Zero.",{"Voltar"},2,)
			lRet := .F.
		EndIf
	EndIf
	
	//--//Validação do preenchimento do local de entrega.
	/*
	If	"C" $ cTpFrete 	.And. Empty(Alltrim(cLocEntr))
		Aviso("Nutratta","Para o Tipo de frete CIF favor preencher o campo :"+Chr(13)+Chr(10)+"Local de entrega. "+Chr(13)+Chr(10)+;
		"Favor selecionar um local de entrega para o cliente.",{"Voltar"},2,)
		lRet := .F.	
	EndIf
	*/
		
	//-----------------------------------------------------------------------------------
	// Excessão solicita por Jenniffer e autorizada por Antonio Cortes em 06/12/1026
	// Regra: Não realizar a validação de contrato para Pedidos de bonificação com as 
	// TES e CFOPS: 
	// 520 = CFOP 5910 
	// 521 = CFOP 6910 
	// 522 = CFOP 6910	
	//
	//Davidson Nutratta-07/12/2016
	//-----------------------------------------------------------------------------------
	If Alltrim(cCFOP) $ Alltrim(cCFBonif)               
		
		lBonifica := .T.		//Alert("Bonificacao")
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Implantar no  Contrato de Parceria do Faturamento.
	//³ Garantir que não possa ser implementado novos pedidos de venda
	//³ do mesmo produto para clientes que ainda possuem contrato em aberto.
	//³
	//³ Objetivo.
	//³ Esta rotina deve garantir que não haja peidos palaleos
	//³ à contratos de parceiras em aberto já existentes para
	//³ o mesmo produto.                      ³
	//³
	//³ Davidson Clayton 08/09/2016. Solicitado por Antônio Cortes
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet .And. xFilial("SC5")=="0101"  .And. !lBonifica//Espeficifico para matriz.
		
		//--Contrato vazio nao foi gerado remessa.
		If 	Empty(cContrat)
			
			//--Realiza a validação da TES 509-Externa ou 504-Interna -- Mudou para 535-Externa e 536-Interna
			If  cTEs $ cTesCtr	  //Contrato de parceria
				
				If aCols[n][Len(aCols[n])] == .F.  //Valida se a linha não está deletada
				//Alterado em 26/05/2017,para atender a nova forma de contrato de parceria com nota mae.	
				//	Aviso("Nutratta","Campo contrato vazio."+Chr(13)+Chr(10)+;
				//	"Favor gerar a remessa para que seja criado o pedido de vendas.",{"Voltar"},2)
					lRet := .T.
				EndIf
			Else				
				//--Verfica se existe contrato em aberto para o cliente loja e produto.
				dbSelectArea("ADB")
				ADB->(dbGotop())
				While ADB->(!Eof())
											
					If cCodCli == ADB->ADB_CODCLI .And. cCodLoj == ADB->ADB_LOJCLI .And. ADB->ADB_CODPRO == cCodPrd
						
						If ADB->ADB_QUANT <> ADB->ADB_QTDEMP //Parcialmente atendido/Existe saldo a consumir no contrato.
				
							If aCols[n][Len(aCols[n])] == .F.  //Valida se a linha não está deletada
				
								//--Valida a situação do contrato na ADA
								dbSelectArea("ADA")
								ADA->(dbSetOrder(1))//ADA->ADA_FILIAL+ADA->ADA_NUMCTRDAVIDSON
								If ADA->(dbSeek(xFilial("SC5")+ADB->ADB_NUMCTR))
				
									If ADA->ADA_STATUS != "E" //Encerrado manualmente.
				 
										Aviso("Nutratta","Existe um contrato em aberto para este cliente e produto."+Chr(13)+Chr(10)+;
											"Favor verificar o contrato. ",{"Voltar"},2,"Contrato: "+ADB->ADB_NUMCTR)
										lRet := .F.
										Exit
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
					ADB->(dbSkip())
				EndDo
			EndIf
		Else
			//--Contrato com remessa.
			If  !cTEs $ cTesCtr //Não permitir coloca TES diferente de 509 504.
				
				If aCols[n][Len(aCols[n])] == .F.  //Valida se a linha não está deletada
					
				//	Aviso("Nutratta","TES-Inválida"+Chr(13)+Chr(10)+;
				//	"2016 - 504 509"+Chr(13)+Chr(10)+;
				//	"2017 - 535 536 ",{"Voltar"},2)
					lRet := .T. //"Para pedidos com contrato de parceria selecioanar:"+Chr(13)+Chr(10)+;
				EndIf
			EndIf			
		EndIf
	EndIf
EndIf 

RestArea(aAreaPRd)

Return(lRet)
           
/*
ADB->( dbSetOrder(2))//ADB_FILIAL+ADB_CODCLI+ADB_LOJCLI+ADB_CODPRO
If ADB->( dbSeek(xFilial("SC5")+cCodCli+cCodLoj+cCodPrd ))
	If ADB->ADB_QUANT <> ADB->ADB_QTDEMP //Parcialmente atendido/Existe saldo a consumir no contrato.
		Aviso("Nutratta","Existe um contrato em aberto para este cliente e produto. Favor verificar o contrato ",{"Voltar"},2,"Contrato: "+ADB->ADB_NUMCTR)
		lRet := .F.
	EndIf
EndIf 

//Proxima linha recebe o numero do contrato da linha anterior.
GDFieldPut("C6_TES",cTEs,Len(aCols))
GDFieldPut("C6_CONTRAT",cContrat,Len(aCols))
*/



		
	

