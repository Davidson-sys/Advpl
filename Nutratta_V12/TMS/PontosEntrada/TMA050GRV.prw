#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"


//------------------------------------------------------------------+

/*/{Protheus.doc} TMA050grv()
Ponto de Entrada apos Gravacao do  Documento do cliente
@author 	Davis Magalhaes
@since 		31/08/2015
@version 	P11 R5
@param   	n/t
@return  	n/t
@obs        Programa Especifico para Nutratta          
			Cadastra Tabela de Preco Generica para TMS.
/*/
//------------------------------------------------------------------+


User Function TMA050GRV()

Local aAreaGrv      := GetArea()


MsgRun("Favor Aguardar","Validando Tabela Frete",{|| CursorWait(), TM050Tab(DTC->DTC_CDRORI,DTC->DTC_CDRCAL), CursorArrow()}) // "Selecionando Registros..."


RestArea(aAreaGrv)


Return Nil


//------------------------------------------------------------------+

/*/{Protheus.doc} TM050Tab()
Usado pelo P.E - TMA050GRV
@author 	Davis Magalhaes
@since 		31/08/2015
@version 	P11 R5
@param   	Cod Regiao Origem
			Cod Regiao Destino
@return  	n/t
@obs        Programa Especifico para Nutratta          

/*/
//------------------------------------------------------------------+

Static Function TM050Tab(cCdrOri,cCdrDes)

Local aArea01 := GetArea()                          

dbSelectArea("DT0")
DT0->( dbSetOrder(1) )

If ! DT0->( dbSeek(xFilial("DT0")+"R000"+"01"+cCdrOri+cCdrDes))
	
	DT0->( RecLock("DT0",.T.) )
	
	Replace DT0_FILIAL With xFilial("DT0") ,;
			DT0_TABFRE With "R000"    ,;
			DT0_TIPTAB With "01"     ,;
			DT0_CDRORI With cCdrOri ,;
			DT0_CDRDES With cCdrDes ,;
			DT0_CATTAB With "1"
	
	DT0->( MsUnLock())
	
	
	dbSelectArea("DT1")
	
	DT1->( RecLock("DT1",.T.) )
	
	Replace DT1_FILIAL With xFilial("DT1") ,;
			DT1_TABFRE With "R000" ,;
			DT1_TIPTAB With "01"  ,;
			DT1_CDRORI With cCdrOri ,;
			DT1_CDRDES With cCdrDes ,;
			DT1_CODPAS With "01"   ,;
			DT1_ITEM   With "01"   ,;
			DT1_VALATE With 999999999.9999 ,;
			DT1_FATPES With 0 ,;
			DT1_VALOR  With 1 ,;
			DT1_INTERV With 1 ,;
			DT1_TARIFA With "2"
	
	DT1->( MsUnLock() )

    // Grava Valor Componente de Pedagio
	
	dbSelectArea("DT1")
	
	DT1->( RecLock("DT1",.T.) )
	
	Replace DT1_FILIAL With xFilial("DT1") ,;
			DT1_TABFRE With "R000" ,;
			DT1_TIPTAB With "01"  ,;
			DT1_CDRORI With cCdrOri ,;
			DT1_CDRDES With cCdrDes ,;
			DT1_CODPAS With "02"   ,;
			DT1_ITEM   With "01"   ,;
			DT1_VALATE With 999999999.9999 ,;
			DT1_FATPES With 0 ,;
			DT1_VALOR  With 1 ,;
			DT1_INTERV With 1 ,;
			DT1_TARIFA With "2"
	
	DT1->( MsUnLock() )

// -- gRAVA cOMPONENTE 03	
	dbSelectArea("DT1")
	
	DT1->( RecLock("DT1",.T.) )
	
	Replace DT1_FILIAL With xFilial("DT1") ,;
			DT1_TABFRE With "R000" ,;
			DT1_TIPTAB With "01"  ,;
			DT1_CDRORI With cCdrOri ,;
			DT1_CDRDES With cCdrDes ,;
			DT1_CODPAS With "03"   ,;
			DT1_ITEM   With "01"   ,;
			DT1_VALATE With 999999999.9999 ,;
			DT1_FATPES With 0 ,;
			DT1_VALOR  With 1 ,;
			DT1_INTERV With 1 ,;
			DT1_TARIFA With "2"
	
	DT1->( MsUnLock() )

	
EndIf                              

RestArea(aArea01)

Return Nil
