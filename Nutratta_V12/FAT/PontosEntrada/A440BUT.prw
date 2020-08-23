#include 'parmtype.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "COLORS.CH"
#INCLUDE "TOTVS.CH"

//===========================================================================================================
/* Ponto de entrada para criar um botão na tela de liberação de pedido de vendas
@author  	Davidson Carvalho
@version 	P12 12.1.17
@build		
@since 	    12/03/2019
@return
  
//===========================================================================================================
*/

User Function A440BUT ()

Local aButtons:={} 

//-----------------------------------------------------------------------------------
// Só exibi o botão caso esteja logado na filial 0101-Industria e modulo 39
//-----------------------------------------------------------------------------------
If xFilial("SC5")='0101'
	
	If NMODULO == 39
		
//		aButton :={{"POSCLI",{|| fTelaBlq()},"Motiv.Bloq."}} 
//		aButtons :={{"POSCLI",{|| fTelaBlq()},"Frete Real."}} 
		aAdd(aButtons, {"SIMULACA",{||  fTelaBlq()},"Motiv.Bloq"})
		aAdd(aButtons, {"SIMULACA",{||  MFRTREAL()},"Frete Real"})
		
	EndIf
EndIf 
   
Return(aButtons) 
                      


//--------------------------------------------------------------------------
/* {Protheus.doc} Função
Consulta o motivo do bloqueio.
Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 12/03/2019
@version P12 12.1.17
*/
//--------------------------------------------------------------------------

Static Function fTelaBlq()
  
Local dDataEntre	:=	SC5->C5_FECENT
Local dDataVen1		:=	SC5->C5_DATA1
Local dDataVen2		:=	SC5->C5_DATA2
Local dDataVen3		:=	SC5->C5_DATA3
Local dDataVen4		:=	SC5->C5_DATA4
Local dDataVen5		:=	SC5->C5_DATA5
Local dDataVen6		:=	SC5->C5_DATA6
Local dDataVen7		:=	SC5->C5_DATA7
Local dDataVen8		:=	SC5->C5_DATA8
Local dDataVen9		:=	SC5->C5_DATA9
Local cTipFrete		:=	SC5->C5_TPFRETE  
Local cCliente		:=	SC5->C5_CLIENTE
Local cLojaCli		:=	SC5->C5_LOJACLI 
Local cNumPed		:=	SC5->C5_NUM
Local cLocEntreg	:=  SC5->C5_XLOCENT 
Local lBloqTMS		:=  SC5->C5_LIBTMS
Local cNumPed		:=  SC5->C5_NUM 
Local cTitulo		:=	"Motivo de Bloqueio."
Local oOk 	   		:= 	LoadBitmap( GetResources(), "LBOK" )
Local oNo 	   		:= 	LoadBitmap( GetResources(), "LBNO" )
Local _aVariavel	:=  0
Local oDgl
Local oLbx

Private _aDados		:=	{}
Private xButtons  	:= 	{}
Private aFili     	:= 	{}
Private aListBox  	:= 	{}
Private lEstoque  	:= 	.F.
Private aSize	  	:= 	MsAdvSize()
Private cFili  	  	:= 	""
Private cTitulo   	:= 	"Consulta Motivo de bloqueio"
Private oListBox1
	
	
dbSelectArea("SC6") 
dbSetOrder(1)
If dbSeek(xFilial("SC6")+Padr(cNumPed,6))

	_aDados:= U_VldFrt(cNumPed,cCliente,cLojaCli,cLocEntreg,2)
EndIf
  	
//-----------------------------------------------------------------------------------
// Se não houver dados no vetor,avisar usuário e abandonar rotina.
//-----------------------------------------------------------------------------------	
If Len(_aDados)== 0

 Aviso(cTitulo,"Não existe dados a consultar",{"OK"})
 Return
Endif

//-----------------------------------------------------------------------------------
// Monta a tela para usuário visualizar consulta.
//-----------------------------------------------------------------------------------

#IFDEF WINDOWS
@ 005,250 TO 085,1250 DIALOG oEst TITLE "Motivo Bloqueio."

fListBox()
ACTIVATE DIALOG oEst CENTERED
#ENDIF	           


Return


//-----------------------------------------------------------------------------------
// Montagem inicial do ListBox 
//-----------------------------------------------------------------------------------
Static Function fListBox()

@ 000,001 LISTBOX oListBox1 FIELDS ;
HEADER "Pedido","Frete Pedido","Frt Nutratta",;
"Valor Diferença","Codigo","Descrição Tabela","Km Inicial",;
"Km Final","Frete Dentro","Frente Fora","Qtd. Inicial","Qtd Final"; 
Size 500,040 OF oEst PIXEL;
ColSizes 30,55,60,50,30,50,30,30,40,40,30,30;

fLimpaList()

Return Nil

//-----------------------------------------------------------------------------------
// Realiza a limpeza da listagem
//-----------------------------------------------------------------------------------
Static Function fLimpaList()  

oListBox1:SetArray(_aDados) 

oListBox1:bLine := {|| {;
	_aDados[oListBox1:nAt,1],;
	_aDados[oListBox1:nAt,2],;  
	_aDados[oListBox1:nAt,3],; 
	_aDados[oListBox1:nAt,4],;
	_aDados[oListBox1:nAt,5],;	
	_aDados[oListBox1:nAt,6],;    
	_aDados[oListBox1:nAt,7],;
	_aDados[oListBox1:nAt,8],;
	_aDados[oListBox1:nAt,9],;
	_aDados[oListBox1:nAt,10],;  
	_aDados[oListBox1:nAt,11],;
	_aDados[oListBox1:nAt,12]}}

oListBox1:Refresh()

Return



//-------------------------------------------------------------------
/*/{Protheus.doc} MFRTREAL.
Exibe a tela para permitir manutenção do valor do frete realizado.

@Author   Davidson-Nutratta
@Since 	   29/04/2019
@Version 	P11 R5
@param   	n/t
@return  	n/t
@obs.......  
o Especifico Nutratta Nutrição Animal.

xxx......
/*/
//-----------------------------------------------------------------------------------------------------------

Static Function MFRTREAL() 

Local oDlgEsp
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
Local nLimLin			:= 99								//Limite de linhas para a GetDados
Local lAux				:= .F.
Local lVisu				:= .T.
Local lVisu2			:= .T.
Local lRet				:= .T.
Local lGet	 			:= .T.
Local cText				:="A"

Private cGet1  			:= "Digite o Nome, CRM ou o CPF/CNPJ do Titular." + Space(50)
Private cApolice		:=Space(10)
Private cPremio			:=Space(07)
Private dVenc         	:=Date()
Private nSalario		:=GetMV("MV_SALARIO") 
Private cCRM			:=Space(05)
Private cCPF			:=Space(12)
Private lCheck			:=.F. 
Private	nValSelec       :=0
Private	nValTotFixo		:=0
Private	nValTCopart		:=0
Private	nValTRepass		:=0
Private	nValRepaJur		:=0
Private	nValTaxa		:=0
Private	nTotGeral		:=0
Private	nBol			:=0
Private	nDebito			:=0
Private	nValTBol		:=0
Private	nValTDeb		:=0


//Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do segundo campo>+..."
Private oGetD
Private nFreeze      	:= 0                // Campos estaticos na GetDados.
Private nUsado      	:= 0 
Private nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99
Private cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo
Private cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols
Private cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                   
Private aCmpAlter		:= {"SZA1->NOME"}  
 
Private lInverte 		:= .F.
Private cMark   		:= GetMark()   
Private oMark		

SetPrvt("CALIAS,CARQUINDI,cCODFIL")

// Objeto no qual a MsNewGetDados sera criada
Private aCols     		:= {}
Private aHeader  		:= {}
Private nOpc       		:=  GD_INSERT+GD_DELETE+GD_UPDATE //GD_UPDATE 
Private aRotina := {{'','AxPesqui',0,1}, ;
   					{'','AxVisual',0,2}, ;
   					{'','AxInclui',0,3}, ;
   					{'','AxAltera',0,4}, ;
   					{'','AxDeleta',0,5}}

//Função montar a Estrutura        
fStru()  
	
                                          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dimensoes Padrao                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize   := MsAdvSize()
aAdd(aObjects, {100, 020, .T., .F.})
aAdd(aObjects, {100, 100, .T., .T.})
aAdd(aObjects, {100, 100, .T., .T.})
aInfo   := {aSize[1], aSize[2], aSize[3], aSize[4], 5, 5}
aPosObj := MsObjSize(aInfo, aObjects)                                                                                                              

DEFINE MSDIALOG oDlgEsp TITLE OemToAnsi('') FROM  aSize[7],0 To aSize[6],aSize[5] PIXEL /
 
//Group para separa Apolice e Premio.  
TGroup():New(003,006,025,330,"APOLICE",oDlgEsp,CLR_RED,,.T.)
                                                        
//Group para pesquisar atraves do CRM.  
TGroup():New(003,340,025,550,"Pesquisa",oDlgEsp,CLR_BLUE,,.T.) 
 
//Group para separa a pesquisa por CPF.  
//TGroup():New(003,440,025,550,"CPF",oDlgEsp,CLR_RED,,.T.) 

@ aPosObj[1,1]+7,030 SAY "Apolice" SIZE 041, 09 OF oDlgEsp PIXEL //Apolice.
@ aPosObj[1,1]+5,053 MSGET cApolice PICTURE "@E 9999999999"  SIZE 035, 008  OF oDlgEsp PIXEL //Codigo da Apolice.

@ aPosObj[1,1]+7,95 SAY "Prêmio" SIZE 041, 09 OF oDlgEsp PIXEL  //Premio.
@ aPosObj[1,1]+5,115 MSGET cPremio PICTURE "@E 99/9999" WHEN .T. VALID SA1200Doc(cApolice,cPremio,cGet1,lCheck) SIZE 040, 008 OF oDlgEsp PIXEL

@ aPosObj[1,1]+7,165 SAY "Vencimento" SIZE 041, 09 OF oDlgEsp PIXEL  //Data do Vencimento.
@ aPosObj[1,1]+5,198 MSGET dVenc WHEN .T. SIZE 040, 008 OF oDlgEsp PIXEL 
                                                                                          
@ aPosObj[1,1]+7,250 SAY "Vlr.Salário" SIZE 041, 09 OF oDlgEsp PIXEL  //Salario de referencia.
@ aPosObj[1,1]+5,280 MSGET nSalario  PICTURE "@E 999,999.99" WHEN .T. SIZE 040, 008 OF oDlgEsp PIXEL 
                                                                    '
@ aPosObj[1,1]+5,370 MSGET oGet1 VAR cGet1 WHEN lGet  VALID SA1200Doc(cApolice,cPremio,cGet1,lCheck) SIZE 160,008 COLOR CLR_BLACK PICTURE "@!" FONT oFnt PIXEL OF oDlgEsp	

TCheckBox():New(aPosObj[1,1]+7,560,"Juridicos",{|u| if(PCount()>0,lCheck:=u,lCheck)},oDlgEsp,050,010,,,,,,,,.T.,OemToAnsi("CHECK"))
TSay():New(090,130, {|| cText },oDlgEsp,,,,,,.T.,CLR_RED,,300,10)    
                                    	
oGetD := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]+100,aPosObj[2,4],2,nOpc,"AllwaysTrue()","AllwaysTrue()",,aCmpAlter,0, ,cFieldOk,cDelOk,,oDlgEsp)
oGetD:oBrowse:blDblClick := {|| DT6DB01 (oGetD:oBrowse:nAt,@oGetD)} 

@ aPosObj[3,1]+100,010 SAY "VALOR SELECIONADO:" 								SIZE 080, 09 Color CLR_BLUE	OF oDlgEsp PIXEL 
@ aPosObj[3,1]+100,070 SAY 	Alltrim(Transform (nValSelec,"@E 999,999.99")) 	 	SIZE 041, 09 Color CLR_RED 	OF oDlgEsp PIXEL  //Valor Fixo 

@ aPosObj[3,1]+100,100 SAY "BOLETO:"											SIZE 041, 09 Color CLR_GREEN	OF oDlgEsp PIXEL 
@ aPosObj[3,1]+100,123 SAY 	nBol												SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Qtd.Boletos
@ aPosObj[3,1]+100,135 SAY 	Alltrim(Transform (nValTBol,"@E 999,999.99")) 		SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Valor Boletos

@ aPosObj[3,1]+100,170 SAY "DEBITO:"											SIZE 041, 09 Color CLR_GREEN	OF oDlgEsp PIXEL 
@ aPosObj[3,1]+100,190 SAY 	nDebito												SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Qtd.Debitos.
@ aPosObj[3,1]+100,203 SAY 	Alltrim(Transform (nValTDeb,"@E 999,999.99")) 		SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Valor Boletos

@ aPosObj[3,1]+100,235 SAY "TOT. GERAL:"										SIZE 041, 09 Color CLR_BLUE	OF oDlgEsp PIXEL  
@ aPosObj[3,1]+100,270 SAY 	Alltrim(Transform (nValTotFixo,"@E 999,999.99")) 	SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Valor Fixo 
@ aPosObj[3,1]+100,315 SAY 	Alltrim(Transform (nValTCopart,"@E 999,999.99"))	SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Co-participação
@ aPosObj[3,1]+100,355 SAY 	Alltrim(Transform (nValTRepass,"@E 999,999.99"))	SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Repasse fisico
@ aPosObj[3,1]+100,405 SAY 	Alltrim(Transform (nValRepaJur,"@E 999,999.99"))	SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Repasse Juridico 
@ aPosObj[3,1]+100,475 SAY 	Alltrim(Transform (nValTaxa,"@E 999,999.99"))		SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Valor taxas
@ aPosObj[3,1]+100,570 SAY 	Alltrim(Transform (nTotGeral,"@E 999,999.99")) 		SIZE 041, 09 Color CLR_RED	OF oDlgEsp PIXEL  //Total Geral

aButtons := {} 
aAdd(aButtons,{"Detalhamento",{|| DT6DB012()},"Detalhamento", OemToAnsi("Detalhamento")})   //Tela com o detalhe dos dependentes.
aAdd(aButtons,{"Inverter"  ,{|| DT6DB011()},"Inverter", OemToAnsi("Inverter")})   //Inverte a marcação.
	
ACTIVATE MSDIALOG oDlgEsp Center ON INIT EnchoiceBar(oDlgEsp,{|| fGerTitu()},{|| oDlgEsp:End()},,aButtons)


Return()


                          



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fStru    ³Autor ³ Davidson     ³Data³ 01.02.15 		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Montar a estrutura do aHeader e aCols                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fStru()

Local aAux		:= {} 
	
Aadd(aHeader,{"" 				,"C6_OK"   		,"@BMP"			,02	,00	,	, 	,"C", 	,"V", , , , "V", , , })
Aadd(aHeader,{"Pedido"			,"PEDIDO"		,"@!"			,50	,0	,""	,""	,"C",""	,""}) 	                                                                                              
Aadd(aHeader,{"Frete Pedido"	,"FRTPV"		,"@!"			,20	,0	,""	,""	,"C",""	,""}) 	
Aadd(aHeader,{"Frt Nutratta"	,"FRTNUT"		,"@E 999,999.99",14	,2	,""	,""	,"N",""	,""})
Aadd(aHeader,{"Frt Real"		,"FRTREAL"		,"@E 999,999.99",14	,2	,""	,""	,"N",""	,""})
Aadd(aHeader,{"Vlr.Diferença"	,"VLRDIF"		,"@E 999,999.99",14	,2	,""	,""	,"N",""	,""})
Aadd(aHeader,{"Codigo"			,"CODIGO"		,"@E 999,999.99",14	,2	,""	,""	,"N",""	,""})
Aadd(aHeader,{"Descrição Tabela","DESCR"		,"@E 99			",2	,0	,""	,""	,"N",""	,""})
Aadd(aHeader,{"Km Inicial"		,"KMI" 			,"@E 999,999.99",14	,2	,""	,""	,"N",""	,""})
Aadd(aHeader,{"Km Final"		,"KMFIM"		,"@!"			,15	,0	,""	,""	,"C",""	,""})
Aadd(aHeader,{"Frete Dentro"	,"FRTD" 		,"@E 999,999.99",14	,2	,""	,""	,"N",""	,""})
Aadd(aHeader,{"Frete Fora"		,"FRTF" 		,"@E 999,999.99",14	,2	,""	,""	,"N",""	,""})
Aadd(aHeader,{"Qtd.Inicial"		,"QTDINI" 		,"@E 999,999.99",14	,2	,""	,""	,"N",""	,""})  
Aadd(aHeader,{"Qtd.Fim"			,"QTDFIM" 		,"@E 999,999.99",14	,2	,""	,""	,"N",""	,""})  
                                        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Array aCols Vazio                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aCols, Array(Len(aHeader)+1))
For nX := 1 To Len(aHeader)
	If	aHeader[nX,8] $'C'
		aCols[Len(aCols),nX]:= Space(aHeader[nX,4])
	Else
		aCols[Len(aCols),nX]:= 0
	EndIf
Next nX
aCols[Len(aCols), Len(aHeader)+1] := .F.  
	
	
Return                              





          












