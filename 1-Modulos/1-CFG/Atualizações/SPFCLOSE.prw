
#INCLUDE 'Rwmake.ch'
#INCLUDE 'Colors.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

#DEFINE _CRLF  CHR(13)+CHR(10)
#DEFINE TAB  Chr(09)

//-------------------------------------------------------------------
/*/{Protheus.doc} zSPFCLOSE.
Funcao utilizada para fechar arquivo de senha para recuperar senha admin

@Author   Nome Sobrenome
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......
Especifico nome da empresa/cliente.

u_zSPFCLOSE() 		//Chamar no executor.

Link TDN:

/*/
//--------------------------------------------------------------------
User Function zSPFCLOSE()

    Local aSaveArea :=  GetArea()


    SPF_CLOSE("SIGAPSS.SPF")

    RestArea(aSaveArea)

Return( Nil )

//  u_zSPFCLOSE() 		//Chamar no executor.

//Resultado: em  99/99/9999 Nome Sobrenome  ---> Teste com a rotina - 0% Funcionando.



