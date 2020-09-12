#Include "Rwmake.ch"
#Include "Colors.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"
#include "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} zRestarTSS.
Reiniciar serviço TSS no servidor. 
@Author   Davidson Carvalho
@Since 	   25/08/2020
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico nome da empresa/cliente.

u_zRestarTSS() 		//Chamar no executor.

xxx......
/*/
//-----------------------------------------------------------------------------------------------------------
User Function zRestarTSS()

	Local cTitulo 	:= "Serviço Transmissor de NFe"
	Local cMens		:= "Confirma a Reinicialização do serviço de transmissão de Nota Fiscal Eletrônica?"
	Local cRet		:= ""
	Local nCnt		:= 0
	Local nI		:= 0

	If Aviso(cTitulo,cMens,{"Confirmar","Abandonar"},2) == 1

		//Obtém as informações dos usuários logados
		aInfo := GetUserInfoArray()

		//Busca no array se algum usuário está utilizando as rotinas SPEDNFE e FISA022
		For nI := 1 to Len(aInfo)

			If Substr(aInfo[nI][11],at("Obj",aInfo[nI][11])+5,7) $ ("SPEDNFE/FISA022")

				cRet += IIf(Len(cRet) > 1,",","") + Alltrim(Substr(aInfo[nI][11],at("Logged",aInfo[nI][11])+8,24))

				nCnt++

			EndIf

		Next nI

		//Se algum usuário estiver utilizando as rotinas, mostra um aviso e não permite o reinicio
		If Len(cRet) > 1

			cMens := IIf(nCnt > 1,"Os usuários "+Upper(cRet)+" estão ","O usuário "+Upper(cRet)+" está ")
			cMens += "utilizando o serviço de transmissão de Nota Fiscal Eletrônica, portanto, o mesmo não poderá ser reiniciado!"

			Aviso("Não Permitido!",cMens,{"Ok"},2)

		Else
			Processa({||fReinicia(),OemToAnsi('Aguarde...')},OemToAnsi('Reiniciando o Serviço...'))

		EndIf

	EndIf
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} fReinicia.
Interrompe o serviço do TSS
@Author   Davidson Carvalho
@Since 	   25/08/2020
@Version 	12.1.25
@param   	n/t
@return  	Retorno da Static Function
xxxxx
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function fReinicia()

	ProcRegua(2)

	IncProc("Encerrando o serviço")

	//Interrompe e inicia o serviço, em caso de algum erro, informa ao usuário
	//  WaitRunSrv( 'net stop "_TOTVS | NUT_CTB4"' , .T. , "E:\NUT_CTB4\bin\appserver\"  )      
	If 	WaitRunSrv( 'net stop "SQLSERVERAGENT"' , .T. , "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\")
		WaitRunSrv( 'net stop "SQLSERVERAGENT"' , .T. , "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\")



		IncProc("Iniciando o serviço TSS")

	//     WaitRunSrv( 'net start "_TOTVS | NUT_CTB4"' , .T. ,"E:\NUT_CTB4\bin\appserver\"  )
	//													  	   E:\NUT_P11OFC\totvssped\bin\appserver\appserver.exe															 
		If WaitRunSrv( 'net start "SQLSERVERAGENT"'  , .T. ,"C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\")
			WaitRunSrv( 'net start "SQLSERVERAGENT"'  , .T. ,"C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\")

			MsgInfo("Serviço reiniciado com sucesso!!")

		Else
			MsgStop("O serviço não pode ser iniciado!!")
		EndIf
	Else
		MsgStop("O serviço não pode ser encerrado!!")
	EndIf

Return

/*
Rascunho

//Interrompe e inicia o serviço, em caso de algum erro, informa ao usuário
//  WaitRunSrv( 'net stop "_TOTVS | NUT_CTB4"' , .T. , "E:\NUT_CTB4\bin\appserver\"  ) 

// WaitRunSrv( 'net start "_TOTVS | NUT_CTB4"' , .T. ,"E:\NUT_CTB4\bin\appserver\"  )
//													  	   E:\NUT_P11OFC\totvssped\bin\appserver\appserver.exe
Teste com o serviço SQL 
SQLSERVERAGENT
WaitRunSrv( 'net stop "SQLSERVERAGENT"' , .T. , "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\")
WaitRunSrv( 'net start "SQLSERVERAGENT"'  , .T. ,"C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\")

Resultado: em 25/08/2020 Davidson
Teste com o serviço SQLSERVERAGENT - 100% Funcionando.
*/

