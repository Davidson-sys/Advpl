/*
========================================================================================================================
Rotina----: GFAT002
Autor-----: Gatilho para acertar produto com descrição A
Data------: 10/10/2018
========================================================================================================================
Descrição-: Executado no momento da efetivação do orçamento 
Uso-------:RUNTRIGGER - Execução de gatilhos ( [ nTipo ] [ nLin ] [ cMacro ] [ oObj ] [ cField ] )
========================================================================================================================
*/

User Function GFAT002()  

Local cDesc		  	:= ""
Local cDescPrd	 	:= "" 
Local i			  	:= 0                        


 //GDFieldPut("C6_DESCRI","TESTE",n)
//Padr(GDFieldPut("C6_DESCRI","TESTE",n),TAMSX3("C6_DESCRI"),'TESTE')

//GDFieldPut("C6_DESCRI",Padr(TAMSX3("C6_DESCRI"),'TESTE'),n)
//GDFieldPut(TAMSX3("C6_DESCRI"),"TESTE",n)
//Padr(GDFieldPut("C6_DESCRI","TESTE",n),TAMSX3('C6_DESCRI'),"TESTE1")

//Padr(aCols[n][3],TAMSX3('C6_DESCRI'),'BRASIL') 

//GDFieldPut(Padr("C6_DESCRI",TAMSX3('C6_DESCRI')),'BRASIL'),n)

//GDFieldPut("C6_DESCRI",Padr("C6_DESCRI",TAMSX3('C6_DESCRI'),'BRASIL'),n) 
 
//GDFieldPut(Padr("C6_DESCRI",60,SPACE(60)),"TESTE",n)
                                          
//Padr("C6_DESCRI",TAMSX3('C6_DESCRI'),'') 

//GDFieldPut(TAMSX3("C6_DESCRI"),"TESTE",n)
 

Padr(GDFieldPut("C6_DESCRI","TESTE",n),TAMSX3("C6_DESCRI"),'')
   

Return 

/*
Local nPos		:=aScan(aHeader,{|x| AllTrim(x[2]) == 'C6_PRODUTO'})

For i:=1 To Len(aCols)
	
	Alert(aCols[n][2])   
	Alert(aCols[1][2])
	cDescPrd :=Alltrim(Posicione("SB1",1,xFilial("SB1")+aCols[n][2],"B1_DESC"))
	Alert(cDescPrd)
	GDFieldPut("C6_DESCRI",'A',n)
	Padr(GDFieldPut("C6_DESCRI","TESTE",n),TAMSX3("C6_DESCRI"),'TESTE')
	aCols[n][3]	:= "BRASIL" //cDescPrd   

	RunTrigger(2,n,nil,,GDFieldPut("C6_DESCRI",cDescPrd,n),Len(aCols))

	RunTrigger(2,nLin,nil,,"C6_DESCRI")	
	
	RunTrigger(2,nLin,nil,,'C6_PRODUTO')
	If ExistTrigger('C6_PRODUTO') // verifica se existe trigger para este campo      
		
		RunTrigger(2,N,nil,,'C6_PRODUTO')
	
		GDFieldPos("C6_DESCRI",nil:aHeader) 
		aCols[n][2]
		Endif
	 	
Next i        
*/
