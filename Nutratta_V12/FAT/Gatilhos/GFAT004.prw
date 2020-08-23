#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//--------------------------------------------------------------------------
/* {Protheus.doc} NTFATGAT04
Gatilho para preencher a margem de contribui��o do produto.
  
Campo 		  C6_PRODUTO
Campo.Domino  C6_N_MARGE
Conteudo	  NTFATGAT04()  

O gatilho tem como objetivo preencher os campos 
campos abaixo:     

C6_N_CUSTD N 12.
C6_N_MARGE 12.       

Margem de contribui��o � igual:
Valor bruto do produto no pedido de venda -imposto gerado pra nota -frete do produto 
-provisao de comissao -(custo de material direto inserido na tabela de pre�o pelo Leonardo).

Empresa - Copyright - P2P Nutratta Nutri��o Animal.
@author Davidson Clayton
@since 11/01/2019.
@version P12 R8   
                   
DA1_N_CUST N 12.
@return Logico (o valor do custo direto)
*/
//--------------------------------------------------------------------------
User Function GFAT004()
              
Local _nPosPrd 		:= 	aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})  
Local _nPosCustD	:= 	aScan(aHeader,{|x| AllTrim(x[2])=="C6_N_CUSTD"})
Local _nPosMarG		:= 	aScan(aHeader,{|x| AllTrim(x[2])=="C6_N_MARGE"})  
Local _cCodPrd		:= 	GDFieldGet("C6_PRODUTO",n)
Local _cTEs			:=	GDFieldGet("C6_TES",n)
Local _cCfOp		:= 	GDFieldGet("C6_CF",n)
Local _nValBrut		:= 	GDFieldGet("C6_VALOR",n)//Valor bruto do produto   
Local _nValFrete	:= 	GDFieldGet("C6_",n)//Valor bruto do produto
Local _nValImposto	:= 	GDFieldGet("C6_",n)//Valor bruto do produto
Local _nValComiss	:= 	GDFieldGet("C6_",n)//Valor bruto do produto   

Local _cTipo		:=	M->C5_TIPO
Local _cTabela		:=	M->C5_TABELA
Local _cCondicao	:=	M->C5_CONDPAG
Local _nxi			:= 	0 
Local _nValCustD	:=	0	
Local _nMargContri	:=	0	
Local _nVal			:=	0
Local _Imposto		:=  0	//imposto gerado pra nota -frete do produto 
Local _lRet			:= .T.             
Local _cMens		:=	""

If xFilial("SC5") == "0101" //Espeficifico para matriz.

	//---------------------------------------------------------------------------------------
	// Posiciona na tabela de pre�o para pegar o valor do custo direto.
	//---------------------------------------------------------------------------------------
	dbSelectArea("DA1")
	dbSetOrder(7) //DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_COND  //Filial+Cod.Tabela+Codigo produto+condicao
	If dbSeek(xFilial("DA1")+Padr(_cTabela,3)+Padr(_cCodPrd,15)+Padr(_cCondicao,3))
		
		_nValCustD	:=DA1->DA1_N_CUST 
		
	EndIf
	
	C6_C_BASCO - Base Comissa
	C6_C_PERCO - % Comisao   
	C6_C_VLCOM - Vlr.Comissao
	
	//-------------------------------------------------------------------------------------------
	//Valor bruto do produto no pedido de venda -imposto gerado pra nota -frete do produto
	//provisao de comissao -(custo de material direto inserido na tabela de pre�o pelo Leonardo).  
	//-------------------------------------------------------------------------------------------
     _nValBrut-_Imposto-_nValFrete-
   
               
     
	_nMargContri

	
		
EndIf       
	
Return(_nMargContri)