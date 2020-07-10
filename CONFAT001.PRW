#INCLUDE "TOTVS.CH"

/*
+-----------------------------------------------------------------------+
|Programa  | CONFAT001  | Davidson-P2P    | 		Data 23.12.2015 |
|----------|------------------------------------------------------------|
|Descricao | Interface de consulta de pedidos de venda                   |
|----------+------------------------------------------------------------|
| Uso      | Especifico Acol Petroleo	                                |
|-----------------------------------------------------------------------|
|  A l t e r a ç õ e s   S o f r i d a s   a p ó s   a  c r i a ç ã o   |
|-----------------------------------------------------------------------|
|                                                                       |
+-----------------------------------------------------------------------+
*/  

User Function CONFAT001()   
	Local cMensagem:="Aprendendo GITHUB"
	Local cAlias := Alias()
	Local lGet	 := .T.
	Local nOpc	 := 0
	Local oFnt   := TFont():New("MS Sans Serif",,014,,.T.,,,,,.F.,.F.)
	
	Private aRotAuto := Nil
	Private oDlg1, oGet1, oSay1, oBtn1, oBtn2, oBtn3, oBtn4, oBtn5, oList
	
	Private aHead  := {}
	Private aList  := {}
	Private cEstOp := ""
	Private cGet1  := "Digite o Pedido, Nome ou o CPF/CNPJ do Cliente." + Space(50)
	Private cINOp  := ""
	Private cTpBx  := ""
	Private lFilOp := .T.
	Private lRet   := .F. 
	Private nTamNome  := TAMSX3('A1_NOME')[1]
	Private nTamSaldo := TAMSX3('E1_SALDO')[1]
	Private oNO	   := LoadBitmap(GetResources(),'BR_VERMELHO')
	Private oOK	   := LoadBitmap(GetResources(),'BR_VERDE')
	Private oAT	   := LoadBitmap(GetResources(),'BR_BRANCO')
	Private oBL	   := LoadBitmap(GetResources(),'BR_CINZA') 
	
	Private lFilProt := .F. 				//Adicionado para realização do tratamento da Alteração 1*

	SC5->(dbSetOrder(1))
	
	MsgRun("Aguarde...", "Consulta", {|| CursorWait(), CursorArrow()})	
	
	DEFINE MSDIALOG oDlg1 TITLE "Consulta Pedidos" FROM 000,000 TO 450,800 PIXEL
	
	//Cabeçalho
	//@ 000,000 SAY oSay1 PROMPT "<html><p align='center'><br><font face='verdana' size='5' color='#fff'><b>CLIENTES INADIMPLENTES</b></font></p></html>" SIZE 402,025 OF oDlg1 COLORS 16777215, 5126199 HTML PIXEL		
	
	//Bloco Dados da Pesquisa
	@ 002,002 TO 040,398 LABEL "Dados da pesquisa" PIXEL OF oDlg1
	@ 012,005 MSGET oGet1 VAR cGet1 WHEN lGet SIZE 322,012 COLOR CLR_BLACK PICTURE "@!" FONT oFnt PIXEL OF oDlg1
	@ 011,332 BUTTON oBtn1 PROMPT "&Pesquisar" ACTION {|| fPesquisa(), oList:SetFocus()} SIZE 060,015 FONT oFnt PIXEL OF oDlg1 WHEN lGet
	
//	@ 030,005 CHECKBOX oChk1 VAR lFilOp PROMPT "Filtro do Operador" SIZE 080,015 FONT oFnt PIXEL OF oDlg1 ON CHANGE fPesquisa()			//Alterado para realização do tratamento da Alteração 1*
//	@ 030,075 CHECKBOX oChk2 VAR lFilProt PROMPT "Somente Protestados" SIZE 080,015 FONT oFnt PIXEL OF oDlg1 ON CHANGE fPesquisa()		//Adicionado para realização do tratamento da Alteração 1*
	
	//Browse Resultado da Pesquisa
	@ 045,002 TO 260,398 LABEL "Resultado da pesquisa" PIXEL OF oDlg1
	aSize := {30,40,30,15,120,40,80,30} 
//	aSize := {1 ,12,4 ,76,12,50}
	aHead := {"Pedido", "Emissao", "Cliente", "Loja", "Nome", "Produto", "Descrição","Quant"}
	oList := TWBrowse():New(054, 005, 389, 150,,aHead,aSize,oDlg1,,,,,{|| nOpc:=oList:nAT, oDlg1:End()},,,,,,,.F.,"ARRAY",.T.) 
	
//	fOperador()
	fPesquisa()

	If !Empty(aList)
		oList:bLDblClick   := {|| nOpc:=oList:nAT, fChamada(aList, oList:nAT)}	//Double Click na linha para confirmar
	   	oList:BHeaderClick := {|o,n| TWBOrd(o,n)}								//Click no Header para ordernar as colunas
	Endif	
	
	oList:SetArray(aList)                                                            
	oList:bLine := {|o| o:aArray[o:nAT]}     
	oGet1:SetFocus()		

	//Botões
	@ 207,125 BUTTON oBtn2 PROMPT "&Visualizar" 		ACTION {|| fVisCli(aList, oList:nAT)}	SIZE 060,015 FONT oFnt PIXEL OF oDlg1
	@ 207,260 BUTTON oBtn4 PROMPT "&Confirmar" 			ACTION {|| fChamada(aList, oList:nAT)}	SIZE 060,015 FONT oFnt PIXEL OF oDlg1
	@ 207,330 BUTTON oBtn5 PROMPT "C&ancelar"  			ACTION {|| nOpc:=0, oDlg1:End()} 		SIZE 060,015 FONT oFnt PIXEL OF oDlg1 		                                               
	
	ACTIVATE MSDIALOG oDlg1 CENTERED
			              		          
	IIF(Empty(cAlias), Nil, dbSelectArea(cAlias))

Return lRet


Static Function RunGrid(cPesq)
*********************************************
** Busca os dados para a montagem da lista **
*********************************************
	Local cAlias := Alias()   
	Local cMsg1  := "" 
	Local nOrd   := 1

	cQry := " SELECT C5.C5_NUM AS NUM ,Substring(C5.C5_EMISSAO,7,2)+'/'+Substring(C5.C5_EMISSAO,5,2)+'/'+Substring(C5.C5_EMISSAO,1,4) AS EMISSA,C5.C5_CLIENTE AS CLIENTE,C5.C5_LOJACLI AS LOJA,A1.A1_NOME AS NOME,C6.C6_PRODUTO AS PRODUTO,C6.C6_DESCRI AS DESCRI,C6.C6_QTDVEN AS QUANT,C6.C6_NOTA" 
	cQry += " FROM "+RetSqlName("SC5")+" C5 " 
	cQry += " INNER JOIN "+RetSqlName("SA1")+" A1 ON A1.D_E_L_E_T_ <> '*' AND A1.A1_COD = C5.C5_CLIENTE AND A1.A1_LOJA = C5.C5_LOJACLI "
	cQry += " INNER JOIN "+RetSqlName("SC6")+" C6 ON C6.D_E_L_E_T_ <> '*' AND C6.C6_NUM = C5.C5_NUM	AND C6.C6_NOTA='' AND C6.C6_FILIAL= "+xFilial("SF2")+"								  "
	cQry += " WHERE C5.C5_ZORDEM='' AND C5.D_E_L_E_T_ <> '*' AND C5.C5_FILIAL= "+xFilial("SF2")+" 
		
	If !("Digite o" $ cPesq) .And. Len(Alltrim(cPesq)) > 2
		cQry += "AND (C5.C5_NUM LIKE '%"+cPesq+"%' OR A1.A1_NOME LIKE '%"+cPesq+"%' OR A1.A1_CGC LIKE '%"+cPesq+"%') "
	Else
		cQry += "ORDER BY C5.C5_NUM 
	EndIf
    	
	aList := {}

	If Empty(cMsg1)
	
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'TMPQRY', .F., .F.)	
	
		While ! TMPQRY->(Eof())  
		     
	       	//Adiciona linhas no Grid
			Aadd(aList, {Alltrim(TMPQRY->NUM),;  		//Pedido
			   			Alltrim(TMPQRY->EMISSA),; 		//Emissao						              
						Alltrim(TMPQRY->CLIENTE),;  	//Cliente
						Alltrim(TMPQRY->LOJA),;			//Loja  
						Alltrim(TMPQRY->NOME),;  		//Nome
						Alltrim(TMPQRY->PRODUTO),; 		//Produto
						Alltrim(TMPQRY->DESCRI),;		//Descrição 
						Alltrim(Str(TMPQRY->QUANT))})	//Quantidade
	
			TMPQRY->(dbSkip())
				
		End               
	
		TMPQRY->(dbCloseArea())
	
		If Len(aList) < 1
	
		   	aList := {{ ;
		   			Space(1),;
				   	Space(TAMSX3('C5_NUM')[1]+10),;
	   			 	Space(TAMSX3('C5_EMISSAO')[1]+10),;
	   			 	Space(TAMSX3('C5_CLIENTE')[1]+10),;  
	   			 	Space(TAMSX3('C5_LOJACLI')[1]+10),;
	   			 	Space(nTamNome+10)	,;
	   			 	Space(TAMSX3('C5_LOJACLI')[1]);
	   			 }}
	
		   oGet1:SetFocus()
	
		ElseIf Len(aList) > 999
	
		   cMsg1 := "Muitos registros encontrados, informe mais detalhes para a pesquisa"
	
		Endif   
	
	Endif	
		
	If Len(aList) > 0    
		oList:BHeaderClick := {|o,n| TWBOrd(o,n)} 									//Click no Header das colunas ordena 
	//    oList:cToolTip:=AllTrim(Transform(Len(aList),"@E 999,999")+" Registro(s)")
	    
	    If Len(aList) < 5
	//    	ASORT(aList,,,{|x,y| x[1] < y[1]}) 
		Else       
	       oList:bLDblClick   := Nil    
	       oList:BHeaderClick := Nil
	       oList:cToolTip 	  := ""
	    Endif 
	                                          
	    //Atualiza o objeto
		oList:SetArray(aList)
	   	oList:bLine := {|o| o:aArray[o:nAT]}
	   	oList:Refresh()
	EndIf

	IIF(Empty(cAlias), Nil, dbSelectArea(cAlias))
    
Return Nil

                     
Static Function TWBOrd(o,n)  
************************
** Ordenação da lista **
************************

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


Static Function fPesquisa(cPesq)
*********************************************
** Busca os dados para a montagem da lista **
*********************************************
	Local lRet := Len(AllTrim(cGet1)) > 2 .Or. Len(AllTrim(cGet1)) == 0

	If lRet
 		MsgRun("Pesquisando Pedidos, Aguarde...", "Consulta", {|| CursorWait(), RunGrid(AllTrim(cGet1)), CursorArrow()})
	Endif		

Return lRet


                                   

Static Function fVisCli(aList, nOpc)
*****************************************
** Visualização do cliente posicionado **
*****************************************

	If SC5->(dbSeek(xFilial("SC5")+aList[nOpc,1]))
	
		Private cCadastro := "Pedidos"
		A410Visual("SC5",SC5->(Recno()), 2)
		
	EndIf
	
Return Nil  


Static Function fChamada(aList, nOpc)
***************************************************
** Monta a tela com os telefones do cliente para **
** que os operadores possam realizar as ligações **
***************************************************
	Local aAlias
	Local oLbx1
	Local aTel  := {}
	Local cDDD  := ""
	Local nTipo := 1

	If Len(aList) > 0 .And. nOpc > 0
	   lRet := SC5->(dbSeek(xFilial("SC5")+aList[nOpc,1]))
	EndIf

	//Chamada da interface contendo os telefones do cliente
	If lRet
		aCols[n][GDFieldPos("ZI_NUMPED",aHeader)] :=aList[nOpc,1]
	EndIf

Return IIF(lRet, oDlg1:End(), Nil)




