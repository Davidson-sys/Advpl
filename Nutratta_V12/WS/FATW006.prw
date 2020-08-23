#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.Ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "totvswebsrv.ch"



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออออออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณ FATW006  บ Autor ณ Fabrํcio Antunes      บ Data da Criacao  ณ 07/04/2016               					    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Realiza a grava็ใo no cadastro de prospects.			                                                 		บฑฑ
ฑฑบ          ณ 																					                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 														             						                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nenhum						   							                               						บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nenhum						  							                               						บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUsuario   ณ Microsiga                                                                                					บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSetor     ณ Politriz				                                                                   						บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ            			          	ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL                   						บฑฑ
ฑฑฬออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออัออออออออออออออออออออออออออออออออออัอออออออออออออนฑฑ
ฑฑบAutor     ณ Data     ณ Motivo da Alteracao  				               ณUsuario(Filial+Matricula+Nome)    ณSetor        บฑฑ
ฑฑบฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤบฑฑ
ฑฑบ          ณ          ณ                               				   ณ                                  ณ   	        บฑฑ
ฑฑบ----------ณ----------ณ--------------------------------------------------ณ----------------------------------ณ-------------บฑฑ
ฑฑบ          ณ          ณ                    							   ณ                                  ณ 			บฑฑ
ฑฑบ----------ณ----------ณ--------------------------------------------------ณ----------------------------------ณ-------------บฑฑ
ฑฑศออออออออออฯออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออฯออออออออออออออออออออออออออออออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/    

WsStruct SUSTRUCT

 	WsData US_COD 	 	As STRING	OPTIONAL
	WsData US_LOJA 		As STRING	OPTIONAL
	WsData US_NOME	 	As STRING	OPTIONAL
	WsData US_NREDUZ 	As STRING	OPTIONAL
	WsData US_TIPO	 	As STRING	OPTIONAL
	WsData US_END		As STRING	OPTIONAL
	WsData US_MUN	 	As STRING	OPTIONAL
	WsData US_EST	 	As STRING	OPTIONAL
	WsData US_PESSOA  	As STRING	OPTIONAL	
	WsData US_COD_MUN 	As STRING	OPTIONAL
	WsData US_BAIRRO  	As STRING	OPTIONAL
	WsData US_LC      	As STRING	OPTIONAL
	WsData US_VENCLC  	As STRING	OPTIONAL
	WsData US_CEP     	As STRING	OPTIONAL     
	WsData US_CGC     	As STRING	OPTIONAL
	WsData US_INSCR   	As STRING	OPTIONAL
	WsData US_REGIAO  	As STRING	OPTIONAL
	  
EndWsStruct                       


WsService CADPROSPECT DESCRIPTION "Grava็ใo dos prospects na SUS"

	// Variแveis criadas para atender receber o c๓digo da opera็ใo e a chave de autentica็ใo
	WSData cWSPWD 	   As String 	   //CHAVE PARA INTEGRAวรO PARAMETRO MV_PWSWEB 
	WSData cWSOPERA    As String   	   //CำDIGO DA OPERAวรO conforme abaixo:
    
    WsData oProspects   As SUSTRUCT

    // Variแveis criadas para atender o m้todo de libera็ใo de pedido
	WSData cWSRETURN   As String

    WsMethod GRVPROSPECTS DESCRIPTION "Metodo para grava็ใo do prospect via siagauto TMKA260"

EndWsService


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GRVPROSPECTS บ Autor ณ Fabricio Antunes   บ Data ณ 07/04/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Grava o prospect			                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบArquivos  ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

WsMethod GRVPROSPECTS WsReceive cWSPWD,cWSOPERA,oProspects WsSend cWSRETURN WsService CADPROSPECT

Local cChave 	:= ::cWSPWD  //CHAVE DE VALIDAO ORIGEM
Local cOera 	:= ::cWSOPERA
Local oDados 	:= ::oProspects 
Local cPARPWD	:= "123456" 
Local aProspects:={}  
Local _cLog     :=""

IF AllTrim(cChave) == AllTrim(cPARPWD)
         aProspects:={oDados:US_COD,oDados:US_LOJA,oDados:US_NOME,;
         oDados:US_NREDUZ,oDados:US_TIPO,oDados:US_END,oDados:US_MUN,;
         oDados:US_EST,oDados:US_PESSOA,oDados:US_COD_MUN,oDados:US_BAIRRO,;
         oDados:US_LC,oDados:US_VENCLC,oDados:US_CEP,oDados:US_CGC,;
         oDados:US_INSCR,oDados:US_REGIAO}
         
         cRet	:= U_FATW006P(aProspects)
         ::cWSRETURN:= cRet
Else
	conOut("[ERRO] FATW001 " + dtoc(date()) + " " + Time() +"==>Chave de seguran็a invแlida!")
	::cWSRETURN := "00000 -CHAVE DE SEGURANวA INVมLIDA" //RETORNO DE OPERAO NO CONCLUIDA
EndIf

Return(.T.)  



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FATW006P บ Autor ณ Fabricio Antunes   บ Data ณ 07/04/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Gera o Pedido de venda                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบArquivos  ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/  
User Function FATW006P(aProspects)

Local aReg:={}
Local aRet:={}
Local cNum:=""
Local cRet:=""
Local _cLog:=""

Private lMsErroAuto :=.F.
Private lAutoErrNoFile:=.T.  

//RpcSetType(3)
	
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"
//BEGIN TRANSACTION

cNum:=GETSXENUM("SUS","US_COD")
   
AAdd(aReg,{"US_COD"		,cNum			,Nil})
AAdd(aReg,{"US_LOJA"	,aProspects[2]  ,Nil})
AAdd(aReg,{"US_NOME"	,aProspects[3]	,Nil})
AAdd(aReg,{"US_NREDUZ"	,aProspects[4]	,Nil})
AAdd(aReg,{"US_TIPO"	,aProspects[5]	,Nil})   
AAdd(aReg,{"US_END"		,aProspects[6]	,Nil})
AAdd(aReg,{"US_MUN"		,aProspects[7]	,Nil})	
AAdd(aReg,{"US_EST"		,aProspects[8]	,Nil})
AAdd(aReg,{"US_PESSOA"	,aProspects[9]	,Nil})	
AAdd(aReg,{"US_COD_MUN"	,aProspects[10]	,Nil})	
AAdd(aReg,{"US_BAIRRO"	,aProspects[11]	,Nil})	
AAdd(aReg,{"US_LC"	,Val(aProspects[12]),Nil})
AAdd(aReg,{"US_VENCLC"	,Stod(aProspects[13])	,Nil})
AAdd(aReg,{"US_CEP"		,aProspects[14]		,Nil})
AAdd(aReg,{"US_CGC"		,aProspects[15]		,Nil})
AAdd(aReg,{"US_INSCR"	,aProspects[16]	,Nil})
AAdd(aReg,{"US_REGIAO"	,aProspects[17]	,Nil})
	
lMsErroAuto := .F.
	    
//	BEGIN TRANSACTION

//MSExecAuto({|x,y,z|Mata410(x,y,z)},aSC5,aSC6,3)
MSExecAuto({|x,y| TMKA260(x,y)},aReg,3) //3- Inclusใo, 4- Altera็ใo, 5- Exclusใo

If lMsErroAuto
	RollbackSx8()
	aAutoErro := GetAutoGRLog()
	_cLog:=""

	For nX := 1 To Len(aAutoErro)

		_cLog+= aAutoErro[nX]+CHR(13)+CHR(10)
		cRet+= aAutoErro[nX]+CHR(13)+CHR(10)
	Next nX

	DisarmTransaction()
	cRet:="Erro na inclusใo do prospect, favor contactar suporte t้cnico "+_cLog
Else
	ConfirmSx8()
	cRet+="Prospect:  "+cNum+" incluido com sucesso!"
EndIf
		

Return cRet
