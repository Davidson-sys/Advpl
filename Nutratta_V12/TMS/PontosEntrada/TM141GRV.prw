
#Include "Protheus.ch"

//-----------------------------------------------------------------------
/*/{Protheus.doc} TM141GRV 
Efetua a GRavacao do Contrato de Carreteiro automatico

@author Davis Magalhães
@since  30/01/2013
@version 1.0 

@param  cFilOri   Filial de Origem.
        cViagem   Numero da Viagem
                                                      
@Obs	Especifico Nutratta Agricola

@return Logico (.T. ou .F.)
/*/
User Function TM141GRV()

Private nOpcx   	:= PARAMIXB[1]
Private lRet 	  	:= .T.
Private aAreaGrv	:= GetArea()	    
Private cCodVei		:= ""                                     

           	                            

dbSelectArea("DTR")
DTR->( dbSelectArea(1) )
DTR->( dbSeek(xFilial("DTR")+DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM) )

cCodVei := DTR->DTR_CODVEI


dbSelectArea("DA3")
DA3->( dbSetOrder(1) )
DA3->( dbSeek(xFilial("DA3")+cCodVei) )


If DTR->DTR_VALFRE > 0 .And. DA3->DA3_FROVEI == '2' 
                                                                                                    
   If ! Empty(DA3->DA3_CODFOR)
   
   		MsgRun("Aguarde...","Gravando Contrato Fornecedor",{|| CursorWait(), TM141Ctr(DA3->DA3_CODFOR,DA3->DA3_LOJFOR), CursorArrow()}) // "Selecionando Registros..."
   Else
   		Aviso("Nutratta","O Veiculo da Viagem esta sem o campo de proprietario preenchido. Favor Verificar.",{"Voltar"},2,"Veiculo: "+cCodVei)
   		lRet := .F.
   EndIf
EndIf

RestArea(aAreaGrv)

Return(lRet)
            


//-----------------------------------------------------------------------
/*/{Protheus.doc} TM141Ctr
Efetua a GRavacao do Contrato de Carreteiro automatico

@author Davis Magalhaes
@since  30/01/2013
@version 1.0 

@param  cFilOri   Filial de Origem.
        cViagem   Numero da Viagem
                                                      
@Obs	Especifico Nutratta Agricola

@return Logico (.T. ou .F.)
/*/                 

Static Function TM141Ctr(cCodFor,cLojFor)


Local aAreaCtr 		:= GetArea()                                   
Local cNContrato    := ""             


/// -- GRava Contrato do Fornecedor


dbSelectArea("DUJ")
DUJ->( dbSetOrder(2) )
If ! DUJ->( dbSeek(xFilial("DUJ")+cCodFor+cLojFor) )
	
	cNContrato := GETSXENUM("DUJ","DUJ_NCONTR","",1)
	
	
	DUJ->(DbSetOrder(1))
	While DUJ->(DbSeek(xFilial("DUJ")+	cNContrato))
		ConfirmSx8()
		cNContrato := GETSXENUM("DUJ","DUJ_NCONTR","",1)
	EndDo
	
	
	DUJ->( RecLock("DUJ", .T.) )
	
	Replace DUJ_FILIAL With xFilial("DUJ") ,;
			DUJ_NCONTR With cNContrato ,;
			DUJ_CODFOR With cCodFor ,;
			DUJ_LOJFOR With cLojFor ,;
			DUJ_NOMFOR With Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_NOME") ,;
			DUJ_INIVIG With dDataBase ,;
			DUJ_GERAPC With "0"
			
	DUJ->( MsUnLock() )
	
	
	dbSelectArea("DVG")
	DVG->( RecLock("DVG",.T.) )
	
	Replace DVG_FILIAL With xFilial("DVG") ,;
			DVG_NCONTR With cNContrato ,;
			DVG_ITEM   With "01" ,;
			DVG_SERTMS With "3" ,;
			DVG_TIPTRA With "1" ,;
			DVG_TABFRE With "P000" ,;
			DVG_TIPTAB With "01" ,;
			DVG_TITPDG With "2" ,;
			DVG_DEDPDG With "2" ,;
			DVG_GERTIT With "1" ,;
			DVG_GRDVOO With "2"
	
	DVG->( MsUnLock() )
	
EndIf   

RestArea(aAreaCtr)

Return
