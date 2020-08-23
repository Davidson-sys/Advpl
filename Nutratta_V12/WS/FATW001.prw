#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.Ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "totvswebsrv.ch"

/*/
�������������������������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � FATW001  � Autor � Tiago Lucio     � Data da Criacao  � 07/04/2016                   					    ���
���������������������������������������������������������������������������������������������������������������������������͹��
���Descricao � Lista os clientes , retornando dentro da consulta Fluig                                              		���
���          � 																					                            ���
���������������������������������������������������������������������������������������������������������������������������͹��
���Uso       � 														             						                    ���
���������������������������������������������������������������������������������������������������������������������������͹��
���Parametros� Nenhum						   							                               						���
���������������������������������������������������������������������������������������������������������������������������͹��
���Retorno   � Nenhum						  							                               						���
���������������������������������������������������������������������������������������������������������������������������͹��
���Usuario   � Microsiga                                                                                					���
���������������������������������������������������������������������������������������������������������������������������͹��
���Setor     � Politriz				                                                                   						���
���������������������������������������������������������������������������������������������������������������������������͹��
���            			          	ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL                   						���
���������������������������������������������������������������������������������������������������������������������������͹��
���Autor     � Data     � Motivo da Alteracao  				               �Usuario(Filial+Matricula+Nome)    �Setor        ���
���������������������������������������������������������������������������������������������������������������������������ĺ��
���          �          �                               				   �                                  �   	        ���
���----------�----------�--------------------------------------------------�----------------------------------�-------------���
���          �          �                    							   �                                  � 			���
���----------�----------�--------------------------------------------------�----------------------------------�-------------���
���������������������������������������������������������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������������������������
/*/


//Para definir um tipo complexo utiliza-se as chaves WSSTRUCT e ENDWSSTRUCT, onde s�o 
//definidas as vari�veis da estrutura. Para definir que a estrutura ser� tratada como 
//um array, utiliza-se ARRAY OF antes do tipo da vari�vel e/ou estrutura

WsStruct ESTRUTSA1

    WsData A1_COD 		As String	OPTIONAL
    WsData A1_NOME 		As String	OPTIONAL
	WsData A1_NREDUZ 	As String	OPTIONAL
	WsData A1_CGC 		As String	OPTIONAL
	WsData A1_END 		As String	OPTIONAL
	WsData A1_MUN	 	As String	OPTIONAL
	WsData A1_EST	 	As String	OPTIONAL   
	WsData A1_BAIRRO	As String	OPTIONAL 
	WsData A1_COND	 	As String	OPTIONAL
	WsData A1_LOJA	 	As String	OPTIONAL
	WsData A1_DESCPG 	As String	OPTIONAL
EndWsStruct


//Declara��o da classe WsService

WsService FATWCLI DESCRIPTION "WebService de integra��o Fluig exporta��o cliente"

	// Vari�veis criadas para atender receber o c�digo da opera��o e a chave de autentica��o
	WSData cWSPWD 	   As String 	   //CHAVE PARA INTEGRA��O PARAMETRO MV_PWINTOP
	WsData cFiltro	   As String	   //Filtro para ser executado o retorno 
	WsData cVend	   As String	   //Codigo do Vendedor
									
	//Defini��o do objeto complexo que ir� utilizar as estruturas criadas
    WsData oClientes     As ARRAY OF ESTRUTSA1
	
	//Defini��o do m�todo:
    WsMethod BusClientes DESCRIPTION "Metodo para buscar cadastro de clientes"

EndWsService


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATW001P � Autor � Fabricio Antunes   � Data � 07/04/2016  ���
�������������������������������������������������������������������������͹��
���Descri��o � Gera o Pedido de venda                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������͹��
���Arquivos  �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//************************************************************************************************************
WsMethod BusClientes WsReceive cWSPWD,cFiltro,cVend WsSend oClientes WsService FATWCLI
//************************************************************************************************************
Local cChave 	:= ::cWSPWD  //CHAVE DE VALIDAO ORIGEM
Local cFiltro 	:= ::cFiltro
Local cVend		:= ::cVend
Local aExec 	:= {} //Retorno da fun��o que executa o MsExecAuto()
Local cPARPWD	:= '123456'//AllTrim(GetMv("MV_PWINTOP"))
Private aClientes	:={}
Default cFiltro:=""


conOut("[INFO] EXP_CLIENTE_1 " + dtoc(date()) + " " + Time() +" ==> Montando Vetor de Procesamento com cadastros de clientes")

// VALIDA SE CHAVE EST� CORRETA
if AllTrim(cChave) == AllTrim(cPARPWD)
			ConOut("Antes da chamada da fun��o FATW002P")
			U_FATW002P(::cFiltro,::cVend)
			For nX:=1 to Len(aClientes)
				AADD (oClientes,LoadORet(aClientes[nX]))
			Next
Else
	conOut("[ERRO] POOMSM04.PRW " + dtoc(date()) + " " + Time() +"==>Chave de seguran�a inv�lida!")
	AADD (oClientes:retornos,LoadORet(aClientes))
EndIf

Return(.T.)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATW002P � Autor � Fabricio Antunes   � Data � 07/04/2016  ���
�������������������������������������������������������������������������͹��
���Descri��o � carregar os clientes.                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������͹��
���Arquivos  �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FATW002P(cFiltro,cVend)
 
Local cQuery
Default cFiltro:=""

cFiltro:= strtran(cFiltro,".","")
cFiltro:= strtran(cFiltro,"-","")
cFiltro:= strtran(cFiltro,"/","")


cQuery:="SELECT  TOP 300 A1_NOME, A1_NREDUZ, A1_CGC, A1_END, A1_MUN, A1_COD, A1_EST, A1_BAIRRO, A1_COND, A1_LOJA FROM "+RetSqlName("SA1")+" WHERE D_E_L_E_T_ = ''  "

If Alltrim(cFiltro) <> ""
	cQuery+=" AND A1_CGC LIKE ('"+cFiltro+"%')
	//cQuery+=" AND ( A1_CGC LIKE ('"+cFiltro+"%') OR  A1_NOME ('"+cFiltro+"%') OR  A1_NREDUZ ('"+cFiltro+"%'))
EndIf

/*If Alltrim(cVend) <> "" 
	If Alltrim(cVend) = 'administrador'
		cQuery+=" AND A1_VEND ='000071'"
	Else
   		cQuery+=" AND A1_VEND ='"+cVend+"'"
 	EndIF
EndIf
*/
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRF", .T., .F. )

While !TRF->(EOF())
	AADD(aClientes,{TRF->A1_NOME,TRF->A1_NREDUZ,TRF->A1_CGC,TRF->A1_END,TRF->A1_MUN,TRF->A1_COD,TRF->A1_EST,TRF->A1_BAIRRO,TRF->A1_COND,TRF->A1_LOJA,POSICIONE("SE4",1,xFilial("SE4")+TRF->A1_COND,"E4_DESCRI")})
	TRF->(dbSkip())
EndDo
TRF->(dbCloseArea())

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATW001P � Autor � Fabricio Antunes   � Data � 07/04/2016  ���
�������������������������������������������������������������������������͹��
���Descri��o � Gera o Pedido de venda                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������͹��
���Arquivos  �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function LoadORet(_aDados)

Local oRetorno 		:= WsClassNew("ESTRUTSA1") // Objeto de retorno generico

	IF Len(_aDados) > 0  
		oRetorno:A1_COD			:= Alltrim(_aDados[6])
		oRetorno:A1_NOME		:= Alltrim(_aDados[1])
		oRetorno:A1_NREDUZ 		:= Alltrim(_aDados[2])
		oRetorno:A1_CGC 		:= Alltrim(_aDados[3])
		oRetorno:A1_END 		:= Alltrim(_aDados[4])
		oRetorno:A1_MUN	 		:= Alltrim(_aDados[5]) 
		oRetorno:A1_EST			:= Alltrim(_aDados[7])
		oRetorno:A1_BAIRRO		:= Alltrim(_aDados[8])
		oRetorno:A1_COND		:= Alltrim(_aDados[9])   
		oRetorno:A1_LOJA		:= Alltrim(_aDados[10]) 
		oRetorno:A1_DESCPG 		:= Alltrim(_aDados[11]) 
	Else
		oRetorno:A1_NOME		:= "ERRO DE SENHA"
		oRetorno:A1_NREDUZ 		:= "ERRO DE SENHA"
		oRetorno:A1_CGC 		:= "ERRO DE SENHA"
		oRetorno:A1_END 		:= "ERRO DE SENHA"
		oRetorno:A1_MUN	 		:= "ERRO DE SENHA"
		oRetorno:A1_COD	 		:= "ERRO DE SENHA"
	EndIf

Return oRetorno