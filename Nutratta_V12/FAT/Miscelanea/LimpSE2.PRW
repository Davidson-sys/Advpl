#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "topconn.ch"      
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

//--------------------------------------------------------------------------
/* {Protheus.doc} SE2EXC
Rotina para realizar o saneamento dos titulo a pagar 
na tabela SE2
Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 12/11/2018
@version P11 R8
*/
//--------------------------------------------------------------------------
User Function SE2EXC()

Local _lAchou	:= .F.  
Local _cTabela	:= "SE2"
Local _nOpc		:=  0

Private oProcess

_nOpc := Aviso("E X C L U S A O - SE2-PAGAR";
+Chr(13)+Chr(10)+Chr(13)+Chr(10);
+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
"Deseja realizar a exclusão dos titulos a pagar?",{"Sair","Excluir Titulos"},2)

If _nOpc == 1
	Return
ElseIf _nOpc == 2   
	
	If "CTT" $ _cTabela 
    	
    	oProcess := MsNewProcess():New( { || fProcesCTT(_cTabela) } ,"Importando registros...", "Analisando registros..." , .F. )
		oProcess:Activate() 
   		MsgBox("Dados importados com sucesso,Favor verificar!!","Mensagem","Info")	                  
   	
   	ElseIf "SE2" $ _cTabela 
    	oProcess := MsNewProcess():New( { || fProceSE2(_cTabela) } ,"Excluindo registros...", "Analisando registros..." , .F. )
		oProcess:Activate() 
   		MsgBox("Dados deletados com sucesso,Favor verificar!!","Mensagem","Info")	                  
   	
   	EndIf
EndIf 

Return         


/*
========================================================================================================================
Rotina----: fProceSE2
Autor-----: Davidson Clayton
Data------: 29/05/2018
========================================================================================================================
Descrição-: Realiza o processamento de importação dos centros de custos.
Uso-------:Especifico Nutratta 
========================================================================================================================
*/
Static Function	fProceSE2(_cTabela)  

Local nContx	:= 0 
Local _cTempTbl	:= _cTabela+"X" 
Local cCaminho	:= ""
Local cCaminho1	:= Alltrim("\CPROVA\"+Alltrim(_cTabela)+"\TABELA_"+_cTabela) 
					

cCaminho:="cCaminho"
oProcess:SetRegua1(nContx) 
oProcess:IncRegua1("Excluindo: "+Alltrim(Str(nContx)))
   
dbUseArea( .T.,"DBFCDXADS",cCaminho1,_cTempTbl, .F., .F.)
		
//--------------------------------------------------------------------------------
//Realiza a importacao dos dados.
//--------------------------------------------------------------------------------
fGrvProSE2(_cTabela,_cTempTbl)  

  
Return

/*
========================================================================================================================
Rotina----: fGrvProSE2
Autor-----: Davidson Clayton
Data------: 15/05/2018
========================================================================================================================
Descrição-: Realiza a deleção dos registros.
Uso-------:Especifico Nutratta 
========================================================================================================================
*/

Static Function fGrvProSE2(_cTabela,_cTempTbl)

Local _nReg 	:=0 
Local cAplic	:=""
Local cPrefixo	:=""
Local cNumero	:=""
Local cFornec	:=""

dbSelectArea(_cTabela) 
dbSetOrder(1)
If dbSeek(xFilial("SE2")+Substr((_cTempTbl)->PRF_NUMERO,1,3)+Substr((_cTempTbl)->PRF_NUMERO,4,9))

	dbSelectArea(_cTempTbl)
	dbGotop()
	While (_cTempTbl)->(!Eof()) 
          
		
		cPrefixo:= Substr((_cTempTbl)->PRF_NUMERO,1,3) 
		cNumero	:= Substr((_cTempTbl)->PRF_NUMERO,4,9)
	    cFornec := Substr((_cTempTbl)->CODIGO_NOM,1,9)
		
		dbSelectArea(_cTabela) 
		dbSetOrder(1)
	   	If dbSeek(xFilial("SE2")+Alltrim((_cTempTbl)->cPrefixo+cNumero))
		 
	   //	 	exit     	
		 
			//--Realiza a deleção.
		   	dbSelectArea(_cTabela)
			RecLock(_cTabela,.F.)
		
  //		   DbDelete()
		   
			MsUnlock()	
		    
		EndIf
		
		dbSelectArea(_cTempTbl)
		(_cTempTbl)->(dbSkip())
	//	(_cTempTbl)->(dbSkip())
		_nReg++
		
		oProcess:SetRegua2(_nReg) 
		oProcess:IncRegua2("Excluindo: ")
//	exit
	End
EndIf
//--------------------------------------------------------------------------------
//Fecha a tabela temporaria.
//--------------------------------------------------------------------------------
//dbCloseArea(_cTempTbl)	 
(_cTempTbl)->(DbCloseArea())  
Return