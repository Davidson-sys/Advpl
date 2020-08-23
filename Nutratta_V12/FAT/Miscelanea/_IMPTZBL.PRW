#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "topconn.ch"      
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

//--------------------------------------------------------------------------
/* {Protheus.doc} ZZIMPTBL
Importação tabelas comissão.
Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 18/05/2018
@version P11 R8
*/
//--------------------------------------------------------------------------
User  Function ZZIMPTBL()

Local _lAchou	:= .F.  
Local _cTabela	:= "ZB4"
Local _nOpc		:=  0

Private oProcess

_nOpc := Aviso("C R I A C A O  - T A  B E L A - I M P O R T A C A O ",;
+Chr(13)+Chr(10)+Chr(13)+Chr(10);
+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
"Escolha a opção para realizar a importação das tabelas de comissionamento!!!",{"Criar Tab","Importar Reg"},2)

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
Data------: 15/05/2018
========================================================================================================================
Descrição-: Realiza o processamento de importação
Uso-------:Especifico Nutratta 
========================================================================================================================
*/
Static Function	fProcessa(_cTabela)  

Local nContx	:= 0 
Local _cTempTbl	:= _cTabela+"X" 
Local cCaminho	:= "" 
                                                          

//ZA4 ZA5 ZA6 ZA7 ZA9 ZB7
Local cCaminho1	:= Alltrim("\CPROVA\"+Alltrim(_cTabela)+"\TABELA_"+_cTabela)

For nContx := 1 To 1
     
   	cCaminho:="cCaminho"+Alltrim(Str(nContx))
   	oProcess:SetRegua1(nContx) 
	oProcess:IncRegua1("Importando: "+Alltrim(Str(nContx)) +" de "+" 1 arquivos."+Substr((&cCaminho),13,20))
   
	//dbUseArea( .T.,"DBFCDXADS",&cCaminho,_cTempTbl, .F., .F.)
	//dbUseArea( .T.,"CTREECDX",&cCaminho,_cTempTbl, .F., .F.)
	dbUseArea( .T.,"DBFCDX",&cCaminho,_cTempTbl, .F., .F.)
		
	//--------------------------------------------------------------------------------
	//Realiza a importacao dos dados.
	//--------------------------------------------------------------------------------
	fGrvProcess(_cTabela,_cTempTbl)  

Next nContx
  
Return

/*
========================================================================================================================
Rotina----: fFAT07PSearch
Autor-----: Davidson Clayton
Data------: 15/05/2018
========================================================================================================================
Descrição-: Localiza os registros na base de dados de acordo com os parametros.
Uso-------:Especifico Nutratta 
========================================================================================================================
*/

Static Function fGrvProcess(_cTabela,_cTempTbl)

Local _nReg 	:=0
Local _cTabela	:="ZB4"
                                  	
dbSelectArea(_cTempTbl)
dbGotop()
While (_cTempTbl)->(!Eof())
	
	//--Grava
	dbSelectArea(_cTabela)
	RecLock(_cTabela,.T.)
	
	Replace 	&(((_cTabela)+"_FILIAL")) 	With 	"0101"	//C 02 _cTempTbl->_cTempTbl_FILIAL       ((_cTabela)+"_FILIAL")
	Replace 	&(((_cTabela)+"_CODTAB"))	With 	Alltrim(((_cTempTbl)->&((Substr(_cTempTbl,1,3)+'_CODTAB'))))//C 3 //Alltrim(StrZero((_cTempTbl)->&((Substr(_cTempTbl,1,3)+'_CODTAB')),3))//C 3   
	Replace 	&(((_cTabela)+"_COND"))	   	With 	Alltrim(((_cTempTbl)->&((Substr(_cTempTbl,1,3)+'_COND'))))//C 3 //Alltrim(StrZero((_cTempTbl)->&((Substr(_cTempTbl,1,3)+'_COND')),3))//C 3    
//	Replace 	&(((_cTabela)+"_DESCON"))  	With 	Posicione("SE4",1,xFilial("SE4")+Alltrim(StrZero((_cTempTbl)->&((Substr(_cTempTbl,1,3)+'_COND')),3)),"E4_DESCRI")//C 15 
	Replace 	&(((_cTabela)+"_CODIGO"))  	With 	Alltrim(Str((_cTempTbl)->&((Substr(_cTempTbl,1,3)+'_CODIGO'))))	//C 15
	Replace 	&(((_cTabela)+"_DESCRI"))	With 	Alltrim((_cTempTbl)->&((Substr(_cTempTbl,1,3)+'_DESCRI')))
	Replace 	&(((_cTabela)+"_0000"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0000')		//N 12 2 
	Replace 	&(((_cTabela)+"_0025"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0025')		//N 12 2 
	Replace 	&(((_cTabela)+"_0050"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0050')		//N 12 2 
	Replace 	&(((_cTabela)+"_0075"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0075')		//N 12 2
	Replace 	&(((_cTabela)+"_0100"))		With	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0100')		//N 12 2 
	Replace 	&(((_cTabela)+"_0125"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0125') 		//N 12 2 
	Replace 	&(((_cTabela)+"_0150"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0150') 		//N 12 2                                                        
	Replace 	&(((_cTabela)+"_0175"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0175')		//N 12 2 
	Replace 	&(((_cTabela)+"_0200"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0200') 		//N 12 2 
	Replace 	&(((_cTabela)+"_0225"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0225') 		//N 12 2 
	Replace 	&(((_cTabela)+"_0250"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0250') 		//N 12 2 
	Replace 	&(((_cTabela)+"_0275"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0275') 		//N 12 2 
	Replace 	&(((_cTabela)+"_0300"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0300') 		//N 12 2 
	Replace 	&(((_cTabela)+"_0325"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0325')		//N 12 2 
	Replace 	&(((_cTabela)+"_0350"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0350')		//N 12 2
	Replace 	&(((_cTabela)+"_0375"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0375')		//N 12 2 
	Replace 	&(((_cTabela)+"_0400"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0400') 		//N 12 2 
	Replace 	&(((_cTabela)+"_0425"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0425')		//N 12 2 
	Replace 	&(((_cTabela)+"_0450"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0450')		//N 12 2 
	Replace 	&(((_cTabela)+"_0475"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0475') 		//N 12 2
	Replace 	&(((_cTabela)+"_0500"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0500')		//N 12 2
	Replace 	&(((_cTabela)+"_0525"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0525')		//N 12 2
	Replace 	&(((_cTabela)+"_0550"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0550')		//N 12 2
	Replace 	&(((_cTabela)+"_0575"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0575')		//N 12 2
	Replace 	&(((_cTabela)+"_0600"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0600')		//N 12 2
	Replace 	&(((_cTabela)+"_0625"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0625')		//N 12 2
	Replace 	&(((_cTabela)+"_0650"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0650')		//N 12 2
	Replace 	&(((_cTabela)+"_0675"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0675')		//N 12 2
	Replace 	&(((_cTabela)+"_0700"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0700')		//N 12 2
	Replace 	&(((_cTabela)+"_0725"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0725')		//N 12 2
	Replace 	&(((_cTabela)+"_0750"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0750') 		//N 12 2
	Replace 	&(((_cTabela)+"_0775"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0775') 		//N 12 2	 
	Replace 	&(((_cTabela)+"_0800"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0800')		//N 12 2 
	Replace 	&(((_cTabela)+"_0900"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0900')		//N 12 2 
	Replace 	&(((_cTabela)+"_1000"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_1000')		//N 12 2 
	Replace 	&(((_cTabela)+"_1100"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_1100')		//N 12 2 
	Replace 	&(((_cTabela)+"_1200"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_1200')	    //N 12 2 
	Replace 	&(((_cTabela)+"_1300"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_1300')		//N 12 2 
	Replace 	&(((_cTabela)+"_1400"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_1400')		//N 12 2 
	Replace		&(((_cTabela)+"_1500"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_1500')		//N 12 2 	
	Replace		&(((_cTabela)+"_1600"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_1600')		//N 12 2 
	Replace		&(((_cTabela)+"_1700"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_1700')		//N 12 2 
	Replace		&(((_cTabela)+"_1800"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_1800')		//N 12 2 
	Replace		&(((_cTabela)+"_1900"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_1900')		//N 12 2 
	Replace		&(((_cTabela)+"_2000"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_2000')		//N 12 2 
	Replace 	&(((_cTabela)+"_TABELA"))	With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_TABELA')
	Replace		&(((_cTabela)+"_0005"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0005')		//N 12 2
	Replace		&(((_cTabela)+"_0004"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0004')		//N 12 2
	Replace		&(((_cTabela)+"_0003"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0003')		//N 12 2
	Replace		&(((_cTabela)+"_0002"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0002')		//N 12 2 
	Replace		&(((_cTabela)+"_0001"))		With 	(_cTempTbl)->&(Substr(_cTempTbl,1,3)+'_0001')		//N 12 2	
	MsUnlock()	
    
	dbSelectArea(_cTempTbl)
	(_cTempTbl)->(dbSkip())
//	(_cTempTbl)->(dbSkip())
	_nReg++
	
	oProcess:SetRegua2(_nReg) 
//	oProcess:IncRegua2("Gravando: "+Alltrim(Str((_cTempTbl)->&((Substr(_cTempTbl,1,3)+'_FILIAL'))))+Alltrim((_cTempTbl)->&((Substr(_cTempTbl,1,3)+'_FILIAL'))))
	oProcess:IncRegua2("Gravando:")
End

//--------------------------------------------------------------------------------
//Fecha a tabela temporaria.
//--------------------------------------------------------------------------------
//dbCloseArea(_cTempTbl)	 
(_cTempTbl)->(DbCloseArea())