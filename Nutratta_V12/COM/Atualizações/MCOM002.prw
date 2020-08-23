#INCLUDE "TOTVS.CH"   
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBTREE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MCOM0002.
Interface de consulta cadastro de produtos	
@Author   Davidson-Nutratta
@Since 	   09/11/2017.
@Version 	P11 R5
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico Nutratta Nutrição Animal.
	CAMPO->C1_PRODUTO
	CONSULTA PADRAO-> B1C1X
xxx......
/*/
//-----------------------------------------------------------------------------------------------------------
User Function MCOM0002()   

	Local cAlias := Alias()
	Local lGet	 := .T.
	Local nOpc	 := 0
	Local oFnt   := TFont():New("MS Sans Serif",,014,,.T.,,,,,.F.,.F.)
	
	Private oDlg1, oGet1, oSay1, oBtn1, oBtn2, oBtn3, oBtn4, oBtn5, oList
	Private aRotAuto := Nil
	
	Private aHead  := {}
	Private aList1 := {}
	Private cEstOp := ""
	Private cGet1  := "Digite ,Codigo ou descrição." + Space(50)
	Private cINOp  := ""
	Private cTpBx  := ""
	Private lFilOp := .T.
	Private lRet   := .F. 
	Private nTamNome := TAMSX3('B1_DESC')[1]
	Private lFilProt := .F. //Adicionado para realização do tratamento da Alteração 1*
		
	SB1->(dbSetOrder(1))
	
	MsgRun("Aguarde...", "Consulta", {|| CursorWait(), CursorArrow()})	
	
	DEFINE MSDIALOG oDlg1 TITLE "Consulta produtos" FROM 000,000 TO 450,800 PIXEL

	//Bloco Dados da Pesquisa
	@ 002,002 TO 040,398 LABEL "Dados da pesquisa" PIXEL OF oDlg1
	@ 012,005 MSGET oGet1 VAR cGet1 WHEN lGet SIZE 322,012 COLOR CLR_BLACK PICTURE "@!" FONT oFnt PIXEL OF oDlg1
	@ 011,332 BUTTON oBtn1 PROMPT "&Pesquisar" ACTION {|| fPesquisa(), oList:SetFocus()} SIZE 060,015 FONT oFnt PIXEL OF oDlg1 WHEN lGet

	//Browse Resultado da Pesquisa
	@ 045,002 TO 260,398 LABEL "Resultado da pesquisa" PIXEL OF oDlg1
	aSize := {30,50,30,20,40,15,130,30,30} 
	aHead := {"Codigo", "Descrição"}
	oList := TWBrowse():New(054,005,389,150,,aHead,aSize,oDlg1,,,,,{|| nOpc:=oList:nAT, oDlg1:End()},,,,,,,.F.,"ARRAY",.T.) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Função para realizar a pesquisa dos contratos               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fPesquisa()

	If !Empty(aList1)
		oList:bLDblClick   := {|| nOpc:=oList:nAT, fChmd1(aList1, oList:nAT)}	//Double Click na linha para confirmar
	   	oList:BHeaderClick := {|o,n| TWBOrd(o,n)}								//Click no Header para ordernar as colunas
	Endif	
	
	oList:SetArray(aList1)                                                            
	oList:bLine := {|o| o:aArray[o:nAT]}     
	oGet1:SetFocus()		

	//Botões
//	@ 207,50  BUTTON oBtn2 PROMPT "&Legenda" 	   		ACTION {|| fLegCNA(aList1, oList:nAT)}	SIZE 060,015 FONT oFnt PIXEL OF oDlg1
	@ 207,125 BUTTON oBtn2 PROMPT "&Visualizar" 		ACTION {|| fVisCli(aList1, oList:nAT)}	SIZE 060,015 FONT oFnt PIXEL OF oDlg1
	@ 207,260 BUTTON oBtn5 PROMPT "C&ancelar"  			ACTION {|| nOpc:=0, oDlg1:End()} 		SIZE 060,015 FONT oFnt PIXEL OF oDlg1 
	@ 207,330 BUTTON oBtn4 PROMPT "&Confirmar" 			ACTION {|| fChmd1(aList1, oList:nAT)}	SIZE 060,015 FONT oFnt PIXEL OF oDlg1
		                                               
	
	ACTIVATE MSDIALOG oDlg1 CENTERED
			              		          
	IIF(Empty(cAlias), Nil, dbSelectArea(cAlias))

Return lRet

                     
//--------------------------------------------------------------------------
/* {Protheus.doc} RunGrid
Query para buscar as informações no contrato.
Empresa - Copyright - Nutratta
@author Davidson Clayton-(Monge)
@since 01/06/2016
@version P11 R8
*/
//--------------------------------------------------------------------------
Static Function RunGrid(cPesq)
	
	Local cAlias := Alias()   
	Local cMsg1  := "" 
	Local nOrd   := 1

	cQry := " SELECT B1_COD,B1_DESC " 
	cQry += " FROM "+RetSqlName("SB1")+" B1 "
	cQry += " WHERE	B1.D_E_L_E_T_<> '*' 	" 
		
	If !("Digite" $ cPesq) .And. Len(Alltrim(cPesq)) > 2
		cQry += "	AND (B1.B1_COD LIKE '%"+cPesq+"%' OR B1.B1_DESC LIKE '%"+cPesq+"%') " 
		If FunName() == "MATA110" .Or. FunName() == "MATA105"
			cQry += " 	AND	B1.B1_TIPO <>'PA'"
		EndIf
	Else
		cQry += "	ORDER BY B1.B1_COD "
	EndIf
    	
	aList1 := {} 

	If Empty(cMsg1)
   		fCloseArea('TMPQRY')
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'TMPQRY', .F., .F.)	
	
		While ! TMPQRY->(Eof())  
		     
	       	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona linhas no Grid                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Aadd(aList1,{TMPQRY->B1_COD,Alltrim(TMPQRY->B1_DESC)})  	
			TMPQRY->(dbSkip())
		End               
	
		TMPQRY->(dbCloseArea())
	
		If Len(aList1) < 1
	
		   	aList1 := {{ ;
		   	        Space(15),;
		   			Space(80)}}	       
	       	
		   oGet1:SetFocus()
	
		ElseIf Len(aList1) > 999
	
		   cMsg1 := "Muitos registros encontrados, informe mais detalhes para a pesquisa"
	
		Endif
	Endif	
		
	If Len(aList1) > 0    
		oList:BHeaderClick := {|o,n| TWBOrd(o,n)} //Click no Header das colunas ordena 
	//    oList:cToolTip:=AllTrim(Transform(Len(aList1),"@E 999,999")+" Registro(s)")
	    
	    If Len(aList1) < 5
	//    	ASORT(aList1,,,{|x,y| x[1] < y[1]}) 
		Else       
	       oList:bLDblClick   := Nil    
	       oList:BHeaderClick := Nil
	       oList:cToolTip 	  := ""
	    Endif 
	    
	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o objeto.                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oList:SetArray(aList1)
	   	oList:bLine := {|o| o:aArray[o:nAT]}
	   	oList:Refresh()
	EndIf

	IIF(Empty(cAlias), Nil, dbSelectArea(cAlias))
    
Return Nil

           
//--------------------------------------------------------------------------
/* {Protheus.doc} TWBOrd
 Ordenação da lista
Empresa - Copyright - Nutratta
@author Davidson Clayton-Nutratta
@since 01/06/2016
@version P11 R8
*/
//--------------------------------------------------------------------------                     
Static Function TWBOrd(o,n)  

	IIF(Empty(o:Cargo), o:Cargo:={0,""}, Nil)
	
	If o:Cargo[2] != o:aHeaders[n] .Or. o:Cargo[1] == 0
		ASORT(o:aArray,,,{|x,y| x[n] < y[n]})
		o:Cargo := {n, o:aHeaders[n]}
	ElseIf o:Cargo[1] == n
		ASORT(o:aArray,,,{|y,x| x[n] < y[n]})
		o:Cargo := {0, o:aHeaders[n]}
	Endif 
	
	o:Refresh()

Return Nil

     
//--------------------------------------------------------------------------
/* {Protheus.doc} fPesquisa
Busca os dados para a montagem da lista 
Empresa - Copyright - Nutratta
@author Davidson Clayton-(Monge)
@since 01/06/2016
@version P11 R8
*/
//--------------------------------------------------------------------------
Static Function fPesquisa(cPesq)

	Local lRet := Len(AllTrim(cGet1)) > 2 .Or. Len(AllTrim(cGet1)) == 0

	If lRet
 		MsgRun("Pesquisando Produtos, Aguarde...", "Consulta", {|| CursorWait(), RunGrid(AllTrim(cGet1)), CursorArrow()})
	Endif		

Return lRet
                                 
          
//--------------------------------------------------------------------------
/* {Protheus.doc} fVisCli
Visualização do cliente posicionado
Empresa - Copyright - Nutratta
@author Davidson Clayton-(Monge)
@since 01/06/2016
@version P11 R8
*/
//--------------------------------------------------------------------------
Static Function fVisCli(aList1, nOpc)

	If SB1->(dbSeek(xFilial("SB1")+aList1[nOpc,1]))	
		Private cCadastro := "Produtos"
		SB1->(A010Visul("SB1",RecNo(),1))
	EndIf
	
Return Nil   

                  
//--------------------------------------------------------------------------
/* {Protheus.doc} fChmd1
Função para retornar os dados da tela.
Empresa - Copyright - Nutratta
@author Davidson Clayton-Nutratta
@since 01/06/2016
@version P11 R8
*/
//--------------------------------------------------------------------------
Static Function fChmd1(aList1,nOpc)

	Local aAlias
     
	If Len(aList1) > 0 .And. nOpc > 0
		dbSelectArea("SB1")
		dbSetOrder(1)//ZA_FILIAL+ZA_CONTRAT+ZA_REVISAO+ZA_CODIGO+ZA_LOJA+ZA_CODINUM+ZA_LJINUM+ZA_TPMEMB                                                                                
	   	lRet :=SB1->(dbSeek(xFilial("SB1")+PadR(aList1[nOpc,1],15)))
	EndIf
    
	
	If lRet	 
		//aCols[n][GDFieldPos("ZI_NUMPED",aHeader)] :=aList1[nOpc,1]
		M->B1_COD	:=PadR(aList1[nOpc,1],15) //CNA->CNA_CONTRA		 
	EndIf

Return IIF(lRet, oDlg1:End(), Nil)
   

//--------------------------------------------------------------------------
/* {Protheus.doc} fCloseArea
Funcao para verificar se existe tabela e exclui-la
Empresa - Copyright - Nutratta
@author Davidson Clayton-(Monge)
@since 01/06/2016
@version P11 R8
*/
//--------------------------------------------------------------------------
Static Function fCloseArea(pParTabe)

	If (Select(pParTabe)!= 0)
		dbSelectArea(pParTabe)
		dbCloseArea()
		If File(pParTabe+GetDBExtension())
			FErase(pParTabe+GetDBExtension())
		EndIf
	EndIf

Return  

