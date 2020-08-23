#Include 'Protheus.ch'
#include 'ApWebSRV.ch'
#include 'TbiConn.ch'

User Function WebServices()

	WSSERVICE SERVERTIME Description "VEJA O HORARIO"
		WSDATA Horario AS String
		WSDATA Parametro AS String
	
		WSMETHOD GetServerTime Description "METHOD DE VISUALIZAÇÃO DE HORARIO"
	
	ENDWSSERVICE
	
	WSMETHOD GetServerTime WSRECEIVE Parametro WSSEND Horario WSSERVICE SERVERTIME 
	::Horario:=time()

Return .T.
