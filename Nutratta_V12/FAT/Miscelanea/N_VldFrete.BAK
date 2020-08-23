#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include 'parmtype.ch'         

//--------------------------------------------------------------------------
/* {Protheus.doc} N_VldFrete
Função para validar o frete de acordo com o km informado 
na tabela ZZJ-Locais de entrega e na ZZ8-Tabela de fretes Nutratta.

Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 12/03/2019
@version P11 R8
*/
//--------------------------------------------------------------------------

User Function VldFrt(_cNumPed,_cCliente,_cLojaCli,_cLocEntreg,_nOpc)

Local _aAreaAnt		:= GetArea()  
Local _cNumPed		:= _cNumPed
Local _cCliente		:= _cCliente
Local _cLojaCli		:= _cLojaCli
Local _cLocEntreg	:= _cLocEntreg
Local _nOpc			:= _nOpc
Local oProcess    	:= Nil
Local _lTrava 		:= .F. 
Local _lEnd	   		:= .F.

Private _aVlrs		:= {}
Private _nTotalFrt	:= 0 
Private _nToTblFrt	:= 0 

oProcess := MsNewProcess():New( { || fConsultFrt(_cNumPed,_cCliente,_cLojaCli,_cLocEntreg,_nOpc,oProcess,_lEnd) } ,"Consultando Tabela Frete...","Aguarde...." , .F. )
oProcess:Activate() 

//-----------------------------			
// Consulta para bloqueio 
//----------------------------
If	_nOpc == 1
	
	//	Frt Pv       Frt Tabela Frete     
	If _nTotalFrt >= _nToTblFrt //.And. _TBloq 
		
		_lTrava:= .F.
	Else
		_lTrava:= .T.
	EndIf

 	Return(_lTrava)
 	 
//-------------------------------
// Consulta Valor para exibição
//------------------------------
ElseIf  _nOpc == 2

	Return (_aVlrs)
EndIf 

RestArea(_aAreaAnt)
Return


/*
========================================================================================================================
Rotina----: fConsultFrt Consulta valor de frete.
Autor-----: Davidson Carvalho 
Data------: 08/04/2019.
========================================================================================================================
Descrição-: 
Uso-------: 
========================================================================================================================
*/

Static Function fConsultFrt(_cNumPed,_cCliente,_cLojaCli,_cLocEntreg,_nOpc,oProcess,_lEnd)

Local _aAreaAnt 	:= GetArea()
Local _aZA8			:= {} 
Local _aZA8X		:= {}  
Local _cEstado		:= "" 
Local _cCodTbl		:= "" 
Local _cEstado		:= "" 
Local _cCodTabela   := "" 
Local _cMensag1		:= ""  
Local _nKM			:= 0
Local _nValFrete	:= 0
Local _nQtdVend		:= 0 
Local _nFrete		:= 0 
Local _nProc1		:= 0
Local _nProc		:= 1
Local _nTotalFrt	:= 0
Local j		   		:= 0
Local i				:= 0 
Local w				:= 0  
Local lContinua		:= .T.
    

_cMensag1	:= "Local de Entrega com Km Zerado!!."+CHR(10)+CHR(13)+""+CHR(10)+CHR(13)+"Favor comunicar ao responsável pelo Setor Logistica."+CHR(10)+CHR(13)    
		
oProcess:SetRegua1(_nProc)   
For w:=1 To _nProc
    
	oProcess:IncRegua1("Consultando....")
	//-----------------------------------------------------------------------------------
	// Validação de clientes bloqueados. 
	//----------------------------------------------------------------------------------- 
	//oProcess:IncRegua1("Verificando estado do cliente....")
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1")+Padr(_cCliente,8)+Padr(_cLojaCli,4))
	
		_cEstado	:= SA1->A1_EST 
	EndIf
	 
	//-----------------------------------------------------------------------------------
	//Pedido de venda esta com bloqueio de Fretes (Nutratta). Tabela ZA8.
	//1=Liberado;2=Bloqueado;3=Liberado Usuário.  
	//ZZJ -Compartilhada  Indice:	ZZJ_FILIAL+ZZJ_CODIGO 
	//Pelo codigo e loja do cliente posicona no Local de entrega-ZZJ utilizado no pedido
	//e pega a kilometragem.
	//-----------------------------------------------------------------------------------   
	//oProcess:IncRegua1("Analisando data de vencimento....")
	//oProcess:IncRegua1("Verificando estado do cliente....")
	//oProcess:IncRegua1("Analisando data de entrega...") 
	//oProcess:IncRegua1("Verificando Tipo de frete CIF/FOB....")  
	
	dbSelectArea("ZZJ")
	dbSetOrder(1)
	If dbSeek(xFilial("ZZJ")+Padr(_cLocEntreg,4))
	
		_nKM	:=	ZZJ->ZZJ_KM
		
		If _nKM == 0
			
			 Aviso("Nutratta - Faturamento",_cMensag1,{"Sair"},3,"Local Entrega - Pedido No: "+Padr(_cLocEntreg,4))
		EndIf
	EndIf
		
	//-----------------------------------------------------------------------------------
	// Calcula o frete Total informado Quantidade x Valor frete.
	//-----------------------------------------------------------------------------------
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial("SC6")+_cNumPed)
	
	While ! SC6->(Eof())
	
		If SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == _cNumPed   
		 
			_nTotalFrt	+= SC6->C6_QTDVEN * SC6->C6_C_FRETE 
			_nQtdVend 	+= SC6->C6_QTDVEN
		EndIf	
	dbSelectArea("SC6")
	SC6->(dbSkip())
	End 	 
	
	//-----------------------------------------------------------------------------------
	// Tabela ZA8 
	// De posse da kilometragem e da quantidade, entra na tabela ZA8 e verifica o 
	// o km correto para assim pegar o frete a ser conferido. 
	//-----------------------------------------------------------------------------------
	If _nKM > 0 .And. _nQtdVend > 0 
	
		dbSelectArea("ZA8") 
		dbGotop()
		
		While ! ZA8->(Eof())
		
			Aadd(_aZA8,{ZA8->ZA8_CODIGO,ZA8->ZA8_KMINIC,ZA8->ZA8_KMFIM,ZA8->ZA8_FRETED,ZA8->ZA8_FRETEF,ZA8->ZA8_QTDINI,ZA8->ZA8_QTDFIM,ZA8_DESCRI})
			           	
		dbSelectArea("ZA8")
		ZA8->(dbSkip())
		End 
	Else              
	
		lContinua:=.F.
	EndIf   
	
	
	If lContinua
	
		//-----------------------------------------------------------------------------------
		// Realiza a busca dentro do array o Km correto dentro da faixa.
		//-----------------------------------------------------------------------------------
		For i:=1 To Len(_aZA8)
		
			If _nKM > 0 .And.  _nKM >= _aZA8[i][2]   .And. _aZA8[i][3] >= _nKM
				
				Aadd(_aZA8X,{_aZA8[i][1],_aZA8[i][2],_aZA8[i][3],_aZA8[i][4],_aZA8[i][5],_aZA8[i][6],_aZA8[i][7],_aZA8[i][8]})
			EndIf                                 
		Next i
				
		//-----------------------------------------------------------------------------------
		// Realiza a busca dentro do array a quantidade correta dentro da faixa.
		//-----------------------------------------------------------------------------------
		oProcess:SetRegua2(_nProc) 
		For j:=1 To Len(_aZA8X)
			 
			oProcess:IncRegua2("Calculando....")
			
				If _nQtdVend >= _aZA8X[j][6]  .And.  _nQtdVend <= _aZA8X[j][7]
				
				_cCodTabela := _aZA8X[j][1]
				
				//-----------------------------------------------------------------------------------
				// Verifico o estado do cliente D-Go F-Fora de Goias e verifico o valor de frete.
				//-----------------------------------------------------------------------------------
				If _cEstado == 'GO'
					
					_nToTblFrt :=	_nQtdVend * _aZA8X[j][4]  //Frete D
					 
					//            Pedido 		Frt Pv   Frt Tabela Frete 					 
		   			Aadd(_aVlrs,{_cNumPed,Transform(_nTotalFrt,"@E 99,999.99"),Transform(_nToTblFrt, "@E 99,999.99"),;
						Transform(_nTotalFrt - _nToTblFrt,"@E 99,999.99"),_cCodTabela,_aZA8X[j][8],_aZA8X[j][2],_aZA8X[j][3],;
						Transform(_aZA8X[j][4],"@E 99,999.99"),0,_aZA8X[j][6],_aZA8X[j][7]})
						Exit
				Else
					
					_nToTblFrt :=	_nQtdVend * _aZA8X[j][5]   //Frete F 
					
					//            Pedido 		Frt Pv   Frt Tabela Frete
					Aadd(_aVlrs,{_cNumPed,Transform(_nTotalFrt,"@E 99,999.99"),Transform(_nToTblFrt, "@E 99,999.99"),;
					Transform(_nTotalFrt - _nToTblFrt,"@E 99,999.99"),_cCodTabela,_aZA8X[j][8],_aZA8X[j][2],_aZA8X[j][3],;
					0,Transform(_aZA8X[j][5],"@E 99,999.99"),_aZA8X[j][6],_aZA8X[j][7]})
					Exit
				EndIf
			EndIf
			
			If 	_lEnd
				Exit
			EndIf
		Next j       
	EndIf
	Sleep(1000)
Next w

RestArea(_aAreaAnt)
Return 


//-------------------------------------------------------------------
/*/{Protheus.doc} fRefresPV.
Função para realizar a atualização do pedido de vendas.
de contribuição.
@Author   Davidson-Nutratta
@Since 	  25/04/2019.
@Version 	P11 R5
@param   	n/t
@return  	n/t
@obs.......  
o Especifico Nutratta Nutrição Animal.

xxx......
/*/
//-----------------------------------------------------------------------------------------------------------

Static Function fRefresPV(_cCliente,_cLojaCli,_cNumPed,_lTrava,_nFrTabela,_nFrtSoma,_nDifFrt)

Local _cQuery 	:= "" 
Local _cStatus	:= ""
Local _cMensag6	:= ""
Local _lBloqTMS	:= .T.
Local _lLibera	:= .T.
Local _lRet		:= .T.            
Local _lContinua:= .T.


_cMensag6 := "Pedido de venda esta com bloqueio de Fretes (Nutratta)."+CHR(10)+CHR(13)+"Favor comunicar ao responsável pelo Setor Logistica "+CHR(10)+CHR(13)
_cMensag6 += "para providenciar a solução do problema."               

dbSelectArea("SC5")
SC5->(dbSetOrder(3))
If dbSeek(xFilial("SC5")+_cCliente+_cLojaCli+_cNumPed)
	
	_lBloqTMS := SC5->C5_LIBTMS
	
	If _lBloqTMS .Or. !_lTrava
			
   		_lContinua:=.F. 
   	EndIf
	 
	If _lContinua       
		              
		_cStatus:='2'
		_cQuery =  " UPDATE C5 "
		_cQuery += " SET C5.C5_BLQ = '"+Alltrim(_cStatus)+"'"
		_cQuery += " ,C5.C5_FRTBL = '"+Alltrim(Str(_nFrTabela))+"'"
		_cQuery += " ,C5.C5_FRTSOMA = '"+Alltrim(Str(_nFrtSoma))+"'"
		_cQuery += " ,C5.C5_DIFRTBL = '"+Alltrim(Str(_nDifFrt))+"'" 
		_cQuery += " ,C5.C5_LIBNUTR = 'X' " 		
		_cQuery += " FROM SC5010 C5	"
		_cQuery += " WHERE C5.C5_NUM = '"+Alltrim(_cNumPed)+"'"
		_cQuery += " AND C5.C5_FILIAL= '"+xFilial("SC5")+"'"
		_cQuery += " AND C5.D_E_L_E_T_<>'*' "
		TcSqlExec(_cQuery)
	
		Aviso("Nutratta - Logistica",_cMensag6,{"Sair"},3,"Bloqueio - Pedido No: "+SC5->C5_NUM)
		_lRet := .F.
	EndIf
EndIf   
Return
   



