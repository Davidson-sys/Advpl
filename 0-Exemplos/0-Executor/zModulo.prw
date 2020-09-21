#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} ESPnome.
Extreme Programming XP - modulo especifico Dcarvalho

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_ ESPnome() 		//Chamar no executor.

Link TDN:
http://www.helpfacil.com.br/forum/display_topic_threads.asp?ForumID=3&TopicID=17487&PagePosition=2
/*/
//--------------------------------------------------------------------
User Function ESPnome()

    Local aSaveArea :=  GetArea()  /*Salva a área atual */

    RestArea(aSaveArea)  /* Restaura a área atual */

Return("XProgramming")

//  u_ ESPnome() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 100% Funcionando.
