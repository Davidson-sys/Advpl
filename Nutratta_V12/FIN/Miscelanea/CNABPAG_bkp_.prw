#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "Protheus.ch"
#include "tbiconn.ch"
#include "Folder.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CNABP07   �Autor  �Thiago Silva        � Data �  08/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Formata CNPJ ou CPJ de acordo com as especificacoes        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CNABP07 (_cCGC)
Local nLen:=Len(Alltrim(_cCGC))
Local aRet
IF nLen = 11
	aRet:=SubStr(_cCGC,1,9)+'0000'+SubStr(_cCGC,10,2)
Else
	aRet:='0'+_cCGC
EndIF
Return (aRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CNABPAG   �Autor  �Thiago Silva        � Data �  08/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para preencher os dados quando e boleto bradesco    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CNABPXX (_nCampo)

Local aRet
Local cTipo:=SEA->EA_MODELO

IF _nCampo = 3
	IF cTipo = '31'
		aRet:=SubStr(SE2->E2_CODBAR,1,3)
		Return(aRet)
	Else
		aRet:=SA2->A2_BANCO
		Return(aRet)
	EndIF
EndIF


IF ((SubStr(SE2->E2_CODBAR,1,3) <> '237') .AND. cTipo <> '31') //Para todos os tipos exceto boletos
	IF _nCampo = 1
		IF SA2->A2_BANCO <> '237'
			aRet:=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+' '
		Else
//			aRet:=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+SA2->A2_C_DGAGE
			aRet:=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+SA2->A2_DVAGE
		EndIF
		Return(aRet)
	EndIF
	
	IF _nCampo = 2
//		IIF(Len(Alltrim(SA2->A2_C_DGCON)) = 1, cDig:=SA2->A2_C_DGCON+' ',cDig:=SA2->A2_C_DGCON)
		IIF(Len(Alltrim(SA2->A2_DVCTA)) = 1, cDig:=SA2->A2_DVCTA+' ',cDig:=SA2->A2_DVCTA)
		aRet:=StrZero(Val(Alltrim(SA2->A2_NUMCON)),13)+cDig 
		Return(aRet)
	EndIF
	IF _nCampo = 4
		aRet:='0'
		Return(aRet)
	EndIF
	
	IF _nCampo = 5
		aRet:=REPLICATE("0",11)
		Return(aRet)
	EndIF
	
ElseIF ((SubStr(SE2->E2_CODBAR,1,3) <> '237') .AND. cTipo = '31') //Para boletos exceto bradesco
	IF _nCampo = 1
		aRet:=REPLICATE("0",5)+' '
		Return(aRet)
	EndIF
	
	IF _nCampo = 2
		aRet:=REPLICATE("0",13)+'  '
		Return(aRet)
	EndIF
	IF _nCampo = 4
		aRet:='0'
		Return(aRet)
	EndIF
	
	IF _nCampo = 5
		aRet:=REPLICATE("0",11)
		Return(aRet)
	EndIF
	
ElseIF ((SubStr(SE2->E2_CODBAR,1,3) = '237') .AND. cTipo = '30') //Para boleto bradesco
	IF Len(ALLTRIM(SE2->E2_CODBAR)) = 44
		IF _nCampo = 1
			aRet:=StrZero(Val(SubStr(SE2->E2_CODBAR,20,4)),5)+U_CNABP06(SubStr(SE2->E2_CODBAR,20,4))
			Return(aRet)
		EndIF
		IF _nCampo = 2
			cDig:=U_CNABP06(SubStr(SE2->E2_CODBAR,37,7))
			IIF (Len(cDig) = 1, cDig:=cDig+' ',cDig:=cDig)
			aRet:=StrZero(Val(SubStr(SE2->E2_CODBAR,37,7)),13)+cDig
			Return(aRet)
		EndIF
		
		IF _nCampo = 4
			aRet:=SubStr(SE2->E2_CODBAR,24,2)
			Return(aRet)
		EndIF
		
		IF _nCampo = 5
			aRet:=SubStr(SE2->E2_CODBAR,26,11)
			aRet := StrZero(Val(aRet),12)
			Return(aRet)
		EndIF		
	Else
		IF _nCampo = 1
			aRet:=StrZero(Val(SubStr(SE2->E2_CODBAR,5,4)),5)+U_CNABP06(Substr(SE2->E2_CODBAR,5,4))
			Return(aRet)
		EndIF
		
		IF _nCampo = 2
			cDig:=U_CNABP06(SubStr(SE2->E2_CODBAR,24,7))
			IIF (Len(cDig) = 1, cDig:=cDig+' ',cDig:=cDig)
			aRet:=StrZero(Val(SubStr(SE2->E2_CODBAR,24,7)),13)+cDig
			Return(aRet)
		EndIF
		
		IF _nCampo = 4
			aRet:=SubStr(SE2->E2_CODBAR,9,1)+SubStr(SE2->E2_CODBAR,11,1)
			Return(aRet)
		EndIF
		
		IF _nCampo = 5
			aRet:=SubStr(SE2->E2_CODBAR,12,9)+SubStr(SE2->E2_CODBAR,22,2)
			aRet := StrZero(Val(aRet),12)
			Return(aRet)
		EndIF
		
	EndIF
EndIF

/*  No comdigo de barras bradesco os dados estao dispostos:
20 a 23  4  Ag�ncia Cedente (Sem o digito verificador, completar com zeros a esquerda quando necess�rio)
24 a 25  2  Carteira 
26 a 36  11  N�mero do Nosso N�mero(Sem o digito verificador)
37 a 43  7  Conta do Cedente (Sem o digito verificador, completar com zeros a esquerda quando necess�rio)
*/

Return (aRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CNABPAG   �Autor  �Microsiga           � Data �  08/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica o tipo de campo atrave do E2_TIPO                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CNABP03(_cTipo)

	Local cRet:='02'
	IIF (SE2->E2_TIPO = 'FT', cRet:='02',IIF (SE2->E2_TIPO = 'NF', cRet:='03',cRet:='05'))

Return (cRet)  

/*/
�������������������������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � CNABP04  � Autor �Thiago Silva          � Data da Criacao  � 27/02/2013  									���
���������������������������������������������������������������������������������������������������������������������������͹��
���Descricao � Funcao para dados complementares do CNAB                                                                     ���
���          �                                                                                            					���
���������������������������������������������������������������������������������������������������������������������������͹��
���Uso       � Cooprata - Bordero de Pagamento.     								                                 		���
���������������������������������������������������������������������������������������������������������������������������͹��
���Parametros� Nenhum						   							                               						���
���������������������������������������������������������������������������������������������������������������������������͹��
���Retorno   � Nenhum						  							                               						���
���������������������������������������������������������������������������������������������������������������������������͹��
���Usuario   � Microsiga                                                                                					���
���������������������������������������������������������������������������������������������������������������������������͹��
���Setor     � Faturamento                                                                            						���
���������������������������������������������������������������������������������������������������������������������������͹��
���            			          	ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL                   						���
���������������������������������������������������������������������������������������������������������������������������͹��
���Autor     � Data     � Motivo da Alteracao  				               �Usuario(Filial+Matricula+Nome)    �Setor    	���
���������������������������������������������������������������������������������������������������������������������������ĺ��
���          �00/00/0000�                               				   �00-000000 -                       � TI	    	���
���----------�----------�--------------------------------------------------�----------------------------------�-------------���
���          �          �                    							   �                                  � 			���
���----------�----------�--------------------------------------------------�----------------------------------�-------------���
���������������������������������������������������������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������������������������������������������������������
*/

User Function CNABP04()
Local cRet:=''
Local _cTipo:=SEA->EA_MODELO


IF _cTipo = '01'
	cRet:=Space(40)
ElseIF _cTipo = '03' .OR. _cTipo = '08'
	cRet:='C'
	cRet+='000000'
	cRet+=IIF(SEA->EA_MODELO=="01","00",SEA->EA_TIPOPAG)
	cRet+=IIF(SEA->EA_MODELO=="01","00","01")
	cRet+=SPACE(29)
	
ElseIf _cTipo = '31'
	If Len(Alltrim(SE2->E2_CODBAR)) == 44	//codigo de barras
        cRet := Substr(Alltrim(SE2->E2_CODBAR),20,25)//374 - 398: Campo Livre
        cRet += Substr(Alltrim(SE2->E2_CODBAR),5,1)  //399 - 399: Dig. Linha digitavel
        cRet += Substr(Alltrim(SE2->E2_CODBAR),4,1)  //400 - 400: Moeda       
        cRet += Space(13)        	                 //401 - 413: Brancos       
	Else    // linha digitavel
        cRet := Substr(Alltrim(SE2->E2_CODBAR),5,5) //374 - 398: Campo Livre
        cRet += Substr(Alltrim(SE2->E2_CODBAR),11,10) //374 - 398: Campo Livre
        cRet += Substr(Alltrim(SE2->E2_CODBAR),22,10) //374 - 398: Campo Livre
        cRet += Substr(Alltrim(SE2->E2_CODBAR),33,1) //399 - 399: Dig. Linha digitavel
        cRet += Substr(Alltrim(SE2->E2_CODBAR),4,1)  //400 - 400: Moeda       
        cRet += Space(13)        	                 //401 - 413: Brancos       
	EndIf
EndIF

Return (cRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CNABPAG   �Autor  �Vinicius Fernandes  � Data �  08/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para calculo do digito verificador da agencia e     ���
���          � conta corrente                                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CNABP06 (cVariavel)
Local Auxi := 0, sumdig := 0

cbase  := cVariavel
lbase  := LEN(cBase)
base   := 2
sumdig := 0
Auxi   := 0
iDig   := lBase
While iDig >= 1
	If base > 7
		base := 2
	EndIf
	auxi   := Val(SubStr(cBase, idig, 1)) * base
	sumdig := SumDig+auxi
	base   := base + 1
	iDig   := iDig-1
EndDo
auxi := mod(sumdig,11)        
if auxi == 1
   auxi:='P'
elseif auxi == 0
   auxi:="0"
else      
   auxi := 11 - auxi
   auxi := str(auxi,1,0)
endif   

Return(auxi)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CNABP08   �Autor  �Vinicius Fernandes  � Data �  08/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para retornar o Fator de vencimento do codigo de    ���
���          � barras                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CNABP08()

Local aRet
Local nTam:=Len(Alltrim(SE2->E2_CODBAR))
IF SEA->EA_MODELO <> '31'
	aRet:="0000"
Else
	IF nTam = 47
		aRet:=SubStr(SE2->E2_CODBAR,34,4)
	Else
		aRet:=SubStr(SE2->E2_CODBAR,6,4)
	EndIF
EndIF
Return (aRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CNABPAG   �Autor  �Microsiga           � Data �  08/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica o tipo de campo atrave do E2_TIPO                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CNABP09()
Local _cRet	:= ""

_cRet	:= STRZERO(VAL(SUBSTRING(ALLTRIM(SEE->EE_CONTA),1,LEN(ALLTRIM(SEE->EE_CONTA))-1)),7,0)

Return (_cRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CNABPAG   �Autor  �Microsiga           � Data �  08/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VAPAG (nValor, nMulta, nDesc)

	Local sVal:=StrZero((nValor+nMulta-nDesc)*100,15)

Return (sVal) 
        

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TPPGTO    � Autor � Alecio  AMM        � Data �  27/05/08   ���
�������������������������������������������������������������������������͹��
���Descricao � INFORMAR O TIPO DE PGTO. PARA CNAB A PAGAR - BRADESCO      ���
�������������������������������������������������������������������������͹��
���Uso       � Bramex                                                     ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                      

User Function TPPGTO

Local Tipo
 
 Tipo := IIF(SEA->EA_MODELO="05","01",IIF(SEA->EA_MODELO="41","08",IIF(SEA->EA_MODELO="43","08",IIF(SEA->EA_MODELO="30","31",SEA->EA_MODELO))))
   //iif(SEA->EA_MODELO="04","02",iif(SEA->EA_MODELO="10","02",;
         //iif(SEA->EA_MODELO="05","01",iif(SEA->EA_MODELO="07","03",SEA->EA_MODELO))))

Return(Tipo)


