#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "topconn.ch"      
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

//--------------------------------------------------------------------------
/* {Protheus.doc} NUTGERINV
Rotina para realizar a importaçãpo das 3 contagens do almoxarifado.
Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 121/12/2018
@version P11 R8
*/
//--------------------------------------------------------------------------
User  Function NUTGERINV()

Local _lAchou	:= .F.  
Local _cTabela	:= "SB7"


Local _nOpc		:=  0

Private oProcess

_nOpc := Aviso("G E R A - I N V E N T A R I O - I M P O R T A C A O ",;
+Chr(13)+Chr(10)+Chr(13)+Chr(10);
+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
"Escolha a opção para realizar a importação das tabelas de inventário!!!",{"Criar Tab","Import Invent"},2)

If _nOpc == 1
	
	//CHKFILE('TABELA')     
   	dbSelectArea(_cTabela)
	dbSetOrder(1)
	MsgBox("Tabela->>> 	"+_cTabela+"	<<<--- criada com sucesso!!","Mensagem","Info")
ElseIf _nOpc == 2   
	 
    oProcess := MsNewProcess():New( { || fProcessa(_cTabela) } ,"Importando registros...", "Analisando registros..." , .F. )
	oProcess:Activate() 
   	MsgBox("Dados importados com sucesso,Favor verificar!!","Mensagem","Info")	                  
EndIf 

Return         

/*
========================================================================================================================
Rotina----: fProcessa
Autor-----: Davidson Clayton
Data------: 21/12/2018
========================================================================================================================
Descrição-: Realiza o processamento de importação dos registros de inventário.
Uso-------:Especifico Nutratta 
========================================================================================================================
*/
Static Function	fProcessa(_cTabela)  

Local nContx	:= 0 
Local _cTempTbl	:= _cTabela+"X" 
Local cCaminho	:= "" 
                                                          
//SB7
Local cCaminho1	:= Alltrim("\CPROVA\"+Alltrim(_cTabela)+"\B7_09_"+_cTabela)


For nContx := 1 To 1
     
   	cCaminho:="cCaminho"+Alltrim(Str(nContx))
   	oProcess:SetRegua1(nContx) 
	oProcess:IncRegua1("Importando: "+Alltrim(Str(nContx)) +" de "+" 1 arquivos."+Substr((&cCaminho),13,20))
   
	dbUseArea( .T.,"DBFCDXADS",&cCaminho,_cTempTbl, .F., .F.)
		
	//--------------------------------------------------------------------------------
	//Realiza a importacao dos dados.
	//--------------------------------------------------------------------------------
	fGrvProcess(_cTabela,_cTempTbl)  

Next nContx
  
Return

/*
========================================================================================================================
Rotina----: fGrvProcess
Autor-----: Davidson Clayton
Data------: 21/12/2018
========================================================================================================================
Descrição-: Localiza os registros na base de dados de acordo com os parametros.
Uso-------:Especifico Nutratta 
========================================================================================================================
*/

Static Function fGrvProcess(_cTabela,_cTempTbl)

Local _nReg :=0

dbSelectArea(_cTempTbl)
dbGotop()
While (_cTempTbl)->(!Eof())
		
		//--Grava Contagem 1
		dbSelectArea(_cTabela)
		RecLock(_cTabela,.T.)
		       
		Replace B7_FILIAL			With "0101"	
		Replace B7_COD			 	With SB7X->B7_COD //Alltrim(Str(SB7X->B7_COD))	
		Replace B7_TIPO			 	With Posicione("SB1",1,xFilial("SB1")+SB7X->B7_COD,"B1_TIPO")
		Replace B7_LOCAL		 	With Alltrim(SB7X->B7_LOCAL)
		Replace B7_DATA		   		With STOD(Alltrim(Str(SB7X->B7_DATA)))
		Replace B7_DOC		   		With Alltrim((SB7X->B7_DOC))
		Replace	B7_QUANT		 	With SB7X->B7_CONTAGE 
		Replace	B7_CONTAGE		 	With '1'
		
	   //If SB7X->B7_CONTAGE ==  SB7X->B7_CONTAG4 
		//Replace B7_ESCOLHA	   	With 'S'  
	    //EndIf		
				
		MsUnlock()	
	    
	
   		//--Grava Contagem 2
		dbSelectArea(_cTabela)
		RecLock(_cTabela,.T.)
		       
		Replace B7_FILIAL			With "0101"	
		Replace B7_COD			 	With SB7X->B7_COD
		Replace B7_TIPO			 	With Posicione("SB1",1,xFilial("SB1")+SB7X->B7_COD,"B1_TIPO")	
		Replace B7_LOCAL		 	With Alltrim(SB7X->B7_LOCAL) //StrZero(SB7X->B7_LOCAL,2)
		Replace B7_DATA		   		With STOD(Alltrim(Str(SB7X->B7_DATA)))
		Replace B7_DOC		   		With Alltrim((SB7X->B7_DOC))
		Replace	B7_QUANT		 	With SB7X->B7_CONTAG2 
		Replace	B7_CONTAGE		 	With '2'
		 
	   //	If SB7X->B7_CONTAG2 == SB7X->B7_CONTAG4 .And. Empty(Alltrim(B7_ESCOLHA))
	   //	Replace B7_ESCOLHA	   	With 'S'  
	   //	EndIf	
	    			
		MsUnlock()	
	          
		//--Grava Contagem 3
		dbSelectArea(_cTabela)
		RecLock(_cTabela,.T.)
		       
		Replace B7_FILIAL			With "0101"	
		Replace B7_COD			 	With SB7X->B7_COD
		Replace B7_TIPO			 	With Posicione("SB1",1,xFilial("SB1")+ SB7X->B7_COD,"B1_TIPO")	
		Replace B7_LOCAL		 	With Alltrim(SB7X->B7_LOCAL)
		Replace B7_DATA		   		With STOD(Alltrim(Str(SB7X->B7_DATA)))
		Replace B7_DOC		   		With Alltrim((SB7X->B7_DOC))
		Replace	B7_QUANT		 	With val(SB7X->B7_CONTAG3)
		Replace	B7_CONTAGE		 	With '3'
		
	   //	If Val(SB7X->B7_CONTAG3) == SB7X->B7_CONTAG4 .And. Empty(Alltrim(B7_ESCOLHA))  
		//	Replace B7_ESCOLHA	   	With 'S'  
	    //	EndIf	
		
		MsUnlock()		    

		dbSelectArea(_cTempTbl)
		(_cTempTbl)->(dbSkip())
	//	(_cTempTbl)->(dbSkip())

	
	oProcess:SetRegua2(_nReg) 
	oProcess:IncRegua2("Gravando: ")
//	exit
End       

//			Replace &(((_cTabela)+"_TIPO")) 	With Posicione("SB1",1,xFilial("SB1")+SB7X->B7_COD,"B1_TIPO")
//--------------------------------------------------------------------------------
//Fecha a tabela temporaria.
//--------------------------------------------------------------------------------
//dbCloseArea(_cTempTbl)	 
(_cTempTbl)->(DbCloseArea())

