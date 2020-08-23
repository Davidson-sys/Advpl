#Include "Rwmake.ch"
#Include "Protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MT100LOK
Ponto de Entrada para Validacao da Digitacao do LOTE
@author 	Davis - NellTech
@since 		26/01/2016.
@version 	P11 R8
@param   	n/t
@return  	n/t
@obs
Exclusivo para Nutratta
/*/
//-------------------------------------------------------------------

User Function MT100LOK()

Local aArea    		:= GetArea()
Local lRetorno 		:= .T.
Local nPosCod  		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})
Local nPosTES  		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"})
Local nPosLote 		:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_LOTECTL'})
Local nPosLoteFor 	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_LOTEFOR'})
Local nPosValLote 	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_DTVALID'})
Local nPosCF 			:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_CF'})
Local lContinua		:= .T.
Local cFops			:= SuperGetMv("NT_CFTRANSP",.F.,"1532") //Parametros com as CFOPS de entrada com excessão para nao pedir lote. 

//Alert(cFops)

If ! GDdeleted(n) 

	dbSelectArea("SF4")
	SF4->( dbSetOrder(1))
	SF4->( dbSeek(xFilial("SF4")+aCols[n][nPosTES]))
	
	If Alltrim(aCols[n][nPosCF]) $  cFops 
		lContinua:= .F.
	EndIf
	
	
	If lContinua	
		If Rastro(aCols[n][nPosCod],"L") .And. SF4->F4_ESTOQUE == "S"
			
			If Empty(aCols[n][nPosLote]) 
				Aviso("Nutratta","Produto controlado por Lote, Favor preencher o numero do Lote.",{"Voltar"},2,"Produto: "+aCols[n][nPosCod])
				lRetorno := .F.
			EndIf
		EndIf
				
		If lRetorno .And.  Rastro(aCols[n][nPosCod],"L") .And. SF4->F4_ESTOQUE == "S"
			If Empty(aCols[n][nPosValLote]) 
				Aviso("Nutratta","Produto controlado por Lote, Favor preencher a data Validade do Lote.",{"Voltar"},2,"Produto: "+aCols[n][nPosCod]+" - Lote: "+aCols[n][nPosLote] )
				lRetorno := .F.
			EndIf	
		EndIf
	EndIf
EndIf

RestArea(aArea)

Return(lRetorno)
