#INCLUDE "TOTVS.CH"   
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBTREE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} N_VLDBLQ.
Rotina para validar o acesso a alteração do campo A1_MSBLQL
Somente usuarios pertencentes ao grupo 000004-Financeiro.

@Author   Davidson-Nutratta
@Since 	   13/05/2019.
@Version 	P11 R5
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico Nutratta Nutrição Animal.

xxx......
/*/
//-----------------------------------------------------------------------------------------------------------


User Function N_VLDBLQ() 

Local	_cCodUser  	:= RetCodUsr()
Local 	_cMemoria   := M->A1_MSBLQL
Local 	_CodCli		:= M->A1_COD
Local 	_LojCli		:= M->A1_LOJA
Local 	_lRet 		:= .T.
Local 	_lOk		:= .F.
Local   _cGravado	:= "" 
Local 	_aArray		:= {}  
Local   _n			:= 0

_cMensag1	:= ""+CHR(10)+CHR(13)+"Usuário sem acesso à bloqueio/Desbloqueio de clientes."+CHR(10)+CHR(13)+"Favor comunicar ao departamento Financeiro."+CHR(10)+CHR(13)


If PswSeek( _cCodUser, .T. )

	_aArray := PswRet() // Retorna vetor com informações do usuário
EndIf

For n:= 1 To Len(_aArray[1][10])

	If _aArray[1][10][n] == '000004'
	
	 _lOk:= .T.
	 Exit
	EndIf
Next n

dbSelectArea("SA1")
If dbSeek(xFilial("SA1")+_CodCli+_LojCli)

    _cGravado:=	SA1->A1_MSBLQL
    
	If _cMemoria !=_cGravado .And. !_lOk
	
		Aviso("Nutratta - Cadastros",_cMensag1,{"Sair"},3,"Gentileza voltar o conteudo do campo para: "+_cGravado)
		_lRet := .F.
	EndIf
EndIf


Return(_lRet)     