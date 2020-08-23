#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "colors.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH" 
#INCLUDE 'MSOBJECT.CH'
#Include "RPTDEF.CH"
#Include "FWPrintSetup.ch"

#DEFINE cDowLinh Chr(13)+Chr(10) // SALTO DE LINHA
#DEFINE _CRLF  CHR(13)+CHR(10) 	// TABULAÇÃO (TAB)
#DEFINE TAB  Chr(09)
//-------------------------------------------------------------------
/*/{Protheus.doc} MFAT0009.
Rotina para apuração das comissoes geradas após baixas dos titulos.
@Author   Davidson-Nutratta
@Since 	   28/11/2019.
@Version 	12.1.17
@param   	n/t
@return  	n/t
@obs.......  

/*/
//-----------------------------------------------------------------------------------------------------------

User Function MFAT0009()

Local oGet1
Local oDlg1 
Local aSaveArea	:= GetArea()

//-----------------------------------------------------------------------------------
//Função para exibir a tela Gerencial.
//-----------------------------------------------------------------------------------
fCreatScreen()
	
Return   


//-------------------------------------------------------------------
/*/{Protheus.doc} fCreatScreen.
Função de criação da tela de gerenciamento de comissões.
@Author   Davidson-Nutratta
@Since 	   28/11/2019.
@Version 	12.1.17
@param   	n/t
@return  	
/*/
//-----------------------------------------------------------------------------------------------------------

Static Function fCreatScreen()
      
Local oGroup1
Local nX
Local aPosObj    		:= {}
Local aObjects   		:= {}
Local aSize      		:= {}
Local aInfo      		:= {}
Local oFnt   			:= TFont():New("MS Sans Serif",,014,,.T.,,,,,.F.,.F.) 
Local aSize     		:= MsAdvSize()
Local nOpcX				:= GD_INSERT+GD_UPDATE+GD_DELETE
Local cIniCpos			:= ""								//Inicializacao de campos
Local cLinOk			:= "AlwaysTrue()"  					//"AlwaysTrue()"
Local cTudoOk			:= "AlwaysTrue()"					//Validacao de todas linhas
Local cFieldOk			:= "AlwaysTrue()"					//Validacao de campo
Local cDelOk			:= "AlwaysTrue()"					//Validacao de exclusao
Local nLimLin			:=  99								//Limite de linhas para a GetDados
Local lAux				:= .F.
Local lVisu				:= .T.
Local lVisu2			:= .T.
Local lRet				:= .T.
Local lGet	 			:= .T.
Local cText				:= "A"

Private oDlgEsp 	
Private _cGet1  		:= "LIMPE O CAMPO PARA TRAZER TODOS OS REGISTROS...." + Space(70)
Private _cPeriodo		:= Space(12)
Private lCheck			:= .F. 
Private	_nValSelec      := 0
Private	nValTotFixo		:= 0
Private	nValTCopart		:= 0
Private	nValTRepass		:= 0
Private	nValRepaJur		:= 0
Private	nValTaxa		:= 0
Private	_nTotGeral		:= 0
Private	nBol			:= 0
Private	nDebito			:= 0
Private	nValTBol		:= 0
Private	nValTDeb		:= 0 

Private	_dPerIni		:= Date()
Private	_dPerFim		:= Date()			                     
Private	_dDataIni		:= Date()
Private	_dDataFim		:= Date()
Private	_cRecalc    	:= ""
Private	_cImprimi   	:= ""		
		
//--------------------------------------------------------------------------------------------
//Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do segundo campo>+..." 
//--------------------------------------------------------------------------------------------
Private oGetD
Private nFreeze      	:= 0                // Campos estaticos na GetDados.
Private nUsado      	:= 0 
Private nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99
Private cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo
Private cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols
Private cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                   
Private aCmpAlter		:= {"ZZA->ZZA_NOME"}  
 
Private lInverte 		:= .F.
Private _aDados			:= {}
Private cMark   		:= GetMark()   
Private oMark		

SetPrvt("CALIAS,CARQUINDI,cCODFIL")


//-----------------------------------------------------------------------------------
//Objeto no qual a MsNewGetDados sera criada 
//-----------------------------------------------------------------------------------
Private aCols		:= {}
Private aHeader		:= {}
Private nOpc   		:=  GD_INSERT+GD_DELETE+GD_UPDATE //GD_UPDATE 
Private aRotina 	:= {{'','AxPesqui',0,1}, ;
   					{'','AxVisual',0,2}, ;
   					{'','AxInclui',0,3}, ;
   					{'','AxAltera',0,4}, ;
   					{'','AxDeleta',0,5}}
  
//-----------------------------------------------------------------------------------
// Função montar a Estrutura 
//-----------------------------------------------------------------------------------     
fStructure()  
	

//-----------------------------------------------------------------------------------
// Dimensoes Padrao
//-----------------------------------------------------------------------------------
aSize   := MsAdvSize()
aAdd(aObjects, {100, 020, .T., .F.})
aAdd(aObjects, {100, 100, .T., .T.})
aAdd(aObjects, {100, 100, .T., .T.})
aInfo   := {aSize[1], aSize[2], aSize[3], aSize[4], 5, 5}
aPosObj := MsObjSize(aInfo, aObjects)                                                                                                              

DEFINE MSDIALOG oDlgEsp TITLE OemToAnsi('Gerenciamento de Comissões Nutratta') FROM  aSize[7],0 To aSize[6],aSize[5] PIXEL 
 
//-----------------------------------------------------------------------------------
// Group para separa Período.
//----------------------------------------------------------------------------------- 
TGroup():New(30,05,57,160,'Período',oDlgEsp,CLR_RED,,.T.)

@ aPosObj[1,1]+7,030 SAY "Período" SIZE 041, 09 OF oDlgEsp PIXEL //Período.
@ aPosObj[1,1]+5,053 MSGET _cPeriodo PICTURE "@E 999999"  WHEN .T. VALID VLDPER(_cPeriodo,1)  SIZE 035, 012  OF oDlgEsp PIXEL F3 "ZB5PER" //Período comissão.

@ aPosObj[1,1]+1,95  SAY "Data Inicio:" SIZE 041, 09 OF oDlgEsp COLOR CLR_BLUE PIXEL  //Data Inicio.
@ aPosObj[1,1]+1,130 SAY _dDataIni	   	SIZE 041, 09 OF oDlgEsp COLOR CLR_BLUE PIXEL  

@ aPosObj[1,1]+7,95  SAY "Data Fim:"	SIZE 041, 09 OF oDlgEsp COLOR CLR_RED PIXEL  //Data Final
@ aPosObj[1,1]+7,130 SAY _dDataFim  	SIZE 041, 09 OF oDlgEsp COLOR CLR_RED PIXEL


//-----------------------------------------------------------------------------------
// Group para separa Filtros de data.
//----------------------------------------------------------------------------------- 
TGroup():New(30,170,57,295,'Filtrar',oDlgEsp,CLR_RED,,.T.)

@ aPosObj[1,1]+7,180 SAY "Filtrar:" 	SIZE 041, 09 OF oDlgEsp PIXEL  //Filtra o Perido inicial
@ aPosObj[1,1]+5,200 MSGET _dPerIni 	WHEN .T. VALID NaoVazio() SIZE 040, 008 OF oDlgEsp PIXEL 
                                                                               
@ aPosObj[1,1]+7,242 SAY " à " 	SIZE 041, 09 OF oDlgEsp PIXEL  //Filtra o Perido final
@ aPosObj[1,1]+5,252 MSGET _dPerFim 	WHEN .T. VALID NaoVazio() .And. (_dPerFim >= _dPerIni).And. MFATDADOS(_cPeriodo,_dPerIni,_dPerFim,_cGet1) SIZE 040, 008 OF oDlgEsp PIXEL 

//-----------------------------------------------------------------------------------
// Group para separa a pesquisa por descrição.
//----------------------------------------------------------------------------------- 
TGroup():New(30,300,57,520,'Pesquisa - Vendedor / Nota / Pedido',oDlgEsp,CLR_RED,,.T.)
@ aPosObj[1,1]+5,310 MSGET oGet1 VAR _cGet1 WHEN lGet VALID MFATDADOS(_cPeriodo,_dPerIni,_dPerFim,_cGet1)  SIZE 200,008 COLOR CLR_BLACK PICTURE "@!" FONT oFnt PIXEL OF oDlgEsp	

oGetD := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]+100,aPosObj[2,4],2,nOpc,"AllwaysTrue()","AllwaysTrue()",,aCmpAlter,0, ,cFieldOk,cDelOk,,oDlgEsp)
oGetD:oBrowse:blDblClick := {|| DLCLIK (oGetD:oBrowse:nAt,@oGetD)} 

@ aPosObj[3,1]+100,010 SAY "VALOR SELECIONADO:" 								SIZE 080, 09 Color CLR_BLUE	OF oDlgEsp PIXEL 
@ aPosObj[3,1]+100,070 SAY 	Alltrim(Transform (_nValSelec,"@E 999,999.99"))  	SIZE 041, 09 Color CLR_RED 	OF oDlgEsp PIXEL  //Valor Selecionado

/*@ aPosObj[3,1]+100,100 SAY "BOLETO:"											SIZE 041, 09 Color CLR_GREEN	OF oDlgEsp PIXEL 
@ aPosObj[3,1]+100,123 SAY 	nBol												SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Qtd.Boletos
@ aPosObj[3,1]+100,135 SAY 	Alltrim(Transform (nValTBol,"@E 999,999.99")) 		SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Valor Boletos

@ aPosObj[3,1]+100,170 SAY "DEBITO:"											SIZE 041, 09 Color CLR_GREEN	OF oDlgEsp PIXEL 
@ aPosObj[3,1]+100,190 SAY 	nDebito												SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Qtd.Debitos.
@ aPosObj[3,1]+100,203 SAY 	Alltrim(Transform (nValTDeb,"@E 999,999.99")) 		SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Valor Boletos
*/
@ aPosObj[3,1]+100,235 SAY "TOT. GERAL:"										SIZE 041, 09 Color CLR_BLUE	OF oDlgEsp PIXEL  
@ aPosObj[3,1]+100,270 SAY 	Alltrim(Transform (_nTotGeral,"@E 999,999.99")) 	SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Valor Fixo 


/*@ aPosObj[3,1]+100,315 SAY 	Alltrim(Transform (nValTCopart,"@E 999,999.99"))	SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Co-participação
@ aPosObj[3,1]+100,355 SAY 	Alltrim(Transform (nValTRepass,"@E 999,999.99"))	SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Repasse fisico
@ aPosObj[3,1]+100,405 SAY 	Alltrim(Transform (nValRepaJur,"@E 999,999.99"))	SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Repasse Juridico 
@ aPosObj[3,1]+100,475 SAY 	Alltrim(Transform (nValTaxa,"@E 999,999.99"))		SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Valor taxas
@ aPosObj[3,1]+100,570 SAY 	Alltrim(Transform (_nTotGeral,"@E 999,999.99")) 		SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Total Geral
*/

//-----------------------------------------------------------------------------------
// Realiza a criação dos botões em ações relacionadas.
//-----------------------------------------------------------------------------------
aButtons := {}                                                                    
aAdd(aButtons,{"Períodos Comissão",{|| U_MFAT0010()},"Períodos Comissão", OemToAnsi("Períodos Comissão")})   
aAdd(aButtons,{"Calcular Comissão",{|| fCalcComiss(_cPeriodo)},"Calcular Comissão", OemToAnsi("Calcular Comissão")})
aAdd(aButtons,{"Encerrar Período",{|| FechaPer()},"Encerrar Período", OemToAnsi("Encerrar Período")})   
   

//aAdd(aButtons,{"Memoria de Calculo",{|| DT6DB012()},"Memoria de Calculo", OemToAnsi("Memoria de Calculo")})  
//aAdd(aButtons,{"Recalcular",{|| DT6DB012()},"Recalculo de comissão", OemToAnsi("Recalcular")})  
//aAdd(aButtons,{"Detalhamento",{|| TWBrowse()},"Detalhamento", OemToAnsi("Detalhamento")})
   
aAdd(aButtons,{"Extrato Rcs",{|| DT6DB012()},"Extrato Excel", OemToAnsi("Extrato RCs")})   
aAdd(aButtons,{"Extrato Supervisor",{|| DT6DB012()},"Extrato Excel", OemToAnsi("Extrato Supervisor")})   //Comissão Supervisor
aAdd(aButtons,{"Extrato Excel",{|| DT6DB012()},"Extrato Excel", OemToAnsi("Extrato Excel")})   //Extrato Excel
aAdd(aButtons,{"Extrato PDF",{|| DT6DB012()},"Extrato PDF", OemToAnsi("Extrato PDF")})   //Extratos PDFs
aAdd(aButtons,{"Marca/Desmarca",{|| TDLCLIK()},"Marca/Desmarca", OemToAnsi("Marca/Desmarca")})   //Inverte a marcação.


ACTIVATE MSDIALOG oDlgEsp Center ON INIT EnchoiceBar(oDlgEsp,{|| fGerTitu()},{|| oDlgEsp:End()},,aButtons)
           
Return 


//-------------------------------------------------------------------
/*/{Protheus.doc} fStructure.
Rotina para atualizar as notas fiscais emitidas com o calculo 
@Author   Davidson-Nutratta
@Since 	   03/12/2019.
@Version 	12.1.17
@param   	n/t
@return  	n/t
@obs.......  
/*/
//-----------------------------------------------------------------------------------------------------------

Static Function fStructure()

Local aAux		:= {}
   
Aadd(aHeader,{"" 				,"ZZA_OK" 	   	,"@BMP"				,02		,00	,	, 	,"C", 	,"V", , , , "V", , , })
Aadd(aHeader,{"Período"			,"PERIODO"		,"@!"		   		,06		,0	,""	,""	,"C",""	,""}) 	                                                                                              
//Aadd(aHeader,{"Data Ini"		,"DATAINI"		,"@!"				,08		,0	,""	,""	,"D",""	,""}) 	
//Aadd(aHeader,{"Data Fim"		,"DATAFIM"		,"@!"				,08		,0	,""	,""	,"D",""	,""})
//Aadd(aHeader,{"Codigo"		,"CODIGO"		,"@!"				,08		,0	,""	,""	,"C",""	,""})
Aadd(aHeader,{"Vendedor"		,"VEND"  		,"@!"				,30		,0	,""	,""	,"C",""	,""})
//Aadd(aHeader,{"Nota"			,"NOTA"  		,"@!"				,09		,0	,""	,""	,"C",""	,""})
Aadd(aHeader,{"Pedido"			,"PEDIDO"  		,"@!"				,06		,0	,""	,""	,"C",""	,""}) 
Aadd(aHeader,{"Emissão"			,"EMISSA"  		,"@!"		   		,08		,0	,""	,""	,"D",""	,""}) 
Aadd(aHeader,{"Baixa"			,"BAIXA"  		,"@!"		   		,08		,0	,""	,""	,"D",""	,""}) 
//Aadd(aHeader,{"Tabela"		,"TABELA"  		,"@!"				,03		,0	,""	,""	,"C",""	,""})
//Aadd(aHeader,{"Cliente"		,"CLIENTE"  	,"@!"				,20		,0	,""	,""	,"C",""	,""})
//Aadd(aHeader,{"Supervisor"	,"SUPERVI"  	,"@!"				,20		,0	,""	,""	,"C",""	,""})
Aadd(aHeader,{"Produto"			,"PRODUTO"  	,"@!"				,30		,0	,""	,""	,"C",""	,""})
//Aadd(aHeader,{"Condição"		,"COND"		  	,"@!"				,03		,0	,""	,""	,"C",""	,""})
Aadd(aHeader,{"Quant"			,"QUANT"  		,"@E 999,999.99"	,12		,2	,""	,""	,"N",""	,""})
Aadd(aHeader,{"Preço"			,"PRCV"  		,"@E 999,999.99"	,12		,2	,""	,""	,"N",""	,""})
Aadd(aHeader,{"Total"			,"TOTAL"  		,"@E 999,999.99"	,12		,2	,""	,""	,"N",""	,""})
Aadd(aHeader,{"Base"			,"BASE"    		,"@E 999,999.99"	,12		,2	,""	,""	,"N",""	,""})
Aadd(aHeader,{"%"		   		,"PERC"  		,"@E 999.99"		,05		,2	,""	,""	,"N",""	,""})                           	
Aadd(aHeader,{"Comissão"   		,"COMISS"  		,"@E 999,999.99"	,12		,2	,""	,""	,"N",""	,""})
Aadd(aHeader,{"Mensagem"   		,"MENSAGEM"  	,"@!"		   		,50   	,0	,""	,""	,"C",""	,""}) 


//--------------------------------------
// Monta o Array aCols Vazio
//--------------------------------------
aAdd(aCols, Array(Len(aHeader)+1))
For nX := 1 To Len(aHeader)
	If	aHeader[nX,8] $ 'C'
		aCols[Len(aCols),nX]:= Space(aHeader[nX,4])
	Else
		aCols[Len(aCols),nX]:= 0
	EndIf
Next nX
aCols[Len(aCols), Len(aHeader)+1] := .F.  
	
	
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} fCalcComiss.
Rotina para realizar o recalculo de comissão.
@Author   Davidson-Nutratta
@Since 	  02/12/2019.
@Version 	12.1.17
@param   	n/t
@return  	
/*/
//-----------------------------------------------------------------------------------------------------------   
Static Function fCalcComiss(_cPeriodo)

Local _cMensagem := ""
Local _cRetormo	 := ""
Local _nOpcao	 := 0		
Local lContinua  := .F.	

//---------------------------------------------------------------------------
// Valida se o período esta aberto para realizar o calculo.
//---------------------------------------------------------------------------
lContinua:= VLDPER(_cPeriodo,2) 


If lContinua	
	
	//---------------------------------------------------------------------------
	// Posiciona na tabela ZZA para verificar se foi apurado o comissionamento.
	//---------------------------------------------------------------------------
	dbSelectArea("ZZA")
	dbSetOrder(2) //ZZA_FILIAL+ZZA_PERIOD
	If dbSeek(xFilial("ZZA")+Alltrim(_cPeriodo))
		
		_nOpcao := Aviso("C  O  M  I  S  S  A  O ","A comissão para o período já foi calculada,Deseja Recalcular ?",{"Recalcular","Sair"},2)
		
		//------------------------------------------------
		// Chama a rotina para recalculo de comissão.
		//------------------------------------------------
		If _nOpcao == 1
			
			//StaticCall( _cRotina,MENUDEF)
			//StaticCall(FINA440,Fa440ProcB)
			//------------------------------------------------
			// Chama a rotina para recalculo de comissão.
			//------------------------------------------------
			FINA440()
		Else
			Return
		EndIf
	Else
		
		_nOpcao := Aviso("C  O  M  I  S  S  A  O ","A comissão para o período não foi calculada,Deseja calcular ?",{"Calcular","Sair"},2)
		
		
		If _nOpcao == 1
			
			//StaticCall( _cRotina,MENUDEF)
			//StaticCall(FINA440,Fa440ProcB)
			//------------------------------------------------
			// Chama a rotina para recalculo de comissão.
			//------------------------------------------------
			FINA440()
		Else
			Return
		EndIf
	EndIf
EndIf	

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} MFATDADOS.
Rotina para carregar os dados.
@Author   Davidson-Nutratta
@Since 	   03/12/2019.
@Version 	12.1.17
@param   	n/t
@return  	_nPerDesc
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function MFATDADOS(_cPeriodo,_dPerIni,_dPerFim,_cGet1)

Local _cQuery		:=	""
Local _cCodCli		:=	"" 
Local cAuxCart		:=	""
Local cAuxCart1		:=	""
Local lRet			:=	.T. 
Local aDados		:=	{} 
Local nValTit		:=	0
Local nValCoPart	:=	0
Local nValRepass	:=	0
Local nValRepaPj	:=	0
Local nSalario		:=	0
Local nVlrFami		:=	0
Local cTxMax  		:=	0 
Local nValTx		:=	0   
Local nxg			:=  0   
Local _nOpcao		:=  0
			
nValSelec			:=	0
nValTotFixo			:=	0
nValTCopart			:=	0
nValTRepass			:=	0
nValRepaJur			:=	0
nValTaxa			:=	0
_nTotGeral			:=	0
nBol				:=	0
nDebito				:=	0
nValTBol			:=	0
nValTDeb			:=	0                  
    

If !Empty(_cPeriodo) .And. Alltrim(_cGet1) $ "LIMPE O CAMPO PARA TRAZER TODOS OS REGISTROS...."//Somente por período de comissão.
	
	_nOpc:= 1

ElseIf Empty(_cPeriodo) .And. Empty(_cGet1)  //Traz todos os registros
	
	_nOpc:= 2
	
ElseIf Empty(_cPeriodo) .And. !Empty(_cGet1) .And. !Alltrim(_cGet1) $ "LIMPE O CAMPO PARA TRAZER TODOS OS REGISTROS...." //Traz por descrição e data 
	
	_nOpc:= 3	

ElseIf !Empty(_cPeriodo) .And. !Alltrim(_cGet1) $ "LIMPE O CAMPO PARA TRAZER TODOS OS REGISTROS...."  //Filtrou por periodo e por descrição 

	_nOpc:= 4

ElseIf Empty(_cPeriodo) .And. Alltrim(_cGet1) $ "LIMPE O CAMPO PARA TRAZER TODOS OS REGISTROS...."  

	 Return
EndIf

_aDados:= fBsucaDados(_cPeriodo,_dPerIni,_dPerFim,_cGet1,_nOpc)
ZZAPesq(_aDados)
	    
Return lRet

  
//-------------------------------------------------------------------
/*/{Protheus.doc} fBsucaDados.
Função para buscar os dados na tabela de comissionamento.
@Author   Davidson-Nutratta
@Since 	   03/12/2019.
@Version 	12.1.17
@param   	n/t
@return  	
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function fBsucaDados(_cPeriodo,_dPerIni,_dPerFim,_cGet1,_nOpc)
	
Local	lRet	:= .T.
Local  _nAux	:= 0 
Local  _nxg		:= 0
Local _nValCom	:= 0
Local _cQuery	:= "" 

_aDados 		:= {}

_nTotGeral 		:= 0
_nValSelec 		:= 0

_cQuery 	:= "	SELECT ZZA_OK,ZZA_PERIOD AS PERIODO,ZZA_DTINI AS DATAINI,ZZA_DTFIM AS DATAFIM,ZZA_VEND AS CODIGO,
_cQuery 	+= "	ZZA_NOME AS VEND,ZZA_NOTA AS NOTA,ZZA_NUM AS PEDIDO ,ZZA_EMISSA AS EMISSA,ZZA_DTBAIX AS BAIXA,ZZA_TABELA AS TABELA,
_cQuery 	+= " 	ZZA_CLIENT AS CLIENTE,ZZA_SUPER AS SUPERVI,ZZA_DESCRI AS PRODUTO,ZZA_COND AS COND,ZZA_QUANT AS QUANT,
_cQuery 	+= "	ZZA_PRCVEN AS PRCV,ZZA_VALOR AS TOTAL,ZZA_BASE AS BASE,ZZA_PERCO AS PERC,ZZA_COMISS AS COMISS,ZZA_TBLZZ AS MENSAGEM"
_cQuery 	+= "	FROM "+RetSqlName("ZZA")+ " ZZA " 


If _nOpc == 1 	//Filtro por periodos fixos de comissão. 	
	                                 
	_cQuery	+= "	WHERE ZZA_PERIOD ='" +(_cPeriodo)+"' 
	

ElseIf _nOpc == 2  .Or.	_nOpc == 3 //Todos os registros 	

	_nAux := _nOpc
	
	If IsDigit(_cGet1) .And. _nOpc == 3  //Caso não contenha numero mostra a tela...
		
		_cQuery += "	WHERE (ZZA_NOME   LIKE '%"+Alltrim(_cGet1)+"%' COLLATE Latin1_general_CI_AI "  //Nome vendedor
		_cQuery += "	OR ZZA_VEND LIKE '%"+Alltrim(_cGet1)+"%' COLLATE Latin1_general_CI_AI "        //Codigo vendedor
		_cQuery += "	OR ZZA_NOTA LIKE '%"+Alltrim(_cGet1)+"%' COLLATE Latin1_general_CI_AI)"	       //Nota fiscal
		
		
	Else
	
		_nOpcao := Aviso("Filtrar Períodos","Escolha a forma de filtro",{"Baixa Titulo","Emissão Pedido"},2)
	
		If _nOpcao == 1 
		
			 //Filtro por data de Emissão Periodo Inicial Emissão e Periodo Emissão                                
		  	_cQuery	+= "	WHERE ZZA_DTBAIX  BETWEEN  '" +Dtos(_dPerIni)+"' AND '"+Dtos(_dPerFim)+"' 	
		
		ElseIf _nOpcao == 2 
			
			//Filtro por data de Emissão Periodo Inicial Baixa e Periodo Final                                
			_cQuery	+= "	WHERE ZZA_EMISSA BETWEEN  '" +Dtos(_dPerIni)+"' AND '"+Dtos(_dPerFim)+"' 	
		EndIf 
		
	 	_cQuery += "	AND (ZZA_NOME   LIKE '%"+Alltrim(_cGet1)+"%' COLLATE Latin1_general_CI_AI "
		_cQuery += "	OR ZZA_VEND LIKE '%"+Alltrim(_cGet1)+"%' COLLATE Latin1_general_CI_AI " 
		_cQuery += "	OR ZZA_NOTA LIKE '%"+Alltrim(_cGet1)+"%' COLLATE Latin1_general_CI_AI)"     
    EndIf
    
ElseIf _nOpc == 4 

		_cQuery	+= "	WHERE ZZA_PERIOD ='" +(_cPeriodo)+"' 
		_cQuery += "	AND (ZZA_NOME   LIKE '%"+Alltrim(_cGet1)+"%' COLLATE Latin1_general_CI_AI "
		_cQuery += "	OR ZZA_VEND LIKE '%"+Alltrim(_cGet1)+"%' COLLATE Latin1_general_CI_AI " 
		_cQuery += "	OR ZZA_NOTA LIKE '%"+Alltrim(_cGet1)+"%' COLLATE Latin1_general_CI_AI)"  
EndIf    
                           
_cQuery  += " 	AND ZZA.D_E_L_E_T_<> '*' "


fCloseArea("ZZAX")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"ZZAX",.T.,.T.)


//-----------------------------------------
// Verifica se a Tabela esta fechada.
//-----------------------------------------
dbSelectArea("ZZAX")
dbGotop()
If Eof()
	
	lRet:=.F.
EndIf

//-----------------------------------------
// Captura os valores da tabela.
//-----------------------------------------
dbSelectArea("ZZAX")
dbGoTop()
While !ZZAX->(Eof())
	
	_nValCom:= ZZAX->COMISS
	AAdd(_aDados,{_nValCom})

	dbSelectArea("ZZAX")
	ZZAX->(dbskip())
EndDo

dbSelectArea("ZZAX")
dbGoTop()

//---------------------------------------------------
// Atualiza aCols com os dados da tabela Total Geral
//---------------------------------------------------
For _nxg:=1 To Len(_aDados)
	
	_nTotGeral+= _aDados[_nxg][1]   
Next _nxg 

//--------------------------------------------------------
// Atualiza aCols com os dados da tabela Vlr.Selecionado
//--------------------------------------------------------
For _nxg:=1 To Len(_aDados)
	
	_nValSelec+= _aDados[_nxg][1]    
Next _nxg 

Return(_aDados)


//-------------------------------------------------------------------
/*/{Protheus.doc} ZZAPesq.
Tela para realização das pesquisas.
@Author   Davidson-Nutratta
@Since 	   03/12/2019
@Version 	12.1.17
@param   	n/t
@return  	n/t
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function ZZAPesq(_aDados)

	MsgRun('Carregando...', '', {|| CursorWait(), _ZZAPesq(_aDados), CursorArrow()}) //'Pesquisando...'

Return Nil  


//-------------------------------------------------------------------
/*/{Protheus.doc} _ZZAPesq.
Tela para realizar as pesquisas.
@Author   Davidson-Nutratta
@Since 	   03/12/2019.
@Version 	12.1.17
@param   	n/t
@return  	n/t
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function _ZZAPesq(_aDados)

Local aAreaAnt   	:= GetArea()
Local cArqTra1
Local lRet			:= .T.
Local lRet	   		:= .F.
Local cQuery   		:= ""
Local cAliasZA1		:= ""
Local cCodCli		:= ""
Local nPos       	:= 0
Local nX			:= 0  
Local nXi			:= 0  
Local aTitulo		:= {}
Local aCampos  		:= {}
aCols				:= {}


dbselectarea("ZZAX")
If !("ZZAX")->(EOF())
	Do While !Eof()
		aAdd(aCols, Array(Len(aHeader)+1))
		
		For nX := 1 To Len(aHeader)
			
			If (nPos:=FieldPos(aHeader[nX,2]))> 0  //FieldPos("NOME")
				
				If	aHeader[nX,8] $'D' //Tratamento para data.
					
					aCols[Len(aCols),nX] := Stod(FieldGet(nPos))
					
				Else
					
					If Trim(aHeader[nX][2]) == "ZZA_OK"
						
						aCols[Len(aCols),nX] :="LBTIK"  //oOk := LoadBitmap( GetResources(), "LBOK" )
						
					Else
						aCols[Len(aCols),nX] := FieldGet(nPos)
					EndIf
					
				EndIf
			EndIf
		Next nX
		aCols[Len(aCols),Len(aHeader)+1] := .F.
		dbSkip()
	EndDo
Else
	aAdd(aCols, Array(Len(aHeader)+1))
	For nX := 1 To Len(aHeader)
		If	aHeader[nX,8] $'C'
			aCols[Len(aCols),nX]:= Space(aHeader[nX,4])
		Else
			aCols[Len(aCols),nX]:= 0
		EndIf
	Next nX
	aCols[Len(aCols), Len(aHeader)+1] := .F.
EndIf



oGetD:oBrowse:Refresh()
RestArea(aAreaAnt)

   
Return Nil 


//-------------------------------------------------------------------
/*/{Protheus.doc} DLCLIK.
Rotina para marcar e desmarcar os itens no acols.
@Author   Davidson-Nutratta
@Since 	   06/12/2019.
@Version 	12.1.17
@param   	n/t
@return  	_nPerDesc
/*/
//--------------------------------------------------------------------
Static Function DLCLIK (nLin,oGetD)          

Local aArea		:= GetArea()
Local cMarca   	:= GetMark()
Local lMarkAll 	:= .T.
Local lInverte 	:= .T.
Local _nXi		:= 0

_nValSelec		:= 0

If "LBNO" $ (aCols[n][1]) //marca 			   

	aCols[n][1]:= "LBTIK"
	
ElseIf "LBTIK" $ (aCols[n][1]) //Descmarca			   	    

	aCols[n][1]:= "LBNO"
EndIf

//---------------------------------------
// Atualiza o valor selecionado.
//---------------------------------------
For _nXi:=1 To Len(aCols)

	If "LBTIK" $ (aCols[_nXi][1])

		_nValSelec += aCols[_nXi][19]

    EndIf
Next

Return



//-------------------------------------------------------------------
/*/{Protheus.doc} TDLCLIK.
Marca e desmarca todos 
@Author   Davidson-Nutratta
@Since 	   06/12/2019.
@Version 	12.1.17
@param   	n/t
@return  	_nPerDesc
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function TDLCLIK ()          
 
Local aArea:= GetArea()
Local lInverte 	:= .T.
Local cMarca   	:= GetMark()
Local lMarkAll 	:= .T.
Local nXi		:= 0

_nValSelec 		:= 0

If "LBNO" $ (aCols[n][1]) //marca
	
	For nXi:=1 To Len(aCols)
		
		aCols[nXi][1]:= "LBTIK"
		
	Next nXi
	
ElseIf "LBTIK" $ (aCols[n][1]) //Descmarca
	
	For nXi:=1 To Len(aCols)
		
		aCols[nXi][1]:= "LBNO"
		
	Next nXi
EndIf

//---------------------------------------
// Atualiza o valor selecionado.
//---------------------------------------
For _nXi:=1 To Len(aCols)
	                                                                            
	If "LBTIK" $ (aCols[_nXi][1])
		
		_nValSelec += aCols[_nXi][19]		
	EndIf
Next

Return




//-------------------------------------------------------------------
/*/Protheus.doc} FechaPer.
 Encerrar período apos recalculo de comissão.
@Author   Davidson-Nutratta
@Since 	   17/12/2019
@Version 	12.1.17
@param   	n/t
@return  	_nVlrTotBx
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function FechaPer() 

Local _nVlrTotBx	:= 0
Local _oTButton
Local _oDlgVen
Local _cStatus
Local lContinua 	:= .F.

_nVlrTotCom := 0

If Empty(_cPeriodo)
	Return
EndIf

lContinua:= VLDPER(_cPeriodo,3) 
If !lContinua
	Return 
EndIf

Define MSDialog _oDlgVen From 000,000 To 60,360 Title OemToAnsi("Informe o valor total baixado pelo Financiero Nutratta") Pixel

@010,002 Say " Total Baixado:" Size 120,08 Pixel Of _oDlgVen
@010,080 MSGet _nVlrTotBx Size 060,08 Pixel Of _oDlgVen PICTURE "@E 999,999,999.99"  VALID _nVlrTotBx > 0 When .T.

_oTButton := TButton():New(010,140,"OK",_oDlgVen,{|| _oDlgVen:End()},30,10,,,.F.,.T.,.F.,,.F.,,,.F.)

Activate MSDialog _oDlgVen Centered


//--------------------------------------------
// Gravar o status de encerramento do período
//--------------------------------------------
dbSelectArea("ZB5")
dbSetOrder(2) //ZB5_FILIAL+ZB5_PERIOD+DTOS(ZB5_DTINI)+DTOS(ZB5_DTFIM)
If dbSeek(xFilial("ZB5")+Alltrim(_cPeriodo))	
	
	If RecLock("ZB5",.F.)
		
		Replace ZB5_TOTCOM 	With _nVlrTotCom 	//Total apurado de comissão
		Replace ZB5_TOTBXF 	With _nVlrTotBx		//Total baixado pelo Financeiro
		Replace ZB5_PERCOM 	With (_nVlrTotCom / _nVlrTotBx)* 100 //% pago de comissão Baixa x Comissão
		Replace ZB5_STATUS 	With '2' 	//Status de fechamento da comissão
		Replace ZB5_RECALC 	With '2'    //Calculado
		MsUnlock()
	EndIf
	
	MsgInfo("Encerramento:    Período Encerrado",""+_CRLF+"Período encerrado com sucesso!!",{"Voltar"},2)
EndIf    

Return  

//-------------------------------------------------------------------
/*/{Protheus.doc} VLDPER
 Encerrar período apos recalculo de comissão.
@Author   Davidson-Nutratta
@Since 	   17/12/2019
@Version 	12.1.17
@param   	n/t
@return  	_nVlrTotBx
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function VLDPER(_cPeriodo,nOpc)  

Local 	lExist 		:= .F.
Local 	lRet		:= .T.

Local	_cRecalc    := ""
Local	_cImprimi   := ""
Local	_cStatus    := ""  
Local	_cEncerra   := ""


//-------------------------------------------
// Verifica se existe o período cadastrado.
//-------------------------------------------
dbSelectArea("ZB5")
dbSetOrder(2) //ZB5_FILIAL+ZB5_PERIOD+DTOS(ZB5_DTINI)+DTOS(ZB5_DTFIM)
If dbSeek(xFilial("ZB5")+_cPeriodo)
	
	_dDataIni	:= ZB5->ZB5_DTINI
	_dDataFim	:= ZB5->ZB5_DTFIM
	_cRecalc    := ZB5->ZB5_RECALC
	_cImprimi   := ZB5->ZB5_IMPRIM
	_cStatus    := ZB5->ZB5_STATUS  
	_cEncerra   := ZB5->ZB5_RECALC
	
	lExist :=.T.
Else
	lExist := .F.	
EndIf

//-------------------------------------------
// Validação normal somente o período
//-------------------------------------------
If nOpc == 1 .And. lExist .And. !Empty(_cPeriodo) 
		
	//-----------------------------------------------------------------------------------
	// Chama a rotina para buscar os dados na tabela de comissão ZZA.
	//-----------------------------------------------------------------------------------
	MFATDADOS(_cPeriodo,_dPerIni,_dPerFim,_cGet1)
	lRet := .T.
	
ElseIf  nOpc == 1 .And. !Empty(_cPeriodo)
	
	Aviso("Atenção:    Período Inválido",""+_CRLF+"Favor Verificar o período informado!!",{"Voltar"},2)
	lRet := .F.	
EndIf

//---------------------------------------------------
// Validação recalculo de comissão
//---------------------------------------------------
If nOpc == 2 .And. _cStatus == '2'	

	Aviso("Atenção:    Período  já  Encerrado.",""+_CRLF+"Período já encerrado!!",{"Voltar"},2)
	lRet:= .F.
EndIf

//------------------------------------------------------
// Validação encerramento - Valida se esta encerrado
//------------------------------------------------------
If nOpc == 3 .And. _cStatus == '2'

	Aviso("Atenção:    Período  já  Encerrado.",""+_CRLF+"Período já encerrado!!",{"Voltar"},2)
	lRet:= .F.
EndIf

Return(lRet)



//-------------------------------------------------------------------
/*/{Protheus.doc} ZB5PER
Consulta períodos.
@Author   Davidson-Nutratta
@Since 	   17/12/2019
@Version 	12.1.17
@param   	n/t
@return  	
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function ZB5PER()   

Local oOK := LoadBitmap(GetResources(),'br_verde')
Local oNO := LoadBitmap(GetResources(),'br_vermelho')  
Local oDlg

DEFINE DIALOG oDlg TITLE "Consulta Períodos Comissionamento" FROM 180,180 TO 550,700 PIXEL	    

oBrowse := TWBrowse():New( 01 , 01, 260,184,,{'','Mes','Ano Compete.','Cod.Período','Data Inicial','Data Final0','Status'},;
											 {20,30,30,20,20,20,20},;                              
oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )    
aBrowse   := {{.T.,'CLIENTE 001','RUA CLIENTE 001','BAIRRO CLIENTE 001'},;                    
              {.F.,'CLIENTE 002','RUA CLIENTE 002','BAIRRO CLIENTE 002'},;                    
              {.T.,'CLIENTE 003','RUA CLIENTE 003','BAIRRO CLIENTE 003'} }    
oBrowse:SetArray(aBrowse)    
oBrowse:bLine := {||{If(aBrowse[oBrowse:nAt,01],oOK,oNO),aBrowse[oBrowse:nAt,02],;                      
aBrowse[oBrowse:nAt,03],aBrowse[oBrowse:nAt,04] } }    

// Troca a imagem no duplo click do mouse    
oBrowse:bLDblClick := {|| aBrowse[oBrowse:nAt][1] := !aBrowse[oBrowse:nAt][1],;                               
oBrowse:DrawSelect()} 
ACTIVATE DIALOG oDlg CENTERED 

Return   






//-------------------------------------------------------------------
/*/{Protheus.doc} fCloseArea.
Tela para conferencia do calculo de descontos.
@Author   Davidson-Nutratta
@Since 	   03/12/2019
@Version 	12.1.17
@param   	n/t
@return  	n/t
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function fCloseArea(pParTabe)
	
If (Select(pParTabe)!= 0)
	dbSelectArea(pParTabe)
	dbCloseArea()
	If File(pParTabe+GetDBExtension())
		FErase(pParTabe+GetDBExtension())
	EndIf
EndIf

Return 