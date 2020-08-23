#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//--------------------------------------------------------------------------
	/* {Protheus.doc} NTFATGAT02
Gatilho para preencher os campos da aba Local de entrega.
após o preenchimento do local de entrega.
  
Campo 		  C5_XLOCENT   
Campo.Domino  C5_XLOCENT
Conteudo	  U_NTFATGT02()  

@return Logico (.T. ou .F.)
*/
//--------------------------------------------------------------------------
User Function NTFATGT02()

Local lRet 	:=.T.
Local cCdigo:=""

//---------------------------------------------------------------------------------------
// Atualiza os campos do local de entrega no pedido de vendas.
//---------------------------------------------------------------------------------------
dbSelectArea("ZZJ")
dbSetOrder(2)
If dbSeek(xFilial("ZZJ")+Padr(M->C5_CLIENTE,8)+Padr(M->C5_XLOCENT,4))  
    
	M->C5_XLOCENT	:= ZZJ->ZZJ_CODIGO 
	M->C5_XNOMFAZ	:= ZZJ->ZZJ_NOMFAZ 
	M->C5_XENDERE	:= ZZJ->ZZJ_ENDERE 	      
	M->C5_XBAIRRO  	:= ZZJ->ZZJ_BAIRRO
	M->C5_XUF		:= ZZJ->ZZJ_UF
	M->C5_XMUNENT	:= ZZJ->ZZJ_MUNICI
	M->C5_XDDD		:= ZZJ->ZZJ_DDD
	M->C5_XTELEFO  	:= ZZJ->ZZJ_TELEFO
	M->C5_XCTTLOC	:= ZZJ->ZZJ_CTTLOC
	M->C5_XROTEIR	:= ZZJ->ZZJ_ROTEIR
	M->C5_XCODGPS	:= ZZJ->ZZJ_CODGPS
	M->C5_XUFCHAP	:= ZZJ->ZZJ_XUFCHA
	M->C5_XCDMUCH	:= ZZJ->ZZJ_XCDMUC
	M->C5_XMUNCHA	:= ZZJ->ZZJ_XMUNCH
	M->C5_XDDDCHA	:= ZZJ->ZZJ_XDDDCH
	M->C5_XTELCHA	:= ZZJ->ZZJ_XTELCH 
	M->C5_XNOMCHA	:= ZZJ->ZZJ_XNOMCHA 
	M->C5_XHRECED	:= ZZJ->ZZJ_HRECDE
	M->C5_XHRECEA	:= ZZJ->ZZJ_HRECA    
	cCdigo			:= ZZJ->ZZJ_CODIGO
	
	//---------------------------------------------------------------------------------------
	// Incios das condicionais.
	//---------------------------------------------------------------------------------------
	
	//Tipo de veiculo
	If ZZJ->ZZJ_XTPVEI $ "1"
		M->C5_XTPVEIC	:= "Truck Graneleiro"                                                                       

	ElseIf ZZJ->ZZJ_XTPVEI $ "2"
		M->C5_XTPVEIC	:= "Truck Silo"

	ElseIf ZZJ->ZZJ_XTPVEI $ "3"
		M->C5_XTPVEIC	:= "Camionete 3/4"	

	ElseIf ZZJ->ZZJ_XTPVEI $ "4"
		M->C5_XTPVEIC	:= "Carreta"	

	EndIf
	    
	//Indicação de chapas
	If ZZJ->ZZJ_XLOCCH $ "1"                                                                  
		M->C5_XLOCCHA	:="Motorista leva/procura"

	ElseIf ZZJ->ZZJ_XLOCCH $ "2" 
		M->C5_XLOCCHA	:="No local de entrega"

	ElseIf ZZJ->ZZJ_XLOCCH $ "3" 
		M->C5_XLOCCHA	:="Tenho indicacao"

	EndIf	
	
	//Dias de recebimento
	If  ZZJ->ZZJ_RECEBI $ "1"                                                                                             
		M->C5_XRECEBI  	:= "SEG A SEX" 

	ElseIf ZZJ->ZZJ_RECEBI $ "2"
		M->C5_XRECEBI  	:= "SEG A SAB"

	ElseIf ZZJ->ZZJ_RECEBI $ "3"	
		M->C5_XRECEBI  	:= "SEG A DOM"	

	EndIf
EndIf

Return(cCdigo)