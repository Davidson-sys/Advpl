#INCLUDE "PROTHEUS.CH"

#DEFINE STR0001 "Informe o CEP"
#DEFINE STR0002 "Consulta de CEP"
#DEFINE STR0003	 "UF"
#DEFINE STR0004 "Cidade"
#DEFINE STR0005	 "Bairro"
#DEFINE STR0006 "Tipo de Logradouro"
#DEFINE STR0007 "Logradouro"
#DEFINE STR0008 "Resultado da Consulta"
#DEFINE STR0009 "CEP"
#DEFINE STR0010 "Mensagem"
#DEFINE STR0011 "Consultar Novo CEP?"
#DEFINE STR0012 "Consultando CEP"
#DEFINE STR0013 "Aguarde..."

/*/
	Funcao: FATW004
	Autor:	Marinaldo de Jesus
	Data:	20/09/2010
	Uso:	Consulta de CEP
	Obs.:	Exemplo de Consumo do WEB Service u_wsCEPInfo para Consulta de CEP ao site da Republica Virtual
/*/
User Function FATW004()

	Local aPerg			:= {}
	Local aResult		:= {}
	
	Local bCEPSearch
	
	Local cXML

	Local cError		:= ""
	Local cWarning		:= ""

	Local cUF
	Local cCidade
	Local cBairro
	Local cMensagem
	Local cResultado
	Local cLogradouro
	Local cTpLogradouro

	Local oWSCEP
	Local oXML

	BEGIN SEQUENCE
	
		aAdd( aPerg , { 1 , STR0002 , Space(8) , "99999999" , ".T." , "" , ".T." , 8 , .T. } ) //"Informe o CEP"
		IF ParamBox( @aPerg , STR0002 , NIL , NIL , NIL , .T. )
			
			bCEPSearch := { ||											; 
								oWSCEP 		:= WSU_WSCEPINFO():New(),	;
								oWSCEP:cCEP	:= MV_PAR01,				;
								oWSCEP:CEPSEARCH()						;
						   }	

			MsgRun( STR0013 , STR0012 , bCEPSearch ) //"Aguarde"###"Consultando CEP"

			cXML		:= oWSCEP:cCEPSEARCHRESULT
			oXML		:= XmlParser( cXML , "_" , @cError , @cWarning )
	
			cResultado	:= oXml:_WebServiceCep:_Resultado:Text
			cMensagem	:= oXml:_WebServiceCep:_Resultado_Txt:Text
	
			IF ( cResultado == "1" )
	
				cUF				:= oXml:_WebServiceCep:_UF:Text
				cCidade			:= oXml:_WebServiceCep:_Cidade:Text
				cBairro			:= oXml:_WebServiceCep:_Bairro:Text
				cLogradouro		:= oXml:_WebServiceCep:_Logradouro:Text
				cTpLogradouro	:= oXml:_WebServiceCep:_Tipo_Logradouro:Text

				aAdd( aResult , { 1 , STR0009 , MV_PAR01		, "99999999"	, ".T." , "" , ".F." , 08	, .F. } ) //"CEP"
				aAdd( aResult , { 1 , STR0003 , cUF 	  		, "@"			, ".T." , "" , ".F." , 04 	, .F. } ) //"UF"
				aAdd( aResult , { 1 , STR0004 , cCidade			, "@"			, ".T." , "" , ".F." , 100	, .F. } ) //"Cidade"
				aAdd( aResult , { 1 , STR0005 , cBairro			, "@" 		 	, ".T." , "" , ".F." , 100	, .F. } ) //"Bairro"
				aAdd( aResult , { 1 , STR0006 , cTpLogradouro	, "@" 		 	, ".T." , "" , ".F." , 100	, .F. } ) //"Tipo de Logradouro"
				aAdd( aResult , { 1 , STR0007 , cLogradouro		, "@"			, ".T." , "" , ".F." , 100	, .F. } ) //"Logradouro"

			Else
			
				aAdd( aResult , { 1 , STR0009 , MV_PAR01		, "99999999" 	, ".T." , "" , ".F." , 08	, .F. } ) //"CEP"
	
			EndIF

			ParamBox( @aResult , STR0008 + " : " + cMensagem , NIL , NIL , NIL , .T. )	//"Resultado da Consulta"


			IF !( MsgNoYes( "Consultar Novo CEP?" , ProcName() ) )
				BREAK
			EndIF
	
			U_FATW004()
	
		EndIF

	END SEQUENCE

Return( MBrChgLoop( .F. ) )