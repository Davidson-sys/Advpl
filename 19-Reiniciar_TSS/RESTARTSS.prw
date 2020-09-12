#Include "Rwmake.ch"
#Include "Colors.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"
#include "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} zRestarTSS.
Reiniciar servi�o TSS no servidor. 
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

	Local cTitulo 	:= "Servi�o Transmissor de NFe"
	Local cMens		:= "Confirma a Reinicializa��o do servi�o de transmiss�o de Nota Fiscal Eletr�nica?"
	Local cRet		:= ""
	Local nCnt		:= 0
	Local nI		:= 0

	If Aviso(cTitulo,cMens,{"Confirmar","Abandonar"},2) == 1

		//Obt�m as informa��es dos usu�rios logados
		aInfo := GetUserInfoArray()

		//Busca no array se algum usu�rio est� utilizando as rotinas SPEDNFE e FISA022
		For nI := 1 to Len(aInfo)

			If Substr(aInfo[nI][11],at("Obj",aInfo[nI][11])+5,7) $ ("SPEDNFE/FISA022")

				cRet += IIf(Len(cRet) > 1,",","") + Alltrim(Substr(aInfo[nI][11],at("Logged",aInfo[nI][11])+8,24))

				nCnt++

			EndIf

		Next nI

		//Se algum usu�rio estiver utilizando as rotinas, mostra um aviso e n�o permite o reinicio
		If Len(cRet) > 1

			cMens := IIf(nCnt > 1,"Os usu�rios "+Upper(cRet)+" est�o ","O usu�rio "+Upper(cRet)+" est� ")
			cMens += "utilizando o servi�o de transmiss�o de Nota Fiscal Eletr�nica, portanto, o mesmo n�o poder� ser reiniciado!"

			Aviso("N�o Permitido!",cMens,{"Ok"},2)

		Else
			Processa({||fReinicia(),OemToAnsi('Aguarde...')},OemToAnsi('Reiniciando o Servi�o...'))

		EndIf

	EndIf
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} fReinicia.
Interrompe o servi�o do TSS
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

	IncProc("Encerrando o servi�o")

	//Interrompe e inicia o servi�o, em caso de algum erro, informa ao usu�rio
	//  WaitRunSrv( 'net stop "_TOTVS | NUT_CTB4"' , .T. , "E:\NUT_CTB4\bin\appserver\"  )      
	If 	WaitRunSrv( 'net stop "SQLSERVERAGENT"' , .T. , "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\")
		WaitRunSrv( 'net stop "SQLSERVERAGENT"' , .T. , "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\")



		IncProc("Iniciando o servi�o TSS")

	//     WaitRunSrv( 'net start "_TOTVS | NUT_CTB4"' , .T. ,"E:\NUT_CTB4\bin\appserver\"  )
	//													  	   E:\NUT_P11OFC\totvssped\bin\appserver\appserver.exe															 
		If WaitRunSrv( 'net start "SQLSERVERAGENT"'  , .T. ,"C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\")
			WaitRunSrv( 'net start "SQLSERVERAGENT"'  , .T. ,"C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\")

			MsgInfo("Servi�o reiniciado com sucesso!!")

		Else
			MsgStop("O servi�o n�o pode ser iniciado!!")
		EndIf
	Else
		MsgStop("O servi�o n�o pode ser encerrado!!")
	EndIf

Return

/*
Rascunho

//Interrompe e inicia o servi�o, em caso de algum erro, informa ao usu�rio
//  WaitRunSrv( 'net stop "_TOTVS | NUT_CTB4"' , .T. , "E:\NUT_CTB4\bin\appserver\"  ) 

// WaitRunSrv( 'net start "_TOTVS | NUT_CTB4"' , .T. ,"E:\NUT_CTB4\bin\appserver\"  )
//													  	   E:\NUT_P11OFC\totvssped\bin\appserver\appserver.exe
Teste com o servi�o SQL 
SQLSERVERAGENT
WaitRunSrv( 'net stop "SQLSERVERAGENT"' , .T. , "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\")
WaitRunSrv( 'net start "SQLSERVERAGENT"'  , .T. ,"C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\")

Resultado: em 25/08/2020 Davidson
Teste com o servi�o SQLSERVERAGENT - 100% Funcionando.
*/

