#INCLUDE "TOTVS.CH"   
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBTREE.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TBICONN.CH" 
#include "RWMAKE.CH"

#Define  _CRLF  CHR(13)+CHR(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} NTFATGAT05.
Rotina para calcular o desconto com base na condição de pagamento.

@Author   Davidson-Nutratta
@Since 	   30/09/2019.
@Version 	12.1.17
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico Nutratta Nutrição Animal.
Chamado na validação do campo:
C5_CONDPAG

/*/
//----------------------------------------------------------------------------------------------------------- 
User Function GFAT005()	

Local 	_nValDesc		:=  0              //Valor do desconto comercial
Local	_nPerDesc		:=  0              //Percentual do desconto comercial
Local   _nPrzMedio		:=  0    	       //Prazo medio praticado pela Nutratta
Local	_nNumDias		:=	0			   //Quantide dias entre data de emissão e condição de pagamento.
Local	_nVlrNovo		:=  0              //Valor calculado. 
Local 	_nY				:=  0 
Local   _nVrEncF 		:=  0              //Encargos Financeiros 
Local 	_nSumEncF		:=  0 			   //Soma dos encargos financeiros	
Local	_nVrDig			:=  0              //Valor digitado no item do pedido de vendas
Local	_nQtdReg		:=  0              //Contador de registros do acols
Local	_nVrParc		:=  0              //Valor de cada registro proporcional a taxa aplicada.
Local  	_nVrLiq			:=  0 			   // Valor liquido preço x quantidade	
Local 	_nDesProp       :=  0              // Valor proporcional do desconto por linha no acols
Local 	_nTxFIDIC	 	:=  (GetMv("NT_TXFDC")/100) //Taxa FIDIC Aplicada Percentual - _nTxFIDIC :=	(M->C5_TXFDC/100)
Local 	_cUsuDesc		:=  SuperGetMv("NT_USUDESC",.F.,"000000")
Local 	_cCodUsr 		:=  RetCodUsr()
Local	_cCondPgto 		:=	M->C5_CONDPAG  //Condição de pagamento. 
Local 	_cDesCond		:=  M->C5_C_DCOND  //Descrição da condição de pagamento. 
Local	_nPercDia		:=	M->C5_PERDIA   //Percentual diario desconto.
Local	_nValDia		:=	M->C5_VLDIA    //Valor do desconto calculo diario 
Local	_nValDesc		:=	M->C5_VALDES   //Valor do desconto referente a taxa.
Local	_cCondPag		:=	M->C5_CONDPG   //Campo replica do preenchimento da condição de pagamento (Virtual)
Local	_cDesCond		:=	M->C5_C_DCOND  //Campo replica do preenchimento da condição de pagamento (Virtual)
Local 	_lContinua		:= .T.
Local  	_lRetorno		:= .T.             

Private _nPos1			:= Ascan(aHeader,{|x|Alltrim(X[2]) == "C6_C_VLRDI"})
Private _nPos2			:= Ascan(aHeader,{|x|Alltrim(X[2]) == "C6_QTDVEN"}) 
Private _nPos3			:= Ascan(aHeader,{|x|Alltrim(X[2]) == "C6_PRCVEN"}) 
Private _nPos4			:= Ascan(aHeader,{|x|Alltrim(X[2]) == "C6_VALOR"})
Private _nPos5			:= Ascan(aHeader,{|x|Alltrim(X[2]) == "C6_C_FRETE"}) 
Private _nPos6 			:= Ascan(aHeader,{|x|Alltrim(X[2]) == "C6_C_ENCF"})
Private _nPos7 			:= Ascan(aHeader,{|x|Alltrim(X[2]) == "C6_DESCONT"}) 
Private _nPos8 			:= Ascan(aHeader,{|x|Alltrim(X[2]) == "C6_VALDESC"})  

Private _dEmissao 		:=	M->C5_EMISSAO  //Data de emissão do pedido
Private	_dDtata1		:= 	M->C5_DATA1    //Data de pagamento 1
Private	_dDtata2		:= 	M->C5_DATA2    //Data de pagamento 2
Private	_dDtata3		:= 	M->C5_DATA3    //Data de pagamento 3
Private	_dDtata4		:=  M->C5_DATA4    //Data de pagamento 4


//Somnente para a Industria
If xFilial("SC5") == '0101' 

	//-----------------------------------------------------------------------------------
	// Busca o numero de dias entre a data de emissão e .
	//-----------------------------------------------------------------------------------
	_nNumDias 	:= fCalcDia(_cCondPgto,_dEmissao,_dDtata1,_dDtata2,_dDtata3,_dDtata4)
	
	//-----------------------------------------------------------------------------------
	// Realiza o calculo
	//-----------------------------------------------------------------------------------
	_nPrzMedio	:= fCalcPrZ(_cCondPgto,_dEmissao,_dDtata1,_dDtata2,_dDtata3,_dDtata4)
	
	//-----------------------------------------------------------------------------------
	// Formula: =(1+C1)^(1/F1)-1) - Encontrar o % diário.
	//-----------------------------------------------------------------------------------
	_nPercDia 	:= ((1+(_nTxFIDIC))^(1/30)-1)//Sempre 30 dias.
	
	//-----------------------------------------------------------------------------------
	// Retorna o valor total do pedido de vendas.
	//-----------------------------------------------------------------------------------
	_nTotalPV 	:= fTotalPV()
	
	//-----------------------------------------------------------------------------------
	// Formula: VF = VP * (1+ taxa diária) ^ (dif. Dias)  - Econtrar o Valor
	//-----------------------------------------------------------------------------------
	_nVlrNovo	:= _nTotalPV * ((1+_nPercDia) ^ (_nPrzMedio - IIF(_cCondPgto == '20',_nNumDias,45)))  //aplicar o desconto financeiro no valor total do pedido
	
	//-----------------------------------------------------------------------------------
	// chama a tela para informação do desconto comercial
	//-----------------------------------------------------------------------------------
   //_nPerDesc	:= fGetDesCom() //IIF("001" $ _cCondPgto,fGetDesCom(),0)
	
	//------------------------------------------------------------------------------------
	//Realiza o calculo do desconto com base na regra Quantidade * preço lista (sem frete)
	//------------------------------------------------------------------------------------
	_nQtdReg 	:= Len(aCols)
	
	//-----------------------------------------------------------------------------------
	//Peccore os itens de venda para somar o valor.
	//-----------------------------------------------------------------------------------
	/*
	Private _nPos1			:= Ascan(aHeader,{|x|Alltrim(X[2])=="C6_C_VLRDI"})
	Private _nPos2			:= Ascan(aHeader,{|x|Alltrim(X[2])=="C6_QTDVEN"})
	Private _nPos3			:= Ascan(aHeader,{|x|Alltrim(X[2])=="C6_PRCVEN"})
	Private _nPos4			:= Ascan(aHeader,{|x|Alltrim(X[2])=="C6_VALOR"})
	Private _nPos5			:= Ascan(aHeader,{|x|Alltrim(X[2])=="C6_C_FRETE"})
	Private _nPos6 			:= Ascan(aHeader,{|x|Alltrim(X[2])=="C6_C_ENCF"})
	Private _nPos7 			:= Ascan(aHeader,{|x|Alltrim(X[2])=="C6_DESCONT"})
	Private _nPos8 			:= Ascan(aHeader,{|x|Alltrim(X[2])=="C6_VALDESC"}) */
	
//	If	_cUsuDesc $_cCodUsr
		
		For _nY:= 1 To Len(aCols)
			
			//-----------------------------------------------------------------------------------
			// Verifica se a linha não esta deletada.
			//-----------------------------------------------------------------------------------
			If !aCols[_nY][Len(aHeader)+1]
				
//				If 	M->C5_VALDES == 0
				
					_nVrDig		:= aCols[_nY][_nPos1]
					_nVrEncF	:= Round(_nVlrNovo -_nTotalPV,2)
					_nPercEnc	:= Round(Round(_nVrEncF,2) / aCols[_nY][_nPos2],2) * 100
					_nEncUnit	:= Round(Round((_nVrEncF * _nPercEnc)/ 100,2) / aCols[_nY][_nPos2],2)
					_nEncProp	:= Round(aCols[_nY][_nPos2] * _nSumEncF,2)
					_nVrLiq		:= aCols[_nY][_nPos2] * aCols[_nY][_nPos1]  // C6_C_VLRDI * C6_QTDVEN sem frete
					
					//-----------------------------------------------------------------------------------
					// Atualiza o acols antes da confirmação - Recalculando o valor total do pedido.
					//-----------------------------------------------------------------------------------
					
					aCols[_nY][_nPos6]	:= _nEncProp 
					aCols[_nY][_nPos1]	:= _nVrDig+_nEncUnit  //Preço Unitario.
					
					aCols[_nY][_nPos3]	:= _nVrDig+_nEncUnit  //Preço de venda
					
					_nValDesc	:=  Round(((_nVrLiq +_nEncProp) * _nPerDesc)/100,2)
					_nPerDesc	:=	Round(_nValDesc / _nVrLiq * 100,2)
					_nDesProp	:=	(_nValDesc / aCols[_nY][_nPos2])
					
					// aCols[_nY][_nPos7]	:= _nPerDesc	// Valor de desconto
					// aCols[_nY][_nPos8]	:= _nValDesc	// Valor de desconto
					
					aCols[_nY][_nPos3]	:= ((_nVrDig+aCols[_nY][_nPos5]+(_nEncUnit) - _nDesProp))  //Preço de venda
					
					_nVrTotal	:= aCols[_nY][_nPos3] * aCols[_nY][_nPos2]	//C6_PRCVEN * C6_QTDVEN  Valor Total
					aCols[_nY][_nPos4]	:=  _nVrTotal	//Valor Total
				/*Else 
					
					Alert("Evidenciamos que foi concedido um desconto financeiro/Comercial ao pedido anteriormente, o mesmo será recalculado!")
					
					_nVrDig		:= aCols[_nY][_nPos1]
					_nVrEncF	:= Round(_nVlrNovo -_nTotalPV,2)/_nQtdReg
					_nSumEncF	:= Round(_nVrEncF,2) /aCols[_nY][_nPos2]
					_nVrLiq		:= aCols[_nY][_nPos2] * aCols[_nY][_nPos1]  // C6_C_VLRDI * C6_QTDVEN sem frete
					
					//-----------------------------------------------------------------------------------
					// Atualiza o acols antes da confirmação - Recalculando o valor total do pedido.
					//-----------------------------------------------------------------------------------
					
					aCols[_nY][_nPos6]	:= _nVrEncF
					aCols[_nY][_nPos1]	:= _nVrDig+_nSumEncF  //Preço Unitario.
					
					aCols[_nY][_nPos3]	:= (_nVrDig+_nSumEncF)  //Preço de venda
					
					_nValDesc	:=  Round(((_nVrLiq +_nVrEncF) * _nPerDesc)/100,2)
					_nPerDesc	:=	Round(_nValDesc / _nVrLiq * 100,2)
					_nDesProp	:=	(_nValDesc / aCols[_nY][_nPos2])/_nQtdReg
					
					//		aCols[_nY][_nPos7]	:= _nPerDesc	// Valor de desconto
					//		aCols[_nY][_nPos8]	:= _nValDesc	// Valor de desconto
					
					aCols[_nY][_nPos3]	:= ((_nVrDig+aCols[_nY][_nPos5]+(_nSumEncF) - _nDesProp))+M->C5_VALDES  //Preço de venda
					
					_nVrTotal	:= aCols[_nY][_nPos3] * aCols[_nY][_nPos2]	//C6_PRCVEN * C6_QTDVEN  Valor Total
					aCols[_nY][_nPos4]	:=  _nVrTotal	//Valor Total */
//				EndIf
			EndIf
		Next _nY
				
		//-----------------------------------------------------------------------------------
		// Realiza a gravação dos valores calculados nos campos abaixo.
		//-----------------------------------------------------------------------------------
		//M->C5_CONDPG	:= _cCondPgto  	//Campo replica do preenchimento da condição de pagamento (Virtual)
		//M->C5_C_DESPG	:= _cDesCond	//Campo replica do preenchimento da condição de pagamento (Virtual)
		//M->C5_VLDIA 	:= 0
		M->C5_C_PRZMD	:= _nPrzMedio   //Prazo medio
		M->C5_TXFDC		:= (_nTxFIDIC*100)   	//Taxa 30 dias aplicada ao pedido de vendas.
		M->C5_PERDIA   	:= _nPercDia  	//Percentual diario desconto.
		M->C5_NUMDIAS  	:= _nNumDias	// Valor do desconto calculo diario
		M->C5_VALDES   	:= IIF(_nVlrNovo -_nTotalPV < 0 ,_nVlrNovo -_nTotalPV,0) 	//Valor do desconto referente a taxa
		M->C5_VLACRES  	:= IIF(_nVlrNovo -_nTotalPV >= 0 ,_nVlrNovo -_nTotalPV,0) 	//Valor do acrescimo referente a taxa
		M->C5_C_TOTAL   := Round(_nTotalPV,2)    //Total do pedido de vendas
		M->C5_C_TOT30   := Round(_nVlrNovo,2)    //Preco total apos aplicação da taxa 30 dias.


		
/*		_nOpc := Aviso("D E S C O N T O S   N U T R A T T A","CONFIRMA OS VALORES APÓS ACRÉSCIMOS/DECRÉSCIMOS?"+_CRLF;
		+"Condição: "+_cCondPgto+" - "+_cDesCond+_CRLF;
		+"Prazo Medio: "+Alltrim(Str(_nPrzMedio))+" -  "+" Desconto: "+Transform(_nPerDesc,"@E 999,999.99")+"%"+" - "+" R$ "+Transform(_nValDesc,"@E 999,999.99")+_CRLF;
		+"Taxa 30 Dias: "+Alltrim(Str(_nTxFIDIC*100))+"%"+_CRLF;
		+"Taxa Dia: "+Alltrim(Str(_nPercDia))+_CRLF;
		+"Total Pedido: "+"R$ "+Transform(_nTotalPV,"@E 999,999.99")+"  -  "+"Novo Valor "+"R$ "+Transform(_nVlrNovo,"@E 999,999.99");
		+"  -  "+"Diferença: R$ "+Transform(_nVlrNovo - _nTotalPV,"@E 999,999.99")+_CRLF,{"Sim","Nao"},2)
*/		

		//Chamar a função Wizard  
		fWizard()

		  
		
		
		If _nOpc ==1
			
			_lRetorno:=.T.
		Else
			_lRetorno:=.F.
		EndIf
//	EndIf
EndIf

Return(_lRetorno)

  

//-------------------------------------------------------------------
/*/{Protheus.doc} fCalcDia.
Rotina para somar a diferença somanda de dias entre cada data 
informada.
Função para calcular a diferença de dias entre a data de emissão e a 
condição de pagamento. 
@Author   Davidson-Nutratta
@Since 	   30/09/2019.
@Version 	P11 R5
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico Nutratta Nutrição Animal.
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function fCalcDia(_cCondPgto,_dEmissao,_dDtata1,_dDtata2,_dDtata3,_dDtata4)

Local _nDias	:= 0

//-------------------------------------------------
// Tratamento de condição de pagamento.
//------------------------------------------------- 
If _cCondPgto == '020'
	
	If !Empty(_dDtata4)
		
		_nDias+= DateDiffDay( dDataBase,_dDtata4)  //-> nDiffDay ( Diferenca em dias entre duas datas
	EndIf
	
	If !Empty(_dDtata3)

		_nDias+= DateDiffDay(dDataBase,_dDtata3)  	  //-> nDiffDay ( Diferenca em dias entre duas datas
	EndIf
	
	If !Empty(_dDtata2)
		
		_nDias+= DateDiffDay(dDataBase,_dDtata2)  //-> nDiffDay ( Diferenca em dias entre duas datas
	EndIf
	
	If !Empty(_dDtata1)
		
		_nDias+= DateDiffDay(dDataBase,_dDtata1)
	EndIf
Else
	_nDias := Posicione("SE4",1,xFilial("SE4")+_cCondPgto,"E4_N_DIAS")
EndIf

Return(_nDias)


//-------------------------------------------------------------------
/*/{Protheus.doc} fCalcPrZ.
Rotina para calcular o prazo medio das datas informadas.
@Author   Davidson-Nutratta
@Since 	   30/09/2019.
@Version 	P11 R5
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico Nutratta Nutrição Animal.
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function fCalcPrZ(_cCondPgto,_dEmissao,_dDtata1,_dDtata2,_dDtata3,_dDtata4)

Local _nPrzMedio	:= 0
Local _nParcela		:= 0
Local _nDias		:= 0

//-------------------------------------------------
// Tratamento de condição de pagamento.
//------------------------------------------------- 
If _cCondPgto == '020'
	
	If !Empty(_dDtata4)
		
		_nParcela++
		_nDias+= DateDiffDay( _dEmissao,_dDtata4)  //-> nDiffDay ( Diferenca em dias entre duas datas
	EndIf
	
	If !Empty(_dDtata3)
		
		_nParcela++
		_nDias+= DateDiffDay(_dEmissao,_dDtata3)  //-> nDiffDay ( Diferenca em dias entre duas datas
	EndIf
	
	If !Empty(_dDtata2)
		
		_nParcela++
		_nDias+= DateDiffDay(_dEmissao,_dDtata2)  //-> nDiffDay ( Diferenca em dias entre duas datas
	End
	
	If !Empty(_dDtata1)
		
		_nParcela++
		_nDias+= DateDiffDay(_dEmissao,_dDtata1)
	EndIf
	
	_nPrzMedio := _nDias / _nParcela
Else
	
	_nPrzMedio := Posicione("SE4",1,xFilial("SE4")+_cCondPgto,"E4_N_PRZMD")
EndIf 


Return(_nPrzMedio) 
          


//-------------------------------------------------------------------
/*/{Protheus.doc} fTotalPV.
Função para calcular o total do pedido de venda 
@Author   Davidson-Nutratta
@Since 	   30/09/2019.
@Version 	12.1.17
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico Nutratta Nutrição Animal.
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function fTotalPV()

Local _nTotalPV	:= 0
Local _nI		:= 0

//-----------------------------------------------------------------------------------
//Peccore os itens de venda para somar o valor.
//-----------------------------------------------------------------------------------
For _nI:= 1 To Len(aCols)
     
	//-----------------------------------------------------------------------------------
	// verifica se a linha não esta deletada.
	//-----------------------------------------------------------------------------------
     If !aCols[_nI][Len(aHeader)+1]
          
 		_nTotalPV += aCols[_nI][_nPos1]* aCols[_nI][_nPos2] 
//		_nTotalPV += aCols[_nI][_nPos4]
     EndIf
Next _nI
Return(_nTotalPV)



//-------------------------------------------------------------------
/*/{Protheus.doc} fGetDesCom.
Rotina para capturar o percentual do desconto comercial.
@Author   Davidson-Nutratta
@Since 	   30/09/2019.
@Version 	12.1.17
@param   	n/t
@return  	_nPerDesc
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function fGetDesCom()

Local _cUsuDesc	:= SuperGetMv("NT_USUDESC",.F.,"000000")
Local _cCodUsr 	:= RetCodUsr()
Local _nPerDesc	:= 0
Local _oTButton
Local _oDlgVen

If 	_cCodUsr $ _cUsuDesc

	Define MSDialog _oDlgVen From 000,000 To 60,360 Title OemToAnsi("Percentual de Desconto Comercial ") Pixel
	
	@010,002 Say " Percentual de  Desconto:" Size 120,08 Pixel Of _oDlgVen
	@010,080 MSGet _nPerDesc Size 040,08 Pixel Of _oDlgVen When .T.
	
	_oTButton := TButton():New(010,140,"OK",_oDlgVen,{|| _oDlgVen:End()},30,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	
	Activate MSDialog _oDlgVen Centered
EndIf         
Return(_nPerDesc)
            
            
Static Function	fWizard()            

Local cTexto1   := ""
Local cTexto2   := ""
Local cTexto3   := ""
Local cTexto4   := "" 
Local aTexto    := {}
Local aTxtPre 	:= {}
Local cMsgErro	:= "Erros encontrados durante o processamento " +_CRLF + _CRLF
Local _lContinua:=.T. 

Private oWizard
Private cArq1	:= Space(200)
Private cArq2	:= Space(200)
Private cArq3	:= Space(200)

Private cMesAno	:= Space(7)
Private cTipo	:=""
Private cErros	:= ""
Private lContinua:=.T.
Private cMessage:="Processo de validação finalizado...!" 
Private cCamArq	:="" 


//-----------------------------------------------------------------------------------
// Monta wizard com as perguntas necessarias
//-----------------------------------------------------------------------------------
aAdd(aTxtPre,"Conferência dos descontos Nutratta") //1
aAdd(aTxtPre,"Atenção")                    //2
aAdd(aTxtPre,"Gentileza validar os dados dos descontos.")//3
aAdd(aTxtPre,"")              //4

cTexto1 := " Esta rotina tem como objetivo facilitar a conferência dos descontos "
cTexto2 := " aplicados ao pedido de venda Nutratta   "
cTexto3 := " Desconto Comercial e Desconto Financeiro."
 

aAdd(aTexto,cTexto1+cTexto2+cTexto3)

DEFINE WIZARD oWizard ;
	TITLE aTxtPre[1]; 
	HEADER aTxtPre[2];
	MESSAGE aTxtPre[1];
	TEXT aTexto[1] ;
	NEXT {|| .T.} ;
	FINISH {|| .T.} ; 



CREATE PANEL oWizard  ;
	HEADER aTxtPre[3] ;
	MESSAGE ""	;
	BACK {|| .T.} ;
	NEXT {|| Iif(fValNext(),fProcessa(),.F.)} ;   
	PANEL                 
Return
